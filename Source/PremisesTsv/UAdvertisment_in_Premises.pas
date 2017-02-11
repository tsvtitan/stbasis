unit UAdvertisment_in_Premises;

interface

uses
 Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons,
  tsvDbGrid, IBCustomDataSet, IBQuery, IBTable,
  ImgList, Db, menus, IBDatabase, IBEvents, IBSQLMonitor,
  IBUpdateSQL, UMainForm, tsvDbOrder, tsvDbFilter, XPMan, Provider,
  DBClient,IB,URBMainGrid;

type
  TfmAdvertisment_in_Premises = class(TForm)
    IBTran: TIBTransaction;
    Mainqr: TIBQuery;
    ds: TDataSource;
    IBUpd: TIBUpdateSQL;
    CDS: TClientDataSet;
    DSP: TDataSetProvider;
    pn: TPanel;
    PanelBottom: TPanel;
    bibOk: TButton;
    bibCancel: TButton;
    bibInterface: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
        DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridCellClick(Column: TColumn);
    procedure bibOkClick(Sender: TObject);
    procedure bibCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibInterfaceClick(Sender: TObject);
  private
    { Private declarations }
  protected

  public

     Pms_Premises_id: integer;
     Pms_Agent_id: integer;
     TypeOperation: integer;
//     isEdit,isView:boolean;
     isView:boolean;
     DBGrid: TNewdbGrid;
     fmParent:TForm;
     itf:string;
     procedure ActiveQuery;
    { Public declarations }
  end;

var
  fmAdvertisment_in_Premises: TfmAdvertisment_in_Premises;

implementation

uses UMainUnited, UPremisesTsvCode, UPremisesTsvDM, UPremisesTsvData,
  UEditRBPms_Premises;

{$R *.DFM}


procedure TfmAdvertisment_in_Premises.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
DataCol: integer; Column: TColumn; State: TGridDrawState);

   procedure DrawChecked(rt: TRect; isCheck: Boolean);
   begin
     if not isCheck then Begin
       DrawFrameControl(DBGrid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
     end else begin
       DrawFrameControl(DBGrid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
     end;
   end;

var
  rt: TRect;
begin
  if ds.dataset.Active and not ds.dataset.IsEmpty then begin
    rt.Right:=rect.Right;
    rt.Left:=rect.Left;
    rt.Top:=rect.Top+2;
    rt.Bottom:=rect.Bottom-2;
    if Column.Title.Caption='Выбор' then DrawChecked(rt,Boolean(CDS.FieldByName('check_adv').AsInteger));
  end;
end;


procedure TfmAdvertisment_in_Premises.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
try

  DBGrid.Free;
  CDS.active:=false;
  CloseAllSql(Self);

 except
  raise;
 end;
end;

procedure TfmAdvertisment_in_Premises.DBGridCellClick(Column: TColumn);
begin
  if Column.Title.Caption='Выбор' then
   begin
     CDS.Edit;
     case CDS.FieldByName('check_adv').asInteger of
       0: begin
         if CDS.FieldByName('amount').asInteger<>CDS.FieldByName('amount_use').asInteger
         then   begin
              CDS.FieldByName('amount_use').asInteger:=CDS.FieldByName('amount_use').asInteger+1;
              CDS.FieldByName('check_adv').AsInteger:=1;
             end;
         end;
       1: begin
              CDS.FieldByName('amount_use').asInteger:=CDS.FieldByName('amount_use').asInteger-1;
              CDS.FieldByName('check_adv').AsInteger:=0;
       end;
     end;
    CDS.Post;
   end;
end;

procedure TfmAdvertisment_in_Premises.bibOkClick(Sender: TObject);
var
 sqldel,sqladd:string;

 qr: TIBQuery;
begin

try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  CDS.DisableControls;
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    //************************
    sqldel:=' delete  from '+tbPms_Premises_Advertisment+' where pms_agent_id='+inttostr(Pms_Agent_id)+
        ' and pms_premises_id='+inttostr(Pms_Premises_id)+';' ;
    qr.SQL.Clear;
    qr.SQL.Add(sqldel);
    qr.ExecSQL;
    qr.Transaction.Commit;
    CDS.First;
    sqladd:='';

{    if Boolean(CDS.FieldByName('check_adv').asInteger) then begin
      sqladd:=' Insert into '+tbPms_Premises_Advertisment+
        ' (Pms_Advertisment_id,Pms_Premises_id,Pms_Agent_id) values '+
        ' ('+inttostr(CDS.FieldByName('Pms_Advertisment_id').asInteger)+
        ','+inttostr(Pms_Premises_id)+
        ','+inttostr(Pms_Agent_id)+'); ';
      qr.SQL.Clear;
      qr.SQL.Add(sqladd);
      qr.ExecSQL;
      qr.Transaction.Commit;

    end;
    CDS.Next;
    repeat
        if Boolean(CDS.FieldByName('check_adv').asInteger) then begin
        sqladd:=' Insert into '+tbPms_Premises_Advertisment+
          ' (Pms_Advertisment_id,Pms_Premises_id,Pms_Agent_id) values '+
          ' ('+inttostr(CDS.FieldByName('Pms_Advertisment_id').asInteger)+
          ','+inttostr(Pms_Premises_id)+
          ','+inttostr(Pms_Agent_id)+'); ';
        qr.SQL.Clear;
        qr.SQL.Add(sqladd);
        qr.ExecSQL;
        qr.Transaction.Commit;
        end;
        CDS.Next;
    until CDS.Eof  ;}

    while not CDS.Eof do begin
      if Boolean(CDS.FieldByName('check_adv').asInteger) then begin
        sqladd:=' Insert into '+tbPms_Premises_Advertisment+
          ' (Pms_Advertisment_id,Pms_Premises_id,Pms_Agent_id) values '+
          ' ('+inttostr(CDS.FieldByName('Pms_Advertisment_id').asInteger)+
          ','+inttostr(Pms_Premises_id)+
          ','+inttostr(Pms_Agent_id)+'); ';
        qr.SQL.Clear;
        qr.SQL.Add(sqladd);
        qr.ExecSQL;
        qr.Transaction.Commit;
      end;
      CDS.Next;
    end;

  finally
    CDS.EnableControls;
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
 ModalResult:=mrOk;
end;

procedure TfmAdvertisment_in_Premises.bibCancelClick(Sender: TObject);
begin
 inherited;
 ModalResult:=mrCancel;
end;

procedure TfmAdvertisment_in_Premises.ActiveQuery ;
var
  sqls:string;
begin


try
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  CDS.Active:=false;
  Mainqr.Active:=false;
  Screen.Cursor:=crHourGlass;
  Mainqr.DisableControls;
  try
   Mainqr.sql.Clear;

   sqls:=' select'+
    ' a.pms_advertisment_id,'+
    ' a.name,'+
    ' a.amount,'+
    '(select count(*) from pms_premises_advertisment pa join pms_agent ag on ag.pms_agent_id=pa.pms_agent_id '+
    ' where pa.pms_advertisment_id=a.pms_advertisment_id '+
    ' and ag.sync_office_id=(select valueview from constex where Upper(name)='+QuotedStr('ОФИС')+')) as amount_use, '+
    ' (select count(*) from pms_premises_advertisment pa'+
    ' where pa.pms_premises_id='+inttostr(Pms_Premises_id)+' and pa.pms_agent_id='+inttostr(Pms_Agent_id)+
    ' and pa.pms_advertisment_id=a.pms_advertisment_id) as check_adv'+
    ' from pms_advertisment a '+
    ' where a.typeoperation='+inttostr(TypeOperation)+
    ' order by a.sortnumber';


   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   CDS.Active:=true;
   if isView then begin
     DBGrid.Enabled:=false;
   end;
   bibOk.Enabled:=not isView;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
end;

end;


procedure TfmAdvertisment_in_Premises.FormCreate(Sender: TObject);
var
 sqlsel:string;
 
begin
  try
    {Mainqr.Database:=IBDB;
    IBTran.AddDatabase(IBDB);
    IBDB.AddTransaction(IBTran); }
    try
      Mainqr.Database:=IBDB;
      IBTran.AddDatabase(IBDB);
      IBDB.AddTransaction(IBTran);
      Screen.Cursor:=crHourGlass;
      Mainqr.sql.Clear;
      sqlsel:=' select * from constex where name='+QuotedStr('ITF')+';' ;
      Mainqr.sql.Add(sqlsel);
      Mainqr.Transaction.Active:=false;
      Mainqr.Transaction.Active:=true;
      Mainqr.Active:=true;
      bibInterface.Visible:=false;
      if Mainqr.IsEmpty=false then
      begin
       Mainqr.First;
       itf:=Mainqr.Fields[4].AsString;
       bibInterface.Visible:=true;
      end;
  //handle:=_GetInterfaceHandleFromName(PChar(itf));
    finally
       Mainqr.Active:=false;
       Screen.Cursor:=crDefault;
    end;


    DBGrid:=TNewdbGrid.Create(nil);
    DBGrid.Parent:=pn;
    DBGrid.OnDrawColumnCell:=DBGridDrawColumnCell;
    DBGrid.OnCellClick:=DBGridCellClick;
    DBGrid.OnKeyDown:=DBGridKeyDown;
    DBGrid.Align:=alClient;
    DBGrid.Width:=Width-10;
    DBGrid.Height:=300;
    DBGrid.Name:='Grid';
    DBGrid.RowSelected.Visible:=true;
    DBGrid.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
    AssignFont(_GetOptions.RBTableFont,DBGrid.Font);
    DBGrid.TitleFont.Assign(DBGrid.Font);
    DBGrid.RowSelected.Font.Assign(DBGrid.Font);
    DBGrid.RowSelected.Brush.Style:=bsClear;
    DBGrid.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
    DBGrid.RowSelected.Font.Color:=clWhite;
    DBGrid.RowSelected.Pen.Style:=psClear;
    DBGrid.CellSelected.Visible:=true;
    DBGrid.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
    DBGrid.CellSelected.Font.Assign(DBGrid.Font);
    DBGrid.CellSelected.Font.Color:=clHighlightText;
    DBGrid.TitleCellMouseDown.Font.Assign(DBGrid.Font);
    DBGrid.Options:=DBGrid.Options-[dgEditing]-[dgTabs];
    DBGrid.RowSizing:=true;
    DBGrid.ReadOnly:=true;
    DBGrid.TabOrder:=0;
    DBGrid.Visible:=true;
    DBGrid.DataSource:=ds;
    DBGrid.ColumnSortEnabled:=false;

    with DBGrid.Columns.Add do begin
      FieldName:='name';
      Title.Caption:='Наименование рекламы';
      Width:=300;
    end;

    with DBGrid.Columns.Add do begin
      FieldName:='amount_use';
      Title.Caption:='Использовано';
      Width:=40;
    end;
    with DBGrid.Columns.Add do begin
      FieldName:='amount';
      Title.Caption:='Всего';
      Width:=40;
    end;
    with DBGrid.Columns.Add do begin
      Title.Caption:='Выбор';
      Width:=40;
    end;

   except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
   end;
end;





procedure TfmAdvertisment_in_Premises.DBGridKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 //
  if DBGrid.SelectedIndex=3 then
   if key=VK_SPACE then DBGridCellClick(DBGrid.Columns.Items[3]);
end;

procedure TfmAdvertisment_in_Premises.bibInterfaceClick(Sender: TObject);

var


 TPRBI: TParamRBookInterface;

begin

try


  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  
  _ViewInterfaceFromName(PChar(itf), @TPRBI);



finally
   ActiveQuery;
end;



end;

end.



