unit UEditRBAnnouncementDubl;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls, DBCtrls, IBCustomDataSet, tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBAnnouncementDubl = class(TfmEditRB)
    lbNumRelease: TLabel;
    edNumRelease: TEdit;
    bibNumRelease: TButton;
    lbTreeHeading: TLabel;
    edTreeheading: TEdit;
    bibTreeHeading: TButton;
    lbContactPhone: TLabel;
    edContactPhone: TEdit;
    lbWord: TLabel;
    lbtext: TLabel;
    meText: TMemo;
    lbHomePhone: TLabel;
    edHomePhone: TEdit;
    lbWorkPhone: TLabel;
    edWorkPhone: TEdit;
    lbAbout: TLabel;
    meAbout: TMemo;
    lbCopyPrint: TLabel;
    edCopyPrint: TEdit;
    udCopyPrint: TUpDown;
    IBQKeywords: TIBQuery;
    cmbWord: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure bibNumReleaseClick(Sender: TObject);
    procedure bibTreeHeadingClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edContactPhoneExit(Sender: TObject);
    procedure meTextExit(Sender: TObject);
    procedure cmbWordEnter(Sender: TObject);
    procedure edNumReleaseChange(Sender: TObject);
    procedure cmbWordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    ListBlacklist: TList;
    function InBlackList(S: string): Boolean;
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;

  public
    oldannouncement_id: Integer;
    release_id: Integer;
    treeheading_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;

    procedure ClearListBlackList;
    function InBlackListAllFields: Boolean;
    procedure FillListBlackList;
    procedure SetCurrentReleaseId;
    procedure FillKeyWordsWord;
  end;

var
  fmEditRBAnnouncementDubl: TfmEditRBAnnouncementDubl;

implementation

uses UAncementCode, UAncementData, UMainUnited;

type
  PInfoBlacklist=^TInfoBlacklist;
  TInfoBlacklist=packed record
    inFirst,inLast,inAll: Boolean;
    dbegin,dend: TDate;
    BlackString: string;
  end;

{$R *.DFM}

procedure TfmEditRBAnnouncementDubl.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBAnnouncementDubl.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
  dt: TDateTime;
  CU: TInfoConnectUser;
  curword_id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbAnnouncement,1));
    dt:=_GetDateTimeFromServer;
    FillChar(CU,SizeOf(TInfoConnectUser),0);
    _GetInfoConnectUser(@CU);
    if cmbWord.ItemIndex<>-1 then
      curword_id:=inttostr(Integer(cmbWord.Items.Objects[cmbWord.ItemIndex]))
    else curword_id:='null';
    sqls:='Insert into '+tbAnnouncement+
          ' (announcement_id,release_id,treeheading_id,word_id,textannouncement,'+
          'contactphone,homephone,workphone,copyprint,about,indate,whoin,changedate,'+
          'whochange) values '+
          ' ('+id+
          ','+inttostr(release_id)+
          ','+inttostr(treeheading_id)+
          ','+curword_id+
          ','+iff(Trim(meText.Lines.text)<>'',QuotedStr(Trim(meText.Lines.text)),'null')+
          ','+iff(Trim(edContactPhone.text)<>'',QuotedStr(Trim(edContactPhone.text)),'null')+
          ','+iff(Trim(edHomePhone.text)<>'',QuotedStr(Trim(edHomePhone.text)),'null')+
          ','+iff(Trim(edWorkPhone.text)<>'',QuotedStr(Trim(edWorkPhone.text)),'null')+
          ','+inttostr(udCopyPrint.Position)+
          ','+iff(Trim(meAbout.Lines.text)<>'',QuotedStr(Trim(meAbout.Lines.text)),'null')+
          ','+QuotedStr(DateTimeToStr(dt))+
          ','+QuotedStr(Trim(CU.UserName))+
          ','+QuotedStr(DateTimeToStr(dt))+
          ','+QuotedStr(Trim(CU.UserName))+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldannouncement_id:=strtoint(id);

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBAnnouncementDubl.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBAnnouncementDubl.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
  dt: TDateTime;
  CU: TInfoConnectUser;
  curword_id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(oldannouncement_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    dt:=_GetDateTimeFromServer;
    FillChar(CU,SizeOf(TInfoConnectUser),0);
    _GetInfoConnectUser(@CU);
    if cmbWord.ItemIndex<>-1 then
      curword_id:=inttostr(Integer(cmbWord.Items.Objects[cmbWord.ItemIndex]))
    else curword_id:='null';
    sqls:='Update '+tbAnnouncement+
          ' set release_id='+inttostr(release_id)+
          ', treeheading_id='+inttostr(treeheading_id)+
          ', word_id='+curword_id+
          ', textannouncement='+iff(Trim(meText.Lines.text)<>'',QuotedStr(Trim(meText.Lines.text)),'null')+
          ', contactphone='+iff(Trim(edContactPhone.text)<>'',QuotedStr(Trim(edContactPhone.text)),'null')+
          ', homephone='+iff(Trim(edHomePhone.text)<>'',QuotedStr(Trim(edHomePhone.text)),'null')+
          ', workphone='+iff(Trim(edWorkPhone.text)<>'',QuotedStr(Trim(edWorkPhone.text)),'null')+
          ', copyprint='+inttostr(udCopyPrint.Position)+
          ', about='+iff(Trim(meAbout.Lines.text)<>'',QuotedStr(Trim(meAbout.Lines.text)),'null')+
          ', changedate='+QuotedStr(DateTimeToStr(dt))+
          ', whochange='+QuotedStr(Trim(CU.UserName))+
          ' where announcement_id='+id;

    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBAnnouncementDubl.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBAnnouncementDubl.CheckFieldsFill: Boolean;
var
  but: Integer;
begin
  Result:=true;
  if trim(edNumRelease.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNumRelease.Caption]));
    bibNumRelease.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edTreeheading.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTreeheading.Caption]));
    bibTreeheading.SetFocus;
    Result:=false;
    exit;
  end;
  ClearListBlackList;
  FillListBlackList;
  if InBlackListAllFields then begin
    but:=ShowQuestionEx('Желаете '+AnsiLowerCase(Caption)+' объявление содержащие исключения ?');
    result:=But=ID_YES;
    exit;
  end;
end;

procedure TfmEditRBAnnouncementDubl.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);


  edNumRelease.MaxLength:=9;
  edTreeheading.MaxLength:=DomainNameLength;
  cmbWord.MaxLength:=DomainSmallNameLength;
  meText.MaxLength:=2000;
  edContactPhone.MaxLength:=DomainNameLength;
  edHomePhone.MaxLength:=DomainNameLength;
  edWorkPhone.MaxLength:=DomainNameLength;
  meAbout.MaxLength:=DomainNoteLength;

  ListBlacklist:=TList.Create;

  
end;

procedure TfmEditRBAnnouncementDubl.bibNumReleaseClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='release_id';
  TPRBI.Locate.KeyValues:=release_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
   ChangeFlag:=true;
   release_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'release_id');
   edNumRelease.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'numrelease');
  end;
end;

procedure TfmEditRBAnnouncementDubl.bibTreeHeadingClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='treeheading_id';
  TPRBI.Locate.KeyValues:=treeheading_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTreeHeading,@TPRBI) then begin
   ChangeFlag:=true;
   treeheading_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'treeheading_id');
   edTreeheading.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'nameheading');
   FillKeyWordsWord;
  end;
end;

procedure TfmEditRBAnnouncementDubl.SetCurrentReleaseId;
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' daterelease>='+QuotedStr(DateToStr(_GetDateTimeFromServer))+' ');
  TPRBI.Condition.OrderStr:=PChar(' daterelease ');
  if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
   release_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'release_id');
   edNumRelease.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'numrelease');
  end;
end;

function TfmEditRBAnnouncementDubl.InBlackList(S: string): Boolean;
var
  i: Integer;
  P: PInfoBlacklist;
  dcurrent: TDate;
  APos: Integer;
begin
    Result:=false;
    dcurrent:=StrToDate(DateToStr(_GetDateTimeFromServer));
    for i:=0 to ListBlacklist.Count-1 do begin
      P:=ListBlacklist.Items[i];
      if ((P.dbegin<=dcurrent)and(P.dend>=dcurrent))or
         ((P.dbegin=0)and(P.dend>=dcurrent))or
         ((P.dbegin<=dcurrent)and(P.dend=0))or
         ((P.dbegin=0)and(P.dend=0))then begin
        if P.inFirst then begin
          APos:=Pos(AnsiUpperCase(P.BlackString),AnsiUpperCase(S));
          if Apos=1 then begin
            Result:=true;
            exit;
          end;
        end;
        if P.inLast then begin
          APos:=Pos(AnsiUpperCase(P.BlackString),AnsiUpperCase(S));
          if (Apos>0)and(Apos+Length(P.BlackString)-1=Length(S)) then begin
            Result:=true;
            exit;
          end;
        end;
        if P.inAll then begin
          APos:=Pos(AnsiUpperCase(P.BlackString),AnsiUpperCase(S));
          if Apos>0 then begin
            Result:=true;
            exit;
          end;
        end;
      end;
    end;
end;

function TfmEditRBAnnouncementDubl.InBlackListAllFields: Boolean;
begin
    Result:=false;
    
    if InBlackList(Trim(meText.Lines.Text)) then begin
     meText.Font.Color:=clRed;
     Result:=true;
    end else meText.Font.Color:=clWindowText;

    if InBlackList(Trim(edContactPhone.Text)) then begin
     edContactPhone.Font.Color:=clRed;
     Result:=true;
    end else edContactPhone.Font.Color:=clWindowText;

    if InBlackList(Trim(edHomePhone.Text)) then begin
     edHomePhone.Font.Color:=clRed;
     Result:=true;
    end else edHomePhone.Font.Color:=clWindowText;

    if InBlackList(Trim(edWorkPhone.Text)) then begin
     edWorkPhone.Font.Color:=clRed;
     Result:=true;
    end else edWorkPhone.Font.Color:=clWindowText;
end;

procedure TfmEditRBAnnouncementDubl.FillListBlackList;
var
  TPRBI: TParamRBookInterface;

  procedure GetStartAndAnd(var startinc,endinc: Integer);
  var
    dx: Integer;
  begin
    dx:=High(TPRBI.Result)-Low(TPRBI.Result);
    if dx=0 then exit;
    startinc:=Low(TPRBI.Result[Low(TPRBI.Result)].Values);
    endinc:=High(TPRBI.Result[Low(TPRBI.Result)].Values);
  end;

  function GetNextValue(Index: Integer; FieldName: Variant; ValueType: Word): Variant;
  var
    i: Integer;
  begin
    Result:='';
    for i:=Low(TPRBI.Result) to High(TPRBI.Result) do begin
      if AnsiUpperCase(TPRBI.Result[i].FieldName)=AnsiUpperCase(FieldName) then begin
        Result:=TPRBI.Result[i].Values[Index];
        case ValueType of
           varDate: begin
             if VarType(Result)= varNull then
               Result:=0;
           end;
        end;
        exit;
      end;
    end;
  end;

var
  i: Integer;
  startinc,endinc: integer;
  P: PInfoBlacklist;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  if _ViewInterfaceFromName(NameRbkBlackList,@TPRBI) then begin
    startinc:=0;
    endinc:=0;
    GetStartAndAnd(startinc,endinc);
    for i:=startinc to endinc do begin
      New(P);
      FillChar(P^,SizeOf(TInfoBlacklist),0);
      P.inFirst:=GetNextValue(i,'infirst',varBoolean);
      P.inLast:=GetNextValue(i,'inlast',varBoolean);
      P.inAll:=GetNextValue(i,'inall',varBoolean);
      P.BlackString:=GetNextValue(i,'blackstring',varString);
      P.dbegin:=GetNextValue(i,'datebegin',varDate);
      P.dend:=GetNextValue(i,'dateend',varDate);
      ListBlacklist.Add(P);
    end;  
  end;
end;

procedure TfmEditRBAnnouncementDubl.ClearListBlackList;
var
  i: Integer;
  P: PInfoBlacklist;
begin
  for i:=0 to ListBlacklist.Count-1 do begin
    P:=ListBlacklist.Items[i];
    Dispose(P);
  end;
  ListBlacklist.Clear;
end;
procedure TfmEditRBAnnouncementDubl.FormDestroy(Sender: TObject);
begin
  ClearListBlackList;
  ListBlacklist.Free;
  inherited;
end;

procedure TfmEditRBAnnouncementDubl.edContactPhoneExit(Sender: TObject);
begin
  if InBlackList(Trim(TEdit(Sender).Text)) then begin
    TEdit(Sender).Font.Color:=clRed;
  end else TEdit(Sender).Font.Color:=clWindowText;
end;

procedure TfmEditRBAnnouncementDubl.meTextExit(Sender: TObject);
begin
  if InBlackList(Trim(meText.Lines.Text)) then begin
    meText.Font.Color:=clRed;
  end else meText.Font.Color:=clWindowText;
end;

procedure TfmEditRBAnnouncementDubl.FillKeyWordsWord;
var
  TPRBI: TParamRBookInterface;

  procedure GetStartAndAnd(var startinc,endinc: Integer);
  var
    dx: Integer;
  begin
    dx:=High(TPRBI.Result)-Low(TPRBI.Result);
    if dx=0 then exit;
    startinc:=Low(TPRBI.Result[Low(TPRBI.Result)].Values);
    endinc:=High(TPRBI.Result[Low(TPRBI.Result)].Values);
  end;

  function GetNextValue(Index: Integer; FieldName: Variant; ValueType: Word): Variant;
  var
    i: Integer;
  begin
    Result:='';
    for i:=Low(TPRBI.Result) to High(TPRBI.Result) do begin
      if AnsiUpperCase(TPRBI.Result[i].FieldName)=AnsiUpperCase(FieldName) then begin
        Result:=TPRBI.Result[i].Values[Index];
        case ValueType of
           varDate: begin
             if VarType(Result)= varNull then
               Result:=0;
           end;
        end;
        exit;
      end;
    end;
  end;
  
var
   startinc,endinc: Integer;
   i: Integer;
   curword_id: Integer;
begin
   cmbWord.Items.BeginUpdate;
   try
     cmbWord.Items.Clear;
     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tviOnlyData;
     TPRBI.Condition.WhereStr:=PChar(' '+tbKeyWords+'.treeheading_id='+inttostr(treeheading_id)+' ');
     TPRBI.Condition.OrderStr:=PChar(' word ');
     if _ViewInterfaceFromName(NameRbkKeyWords,@TPRBI) then begin
       startinc:=0;
       endinc:=0;
       GetStartAndAnd(startinc,endinc);
       for i:=startinc to endinc do begin
         curword_id:=GetNextValue(i,'word_id',varInteger);
         cmbWord.Items.AddObject(GetNextValue(i,'word',varString),TObject(curword_id));
       end;
     end;
   finally
     cmbWord.Items.EndUpdate;
   end;
end;

procedure TfmEditRBAnnouncementDubl.cmbWordEnter(Sender: TObject);
begin
  cmbWord.DroppedDown:=true;
end;

procedure TfmEditRBAnnouncementDubl.edNumReleaseChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAnnouncementDubl.cmbWordKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);

  procedure ClearWord;
  begin
    cmbWord.ItemIndex:=-1;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearWord;
  end;
end;

end.
