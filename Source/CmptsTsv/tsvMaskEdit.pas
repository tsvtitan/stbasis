unit tsvMaskEdit;

interface

{$I stbasis.inc}

uses Windows, Classes,
  Graphics, Forms, Controls, Buttons, Dialogs, StdCtrls, ExtCtrls,
  DsgnIntf, Grids, Mask;

type
  TfmMaskEditor = class(TForm)
    bibOk: TButton;
    bibCancel: TButton;
    sgValues: TStringGrid;
    lbTest: TLabel;
    meTest: TMaskEdit;
    lbChar: TLabel;
    edChar: TEdit;
    bibClear: TButton;
    chbEdit: TCheckBox;
    chbSave: TCheckBox;
    procedure MemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure sgValuesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibClearClick(Sender: TObject);
    procedure chbEditClick(Sender: TObject);
    procedure sgValuesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgValuesSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormDestroy(Sender: TObject);
  private
    procedure SetDefaultValues;
    procedure ViewCurrent(RowIndex: Integer);
    function isEmptyGridFromRow(RowIndex: Integer): Boolean;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure ClearGrid;
  public
    procedure SetCaption(AComponent: TComponent);
  end;

  TMaskProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TMaskEditor = class(TDefaultEditor)
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;


implementation

uses SysUtils, LibHelp, UCmptsTsvData, UCmptsTsvCode, UMainUnited;

{$R *.DFM}

procedure TfmMaskEditor.ClearGrid;
var
  i: Integer;
begin
  for i:=1 to sgValues.RowCount-1 do begin
    sgValues.Cells[0,i]:='';
    sgValues.Cells[1,i]:='';
    sgValues.Cells[2,i]:='';
  end;
  sgValues.RowCount:=2;
end;

{ TfmFilterEditor }

procedure TfmMaskEditor.LoadFromIni;
var
  ms: TMemoryStream;
  rd: TReader;
  tmps: string;
  ctn: Integer;
  i: Integer;
begin
  try
    ms:=TMemoryStream.Create;
    try
      sgValues.ColWidths[0]:=ReadParam(ClassName,'w0',sgValues.ColWidths[0]);
      sgValues.ColWidths[1]:=ReadParam(ClassName,'w1',sgValues.ColWidths[1]);
      sgValues.ColWidths[2]:=ReadParam(ClassName,'w2',sgValues.ColWidths[2]);
      tmps:=ReadParam(ClassName,'Values',tmps);
      rd:=TReader.Create(ms,4096);
      try
        tmps:=HexStrToString(tmps);
        ms.SetSize(Length(tmps));
        FillChar(ms.Memory^,Length(tmps),0);
        Move(Pointer(tmps)^,ms.Memory^,Length(tmps));
        ms.Position:=0;
        ctn:=rd.ReadInteger;
        ClearGrid;
        for i:=0 to ctn-1 do begin
          if i=0 then
          else sgValues.RowCount:=sgValues.RowCount+1;
          sgValues.Cells[0,i+1]:=rd.ReadString;
          sgValues.Cells[1,i+1]:=rd.ReadString;
          sgValues.Cells[2,i+1]:=rd.ReadString;
        end;
      finally
        rd.Free;
      end; 
    finally
      ms.Free;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmMaskEditor.SaveToIni;
var
  i: Integer;
  ms: TMemoryStream;
  wr: TWriter;
  tmps: string;
begin
  try
    ms:=TMemoryStream.Create;
    try
      WriteParam(ClassName,'w0',sgValues.ColWidths[0]);
      WriteParam(ClassName,'w1',sgValues.ColWidths[1]);
      WriteParam(ClassName,'w2',sgValues.ColWidths[2]);
      wr:=TWriter.Create(ms,4096);
      try
       wr.WriteInteger(sgValues.RowCount-1);
       for i:=1 to sgValues.RowCount-1 do begin
        wr.WriteString(sgValues.Cells[0,i]);
        wr.WriteString(sgValues.Cells[1,i]);
        wr.WriteString(sgValues.Cells[2,i]);
       end;
      finally
       wr.Free;
      end;
      SetLength(tmps,ms.Size);
      Move(ms.memory^,Pointer(tmps)^,ms.Size);
      WriteParam(ClassName,'Values',StringToHexStr(tmps));
    finally
      ms.Free;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmMaskEditor.SetCaption(AComponent: TComponent);
begin
  if AComponent<>nil then
   Caption:=Format(fmtSetCaption,['Редактор масок',AComponent.Name])
  else
   Caption:='Редактор масок';
end;

procedure TfmMaskEditor.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then bibCancel.Click;
end;

procedure TfmMaskEditor.FormCreate(Sender: TObject);
begin
  sgValues.Cells[0,0]:='Наименование';
  sgValues.Cells[2,0]:='Пример';
  sgValues.Cells[1,0]:='Значение';
  SetDefaultValues;
  LoadFromIni;
  meTest.EditMask:=sgValues.Cells[2,0];
  edChar.Text:=MaskGetMaskBlank(meTest.EditMask);
  chbSave.Checked:=MaskGetMaskSave(meTest.EditMask);
end;

procedure TfmMaskEditor.SetDefaultValues;
var
  i: Integer;
  
  procedure AddToMaskGrid(s1,s2,s3: string);
  begin
    sgValues.Cells[0,i]:=s1;
    sgValues.Cells[1,i]:=s2;
    sgValues.Cells[2,i]:=s3;
    inc(i);
    sgValues.RowCount:=i+1;
  end;

begin
  i:=1;
  AddToMaskGrid('Телефон','55-55-55','!00-00-00;1;_');
  AddToMaskGrid('Дата','01.01.2002','!90.90.0000;1;_');
  AddToMaskGrid('Время','13:45','!90:00;1;_');
  AddToMaskGrid('Время полное','13:45:59','!90:00:00;1;_');

  if i>2 then begin
    sgValues.RowCount:=i;
  end else begin
    sgValues.RowCount:=2;
  end;
end;

{ TMaskProperty }

function TMaskProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

procedure TMaskProperty.Edit;
var
  comp: TPersistent;
begin
  with TfmMaskEditor.Create(Application) do
  try
    meTest.EditMask:=GetStrValue;
    edChar.Text:=MaskGetMaskBlank(meTest.EditMask);
    chbSave.Checked:=MaskGetMaskSave(meTest.EditMask);

    comp:=GetComponent(0);
    if comp is TComponent then
      SetCaption(TComponent(comp));
    ActiveControl := meTest;
    case ShowModal of
      mrOk: SetStrValue(meTest.EditMask);
    end;
  finally
    Free;
  end;
end;


{ TMaskEditor }

procedure TMaskEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: Edit;
  end;
end;

function TMaskEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Редактор масок';
  else Result := '';
  end;
end;

function TMaskEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TMaskEditor.EditProperty(PropertyEditor: TPropertyEditor;
             var Continue, FreeEditor: Boolean);
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'EditMask') = 0)then
  begin
    PropertyEditor.Edit;
    Continue := False;
    FreeEditor:=false;
  end else
    inherited EditProperty(PropertyEditor, Continue, FreeEditor);
end;


procedure TfmMaskEditor.ViewCurrent(RowIndex: Integer);
begin
  if (RowIndex<1)or(RowIndex>sgValues.RowCount-1) then exit;
  meTest.EditMask:=sgValues.Cells[2,RowIndex];
  edChar.Text:=MaskGetMaskBlank(meTest.EditMask);
  chbSave.Checked:=MaskGetMaskSave(meTest.EditMask);
end;

function TfmMaskEditor.isEmptyGridFromRow(RowIndex: Integer): Boolean;
begin
  Result:=false;
  if (RowIndex<1)or(RowIndex>sgValues.RowCount-1) then exit;
  Result:=(Trim(sgValues.Cells[0,RowIndex])='')and
          (Trim(sgValues.Cells[1,RowIndex])='')and
          (Trim(sgValues.Cells[2,RowIndex])='');

end;

procedure TfmMaskEditor.sgValuesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if goRowSelect in sgValues.Options then exit;
 case Key of
   VK_DOWN: begin
    if sgValues.Row=sgValues.RowCount-1 then begin
     sgValues.RowCount:=sgValues.RowCount+1;
    end;
   end;
   VK_UP: begin
    if isEmptyGridFromRow(sgValues.Row) then begin
      sgValues.RowCount:=sgValues.RowCount-1;
      sgValues.Row:=sgValues.RowCount-1;
      sgValues.Invalidate;
     end;
   end;
 end;
end;

procedure TfmMaskEditor.bibClearClick(Sender: TObject);
begin
  meTest.EditMask:='';
  edChar.Text:='';
  chbSave.Checked:=false;
end;

procedure TfmMaskEditor.chbEditClick(Sender: TObject);
begin
  if not chbEdit.Checked then begin
   sgValues.Options:=sgValues.Options+[goRowSelect];
   sgValues.Options:=sgValues.Options-[goAlwaysShowEditor];
  end else begin
   sgValues.Options:=sgValues.Options+[goAlwaysShowEditor];
   sgValues.Options:=sgValues.Options-[goRowSelect];
  end;
  TWinControl(sgValues).Update;
  TWinControl(sgValues).Invalidate;
  meTest.EditMask:=sgValues.Cells[2,sgValues.Row];
  edChar.Text:=MaskGetMaskBlank(meTest.EditMask);
  chbSave.Checked:=MaskGetMaskSave(meTest.EditMask);
end;

procedure TfmMaskEditor.sgValuesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
   ViewCurrent(ARow);
end;

procedure TfmMaskEditor.sgValuesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  ViewCurrent(ARow);
end;

procedure TfmMaskEditor.FormDestroy(Sender: TObject);
begin
  SaveToIni;
end;

end.
