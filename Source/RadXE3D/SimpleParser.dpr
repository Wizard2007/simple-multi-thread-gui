program SimpleParser;

uses
  Vcl.Forms,
  fmMain in 'fmMain.pas' {frmMain},
  uWorkThreads in 'uWorkThreads.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
