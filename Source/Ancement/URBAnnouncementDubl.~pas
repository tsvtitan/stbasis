unit URBAnnouncementDubl;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, UMainUnited,
  DBClient, Provider, Grids, RxMemDS, DBTables, MemTable, RxQuery,
  IBUpdateSQL, RXDBCtrl, Spin, rmLibrary;

type
    PDubl=^TDubl;
    TDubl=packed record
        WorkPhone: String;
        ContactPhone: String;
        HomePhone: String;
        ListParent: TList;
        List: TList;
        id:Integer;
        Hash: Integer;
        CountChar:Integer;
        keyword: String;
    end;


    TfmRBAnnouncementDubl = class(TfmRBMainGrid)
    qr: TIBQuery;
    IBTransaction: TIBTransaction;
    qrFind: TIBQuery;
    IBTrFind: TIBTransaction;
    DSFind: TDataSource;
    bibFind: TButton;
    bibNextDubl: TButton;
    bibPrevDubl: TButton;
    DS1: TDataSource;
    MemDS: TRxMemoryData;
    MemoryTable1: TMemoryTable;
    lbNumRelease: TLabel;
    edNumRelease: TEdit;
    bibNumRelease: TButton;
    ds2: TDataSource;
    IBQr: TQuery;
    ds3: TDataSource;
    pnTreePath: TPanel;
    lbTreePath: TLabel;
    edTreePath: TEdit;
    CBtreeheadingnameheading: TCheckBox;
    SEPercent: TSpinEdit;
    Label2: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bibFindClick(Sender: TObject);
    procedure ShowDubl(Sender: TObject);
    procedure bibNextDublClick(Sender: TObject);
    procedure bibPrevDublClick(Sender: TObject);
    procedure bibNumReleaseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MemDSAfterScroll(DataSet: TDataSet);
    procedure RxDBGrid1GetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure SEPercentChange(Sender: TObject);
    procedure CBtreeheadingnameheadingClick(Sender: TObject);

  private
    NoteRelease: string;
    isFindReleaseNumrelease,isFindTreeHeadingNameHeading,isFindTextAnnouncementDubl,
    isFindContactPhone,isFindHomePhone,isFindWorkPhone,isFindKeyWordsWord: Boolean;

    FindReleaseNumrelease, FindTreeHeadingNameHeading, FindTextAnnouncementDubl,
    FindContactPhone, FindHomePhone, FindWorkPhone, FindKeyWordsWord: String;

    FindReleaseNumrelease_id:Integer;

    Listmain{,ListTree}: TList; //Для хранения дублированных записей
    CountDoubl: Integer;
{    PBHandle: LongWord;  }
{    FCurFreeProgressBar: THandle;  }
{    ListProgressBars: TList; }
//    P : PDubl;
    sql:String;
    CountItem:Integer;
//    MemDS: TRxMemoryData;
{    MemTab: TMemoryTable;   }
        RxDBGrid1: TRxDBGrid;
    RevNext: Bool;
    Color_:Bool;
  {  isFind:Bool;     }
    FindStr:string;
    IDs:  array[1..2000] of Integer;
    id_count:Integer;
    procedure SetCurrentReleaseId;
    procedure ClearList(List: TList);
    procedure AddToList( ListParent: TList;
                       WorkPhone: String;
                       ContactPhone: String;
                       HomePhone: String;
                       List: TList;
                       id:Integer;
                       Hash: Integer;
                       CountChar:Integer;
                       keyword: String);
   procedure AddFromQuery(List: TList);


  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
    procedure ViewCount;override;
  public
    procedure InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);override;
    procedure ActiveQuery(CheckPerm: Boolean);override;
    procedure ShowingChanged; override;
  end;

var
  fmRBAnnouncementDubl: TfmRBAnnouncementDubl;


implementation

uses  UAncementCode, UAncementDM, UAncementData, UEditRBAnnouncementDubl,URptThread,comobj,ActiveX,
  UAncementOptions, URBAnnouncement;


{$R *.DFM}

procedure TfmRBAnnouncementDubl.FormCreate(Sender: TObject);
var
  cl: TColumn;
  i:integer;
begin
 inherited;
 try
  RevNext:=true;
  Caption:=NameRbkAnnouncementDubl;
//  MemDS:=TRxMemoryData.Create(nil);
//  MemTab:=TMemoryTable.Create(nil);
//  MemTab.TableName:='DublList';
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  MemDS.FieldDefs.Add('ANNOUNCEMENT_ID',ftInteger,0,false);
  MemDS.FieldDefs.Add('treeheading_id',ftInteger,0,false);
  MemDS.FieldDefs.Add('release_id',ftInteger,0,false);

  RxDBGrid1:=TRxDBGrid.Create(nil);
  RxDBGrid1.parent:=pnGrid;
  RxDBGrid1.Align:=alClient;
  RxDBGrid1.OnGetCellParams:=fmRBAnnouncementDubl.RxDBGrid1GetCellParams;

  Grid.Visible:=false;

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='Percent';
  cl.Title.Caption:='Похожесть';
  cl.Width:=60;
  MemDS.FieldDefs.Add('Percent',ftInteger,0,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='releasenumrelease';
  cl.Title.Caption:='Выпуск';
  cl.Width:=50;
  MemDS.FieldDefs.Add('releasenumrelease',ftInteger,0,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='releasedaterelease';
  cl.Title.Caption:='Дата выпуска';
  cl.Width:=70;
  MemDS.FieldDefs.Add('releasedaterelease',ftDate,0,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='treeheadingnameheading';
  cl.Title.Caption:='Рубрика';
  cl.Width:=100;
  MemDS.FieldDefs.Add('treeheadingnameheading',ftString,250,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='hash';
  cl.Title.Caption:='CRC32';
  cl.Width:=40;
  MemDS.FieldDefs.Add('hash',ftInteger,0,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='keywordsword';
  cl.Title.Caption:='Ключевое слово';
  cl.Width:=100;
  MemDS.FieldDefs.Add('keywordsword',ftString,30,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='textannouncement';
  cl.Title.Caption:='Текст объявления';
  cl.Width:=150;
  MemDS.FieldDefs.Add('textannouncement',ftString,2000,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='contactphone';
  cl.Title.Caption:='Контактный телефон';
  cl.Width:=60;
  MemDS.FieldDefs.Add('contactphone',ftString,200,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='homephone';
  cl.Title.Caption:='Домашний телефон';
  cl.Width:=60;
  MemDS.FieldDefs.Add('homephone',ftString,200,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='workphone';
  cl.Title.Caption:='Рабочий телефон';
  cl.Width:=60;
  MemDS.FieldDefs.Add('workphone',ftString,200,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='copyprint';
  cl.Title.Caption:='Количество выпусков';
  cl.Width:=60;
  MemDS.FieldDefs.Add('copyprint',ftInteger,0,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='about';
  cl.Title.Caption:='Примечание';
  cl.Width:=60;
  MemDS.FieldDefs.Add('about',ftString,255,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='indate';
  cl.Title.Caption:='Дата ввода';
  cl.Width:=60;
  MemDS.FieldDefs.Add('indate',ftDate,0,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='whoin';
  cl.Title.Caption:='Кто ввел';
  cl.Width:=60;
  MemDS.FieldDefs.Add('whoin',ftString,128,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='changedate';
  cl.Title.Caption:='Дата изменения';
  cl.Width:=60;
  MemDS.FieldDefs.Add('changedate',ftDate,0,false);

  cl:=RxDBGrid1.Columns.Add;
  cl.FieldName:='whochange';
  cl.Title.Caption:='Кто изменял';
  cl.Width:=60;
  MemDS.FieldDefs.Add('whochange',ftString,128,false);


  RxDBGrid1.TabOrder:=1;
  pnTreePath.TabOrder:=2;
  pnTreePath.Visible:=fmOptions.chbAnnouncementTreePath.Checked;
  ShowingChanged;

  LoadFromIni;

  SetCurrentReleaseId;

  Listmain:=TList.Create;


  qr.Database:=IBDB;
  IBTransaction.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTransaction);
//  qr.Active:=true;

  for i:=1 to 2000 do
    begin
     IDs[i]:=0;
    end;
  id_count:=1;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAnnouncementDubl.FormDestroy(Sender: TObject);
begin
  MemDS.Free;
//  MemTab.Free;
  inherited;

  if FormState=[fsCreatedMDIChild] then
   fmRBAnnouncementDubl:=nil;
end;

function TfmRBAnnouncementDubl.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkAnnouncementDubl+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBAnnouncementDubl.ActiveQuery(CheckPerm: Boolean);
{var
 sqls: String;}
begin
 try
{
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  Mainqr.DisableControls;
  try
   Mainqr.sql.Clear;
   sqls:=GetSql;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindReleaseNumrelease or isFindTreeHeadingNameHeading  or
                  isFindTextAnnouncementDubl or isFindContactPhone  or isFindHomePhone or
                  isFindWorkPhone or isFindKeyWordsWord);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end; }
 except
  {$IFDEF DEBUG}
    on E: Exception do Assert(false,E.message);
  {$ENDIF}
 end;
end;

procedure TfmRBAnnouncementDubl.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('announcement_id').asString;
   if UpperCase(fn)=UpperCase('releasenumrelease') then fn:='r.numrelease';
   if UpperCase(fn)=UpperCase('releasedaterelease') then fn:='r.daterelease';
   if UpperCase(fn)=UpperCase('treeheadingnameheading') then fn:='t.nameheading';
   if UpperCase(fn)=UpperCase('keywordsword') then fn:='k.word';
   if UpperCase(fn)=UpperCase('about') then fn:='a.about';
   if UpperCase(fn)=UpperCase('textannouncement') then begin
     exit;
   end;

   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('announcement_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAnnouncementDubl.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBAnnouncementDubl.LoadFromIni;
begin
 inherited;
 try
    FindReleaseNumrelease:=ReadParam(ClassName,'ReleaseNumrelease',FindReleaseNumrelease);
    FindTreeHeadingNameHeading:=ReadParam(ClassName,'TreeHeadingNameHeading',FindTreeHeadingNameHeading);
    FindTextAnnouncementDubl:=ReadParam(ClassName,'TextAnnouncement',FindTextAnnouncementDubl);
    FindContactPhone:=ReadParam(ClassName,'ContactPhone',FindContactPhone);
    FindHomePhone:=ReadParam(ClassName,'HomePhone',FindHomePhone);
    FindWorkPhone:=ReadParam(ClassName,'WorkPhone',FindWorkPhone);
    FindKeyWordsWord:=ReadParam(ClassName,'KeyWordsWord',FindKeyWordsWord);

    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAnnouncementDubl.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'ReleaseNumrelease',FindReleaseNumrelease);
    WriteParam(ClassName,'TreeHeadingNameHeading',FindTreeHeadingNameHeading);
    WriteParam(ClassName,'TextAnnouncement',FindTextAnnouncementDubl);
    WriteParam(ClassName,'ContactPhone',FindContactPhone);
    WriteParam(ClassName,'HomePhone',FindHomePhone);
    WriteParam(ClassName,'WorkPhone',FindWorkPhone);
    WriteParam(ClassName,'KeyWordsWord',FindKeyWordsWord);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAnnouncementDubl.bibRefreshClick(Sender: TObject);
begin
//  ActiveQuery(true);
end;

procedure TfmRBAnnouncementDubl.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBAnnouncementDubl;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBAnnouncementDubl.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    fm.ActiveControl:=fm.bibTreeHeading;
    fm.ClearListBlackList;
    fm.FillListBlackList;
    fm.InBlackListAllFields;
    fm.SetCurrentReleaseid;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('announcement_id',fm.oldannouncement_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAnnouncementDubl.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBAnnouncementDubl;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBAnnouncementDubl.Create(nil);
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.edNumRelease.Text:=Mainqr.fieldByName('releasenumrelease').AsString;
    fm.release_id:=Mainqr.fieldByName('release_id').AsInteger;
    fm.edTreeheading.Text:=Mainqr.fieldByName('treeheadingnameheading').AsString;
    fm.treeheading_id:=Mainqr.fieldByName('treeheading_id').AsInteger;
    fm.FillKeyWordsWord;
    fm.cmbWord.ItemIndex:=fm.cmbWord.Items.IndexOf(Mainqr.fieldByName('keywordsword').AsString);
    fm.meText.Lines.Text:=Mainqr.fieldByName('textannouncement').AsString;
    fm.edContactPhone.Text:=Mainqr.fieldByName('contactphone').AsString;
    fm.edHomePhone.Text:=Mainqr.fieldByName('homephone').AsString;
    fm.edWorkPhone.Text:=Mainqr.fieldByName('workphone').AsString;
    fm.meAbout.Lines.Text:=Mainqr.fieldByName('about').AsString;
    fm.udCopyPrint.Position:=Mainqr.fieldByName('copyprint').AsInteger;
    fm.oldannouncement_id:=Mainqr.fieldByName('announcement_id').AsInteger;

    fm.ClearListBlackList;
    fm.FillListBlackList;
    fm.InBlackListAllFields;

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('announcement_id',fm.oldannouncement_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAnnouncementDubl.bibDelClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
    tmpid:integer;
    pos :integer;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   try
    result:=false;
    try
     qr.Database:=IBDB;
     qr.Transaction:=IBTran;
     qr.Transaction.Active:=true;
     tmpid := MemDS.FieldByName('announcement_id').asInteger;
     sqls:='Delete from '+tbAnnouncement+' where announcement_id='+ IntToStr(tmpid);
     qr.sql.Add(sqls);
     qr.ExecSQL;


      pos := MemDs.RecNo;
      Grid.DataSource:=nil;
      RxDBGrid1.DataSource:=nil;
      MemDs.First;
      while (not MemDS.Eof) do
      begin
        if (MemDS.FieldByName('announcement_id').asInteger = tmpid) then
        MemDS.Delete;
        MemDS.Next;
      end;
//      Grid.DataSource:=ds1;
      RxDBGrid1.DataSource:=ds1;
      MemDS.First;
      MemDS.MoveBy(pos-1);
      MemDS.MoveBy(5);
      MemDS.MoveBy(-5);
      lbCount.Caption:= 'Всего найдено: '+ IntToStr(MemDS.RecordCount);
      qr.Transaction.Commit;
//     ActiveQuery(false);
     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if MemDS.RecordCount=0 then exit;
   MemDS.AfterScroll:=nil;
  but:=DeleteWarningEx('текущее объявление ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end
    else
//       MemDS.Delete;
  end;
   MemDS.AfterScroll:=MemDSAfterScroll;
   MemDSAfterScroll(MemDS);   
  //ShowDubl(Sender);
end;

procedure TfmRBAnnouncementDubl.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBAnnouncementDubl;
begin
  if not MemDS.Active then exit;
//  if MemDS.IsEmpty then exit;
  fm:=TfmEditRBAnnouncementDubl.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.edNumRelease.Text:=MemDS.fieldByName('releasenumrelease').AsString;
    fm.release_id:=MemDS.fieldByName('release_id').AsInteger;
    fm.edTreeheading.Text:=MemDS.fieldByName('treeheadingnameheading').AsString;
    fm.treeheading_id:=MemDS.fieldByName('treeheading_id').AsInteger;
    fm.FillKeyWordsWord;
    fm.cmbWord.ItemIndex:=fm.cmbWord.Items.IndexOf(MemDS.fieldByName('keywordsword').AsString);
    fm.meText.Lines.Text:=MemDS.fieldByName('textannouncement').AsString;
    fm.edContactPhone.Text:=MemDS.fieldByName('contactphone').AsString;
    fm.edHomePhone.Text:=MemDS.fieldByName('homephone').AsString;
    fm.edWorkPhone.Text:=MemDS.fieldByName('workphone').AsString;
    fm.meAbout.Lines.Text:=MemDS.fieldByName('about').AsString;
    fm.udCopyPrint.Position:=MemDS.fieldByName('copyprint').AsInteger;
    fm.oldannouncement_id:=MemDS.fieldByName('announcement_id').AsInteger;

    fm.ClearListBlackList;
    fm.FillListBlackList;
    fm.InBlackListAllFields;

    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAnnouncementDubl.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBAnnouncementDubl;
  filstr: string;
begin
 fm:=TfmEditRBAnnouncementDubl.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  fm.edNumRelease.ReadOnly:=false;
  fm.edNumRelease.Color:=clWindow;
  fm.cmbWord.Style:=csDropDown;

  fm.edTreeheading.ReadOnly:=false;
  fm.edTreeheading.Color:=clWindow;

  fm.lbAbout.Enabled:=false;
  fm.meAbout.Enabled:=false;
  fm.meAbout.Color:=clBtnface;
  fm.lbCopyPrint.Enabled:=false;
  fm.edCopyPrint.Enabled:=false;
  fm.edCopyPrint.Color:=clbtnFace;
  fm.udCopyPrint.Enabled:=false;

  if Trim(FindReleaseNumrelease)<>'' then fm.edNumRelease.Text:=FindReleaseNumrelease;
  if Trim(FindTreeHeadingNameHeading)<>'' then fm.edTreeheading.Text:=FindTreeHeadingNameHeading;
  if Trim(FindTextAnnouncementDubl)<>'' then fm.meText.Lines.Text:=FindTextAnnouncementDubl;
  if Trim(FindContactPhone)<>'' then fm.edContactPhone.Text:=FindContactPhone;
  if Trim(FindHomePhone)<>'' then fm.edHomePhone.Text:=FindHomePhone;
  if Trim(FindWorkPhone)<>'' then fm.edWorkPhone.Text:=FindWorkPhone;
  if Trim(FindKeyWordsWord)<>'' then fm.cmbWord.Text:=FindKeyWordsWord;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ClearListBlackList;
  fm.FillListBlackList;
  fm.InBlackListAllFields;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindReleaseNumrelease:=Trim(fm.edNumRelease.Text);
    FindTreeHeadingNameHeading:=Trim(fm.edTreeheading.Text);
    FindTextAnnouncementDubl:=Trim(fm.meText.Lines.Text);
    FindContactPhone:=Trim(fm.edContactPhone.Text);
    FindHomePhone:=Trim(fm.edHomePhone.Text);
    FindWorkPhone:=Trim(fm.edHomePhone.Text);
    FindKeyWordsWord:=Trim(fm.cmbWord.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBAnnouncementDubl.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7: string;
  and1,and2,and3,and4,and5,and6: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindReleaseNumrelease:=isInteger(FindReleaseNumrelease);
    isFindTreeHeadingNameHeading:=Trim(FindTreeHeadingNameHeading)<>'';
    isFindTextAnnouncementDubl:=Trim(FindTextAnnouncementDubl)<>'';
    isFindContactPhone:=Trim(FindContactPhone)<>'';
    isFindHomePhone:=Trim(FindHomePhone)<>'';
    isFindWorkPhone:=Trim(FindWorkPhone)<>'';
    isFindKeyWordsWord:=Trim(FindKeyWordsWord)<>'';

    if isFindReleaseNumrelease or isFindTreeHeadingNameHeading  or
       isFindTextAnnouncementDubl or isFindContactPhone  or isFindHomePhone or
       isFindWorkPhone or isFindKeyWordsWord then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindReleaseNumrelease then begin
        addstr1:=' Upper(r.numrelease) like '+AnsiUpperCase(QuotedStr(FilInSide+FindReleaseNumrelease+'%'))+' ';
     end;

     if isFindTreeHeadingNameHeading then begin
        addstr2:=' Upper(t.nameheading) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTreeHeadingNameHeading+'%'))+' ';
     end;

     if isFindTextAnnouncementDubl then begin
        addstr3:=' Upper(textannouncement) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTextAnnouncementDubl+'%'))+' ';
     end;

     if isFindContactPhone then begin
        addstr4:=' Upper(contactphone) like '+AnsiUpperCase(QuotedStr(FilInSide+FindContactPhone+'%'))+' ';
     end;

     if isFindHomePhone then begin
        addstr5:=' Upper(homephone) like '+AnsiUpperCase(QuotedStr(FilInSide+FindHomePhone+'%'))+' ';
     end;

     if isFindWorkPhone then begin
        addstr6:=' Upper(workphone) like '+AnsiUpperCase(QuotedStr(FilInSide+FindWorkPhone+'%'))+' ';
     end;

     if isFindKeyWordsWord then begin
        addstr7:=' Upper(k.word) like '+AnsiUpperCase(QuotedStr(FilInSide+FindKeyWordsWord+'%'))+' ';
     end;

     if (isFindReleaseNumrelease and isFindTreeHeadingNameHeading)or
        (isFindReleaseNumrelease and isFindTextAnnouncementDubl)or
        (isFindReleaseNumrelease and isFindContactPhone)or
        (isFindReleaseNumrelease and isFindHomePhone)or
        (isFindReleaseNumrelease and isFindWorkPhone)or
        (isFindReleaseNumrelease and isFindKeyWordsWord)
        then and1:=' and ';

     if (isFindTreeHeadingNameHeading and isFindTextAnnouncementDubl)or
        (isFindTreeHeadingNameHeading and isFindContactPhone)or
        (isFindTreeHeadingNameHeading and isFindHomePhone)or
        (isFindTreeHeadingNameHeading and isFindWorkPhone)or
        (isFindTreeHeadingNameHeading and isFindKeyWordsWord)
        then and2:=' and ';

     if (isFindTextAnnouncementDubl and isFindContactPhone)or
        (isFindTextAnnouncementDubl and isFindHomePhone)or
        (isFindTextAnnouncementDubl and isFindWorkPhone)or
        (isFindTextAnnouncementDubl and isFindKeyWordsWord)
        then and3:=' and ';

     if (isFindContactPhone and isFindHomePhone)or
        (isFindContactPhone and isFindWorkPhone)or
        (isFindContactPhone and isFindKeyWordsWord)
        then and4:=' and ';

     if (isFindHomePhone and isFindWorkPhone)or
        (isFindHomePhone and isFindKeyWordsWord)
        then and5:=' and ';

     if (isFindWorkPhone and isFindKeyWordsWord)
        then and6:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4+and4+
                      addstr5+and5+
                      addstr6+and6+
                      addstr7;
end;

procedure TfmRBAnnouncementDubl.SetCurrentReleaseId;
var
  TPRBI: TParamRBookInterface;
  s: string;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' daterelease>='+QuotedStr(DateToStr(_GetDateTimeFromServer))+' ');
  TPRBI.Condition.OrderStr:=PChar(' daterelease ');
  if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
   FindReleaseNumrelease:=inttostr(GetFirstValueFromParamRBookInterface(@TPRBI,'numrelease'));
   NoteRelease:=GetFirstValueFromParamRBookInterface(@TPRBI,'about');
   s:=GetFirstValueFromParamRBookInterface(@TPRBI,'numrelease');
   edNumRelease.Text:=Trim(NoteRelease)+' ('+s+')';
   FindReleaseNumrelease_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'release_id');
  end;
end;

procedure TfmRBAnnouncementDubl.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  ClearList(Listmain);
  Listmain.free;
end;

procedure TfmRBAnnouncementDubl.ClearList(List: TList);
var
 i: Integer;
 P: PDubl;
begin
 for i:=0 to List.Count-1 do begin
  P:=List.Items[i];
  if P.List<>nil then
    ClearList(P.List);
  dispose(P);
 end;
 List.Clear;
end;

procedure TfmRBAnnouncementDubl.AddToList( ListParent: TList;
                       WorkPhone: String;
                       ContactPhone: String;
                       HomePhone: String;
                       List: TList;
                       id:Integer;
                       Hash:Integer;
                       CountChar:Integer;
                       keyword: String);

var
 P: PDubl;
begin
 new(P);
 P.WorkPhone:=WorkPhone;
 P.ContactPhone:=ContactPhone;
 P.HomePhone:=HomePhone;
 P.Hash:=Hash;
 P.id:=id;
 P.CountChar:=CountChar;
 P.ListParent:=ListParent;
 P.keyword:=keyword;

 P.List:=TList.Create;
 ListParent.Add(P);
end;



procedure TfmRBAnnouncementDubl.AddFromQuery(List: TList);
begin
  CountDoubl:=0;
  qr.SQL.Clear();
 //Группировка по номерам телефонов
  qr.SQL.Add('select count(addstr(Ltrim(Rtrim(a.contactphone)),Ltrim(Rtrim(a.homephone)), '+
             ' Ltrim(Rtrim(a.workphone)))),'+
             ' addstr(substr(Ltrim(Rtrim(a.contactphone)),1,80),substr(Ltrim(Rtrim(a.homephone)),1,80),'+
             ' substr(Ltrim(Rtrim(a.workphone)),1,80))'+
             ' from ANNOUNCEMENT a where release_id =' + IntToStr(FindReleaseNumrelease_id) +
             ' group by addstr(substr(Ltrim(Rtrim(a.contactphone)),1,80),substr(Ltrim(Rtrim(a.homephone)),1,80),'+
             ' substr(Ltrim(Rtrim(a.workphone)),1,80))');




{  qr.SQL.Add('select count(announcement.announcement_id),contactphone, homephone, workphone ' +
             ' from ANNOUNCEMENT where release_id =' + IntToStr(FindReleaseNumrelease_id) +
             ' group by contactphone, homephone, workphone');}
  qr.Open();
  qr.First;
  ClearList(ListMain);
  while (not qr.Eof) do begin
      if (qr.FieldBYName('COUNT').AsInteger > 1) then begin
      AddToList(ListMain,
                Trim(qr.FieldBYName('addstr').AsString),
                '',
                '',
                nil,0,0,0,'');
           CountDoubl:=CountDoubl+1;
           end;
    qr.Next;
  end;
end;

procedure TfmRBAnnouncementDubl.InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);
begin
   _OnVisibleInterface(hInterface,true);
   FhInterface:=hInterface;
   ViewSelect:=false;
//   if Trim(LastOrderStr)='' then  LastOrderStr:=DefLastOrderStr;
       FormStyle:=fsMDIChild;
   if WindowState=wsMinimized then begin
       WindowState:=wsNormal;
   end; 
   BringToFront;
   Show;
end;


procedure TfmRBAnnouncementDubl.bibFindClick(Sender: TObject);
var
i,{j,}percent : integer;
counter: Integer;
newHash: cardinal;
CountChar:cardinal;
TCLI: TCreateLogItem;
S: String;

sqls: string;
//sql: string;
//tmp : string;
  str: String;
  Pnew : PDubl;
//  T: TmemoryStatus;
  ID: Integer;

begin
  try
   IBTrFind.AddDatabase(IBDB);
   IBDB.AddTransaction(IBTrFind);
   qrFind.Database:=IBDB;

//   new(P);
   CountItem:=0;
   percent:=0;
   ClearList(Listmain);
   
   AddFromQuery(Listmain);
   
      sqls:=PChar('Отсортировано '+ IntToStr(ListMain.Count) +' групп.');
      TCLI.Text:=PChar(sqls);
      TCLI.TypeLogItem:=tliInformation;
      TCLI.ViewLogItemProc:=nil;
      _CreateLogItem(@TCLI);
      _ViewLog(true);
      Application.ProcessMessages;

   for i:=0 to ListMain.Count-1 do
     begin
      if (Round(100/ListMain.Count*(i+1))<>percent) then
      begin
         percent:=Round(100/ListMain.Count*(i+1));
         if (ListMain.Count>0) then begin
           TCLI.Text:=PChar('Группировка объявлений. Выполнено: '+ IntToStr(percent) + '%');
           TCLI.TypeLogItem:=tliInformation;
           TCLI.ViewLogItemProc:=nil;
           _CreateLogItem(@TCLI);
           _ViewLog(true);
        end;
        Application.ProcessMessages;
     end;

      Pnew:=ListMain.Items[i];
      qrFind.SQL.Clear;
      if (pnew.WorkPhone= '') then
                FindStr := ' is null '
                else
                FindStr := '= ''' + pnew.WorkPhone+ ''' ';
      sqls:= 'select ANNOUNCEMENT_ID,TEXTANNOUNCEMENT,WORD,a.TREEHEADING_ID  from ANNOUNCEMENT a left '+
             'join keywords k on a.word_id = k.word_id where rtrim(ltrim(addstr(substr(Ltrim(Rtrim(a.contactphone)),1,80),' +
             ' substr(Ltrim(Rtrim(a.homephone)),1,80), substr(Ltrim(Rtrim(a.workphone)),1,80)))) ' + FindStr +
             ' and release_id='+IntToStr(FindReleaseNumrelease_id);
      qrFind.SQL.Add(sqls);
      qrFind.Open;
      qrFind.First;
      while (not qrFind.Eof) do
        begin
//           tmp:=
           str:=AnsiUpperCase(Trim(qrFind.FieldBYName('WORD').AsString)+Trim(qrFind.FieldBYName('TEXTANNOUNCEMENT').AsString));
           counter:=1;
           CountChar:=0;
           S:='';
           while counter <= Length(str) do
            begin
               if (str[counter-1] in [' ','@','~','#','$','%','^','&','(',')','=','.',',','!','?','-',';',':','/','\','*','+','[',']']) {or
                  (str[counter-1] in ['A'..'z']) or
                  (str[counter-1] in ['А'..'я']) }then
//               if ((str[counter-1]=' ') or (str[counter-1]='.') or (str[counter-1]=',') or (str[counter-1]='?') or (str[counter-1]='-')
//                   or (str[counter-1]=';') or (str[counter-1]=':') or (str[counter-1]='/') or (str[counter-1]='\')
//                   or (str[counter-1]='*') or (str[counter-1]='+') or (str[counter-1]='[') or (str[counter-1]=']')) then
                    begin
                      //
                    end else  begin
{                     case str[counter-1] of
                         'А': newHash:=newHash+Byte(str[counter-1])*2;
                         'Е': newHash:=newHash+Byte(str[counter-1])*3;
                         'И': newHash:=newHash+Byte(str[counter-1])*4;
                         'О': newHash:=newHash+Byte(str[counter-1])*5;
                         'У': newHash:=newHash+Byte(str[counter-1])*6;
                         'Э': newHash:=newHash+Byte(str[counter-1])*7;
                         'Ю': newHash:=newHash+Byte(str[counter-1])*8;
                         'Я': newHash:=newHash+Byte(str[counter-1])*9;
                         '1': newHash:=newHash+Byte(str[counter-1])*3;
                         '2': newHash:=newHash+Byte(str[counter-1])*5;
                         '3': newHash:=newHash+Byte(str[counter-1])*7;
                         '4': newHash:=newHash+Byte(str[counter-1])*9;
                         '5': newHash:=newHash+Byte(str[counter-1])*11;
                         '6': newHash:=newHash+Byte(str[counter-1])*13;
                         '7': newHash:=newHash+Byte(str[counter-1])*15;
                         '8': newHash:=newHash+Byte(str[counter-1])*17;
                         '9': newHash:=newHash+Byte(str[counter-1])*19;
                         '0': newHash:=newHash+Byte(str[counter-1])*21;
                     else}
//                     newHash:=newHash+Byte(str[counter-1])*10;
//                     end;

                     CountChar:=CountChar+1;
                     S:=S+str[counter-1];
                    end;
               counter := counter+1;
            end;
            newHash:=GetStrCRC32(S);

         ID:=qrFind.FieldBYName('ANNOUNCEMENT_ID').AsInteger;
         AddToList(PNew.List,'','','',nil,ID,newHash,
                   CountChar,AnsiUpperCase(Trim(qrFind.FieldBYName('TREEHEADING_ID').AsString)));
         try
          qrFind.Next;
         except
          on E: Exception do begin
             TCLI.Text:=PChar(E.Message);
             TCLI.TypeLogItem:=tliError;
             _CreateLogItem(@TCLI);
          end;
         end;
        end;
     end;
  finally

  end;
      if (ListMain.Count <= 0) then ShowMessage('Одинаковые объявления не найдены.')
      else
        begin
           bibPrevDubl.Enabled:=true;
           bibNextDubl.Enabled:=true;
//--------------------------------------------------------------------------
           ShowDubl(Sender);
//--------------------------------------------------------------------------
        end;
end;

procedure TfmRBAnnouncementDubl.ShowDubl(Sender: TObject);

    function Step100 (p: PDubl):THandle;
    var
        i,j,ii,ss ,percent: integer;
        Ready, ISID, cur: Bool;
        TCLI: TCreateLogItem;
    begin
       Result:=0;
                //Общий список - весь
          percent:=0;      
          if (p.List <> nil) then
          for j:=0 to p.List.Count-1 do
             begin
                if (Round(100/p.List.Count*(j+1))<>percent) then
                  begin
                      percent:=Round(100/p.List.Count*(j+1));
                      if (p.List.Count>0  ) then begin
                         TCLI.Text:=PChar('Поиск идентичных объявлений: '+ IntToStr(percent) + '%');
                         TCLI.TypeLogItem:=tliInformation;
                         TCLI.ViewLogItemProc:=nil;
                         _CreateLogItem(@TCLI);
                         _ViewLog(true);
                      end;
                      Application.ProcessMessages;
                 end;

                  ii:=0;
                  Color_:= not Color_;
                  sql:=SQLRbkAnnouncementDubl;
                  sql:=sql + ' where announcement_id in (0,'+IntToStr(PDubl(P.List.Items[j]).id)+',';
                  //Не ищу сравнения в оставшихся отобранных
                  cur :=false;
                  for i:=j+1 to p.List.Count-1 do
                   begin
                      Ready:=false;
                        //Если не добавлено, то ищу похожие
                        if (not Ready) then
                            begin
                              if (CBtreeheadingnameheading.Checked) then begin
                              if ((PDubl(P.List.Items[j]).Hash = PDubl(P.List.Items[i]).Hash) and
                                  (PDubl(P.List.Items[j]).CountChar = PDubl(P.List.Items[i]).CountChar))
                                   and (PDubl(P.List.Items[j]).keyword = PDubl(P.List.Items[i]).keyword)
                              then
                                  begin
                                  ISID:=false;
                                    //Проверяю отобрана ли уже такая строка
                                  for ss:=1 to 2000 do
                                    begin
                                       if IDs[ss]=PDubl(P.List.Items[i]).id then
                                       ISID:=true;
                                    end;
                                     if (not ISID) then
                                     begin
                                      if (not cur) then begin
                                              sql:=sql+IntToStr(PDubl(P.List.Items[j]).id)+',';
                                              IDs[id_count]:=PDubl(P.List.Items[j]).id;
                                              inc(id_count);
                                              cur:=true;
                                      end;
                                      sql:=sql+IntToStr(PDubl(P.List.Items[i]).id)+',';
                                       //Запоминаю её
                                      IDs[id_count]:=PDubl(P.List.Items[i]).id;
                                      inc(id_count);
                                      inc(ii);
                                     end;
                                     //Проверка на лимит по запросу 1500 значений
                                     if ii=1495 then break;
                                  end;//----
                                  end
                                  else
                                   if ((PDubl(P.List.Items[j]).Hash = PDubl(P.List.Items[i]).Hash) and
                                       (PDubl(P.List.Items[j]).CountChar = PDubl(P.List.Items[i]).CountChar))
                                      then
                                          begin
                                          ISID:=false;
                                            //Проверяю отобрана ли уже такая строка
                                          for ss:=1 to 2000 do
                                            begin
                                               if IDs[ss]=PDubl(P.List.Items[i]).id then
                                               ISID:=true;
                                            end;
                                             if (not ISID) then
                                             begin
                                              if (not cur) then begin
                                                      sql:=sql+IntToStr(PDubl(P.List.Items[j]).id)+',';
                                                      IDs[id_count]:=PDubl(P.List.Items[j]).id;
                                                      inc(id_count);
                                                      cur:=true;
                                              end;
                                              sql:=sql+IntToStr(PDubl(P.List.Items[i]).id)+',';
                                               //Запоминаю её
                                              IDs[id_count]:=PDubl(P.List.Items[i]).id;
                                              inc(id_count);
                                              inc(ii);
                                             end;
                                             //Проверка на лимит по запросу 1500 значений
                                             if ii=1495 then break;
                                          end;//----
                            end;
                      end;
                sql:=sql+'0)';
                qrFind.SQL.Clear;
//                ShowMessage(IntToStr(Length(sql)));
                if (ii>0) then
                begin
                qrFind.SQL.Add(sql);
                qrFind.Open;
//                ds1.DataSet.DisableControls;
                  Grid.DataSource:=nil;
                  RxDBGrid1.DataSource:=nil;
                  qrFind.First;
                  while (not qrFind.Eof) do
                        begin
                          MemDS.Active:=true;
                          MemDS.Append;
                          MemDS.FieldByName('treeheadingnameheading').AsString := qrFind.FieldByName('treeheadingnameheading').AsString;
                          MemDS.FieldByName('ANNOUNCEMENT_ID').AsInteger := qrFind.FieldByName('ANNOUNCEMENT_ID').AsInteger;
                          MemDS.FieldByName('releasenumrelease').AsInteger := qrFind.FieldByName('releasenumrelease').AsInteger;
                          MemDS.FieldByName('releasedaterelease').AsDateTime := qrFind.FieldByName('releasedaterelease').AsDateTime;
                          MemDS.FieldByName('treeheadingnameheading').AsString := qrFind.FieldByName('treeheadingnameheading').AsString;
                          MemDS.FieldByName('keywordsword').AsString := qrFind.FieldByName('keywordsword').AsString;
                          MemDS.FieldByName('textannouncement').AsString := qrFind.FieldByName('textannouncement').AsString;
                          MemDS.FieldByName('contactphone').AsString := qrFind.FieldByName('contactphone').AsString;
                          MemDS.FieldByName('homephone').AsString := qrFind.FieldByName('homephone').AsString;
                          MemDS.FieldByName('workphone').AsString := qrFind.FieldByName('workphone').AsString;
                          MemDS.FieldByName('copyprint').AsInteger := qrFind.FieldByName('copyprint').AsInteger;
                          MemDS.FieldByName('about').AsString := qrFind.FieldByName('about').AsString;
                          MemDS.FieldByName('indate').AsDateTime := qrFind.FieldByName('indate').AsDateTime;
                          MemDS.FieldByName('whoin').AsString := qrFind.FieldByName('whoin').AsString;
                          MemDS.FieldByName('changedate').AsDateTime := qrFind.FieldByName('changedate').AsDateTime;
                          MemDS.FieldByName('whochange').AsString := qrFind.FieldByName('whochange').AsString;
                          MemDS.FieldByName('treeheading_id').AsString := qrFind.FieldByName('treeheading_id').AsString;
                          MemDS.FieldByName('release_id').AsString := qrFind.FieldByName('release_id').AsString;
                          MemDS.FieldByName('Percent').AsInteger := 100;
                          MemDS.FieldByName('hash').AsInteger := PDubl(P.List.Items[j]).Hash;
                          MemDS.Post;
                          if (MemDS.RecordCount > 1000) then
                                begin
                                  ShowMessage('Слишком много одинаковых объявлений. Удалите лишние и повторите поиск.');
                                  exit;
                                end;
                          qrFind.Next;
                        end;
                end;
               end;
    end;


    function Step (p: PDubl):THandle;
    var
        i,j,ii,ss ,percent: integer;
        Ready, ISID, cur: Bool;
        TCLI: TCreateLogItem;
    begin
                //Общий список - весь
                 Result:=0;
                    percent:=0;
          if (p.List <> nil) then
          for j:=0 to p.List.Count-1 do
             begin
                if (Round(100/p.List.Count*(j+1))<>percent) then
                  begin
                      percent:=Round(100/p.List.Count*(j+1));
                      if (p.List.Count>0  ) then begin
                         TCLI.Text:=PChar('Поиск похожих объявлений: '+ IntToStr(percent) + '%');
                         TCLI.TypeLogItem:=tliInformation;
                         TCLI.ViewLogItemProc:=nil;
                         _CreateLogItem(@TCLI);
                         _ViewLog(true);
                      end;
                      Application.ProcessMessages;
                 end;
                  ii:=0;
                  Color_:= not Color_;
                  sql:=SQLRbkAnnouncementDubl;
                  sql:=sql + ' where announcement_id in (0,'+IntToStr(PDubl(P.List.Items[j]).id)+',';
                  cur :=false;
                  for i:=j+1 to p.List.Count-1 do
                   begin
                      Ready:=false;
                        if (not Ready) then
                            begin
                              if (CBtreeheadingnameheading.Checked) then begin
                              if ((PDubl(P.List.Items[j]).Hash < PDubl(P.List.Items[i]).Hash*(2-SEPercent.Value/100)) and
                                  (PDubl(P.List.Items[j]).Hash > PDubl(P.List.Items[i]).Hash*SEPercent.Value/100) and
                                  (PDubl(P.List.Items[j]).CountChar < PDubl(P.List.Items[i]).CountChar*(2-SEPercent.Value/100)) and
                                  (PDubl(P.List.Items[j]).CountChar > PDubl(P.List.Items[i]).CountChar*SEPercent.Value/100) and
                                  (PDubl(P.List.Items[j]).Hash <> PDubl(P.List.Items[i]).Hash))
                                  and (PDubl(P.List.Items[j]).keyword = PDubl(P.List.Items[i]).keyword)
                                  then
                                  begin
                                  ISID:=false;
                                    //Проверяю отобрана ли уже такая строка
                                  for ss:=1 to 2000 do
                                    begin
                                       if IDs[ss]=PDubl(P.List.Items[i]).id then
                                       ISID:=true;
                                    end;
                                     if (not ISID) then
                                     begin
                                      if (not cur) then begin
                                              sql:=sql+IntToStr(PDubl(P.List.Items[j]).id)+',';
                                              IDs[id_count]:=PDubl(P.List.Items[j]).id;
                                              inc(id_count);
                                              cur:=true;
                                      end;

                                      sql:=sql+IntToStr(PDubl(P.List.Items[i]).id)+',';
                                       //Запоминаю её
                                      IDs[id_count]:=PDubl(P.List.Items[i]).id;
                                      inc(id_count);
                                      inc(ii);
                                     end;
                                     //Проверка на лимит по запросу 1500 значений
                                     if ii=1495 then break;
                                  end//----
                                  end
                                  else
                                      if ((PDubl(P.List.Items[j]).Hash < PDubl(P.List.Items[i]).Hash*(2-SEPercent.Value/100)) and
                                          (PDubl(P.List.Items[j]).Hash > PDubl(P.List.Items[i]).Hash*SEPercent.Value/100) and
                                          (PDubl(P.List.Items[j]).CountChar < PDubl(P.List.Items[i]).CountChar*(2-SEPercent.Value/100)) and
                                          (PDubl(P.List.Items[j]).CountChar > PDubl(P.List.Items[i]).CountChar*SEPercent.Value/100) and
                                          (PDubl(P.List.Items[j]).Hash <> PDubl(P.List.Items[i]).Hash))
                                          then
                                          begin
                                          ISID:=false;
                                            //Проверяю отобрана ли уже такая строка
                                          for ss:=1 to 2000 do
                                            begin
                                               if IDs[ss]=PDubl(P.List.Items[i]).id then
                                               ISID:=true;
                                            end;
                                             if (not ISID) then
                                             begin
                                              if (not cur) then begin
                                                      sql:=sql+IntToStr(PDubl(P.List.Items[j]).id)+',';
                                                      IDs[id_count]:=PDubl(P.List.Items[j]).id;
                                                      inc(id_count);
                                                      cur:=true;
                                              end;

                                              sql:=sql+IntToStr(PDubl(P.List.Items[i]).id)+',';
                                               //Запоминаю её
                                              IDs[id_count]:=PDubl(P.List.Items[i]).id;
                                              inc(id_count);
                                              inc(ii);
                                                     end;
                                                     //Проверка на лимит по запросу 1500 значений
                                                     if ii=1495 then break;
                                                  end//----

                            end;
                      end;
                sql:=sql+'0)';
                qrFind.SQL.Clear;
//                ShowMessage(IntToStr(Length(sql)));
{                          if (PDubl(P.List.Items[j]).Hash < PDubl(P.List.Items[i]).Hash) then
                          MemDS.FieldByName('Percent').AsInteger := 100*PDubl(P.List.Items[j]).Hash / PDubl(P.List.Items[i]).Hash);
                          else
                          MemDS.FieldByName('Percent').AsInteger := 100*PDubl(P.List.Items[j]).Hash / PDubl(P.List.Items[i]).Hash);
}
                if (ii>0) then
                begin
                qrFind.SQL.Add(sql);
                qrFind.Open;
//                ds1.DataSet.DisableControls;
                  Grid.DataSource:=nil;
                  RxDBGrid1.DataSource:=nil;
                  qrFind.First;
                  while (not qrFind.Eof) do
                        begin
                          MemDS.Active:=true;
                          MemDS.Append;
                          MemDS.FieldByName('treeheadingnameheading').AsString := qrFind.FieldByName('treeheadingnameheading').AsString;
                          MemDS.FieldByName('ANNOUNCEMENT_ID').AsInteger := qrFind.FieldByName('ANNOUNCEMENT_ID').AsInteger;
                          MemDS.FieldByName('releasenumrelease').AsInteger := qrFind.FieldByName('releasenumrelease').AsInteger;
                          MemDS.FieldByName('releasedaterelease').AsDateTime := qrFind.FieldByName('releasedaterelease').AsDateTime;
                          MemDS.FieldByName('treeheadingnameheading').AsString := qrFind.FieldByName('treeheadingnameheading').AsString;
                          MemDS.FieldByName('keywordsword').AsString := qrFind.FieldByName('keywordsword').AsString;
                          MemDS.FieldByName('textannouncement').AsString := qrFind.FieldByName('textannouncement').AsString;
                          MemDS.FieldByName('contactphone').AsString := qrFind.FieldByName('contactphone').AsString;
                          MemDS.FieldByName('homephone').AsString := qrFind.FieldByName('homephone').AsString;
                          MemDS.FieldByName('workphone').AsString := qrFind.FieldByName('workphone').AsString;
                          MemDS.FieldByName('copyprint').AsInteger := qrFind.FieldByName('copyprint').AsInteger;
                          MemDS.FieldByName('about').AsString := qrFind.FieldByName('about').AsString;
                          MemDS.FieldByName('indate').AsDateTime := qrFind.FieldByName('indate').AsDateTime;
                          MemDS.FieldByName('whoin').AsString := qrFind.FieldByName('whoin').AsString;
                          MemDS.FieldByName('changedate').AsDateTime := qrFind.FieldByName('changedate').AsDateTime;
                          MemDS.FieldByName('whochange').AsString := qrFind.FieldByName('whochange').AsString;
                          MemDS.FieldByName('treeheading_id').AsString := qrFind.FieldByName('treeheading_id').AsString;
                          MemDS.FieldByName('release_id').AsString := qrFind.FieldByName('release_id').AsString;
                          MemDS.FieldByName('Percent').AsInteger := SEPercent.Value;
                          MemDS.FieldByName('hash').AsInteger := PDubl(P.List.Items[j]).Hash;
                          MemDS.Post;
                          if (MemDS.RecordCount > 1000) then
                                begin
                                  ShowMessage('Слишком много одинаковых объявлений. Удалите лишние и повторите поиск.');
                                  exit;
                                end;

                          qrFind.Next;
                        end;
                end;
               end;
    end;
var
 i:Integer;
// TCLI: TCreateLogItem;
 P: PDubl;
begin
   MemDS.EmptyTable;
{   while (not MemDS.Eof) do
      begin
        MemDS.Delete;
      end;}
//Очищаю список отобранных записей
  for i:=1 to 2000 do
    begin
     IDs[i]:=0;
    end;
  id_count:=1;


   P:=ListMain.Items[CountItem];
   MemDS.AfterScroll:=nil;
   Step100(P);
   if (fmOptions.chbAnnouncementDoStep95.Checked) and (SEPercent.Value<100) then
     begin
        Step(P);
     end;
   MemDS.AfterScroll:=MemDSAfterScroll;
   ds1.DataSet:=MemDs;
//   Grid.DataSource:=ds1;
   RxDBGrid1.DataSource:=ds1;
   lbCount.Caption:= 'Всего найдено: '+ IntToStr(MemDs.RecordCount);
   if (MemDS.RecordCount>0) then MemDS.First;

   if (MemDs.Eof) then
        begin
            if ((CountItem < ListMain.Count-1) and (CountItem <> 0)) then
                    if (RevNext) then bibNextDubl.Click
                        else bibPrevDubl.Click
        end;
end;

procedure TfmRBAnnouncementDubl.bibNextDublClick(Sender: TObject);
begin
  RevNext:=true;
  if (CountItem+1 > ListMain.Count-1) then
        begin
         bibPrevDubl.Enabled:=true;
         bibNextDubl.Enabled:=false;
        end
      else
        begin
         bibPrevDubl.Enabled:=true;
         bibNextDubl.Enabled:=true;
         CountItem:=CountItem+1;
        end;
ShowDubl(Sender);
end;

procedure TfmRBAnnouncementDubl.bibPrevDublClick(Sender: TObject);
begin
  RevNext:=false;
  if (CountItem-1 < 0) then
        begin
          bibPrevDubl.Enabled:=false;
          bibNextDubl.Enabled:=true;
        end
      else
        begin
        bibPrevDubl.Enabled:=true;
        bibNextDubl.Enabled:=true;
        CountItem:=CountItem-1;
        end;
ShowDubl(Sender);
end;


procedure TfmRBAnnouncementDubl.ViewCount;
begin
 if MemDS.Active then
  lbCount.Caption:=ViewCountText+inttostr(MemDS.RecordCount);
end;


procedure TfmRBAnnouncementDubl.bibNumReleaseClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  s: string;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='release_id';
  TPRBI.Locate.KeyValues:=FindReleaseNumrelease_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
//   ChangeFlag:=true;
   FindReleaseNumrelease_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'release_id');
   NoteRelease:=GetFirstValueFromParamRBookInterface(@TPRBI,'about');
   s:=GetFirstValueFromParamRBookInterface(@TPRBI,'numrelease');
   edNumRelease.Text:=Trim(NoteRelease)+' ('+s+')';
  end;
end;

procedure TfmRBAnnouncementDubl.ShowingChanged;
begin
  inherited;
  edTreePath.Width:=pnTreePath.Width-edTreePath.Left;
end;


procedure TfmRBAnnouncementDubl.FormResize(Sender: TObject);
begin
  inherited;
  ShowingChanged;
end;

procedure TfmRBAnnouncementDubl.MemDSAfterScroll(DataSet: TDataSet);
begin
  if not MemDS.Active then exit;
  if MemDS.IsEmpty then exit;
  if pnTreePath.Visible then
    edTreePath.Text:=GetTreeheadinPath(MemDS.FieldByname('treeheading_id').AsInteger);
end;

procedure TfmRBAnnouncementDubl.RxDBGrid1GetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
var
  Len: Integer;
begin
  Len := (Sender as TrxDBGrid).DataSource.DataSet.FieldByName('Hash').AsInteger+7;
  if (Len mod 9)= 0 then
    begin
       Background := clLime;  { shortest }
       exit;
    end;
  if (Len mod 8)= 0 then
    begin
        Background := clAqua;   { shortest }
       exit;
    end;
  if (Len mod 7)= 0 then
    begin
        Background := clBlue;	   { shortest }
       exit;
    end;
  if (Len mod 6)= 0 then
    begin
        Background := clTeal;	   { shortest }
       exit;
    end;
  if (Len mod 5)= 0 then
    begin
        Background := clFuchsia	;	   { shortest }
       exit;
    end;
  if (Len mod 6)= 0 then
    begin
        Background := clGreen	;	   { shortest }
       exit;
    end;
  if (Len mod 3)= 0 then
    begin
        Background := clYellow	;	   { shortest }
       exit;
    end;
  if (Len mod 2)= 0 then
    begin
        Background := clSilver	;	   { shortest }
       exit;
    end;
        Background := clDkGray;	   { shortest }
end;
procedure TfmRBAnnouncementDubl.SEPercentChange(Sender: TObject);
begin
  ShowDubl(Sender);
end;

procedure TfmRBAnnouncementDubl.CBtreeheadingnameheadingClick(
  Sender: TObject);
begin
  ShowDubl(Sender);
end;

end.


