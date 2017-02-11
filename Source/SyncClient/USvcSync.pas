unit USvcSync;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  USrvMain, ComCtrls, ExtCtrls, StdCtrls, IBQuery, IBDatabase,
  IdComponent,
  tsvSyncClient, UMainUnited, tsvInterbase;

type
  TfmSvcSync = class(TfmSrvMain)
    pnTop: TPanel;
    sbBottom: TStatusBar;
    pnCenter: TPanel;
    pbStatus: TProgressBar;
    btSync: TButton;
    btCancel: TButton;
    meHint: TMemo;
    TimerStart: TTimer;
    TimerClose: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btSyncClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure TimerCloseTimer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FBreak: Boolean;
    FRunning: Boolean;
    FSyncClient: TtsvSyncClient;
    FProgressBar: THandle;
    FTSPB: TSetProgressBarStatus;
    procedure Synchronizing;
    procedure Breaking(WithCloseCaption: Boolean=false);
    procedure BreakClick(Sender: TObject);
    procedure SyncClientLog(Message: string);
    procedure SyncClientWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
    procedure SyncClientWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
    procedure SyncClientWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure SyncClientGetDataDesc(InStream,OutStream: TMemoryStream);
    procedure SyncClientSetData(Stream: TMemoryStream);
    procedure ProgressProc(Progress: Integer);
    function GetTableDesc(AName: String): String;
    function CheckBreakProc: Boolean;
    procedure SyncClientSuccessData(Sender: TObject);
  public
  end;

var
  fmSvcSync: TfmSvcSync;

implementation

uses Db,
     USyncClientData, StbasisSClientDataSet, StbasisSGlobal;

{$R *.DFM}

procedure TfmSvcSync.FormCreate(Sender: TObject);
var
  TCPB: TCreateProgressBar;
begin
  Caption:=NameSvcSync;
  FSyncClient:=TtsvSyncClient.Create(nil);
  FSyncClient.OnLog:=SyncClientLog;
  FSyncClient.OnWorkBegin:=SyncClientWorkBegin;
  FSyncClient.OnWork:=SyncClientWork;
  FSyncClient.OnWorkEnd:=SyncClientWorkEnd;
  FSyncClient.OnGetDataDesc:=SyncClientGetDataDesc;
  FSyncClient.OnSetData:=SyncClientSetData;
  FSyncClient.OnSuccessData:=SyncClientSuccessData;

  FillChar(TCPB,SizeOf(TCPB),0);
  TCPB.Color:=clNavy;
  TCPB.Min:=0;
  TCPB.Max:=0;
  TCPB.Hint:='';
  FProgressBar:=_CreateProgressBar(@TCPB);
end;

procedure TfmSvcSync.btCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmSvcSync.btSyncClick(Sender: TObject);
begin
  Synchronizing;
end;

procedure TfmSvcSync.Breaking(WithCloseCaption: Boolean=false);
begin
  FBreak:=true;
  FRunning:=false;
  btSync.Enabled:=true;
  if not WithCloseCaption then
    btCancel.Caption:='Отмена'
  else btCancel.Caption:='Закрыть';
  btCancel.OnClick:=btCancelClick;
  FSyncClient.Stop;
  TimerClose.Enabled:=true;
end;

procedure TfmSvcSync.BreakClick(Sender: TObject);
begin
  Breaking;
end;

procedure TfmSvcSync.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Breaking;
end;

procedure TfmSvcSync.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  But: Integer;
begin
  if FRunning then begin
    But:=ShowQuestion(Handle,'Прервать процесс синхронизации?');
    case But of
      mrYes: CanClose:=true;
      else begin
        CanClose:=false;
      end;
    end;
  end;
end;

procedure TfmSvcSync.FormDestroy(Sender: TObject);
begin
  _FreeProgressBar(FProgressBar);
  FSyncClient.Free;
  inherited;
end;

procedure TfmSvcSync.SyncClientLog(Message: string);
var
  S: string;
  TCLI: TCreateLogItem;
const
  fmtLog='%s: %s';
begin
  FillChar(TCLI,SizeOf(TCLI),0);
  TCLI.Text:=PChar(Message);
  TCLI.TypeLogItem:=tliInformation;
  _CreateLogItem(@TCLI);
  S:=Format(fmtLog,[FormatDateTime('hh:nn:ss.zzz',Now),Message]);
  meHint.Lines.Add(S);
  meHint.SelStart:=Length(meHint.Lines.Text);
end;

procedure TfmSvcSync.Synchronizing;
var
  Query: TIBQuery;
  Tran: TIBTransaction;
  IsSuccess: Boolean;
  Used: Boolean;
  RetryCount: Integer;
  i: Integer;
begin
  IsSuccess:=false;
  FBreak:=false;
  FRunning:=true;
  TimerStart.Enabled:=false;
  TimerClose.Enabled:=false;
  btSync.Enabled:=false;
  btCancel.Caption:='Прервать';
  btCancel.OnClick:=BreakClick;
  FSyncClient.ParentHandle:=Self.Handle;
  Query:=TIBQuery.Create(nil);
  Tran:=TIBTransaction.Create(nil);
  try
    Query.Database:=IBDB;
    Tran.AddDatabase(IBDB);
    IBDB.AddTransaction(Tran);

    Tran.Params.Text:=DefaultTransactionParamsTwo;
    Tran.Active:=true;

    Query.Sql.Add(SQLRbkSync_Connection+' order by priority');
    Query.Active:=true;
    Query.First;
    while not Query.Eof do begin
      Application.ProcessMessages;
      if FBreak then break;
      Used:=Boolean(Query.FieldByName('used').AsInteger);
      if Used then begin
        RetryCount:=Query.FieldByName('retry_count').AsInteger;
        for i:=0 to RetryCount-1 do begin
          with FSyncClient do begin
            Disconnect;
            Application.ProcessMessages;
            if FBreak then break;
            ConnectionType:=TConnectionType(Query.FieldByName('connection_type').AsInteger);

            DisplayName:=Query.FieldByName('display_name').AsString;
            ServerName:=Query.FieldByName('server_name').AsString;
            ServerPort:=Query.FieldByName('server_port').AsInteger;
            OfficeName:=Query.FieldByName('office_name').AsString;
            OfficeKey:=Query.FieldByName('office_key').AsString;
            ProxyName:=Query.FieldByName('proxy_name').AsString;
            ProxyPort:=Query.FieldByName('proxy_port').AsInteger;
            ProxyUserName:=Query.FieldByName('proxy_user_name').AsString;
            ProxyUserPass:=Query.FieldByName('proxy_user_pass').AsString;
            ProxyByPass:=Query.FieldByName('proxy_by_pass').AsString;
            RemoteAuto:=Boolean(Query.FieldByName('inet_auto').AsInteger);
            RemoteName:=Query.FieldByName('remote_name').AsString;
            ModemUserName:=Query.FieldByName('modem_user_name').AsString;
            ModemUserPass:=Query.FieldByName('modem_user_pass').AsString;
            ModemDomain:=Query.FieldByName('modem_domain').AsString;
            ModemPhone:=Query.FieldByName('modem_phone').AsString;

            CurrentIncremet:=i+1;
            Sleep(1000);
            Connect;
            IsSuccess:=Synchronize;
            Disconnect;
          end;
          if IsSuccess then break;
        end;
      end;
      if IsSuccess then break;
      Query.Next;
    end;

  finally
    Tran.Free;
    Query.Free;
    Breaking(IsSuccess);
  end;
end;

procedure TfmSvcSync.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled:=false;
  btSync.Click;
end;

procedure TfmSvcSync.SyncClientWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
  pbStatus.Min:=0;
  pbStatus.Max:=AWorkCountMax;
  pbStatus.Position:=0;
  FillChar(FTSPB,SizeOf(FTSPB),0);
  FTSPB.Max:=pbStatus.Max;
  FTSPB.Progress:=pbStatus.Position;
  _SetProgressBarStatus(FProgressBar,@FTSPB);
end;

procedure TfmSvcSync.SyncClientWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
  pbStatus.Position:=AWorkCount;
  FTSPB.Progress:=pbStatus.Position;
  _SetProgressBarStatus(FProgressBar,@FTSPB);
  Application.ProcessMessages;
end;

procedure TfmSvcSync.SyncClientWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  pbStatus.Position:=0;
  FTSPB.Progress:=pbStatus.Position;
  _SetProgressBarStatus(FProgressBar,@FTSPB);
end;

procedure TfmSvcSync.TimerCloseTimer(Sender: TObject);
begin
  btCancel.Click;
end;

procedure TfmSvcSync.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  TimerClose.Enabled:=false;
end;

procedure TfmSvcSync.SyncClientGetDataDesc(InStream,OutStream: TMemoryStream);
var
  InData,OutData,TempData: TStbasisSClientDataSet;
  TempStream: TMemoryStream;
  Tran: TIBTransaction;
  Query: TIBQuery;
  sqls: string;
  AName, AFields_Sync, ACondition: string;
  AObjectId: Integer;
  NewFields: string;
  TCLI: TCreateLogItem;
begin
  try
    InData:=TStbasisSClientDataSet.Create(nil);
    OutData:=TStbasisSClientDataSet.Create(nil);
    try
      try
        InData.LoadFromStream(InStream);
      except
        raise Exception.Create('Данные имеют неверный формат');
      end;
      if InData.Active then begin
        with OutData do begin
          FieldDefs.Add('SYNC_OBJECT_ID',ftInteger);
          FieldDefs.Add('DATA',ftblob);
          CreateDataSet;
        end;
        Tran:=TIBTransaction.Create(nil);
        Query:=TIBQuery.Create(nil);
        try
          IBDB.AddTransaction(Tran);
          Tran.AddDatabase(IBDB);
          Tran.Params.Text:=DefaultTransactionParamsTwo;
          Query.Database:=IBDB;
          Query.Transaction:=Tran;

          InData.First;
          while not InData.Eof do begin
            AObjectId:=InData.FieldByName('SYNC_OBJECT_ID').AsInteger;
            AName:=InData.FieldByName('NAME').AsString;
            AFields_Sync:=InData.FieldByName('FIELDS_SYNC').AsString;
            ACondition:=InData.FieldByName('CONDITION').AsString;
            NewFields:=AFields_Sync;
            sqls:=Format('SELECT %s FROM %s%s',[NewFields,AName,iff(Trim(ACondition)<>'',Format(' WHERE %s',[ACondition]),'')]);

            Query.Transaction.Active:=false;
            Query.Active:=false;
            Query.Transaction.Active:=true;
            Query.Sql.Clear;
            Query.Sql.Add(sqls);
            Query.Active:=true;

            OutData.Append;
            OutData.FieldByName('SYNC_OBJECT_ID').AsInteger:=AObjectId;
            TempData:=TStbasisSClientDataSet.Create(nil);
            TempStream:=TMemoryStream.Create;
            try
              Query.First;
              TempData.CreateDataSetBySource(Query);
              while not Query.Eof do begin
                TempData.FieldValuesBySource(Query);
                Query.Next;
              end;
              TempData.MergeChangeLog;
              TempData.SaveToStream(TempStream);
              TempStream.Position:=0;
              TBlobField(OutData.FieldByName('DATA')).LoadFromStream(TempStream);
            finally
              TempStream.Free;
              TempData.Free;
            end;
            OutData.Post;

            InData.Next;
          end;

          OutData.MergeChangeLog;
          OutData.SaveToStream(OutStream);

        finally
          Query.Free;
          Tran.Free;
        end;
      end;
    finally
      OutData.Free;
      InData.Free;
    end;
  except
    on E: Exception do begin
      FillChar(TCLI,SizeOf(TCLI),0);
      TCLI.Text:=PChar(E.Message);
      TCLI.TypeLogItem:=tliError;
      _CreateLogItem(@TCLI);
      raise;
    end;
  end;
end;

function TfmSvcSync.GetTableDesc(AName: String): String;
var
  Tran: TIBTransaction;
  Query: TIBQuery;
  sqls: string;
const
    SQLTable='Select rdb$description as descr from rdb$relations '+
             'where rdb$system_flag=0 and rdb$view_source is null and rdb$relation_name=%s';

begin
  Result:='';
  Tran:=TIBTransaction.Create(nil);
  Query:=TIBQuery.Create(nil);
  try
    IBDB.AddTransaction(Tran);
    Tran.AddDatabase(IBDB);
    Tran.Params.Text:=DefaultTransactionParamsTwo;
    Query.Database:=IBDB;
    Query.Transaction:=Tran;

    Query.Transaction.Active:=false;
    Query.Active:=false;
    Query.Transaction.Active:=true;
    Query.Sql.Clear;
    sqls:=Format(SQLTable,[QuotedStr(AName)]);
    Query.Sql.Add(sqls);
    Query.Active:=true;
    if not Query.IsEmpty then
      Result:=Query.FieldByName('descr').AsString;

  finally
    Query.Free;
    Tran.Free;
  end;
end;

function TfmSvcSync.CheckBreakProc: Boolean;
begin
  Result:=FBreak;
end;

procedure TfmSvcSync.SyncClientSetData(Stream: TMemoryStream);
var
  Data,TempData: TStbasisSClientDataSet;
  TempStream: TMemoryStream;
  AName,AFields_Sync,AFields_Key,ACondition,ASql_Before,ASql_After: string;
  TCLI: TCreateLogItem;
  ADesc: String;
begin
  try
    Data:=TStbasisSClientDataSet.Create(nil);
    try
      try
        Data.LoadFromStream(Stream);
      except
        raise Exception.Create('Данные имеют неверный формат');
      end;
      if Data.Active then begin


        SyncClientLog('Обновление данных...');
        Data.First;
        while not Data.Eof do begin
          Application.ProcessMessages;
          if FBreak then break;
          AName:=Data.FieldByName('NAME').AsString;
          ADesc:=GetTableDesc(AName);
          SyncClientLog(Format('Объект %s ...',[ADesc]));

          AFields_Sync:=Data.FieldByName('FIELDS_SYNC').AsString;
          AFields_Key:=Data.FieldByName('FIELDS_KEY').AsString;
          ACondition:=Data.FieldByName('CONDITION').AsString;
          ASql_Before:=Data.FieldByName('SQL_BEFORE').AsString;
          ASql_After:=Data.FieldByName('SQL_AFTER').AsString;

          TempData:=TStbasisSClientDataSet.Create(nil);
          TempStream:=TMemoryStream.Create;
          try
            TBlobField(Data.FieldByName('DATA')).SaveToStream(TempStream);
            TempStream.Position:=0;
            TempData.LoadFromStream(TempStream);
            SyncClientWorkBegin(Self,wmWrite,TempData.RecordCount);
            CompareAndModify(IBDB,AName,AFields_Sync,AFields_Key,ACondition,ASql_Before,ASql_After,TempData,ProgressProc,CheckBreakProc);
            if not FBreak then
              SyncClientLog(Format('Объект %s успешно обновлен.',[ADesc]));
          finally
            SyncClientWorkEnd(Self,wmWrite);
            TempStream.Free;
            TempData.Free;
          end;
          Data.Next;
        end;

      end;
    finally
      Data.Free;
    end;
  except
    on E: Exception do begin
      FillChar(TCLI,SizeOf(TCLI),0);
      TCLI.Text:=PChar(E.Message);
      TCLI.TypeLogItem:=tliError;
      _CreateLogItem(@TCLI);
      raise;
    end;
  end;
end;

procedure TfmSvcSync.ProgressProc(Progress: Integer);
begin
  SyncClientWork(Self,wmWrite,Progress);
end;

procedure TfmSvcSync.SyncClientSuccessData(Sender: TObject);
begin
  ExecSql(IBDB,Format('UPDATE CONSTEX SET VALUEVIEW=%s WHERE NAME=%s',[QuotedStr(DateToStr(Now)),QuotedStr(SDateSync)]));
end; 

end.
