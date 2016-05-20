program Fingerprint;

uses
  Forms,
  HelloForm in 'HelloForm.pas' {Form2},
  Fauthentication in 'Fauthentication.pas' {Form1},
  ZKFPEngXControl_TLB in 'ZK4500activeX\ZKFPEngXControl_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
