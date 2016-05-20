unit Fauthentication;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ZKFPEngXControl_TLB, ExtCtrls, OleCtrls;

type
  TForm1 = class(TForm)
    ZKFPEngX1: TZKFPEngX;
    InitDeviceBtn: TButton;
    SensorNum: TEdit;
    PanelStatus: TPanel;
    SensorIndex: TEdit;
    SensorSN: TEdit;
    procedure InitDeviceBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fpcHandle: Integer;
    FFingerName: TStringList;
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
    FFingerName := TStringList.Create;
  end;



  procedure TForm1.FormDestroy(Sender: TObject);
  begin
      FFingerName.Free;
      ZKFPEngX1.FreeFPCacheDB(fpcHandle);
      ZKFPEngX1.EndEngine();
  end;

  procedure TForm1.InitDeviceBtnClick(Sender: TObject);
  begin
    if ZKFPEngX1.InitEngine = 0 then begin
       ZKFPEngX1.FPEngineVersion := EngineVersion;
       SensorNum.Text := IntToStr(ZKFPEngX1.SensorCount);
       SensorIndex.Text := IntToStr(ZKFPEngX1.SensorIndex);
       SensorSN.Text := ZKFPEngX1.SensorSN;
       PanelStatus.Color := clLime;
       InitDeviceBtn.Enabled := False;
    end;
  end;

end.

