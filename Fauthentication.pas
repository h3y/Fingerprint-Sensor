﻿unit Fauthentication;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ZKFPEngXControl_TLB, ExtCtrls, OleCtrls, WideStrings;

type
  TForm1 = class(TForm)
    ZKFPEngX1: TZKFPEngX;
    InitDeviceBtn: TButton;
    SensorNum: TEdit;
    PanelStatus: TPanel;
    SensorIndex: TEdit;
    SensorSN: TEdit;
    RegisterBtn: TButton;
    firstName: TEdit;
    Label1: TLabel;
    StatusBar: TListBox;
    procedure InitDeviceBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RegisterBtnClick(Sender: TObject);
    procedure ZKFPEngX1Enroll(ASender: TObject; ActionResult: WordBool;
      ATemplate: OleVariant);
    procedure ZKFPEngX1Capture(ASender: TObject; ActionResult: WordBool;
      ATemplate: OleVariant);
    procedure ZKFPEngX1FeatureInfo(ASender: TObject; AQuality: Integer);
    procedure ZKFPEngX1ImageReceived(ASender: TObject;
      var AImageValid: WordBool);
    procedure SaveToFile(str: WideString);

  private
    fpcHandle: Integer;
    sRegTemplate: WideString;
    sRegTemplate10: WideString;
    FID: Integer;
    strArray  : Array[1..100,1..2] of String;
    keyTemp, nameTemp: WideString;
    const EngineVersion: WideString = '10';
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  DeviceStatus: Boolean = False;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  DeviceStatus := False;
  PanelStatus.Color := clRed;
  fpcHandle := ZKFPEngX1.CreateFPCacheDB;
  FID:=1;
end;



procedure TForm1.FormDestroy(Sender: TObject);
begin
    ZKFPEngX1.FreeFPCacheDB(fpcHandle);
    ZKFPEngX1.EndEngine();
end;

procedure TForm1.InitDeviceBtnClick(Sender: TObject);
var  f: TextFile; // файл
    fName: String; // имя файла
begin
  if ZKFPEngX1.InitEngine = 0 then begin
     ZKFPEngX1.FPEngineVersion := EngineVersion;
     SensorNum.Text := IntToStr(ZKFPEngX1.SensorCount);
     SensorIndex.Text := IntToStr(ZKFPEngX1.SensorIndex);
     SensorSN.Text := ZKFPEngX1.SensorSN;
     PanelStatus.Color := clLime;
     fName:='data.txt';
     AssignFile(f, fName);
     Reset(f);
     While not EOF(f) do // пока не конец файла делать цикл:
     begin
        readLn(f, keyTemp);
        readLn(f, nameTemp);
        strArray[FID,1] :=  keyTemp;
        strArray[FID,2] :=  nameTemp;
        ZKFPEngX1.AddRegTemplateStrToFPCacheDB(fpcHandle, FID, keyTemp);
        Inc(FID); 
     end;
     Flush(f);
      CloseFile(f);
     InitDeviceBtn.Enabled := False;
     RegisterBtn.Enabled := True;
     StatusBar.Items.Add('Init device OK!');
  end;
end;

procedure TForm1.RegisterBtnClick(Sender: TObject);
begin
  if (firstName.Text = '')  then begin
     MessageDlg('Please enter first name ', mtInformation, [mbOK], 0);
     Exit;
  end;
  ZKFPEngX1.CancelEnroll;
  ZKFPEngX1.EnrollCount := 3;
  ZKFPEngX1.BeginEnroll;
  StatusBar.Items.Add('Register start');
end;



procedure TForm1.ZKFPEngX1Capture(ASender: TObject; ActionResult: WordBool; ATemplate: OleVariant);
var
  ID: Integer;
  Score, ProcessNum: Integer;
  j: Integer;
  msg: String;
begin
    StatusBar.Items.Add('Check Register');
     ProcessNum := 0;
     Score := 8;
      ID := ZKFPEngX1.IdentificationInFPCacheDB(fpcHandle, ATemplate, Score, ProcessNum);
    if ID = -1 then
        MessageDlg('Помилка скану відпечатка！Score = ' + IntToStr(Score) + ' Processed Number = ' + IntToStr(ProcessNum), mtInformation, [mbOK], 0)
    else begin
        for j := 1 to Length(strArray) do begin
            if(j = ID) then begin
                msg := 'Identify Succeed! Hello ' + strArray[ID,2] + ' your finger ID = '+ IntToStr(ID) + ' Score = ' + IntToStr(Score) + ' Processed Number = ' + IntToStr(ProcessNum);
                MessageDlg(msg, mtInformation, [mbOK], 0);
                Exit;
            end;
        end;
    end;
end;

procedure TForm1.ZKFPEngX1Enroll(ASender: TObject; ActionResult: WordBool; ATemplate: OleVariant);
var ID: Integer;
    Score, ProcessNum: Integer;
begin
  if (not ActionResult) then
    MessageDlg('Register failed', mtError, [mbOK], 0)
  else begin
    ProcessNum := 0;
    Score := 8;
    ID := ZKFPEngX1.IdentificationInFPCacheDB(fpcHandle, ATemplate, Score, ProcessNum); 
    if(ID > 0) then begin 
    MessageDlg('This finger exist', mtError, [mbOK], 0);
         Exit;
    end;
    //After enroll, you can get 9.0&10.0 template at the same time
    sRegTemplate := ZKFPEngX1.GetTemplateAsStringEx('9');
    sRegTemplate10 := ZKFPEngX1.GetTemplateAsStringEx('10');
    if(Length(sRegTemplate) > 0) then begin

      if(Length(sRegTemplate10) > 0) then
        ZKFPEngX1.AddRegTemplateStrToFPCacheDB(fpcHandle, FID, sRegTemplate10)
      else
        MessageDlg('Register 10.0 failed, template length is zero', mtError, [mbOK], 0);

      SaveToFile(sRegTemplate10);
      strArray[FID,1] :=  sRegTemplate10;
      strArray[FID,2] :=  firstName.Text;
      Inc(FID);
      StatusBar.Items.Add('Register success');
    end else
     MessageDlg('Register Failed, template length is zero', mtError, [mbOK], 0)
  end;
end;

procedure TForm1.ZKFPEngX1FeatureInfo(ASender: TObject; AQuality: Integer);
var
  sTemp: string;
begin
  sTemp := '';
  if ZKFPEngX1.IsRegister then
     sTemp := 'Register Status: still press finger ' + IntToStr(ZKFPEngX1.EnrollIndex) + ' times!';
  sTemp := sTemp + ' Fingerprint quality';
  if AQuality <> 0 then
     sTemp := sTemp + ' not good, quality=' + IntToStr(ZKFPEngX1.LastQuality)
  else
     sTemp := sTemp + ' good, quality=' + IntToStr(ZKFPEngX1.LastQuality);
  StatusBar.Items.Add(sTemp);
end;

procedure TForm1.ZKFPEngX1ImageReceived(ASender: TObject; var AImageValid: WordBool);
begin
  with ZKFPEngX1 do
    PrintImageAt(Self.Canvas.Handle, 500, 10, ImageWidth, ImageHeight);
end;

procedure TForm1.SaveToFile(str:WideString);
var
  f:TextFile;
  FileDir:String;
begin
  FileDir:='data.txt';
  AssignFile(f,FileDir);
  if not FileExists(FileDir) then
  begin
    Rewrite(f);
    CloseFile(f);
  end;
  Append(f);
  Writeln(f,str);
  Writeln(f,firstName.Text);
  Flush(f);
  CloseFile(f);
end;

end.

