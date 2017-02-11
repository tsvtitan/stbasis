unit WinTab;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, DBCtrls, StdCtrls, Grids, DBGrids, Db, IBCustomDataSet, IBTable,
  IBQuery, inifiles, Data, IBDatabase{,Kassa};

type
  TFTable = class(TForm)
    BAdd: TButton;
    BEdit: TButton;
    BDel: TButton;
    BRef: TButton;
    BAcc: TButton;
    BFilter: TButton;
    BTun: TButton;
    BClose: TButton;
    EFind: TEdit;
    LFind: TLabel;
    DBNavigator: TDBNavigator;
    LSelect: TLabel;
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    IBTable: TIBQuery;
    IBTransaction: TIBTransaction;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BDelClick(Sender: TObject);
    procedure IBTableAfterRefresh(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EFindKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BRefClick(Sender: TObject);
    procedure BAccClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EFindKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridTitleClick(Column: TColumn);
    procedure DBGridDblClick(Sender: TObject);
  private
  protected
    SourceQuery: string;
    NewLeft,NewTop,NewWidth,NewHeight: Integer;
    NewWindowState: TWindowState;
    Condition: string;
    procedure SaveToIni;dynamic;
    procedure LoadFromIni;dynamic;
    procedure SetNewPosition;
  public
    FilterInSide: Boolean;
    ModeView: Bool;
    procedure ActivateQuery;
    procedure SetCondition(Cond: string);virtual;
  end;

var
  FTable: TFTable;

implementation

{$R *.DFM}

procedure TFTable.FormResize(Sender: TObject);
begin
  BAdd.Left := Width - 88;
  BEdit.Left := Width - 88;
  BDel.Left := Width - 88;
  BRef.Left := Width - 88;
  BAcc.Left := Width - 88;
  BFilter.Left := Width - 88;
  BTun.Left := Width - 88;
  BClose.Left := Width - 88;
  BClose.Top := Height - 54;
  DBGrid.Width := Width - 105;
  DBGrid.Height := Height - 105;
  EFind.Width := Width - 150;
  DBNavigator.Top := Height - 50;
  LSelect.Top := Height - 48;
end;

procedure TFTable.FormCreate(Sender: TObject);
begin
  Caption:='';
{  IBDatabase.DatabaseName := Form1.OpenDialog.FileName;
  IBDatabase.Connected := True;
  IBTransaction.Active := True;}
  IBTable.Database := Form1.IBDatabase;
  IBTable.Transaction := IBTransaction;
  if MView then begin
    FormStyle := fsNormal;
    BAdd.Visible := False;
    BEdit.Visible := False;
    BDel.Visible := False;
    WindowState := wsNormal;
    Left := (Screen.Width div 2)-300;
    Top := (Screen.Height div 2)-165;
    Width := 400;
    Height := 335;
    Visible := True;
  end
  else begin
    WindowState := wsMinimized;
    FormStyle := fsMDIChild;
    Visible := True;
  end;
end;

procedure TFTable.BAddClick(Sender: TObject);
begin
  Caption:=Caption;
end;

procedure TFTable.BCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TFTable.FormActivate(Sender: TObject);
begin
  if (IBTable.Active)  then
    LSelect.Caption := 'Всего выбрано: ' + IntToStr(GetRecordCount(IBTable));
{  if ModeView then begin
    Left := (Screen.Width div 2)-300;
    Top := (Screen.Height div 2)-165;
    Width := 600;
    Height := 335;
  end;}
end;

procedure TFTable.BEditClick(Sender: TObject);
begin
  Caption := Caption;
end;

procedure TFTable.BDelClick(Sender: TObject);
begin
//
end;

procedure TFTable.IBTableAfterRefresh(DataSet: TDataSet);
begin
  try
    if (IBTable.SQL.Count <> 0) and (OnCloseForm = false) then begin
      BRefClick(nil);
      FormActivate(nil);
    end;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFTable.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caFree;
 SaveToIni;
end;

procedure TFTable.EFindKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Down then
    DBGrid.SetFocus;
end;

procedure TFTable.BRefClick(Sender: TObject);
begin
  ActivateQuery;
end;

procedure TFTable.BAccClick(Sender: TObject);
begin
//
end;

procedure TFTable.SaveToIni;
var
  fi: TIniFile;

  procedure SaveFormProp;
  begin
    if FormState=[fsCreatedMDIChild] then begin
     fi.WriteInteger(ClassName,'Left',Left);
     fi.WriteInteger(ClassName,'Top',Top);
     fi.WriteInteger(ClassName,'Width',Width);
     fi.WriteInteger(ClassName,'Height',Height);
     fi.WriteInteger(ClassName,'WindowState',Integer(WindowState));
    end;
  end;

  procedure SaveGridProp;
  var
    i: Integer;
    cl: TColumn;
  begin
    if DBGrid=nil then exit;
    if DBGrid.Columns.Count=0 then exit;
    for i:=0 to DBGrid.Columns.Count-1 do begin
      cl:=DBGrid.Columns.Items[i];
      fi.WriteInteger(ClassName,'ColumnID'+inttostr(i),cl.ID);
      fi.WriteInteger(ClassName,'ColumnIndex'+inttostr(i),cl.Index);
      fi.WriteInteger(ClassName,'ColumnWidth'+inttostr(i),cl.Width);
      fi.WriteBool(ClassName,'ColumnVisible'+inttostr(i),cl.Visible);
    end;
  end;

begin
  try
    fi:=nil;
    try
      fi:=TIniFile.Create(StrPas('Project1.ini'));
      if FormState=[fsCreatedMDIChild] then begin
        SaveFormProp;
        SaveGridProp;
      end;
    finally
      fi.free;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFTable.FormDestroy(Sender: TObject);
begin
//  IBTable.SQL.Clear;
  SaveToIni;
end;

procedure TFTable.LoadFromIni;
var
  fi1: TIniFile;

  procedure LoadFormProp;
  begin
    NewWindowState:=TWindowState(fi1.ReadInteger(ClassName,'WindowState',Integer(WindowState)));
    if NewWindowState<>wsMaximized then begin
     NewLeft:=fi1.ReadInteger(ClassName,'Left',Left);
     NewTop:=fi1.ReadInteger(ClassName,'Top',Top);
     NewWidth:=fi1.ReadInteger(ClassName,'Width',Width);
     NewHeight:=fi1.ReadInteger(ClassName,'Height',Height);
    end;
  end;

  procedure LoadGridProp;
  var
    i: Integer;
    cl: TColumn;
    id: Integer;
  begin
    if DBGrid=nil then exit;
    if DBGrid.Columns.Count=0 then exit;
    for i:=0 to DBGrid.Columns.Count-1 do begin
      id:=fi1.ReadInteger(ClassName,'ColumnID'+inttostr(i),i);
      cl:=TColumn(DBGrid.Columns.FindItemID(id));
      if cl<>nil then begin
       cl.Index:=fi1.ReadInteger(ClassName,'ColumnIndex'+inttostr(i),cl.Index);
       cl.Width:=fi1.ReadInteger(ClassName,'ColumnWidth'+inttostr(i),cl.Width);
       cl.Visible:=fi1.ReadBool(ClassName,'ColumnVisible'+inttostr(i),cl.Visible);
      end;
    end;
  end;

begin
  try
    fi1:=nil;
    try
      fi1:=TIniFile.Create(StrPas('Project1.ini'));
      if FormState=[fsCreatedMDIChild] then begin
//      fi1.UpdateFile;
        LoadFormProp;
        LoadGridProp;
        SetNewPosition;
      end;
    finally
      fi1.free;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFTable.SetNewPosition;
begin
  if (FormState=[fsCreatedMDIChild]) then begin
 //   WindowState := wsMinimized;
//    Visible := true;
    if NewWindowState<>wsMaximized then begin
      Left:=NewLeft;
      Top:=NewTop;
      Width:=NewWidth;
      Height:=NewHeight;
    end;
    Visible := true;
    WindowState:=NewWindowState;
  end;
end;

procedure TFTable.ActivateQuery;
var
 sqls: String;
begin
 try
  IBTable.Active:=false;
  Screen.Cursor:=crHourGlass;
  try
   sqls := IBTable.sql.Text;
   IBTable.sql.Clear;
   IBTable.sql.Add(sqls);
   IBTable.Transaction.Active:=false;
   IBTable.Transaction.Active:=true;
   IBTable.Active:=true;
   FormActivate(nil);
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFTable.EFindKeyUp(Sender: TObject; var Key: Word;
 Shift: TShiftState);
begin
  if not IBTable.Active then Exit;
  if EFind.Text<>'' then
    IBTable.Locate(DBGrid.SelectedField.FieldName,EFind.Text,[loPartialKey]);

end;

procedure TFTable.DBGridTitleClick(Column: TColumn);
var
  sqls1,NameField: string;
  Pos: integer;
  Buffer: array [0..1000] of char;
begin
  Pos := AnsiPos('Order by',IBTable.SQL.Text);
  NameField := Column.FieldName;
  if Column.FieldName='SUBKONTO_NAME' then
    NameField := 'K1.SUBKONTO_NAME';
  if Column.FieldName='SUBKONTO_NAME1' then
    NameField := 'K2.SUBKONTO_NAME';
  if Column.FieldName='SUBKONTO_NAME2' then
    NameField := 'K3.SUBKONTO_NAME';
  if Column.FieldName='PA_GROUPID1' then
    NameField := 'P2.PA_GROUPID';
  if Column.FieldName='FNAME1' then
    NameField := 'E2.FNAME';
  if Pos=0 then begin
    IBTable.SQL.Add(' Order by '+NameField);
  end
  else begin
    StrLCopy(Buffer,PChar(IBTable.SQL.Text),Pos-1);
    sqls1:=Buffer;
    sqls1 := sqls1 + ' Order by ' + NameField;
    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls1);
  end;
  ActivateQuery;

end;

procedure TFTable.DBGridDblClick(Sender: TObject);
begin
//
end;

procedure TFTable.SetCondition(Cond: string);
var
  sqls: string;
begin
  if Cond<>'' then begin
    Condition := Cond;
     if (AnsiPos('where',SourceQuery)=0) then
       sqls := SourceQuery + ' where ' + Condition
     else
       sqls := SourceQuery + ' AND ' + Condition;
//    sqls := SourceQuery + ' AND ' + Condition;
    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    ActivateQuery;
    if (IBTable.IsEmpty) then begin
      Application.MessageBox(PChar('Записей нет'),PChar('Ошибка'),
         MB_OK+MB_ICONERROR);
         Abort;
    end;     
  end;
end;

end.


