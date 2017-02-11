unit URBAnnouncement;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL, grids,
  Mask;

type

   TfmRBAnnouncement = class(TfmRBMainGrid)
    pnTreePath: TPanel;
    lbTreePath: TLabel;
    pnDouble: TPanel;
    spl: TSplitter;
    dsDouble: TDataSource;
    qrDouble: TIBQuery;
    trDouble: TIBTransaction;
    updDouble: TIBUpdateSQL;
    pnDoubleBut: TPanel;
    bibDoubleDel: TButton;
    bibDoubleAdjust: TButton;
    edTreePath: TDBEdit;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MainqrAfterScroll(DataSet: TDataSet);
    procedure bibDoubleDelClick(Sender: TObject);
    procedure bibDoubleAdjustClick(Sender: TObject);
    procedure splMoved(Sender: TObject);
  private
    GridDouble: TNewdbGrid;
    isFindReleaseNumrelease,isFindTreeHeadingNameHeading,isFindTextAnnouncement,
    isFindContactPhone,isFindHomePhone,isFindWorkPhone,isFindKeyWordsWord: Boolean;
    isFindAbout, isFindWhoIn, isFindWhoChange: Boolean;
    FindReleaseId: Integer;
    NoteRelease: string;

    FindReleaseNumrelease, FindTreeHeadingNameHeading, FindTextAnnouncement,
    FindContactPhone, FindHomePhone, FindWorkPhone, FindKeyWordsWord, FindAbout, FindWhoIn, FindWhoChange: String;
    procedure SetCurrentReleaseId;
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ViewDouble;
    procedure GridDoubleOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DeleteDouble;
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
    procedure ShowingChanged; override;
  end;

var
  fmRBAnnouncement: TfmRBAnnouncement;

  function GetTreeheadinPath(treeheading_id: Integer): String;
  function GetTreeheadinPathNew(treeheading_id: Integer): String;

implementation

uses UMainUnited, UAncementCode, UAncementDM, UAncementData, UEditRBAnnouncement,
     UAncementOptions, tsvAdjust;

{$R *.DFM}

{ TfmRBAnnouncement }

procedure TfmRBAnnouncement.FormCreate(Sender: TObject);
var
  cl: TColumn;

  procedure AddColumsToGrid(gr: TNewDbGrid);
  begin
    cl:=gr.Columns.Add;
    cl.FieldName:='releasenumrelease';
    cl.Title.Caption:='Выпуск';
    cl.Width:=50;

    cl:=gr.Columns.Add;
    cl.FieldName:='releasedaterelease';
    cl.Title.Caption:='Дата выпуска';
    cl.Width:=70;

    cl:=gr.Columns.Add;
    cl.FieldName:='treeheadingnameheading';
    cl.Title.Caption:='Рубрика';
    cl.Width:=100;

    cl:=gr.Columns.Add;
    cl.FieldName:='keywordsword';
    cl.Title.Caption:='Ключевое слово';
    cl.Width:=100;

    cl:=gr.Columns.Add;
    cl.FieldName:='textannouncement';
    cl.Title.Caption:='Текст объявления';
    cl.Width:=150;

    cl:=gr.Columns.Add;
    cl.FieldName:='contactphone';
    cl.Title.Caption:='Контактный телефон';
    cl.Width:=60;

    cl:=gr.Columns.Add;
    cl.FieldName:='homephone';
    cl.Title.Caption:='Домашний телефон';
    cl.Width:=60;

    cl:=gr.Columns.Add;
    cl.FieldName:='workphone';
    cl.Title.Caption:='Рабочий телефон';
    cl.Width:=60;

    cl:=gr.Columns.Add;
    cl.FieldName:='copyprint';
    cl.Title.Caption:='Количество выпусков';
    cl.Width:=60;

    cl:=gr.Columns.Add;
    cl.FieldName:='about';
    cl.Title.Caption:='Примечание';
    cl.Width:=60;

    cl:=gr.Columns.Add;
    cl.FieldName:='indate';
    cl.Title.Caption:='Дата ввода';
    cl.Width:=60;

    cl:=gr.Columns.Add;
    cl.FieldName:='whoin';
    cl.Title.Caption:='Кто ввел';
    cl.Width:=60;

    cl:=gr.Columns.Add;
    cl.FieldName:='changedate';
    cl.Title.Caption:='Дата изменения';
    cl.Width:=60;

    cl:=gr.Columns.Add;
    cl.FieldName:='whochange';
    cl.Title.Caption:='Кто изменял';
    cl.Width:=60;
  end;

begin
 inherited;
 try
  Caption:=NameRbkAnnouncement;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  qrDouble.Database:=IBDB;
  trDouble.AddDatabase(IBDB);
  IBDB.AddTransaction(trDouble);

  GridDouble:=TNewdbGrid.Create(Self);
  GridDouble.Parent:=pnDouble;
  GridDouble.Align:=alClient;
  GridDouble.Name:='GridDouble';
  GridDouble.ColumnSortEnabled:=false;
  GridDouble.DataSource:=dsDouble;
  GridDouble.RowSelected.Visible:=true;
  GridDouble.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridDouble.Font);
  GridDouble.TitleFont.Assign(GridDouble.Font);
  GridDouble.RowSelected.Font.Assign(GridDouble.Font);
  GridDouble.RowSelected.Brush.Style:=bsClear;
  GridDouble.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridDouble.RowSelected.Font.Color:=clWhite;
  GridDouble.RowSelected.Pen.Style:=psClear;
  GridDouble.CellSelected.Visible:=true;
  GridDouble.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridDouble.CellSelected.Font.Assign(GridDouble.Font);
  GridDouble.CellSelected.Font.Color:=clHighlightText;
  GridDouble.TitleCellMouseDown.Font.Assign(GridDouble.Font);
  GridDouble.Options:=GridDouble.Options-[dgEditing]-[dgTabs];
  GridDouble.RowSizing:=true;
  GridDouble.ReadOnly:=true;
  GridDouble.OnKeyDown:=GridDoubleOnKeyDown;
  GridDouble.TabOrder:=1;

  cl:=GridDouble.Columns.Add;
  cl.FieldName:='outpercent';
  cl.Title.Caption:='Процент совпадения';
  cl.Width:=40;


  edTreePath.DataField:='treeheadingnameheading';
  
  AddColumsToGrid(GridDouble);

  AddColumsToGrid(Grid);

  DefaultOrders.Add('по выпуску','numrelease');

  grid.TabOrder:=1;
  grid.OnDrawColumnCell:=GridDrawColumnCell;


  pnDouble.TabOrder:=2;
  pnTreePath.TabOrder:=3;

  pnDouble.Visible:=fmOptions.chbAnnouncementViewDouble.Checked;
  spl.Visible:=pnDouble.Visible;
  pnTreePath.Visible:=fmOptions.chbAnnouncementTreePath.Checked;
  ShowingChanged;

  LoadFromIni;

  SetCurrentReleaseId;
  
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAnnouncement.FormDestroy(Sender: TObject);
begin
  inherited;
  GridDouble.Free;
  if FormState=[fsCreatedMDIChild] then
   fmRBAnnouncement:=nil;
end;

function TfmRBAnnouncement.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=Format(SQLRbkAnnouncement,[QuotedStr(fmOptions.edBeforeTree.Text),
                                     QuotedStr(fmOptions.edAfterTree.Text),
                                     QuotedStr(fmOptions.edPointerTree.Text)])+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBAnnouncement.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  Mainqr.DisableControls;
  Mainqr.AfterScroll:=nil;
  try
   Mainqr.sql.Clear;
   sqls:=GetSql;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindReleaseNumrelease or isFindTreeHeadingNameHeading  or
                  isFindTextAnnouncement or isFindContactPhone  or isFindHomePhone or
                  isFindWorkPhone or isFindKeyWordsWord or isFindAbout or isFindWhoIn or isFindWhoChange);
   ViewCount;
  finally
   Mainqr.AfterScroll:=MainqrAfterScroll;
   MainqrAfterScroll(Mainqr);
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAnnouncement.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
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
   if UpperCase(fn)=UpperCase('textannouncement') then fn:='1';
   if UpperCase(fn)=UpperCase('treeheadingnameheading') then fn:='18';

   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   Mainqr.AfterScroll:=nil;
   MainQr.First;
   try
     if RecordCount<1000 then
       MainQr.Locate('announcement_id',id,[loCaseInsensitive]);
   except
   end;  
   Mainqr.AfterScroll:=MainqrAfterScroll;
   MainqrAfterScroll(Mainqr);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAnnouncement.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBAnnouncement.LoadFromIni;
begin
 inherited;
 try
    FindReleaseId:=ReadParam(ClassName,'ReleaseId',FindReleaseId);
//    FindReleaseNumrelease:=ReadParam(ClassName,'ReleaseNumrelease',FindReleaseNumrelease);
    FindTreeHeadingNameHeading:=ReadParam(ClassName,'TreeHeadingNameHeading',FindTreeHeadingNameHeading);
    FindTextAnnouncement:=ReadParam(ClassName,'TextAnnouncement',FindTextAnnouncement);
    FindContactPhone:=ReadParam(ClassName,'ContactPhone',FindContactPhone);
    FindHomePhone:=ReadParam(ClassName,'HomePhone',FindHomePhone);
    FindWorkPhone:=ReadParam(ClassName,'WorkPhone',FindWorkPhone);
    FindKeyWordsWord:=ReadParam(ClassName,'KeyWordsWord',FindKeyWordsWord);
    FindAbout:=ReadParam(ClassName,'About',FindAbout);
    FindWhoIn:=ReadParam(ClassName,'WhoIn',FindWhoIn);
    FindWhoChange:=ReadParam(ClassName,'WhoChange',FindWhoChange);

    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);

    LoadGridProp(ClassName,TDBGrid(GridDouble));

 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAnnouncement.SaveToIni;
begin
 inherited;
 try
//    WriteParam(ClassName,'ReleaseNumrelease',FindReleaseNumrelease);
    WriteParam(ClassName,'ReleaseId',FindReleaseId);
    WriteParam(ClassName,'TreeHeadingNameHeading',FindTreeHeadingNameHeading);
    WriteParam(ClassName,'TextAnnouncement',FindTextAnnouncement);
    WriteParam(ClassName,'ContactPhone',FindContactPhone);
    WriteParam(ClassName,'HomePhone',FindHomePhone);
    WriteParam(ClassName,'WorkPhone',FindWorkPhone);
    WriteParam(ClassName,'About',FindAbout);
    WriteParam(ClassName,'KeyWordsWord',FindKeyWordsWord);
    WriteParam(ClassName,'WhoIn',FindWhoIn);
    WriteParam(ClassName,'WhoChange',FindWhoChange);
    WriteParam(ClassName,'Inside',FilterInside);

    SaveGridProp(ClassName,TDBGrid(GridDouble));

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAnnouncement.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBAnnouncement.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBAnnouncement;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBAnnouncement.Create(nil);
  try
    fm.fmParent:=Self;
    fm.ActiveControl:=fm.bibTreeHeading;
    fm.ClearListBlackList;
    fm.FillListBlackList;
    fm.InBlackListAllFields;
    fm.SetCurrentReleaseid;
    fm.SetUsers;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
      ViewCount;
      Mainqr.AfterScroll:=nil;
      Mainqr.Locate('announcement_id',fm.oldannouncement_id,[loCaseInsensitive]);
      Mainqr.AfterScroll:=MainqrAfterScroll;
      MainqrAfterScroll(Mainqr);

      if fmOptions.chbAutoAdd.Checked then bibAddClick(Sender);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAnnouncement.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBAnnouncement;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBAnnouncement.Create(nil);
  try
    fm.fmParent:=Self;
    fm.cmbWord.Style:=csDropDownList;
    fm.edNumRelease.Text:=Trim(Mainqr.fieldByName('releasenumrelease').AsString);
    fm.release_id:=Mainqr.fieldByName('release_id').AsInteger;
    fm.edTreeheading.Text:=Mainqr.fieldByName('treeheadingnameheading').AsString;
    fm.treeheading_id:=Mainqr.fieldByName('treeheading_id').AsInteger;
    fm.FillKeyWordsWord;
    fm.cmbWord.ItemIndex:=fm.cmbWord.Items.IndexOf(Mainqr.fieldByName('keywordsword').AsString);
    fm.reText.Lines.Text:=Mainqr.fieldByName('textannouncement').AsString;
    fm.edContactPhone.Text:=Mainqr.fieldByName('contactphone').AsString;
    fm.edHomePhone.Text:=Mainqr.fieldByName('homephone').AsString;
    fm.edWorkPhone.Text:=Mainqr.fieldByName('workphone').AsString;
    fm.meAbout.Lines.Text:=Mainqr.fieldByName('about').AsString;
    fm.udCopyPrint.Position:=Mainqr.fieldByName('copyprint').AsInteger;
    fm.oldannouncement_id:=Mainqr.fieldByName('announcement_id').AsInteger;
    fm.edWhoIn.Text:=Mainqr.fieldByName('whoin').AsString;
    fm.edWhoChange.Text:=Mainqr.fieldByName('whochange').AsString;

    fm.ClearListBlackList;
    fm.FillListBlackList;
    fm.InBlackListAllFields;

    fm.meTextExit(nil);

    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     Mainqr.AfterScroll:=nil;
     MainQr.Locate('announcement_id',fm.oldannouncement_id,[loCaseInsensitive]);
     Mainqr.AfterScroll:=MainqrAfterScroll;
     MainqrAfterScroll(Mainqr);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAnnouncement.bibDelClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbAnnouncement+' where announcement_id='+
          Mainqr.FieldByName('announcement_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
//     ActiveQuery(false);

     IBUpd.DeleteSQL.Clear;
     IBUpd.DeleteSQL.Add(sqls);
     Mainqr.Delete;
     
     ViewCount;

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
    tran.Free; 
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=DeleteWarningEx('текущее объявление ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBAnnouncement.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBAnnouncement;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBAnnouncement.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.reText.OnExit:=nil;
    fm.cmbWord.Style:=csDropDownList;
    fm.edNumRelease.Text:=Trim(Mainqr.fieldByName('releasenumrelease').AsString);
    fm.release_id:=Mainqr.fieldByName('release_id').AsInteger;
    fm.edTreeheading.Text:=Mainqr.fieldByName('treeheadingnameheading').AsString;
    fm.treeheading_id:=Mainqr.fieldByName('treeheading_id').AsInteger;
    fm.FillKeyWordsWord;
    fm.cmbWord.ItemIndex:=fm.cmbWord.Items.IndexOf(Mainqr.fieldByName('keywordsword').AsString);
    fm.reText.Lines.Text:=Mainqr.fieldByName('textannouncement').AsString;
    fm.edContactPhone.Text:=Mainqr.fieldByName('contactphone').AsString;
    fm.edHomePhone.Text:=Mainqr.fieldByName('homephone').AsString;
    fm.edWorkPhone.Text:=Mainqr.fieldByName('workphone').AsString;
    fm.meAbout.Lines.Text:=Mainqr.fieldByName('about').AsString;
    fm.udCopyPrint.Position:=Mainqr.fieldByName('copyprint').AsInteger;
    fm.oldannouncement_id:=Mainqr.fieldByName('announcement_id').AsInteger;
    fm.edWhoIn.Text:=Mainqr.fieldByName('whoin').AsString;
    fm.edWhoChange.Text:=Mainqr.fieldByName('whochange').AsString;

    fm.ClearListBlackList;
    fm.FillListBlackList;
    fm.InBlackListAllFields;

    fm.meTextExit(nil);

    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAnnouncement.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBAnnouncement;
  filstr: string;
begin
 fm:=TfmEditRBAnnouncement.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edNumRelease.OnKeyDown:=fm.edNumReleaseKeyDown;
{  fm.edNumRelease.ReadOnly:=false;
  fm.edNumRelease.Color:=clWindow;}
  fm.cmbWord.Style:=csDropDown;

  fm.edTreeheading.ReadOnly:=false;
  fm.edTreeheading.Color:=clWindow;

  fm.reText.OnExit:=nil;

 { fm.lbAbout.Enabled:=false;
  fm.meAbout.Enabled:=false;
  fm.meAbout.Color:=clBtnface;     }
  fm.lbCopyPrint.Enabled:=false;
  fm.edCopyPrint.Enabled:=false;
  fm.edCopyPrint.Color:=clbtnFace;
  fm.udCopyPrint.Enabled:=false;
  fm.edWhoIn.ReadOnly:=false;
  fm.edWhoIn.Color:=clWindow;
  fm.edWhoChange.ReadOnly:=false;
  fm.edWhoChange.Color:=clWindow;

  if Trim(FindReleaseNumrelease)<>'' then begin
    fm.release_id:=FindReleaseId;
    fm.edNumRelease.Text:=NoteRelease+' ('+FindReleaseNumrelease+')';
    fm.NumRelease:=FindReleaseNumrelease;
    fm.aboutrelease:=NoteRelease;
  end;  
  if Trim(FindTreeHeadingNameHeading)<>'' then fm.edTreeheading.Text:=FindTreeHeadingNameHeading;
  if Trim(FindTextAnnouncement)<>'' then fm.reText.Lines.Text:=FindTextAnnouncement;
  if Trim(FindContactPhone)<>'' then fm.edContactPhone.Text:=FindContactPhone;
  if Trim(FindHomePhone)<>'' then fm.edHomePhone.Text:=FindHomePhone;
  if Trim(FindWorkPhone)<>'' then fm.edWorkPhone.Text:=FindWorkPhone;
  if Trim(FindAbout)<>'' then fm.meAbout.Lines.Text:=FindAbout;
  if Trim(FindKeyWordsWord)<>'' then fm.cmbWord.Text:=FindKeyWordsWord;
  if Trim(FindWhoIn)<>'' then fm.edWhoIn.Text:=FindWhoIn;
  if Trim(FindWhoChange)<>'' then fm.edWhoChange.Text:=FindWhoChange;

  fm.cbInString.Checked:=FilterInSide;

  fm.ClearListBlackList;
  fm.FillListBlackList;
  fm.InBlackListAllFields;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindReleaseNumrelease:=fm.NumRelease;
    NoteRelease:=fm.aboutrelease;
    FindReleaseId:=fm.release_id;
    FindTreeHeadingNameHeading:=Trim(fm.edTreeheading.Text);
    FindTextAnnouncement:=Trim(fm.reText.Lines.Text);
    FindContactPhone:=Trim(fm.edContactPhone.Text);
    FindHomePhone:=Trim(fm.edHomePhone.Text);
    FindWorkPhone:=Trim(fm.edWorkPhone.Text);
    FindAbout:=Trim(fm.meAbout.Lines.Text);
    FindKeyWordsWord:=Trim(fm.cmbWord.Text);
    FindWhoIn:=Trim(fm.edWhoIn.Text);
    FindWhoChange:=Trim(fm.edWhoChange.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBAnnouncement.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7,addstr8,addstr9,addstr10: string;
  and1,and2,and3,and4,and5,and6,and7,and8,and9: string;
  APos: Integer;
  tmps,fmt: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindReleaseNumrelease:=isInteger(FindReleaseNumrelease);
    isFindTreeHeadingNameHeading:=Trim(FindTreeHeadingNameHeading)<>'';
    isFindTextAnnouncement:=Trim(FindTextAnnouncement)<>'';
    isFindContactPhone:=Trim(FindContactPhone)<>'';
    isFindHomePhone:=Trim(FindHomePhone)<>'';
    isFindWorkPhone:=Trim(FindWorkPhone)<>'';
    isFindKeyWordsWord:=Trim(FindKeyWordsWord)<>'';
    isFindAbout:=Trim(FindAbout)<>'';
    isFindWhoIn:=Trim(FindWhoIn)<>'';
    isFindWhoChange:=Trim(FindWhoChange)<>'';

    if isFindReleaseNumrelease or isFindTreeHeadingNameHeading  or
       isFindTextAnnouncement or isFindContactPhone  or isFindHomePhone or
       isFindWorkPhone or isFindKeyWordsWord or isFindAbout or isFindWhoIn or isFindWhoChange then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindReleaseNumrelease then begin
     //   addstr1:=' r.numrelease='+FindReleaseNumrelease+' ';
        addstr1:=' r.release_id='+inttostr(FindReleaseId)+' ';
     end;

     if isFindTreeHeadingNameHeading then begin
        fmt:=Format('select Upper(%s||nameheading||%s) from '+prGetTreeHeadingName+'(%s,t.treeheading_id,1)',
                   [QuotedStr(fmOptions.edBeforeTree.Text),QuotedStr(fmOptions.edAfterTree.Text),QuotedStr(fmOptions.edPointerTree.Text)]);
        addstr2:=' ('+fmt+') like '+AnsiUpperCase(QuotedStr(FilInSide+FindTreeHeadingNameHeading+'%'))+' ';
     end;

     if isFindTextAnnouncement then begin
        addstr3:=' Upper(textannouncement) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTextAnnouncement+'%'))+' ';
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

     if isFindAbout then begin
        addstr8:=' Upper(a.about) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAbout+'%'))+' ';
     end;

     if isFindWhoIn then begin
        addstr9:=' Upper(a.whoin) like '+AnsiUpperCase(QuotedStr(FilInSide+FindWhoIn+'%'))+' ';
     end;

     if isFindWhoChange then begin
        addstr10:=' Upper(a.whochange) like '+AnsiUpperCase(QuotedStr(FilInSide+FindWhoChange+'%'))+' ';
     end;

     if (isFindReleaseNumrelease and isFindTreeHeadingNameHeading)or
        (isFindReleaseNumrelease and isFindTextAnnouncement)or
        (isFindReleaseNumrelease and isFindContactPhone)or
        (isFindReleaseNumrelease and isFindHomePhone)or
        (isFindReleaseNumrelease and isFindWorkPhone)or
        (isFindReleaseNumrelease and isFindKeyWordsWord)or
        (isFindReleaseNumrelease and isFindAbout)or
        (isFindReleaseNumrelease and isFindWhoIn)or
        (isFindReleaseNumrelease and isFindWhoChange)
        then and1:=' and ';

     if (isFindTreeHeadingNameHeading and isFindTextAnnouncement)or
        (isFindTreeHeadingNameHeading and isFindContactPhone)or
        (isFindTreeHeadingNameHeading and isFindHomePhone)or
        (isFindTreeHeadingNameHeading and isFindWorkPhone)or
        (isFindTreeHeadingNameHeading and isFindKeyWordsWord)or
        (isFindTreeHeadingNameHeading and isFindAbout)or
        (isFindTreeHeadingNameHeading and isFindWhoIn)or
        (isFindTreeHeadingNameHeading and isFindWhoChange)
        then and2:=' and ';

     if (isFindTextAnnouncement and isFindContactPhone)or
        (isFindTextAnnouncement and isFindHomePhone)or
        (isFindTextAnnouncement and isFindWorkPhone)or
        (isFindTextAnnouncement and isFindKeyWordsWord)or
        (isFindTextAnnouncement and isFindAbout)or
        (isFindTextAnnouncement and isFindWhoIn)or
        (isFindTextAnnouncement and isFindWhoChange)
        then and3:=' and ';

     if (isFindContactPhone and isFindHomePhone)or
        (isFindContactPhone and isFindWorkPhone)or
        (isFindContactPhone and isFindKeyWordsWord)or
        (isFindContactPhone and isFindAbout)or
        (isFindContactPhone and isFindWhoIn)or
        (isFindContactPhone and isFindWhoChange)
        then and4:=' and ';

     if (isFindHomePhone and isFindWorkPhone)or
        (isFindHomePhone and isFindKeyWordsWord)or
        (isFindHomePhone and isFindAbout)or
        (isFindHomePhone and isFindWhoIn)or
        (isFindHomePhone and isFindWhoChange)
        then and5:=' and ';

     if (isFindWorkPhone and isFindKeyWordsWord)or
        (isFindWorkPhone and isFindAbout)or
        (isFindWorkPhone and isFindWhoIn)or
        (isFindWorkPhone and isFindWhoChange)
        then and6:=' and ';

     if (isFindKeyWordsWord and isFindAbout)or
        (isFindKeyWordsWord and isFindWhoIn)or
        (isFindKeyWordsWord and isFindWhoChange)
        then and7:=' and ';

     if (isFindAbout and isFindWhoIn)or
        (isFindAbout and isFindWhoChange)
        then and8:=' and ';

     if (isFindWhoIn and isFindWhoChange)
        then and9:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4+and4+
                      addstr5+and5+
                      addstr6+and6+
                      addstr7+and7+
                      addstr8+and8+
                      addstr9+and9+
                      addstr10;

     if isFindReleaseNumrelease then begin
       APos:=AnsiPos('where',Result);
       tmps:=Trim(Copy(Result,APos+Length('where'),Length(Result)-(APos+Length('where'))+1));
       Result:=' where ('+tmps+')';
       if Trim(addstr1)<>'' then begin
        APos:=AnsiPos(addstr1,tmps);
        tmps:=Copy(tmps,APos+Length(addstr1),Length(tmps)-(APos+Length(addstr1))+1);
       end;
       Result:=Result+' or (r.numrelease<'+FindReleaseNumrelease+' and (r.numrelease+a.copyprint)>'+
               FindReleaseNumrelease+tmps+' ) ';
     end;
end;

procedure TfmRBAnnouncement.SetCurrentReleaseId;
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' daterelease>='+QuotedStr(DateToStr(_GetDateTimeFromServer))+' ');
  TPRBI.Condition.OrderStr:=PChar(' daterelease ');
  if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
    if ifExistsDataInPRBI(@TPRBI) then begin
      FindReleaseNumrelease:=inttostr(GetFirstValueFromParamRBookInterface(@TPRBI,'numrelease'));
      NoteRelease:=GetFirstValueFromParamRBookInterface(@TPRBI,'about');
      FindReleaseId:=GetFirstValueFromPRBI(@TPRBI,'release_id');
    end;  
  end;
end;

procedure TfmRBAnnouncement.ShowingChanged;
begin
  inherited;
  edTreePath.Width:=pnTreePath.Width-edTreePath.Left;
end;

procedure TfmRBAnnouncement.FormResize(Sender: TObject);
begin
  inherited;
  ShowingChanged;
end;

function GetTreeheadinPath(treeheading_id: Integer): String;
var
  TPRBI: TParamRBookInterface;
  th_id: Integer;
  isFirst: Boolean;
begin
  th_id:=treeheading_id;
  isFirst:=true;
  while true do begin
   FillChar(TPRBI,SizeOf(TPRBI),0);
   TPRBI.Visual.TypeView:=tviOnlyData;
   TPRBI.Condition.WhereStr:=PChar(' treeheading_id='+inttostr(th_id)+' ');
   if _ViewInterfaceFromName(NameRbkTreeHeading,@TPRBI) then begin
     if ifExistsDataInParamRBookInterface(@TPRBI) then begin
       if isFirst then
        Result:=fmOptions.edPointerTree.Text+GetFirstValueFromParamRBookInterface(@TPRBI,'nameheading')
       else
        Result:=fmOptions.edPointerTree.Text+GetFirstValueFromParamRBookInterface(@TPRBI,'nameheading')+Result;

       th_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'parent_id');
       isFirst:=false;
     end else begin
      if Length(Result)>=Length(fmOptions.edPointerTree.Text) then
       Result:=Copy(Result,Length(fmOptions.edPointerTree.Text)+1,Length(Result)-Length(fmOptions.edPointerTree.Text));
      break;
     end;
   end;
  end;
  Result:=fmOptions.edBeforeTree.Text+Result+fmOptions.edAfterTree.Text;
end;

function GetTreeheadinPathNew(treeheading_id: Integer): String;
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.SQL.Select:=PChar('Select nameheading from '+prGetTreeHeadingName+
                          ' ('''+fmOptions.edPointerTree.text+''','+inttostr(treeheading_id)+',1)');

  if _ViewInterfaceFromName(NameRbkQuery,@TPRBI) then begin
    Result:=GetFirstValueFromPRBI(@TPRBI,'nameheading');
  end;
  Result:=fmOptions.edBeforeTree.Text+Result+fmOptions.edAfterTree.Text;
end;

procedure TfmRBAnnouncement.MainqrAfterScroll(DataSet: TDataSet);
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
//  if pnTreePath.Visible then
//    edTreePath.Text:=GetTreeheadinPathNew(Mainqr.FieldByname('treeheading_id').AsInteger);
  if pnDouble.Visible then
    ViewDouble;  
end;

procedure TfmRBAnnouncement.GridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
                                               Column: TColumn; State: TGridDrawState);
begin
 // if Column.Title.Caption='Дата выпуска' then begin
{    if (Mainqr.FieldByName('releasedaterelease').AsDateTime<StrToDate('01.03.2003')) then begin
         if not (gdFocused in State)or not (gdSelected in State) then begin
            Grid.Canvas.Font.Color:=clRed;
//            Grid.Canvas.Brush.Style:=bsClear;
//            Grid.Canvas.FillRect(Rect);
            Grid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
          end else begin
           // Grid.DefaultDrawRowCellSelected(Rect,DataCol,Column,State);
          end;
//       end;

    end;
 // end;  }
end;

procedure TfmRBAnnouncement.ViewDouble;
var
  sqls: string;
begin
  Screen.Cursor:=crHourGlass;
  try
    qrDouble.Active:=false;
    qrDouble.Transaction.Active:=true;


    sqls:=Format(SQLRbkAnnouncementDouble,[QuotedStr(MainQr.FieldByName('textannouncement').AsString),
                                           QuotedStr(fmOptions.edBeforeTree.Text),
                                           QuotedStr(fmOptions.edAfterTree.Text), 
                                           QuotedStr(fmOptions.edPointerTree.Text), 
                                           MainQr.FieldByName('release_id').AsString,
                                           MainQr.FieldByName('announcement_id').AsString,
                                           QuotedStr(MainQr.FieldByName('textannouncement').AsString),
                                           fmOptions.udPercentDouble.Position]);
    qrDouble.SQL.Clear;
    qrDouble.SQL.Add(sqls);
    qrDouble.Active:=true;

  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmRBAnnouncement.GridDoubleOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
{  if key=VK_Delete then
    DeleteDouble;
  if Key=VK_F8 then begin
    SetAdjustColumns(GridDouble.Columns);
  end;}
end;

procedure TfmRBAnnouncement.DeleteDouble;
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbAnnouncement+' where announcement_id='+
            qrDouble.FieldByName('announcement_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     updDouble.DeleteSQL.Clear;
     updDouble.DeleteSQL.Add(sqls);
     qrDouble.Delete;
     
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
    tran.Free; 
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if qrDouble.RecordCount=0 then exit;
  but:=DeleteWarningEx('дубль объявления ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;


procedure TfmRBAnnouncement.bibDoubleDelClick(Sender: TObject);
begin
  DeleteDouble;
end;

procedure TfmRBAnnouncement.bibDoubleAdjustClick(Sender: TObject);
begin
  SetAdjust(GridDouble.Columns,nil);
end;

procedure TfmRBAnnouncement.splMoved(Sender: TObject);
begin
  pnTreePath.Top:=pnDouble.Top+pnDouble.Height+1;
end;

end.
