unit URBPms_Image;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL, tsvDbImage;

type

   TDBImage=class(tsvDbImage.TtsvDBImage)
   end;

   TfmRBPms_Image = class(TfmRBMainGrid)
    pnImage: TPanel;
    splBottom: TSplitter;
    dbi: TDBImage;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindStreet: Boolean;
    FindStreet: String;
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBPms_Image: TfmRBPms_Image;

implementation

uses UMainUnited, UPremisesTsvCode, UPremisesTsvDM, UPremisesTsvData, UEditRBPms_Image, tsvPicture;

{$R *.DFM}

procedure TfmRBPms_Image.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkPms_Image;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  
  cl:=Grid.Columns.Add;
  cl.FieldName:='street_name';
  cl.Title.Caption:='Улица';
  cl.Width:=250;

  cl:=Grid.Columns.Add;
  cl.FieldName:='housenumber';
  cl.Title.Caption:='Дом';
  cl.Width:=80;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Image.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBPms_Image:=nil;
end;

function TfmRBPms_Image.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkPms_Image+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBPms_Image.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
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
   SetImageFilter(isFindStreet);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Image.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if AnsiSameText(fn,'street_name') then fn:='s.name';
   id:=MainQr.fieldByName('Pms_Image_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('Pms_Image_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Image.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBPms_Image.LoadFromIni;
begin
 inherited;
 try
    FindStreet:=ReadParam(ClassName,'Street',FindStreet);
    pnImage.Height:=ReadParam(ClassName,pnImage.Name,pnImage.Height);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Image.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'Street',FindStreet);
    WriteParam(ClassName,pnImage.Name,pnImage.Height);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Image.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBPms_Image.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBPms_Image;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBPms_Image.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('Pms_Image_id',fm.oldPms_Image_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Image.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBPms_Image;
  ms: TMemoryStream;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPms_Image.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbChange;
    fm.street_id:=Mainqr.fieldByName('pms_street_id').AsInteger;
    fm.edStreet.Text:=Mainqr.fieldByName('street_name').AsString;
    fm.edHouseNumber.Text:=Mainqr.fieldByName('housenumber').AsString;
    ms:=TMemoryStream.Create;
    try
      TBlobField(Mainqr.fieldByName('image')).SaveToStream(ms);
      ms.Position:=0;
      TtsvPicture(fm.imImage.Picture).LoadFromStream(ms);
    finally
      ms.Free;
    end;
    fm.oldPms_Image_id:=MainQr.FieldByName('Pms_Image_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('Pms_Image_id',fm.oldPms_Image_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Image.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbPms_Image+' where Pms_Image_id='+
          Mainqr.FieldByName('Pms_Image_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

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
  but:=DeleteWarningEx('изображение дома <'+Mainqr.FieldByName('housenumber').AsString+
                       '> по улице <'+Mainqr.FieldByName('street_name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBPms_Image.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBPms_Image;
  ms: TMemoryStream;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPms_Image.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.street_id:=Mainqr.fieldByName('pms_street_id').AsInteger;
    fm.edStreet.Text:=Mainqr.fieldByName('street_name').AsString;
    fm.edHouseNumber.Text:=Mainqr.fieldByName('housenumber').AsString;
    ms:=TMemoryStream.Create;
    try
      TBlobField(Mainqr.fieldByName('image')).SaveToStream(ms);
      ms.Position:=0;
      TtsvPicture(fm.imImage.Picture).LoadFromStream(ms);
    finally
      ms.Free;
    end;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Image.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBPms_Image;
  filstr: string;
begin
 fm:=TfmEditRBPms_Image.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;
  fm.lbImage.Enabled:=false;
  fm.bibImageLoad.Enabled:=false;
  fm.bibImageSave.Enabled:=false;
  fm.lbHouseNumber.Enabled:=false;
  fm.edHouseNumber.Enabled:=false;
  fm.edHouseNumber.Color:=clBtnFace;
  fm.edStreet.ReadOnly:=false;
  fm.edStreet.Color:=clWindow;

  if Trim(FindStreet)<>'' then fm.edStreet.Text:=FindStreet;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindStreet:=Trim(fm.edStreet.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBPms_Image.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindStreet:=Trim(Findstreet)<>'';

    if isFindstreet then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindstreet then begin
        addstr1:=' Upper(s.name) like '+AnsiUpperCase(QuotedStr(FilInSide+Findstreet+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


end.
