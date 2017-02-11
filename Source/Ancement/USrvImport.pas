unit USrvImport;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  USrvMain, rxRichEd, StdCtrls, ExtCtrls, Buttons, tsvDbGrid, Db, dbgrids,
  RxMemDS, IBDatabase, IBCustomDataSet, IBQuery, comctrls, Grids;

type
  TfmSrvImport = class(TfmSrvMain)
    od: TOpenDialog;
    pnBut: TPanel;
    bibLoad: TButton;
    pnGrbBack: TPanel;
    grbRichEdit: TGroupBox;
    pnBackRichEdit: TPanel;
    spl: TSplitter;
    pnGrid: TPanel;
    ds: TDataSource;
    bibImport: TButton;
    bibBreak: TButton;
    bibClose: TButton;
    qr: TIBQuery;
    tran: TIBTransaction;
    lbCount: TLabel;
    pnRelease: TPanel;
    lbRelease: TLabel;
    edRelease: TEdit;
    bibRelease: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibLoadClick(Sender: TObject);
    procedure bibCloseClick(Sender: TObject);
    procedure bibBreakClick(Sender: TObject);
    procedure bibImportClick(Sender: TObject);
    procedure bibReleaseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    LastKey: Word;
    procedure OnRptImportTerminate(Sender: TObject);
    procedure MemTableAfterScroll(DataSet: TDataSet);
    procedure reLoadOnEnter(Sender: TObject);
    procedure GridEditButtonClick(Sender: TObject);
    procedure GridDrawDataCell(Sender: TObject; const Rect: TRect; Field: TField; State: TGridDrawState);

    procedure SetReleaseNumRelease;
    function CheckFieldsFill: Boolean;
    procedure MemTableAfterEdit(DataSet: TDataSet);
  public
  //  reLoad: TRXRichEdit;
    NumRelease: string;
    NoteRelease: string;
    release_id: Integer;
    reLoad: TRichEdit;
    Grid: TNewDBgrid;
    MemTable: TRxMemoryData;

    procedure SaveToIni;override;
    procedure LoadFromIni;override;

    procedure ViewCount;
  end;

var
  fmSrvImport: TfmSrvImport;

implementation

uses UAncementData, UMainUnited, UAncementCode, StrUtils, UAncementOptions;

{$R *.DFM}

type
  TThreadLoad=class(TObject)
  private
    hPBMain: THandle;
    FCurFreeProgressBar: THandle;
    ListTreeHeading: TList;
    procedure ClearAndFreeListTreeHeading(List: TList);
    procedure FreeCurrentProgressBar;
  public
    fmParent: TfmSrvImport;
    constructor Create;
    destructor Destroy;override;
    procedure Execute; virtual;
  end;

  PInfoTreeHeading=^TInfoTreeHeading;
  TInfoTreeHeading=packed record
    treeheading_id: Integer;
    name: string;
    ListChild: TList;
    ListKeyWords: TList;
  end;

  PInfoKeyWord=^TInfoKeyWord;
  TInfoKeyWord=packed record
    word_id: Integer;
    Name: string;
  end;

  TThreadImport=class(TThread)
  private
    hPB: THandle;
  public
    fmParent: TfmSrvImport;
    constructor Create;
    destructor Destroy;override;
    procedure Execute;override;
  end;


var
  RptLoad: TThreadLoad;
  RptImport: TThreadImport;

{ TThreadLoad }

function ConvertQuotas(TextAnn: String): String;
var
  i: Integer;
  chPrev,chNext,ch: Char;
  Index: Integer;
  Flag: Boolean;
  CountBetween: Integer;
begin
  Result:='';
  Flag:=false;
  Index:=-1;
  CountBetween:=0;
  for i:=1 to Length(TextAnn) do begin
    if i>1 then
      chPrev:=TextAnn[i-1]
    else chPrev:=#0;
    if i<Length(TextAnn) then
      chNext:=TextAnn[i+1]
    else chNext:=#0;
    ch:=TextAnn[i];
    if ch in [#34,#39,#96,#145,#146,#147,#148] then begin
      if not Flag and (chPrev=' ') or (chPrev=#0) then begin
        Flag:=true;
        Index:=i;
        CountBetween:=0;
      end;
      if ((chNext in [' ',#0,',','.',':',')','(','!',';']) and Flag) and
         (CountBetween>0) then begin
        Flag:=false;
        TextAnn[Index]:=#171;
        ch:=#187;
        CountBetween:=0;
      end;
    end else
      if Flag then begin
        Inc(CountBetween);
      end;
    TextAnn[i]:=ch;
  end;
  Result:=TextAnn;
end;

constructor TThreadLoad.Create;
begin
  inherited Create;
  ListTreeHeading:=TList.Create;
end;

procedure TThreadLoad.ClearAndFreeListTreeHeading(List: TList);
var
  i,j: Integer;
  P: PInfoTreeHeading;
begin
  for i:=0 to List.Count-1 do begin
    P:=List.Items[i];
    for j:=0 to P.ListKeyWords.Count-1 do begin
      Dispose(PInfoKeyWord(P.ListKeyWords.Items[j]));
    end;
    P.ListKeyWords.Free;
    ClearAndFreeListTreeHeading(P.ListChild);
    Dispose(P);
  end;
  LIst.Free;
end;

procedure TThreadLoad.FreeCurrentProgressBar;
begin
  _FreeProgressBar(FCurFreeProgressBar);
end;

destructor TThreadLoad.Destroy;
begin
  FreeCurrentProgressBar;
  _FreeProgressBar(hPBMain);
  ClearAndFreeListTreeHeading(ListTreeHeading);
  inherited Destroy;
end;

procedure TThreadLoad.Execute;
var
  BeginTree: string;
  EndTree: string;
  PointerTree: string;
  ContactPhone: string;
  HomePhone: string;
  WorkPhone: string;

  SizeCreateTree: Extended;
  SizeMax: Integer;
  
  function GetListParentByTreeHeadingId(Id: Integer): TList;
  var
    isBreak: Boolean;

    function GetLocalList(List: TList): TList;
    var
     i: Integer;
     P: PInfoTreeHeading;
    begin
     Result:=nil;
     if isBreak then exit;
     for i:=0 to List.Count-1 do begin
       P:=List.Items[i];
      if P.treeheading_id=id then begin
        Result:=P.ListChild;
        isBreak:=true;
        exit;
      end else begin
       Result:=GetLocalList(P.ListChild);
       if Result<>nil then begin
        isBreak:=true;
        exit;
       end;
      end; 
     end;
    end;

  begin
    isBreak:=false;
    Result:=GetLocalList(ListTreeHeading);
    if Result=nil then
      Result:=ListTreeHeading;
  end;

  procedure FillKeyWords(P: PInfoTreeHeading);
  var
    qr: TIBQuery;
    tr: TIbTransaction;
    PKey: PInfoKeyWord;
  begin
    qr:=TIBQuery.Create(nil);
    tr:=TIbTransaction.Create(nil);
    try
      tr.AddDatabase(IBDB);
      IBDB.AddTransaction(tr);
      tr.Params.Text:=DefaultTransactionParamsTwo;
      qr.Database:=IBDB;
      qr.Transaction:=tr;
      qr.ParamCheck:=false;
      qr.SQL.Text:='SELECT WORD_ID, WORD FROM '+tbKeywords+' WHERE TREEHEADING_ID='+inttostr(P.treeheading_id)+' ';
      tr.Active:=true;
      qr.Open;
      qr.FetchAll;
      if not qr.IsEmpty then begin
        try
          try
           qr.First;
           while not qr.Eof do begin
             New(PKey);
             FillChar(PKey^,SizeOf(TInfoKeyWord),0);
             PKey.word_id:=qr.FieldByName('WORD_ID').AsInteger;
             PKey.Name:=qr.FieldByName('WORD').AsString;
             P.ListKeyWords.Add(PKey);
             qr.Next;
           end;
          finally
            FreeCurrentProgressBar;
          end;
        except
          {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
        end;
      end;
    finally
      tr.Free;
      qr.Free;
    end;
  end;

{  procedure FillKeyWords(P: PInfoTreeHeading);
  var
    TPRBI: TParamRBookInterface;
    StartValue,EndValue: Integer;
    i: Integer;
    PKey: PInfoKeyWord;
  begin
     FillChar(TPRBI,Sizeof(TParamRBookInterface),0);
     TPRBI.Visual.TypeView:=tviOnlyData;
     TPRBI.Condition.WhereStr:=PChar(' '+tbKeywords+'.treeheading_id='+inttostr(P.treeheading_id)+' ');
     if _ViewInterfaceFromName(NameRbkKeyWords,@TPRBI) then begin
       GetStartAndEndByParamRBookInterface(@TPRBI,StartValue,EndValue);
       for i:=StartValue to EndValue do begin
         New(PKey);
         FillChar(PKey^,SizeOf(TInfoKeyWord),0);
         PKey.word_id:=GetValueByParamRBookInterface(@TPRBI,i,'word_id',varInteger);
         PKey.Name:=GetValueByParamRBookInterface(@TPRBI,i,'word',varString);
         P.ListKeyWords.Add(PKey);
       end;
     end;
  end;

 { procedure CreateTree;
  var
    TPRBI: TParamRBookInterface;
    TCPB: TCreateProgressBar;
    TSPBS: TSetProgressBarStatus;
    StartValue,EndValue: Integer;
    ListParent: TList;
    P: PInfoTreeHeading;
    i: Integer;
    curparent_id: Integer;
    PBH: THandle;
    incMain: Extended;
    CurMainProgress: Extended;
    tid: Integer;
  begin
     FillChar(TPRBI,Sizeof(TParamRBookInterface),0);
     TPRBI.Visual.TypeView:=tviOnlyData;
     TPRBI.Condition.OrderStr:=PChar(' parent_id desc, sortnumber desc ');
     if _ViewInterfaceFromName(NameRbkTreeHeading,@TPRBI) then begin
      GetStartAndEndByParamRBookInterface(@TPRBI,StartValue,EndValue);
      try
       TCPB.Min:=StartValue;
       TCPB.Max:=EndValue;
       TCPB.Hint:='Генерация дерева';
       TCPB.Color:=clNavy;
       PBH:=_CreateProgressBar(@TCPB);
       FCurFreeProgressBar:=PBH;
       incMain:=1/(Abs(EndValue-StartValue)/SizeCreateTree);
       CurMainProgress:=0;

       for i:=EndValue downto StartValue do begin
        if Terminated then exit;
        curparent_id:=GetValueByParamRBookInterface(@TPRBI,i,'parent_id',varInteger);
        tid:=GetValueByParamRBookInterface(@TPRBI,i,'treeheading_id',varInteger);
        ListParent:=GetListParentByTreeHeadingId(curparent_id);
        if ListParent<>nil then begin
         New(P);
         FillChar(P^,Sizeof(TInfoTreeHeading),0);
         P.treeheading_id:=tid;
         P.name:=GetValueByParamRBookInterface(@TPRBI,i,'nameheading',varString);
         P.ListChild:=TList.Create;
         P.ListKeyWords:=TList.Create;
         if not fmOptions.chbImportWithOutKeyWords.Checked then
           FillKeyWords(P);
         ListParent.Add(P);
        end;
        TSPBS.Progress:=TCPB.Max-i;
        TSPBS.Hint:='';
        _SetProgressBarStatus(PBH,@TSPBS);
        CurMainProgress:=CurMainProgress+incMain;
        TSPBS.Progress:=Round(CurMainProgress);
        TSPBS.Hint:='';
        _SetProgressBarStatus(hPBMain,@TSPBS);
       end;
      finally
       Synchronize(FreeCurrentProgressBar);
      end;
     end;
  end;   }

  procedure CreateTree;
  var
    TCPB: TCreateProgressBar;
    TSPBS: TSetProgressBarStatus;
    ListParent: TList;
    P: PInfoTreeHeading;
    i: Integer;
    curparent_id: Integer;
    PBH: THandle;
    incMain: Extended;
    CurMainProgress: Extended;
    tid: Integer;
    qr: TIBQuery;
    tr: TIbTransaction;
    StartValue, EndValue: Integer;
  begin
    qr:=TIBQuery.Create(nil);
    tr:=TIbTransaction.Create(nil);
    try
      tr.AddDatabase(IBDB);
      IBDB.AddTransaction(tr);
      tr.Params.Text:=DefaultTransactionParamsTwo;
      qr.Database:=IBDB;
      qr.Transaction:=tr;
      qr.ParamCheck:=false;
      qr.SQL.Text:='SELECT C.TREEHEADING_ID, T.NAMEHEADING, T.PARENT_ID '+
                   'FROM CREATETREEHEADING(NULL,0) C JOIN TREEHEADING T ON T.TREEHEADING_ID=C.TREEHEADING_ID '+
                   'ORDER BY C.INC';
      tr.Active:=true;
      qr.Open;
      qr.FetchAll;
      if not qr.IsEmpty then begin
        try
          try
           StartValue:=0;
           EndValue:=qr.RecordCount;
           TCPB.Min:=StartValue;
           TCPB.Max:=EndValue;
           TCPB.Hint:='Генерация дерева';
           TCPB.Color:=clNavy;
           PBH:=_CreateProgressBar(@TCPB);
           FCurFreeProgressBar:=PBH;
           incMain:=1/(Abs(EndValue-StartValue)/SizeCreateTree);
           CurMainProgress:=0;
           i:=0;
           qr.First;
           while not qr.Eof do begin
            curparent_id:=qr.FieldByName('parent_id').AsInteger;
            tid:=qr.FieldByName('treeheading_id').AsInteger;
            ListParent:=GetListParentByTreeHeadingId(curparent_id);
            if ListParent<>nil then begin
             New(P);
             FillChar(P^,Sizeof(TInfoTreeHeading),0);
             P.treeheading_id:=tid;
             P.name:=qr.FieldByName('nameheading').AsString;
             P.ListChild:=TList.Create;
             P.ListKeyWords:=TList.Create;
             if not fmOptions.chbImportWithOutKeyWords.Checked then
               FillKeyWords(P);
             ListParent.Add(P);
            end;
            inc(i);
            TSPBS.Progress:=i;
            TSPBS.Hint:='';
            _SetProgressBarStatus(PBH,@TSPBS);
            CurMainProgress:=CurMainProgress+incMain;
            TSPBS.Progress:=Round(CurMainProgress);
            TSPBS.Hint:='';
            _SetProgressBarStatus(hPBMain,@TSPBS);
            qr.Next;
           end;
          finally
            FreeCurrentProgressBar;
          end;  
        except
          {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
        end;
      end;
    finally
      tr.Free;
      qr.Free;
    end;
  end;

{type
  TSetOfChar=set of char;

  function GetFirstWord(s: string; SetOfChar: TSetOfChar; var Pos: Integer): string;
  var
    tmps: string;
    i: integer;
  begin
    for i:=1 to Length(s) do begin
      if S[i] in SetOfChar then break;
      tmps:=tmps+S[i];
      Pos:=i;
    end;
    Result:=tmps;
  end;}

  function GetInfoTreeHeadingByName(s: string; parent_id: integer): PInfoTreeHeading;
  var
    Lst: TList;
    i: Integer;
    P: PInfoTreeHeading;
  begin
    Result:=nil;
    lst:=GetListParentByTreeHeadingId(parent_id);
    if lst=nil then exit;
    for i:=0 to lst.Count-1 do begin
      P:=lst.Items[i];
      if AnsiSameText(AnsiUpperCase(P.Name),AnsiUpperCase(s)) then begin
        Result:=P;
        exit;
      end;
    end;
  end;

  function GetRecurseTReeHeading(s: string; var P: PInfoTreeHeading): Boolean;
  var
    str: TStringList;

    procedure FillStr(snew: string);
    var
      APos: Integer;
      tmps: string;
      s1: string;
    begin
      APos:=-1;
      tmps:=snew;
      while APos<>0 do begin
        APos:=ANsiPos(PointerTree,tmps);
        if APos<>0 then begin
          s1:=Copy(tmps,1,APos-1);
          tmps:=Copy(tmps,APos+Length(PointerTree),Length(tmps)-APos);
          str.Add(s1);
        end else str.Add(tmps);
      end;
    end;

  var
    snew: string;
    APos:Integer;
    i: Integer;
    pParent: PInfoTreeHeading;
  begin
    Result:=false;
    s:=Trim(s);
    Apos:=AnsiPos(BeginTree,s);
    if APos=0 then exit;
    s:=Copy(s,Apos+Length(BeginTree),Length(s)-(Apos+1-Length(BeginTree)));
    APos:=AnsiPos(EndTree,s);
    if APos=0 then exit;
    snew:=Copy(s,Length(EndTree),APos-Length(EndTree));
    if Trim(snew)='' then exit;
    str:=TStringList.Create;
    try
      FillStr(snew);
      pParent:=nil;
      if str.Count=0 then exit;
      for i:=0 to str.Count-1 do begin
        if i=0 then begin
          PParent:=GetInfoTreeHeadingByName(str.strings[i],0);
        end else begin
          PParent:=GetInfoTreeHeadingByName(str.strings[i],PParent.treeheading_id);
        end;
        if PParent=nil then exit;
      end;
      P:=PParent;
      Result:=PParent<>nil;
    finally
      str.Free;
    end;
  end;

  function GetInfoKeyWord(P: PInfoTreeHeading; s: string): PInfoKeyWord;
  var
    i: Integer;
    PKey: PInfoKeyWord;
  begin
    Result:=nil;
    for i:=0 to P.ListKeyWords.Count-1 do begin
      PKey:=P.ListKeyWords.Items[i];
      if AnsiSameText(AnsiUpperCase(PKey.Name),AnsiUpperCase(s)) then begin
        Result:=PKey;
        exit;
      end;
    end;
  end;

  function TranslatePhone(Phone: string): string;
  begin
    if Trim(Phone)<>'' then begin
      Phone:=ChangeString(Phone,'-','');
      if Length(Phone)>0 then
        if Phone[Length(Phone)]=',' then
          Phone:=Copy(Phone,1,Length(Phone)-1);
    end;
    Result:=Phone;
  end;

var
  i: Integer;
  TCPB: TCreateProgressBar;
  TSPBS: TSetProgressBarStatus;
  s,fs: string;
  l,len: Integer;
  OldAfterScroll: TDataSetNotifyEvent;
  isChangeTree: Boolean;
  PParent: PInfoTreeHeading;
  POld: PInfoTreeHeading;
  PKey: PInfoKeyWord;
  Pos: Integer;
  ta: Variant;
  cp,hp,wp: Variant;
  APos: Integer;
  tmps: string;
  TCLI: TCreateLogItem;
  AnnCount: Integer;
  OldTree: string;
begin                                                                                       
  try
   try
    SizeMax:=fmParent.reLoad.Lines.Count;
    if SizeMax=0 then exit;
    SizeCreateTree:=SizeMax*35/100;
    TCPB.Min:=1;
    TCPB.Max:=SizeMax+Round(SizeCreateTree);
    TCPB.Hint:='';
    TCPB.Color:=clRed;
    hPBMain:=_CreateProgressBar(@TCPB);
    BeginTree:=fmOptions.edBeforeTree.Text;
    EndTree:=fmOptions.edAfterTree.Text;
    PointerTree:=fmOptions.edPointerTree.Text;
    ContactPhone:=fmOptions.edBeforeContact.Text;
    HomePhone:=fmOptions.edBeforeHome.Text;
    WorkPhone:=fmOptions.edBeforeWork.Text;
    _SetSplashStatus('Создание дерева рубрик');
    CreateTree;
    _SetSplashStatus('Загрузка данных');
    fmParent.MemTable.DisableControls;
    OldAfterScroll:=fmParent.MemTable.AfterScroll;
    fmParent.MemTable.AfterScroll:=nil;
    try
     l:=0;
     AnnCount:=0;
     PParent:=nil;
     POld:=nil;
     for i:=0 to TCPB.Max-1 do begin
      with fmParent do begin
       s:=fmParent.reLoad.Lines.Strings[i];
       len:=Length(s);
       if Trim(s)<>'' then begin
        isChangeTree:=GetRecurseTReeHeading(s,PParent);
        if isChangeTree then begin
          if POld=nil then begin
            OldTree:=Trim(s);
            AnnCount:=0;
          end else begin
            FillChar(TCLI,Sizeof(TCLI),0);
            TCLI.Text:=PChar(Format('Рубрика %s - %d объявления/ий',[OldTree,AnnCount]));
            _CreateLogItem(@TCLI);
            OldTree:=Trim(s);
            AnnCount:=0;
         end;
        end else begin
         if PParent<>nil then begin
          Pos:=0;
          s:=Trim(s);
          fs:=GetFirstWord(s,[' '],Pos);
          PKey:=GetInfoKeyWord(PParent,fs);
          if PKey<>nil then
           s:=Copy(s,Pos+1,Length(s)-Pos);

          MemTable.Append;

          MemTable.FieldByName('treeheadingnameheading').AsString:=PParent.Name;
          MemTable.FieldByName('treeheading_id').AsInteger:=PParent.treeheading_id;
          if PKey<>nil then begin
           MemTable.FieldByName('keywordsword').AsString:=PKey.Name;
           MemTable.FieldByName('word_id').AsInteger:=PKey.word_id;
          end;
          MemTable.FieldByName('copyprint').AsInteger:=1;

          s:=Trim(s);
          if s<>'' then begin
            ta:=s;
            APos:=AnsiPos(ANsiUpperCase(ContactPhone),ANsiUpperCase(ta));
            if Apos<>0 then ta:=Copy(ta,1,APos-1)
            else begin
             APos:=AnsiPos(ANsiUpperCase(HomePhone),ANsiUpperCase(ta));
             if Apos<>0 then ta:=Copy(ta,1,APos-1)
             else begin
              APos:=AnsiPos(ANsiUpperCase(WorkPhone),ANsiUpperCase(ta));
              if Apos<>0 then ta:=Copy(ta,1,APos-1)
              else begin
//                ta:=s;
              end;
             end;
            end;

            APos:=AnsiPos(ANsiUpperCase(HomePhone),ANsiUpperCase(ta));
            if Apos<>0 then ta:=Copy(ta,1,APos-1)
            else begin
             APos:=AnsiPos(ANsiUpperCase(WorkPhone),ANsiUpperCase(ta));
             if Apos<>0 then ta:=Copy(ta,1,APos-1)
             else begin
              APos:=AnsiPos(ANsiUpperCase(ContactPhone),ANsiUpperCase(ta));
              if Apos<>0 then ta:=Copy(ta,1,APos-1)
              else begin
//                ta:=s;
              end;
             end;
            end;
              

            APos:=AnsiPos(ANsiUpperCase(WorkPhone),ANsiUpperCase(ta));
            if Apos<>0 then ta:=Copy(ta,1,APos-1)
            else begin
             APos:=AnsiPos(ANsiUpperCase(ContactPhone),ANsiUpperCase(ta));
             if Apos<>0 then ta:=Copy(ta,1,APos-1)
             else begin
              APos:=AnsiPos(ANsiUpperCase(HomePhone),ANsiUpperCase(ta));
              if Apos<>0 then ta:=Copy(ta,1,APos-1)
              else begin
//                ta:=s;
              end;
             end;
            end;

            if fmOptions.chbImportLoadTranslateQuotas.Checked then
              ta:=ConvertQuotas(ta);

            MemTable.FieldByName('textannouncement').Value:=Trim(ta);
            if Length(ta)>0 then begin
              tmps:=ta;
              s:=Copy(s,Length(tmps),Length(s)-Length(tmps)+1);
              APos:=AnsiPos(ANsiUpperCase(ContactPhone),ANsiUpperCase(s));
              cp:=null;
              if APos<>0 then begin
                cp:=Trim(Copy(s,APos+Length(ContactPhone),Length(s)-APos-Length(ContactPhone)+1));
                APos:=AnsiPos(ANsiUpperCase(HomePhone),ANsiUpperCase(cp));
                if APos<>0 then cp:=Trim(Copy(cp,1,APos-1));
                APos:=AnsiPos(ANsiUpperCase(WorkPhone),ANsiUpperCase(cp));
                if APos<>0 then cp:=Trim(Copy(cp,1,APos-1));
                cp:=TranslatePhone(cp);
              end;
              MemTable.FieldByName('contactphone').Value:=cp;

              APos:=AnsiPos(ANsiUpperCase(HomePhone),ANsiUpperCase(s));
              hp:=null;
              if APos<>0 then begin
                hp:=Trim(Copy(s,APos+Length(HomePhone),Length(s)-APos-Length(HomePhone)+1));
                APos:=AnsiPos(ANsiUpperCase(WorkPhone),ANsiUpperCase(hp));
                if APos<>0 then hp:=Trim(Copy(hp,1,APos-1));
                APos:=AnsiPos(ANsiUpperCase(ContactPhone),ANsiUpperCase(hp));
                if APos<>0 then hp:=Trim(Copy(hp,1,APos-1));
                hp:=TranslatePhone(hp);
              end;
              MemTable.FieldByName('homephone').Value:=hp;

              APos:=AnsiPos(ANsiUpperCase(WorkPhone),ANsiUpperCase(s));
              wp:=null;
              if APos<>0 then begin
                wp:=Trim(Copy(s,APos+Length(WorkPhone),Length(s)-APos-Length(WorkPhone)+1));
                APos:=AnsiPos(ANsiUpperCase(ContactPhone),ANsiUpperCase(wp));
                if APos<>0 then wp:=Trim(Copy(wp,1,APos-1));
                APos:=AnsiPos(ANsiUpperCase(HomePhone),ANsiUpperCase(wp));
                if APos<>0 then wp:=Trim(Copy(wp,1,APos-1));
                wp:=TranslatePhone(wp);
              end;
              MemTable.FieldByName('workphone').Value:=wp;

            end;
          end;

          MemTable.FieldByName('pos').AsInteger:=l;
          MemTable.FieldByName('len').AsInteger:=len;
          
          MemTable.Post;
          
          inc(AnnCount);

          POld:=PParent;


         end;
        end;
       end;
      end;

      l:=l+len+Length(#13#10);
      TSPBS.Progress:=Round(SizeCreateTree+i);
      TSPBS.Hint:='';
      _SetProgressBarStatus(hPBMain,@TSPBS);
     end;

      if PParent<>nil then begin
        FillChar(TCLI,Sizeof(TCLI),0);
        TCLI.Text:=PChar(Format('Рубрика %s - %d объявления/ий',[OldTree,AnnCount]));
        _CreateLogItem(@TCLI);
      end;
      
    finally
     fmParent.MemTable.AfterScroll:=OldAfterScroll;
     fmParent.MemTable.EnableControls;
    end;
   finally
   end;
 except
  {$IFDEF DEBUG}
    on E: Exception do begin
     try
       Assert(false,E.message);
     except
       Application.HandleException(nil);
     end;
    end;
  {$ENDIF}
 end;
end;

{ TThreadImport }

constructor TThreadImport.Create;
begin
  Priority:=tpNormal;
  inherited Create(true);
end;

destructor TThreadImport.Destroy;
begin
  _FreeProgressBar(hPB);
  TerminateThread(Handle,0);
  inherited Destroy;
end;

procedure TThreadImport.Execute;


var
  incr: Integer;
  TCPB: TCreateProgressBar;
  TSPBS: TSetProgressBarStatus;
  OldAfterScroll: TDataSetNotifyEvent;
  sqls: string;
  qr: TIBQuery;
  tran: TIBTransaction;
  id: string;
  dt: TDateTime;
  CU: TInfoConnectUser;
  TextAnn: string;
//  TCLI: TCreateLogItem;
  release_id_local: integer;
begin
 try
   try
    if fmParent.MemTable.IsEmpty then exit;
    TCPB.Min:=0;
    TCPB.Max:=fmParent.MemTable.RecordCount-1;
    TCPB.Hint:='';
    TCPB.Color:=clNavy;
    hPB:=_CreateProgressBar(@TCPB);
    _SetSplashStatus('Импорт данных данных');
    fmParent.MemTable.DisableControls;
    OldAfterScroll:=fmParent.MemTable.AfterScroll;
    fmParent.MemTable.AfterScroll:=nil;
    qr:=TIBQuery.Create(nil);
    tran:=TIBTransaction.Create(nil);
    try
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.ParamCheck:=false;

     dt:=_GetDateTimeFromServer;
     FillChar(CU,SizeOf(TInfoConnectUser),0);
     _GetInfoConnectUser(@CU);
     fmParent.MemTable.First;
     incr:=0;
     release_id_local:=fmParent.release_id;

     repeat
      if Terminated then exit;
      try
       try
        id:=inttostr(GetGenId(IBDB,tbAnnouncement,1));
        with fmParent do begin

         TextAnn:=ChangeString(MemTable.FieldByName('textannouncement').AsString,#13#10,'');

         if fmOptions.chbImportConvertWords.Checked then begin
           TextAnn:=ConvertExtended(TextAnn,ctRussian);
         end;


         TextAnn:=QuotedStr(TextAnn);

         sqls:='Insert into '+tbAnnouncement+
               ' (announcement_id,release_id,treeheading_id,word_id,textannouncement,'+
               'contactphone,homephone,workphone,copyprint,about,indate,whoin,changedate,'+
               'whochange) values '+
               ' ('+id+
               ','+inttostr(release_id_local)+
               ','+inttostr(MemTable.FieldByName('treeheading_id').AsInteger)+
               ','+iff(MemTable.FieldByName('word_id').Value=null,'null',MemTable.FieldByName('word_id').AsString)+
               ','+iff(MemTable.FieldByName('textannouncement').Value=null,'null',TextAnn)+
               ','+iff(MemTable.FieldByName('contactphone').Value=null,'null',QuotedStr(MemTable.FieldByName('contactphone').AsString))+
               ','+iff(MemTable.FieldByName('homephone').Value=null,'null',QuotedStr(MemTable.FieldByName('homephone').AsString))+
               ','+iff(MemTable.FieldByName('workphone').Value=null,'null',QuotedStr(MemTable.FieldByName('workphone').AsString))+
               ','+iff(MemTable.FieldByName('copyprint').Value=null,'1',MemTable.FieldByName('copyprint').AsString)+
               ','+QuotedStr('Импортировано из файла <'+fmParent.od.FileName+'>')+
               ','+QuotedStr(DateTimeToStr(dt))+
               ','+QuotedStr(Trim(CU.UserName))+
               ','+QuotedStr(DateTimeToStr(dt))+
               ','+QuotedStr(Trim(CU.UserName))+
               ')';

        end;
        qr.SQL.Clear;
        qr.SQL.Add(sqls);
        qr.Transaction.Active:=true;
        qr.ExecSQL;
        qr.Transaction.Commit;

        fmParent.MemTable.Delete;
       except
        {$IFDEF DEBUG}
          on E: Exception do begin
           try
             fmParent.MemTable.Next;
{             TCLI.ViewLogItemProc:=nil;
             TCLI.TypeLogItem:=tliInformation;
             TCLI.Text:=PChar(sqls);
             _CreateLogItem(@TCLI);}
             Assert(false,E.message);
           except
             Application.HandleException(nil);
           end;
          end;
        {$ENDIF}
       end;
      finally
       inc(incr);
       TSPBS.Progress:=incr;
       TSPBS.Hint:='';
       _SetProgressBarStatus(hPB,@TSPBS);
      end;
     until incr>TCPB.Max;
    finally
     qr.Free;
     tran.Free;
     fmParent.MemTable.AfterScroll:=OldAfterScroll;
     fmParent.MemTable.EnableControls;
    end;
   finally
    DoTerminate;
   end;
 except
  {$IFDEF DEBUG}
    on E: Exception do begin
     try
       Assert(false,E.message);
     except
       Application.HandleException(nil);
     end;
    end;
  {$ENDIF}
 end;
end;

{ TfmSrvImport }

procedure TfmSrvImport.FormCreate(Sender: TObject);
var
  cl: TColumn;
  fd: TFieldDef;
begin
 inherited;
 try
  Caption:=NameSrvImport;

  qr.Database:=IBDB;
  qr.Transaction:=tran;
  tran.AddDatabase(IBDB);
  IBDB.AddTransaction(tran);


//  reLoad:=TRXRichEdit.Create(nil);
  reLoad:=TRichEdit.Create(nil);
  reLoad.Parent:=pnBackRichEdit;
  reLoad.Align:=alClient;
  reLoad.ScrollBars:=ssBoth;
  reLoad.WordWrap:=false;
  reLoad.OnEnter:=reLoadOnEnter;
//  reLoad.AutoURLDetect:=false;
//  reLoad.SelectionBar:=false;
//  reLoad.StreamMode:=[smSelection,smPlainRtf];
//  reLoad.LangOptions:=[rlAutoKeyboard,rlAutoFont];
  reLoad.ReadOnly:=true;

  MemTable:=TRxMemoryData.Create(nil);
  
  Grid:=TNewdbGrid.Create(self);
  Grid.Parent:=pnGrid;
  Grid.Align:=alClient;
  Grid.DataSource:=ds;
  Grid.Name:='Grid';
  Grid.RowSelected.Visible:=true;
  Grid.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,Grid.Font);
  Grid.TitleFont.Assign(Grid.Font);
  Grid.RowSelected.Font.Assign(Grid.Font);
  Grid.RowSelected.Brush.Style:=bsClear;
  Grid.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  Grid.RowSelected.Font.Color:=clWhite;
  Grid.RowSelected.Pen.Style:=psClear;
  Grid.CellSelected.Visible:=true;
  Grid.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  Grid.CellSelected.Font.Assign(Grid.Font);
  Grid.CellSelected.Font.Color:=clHighlightText;
  Grid.TitleCellMouseDown.Font.Assign(Grid.Font);
  Grid.WordColor:=clRed;
  Grid.Options:=Grid.Options-[dgEditing]-[dgTabs];
  Grid.RowSizing:=false;
  Grid.ReadOnly:=not MemTable.CanModify;
  if fmOptions.chbImportSelectInvalidChar.Checked then begin
    Grid.Words.Text:=fmOptions.meImportValidChars.Lines.Text;
  end;  

  Grid.OnKeyDown:=FormKeyDown;
  Grid.ColumnSortEnabled:=false;
  Grid.OnEditButtonClick:=GridEditButtonClick;
  Grid.OnDrawDataCell:=GridDrawDataCell;

//  Grid.OnTitleClick:=GridTitleClick;
//  Grid.OnTitleClickWithSort:=GridTitleClickWithSort;
//  Grid.OnDblClick:=GridDblClick;
//  Grid.OnKeyPress:=GridKeyPress;
//  Grid.TabOrder:=1;
//  Grid.PopupMenu:=pmGrid;


  cl:=Grid.Columns.Add;
  cl.ButtonStyle:=cbsEllipsis;
  cl.ReadOnly:=true;
  cl.FieldName:='treeheadingnameheading';
  cl.Title.Caption:='Рубрика';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.ButtonStyle:=cbsEllipsis;
  cl.ReadOnly:=true;
  cl.FieldName:='keywordsword';
  cl.Title.Caption:='Ключевое слово';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='textannouncement';
  cl.Title.Caption:='Текст объявления';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='contactphone';
  cl.Title.Caption:='Контактный телефон';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='homephone';
  cl.Title.Caption:='Домашний телефон';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='workphone';
  cl.Title.Caption:='Рабочий телефон';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='copyprint';
  cl.Title.Caption:='Количество выпусков';
  cl.Width:=60;

{  qr.Transaction.Active:=true;
  qr.Active:=false;
  qr.SQL.Clear;
  qr.SQL.Add(SQLRbkAnnouncementImport);
  qr.Active:=true;}

//  MemTable.CopyStructure(qr);
  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='contactphone';
  fd.DataType:=ftString;
  fd.Size:=150;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='homephone';
  fd.DataType:=ftString;
  fd.Size:=150;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='workphone';
  fd.DataType:=ftString;
  fd.Size:=150;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='treeheading_id';
  fd.DataType:=ftInteger;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='word_id';
  fd.DataType:=ftInteger;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='keywordsword';
  fd.DataType:=ftString;
  fd.Size:=30;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='treeheadingnameheading';
  fd.DataType:=ftString;
  fd.Size:=250;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='textannouncement';
  fd.DataType:=ftString;
  fd.Size:=2000;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='pos';
  fd.DataType:=ftInteger;
  fd.CreateField(MemTable);
  
  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='len';
  fd.DataType:=ftInteger;
  fd.CreateField(MemTable);

  fd:=MemTable.FieldDefs.AddFieldDef;
  fd.Name:='copyprint';
  fd.DataType:=ftInteger;
  fd.Required:=true;
  fd.CreateField(MemTable);

  MemTable.AfterScroll:=MemTableAfterScroll;
  MemTable.AfterEdit:=MemTableAfterEdit;
  MemTable.Active:=true;

//  MemTable.FieldByName(treeheadingnameheading).FieldKind;

  qr.Active:=false;

  ds.DataSet:=MemTable;
  
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmSrvImport.FormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(RptLoad) then begin
    FreeAndNil(RptLoad);
  end;
  if Assigned(RptImport) then begin
    FreeAndNil(RptImport);
  end;  
  reLoad.Free;
  Grid.Free;
  MemTable.Free;
  if FormState=[fsCreatedMDIChild] then
   fmSrvImport:=nil;
end;

procedure TfmSrvImport.bibLoadClick(Sender: TObject);
var
  fs: TFileStream;
  ms: TMemoryStream;
  i: Integer;
begin
  if od.Execute then begin
    try
     Screen.Cursor:=crHourGlass;
     ms:=TMemoryStream.Create;
     try
      MemTable.EmptyTable;
      ViewCount;
      Update;
      for i:=0 to od.Files.Count-1 do begin
        fs:=nil;
        try
          fs:=TFileStream.Create(od.Files[i],fmOpenRead);
          ms.CopyFrom(fs,fs.size);
        finally
          fs.Free;
        end;
      end;
      ms.Position:=0;
      reLoad.Lines.LoadFromStream(ms);
      ms.Position:=0;
      reLoad.Lines.LoadFromStream(ms);
      reLoad.Update;

     finally
      ms.Free;
      Screen.Cursor:=crDefault;
     end;
     reLoad.Enabled:=false;
     Grid.Enabled:=false; 
     bibLoad.Enabled:=false;
     bibImport.Enabled:=false;
     bibBreak.Enabled:=true;
     if RptLoad<>nil then exit;
     RptLoad:=TThreadLoad.Create;
     RptLoad.fmParent:=Self;
     try
       RptLoad.Execute;
     finally
       bibBreakClick(nil);
     end;  
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
  end;
end;

procedure TfmSrvImport.SaveToIni;

  procedure SaveGridProp;
  var
   i: Integer;
   cl: TColumn;
  begin
   for i:=0 to Grid.Columns.Count-1 do begin
    cl:=Grid.Columns.Items[i];
    WriteParam(ClassName,'clmnID'+Grid.Name+inttostr(i),cl.ID);
    WriteParam(ClassName,'clmnIndex'+Grid.Name+inttostr(i),cl.Index);
    WriteParam(ClassName,'clmnWidth'+Grid.Name+inttostr(i),cl.Width);
    WriteParam(ClassName,'clmnVisible'+Grid.Name+inttostr(i),cl.Visible);
   end;
  end;

begin
  inherited;
  SaveGridProp;
  WriteParam(ClassName,'release_id',release_id);
end;

procedure TfmSrvImport.LoadFromIni;

  procedure LoadGridProp;
  var
   i: Integer;
   cl: TColumn;
   id: Integer;
  begin
   for i:=0 to Grid.Columns.Count-1 do begin
    id:=ReadParam(ClassName,'clmnID'+Grid.Name+inttostr(i),i);
    cl:=TColumn(Grid.Columns.FindItemID(id));
    if cl<>nil then begin
     cl.Index:=ReadParam(ClassName,'clmnIndex'+Grid.Name+inttostr(i),cl.Index);
     cl.Width:=ReadParam(ClassName,'clmnWidth'+Grid.Name+inttostr(i),cl.Width);
     cl.Visible:=ReadParam(ClassName,'clmnVisible'+Grid.Name+inttostr(i),cl.Visible);
    end;
   end;
  end;

begin
  inherited;
  LoadGridProp;
  release_id:=ReadParam(ClassName,'release_id',release_id);
  SetReleaseNumRelease;
end;

procedure TfmSrvImport.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmSrvImport.OnRptImportTerminate(Sender: TObject);
begin
  FreeAndNil(RptImport);
  bibBreakClick(nil);
end;

procedure TfmSrvImport.bibBreakClick(Sender: TObject);
begin
  if RptLoad<>nil then FreeAndNil(RptLoad);
  if RptImport<>nil then RptImport.Terminate;
  reLoad.Enabled:=true;
  if Memtable.RecordCount>0 then
   Grid.Options:=Grid.Options+[dgEditing]
  else Grid.Options:=Grid.Options-[dgEditing];                                     
  Grid.Enabled:=true;
  Grid.Invalidate;
  MemTableAfterScroll(nil);
  bibLoad.Enabled:=true;
  bibImport.Enabled:=true;
  bibBreak.Enabled:=false;
  ViewCount;
  Grid.SetFocus;
end;

procedure TfmSrvImport.ViewCount;
begin
  lbCount.Caption:=Format('Всего: %d',[MemTable.RecordCount]);
end;

procedure TfmSrvImport.MemTableAfterScroll(DataSet: TDataSet);
var
  wParam: Dword;
begin
  if MemTable.IsEmpty then exit;
  reLoad.SelAttributes.Color:=reLoad.DefAttributes.Color;
  reLoad.SelStart:=MemTable.FieldbyName('pos').AsInteger;
  reLoad.SelLength:=MemTable.FieldbyName('len').AsInteger;
  reLoad.SelAttributes.Color:=clRed;
  SendMessage(reLoad.Handle,EM_SCROLLCARET,0,0);
  wParam:=Loword(SB_PAGELEFT)+HiWord(0);
  SendMessage(reLoad.Handle,WM_HSCROLL,wParam,0);
end;

procedure TfmSrvImport.reLoadOnEnter(Sender: TObject);
begin
  reLoad.SelAttributes.Color:=reLoad.DefAttributes.Color;
  reLoad.SelAttributes.Style:=reLoad.DefAttributes.Style;
end;

procedure TfmSrvImport.GridEditButtonClick(Sender: TObject);
var
  fl: TField;
  TPRBI: TParamRBookInterface;
begin
  fl:=Grid.SelectedField;
  if fl=nil then exit;
  FillChar(TPRBI,SizeOf(TPRBI),0);
  if AnsiSameText(fl.FieldName,'treeheadingnameheading') then begin
   TPRBI.Visual.TypeView:=tvibvModal;
   TPRBI.Locate.KeyFields:='treeheading_id';
   TPRBI.Locate.KeyValues:=MemTable.FieldByName('treeheading_id').AsInteger;
   TPRBI.Locate.Options:=[loCaseInsensitive];
   if _ViewInterfaceFromName(NameRbkTreeHeading,@TPRBI) then begin
    MemTable.Edit;
    MemTable.FieldByName('treeheading_id').AsInteger:=GetFirstValueFromParamRBookInterface(@TPRBI,'treeheading_id');
    MemTable.FieldByName('treeheadingnameheading').AsString:=GetFirstValueFromParamRBookInterface(@TPRBI,'nameheading');
    MemTable.FieldByName('word_id').Value:=null;
    MemTable.FieldByName('keywordsword').Value:=null;
    MemTable.Post;
   end;
  end;
  if AnsiSameText(fl.FieldName,'keywordsword') then begin
   TPRBI.Visual.TypeView:=tvibvModal;
   TPRBI.Locate.KeyFields:='word_id';
   TPRBI.Locate.KeyValues:=MemTable.FieldByName('word_id').AsInteger;
   TPRBI.Locate.Options:=[loCaseInsensitive];
   TPRBI.Condition.WhereStr:=PChar(' '+tbKeywords+'.treeheading_id='+
                                   inttostr(MemTable.FieldByName('treeheading_id').AsInteger)+' ');
   if _ViewInterfaceFromName(NameRbkKeyWords,@TPRBI) then begin
    MemTable.Edit;
    MemTable.FieldByName('word_id').AsInteger:=GetFirstValueFromParamRBookInterface(@TPRBI,'word_id');
    MemTable.FieldByName('keywordsword').AsString:=GetFirstValueFromParamRBookInterface(@TPRBI,'word');
    MemTable.Post;
   end;
  end;

end;

procedure TfmSrvImport.SetReleaseNumRelease;
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' release_id='+inttostr(release_id)+' ');
  if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
   if ifExistsDataInParamRBookInterface(@TPRBI) then begin
    NumRelease:=Inttostr(GetFirstValueFromParamRBookInterface(@TPRBI,'numrelease'));
    NoteRelease:=GetFirstValueFromParamRBookInterface(@TPRBI,'about');
    edRelease.Text:=Trim(NoteRelease)+' ('+NumRelease+') от '+DateToStr(GetFirstValueFromParamRBookInterface(@TPRBI,'daterelease'));
   end;
  end;
end;

function TfmSrvImport.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edRelease.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbRelease.Caption]));
    bibRelease.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmSrvImport.bibReleaseClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='release_id';
  TPRBI.Locate.KeyValues:=release_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
   release_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'release_id');
   NumRelease:=inttostr(GetFirstValueFromParamRBookInterface(@TPRBI,'numrelease'));
   NoteRelease:=GetFirstValueFromParamRBookInterface(@TPRBI,'about');
   edRelease.Text:=Trim(NoteRelease)+' ('+NumRelease+') от '+DateToStr(GetFirstValueFromParamRBookInterface(@TPRBI,'daterelease'));
  end;
end;

procedure TfmSrvImport.bibImportClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  reLoad.Enabled:=false;
  Grid.Enabled:=false;
  bibLoad.Enabled:=false;
  bibImport.Enabled:=false;
  bibBreak.Enabled:=true;
  if RptImport<>nil then exit;
  RptImport:=TThreadImport.Create;
  RptImport.fmParent:=Self;
  RptImport.OnTerminate:=OnRptImportTerminate;
  RptImport.Resume;
end;

procedure TfmSrvImport.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  but: Integer;  
begin
  if Key=LastKey then begin
   LastKey:=0;
   exit;
  end;
  if Shift=[] then begin
   case Key of
    VK_F2: begin
      MemTable.Insert;
    end;
    VK_F3: begin
      MemTable.Edit;
      Grid.EditorMode:=true;
    end;
    VK_F4: begin
      if not MemTable.isEmpty then begin
       but:=DeleteWarningEx('текущее объявление ?');
       if but=mrYes then begin
        MemTable.Delete;
       end;
      end; 
    end;
    VK_F5: begin
      MemTable.Refresh;
    end; 
    VK_F6: begin
    end;
    VK_F7: begin
    end;
    VK_F8: begin
    end;
    VK_UP,VK_DOWN: begin
//      Grid.SetFocus;
    end;
    VK_F9: begin
    end;
   end;
  end;
  _MainFormKeyDown(Key,Shift);
  LastKey:=Key;
end;

procedure TfmSrvImport.MemTableAfterEdit(DataSet: TDataSet);
begin
end;

procedure TfmSrvImport.GridDrawDataCell(Sender: TObject; const Rect: TRect; Field: TField; State: TGridDrawState);
begin

end;

end.
