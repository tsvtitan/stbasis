unit CashAppend;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinTab, Db, IBCustomDataSet, IBQuery, Grids, DBGrids, ExtCtrls, DBCtrls,
  StdCtrls, Kassa, AddCA, EditCA, Data, IB, inifiles, FilterCA, WTun;

type
  TFCashAppend = class(TFTable)
    procedure FormCreate(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BDelClick(Sender: TObject);
    procedure BAccClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormAddClose(Sender: TObject);
    procedure BFilterClick(Sender: TObject);
    procedure BTunClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
  private
    FindText: string;
    OldRecId: string;
    procedure SaveToIni;
    procedure LoadFromIni;
    function CompareQuery (List: TStrings): string;
  public
    { Public declarations }
  end;

var
  FCashAppend: TFCashAppend;

implementation

procedure TFCashAppend.FormCreate(Sender: TObject);
var
   sqls: string;
   cl:TColumn;
   List: TStrings;
begin
 inherited;
  try
    List := TStringList.Create;

    Caption := 'Приложения кассовых ордеров';
{    IBTable.Database := IBDatabase;
    IBTable.Transaction := IBTransaction;}
    sqls := 'select * from CASHAPPEND';
    SourceQuery := sqls;
    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    IBTable.Active := True;

    DBGrid.Columns.Clear;
    cl:=DBGrid.Columns.Add;
    cl.FieldName:='CA_TEXT';
    cl.Title.Caption:='Текст';
    cl.Width:=250;

    BFilter.OnClick := BFilterClick;
    BTun.OnClick := BTunClick;
    OnDestroy := FormDestroy;
    DBGrid.OnDblClick := DBGridDblClick;

    LoadFromIni;
    List.Add(FindText);
    sqls := CompareQuery(List);
    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    IBTable.Active := True;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFCashAppend.BAddClick(Sender: TObject);
var
 FAdd: TFAddCA;
begin
  try
    if not IBTable.Active then exit;
    FAdd :=TFAddCA.Create(nil);
    try
      OldRecId :=IBTable.FieldByName('CA_ID').AsString;
       if FAdd.ShowModal = mrok then begin
      end;
    finally
      FAdd.free;
      ActivateQuery;
      IBTable.Locate('CA_ID',OldRecId,[loCaseInsensitive]);
    end;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCashAppend.BEditClick(Sender: TObject);
var
   fm: TFEditCA;
begin
  try
    if not IBTable.Active then exit;
      IDRec := IBTable.FieldByName('CA_Id').AsInteger;
      fm := TFEditCA.Create(nil);
      try
        fm.Edit.Text := Trim(IBTable.FieldByName('CA_Text').AsString);
        if fm.ShowModal=mrok then begin
        end;
      finally
        fm.free;
        ActivateQuery;
        IBTable.Locate('CA_ID',IdRec,[loCaseInsensitive]);
      end;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCashAppend.BDelClick(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
begin
 try
  qr:=TIBQuery.Create(nil);
  if(Application.MessageBox(Pchar('Удалить приложение <'+Trim(IBTable.FieldByName('CA_Text').AsString)+' >?'),
     Pchar('Подтверждение'), MB_YESNO + MB_ICONQUESTION) = IDNO) then Abort;
  try
     sqls := 'Delete from CashAppend where CA_ID = '+ IBTable.FieldByName('CA_ID').AsString;
     IBTable.Next;
     OldRecId := IBTable.FieldByName('CA_ID').AsString;
     qr.Database:=Form1.IBDatabase;
     qr.Transaction := Form1.IBTransaction;
     qr.Transaction.Active:=true;
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
  finally
     qr.Free;
     ActivateQuery;
     IBTable.Locate('CA_ID',OldRecId,[loCaseInsensitive]);
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCashAppend.BAccClick(Sender: TObject);
var
 fm: TFAddCA;
begin
  try
    fm := TFAddCA.Create(nil);
    try
      fm.Caption := 'Подробная информация';
      fm.BOk.Visible := false;
      fm.BCancel.Caption := 'Закрыть';
      fm.Edit.Text := IBTable.FieldByName('CA_TEXT').AsString;
      fm.BOk.OnClick := fm.BCancel.OnClick;
      fm.Edit.ReadOnly := true;
      fm.Edit.Enabled := false;
//      fm.Edit.Font.Color := clBlack;
      fm.BCancel.TabOrder := 0;
      fm.Edit.TabOrder := 1;
      if fm.ShowModal=mrok then
        fm.BCancel.SetFocus;
    finally
      fm.Free;
   end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCashAppend.SaveToIni;
var
  fi: TIniFile;
begin
 inherited;
 try
  fi:=TIniFile.Create('Project1.ini');
  try
    fi.WriteString(ClassName,'CA_TEXT',FindText);
    fi.WriteBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCashAppend.FormDestroy(Sender: TObject);
begin
  SaveToIni;
end;

procedure TFCashAppend.FormAddClose(Sender: TObject);
begin
  BRef.OnClick(nil);
end;

{procedure TFCashBasis.FormDestroy(Sender: TObject);
begin
  Caption := Caption;
end;}

procedure TFCashAppend.BFilterClick(Sender: TObject);
var
  fm: TFCAFilter;
  sqls: string;
begin
  try
    if not IBTable.Active then Exit;
    fm := TFCAFilter.Create(nil);
    sqls := SourceQuery;
    try
      fm.Edit.Text := FindText;
      fm.CheckBox.Checked := FilterInSide;
      fm.ShowModal;
      if TempList.Count=0 then Abort;
      FilterInSide := inside;
      FindText := TempList.Strings[0];
      IBTable.Active := false;
      IBTable.SQL.Clear;
      if FindText<>'' then
         sqls := CompareQuery(TempList);
      IBTable.SQL.Add(sqls);
      ActivateQuery;
    finally
      fm.Free;
      inside := false;
      TempList.Clear;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
 end;

function TFCashAppend.CompareQuery (List: TStrings): string;
var
  sqls: string;
begin
  try
    sqls:='';
    if List[0]<>'' then begin
      if not FilterInSide then
        sqls := ' Upper(CA_TEXT)='+''#39''+AnsiUpperCase(List.Strings[0])+''#39'';
      if FilterInSide then
        sqls := ' Upper(CA_TEXT) LIKE' + '('#39'%'+ AnsiUpperCase(FindText) + '%'#39')';
      if (AnsiPos('where',SourceQuery)=0) then
        sqls := ' where ' + sqls;
    end;

    Result := SourceQuery + sqls;

  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFCashAppend.BTunClick(Sender: TObject);
var
  fm: TFTuning;
begin
  fm := TFTuning.Create(nil);
  TempList.Clear;
  fm.CLBFields.Items.Add(DBGrid.Columns.Items[0].Title.Caption);
  fm.CLBFields.Checked[0] := True;
  fm.ShowModal;
  fm.free;
end;

procedure TFCashAppend.LoadFromIni;
var
  fi: TIniFile;
begin
 inherited;
 try
  fi:=TIniFile.Create('Project1.ini');
  try
    FindText := fi.ReadString(ClassName,'CA_TEXT',FindText);
    FilterInside := fi.ReadBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCashAppend.DBGridDblClick(Sender: TObject);
begin
  if ModeView then begin
    TempList.Clear;
    TempList.Add(Trim(IBTable.FieldByName('CA_ID').AsString));
    TempList.Add(Trim(IBTable.FieldByName('CA_TEXT').AsString));
    ModalResult := mrOk;
  end;
end;

end.
