unit URBQuery;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL, grids,
  DBClient;

type
   TfmRBQuery = class(TfmRBMainGrid)
    spl: TSplitter;
    pnSqlExecute: TPanel;
    grbSqlExecute: TGroupBox;
    pnSqlExecuteBut: TPanel;
    bibSqlExecute: TButton;
    pnSqlExecuteMemo: TPanel;
    meExecute: TMemo;
    pmAction: TPopupMenu;
    miSaveSructureXML: TMenuItem;
    sd: TSaveDialog;
    miSaveSructureWithDataXML: TMenuItem;
    cds: TClientDataSet;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibSqlExecuteClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure miSaveSructureXMLClick(Sender: TObject);
    procedure pmActionPopup(Sender: TObject);
  private
    isFirstQuery: Boolean;
    function Prepeared(s: string; var IsQuery: Boolean): Boolean;
  protected
    procedure GridDblClick(Sender: TObject); override;
  public
    procedure ShowingChanged; override;
    function GetSql: String; override;
    procedure ActiveQuery(CheckPerm: Boolean);override;

    procedure LoadFromIni; override;
    procedure SaveToIni; override;
  end;

var
  fmRBQuery: TfmRBQuery;

implementation

uses UMainUnited, UMainCode,  UMainData,
     IBSQL;

{$R *.DFM}

procedure TfmRBQuery.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameRbkQuery;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  Grid.ReadOnly:=false;
  Grid.ColumnSortEnabled:=false;
  Grid.PopupMenu:=pmAction;

  pnBut.Visible:=false;
  pmGrid.OnPopup:=nil;

  isFirstQuery:=true;

//  miEdit.Visible:=false;
  
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBQuery.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBQuery:=nil;
end;

function TfmRBQuery.Prepeared(s: string; var IsQuery: Boolean): Boolean;
var
  qr: TIBQuery;
  tran: TIBTransaction;
begin
  Result:=false;
  IsQuery:=true;
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
   qr.Database:=IBDB;
   tran.AddDatabase(IBDB);
   IBDB.AddTransaction(tran);
   tran.Params.Text:=DefaultTransactionParamsTwo;
   qr.ParamCheck:=false;
   qr.Transaction:=tran;
   qr.Transaction.Active:=true;
   qr.SQL.Text:=s;
   try
    qr.Prepare;
    IsQuery:=qr.StatementType=SQLSelect;
    Result:=true;
   except
    on E: Exception do begin
     try
       Assert(false,E.message);
     except
       Application.HandleException(nil);
     end;
    end;
   end;
  finally
   qr.Free;
   tran.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure TfmRBQuery.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
 IsQuery: Boolean;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  sqls:=GetSql;
  if Trim(sqls)='' then exit;
  IsQuery:=true;
  Grid.Columns.Clear;
  
  if ShowQuestion(Handle,Format('Выполнить запрос: (%s)?',[sqls]))=mrYes then begin
    if not Prepeared(sqls,IsQuery) then exit;


    Screen.Cursor:=crHourGlass;
    Mainqr.DisableControls;
    try
     Mainqr.sql.Clear;
     Mainqr.sql.Add(sqls);
     Mainqr.Transaction.Active:=false;
     Mainqr.Transaction.Active:=true;
     if IsQuery then
       Mainqr.Active:=true
     else begin
       Mainqr.ExecSQL;
       Mainqr.Transaction.Commit;
     end;
     ViewCount;
    finally
     Mainqr.EnableControls;
     Screen.Cursor:=crDefault;
    end;
  end;  
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBQuery.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBQuery.bibRefreshClick(Sender: TObject);
begin
  isFirstQuery:=false;
  ActiveQuery(true);
end;

procedure TfmRBQuery.bibSqlExecuteClick(Sender: TObject);
begin
  bibRefreshClick(nil);
end;

procedure TfmRBQuery.FormResize(Sender: TObject);
begin
  inherited;
  ShowingChanged;
end;

procedure TfmRBQuery.ShowingChanged;
begin
  edSearch.Width:=pnFind.Width-pnSqlExecute.BorderWidth-edSearch.Left;
end;

function TfmRBQuery.GetSql: String;
begin
  Result:=inherited GetSql;
  if (Trim(Result)<>'') then begin
    if isFirstQuery then begin
      meExecute.Lines.Text:=Result;
      meExecute.SelStart:=Length(meExecute.Lines.Text);
      meExecute.SelLength:=0;
    end else begin
      if meExecute.SelLength>0 then begin
        Result:=Copy(meExecute.Lines.Text,meExecute.SelStart+1,meExecute.SelLength);
      end else
        Result:=meExecute.Lines.Text;
    end;
  end else begin
    if meExecute.SelLength>0 then begin
      Result:=Copy(meExecute.Lines.Text,meExecute.SelStart+1,meExecute.SelLength);
    end else
      Result:=meExecute.Lines.Text;
  end;
end;

procedure TfmRBQuery.LoadFromIni;
begin
  inherited;
  meExecute.Lines.Text:=HexStrToStr(ReadParam(ClassName,meExecute.Name,StrToHexStr(meExecute.Lines.Text)));
  pnSqlExecute.Height:=ReadParam(ClassName,pnSqlExecute.Name,pnSqlExecute.Height);
end;

procedure TfmRBQuery.SaveToIni;
begin
  inherited;
  WriteParam(ClassName,meExecute.Name,StrToHexStr(meExecute.Lines.Text));
  WriteParam(ClassName,pnSqlExecute.Name,pnSqlExecute.Height);
end;

procedure TfmRBQuery.miSaveSructureXMLClick(Sender: TObject);
var
  WithData: Boolean;
  i: Integer;
  pb: Thandle;
  TCPB: TCreateProgressBar;
  TSPBS: TSetProgressBarStatus;
  b: TBookmark;
begin
  sd.DefaultExt:=dfeXML;
  sd.Filter:=fltXML;
  if not sd.Execute then exit;
  Screen.Cursor:=crHourGlass;
  try
    WithData:=Sender=miSaveSructureWithDataXML;
    cds.Active:=false;
    cds.FieldDefs.Clear;
    cds.FieldDefs.Assign(Mainqr.FieldDefs);
    cds.CreateDataSet;
    cds.Active:=true;
    Update;
    if WithData then begin
      Mainqr.DisableControls;
      b:=Mainqr.GetBookmark;
      pb:=0;
      try
        Mainqr.FetchAll;
        TCPB.Min:=0;
        TCPB.Max:=Mainqr.RecordCount;
        TCPB.Hint:='Экспорт данных в XML';
        TCPB.Color:=clNavy;
        pb:=_CreateProgressBar(@TCPB);
        Mainqr.First;
        TSPBS.Progress:=0;
        TSPBS.Hint:='';
        while not Mainqr.Eof do begin
          cds.Append;
          for i:=0 to Mainqr.FieldCount-1 do begin
            cds.Fields[i].Value:=Mainqr.Fields[i].Value;
          end;
          cds.Post;
          Mainqr.Next;
          TSPBS.Progress:=TSPBS.Progress+1;
          _SetProgressBarStatus(pb,@TSPBS);
        end;
      finally
        _FreeProgressBar(pb);
        Mainqr.GotoBookmark(b);
        Mainqr.EnableControls;
      end;
    end;
  finally
    cds.SaveToFile(sd.FileName);
    Screen.Cursor:=crDefault;
  end;  
end;

procedure TfmRBQuery.pmActionPopup(Sender: TObject);
begin
  miSaveSructureXML.Enabled:=Mainqr.Active;
  miSaveSructureWithDataXML.Enabled:=Mainqr.Active;
end;

end.
