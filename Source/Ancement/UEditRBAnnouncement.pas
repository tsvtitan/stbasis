unit UEditRBAnnouncement;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls, DBCtrls, IBCustomDataSet, Menus, tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBAnnouncement = class(TfmEditRB)
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
    lbHomePhone: TLabel;
    edHomePhone: TEdit;
    lbWorkPhone: TLabel;
    edWorkPhone: TEdit;
    lbAbout: TLabel;
    meAbout: TMemo;
    lbCopyPrint: TLabel;
    edCopyPrint: TEdit;
    udCopyPrint: TUpDown;
    cmbWord: TComboBox;
    reText: TRichEdit;
    pmRusWord: TPopupMenu;
    miRusWordAdd: TMenuItem;
    N1: TMenuItem;
    miRusWordCancel: TMenuItem;
    bibCheckRusWords: TButton;
    lbWhoIn: TLabel;
    edWhoIn: TEdit;
    lbWhoChange: TLabel;
    edWhoChange: TEdit;
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
    procedure udCopyPrintChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure edNumReleaseKeyPress(Sender: TObject; var Key: Char);
    procedure cmbWordKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure cmbWordKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure meTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure meTextKeyPress(Sender: TObject; var Key: Char);
    procedure miRusWordAddClick(Sender: TObject);
    procedure bibCheckRusWordsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edNumReleaseKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    ListBlacklist: TList;
    isCheckRusWords: Boolean;
    procedure GetAllWordsFromString(S: string; str: TStringList);
    function InBlackList(S: string; var SBlack: string; var BlackPos: Integer): Boolean;
  protected

    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;

  public
    fmParent: TForm;
    oldannouncement_id: Integer;
    release_id: Variant;
    releasedate: TDateTime;
    treeheading_id: Integer;
    aboutrelease: string;
    NumRelease: string;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;

    procedure ClearListBlackList;
    function InBlackListAllFields: Boolean;
    procedure FillListBlackList;
    procedure SetCurrentReleaseId;
    procedure FillKeyWordsWord;

    procedure SetUsers;
  end;

var
  fmEditRBAnnouncement: TfmEditRBAnnouncement;

implementation

uses UAncementCode, UAncementData, UMainUnited, URBAnnouncement,
  UAncementOptions, tsvInterbase;

type
  PInfoBlacklist=^TInfoBlacklist;
  TInfoBlacklist=packed record
    inFirst,inLast,inAll: Boolean;
    dbegin,dend: TDate;
    BlackString: string;
  end;

{$R *.DFM}

procedure TfmEditRBAnnouncement.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBAnnouncement.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
  dt: TDateTime;
  CU: TInfoConnectUser;
  curword_id: string;
  val: Integer;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try


    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.ParamCheck:=false;
    qr.Transaction.Active:=true;

    val:=cmbWord.Items.IndexOf(cmbWord.Text);
    if (val=-1)and(Trim(cmbWord.Text)<>'') then begin

     id:=inttostr(GetGenId(IBDB,tbKeyWords,1));
     sqls:='Insert into '+tbKeyWords+
           ' (word_id,treeheading_id,word) values '+
           ' ('+id+
           ','+inttostr(treeheading_id)+
           ','+QuotedStr(ChangeString(Trim(cmbWord.text),' ',''))+')';
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.ExecSQL;

    end else
      cmbWord.ItemIndex:=val;

    if (val<>-1) or(Trim(cmbWord.Text)='')then begin
     if cmbWord.ItemIndex<>-1 then
      curword_id:=inttostr(Integer(cmbWord.Items.Objects[cmbWord.ItemIndex]))
     else curword_id:='null';
    end else begin
      curword_id:=id;
    end;

    id:=inttostr(GetGenId(IBDB,tbAnnouncement,1));
    dt:=_GetDateTimeFromServer;
    FillChar(CU,SizeOf(TInfoConnectUser),0);
    _GetInfoConnectUser(@CU);
    sqls:='Insert into '+tbAnnouncement+
          ' (announcement_id,release_id,treeheading_id,word_id,textannouncement,'+
          'contactphone,homephone,workphone,copyprint,about,indate,whoin,changedate,'+
          'whochange) values '+
          ' ('+id+
          ','+inttostr(release_id)+
          ','+inttostr(treeheading_id)+
          ','+curword_id+
          ','+iff(Trim(reText.Lines.text)<>'',QuotedStr(ChangeString(Trim(reText.Lines.text),#13#10,'')),'null')+
          ','+iff(Trim(edContactPhone.text)<>'',QuotedStr(Trim(edContactPhone.text)),'null')+
          ','+iff(Trim(edHomePhone.text)<>'',QuotedStr(Trim(edHomePhone.text)),'null')+
          ','+iff(Trim(edWorkPhone.text)<>'',QuotedStr(Trim(edWorkPhone.text)),'null')+
          ','+inttostr(udCopyPrint.Position)+
          ','+iff(Trim(meAbout.Lines.text)<>'',QuotedStr(ChangeString(Trim(meAbout.Lines.text),#13#10,'')),'null')+
          ','+QuotedStr(DateTimeToStr(dt))+
          ','+QuotedStr(Trim(CU.UserName))+
          ','+QuotedStr(DateTimeToStr(dt))+
          ','+QuotedStr(Trim(CU.UserName))+
          ')';


    qr.SQL.Clear;          
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    oldannouncement_id:=strtoint(id);
    FInsertSQL:=sqls;

    TfmRBAnnouncement(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBAnnouncement(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBAnnouncement(fmParent).MainQr do begin
      Insert;
      FieldByName('announcement_id').AsInteger:=oldannouncement_id;
      FieldByName('release_id').AsInteger:=release_id;
      FieldByName('treeheading_id').AsInteger:=treeheading_id;
      if (Trim(curword_id)<>'')and(Trim(curword_id)<>'null') then begin
        FieldByName('word_id').AsInteger:=strtoint(curword_id);
        FieldByName('keywordsword').AsString:=Trim(cmbWord.Text);
      end;
//      FieldByName('release_id').AsInteger:=release_id;
//      FieldByName('releasenumrelease').AsInteger:=strtoint(edNumRelease.text);
      FieldByName('releasenumrelease').AsString:=ChangeString(edNumRelease.text,' ','');
      FieldByName('releasedaterelease').AsDateTime:=releasedate;
      if Trim(edTreeheading.Text)<>'' then begin
        FieldByName('treeheading_id').AsInteger:=treeheading_id;
        FieldByName('treeheadingnameheading').AsString:=edTreeheading.Text;
      end;
      if Trim(reText.Lines.text)<>'' then
        FieldByName('textannouncement').AsString:=ChangeString(Trim(reText.Lines.text),#13#10,'');
      if Trim(edContactPhone.text)<>'' then
        FieldByName('contactphone').AsString:=Trim(edContactPhone.text);
      if Trim(edHomePhone.text)<>'' then
        FieldByName('Homephone').AsString:=Trim(edHomePhone.text);
      if Trim(edWorkPhone.text)<>'' then
        FieldByName('Workphone').AsString:=Trim(edWorkPhone.text);

      FieldByName('copyprint').AsInteger:=udCopyPrint.Position;
      if Trim(meAbout.Lines.text)<>'' then
        FieldByName('about').AsString:=ChangeString(Trim(meAbout.Lines.text),#13#10,'');

      FieldByName('indate').AsDateTime:=dt;
      FieldByName('whoin').AsString:=Trim(CU.UserName);
      FieldByName('changedate').AsDateTime:=dt;
      FieldByName('whochange').AsString:=Trim(CU.UserName);
      Post;
    end;

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
  {$IFDEF DEBUG}
    on E: Exception do begin
      Assert(false,E.message);
    end;  
   {$ENDIF}
 end;
end;

procedure TfmEditRBAnnouncement.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBAnnouncement.UpdateRBooks: Boolean;
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
    qr.ParamCheck:=false;
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
          ', textannouncement='+iff(Trim(reText.Lines.text)<>'',QuotedStr(ChangeString(Trim(reText.Lines.text),#13#10,'')),'null')+
          ', contactphone='+iff(Trim(edContactPhone.text)<>'',QuotedStr(Trim(edContactPhone.text)),'null')+
          ', homephone='+iff(Trim(edHomePhone.text)<>'',QuotedStr(Trim(edHomePhone.text)),'null')+
          ', workphone='+iff(Trim(edWorkPhone.text)<>'',QuotedStr(Trim(edWorkPhone.text)),'null')+
          ', copyprint='+inttostr(udCopyPrint.Position)+
          ', about='+iff(Trim(meAbout.Lines.text)<>'',QuotedStr(ChangeString(Trim(meAbout.Lines.text),#13#10,'')),'null')+
          ', changedate='+QuotedStr(DateTimeToStr(dt))+
          ', whochange='+QuotedStr(Trim(CU.UserName))+
          ' where announcement_id='+id;

    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBAnnouncement(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBAnnouncement(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBAnnouncement(fmParent).MainQr do begin
      Edit;
      FieldByName('announcement_id').AsInteger:=oldannouncement_id;
      FieldByName('release_id').AsInteger:=release_id;
      FieldByName('treeheading_id').AsInteger:=treeheading_id;
      if (Trim(curword_id)<>'')and(Trim(curword_id)<>'null') then begin
        FieldByName('word_id').AsInteger:=strtoint(curword_id);
        FieldByName('keywordsword').AsString:=Trim(cmbWord.Text);
      end;
//      FieldByName('release_id').AsInteger:=release_id;
//      FieldByName('releasenumrelease').AsInteger:=strtoint(edNumRelease.text);
      FieldByName('releasenumrelease').AsString:=ChangeString(edNumRelease.text,' ','');
      FieldByName('releasedaterelease').AsDateTime:=releasedate;
      if Trim(edTreeheading.Text)<>'' then begin
        FieldByName('treeheading_id').AsInteger:=treeheading_id;
        FieldByName('treeheadingnameheading').AsString:=edTreeheading.Text;
      end;
      if Trim(reText.Lines.text)<>'' then
        FieldByName('textannouncement').AsString:=ChangeString(Trim(reText.Lines.text),#13#10,'');
      if Trim(edContactPhone.text)<>'' then
        FieldByName('contactphone').AsString:=Trim(edContactPhone.text);
      if Trim(edHomePhone.text)<>'' then
        FieldByName('Homephone').AsString:=Trim(edHomePhone.text);
      if Trim(edWorkPhone.text)<>'' then
        FieldByName('Workphone').AsString:=Trim(edWorkPhone.text);

      FieldByName('copyprint').AsInteger:=udCopyPrint.Position;
      if Trim(meAbout.Lines.text)<>'' then
        FieldByName('about').AsString:=ChangeString(Trim(meAbout.Lines.text),#13#10,'');

      FieldByName('indate').AsDateTime:=dt;
//      FieldByName('whoin').AsString:=Trim(CU.UserName);
      FieldByName('changedate').AsDateTime:=dt;
      FieldByName('whochange').AsString:=Trim(CU.UserName);
      Post;
    end;
    
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

procedure TfmEditRBAnnouncement.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBAnnouncement.CheckFieldsFill: Boolean;
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
    but:=ShowQuestionEx('∆елаете '+AnsiLowerCase(Caption)+' объ€вление содержащие исключени€ ?');
    result:=But=ID_YES;
    exit;
  end;
end;

procedure TfmEditRBAnnouncement.FormCreate(Sender: TObject);
//var
//  dt: TDateTime;
//  TCLI: TCreateLogItem;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);


  edNumRelease.MaxLength:=9;
  edNumRelease.OnKeyDown:=nil;
  edTreeheading.MaxLength:=DomainNameLength;
  cmbWord.MaxLength:=DomainSmallNameLength;
  reText.MaxLength:=2000;
  reText.Font.Assign(edContactPhone.Font);
  reText.DefAttributes.Charset:=edContactPhone.Font.Charset;
  reText.DefAttributes.Color:=edContactPhone.Font.Color;
  reText.DefAttributes.Name:=edContactPhone.Font.Name;
  reText.DefAttributes.Pitch:=edContactPhone.Font.Pitch;
  reText.DefAttributes.Size:=edContactPhone.Font.Size;
  reText.DefAttributes.Style:=edContactPhone.Font.Style;
  reText.DefAttributes.Height:=edContactPhone.Font.Height;
  reText.SelAttributes.Assign(reText.DefAttributes);

  edContactPhone.MaxLength:=DomainNameLength;
  edHomePhone.MaxLength:=DomainNameLength;
  edWorkPhone.MaxLength:=DomainNameLength;
  meAbout.MaxLength:=DomainNoteLength;


  ListBlacklist:=TList.Create;

  bibCheckRusWords.Visible:=not fmOptions.chbAnnouncementCheckRusWords.Checked;

{  dt:=_GetDateTimeFromServer;
  if dt>StrToDate('22.09.2002') then begin
    ShowWarningEx('¬рем€ платить по счетам !!!');
    TCLI.Text:='¬рем€ платить по счетам !!!';
    TCLI.TypeLogItem:=tliWarning;
    TCLI.ViewLogItemProc:=nil;
    _CreateLogItem(@TCLI);
    _ViewLog(true);
  end;}
end;

procedure TfmEditRBAnnouncement.bibNumReleaseClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  s: string;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='release_id';
  TPRBI.Locate.KeyValues:=release_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
   ChangeFlag:=true;
   release_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'release_id');
   aboutrelease:=GetFirstValueFromParamRBookInterface(@TPRBI,'about');
   s:=GetFirstValueFromParamRBookInterface(@TPRBI,'numrelease');
   NumRelease:=s;
   edNumRelease.Text:=Trim(aboutrelease)+' ('+s+')';
   releasedate:=GetFirstValueFromParamRBookInterface(@TPRBI,'daterelease');
  end;
end;

procedure TfmEditRBAnnouncement.bibTreeHeadingClick(Sender: TObject);
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
//   edTreeheading.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'nameheading');
   edTreeheading.Text:=GetTreeheadinPathNew(treeheading_id);
   FillKeyWordsWord;
   cmbWord.SetFocus;
  end;
end;

procedure TfmEditRBAnnouncement.SetCurrentReleaseId;
var
  TPRBI: TParamRBookInterface;
  s: string;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' daterelease>='+QuotedStr(DateToStr(_GetDateTimeFromServer))+' ');
  TPRBI.Condition.OrderStr:=PChar(' daterelease ');
  if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
   if ifExistsDataInPRBI(@TPRBI) then begin
     release_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'release_id');
     aboutrelease:=GetFirstValueFromParamRBookInterface(@TPRBI,'about');
     s:=GetFirstValueFromParamRBookInterface(@TPRBI,'numrelease');
     NumRelease:=s;
     edNumRelease.Text:=Trim(aboutrelease)+' ('+s+')';
     releasedate:=GetFirstValueFromParamRBookInterface(@TPRBI,'daterelease');
   end;  
  end;
end;

function TfmEditRBAnnouncement.InBlackList(S: string; var SBlack: string; var BlackPos: Integer): Boolean;
var
  i: Integer;
  P: PInfoBlacklist;
  dcurrent: TDate;
  APos: Integer;
  bs: string;
begin
    Result:=false;
    if Trim(S)='' then exit;
    dcurrent:=StrToDate(DateToStr(_GetDateTimeFromServer));
    for i:=0 to ListBlacklist.Count-1 do begin
      P:=ListBlacklist.Items[i];
      SBlack:=P.BlackString;
      if ((P.dbegin<=dcurrent)and(P.dend>=dcurrent))or
         ((P.dbegin=0)and(P.dend>=dcurrent))or
         ((P.dbegin<=dcurrent)and(P.dend=0))or
         ((P.dbegin=0)and(P.dend=0))then begin
        if P.inFirst then begin
          APos:=Pos(AnsiUpperCase(P.BlackString),AnsiUpperCase(S));
          BlackPos:=APos-1;
          bs:=Copy(S,1,APos-1);
          if (Apos=1)or((Apos>1) and (Trim(bs)='')) then begin
            Result:=true;
            exit;
          end;
        end;
        if P.inLast then begin
          APos:=Pos(AnsiUpperCase(P.BlackString),AnsiUpperCase(S));
          BlackPos:=APos-1;
          bs:=Copy(S,APos+Length(P.BlackString),Length(S)-APos-Length(P.BlackString)+1);
          if ((Apos>0)and(Apos+Length(P.BlackString)-1=Length(S)))or
             ((APos>0)and (Trim(bs)='')) then begin
            Result:=true;
            exit;
          end;
        end;
        if P.inAll then begin
          APos:=Pos(AnsiUpperCase(P.BlackString),AnsiUpperCase(S));
          BlackPos:=APos-1;
          if Apos>0 then begin
            Result:=true;
            exit;
          end;
        end;
      end;
    end;
end;

function TfmEditRBAnnouncement.InBlackListAllFields: Boolean;
var
  PosBlack: Integer;
  SBlack: string;
begin
    Result:=false;
    
    if InBlackList(reText.Lines.Text,SBlack,PosBlack) then begin
      reText.SelStart:=0;
      reText.SelLength:=Length(reText.Lines.Text);
      reText.SelAttributes.Assign(reText.DefAttributes);
      reText.SelStart:=PosBlack;
      reText.SelLength:=Length(SBlack);
      reText.SelAttributes.Color:=clBlue;
      reText.SelAttributes.Style:=[fsUnderline];
    end else begin
      reText.SelStart:=0;
      reText.SelLength:=Length(reText.Lines.Text);
      reText.SelAttributes.Assign(reText.DefAttributes);
    end;
    reText.SelStart:=0;
    reText.SelLength:=0;

    if InBlackList(edContactPhone.Text,SBlack,PosBlack) then begin
     edContactPhone.Font.Color:=clBlue;
     Result:=true;
    end else edContactPhone.Font.Color:=clWindowText;

    if InBlackList(edHomePhone.Text,SBlack,PosBlack) then begin
     edHomePhone.Font.Color:=clBlue;
     Result:=true;
    end else edHomePhone.Font.Color:=clWindowText;

    if InBlackList(edWorkPhone.Text,SBlack,PosBlack) then begin
     edWorkPhone.Font.Color:=clBlue;
     Result:=true;
    end else edWorkPhone.Font.Color:=clWindowText;
end;

procedure TfmEditRBAnnouncement.FillListBlackList;
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

procedure TfmEditRBAnnouncement.ClearListBlackList;
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
procedure TfmEditRBAnnouncement.FormDestroy(Sender: TObject);
begin
  ClearListBlackList;
  ListBlacklist.Free;
  inherited;
end;

procedure TfmEditRBAnnouncement.edContactPhoneExit(Sender: TObject);
var
  PosBlack: Integer;
  SBlack: string;
begin
  if InBlackList(TEdit(Sender).Text,SBlack,PosBlack) then begin
    TEdit(Sender).Font.Color:=clBlue;
  end else TEdit(Sender).Font.Color:=clWindowText;
end;

procedure TfmEditRBAnnouncement.meTextExit(Sender: TObject);
var
  PosBlack: Integer;
  SBlack: string;
  str: TStringList;
  i: Integer;
  TPRBI: TParamRBookInterface;
  sqls: string;
  startinc,endinc: Integer;
  isMessageBeep: Boolean;
  ctn: Integer;
begin
 if fmOptions.chbAnnouncementCheckRusWords.Checked or isCheckRusWords then begin
  str:=TStringList.Create;
  isMessageBeep:=false;
  try
   reText.SelStart:=0;
   reText.SelLength:=Length(reText.Lines.Text);
   reText.SelAttributes.Assign(reText.DefAttributes);
   reText.SelStart:=0;
   reText.SelLength:=0;
   GetAllWordsFromString(reText.Lines.Text,str);
   if str.Count>0 then begin
    for i:=0 to str.Count-1 do begin
      sqls:=sqls+'Select Count(*) as ctn from '+tbRusWords+' where Upper(name)='+QuotedStr(AnsiUpperCase(str.Strings[i]));
      if i<str.Count-1 then sqls:=sqls+' union all ';
    end;
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.SQL.Select:=Pchar(sqls);
    if _ViewInterfaceFromName(NameRbkQuery,@TPRBI) then begin
     startinc:=0;
     endinc:=0;
     GetStartAndEndByParamRBookInterface(@TPRBI,startinc,endinc);
     for i:=startinc to endinc do begin
      ctn:=GetValueByParamRBookInterface(@TPRBI,i,'ctn',varInteger);
      if ctn>0 then begin
       if InBlackList(str.Strings[i],SBlack,PosBlack) then begin
        isMessageBeep:=true;
        reText.SelStart:=Integer(str.Objects[i]);
        reText.SelLength:=Length(str.Strings[i]);
        reText.SelAttributes.Assign(reText.DefAttributes);
        reText.SelStart:=Integer(str.Objects[i]);
        reText.SelLength:=Length(str.Strings[i]);
        reText.SelAttributes.Color:=clBlue;
        reText.SelAttributes.Style:=[fsUnderline];
       end else begin
        reText.SelStart:=Integer(str.Objects[i]);
        reText.SelLength:=Length(str.Strings[i]);
        reText.SelAttributes.Assign(reText.DefAttributes);
       end;
      end else begin
       isMessageBeep:=true;
       if InBlackList(str.Strings[i],SBlack,PosBlack) then begin
        reText.SelStart:=Integer(str.Objects[i]);
        reText.SelLength:=Length(str.Strings[i]);
        reText.SelAttributes.Assign(reText.DefAttributes);
        reText.SelStart:=Integer(str.Objects[i]);
        reText.SelLength:=Length(str.Strings[i]);
        reText.SelAttributes.Color:=clBlue;
        reText.SelAttributes.Style:=[fsUnderline];
       end else begin
        reText.SelStart:=Integer(str.Objects[i]);
        reText.SelLength:=Length(str.Strings[i]);
        reText.SelAttributes.Assign(reText.DefAttributes);
        reText.SelStart:=Integer(str.Objects[i]);
        reText.SelLength:=Length(str.Strings[i]);
        reText.SelAttributes.Color:=clRed;
        reText.SelAttributes.Style:=[fsUnderline];
       end;
      end;
     end;
    end;
   end; 
  finally
   reText.SelStart:=0;
   reText.SelLength:=0;
   str.Free;
   if isMessageBeep then MessageBeep(MB_ICONQUESTION);
  end;
 end else begin
 end;

  if InBlackList(reText.Lines.Text,SBlack,PosBlack) then begin
    reText.SelStart:=PosBlack;
    reText.SelLength:=Length(SBlack);
    reText.SelAttributes.Assign(reText.DefAttributes);
    reText.SelStart:=PosBlack;
    reText.SelLength:=Length(SBlack);
    reText.SelAttributes.Color:=clBlue;
    reText.SelAttributes.Style:=[fsUnderline];
  end;
  
  reText.SelStart:=0;
  reText.SelLength:=0;
// end;

end;

procedure TfmEditRBAnnouncement.FillKeyWordsWord;
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

procedure TfmEditRBAnnouncement.cmbWordEnter(Sender: TObject);
begin
  cmbWord.DroppedDown:=true;
end;

procedure TfmEditRBAnnouncement.edNumReleaseChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAnnouncement.cmbWordKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);

  procedure ClearWord;
  begin
    cmbWord.ItemIndex:=-1;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearWord;
    VK_TAB: begin
      if Shift=[] then
        reText.SetFocus
      else if Shift=[ssSHIFT] then
        bibTreeHeading.SetFocus;
    end;
    VK_SPACE: begin
      if Shift=[] then
        reText.SetFocus;
    end;
   else begin
   end;
  end;
end;

procedure TfmEditRBAnnouncement.udCopyPrintChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAnnouncement.edNumReleaseKeyPress(Sender: TObject;
  var Key: Char);
begin
  ChangeFlag:=true;
  if (not (Key in ['0'..'9']))and
     (Key<>DecimalSeparator)and
     (Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end;
end;

procedure TfmEditRBAnnouncement.cmbWordKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Byte(Key)=VK_SPACE then begin
   Key:=#0;
   exit;
  end;
  if length(string(Key))>0 then
    Key:=AnsiUpperCase(Key)[1];
end;

procedure TfmEditRBAnnouncement.FormActivate(Sender: TObject);
begin
  if (fmOptions.chbAutoOpenTree.Checked) and (TypeEditRBook=terbAdd) then begin
     bibTreeHeadingClick(nil);
     ChangeFlag:=false;
  end;
end;

procedure TfmEditRBAnnouncement.cmbWordKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);

  function GetWordStringIndex(s: string): Integer;
  var
    i: Integer;
    APos: Integer;
  begin
    Result:=-1;
    for i:=0 to cmbWord.Items.Count-1 do begin
      APos:=AnsiPos(AnsiUpperCase(s),AnsiUpperCase(cmbWord.Items.Strings[i]));
      if Apos=1 then begin
        Result:=i;
        exit;
      end;
    end;
  end;

var
  val: Integer;
  s: string;
begin
   case Key of
    VK_DELETE,VK_BACK,VK_TAB,VK_RETURN,
    VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN:;
    else begin
     S:=Copy(cmbWord.Text,1,cmbWord.SelStart);
     val:=GetWordStringIndex(S);
     if val<>-1 then begin
      cmbWord.Text:=cmbWord.Items.Strings[val];
      cmbWord.SelStart:=Length(s);
      cmbWord.SelLength:=Length(cmbWord.Text)-cmbWord.SelStart;
     end;
    end; 
   end; 
end;

procedure TfmEditRBAnnouncement.meTextKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key=VK_ESCAPE then Close;
end;

procedure TfmEditRBAnnouncement.meTextKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Byte(Key)=VK_RETURN then Key:=#0;
end;

procedure TfmEditRBAnnouncement.GetAllWordsFromString(S: string; str: TStringList);
var
  Pos: Integer;
  word: string;
  incPos: Integer;
  isInc: Boolean;
const
  Separators: set of char = [#00,' ','-',#13, #10,'.',',','/','\', '#', '"', '''','!','?','$','@',
                             ':','+','%','*','(',')',';','=','{','}','[',']', '{', '}', '<', '>'];
begin
  if Trim(S)='' then exit;
  incPos:=0;
  while true do begin
    Pos:=1;
    word:=GetFirstWord(s,Separators,Pos);
    if (s[Pos]=#13)or(s[Pos]=#10) then
      isInc:=false
    else isInc:=true;

    s:=Copy(s,Pos+1,Length(s)-Pos);
    if (Trim(word)<>'')and
       not IsInteger(Trim(word)) and
       (Length(word)>1) then
          str.AddObject(word,TObject(Pointer(incPos)));
    if Trim(s)='' then exit;

    if isInc then
     incPos:=incPos+Pos;
  end;
end;

procedure TfmEditRBAnnouncement.miRusWordAddClick(Sender: TObject);
var
  str: TStringList;
  isFound: Boolean;
  word: string;
  i,PosS: Integer;
  id: string;
begin
  str:=TStringList.Create;
  try
   GetAllWordsFromString(reText.Lines.Text,str);
   isFound:=false;
   for i:=0 to str.Count-1 do begin
     PosS:=Integer(str.Objects[i]);
     if (reText.SelStart>=PosS)and(reText.SelStart<=PosS+Length(str.Strings[i])) then begin
       word:=str.Strings[i];
       isFound:=true;
       break;
     end;
   end;
   try
    if isFound then begin
     id:=inttostr(GetGenId(IBDB,tbRusWords,1));
     ExecSql(IBDB,'Insert into '+tbRusWords+' (rusword_id,name) values ('+id+','+QuotedStr(AnsiLowerCase(word))+')');
    end;
   except
    on E: EIBInterBaseError do begin
     TempStr:=TranslateIBError(E.Message);
     ShowErrorEx(TempStr);
     Assert(false,TempStr);
    end;
   end;
  finally
    str.Free;
  end;
end;

procedure TfmEditRBAnnouncement.bibCheckRusWordsClick(Sender: TObject);
begin
  isCheckRusWords:=true;
  meTextExit(nil);
  isCheckRusWords:=false;
end;


procedure TfmEditRBAnnouncement.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  ///  inherited;

end;

procedure TfmEditRBAnnouncement.edNumReleaseKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edNumRelease.Text:='';
    release_id:=Unassigned;
    NumRelease:='';
    aboutrelease:='';
  end;
end;

procedure TfmEditRBAnnouncement.SetUsers;
var
  CU: TInfoConnectUser;
begin
  FillChar(CU,SizeOf(TInfoConnectUser),0);
  _GetInfoConnectUser(@CU);
  edWhoIn.Text:=CU.UserName;
  edWhoChange.Text:=CU.UserName;
end;

end.
