unit fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Samples.Gauges, IniFiles, Vcl.Samples.Spin, System.Actions, Vcl.ActnList,
  Vcl.ToolWin, uWorkThreads;

type
  TfrmMain = class(TForm)
    pgcMain: TPageControl;
    tsGetEngineerList: TTabSheet;
    gGetEngineerUrls: TGauge;
    grpErrorUrlList: TGroupBox;
    edtErrorUrlList: TEdit;
    btnSelectErrorUrlList: TButton;
    grpUrlList: TGroupBox;
    edtUrlList: TEdit;
    btnSelectUrlList: TButton;
    gpbThreadCount: TGroupBox;
    edtTreadCount: TSpinEdit;
    alMain: TActionList;
    tbMain: TToolBar;
    btnGetUrlList: TToolButton;
    aGetUrlList: TAction;
    fodUrlList: TFileOpenDialog;
    fodErrorUrlList: TFileOpenDialog;
    aSelectUrlLsit: TAction;
    aSelectErrorUrlList: TAction;
    grpMaxPageCount: TGroupBox;
    edtMaxPageCount: TSpinEdit;
    grpStep: TGroupBox;
    edtStep: TSpinEdit;
    btnSaveParams: TToolButton;
    aSaveParams: TAction;
    aGetInfo: TAction;
    btnGetInfo: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure aGetUrlListExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure aSelectUrlLsitExecute(Sender: TObject);
    procedure aSelectErrorUrlListExecute(Sender: TObject);
    procedure aSaveParamsExecute(Sender: TObject);
    procedure aGetInfoExecute(Sender: TObject);
  private
    FPathToEngineerUrlErrorList: string;
    FPathToEngineerUrlList: string;
    FIniFile: TIniFile;
    FThreadCount: Integer;
    FMaxPageCount: Integer;
    FStep: Integer;
    procedure SetPathToEngineerUrlErrorList(const Value: string);
    procedure SetPathToEngineerUrlList(const Value: string);
    procedure SetIniFile(const Value: TIniFile);
    procedure SetThreadCount(const Value: Integer);
    procedure SetMaxPageCount(const Value: Integer);
    procedure SetStep(const Value: Integer);
    { Private declarations }
  public
    { Public declarations }
    procedure LoadParams;
    procedure SaveParams;
    procedure FillControls;
    procedure GetValuesFromControls;
    property IniFile: TIniFile read FIniFile write SetIniFile;
    property ThreadCount: Integer read FThreadCount write SetThreadCount;
    property PathToEngineerUrlList: string read FPathToEngineerUrlList
      write SetPathToEngineerUrlList;
    property PathToEngineerUrlErrorList: string read FPathToEngineerUrlErrorList
      write SetPathToEngineerUrlErrorList;
    property MaxPageCount: Integer read FMaxPageCount write SetMaxPageCount;
    property Step: Integer read FStep write SetStep;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.aSaveParamsExecute(Sender: TObject);
begin
  GetValuesFromControls;
  SaveParams;
end;

procedure TfrmMain.aSelectErrorUrlListExecute(Sender: TObject);
begin
  if fodErrorUrlList.Execute then
    edtErrorUrlList.Text:= fodErrorUrlList.FileName;
end;

procedure TfrmMain.aSelectUrlLsitExecute(Sender: TObject);
begin
  if fodUrlList.Execute then
    edtUrlList.Text:= fodUrlList.FileName;
end;

procedure TfrmMain.aGetInfoExecute(Sender: TObject);
var
  lMainGetUrlWorker: TthrdMainGetUrlWorker;
begin
  GetValuesFromControls;
  lMainGetUrlWorker:= TthrdMainGetUrlWorker.Create(True);
  lMainGetUrlWorker.ParseType:= ptGetUrlInfo;
  lMainGetUrlWorker.Gauge:= gGetEngineerUrls;
  lMainGetUrlWorker.PageMin:= 1;
  lMainGetUrlWorker.PageMax:= MaxPageCount;
  lMainGetUrlWorker.PageStep:= edtStep.Value;
  lMainGetUrlWorker.PathToSaveErrorList:= PathToEngineerUrlErrorList;
  lMainGetUrlWorker.PathToSaveUrlList:= PathToEngineerUrlList;
  lMainGetUrlWorker.PageUrlPattern:=
    'http://sample.site/search/scroll?page=';
  lMainGetUrlWorker.PageUrlPatternEngineer:=
    'http://sample.site';
  lMainGetUrlWorker.SearchUrlPattern:=
    'http://sample.site/search/?&text=';
  lMainGetUrlWorker.SearchText:= 'key word';
  lMainGetUrlWorker.ThreadCount:= ThreadCount;
  lMainGetUrlWorker.Init;
  lMainGetUrlWorker.UrlList.LoadFromFile(PathToEngineerUrlList);
  lMainGetUrlWorker.PageMax:= lMainGetUrlWorker.UrlList.Count;
  lMainGetUrlWorker.Init;
  lMainGetUrlWorker.Start;
end;

procedure TfrmMain.aGetUrlListExecute(Sender: TObject);
var
  lMainGetUrlWorker: TthrdMainGetUrlWorker;
  lQueryList: TStringList;
  i: Integer;
begin
  GetValuesFromControls;
  lQueryList:=TStringList.Create;
  try
    lQueryList.StrictDelimiter:= True;
    lQueryList.Delimiter:= ';';
    lQueryList.DelimitedText:= 'key word 1;key word 2;key word 3;key word 4;key word 5;key word 6';
    for i := 0 to lQueryList.Count - 1 do
    begin
      lMainGetUrlWorker:= TthrdMainGetUrlWorker.Create(True);
      lMainGetUrlWorker.ParseType:= ptGetUrls;
      lMainGetUrlWorker.Gauge:= gGetEngineerUrls;
      lMainGetUrlWorker.PageMin:= 1;
      lMainGetUrlWorker.PageMax:= MaxPageCount;
      lMainGetUrlWorker.PageStep:= edtStep.Value;
      lMainGetUrlWorker.PathToSaveErrorList:= PathToEngineerUrlErrorList;
      lMainGetUrlWorker.PathToSaveUrlList:= PathToEngineerUrlList;
      lMainGetUrlWorker.ExcludePageUrlPattern:='help.sample.site';
      lMainGetUrlWorker.PageUrlPattern:=
        '&page=';
      lMainGetUrlWorker.PageUrlPatternEngineer:=
        '';
      lMainGetUrlWorker.SearchUrlPattern:=
        'http://sample.site/search/?q=';
      lMainGetUrlWorker.SearchText:= lQueryList[i];
      lMainGetUrlWorker.ThreadCount:= ThreadCount;
      lMainGetUrlWorker.Init;
      lMainGetUrlWorker.UrlList.LoadFromFile(PathToEngineerUrlList);
      lMainGetUrlWorker.Start;
      while not lMainGetUrlWorker.Finished do
      begin
        Application.ProcessMessages;
        Sleep(5000);
      end;
      FreeAndNil(lMainGetUrlWorker);
    end;
  finally
    FreeAndNil( lQueryList);
  end;
end;

procedure TfrmMain.FillControls;
begin
  edtTreadCount.Value:= ThreadCount;
  edtUrlList.Text:= PathToEngineerUrlList;
  edtErrorUrlList.Text:= PathToEngineerUrlErrorList;
  edtMaxPageCount.Value:= MaxPageCount;
  edtStep.Value:= Step;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GetValuesFromControls;
  SaveParams;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FIniFile:= TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FIniFile);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  LoadParams;
  FillControls;
end;

procedure TfrmMain.GetValuesFromControls;
begin
  ThreadCount:= edtTreadCount.Value;
  PathToEngineerUrlList:= edtUrlList.Text;
  PathToEngineerUrlErrorList:= edtErrorUrlList.Text;
  MaxPageCount:= edtMaxPageCount.Value;
  Step:= edtStep.Value;
end;

procedure TfrmMain.LoadParams;
begin
  with FIniFile do
  begin
    FPathToEngineerUrlList:= ReadString('COMMON', 'PathToEngineerUrlList', '');
    FPathToEngineerUrlErrorList:= ReadString('COMMON'
      , 'PathToEngineerUrlErrorList', '');
    FThreadCount:= ReadInteger('COMMON', 'ThreadCount', 0);
    FMaxPageCount:= ReadInteger('COMMON', 'MaxPageCount', 0);
    FStep:= ReadInteger('COMMON', 'Step', 0);
  end;
end;

procedure TfrmMain.SaveParams;
begin
  with FIniFile do
  begin
    WriteString('COMMON', 'PathToEngineerUrlList', FPathToEngineerUrlList);
    WriteString('COMMON', 'PathToEngineerUrlErrorList'
      , FPathToEngineerUrlErrorList);
    WriteInteger('COMMON', 'ThreadCount', FThreadCount);
    WriteInteger('COMMON', 'MaxPageCount', FMaxPageCount);
    WriteInteger('COMMON', 'Step', FStep);
  end;
end;

procedure TfrmMain.SetIniFile(const Value: TIniFile);
begin
  FIniFile := Value;
end;

procedure TfrmMain.SetMaxPageCount(const Value: Integer);
begin
  FMaxPageCount := Value;
end;

procedure TfrmMain.SetPathToEngineerUrlErrorList(const Value: string);
begin
  FPathToEngineerUrlErrorList := Value;
end;

procedure TfrmMain.SetPathToEngineerUrlList(const Value: string);
begin
  FPathToEngineerUrlList := Value;
end;

procedure TfrmMain.SetStep(const Value: Integer);
begin
  FStep := Value;
end;

procedure TfrmMain.SetThreadCount(const Value: Integer);
begin
  FThreadCount := Value;
end;

end.
