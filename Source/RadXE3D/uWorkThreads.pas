unit uWorkThreads;

interface

uses System.SysUtils, System.Classes, System.SyncObjs, Vcl.Samples.Gauges,
  Vcl.Forms, IdHTTP, IdSSLOpenSSL, IdSocks, System.RegularExpressions,
  IdCookieManager, IdURI;

type
  TParseTyp = (ptGetUrls, ptGetUrlInfo);
  TGetJob = function (AData: Pointer): Boolean of object;

  TthrdGetUrlWorker = class(TThread)
  private
    FPageMin: Integer;
    FPageMax: Integer;
    FGetJob: TGetJob;
    FMarkFinished: TGetJob;
    FPageUrlPattern: string;
    FPageUrlPatternEngineer: string;
    FUrlList: TStringList;
    FErrorUrlList: TStringList;
    FParseType: TParseTyp;
    FSearchText: string;
    FSearchUrlPattern: string;
    FExcludePageUrlPattern: string;
    procedure SetPageMax(const Value: Integer);
    procedure SetPageMin(const Value: Integer);
    procedure SetGetJob(const Value: TGetJob);
    procedure SetMarkFinished(const Value: TGetJob);
    procedure SetPageUrlPattern(const Value: string);
    procedure SetPageUrlPatternEngineer(const Value: string);
    procedure SetUrlList(const Value: TStringList);
    procedure SetErrorUrlList(const Value: TStringList);
    procedure SetParseType(const Value: TParseTyp);
    procedure SetSearchText(const Value: string);
    procedure SetSearchUrlPattern(const Value: string);
    function Convert(ASourceStr: string): string;
    procedure SetExcludePageUrlPattern(const Value: string);
  protected
    procedure Execute;override;
  public
    FidHTTPMain: TIdHTTP;
    FIdSocksInfoMain: TIdSocksInfo;
    FIdSSLIOHandlerSocketOpenSSLMain: TIdSSLIOHandlerSocketOpenSSL;
    FIdCookieManager: TIdCookieManager;
    FCSVPattern: TStringList;
    destructor Destroy; override;
    procedure Init;
    function ProcessUrls: Boolean;
    function GetUrlInfo:Boolean;
    procedure ClearValues(AList: TStringList);
    procedure PrepareParsingValues;
    property PageUrlPattern: string read FPageUrlPattern write SetPageUrlPattern;
    property PageUrlPatternEngineer: string read FPageUrlPatternEngineer
      write SetPageUrlPatternEngineer;
    property PageMin: Integer read FPageMin write SetPageMin;
    property PageMax: Integer read FPageMax write SetPageMax;
    property GetJob: TGetJob read FGetJob write SetGetJob;
    property MarkFinished: TGetJob read FMarkFinished write SetMarkFinished;
    property UrlList: TStringList read FUrlList write SetUrlList;
    property ErrorUrlList: TStringList read FErrorUrlList write SetErrorUrlList;
    property ParseType: TParseTyp read FParseType write SetParseType;
    property SearchUrlPattern: string read FSearchUrlPattern
      write SetSearchUrlPattern;
    property SearchText: string read FSearchText write SetSearchText;
    property ExcludePageUrlPattern: string
      read FExcludePageUrlPattern
      write SetExcludePageUrlPattern;
  end;

  TthrdMainGetUrlWorker = class(TThread)
  private
    FThreadCount: Integer;
    FThreadLsit: TList;
    FPageMin: Integer;
    FPageMax: Integer;
    FQueueLock: TCriticalSection;
    FPageStep: Integer;
    FCurrentPage: Integer;
    FFinishedThreadCount: Integer;
    FFinishedLock: TCriticalSection;
    FGauge: TGauge;
    FPageUrlPattern: string;
    FPageUrlPatternEngineer: string;
    FUrlList: TStringList;
    FErrorUrlList: TStringList;
    FPathToSaveErrorList: string;
    FPathToSaveUrlList: string;
    FParseType: TParseTyp;
    FHeaderPattern: string;
    FSearchText: string;
    FSearchUrlPattern: string;
    FExcludePageUrlPattern: string;
    procedure SetThreadCount(const Value: Integer);
    procedure SetThreadLsit(const Value: TList);
    procedure SetPageMax(const Value: Integer);
    procedure SetPageMin(const Value: Integer);
    procedure SetQueueLock(const Value: TCriticalSection);
    procedure SetPageStep(const Value: Integer);
    procedure SetCurrentPage(const Value: Integer);
    procedure SetFinishedThreadCount(const Value: Integer);
    procedure SetFinishedLock(const Value: TCriticalSection);
    procedure SetGauge(const Value: TGauge);
    procedure SetPageUrlPattern(const Value: string);
    procedure SetPageUrlPatternEngineer(const Value: string);
    procedure SetUrlList(const Value: TStringList);
    procedure SetErrorUrlList(const Value: TStringList);
    procedure SetPathToSaveErrorList(const Value: string);
    procedure SetPathToSaveUrlList(const Value: string);
    procedure SetParseType(const Value: TParseTyp);
    procedure SetHeaderPattern(const Value: string);
    procedure SetSearchText(const Value: string);
    procedure SetSearchUrlPattern(const Value: string);
    procedure SetExcludePageUrlPattern(const Value: string);
    function MarkFinisged(AData: Pointer): Boolean;
  protected
    procedure Execute;override;
  public
    FIdCookieManager: TIdCookieManager;
    FIdHTTP: TIdHTTP;
    destructor Destroy; override;
    procedure Init;
    procedure PrepareParsingValues;
    function GetJob(AData: Pointer): Boolean;
    function MrkFinisged(AData: Pointer): Boolean;
    procedure SetExcludePageUrlPatternAll;
    procedure SetUrlPatternToAll;
    procedure SetUrlPatternEngineerToAll;
    procedure InitAll;
    procedure SetParseTypeAll;
    procedure StartAll;
    procedure SuspendAll;
    procedure SetCookieManagerAll;
    procedure SetSearchUrlPatternAll;
    procedure SetSearchTextAll;
    procedure PrepareParsingValuesAll;
    procedure ShiftGauge;
    procedure SetGaugeToMax;
    property SearchUrlPattern: string read FSearchUrlPattern
      write SetSearchUrlPattern;
    property SearchText: string read FSearchText write SetSearchText;
    property ExcludePageUrlPattern: string
      read FExcludePageUrlPattern
      write SetExcludePageUrlPattern;
    property PageUrlPatternEngineer: string read FPageUrlPatternEngineer
      write SetPageUrlPatternEngineer;
    property PageUrlPattern: string read FPageUrlPattern write SetPageUrlPattern;
    property ThreadLsit: TList read FThreadLsit write SetThreadLsit;
    property FinishedThreadCount: Integer read FFinishedThreadCount
      write SetFinishedThreadCount;
    property ThreadCount: Integer read FThreadCount write SetThreadCount;
    property CurrentPage: Integer read FCurrentPage write SetCurrentPage;
    property PageMin: Integer read FPageMin write SetPageMin;
    property PageMax: Integer read FPageMax write SetPageMax;
    property PageStep: Integer read FPageStep write SetPageStep;
    property QueueLock: TCriticalSection read FQueueLock write SetQueueLock;
    property FinishedLock: TCriticalSection read FFinishedLock
      write SetFinishedLock;
    property Gauge: TGauge read FGauge write SetGauge;
    property UrlList: TStringList read FUrlList write SetUrlList;
    property ErrorUrlList: TStringList read FErrorUrlList write SetErrorUrlList;
    property PathToSaveErrorList: string read FPathToSaveErrorList
      write SetPathToSaveErrorList;
    property PathToSaveUrlList: string read FPathToSaveUrlList
      write SetPathToSaveUrlList;
    property ParseType: TParseTyp read FParseType write SetParseType;
    property HeaderPattern: string read FHeaderPattern write SetHeaderPattern;
  end;

implementation

{ TMainGetUrlWorker }

destructor TthrdMainGetUrlWorker.Destroy;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  if Assigned(FThreadLsit) then begin
    for i:= 0 to FThreadLsit.Count - 1 do
    begin
      lGetUrlWorker:= FThreadLsit[i];
      FreeAndNil(lGetUrlWorker);
    end;
  end;
  FreeAndNil(FQueueLock);
  FreeAndNil(FFinishedLock);
  FreeAndNil(FUrlList);
  FreeAndNil(FErrorUrlList);
  FreeAndNil(FIdCookieManager);
  FreeAndNil(FIdHTTP);
  inherited;
end;

procedure TthrdMainGetUrlWorker.Execute;
begin
  inherited;
  StartAll;
  case ParseType of
    ptGetUrls: UrlList.Add(HeaderPattern) ;
    ptGetUrlInfo: ;
  end;
  while not Terminated do
  begin
    if (ThreadCount <> FinishedThreadCount) then begin
      Sleep(2000);
      Application.ProcessMessages;
    end
    else begin
      Synchronize(SetGaugeToMax);
      UrlList.SaveToFile(PathToSaveUrlList);
      ErrorUrlList.SaveToFile(PathToSaveErrorList);
      Application.ProcessMessages;
      Terminate;
    end;
  end;
end;

function TthrdMainGetUrlWorker.GetJob(AData: Pointer): Boolean;
var
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  QueueLock.Acquire();
  try
    lGetUrlWorker:= TthrdGetUrlWorker(AData);
    case ParseType of
      ptGetUrls:
        begin
          UrlList.AddStrings(lGetUrlWorker.UrlList);
          lGetUrlWorker.UrlList.Clear;
          ErrorUrlList.AddStrings(lGetUrlWorker.ErrorUrlList);
          lGetUrlWorker.ErrorUrlList.Clear;
        end;
      ptGetUrlInfo:
        begin
          lGetUrlWorker.UrlList:= UrlList;
          lGetUrlWorker.ErrorUrlList:= ErrorUrlList;
        end;
    end;
    if CurrentPage < PageMax then begin
      lGetUrlWorker.PageMin:= CurrentPage;
      CurrentPage:= CurrentPage + PageStep;
      if CurrentPage < PageMax then begin
        lGetUrlWorker.PageMax:= CurrentPage;
      end
      else begin
        lGetUrlWorker.PageMax:= PageMax;
        CurrentPage:= PageMax;
      end;
      Synchronize(ShiftGauge);
      inc(FCurrentPage);
      Result:= True;
    end
    else
      Result:= false;
  finally
    QueueLock.Release
  end;
end;

procedure TthrdMainGetUrlWorker.Init;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin

  if not Assigned(FQueueLock) then begin
    FQueueLock:= TCriticalSection.Create;
  end;
  if not Assigned(FFinishedLock) then begin
    FFinishedLock:= TCriticalSection.Create;
  end;
  if not Assigned(FUrlList) then begin
    FUrlList:= TStringList.Create;
  end;
  if not Assigned(FErrorUrlList) then begin
    FErrorUrlList:= TStringList.Create;
  end;
  if not Assigned(FIdCookieManager) then
    FIdCookieManager:= TIdCookieManager.Create(nil);
  if not Assigned(FIdHTTP) then
    FIdHTTP:= TIdHTTP.Create(nil);
  FIdHTTP.AllowCookies:= True;
  FIdHTTP.HandleRedirects:= True;
  FIdHTTP.CookieManager:= FIdCookieManager;
  CurrentPage:= PageMin;
  FFinishedThreadCount:= 0;
  if not Assigned(FThreadLsit) then begin
    FThreadLsit:= TList.Create;
    for i:= 1 to ThreadCount do
    begin
      lGetUrlWorker:= TthrdGetUrlWorker.Create(True);
      lGetUrlWorker.GetJob:= GetJob;
      lGetUrlWorker.MarkFinished:= MarkFinisged;
      FThreadLsit.Add(lGetUrlWorker);
    end;
  end;
  if Assigned(FGauge) then begin
    FGauge.MinValue:= PageMin;
    FGauge.MaxValue:= PageMax + 2;
    FGauge.Progress:= PageMin;
  end;
  InitAll;
  SetUrlPatternToAll;
  SetUrlPatternEngineerToAll;
  SetParseTypeAll;
  SetSearchUrlPatternAll;
  SetSearchTextAll;
  SetExcludePageUrlPatternAll;
  PrepareParsingValuesAll;
  HeaderPattern:= ';;;;';
end;

procedure TthrdMainGetUrlWorker.InitAll;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  for i:= 0 to FThreadLsit.Count - 1 do
  begin
    lGetUrlWorker:= FThreadLsit[i];
    lGetUrlWorker.Init;
  end;
end;

function TthrdMainGetUrlWorker.MarkFinisged(AData: Pointer): Boolean;
var
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  FinishedLock.Acquire();
  try
    lGetUrlWorker:= TthrdGetUrlWorker(AData);
    Inc(FFinishedThreadCount);
    Result:= True;
  finally
    FinishedLock.Release
  end;
end;

function TthrdMainGetUrlWorker.MrkFinisged(AData: Pointer): Boolean;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  for i:= 0 to FThreadLsit.Count - 1 do
  begin
    lGetUrlWorker:= FThreadLsit[i];
    lGetUrlWorker.ExcludePageUrlPattern:= ExcludePageUrlPattern;
  end;
end;

procedure TthrdMainGetUrlWorker.PrepareParsingValues;
begin
  FIdHTTP.Get(SearchUrlPattern+SearchText);
end;

procedure TthrdMainGetUrlWorker.PrepareParsingValuesAll;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  for i:= 0 to FThreadLsit.Count - 1 do
  begin
    lGetUrlWorker:= FThreadLsit[i];
    lGetUrlWorker.PrepareParsingValues;
  end;
end;

procedure TthrdMainGetUrlWorker.SuspendAll;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  for i:= 0 to FThreadLsit.Count - 1 do
  begin
    lGetUrlWorker:= FThreadLsit[i];
    lGetUrlWorker.Suspend;
  end;
end;

procedure TthrdMainGetUrlWorker.SetCookieManagerAll;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  for i:= 0 to FThreadLsit.Count - 1 do
  begin
    lGetUrlWorker:= FThreadLsit[i];
    lGetUrlWorker.FIdCookieManager:= FIdCookieManager;
    lGetUrlWorker.FidHTTPMain.CookieManager:= FIdCookieManager;
  end;
end;


procedure TthrdMainGetUrlWorker.SetCurrentPage(const Value: Integer);
begin
  FCurrentPage := Value;
end;

procedure TthrdMainGetUrlWorker.SetErrorUrlList(const Value: TStringList);
begin
  FErrorUrlList := Value;
end;

procedure TthrdMainGetUrlWorker.SetExcludePageUrlPattern(
  const Value: string);
begin
  FExcludePageUrlPattern := Value;
end;

procedure TthrdMainGetUrlWorker.SetExcludePageUrlPatternAll;
begin

end;

procedure TthrdMainGetUrlWorker.SetFinishedLock(const Value: TCriticalSection);
begin
  FFinishedLock := Value;
end;

procedure TthrdMainGetUrlWorker.SetFinishedThreadCount(const Value: Integer);
begin
  FFinishedThreadCount := Value;
end;

procedure TthrdMainGetUrlWorker.SetGauge(const Value: TGauge);
begin
  FGauge := Value;
end;

procedure TthrdMainGetUrlWorker.SetGaugeToMax;
begin
  FGauge.Progress:= FGauge.MaxValue;
  UrlList.SaveToFile(PathToSaveUrlList);
  ErrorUrlList.SaveToFile(PathToSaveErrorList);
end;

procedure TthrdMainGetUrlWorker.SetHeaderPattern(const Value: string);
begin
  FHeaderPattern := Value;
end;

procedure TthrdMainGetUrlWorker.SetPageMax(const Value: Integer);
begin
  FPageMax := Value;
end;

procedure TthrdMainGetUrlWorker.SetPageMin(const Value: Integer);
begin
  FPageMin := Value;
end;

procedure TthrdMainGetUrlWorker.SetPageStep(const Value: Integer);
begin
  FPageStep := Value;
end;

procedure TthrdMainGetUrlWorker.SetPageUrlPattern(const Value: string);
begin
  FPageUrlPattern := Value;
end;

procedure TthrdMainGetUrlWorker.SetPageUrlPatternEngineer(const Value: string);
begin
  FPageUrlPatternEngineer := Value;
end;

procedure TthrdMainGetUrlWorker.SetParseType(const Value: TParseTyp);
begin
  FParseType := Value;
end;

procedure TthrdMainGetUrlWorker.SetParseTypeAll;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  for i:= 0 to FThreadLsit.Count - 1 do
  begin
    lGetUrlWorker:= FThreadLsit[i];
    lGetUrlWorker.ParseType:= ParseType;
  end;
end;

procedure TthrdMainGetUrlWorker.SetPathToSaveErrorList(const Value: string);
begin
  FPathToSaveErrorList := Value;
end;

procedure TthrdMainGetUrlWorker.SetPathToSaveUrlList(const Value: string);
begin
  FPathToSaveUrlList := Value;
end;

procedure TthrdMainGetUrlWorker.SetQueueLock(const Value: TCriticalSection);
begin
  FQueueLock := Value;
end;

procedure TthrdMainGetUrlWorker.SetSearchText(const Value: string);
begin
  FSearchText := Value;
end;

procedure TthrdMainGetUrlWorker.SetSearchTextAll;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  for i:= 0 to FThreadLsit.Count - 1 do
  begin
    lGetUrlWorker:= FThreadLsit[i];
    lGetUrlWorker.SearchUrlPattern:= SearchUrlPattern;
  end;
end;

procedure TthrdMainGetUrlWorker.SetSearchUrlPattern(const Value: string);
begin
  FSearchUrlPattern := Value;
end;

procedure TthrdMainGetUrlWorker.SetSearchUrlPatternAll;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  for i:= 0 to FThreadLsit.Count - 1 do
  begin
    lGetUrlWorker:= FThreadLsit[i];
    lGetUrlWorker.SearchText:= SearchText;
  end;
end;
procedure TthrdMainGetUrlWorker.SetThreadCount(const Value: Integer);
begin
  FThreadCount := Value;
end;

procedure TthrdMainGetUrlWorker.SetThreadLsit(const Value: TList);
begin
  FThreadLsit := Value;
end;

procedure TthrdMainGetUrlWorker.SetUrlList(const Value: TStringList);
begin
  FUrlList := Value;
end;

procedure TthrdMainGetUrlWorker.SetUrlPatternEngineerToAll;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  for i:= 0 to FThreadLsit.Count - 1 do
  begin
    lGetUrlWorker:= FThreadLsit[i];
    lGetUrlWorker.PageUrlPatternEngineer:= PageUrlPatternEngineer;
  end;
end;

procedure TthrdMainGetUrlWorker.SetUrlPatternToAll;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  for i:= 0 to FThreadLsit.Count - 1 do
  begin
    lGetUrlWorker:= FThreadLsit[i];
    lGetUrlWorker.PageUrlPattern:= PageUrlPattern;
  end;
end;

procedure TthrdMainGetUrlWorker.ShiftGauge;
begin
  FGauge.Progress:= CurrentPage;
end;

procedure TthrdMainGetUrlWorker.StartAll;
var
  i: Integer;
  lGetUrlWorker: TthrdGetUrlWorker;
begin
  for i:= 0 to FThreadLsit.Count - 1 do
  begin
    lGetUrlWorker:= FThreadLsit[i];
    lGetUrlWorker.Start;
  end;
end;

{ TthrdGetUrlWorker }

procedure TthrdGetUrlWorker.ClearValues(AList: TStringList);
var
  i: Integer;
begin

end;

destructor TthrdGetUrlWorker.Destroy;
begin
  FreeAndNil(FErrorUrlList);
  FreeAndNil(FidHTTPMain);
  FreeAndNil(FIdSocksInfoMain);
  FreeAndNil(FIdSSLIOHandlerSocketOpenSSLMain);
  FreeAndNil(FCSVPattern);
  inherited;
end;

procedure TthrdGetUrlWorker.Execute;
begin
  inherited;
  while not Terminated do
  begin
    if Assigned(FGetJob) then begin
      while GetJob(Self) do
      begin
        case ParseType of
          ptGetUrls: ProcessUrls;
          ptGetUrlInfo: GetUrlInfo;
        end;
        Sleep(2000);
      end;
      if Assigned(MarkFinished) then begin
        MarkFinished(Self);
        Terminate;
      end;
    end
    else
      Terminate;
  end;
end;

procedure TthrdGetUrlWorker.Init;
begin
  if not  Assigned(FCSVPattern) then
    FCSVPattern:= TStringList.Create;
  if not Assigned(FidHTTPMain) then
    FidHTTPMain:= TIdHTTP.Create(nil);
  if not Assigned(FIdSocksInfoMain) then
    FIdSocksInfoMain:= TIdSocksInfo.Create(nil);
  if not Assigned(FIdSSLIOHandlerSocketOpenSSLMain) then
    FIdSSLIOHandlerSocketOpenSSLMain:= TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  if not Assigned(FUrlList) then
    FUrlList:= TStringList.Create;
  if not Assigned(FErrorUrlList) then
    FErrorUrlList:= TStringList.Create;
  if not Assigned(FIdCookieManager) then
    FIdCookieManager:= TIdCookieManager.Create(nil);

  FCSVPattern.StrictDelimiter:= True;
  FCSVPattern.Delimiter:= ';';

  FCSVPattern.DelimitedText:= ';;;;;;;;;;;';


  FIdSSLIOHandlerSocketOpenSSLMain.TransparentProxy:= FIdSocksInfoMain;
  FidHTTPMain.IOHandler:= FIdSSLIOHandlerSocketOpenSSLMain;
  FidHTTPMain.AllowCookies:= True;
  FidHTTPMain.HandleRedirects:= True;
  FidHTTPMain.CookieManager:= FIdCookieManager;
end;

procedure TthrdGetUrlWorker.PrepareParsingValues;
var
  lurl: string;
begin
  lurl:= SearchUrlPattern + SearchText;
  lurl:= UTF8ToString(TIdURI.URLEncode(UTF8Encode(lurl)));
  FidHTTPMain.Get(lurl);
end;

function TthrdGetUrlWorker.Convert(ASourceStr: string): string;
begin
  Result:= ASourceStr;
  Result := stringreplace(Result, '&#x44E;', 'þ', [rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x43F;', 'ï',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x42E;', 'Þ',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x41F;', 'Ï',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x430;', 'à',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x44F;', 'ÿ',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x410;', 'À',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x42F;', 'ß',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x431;', 'á',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x440;', 'ð',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x411;', 'Á',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x420;', 'Ð',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x451;', '¸',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x401;', '¨',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x446;', 'ö',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x441;', 'ñ',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x426;', 'Ö',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x421;', 'Ñ',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x434;', 'ä',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x442;', 'ò',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x414;', 'Ä',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x422;', 'Ò',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x435;', 'å',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x443;', 'ó',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x415;', 'Å',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x423;', 'Ó',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x444;', 'ô',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x436;', 'æ',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x424;', 'Ô',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x416;', 'Æ',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x433;', 'ã',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x432;', 'â',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x413;', 'Ã',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x412;', 'Â',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x445;', 'õ',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x44C;', 'ü',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x425;', 'Õ',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x42C;', 'Ü',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x438;', 'è',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x44B;', 'û',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x418;', 'È',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x42B;', 'Û',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#xA0;', '',[rfReplaceAll, rfIgnoreCase]);

  Result := stringreplace(Result, '&#x28;', '(',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x29;', ')',[rfReplaceAll, rfIgnoreCase]);

  Result := stringreplace(Result, '&#x457;', '¿',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x407;', '¯',[rfReplaceAll, rfIgnoreCase]);

  Result := stringreplace(Result, '&#x456;', '³',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x406;', '²',[rfReplaceAll, rfIgnoreCase]);

  Result := stringreplace(Result, '&#x454;', 'º',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x404;', 'ª',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x27;', '''',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x2b;', '+',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x2116;', '¹',[rfReplaceAll, rfIgnoreCase]);



  Result := stringreplace(Result, '&#x439;', 'é',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x437;', 'ç',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x419;', 'É',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x417;', 'Ç',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x43A;', 'ê',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x448;', 'ø',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x41A;', 'Ê',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x428;', 'Ø',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#xB0;', '°',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x43B;', 'ë',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x44D;', 'ý',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x41B;', 'Ë',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x42D;', 'Ý',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x43C;', 'ì',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x449;', 'ù',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x41C;', 'Ì',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x429;', 'Ù',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#xB7;', '·',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x43D;', 'í',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x447;', '÷',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x41D;', 'Í',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x427;', '×',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#xA9;', '©',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x43E;', 'î',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x44A;', 'ú',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x41E;', 'Î',[rfReplaceAll, rfIgnoreCase]);
  Result := stringreplace(Result, '&#x42A;', 'Ú',[rfReplaceAll, rfIgnoreCase]);
end;

function TthrdGetUrlWorker.GetUrlInfo: Boolean;
var
  i, j, k, lCount, lIndex, lAdressShift: Integer;
  lStringList, lPropList: TStringList;
  lText, lPattern, lUrlEngineer, lStr_1, lStr_2, lStr_3, lStr_4, lStr_5: string;
  lMatchCollection: TMatchCollection;
  lMatch: TMatch;
  lStrArray: TArray<string>;
begin
   {
   }

  Result:= False;
  for i := PageMin to PageMax do
  begin
    lStringList:= TStringList.Create;
    lPropList:= TStringList.Create;
    try
      try
        FCSVPattern.DelimitedText:= UrlList[i];
        lUrlEngineer:= FCSVPattern[FCSVPattern.Count - 1];
        lUrlEngineer:= UTF8ToString(TIdURI.URLEncode(UTF8Encode(lUrlEngineer)));
        lText:= FidHTTPMain.Get(lUrlEngineer);
        lText:= TRegEx.Replace(lText, '[\t\r]','');
        lText:= TRegEx.Replace(lText, '&quot;','"');
        lText:= TRegEx.Replace(lText, '&nbsp;',' ');
        lStringList.Text:= lText;
        lStringList.SaveToFile(IntToStr(i)+'.html');
        // Name
        lPattern:= '<h1 itemprop="name">(.*)<span class="b-company--item_shevron">';

        lMatchCollection:= TRegEx.Matches(lText, lPattern);

        if lMatchCollection.Count > 0 then begin
          FCSVPattern[0]:= convert(Trim(TRegEx.Replace(lMatchCollection.Item[0].Value
            , '<([^<>]+)>','')));
        end
        else begin
          FCSVPattern[0]:= '';
        end;
        // About
        lPattern:= '<div class="p-eparticle--description js-ent-description" itemprop="description">(.*)<div class="b-box">';

        lMatchCollection:= TRegEx.Matches(lText, lPattern);

        if lMatchCollection.Count > 0 then begin
          lStr_1:= convert(Trim(TRegEx.Replace(lMatchCollection.Item[0].Value
            , '<([^<>]+)>|\r|\n','')));
          while Pos('  ', lStr_1) > 0 do
            lStr_1:= StringReplace(lStr_1, '  ', ' ', [rfReplaceAll, rfIgnoreCase]);
          FCSVPattern[1]:= lStr_1;
        end
        else begin
          FCSVPattern[1]:= '';
        end;

        // CommonInfo
        lPattern:= '<td class="b-about-additional-info__data">(.*)</td>';

        lMatchCollection:= TRegEx.Matches(lText, lPattern);

        if lMatchCollection.Count > 0 then begin
          lStr_1:= convert(Trim(TRegEx.Replace(lMatchCollection.Item[0].Value
            , '<([^<>]+)>|\n|\r','')));
          while Pos('  ', lStr_1) > 0 do
            lStr_1:= StringReplace(lStr_1, '  ', ' ', [rfReplaceAll, rfIgnoreCase]);
          FCSVPattern[2]:= lStr_1;
        end
        else begin
          FCSVPattern[2]:= '';
        end;

        // Adress
        lPattern:= '(<div itemprop="addressLocality" class="b-pli-alliance__country">(.*)<span class="b-pli-alliance__clock)|(<samp class="b-enterprise--view-info__showonmap">(.*))</samp></samp>)';

        lMatchCollection:= TRegEx.Matches(lText, lPattern);

        if lMatchCollection.Count > 0 then begin
          lStrArray:= TRegEx.Split(lMatchCollection.Item[0].Value, '<br />|<br/>');
          lStr_1:= convert(Trim(TRegEx.Replace(lMatchCollection.Item[0].Value
            , '<([^<>]+)>|\n|\r','')));
          while Pos('  ', lStr_1) > 0 do
            lStr_1:= StringReplace(lStr_1, '  ', ' ', [rfReplaceAll, rfIgnoreCase]);
          FCSVPattern[3]:= lStr_1;
        end
        else begin
          FCSVPattern[3]:= '';
        end;
        for k:= 0 to Length(lStrArray) -1 do
        begin
          lStrArray[k]:= convert(Trim(TRegEx.Replace(lStrArray[k], '<([^<>]+)>|\n|\r','')));
        end;

        // Country
        if (length(lStrArray) - 1) >= 0 then begin
          FCSVPattern[4]:= convert(Trim(lStrArray[length(lStrArray) - 1]));
        end
        else begin
          FCSVPattern[4]:= '';
        end;
        // index
        if (length(lStrArray) - 2) >= 0 then begin
          FCSVPattern[5]:= convert(Trim(lStrArray[length(lStrArray) - 2]));
        end
        else begin
          FCSVPattern[5]:= '';
        end;
        // Region
        if (length(lStrArray) - 3) >= 0 then begin
          FCSVPattern[6]:= convert(Trim(lStrArray[length(lStrArray) - 3]));
        end
        else begin
          FCSVPattern[6]:= '';
        end;
        // City
        if (length(lStrArray) - 3) >= 0 then begin
          FCSVPattern[7]:= convert(Trim(lStrArray[length(lStrArray) - 3]));
        end
        else begin
          FCSVPattern[7]:= '';
        end;
        // location
        if (length(lStrArray) - 4) >= 0 then begin
          FCSVPattern[8]:= convert(Trim(lStrArray[length(lStrArray) - 4]));
        end
        else begin
          FCSVPattern[8]:= '';
        end;
        //Phone, Phone1
        lPattern:= '<span class="_number" itemprop="telephone">([a-zA-Z0-9,\+ ()]*)</span>';

        lMatchCollection:= TRegEx.Matches(lText, lPattern);

        if lMatchCollection.Count > 0 then begin
          FCSVPattern[FCSVPattern.Count - 2]:= Trim(TRegEx.Replace(lMatchCollection.Item[0].Value
            , '<([^<>]+)>',''));

          lStr_1:= FCSVPattern[FCSVPattern.Count - 2];
          lStr_1[13]:= 'X';
          lStr_1[14]:= 'X';
          lStr_1[15]:= 'X';
          FCSVPattern[FCSVPattern.Count - 3]:= lStr_1;
        end
        else begin
          FCSVPattern[FCSVPattern.Count - 2]:= '';
          FCSVPattern[FCSVPattern.Count - 3]:= '';
        end;

        // Url
        FCSVPattern[FCSVPattern.Count - 1]:= lUrlEngineer;
        FCSVPattern.StrictDelimiter:= True;
        FCSVPattern.Delimiter:= ';';

        UrlList[i]:=FCSVPattern.DelimitedText;
        Result:= True;
      except on e: Exception do
        begin
          ErrorUrlList.Add(FCSVPattern.Text);
        end;
      end;
    finally
      FreeAndNil(lStringList);
      FreeAndNil(lPropList);
    end;
  end;
end;


function TthrdGetUrlWorker.ProcessUrls: Boolean;
var
  i, j: Integer;
  lStrI, lText, lPattern, lUrl, lUrlEngineer, lCSVText: string;
  lMatchCollection: TMatchCollection;
  lMatch: TMatch;
  lStringList: TStringList;
begin
  Result:= False;
  lStringList:= TStringList.Create;
  try
    for i := PageMin to PageMax do
    begin
      try
        lStrI:= IntToStr(i);
        lUrl:= UTF8ToString(TIdURI.URLEncode(SearchUrlPattern+SearchText+PageUrlPattern+IntToStr(i)));
        lText:= FidHTTPMain.Get(lUrl);

        lText:= TRegEx.Replace(lText, '[\t]','');
        lText:= TRegEx.Replace(lText, '[\r]','');
        lText:= TRegEx.Replace(lText, '&quot;','"');
        lText:= TRegEx.Replace(lText, '&nbsp;',' ');
        lStringList.Text:= lText;
        //lStringList.SaveToFile(IntToStr(i)+'.html');
        lPattern:= 'http://([a-zA-Z]*).all.biz/([a-zA-Z\-]*)-([a-zA-Z]+)([0-9]+)';
        lMatchCollection:= TRegEx.Matches(lText, lPattern);
        for j:= 0 to lMatchCollection.Count - 1 do
        begin
          lMatch:= lMatchCollection.Item[j];
          lUrlEngineer:= PageUrlPatternEngineer+lMatch.Value;
          FCSVPattern[FCSVPattern.Count - 1]:= lUrlEngineer;
          lCSVText:= FCSVPattern.DelimitedText;
          if Pos(ExcludePageUrlPattern, lCSVText) > 0 then begin

          end
          else begin
            if UrlList.IndexOf(lCSVText) < 0  then begin
              UrlList.Add(lCSVText);
            end;
          end;
          Result:= True;
        end;
      except on e: Exception do
        begin
          ErrorUrlList.Add(lUrl);
        end;
      end;
    end;
  finally
    FreeAndNil(lStringList);
  end;
end;

procedure TthrdGetUrlWorker.SetErrorUrlList(const Value: TStringList);
begin
  FErrorUrlList := Value;
end;

procedure TthrdGetUrlWorker.SetExcludePageUrlPattern(const Value: string);
begin
  FExcludePageUrlPattern := Value;
end;

procedure TthrdGetUrlWorker.SetGetJob(const Value: TGetJob);
begin
  FGetJob := Value;
end;

procedure TthrdGetUrlWorker.SetMarkFinished(const Value: TGetJob);
begin
  FMarkFinished := Value;
end;

procedure TthrdGetUrlWorker.SetPageMax(const Value: Integer);
begin
  FPageMax := Value;
end;

procedure TthrdGetUrlWorker.SetPageMin(const Value: Integer);
begin
  FPageMin := Value;
end;

procedure TthrdGetUrlWorker.SetPageUrlPattern(const Value: string);
begin
  FPageUrlPattern := Value;
end;

procedure TthrdGetUrlWorker.SetPageUrlPatternEngineer(const Value: string);
begin
  FPageUrlPatternEngineer := Value;
end;

procedure TthrdGetUrlWorker.SetParseType(const Value: TParseTyp);
begin
  FParseType := Value;
end;

procedure TthrdGetUrlWorker.SetSearchText(const Value: string);
begin
  FSearchText := Value;
end;

procedure TthrdGetUrlWorker.SetSearchUrlPattern(const Value: string);
begin
  FSearchUrlPattern := Value;
end;

procedure TthrdGetUrlWorker.SetUrlList(const Value: TStringList);
begin
  FUrlList := Value;
end;

end.
