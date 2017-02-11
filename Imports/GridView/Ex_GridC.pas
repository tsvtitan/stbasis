{
  Библиотека дополнительных компонентов

  Редактор столбцов таблицы

  Роман М. Мочалов
  E-mail: roman@sar.nnov.ru
}

unit Ex_GridC;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Graphics, StdCtrls, ComCtrls,
  Ex_Grid;

type

{ TGridColumnsEditorForm }

  TColumnsEditorForm = class(TForm)
    ColumnsGroup: TGroupBox;
    ColumnsList: TListView;
    PropertiesGroup: TGroupBox;
    IndexLabel: TLabel;
    IndexEdit: TEdit;
    CaptionLabel: TLabel;
    CaptionEdit: TEdit;
    WidthLabel: TLabel;
    WidthEdit: TEdit;
    LengthLabel: TLabel;
    AlignmentLabel: TLabel;
    AlignmentCombo: TComboBox;
    LengthEdit: TEdit;
    FixedSizeCheck: TCheckBox;
    OKButton: TButton;
    CancelButton: TButton;
    ApplyButton: TButton;
    ReadOnlyCheck: TCheckBox;
    MultiLineCheck: TCheckBox;
    VisibleCheck: TCheckBox;
    AddButton: TButton;
    DeleteButton: TButton;
    procedure EnableApply(Sender: TObject);
    procedure DisableApply(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ColumnsListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure ColumnsListChanging(Sender: TObject; Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
    procedure ColumnsListEnter(Sender: TObject);
    procedure ColumnsListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OKButtonClick(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure IndexEditKeyPress(Sender: TObject; var Key: Char);
  private
    FGrid: TCustomGridView;
    FColumns: TGridColumns;
    FExceptCount: Integer;
    FChangeCount: Integer;
    procedure AddColumn;
    procedure DeleteAllColumns;
    procedure DeleteColumn;
    procedure CheckColumn;
    procedure GetColumn;
    procedure GetParams;
    procedure MoveColumnDown;
    procedure MoveColumnUp;
    procedure PutColumn;
    procedure PutParams;
    procedure RefreshView;
  public
    function Execute(Grid: TCustomGridView): Boolean;
  end;

function EditGridColumns(Grid: TCustomGridView): Boolean;

implementation

{$R *.DFM}

function EditGridColumns(Grid: TCustomGridView): Boolean;
var
  ColumnsEditor: TColumnsEditorForm;
begin
  ColumnsEditor := TColumnsEditorForm.Create(Application);
  try
    { показываем диалог }
    ColumnsEditor.Execute(Grid);
    { результат }
    Result := ColumnsEditor.FChangeCount > 0;
  finally
    ColumnsEditor.Free;
  end;
end;

{ Exception handlers }

type
  EColumnError = class(Exception);

procedure IndexError(Index: Integer);
begin
  raise EColumnError.CreateFmt('"%d" недопустимое значение индекса ', [Index]);
end;

{ TColumnsEditorForm }

procedure TColumnsEditorForm.AddColumn;
begin
  { добавляем колонку }
  FColumns.Add;
  { обновляем список столбцов }
  RefreshView;
  { фокус на строку с заголовком }
  CaptionEdit.SetFocus;
  { доступ к кнопке "Применить" }
  EnableApply(nil);
end;

procedure TColumnsEditorForm.DeleteAllColumns;
const
  Message = 'Удалить все столбцы?';
  Flags = MB_YESNO or MB_ICONQUESTION;
begin
  { есть ли столбцы }
  if ColumnsList.Items.Count > 0 then
    { спрашиваем разрешение на удаление }
    if Application.MessageBox(Message, PChar(Caption), Flags) = IDYES then
    begin
      { удаляем все столбцы }
      FColumns.Clear;
      { обновляем список столбцов }
      RefreshView;
      { доступ к кнопке "Применить" }
      EnableApply(nil);
    end;
end;

procedure TColumnsEditorForm.DeleteColumn;
var
  I: Integer;
begin
  with ColumnsList do
  begin
    { есть ли выделенный столбец }
    I := Items.IndexOf(ItemFocused);
    if I <> -1 then
    begin
      { удаляем его }
      FColumns[I].Free;
      { обновляем список столбцов }
      RefreshView;
      ColumnsList.SetFocus;
      { доступ к кнопке "Применить" }
      EnableApply(nil);
    end;
  end;
end;

procedure TColumnsEditorForm.CheckColumn;
var
  I: Integer;
begin
  if PropertiesGroup.Enabled then
  begin
    { проверяем индекс столбца }
    with IndexEdit do
    try
      I := StrToInt(Text);
      if (I < 0) or (I > FColumns.Count - 1) then IndexError(I);
    except
      SetFocus;
      raise;
    end;
    { проверяем ширину столбца }
    with WidthEdit do
    try
      StrToInt(Text);
    except
      SetFocus;
      raise;
    end;
    { проверяем длину строки }
    with LengthEdit do
    try
      StrToInt(Text);
    except
      SetFocus;
      raise;
    end;
  end;
end;

procedure TColumnsEditorForm.GetColumn;
var
  I: Integer;
begin
  with ColumnsList do
  begin
    { есть ли выделенный столбец }
    I := Items.IndexOf(ItemFocused);
    if I <> -1 then
    begin
      { обновляем параметры }
      IndexEdit.Text := IntToStr(I);
      CaptionEdit.Text := FColumns[I].Caption;
      WidthEdit.Text := IntToStr(FColumns[I].DefWidth);
      AlignmentCombo.ItemIndex := Ord(FColumns[I].Alignment);
      LengthEdit.Text := IntToStr(FColumns[I].MaxLength);
      FixedSizeCheck.Checked := FColumns[I].FixedSize;
      ReadOnlyCheck.Checked := FColumns[I].ReadOnly;
      MultiLineCheck.Checked := FColumns[I].MultiLine;
      VisibleCheck.Checked := not FColumns[I].Visible;
    end;
  end;
end;

procedure TColumnsEditorForm.GetParams;
begin
  { считываем список стобцов таблицы }
  FColumns.Assign(FGrid.Columns);
  { обновляем список столбцов }
  RefreshView
end;

procedure TColumnsEditorForm.MoveColumnDown;
var
  I: Integer;
begin
  with ColumnsList do
  begin
    { есть ли выделенный столбец }
    I := Items.IndexOf(ItemFocused);
    { можно ли двигать его вниз }
    if I < Items.Count - 1 then
    begin
      { смещаем вниз }
      FColumns[I].Index := I + 1;
      { обновляем список столбцов }
      RefreshView;
      { подправляем выделенную строку }
      ItemFocused.Selected := False;
      ItemFocused := Items[I + 1];
      ItemFocused.Selected := True;
      ItemFocused.MakeVisible(True);
      { доступ к кнопке "Применить" }
      EnableApply(nil);
    end;
  end;
end;

procedure TColumnsEditorForm.MoveColumnUp;
var
  I: Integer;
begin
  with ColumnsList do
  begin
    { есть ли выделенный столбец }
    I := Items.IndexOf(ItemFocused);
    { можно ли двигать его вверх }
    if I > 0 then
    begin
      { смещаем вверх }
      FColumns[I].Index := I - 1;
      { обновляем список столбцов }
      RefreshView;
      { подправляем выделенную строку }
      ItemFocused.Selected := False;
      ItemFocused := Items[I - 1];
      ItemFocused.Selected := True;
      ItemFocused.MakeVisible(True);
      { доступ к кнопке "Применить" }
      EnableApply(nil);
    end;
  end;
end;

procedure TColumnsEditorForm.PutColumn;
var
  I: Integer;
begin
  with ColumnsList do
  begin
    { есть ли выделенный столбец }
    I := Items.IndexOf(ItemFocused);
    if I <> -1 then
      with FColumns[I] do
      begin
        { считываем параметры столбца }
        Index := StrToInt(IndexEdit.Text);
        Caption := CaptionEdit.Text;
        DefWidth := StrToInt(WidthEdit.Text);
        Alignment := TAlignment(AlignmentCombo.ItemIndex);
        MaxLength := StrToInt(LengthEdit.Text);
        FixedSize := FixedSizeCheck.Checked;
        ReadOnly := ReadOnlyCheck.Checked;
        MultiLine := MultiLineCheck.Checked;
        Visible := not VisibleCheck.Checked;
        { обновляем список столбцов }
        RefreshView;
      end;
  end;
end;

procedure TColumnsEditorForm.PutParams;
begin
  FGrid.Columns := FColumns;
end;

procedure TColumnsEditorForm.RefreshView;

  procedure BeginRefresh;
  begin
    ColumnsList.OnChange := nil;
    ColumnsList.OnChanging := nil;
    IndexEdit.OnChange := nil;
    CaptionEdit.OnChange := nil;
    WidthEdit.OnChange := nil;
    LengthEdit.OnChange := nil;
    FixedSizeCheck.OnClick := nil;
    ReadOnlyCheck.OnClick := nil;
    MultiLineCheck.OnClick := nil;
    VisibleCheck.OnClick := nil;
  end;

  procedure EndRefresh;
  begin
    ColumnsList.OnChange := ColumnsListChange;
    ColumnsList.OnChanging := ColumnsListChanging;
    IndexEdit.OnChange := EnableApply;
    CaptionEdit.OnChange := EnableApply;
    WidthEdit.OnChange := EnableApply;
    LengthEdit.OnChange := EnableApply;
    FixedSizeCheck.OnClick := EnableApply;
    ReadOnlyCheck.OnClick := EnableApply;
    MultiLineCheck.OnClick := EnableApply;
    VisibleCheck.OnClick := EnableApply;
  end;

  procedure RefreshListView;
  var
    I, C: Integer;

    procedure SetCaption(Item: Integer; const Value: string);
    begin
      with ColumnsList.Items[Item] do
        if Caption <> Value then
        begin
          Caption := Value;
          Inc(C);
        end;
    end;

    procedure SetSubItem(Item, Index: Integer; const Value: string);
    begin
      with ColumnsList.Items[Item].SubItems do
        if Strings[Index] <> Value then
        begin
          Strings[Index] := Value;
          Inc(C);
        end;
    end;

    procedure UpdateItem(Item: Integer);
    var
      R: TRect;
    begin
      with ColumnsList do
      begin
        R := Items[Item].DisplayRect(drBounds);
        InvalidateRect(Handle, @R, False);
      end;
    end;

  begin
    with ColumnsList do
    begin
      { уравниваем количество столбцов и строк в списке }
      if Items.Count > FColumns.Count then
      begin
        I := Items.Count;
        while I > FColumns.Count do
        begin
          Dec(I);
          Items.Delete(I);
        end;
      end else
      if Items.Count < FColumns.Count then
      begin
        I := Items.Count;
        while I < FColumns.Count do
        begin
          Inc(I);
          with Items.Add do
          begin
            SubItems.Add('');
          end;
        end;
        if Items.Count > 0 then
        begin
          ItemFocused := Items[Items.Count - 1];
          Selected := Items[Items.Count - 1];
          Selected.MakeVisible(True);
        end;
      end;
    end;
    { обновляем строки списка }
    with FColumns do
    begin
      for I := 0 to Count - 1 do
      begin
        C := 0;
        with Columns[I] do
        begin
          SetCaption(I, IntToStr(I));
          SetSubItem(I, 0, Caption);
        end;
        if C <> 0 then UpdateItem(I);
      end;
    end;
  end;

  procedure RefreshControls;
  begin
    with ColumnsList do
    begin
      { есть ли выделенный столбец }
      if Items.IndexOf(ItemFocused) <> -1 then
      begin
        { разрешаем изменение параметров }
        PropertiesGroup.Enabled := True;
        DeleteButton.Enabled := True;
        { считываем параметры столца }
        GetColumn;
      end
      else
      begin
        { очищаем компоненты параметров }
        VisibleCheck.Checked := False;
        MultiLineCheck.Checked := False;
        ReadOnlyCheck.Checked := False;
        FixedSizeCheck.Checked := False;
        LengthEdit.Text := '';
        AlignmentCombo.ItemIndex := -1;
        WidthEdit.Text := '';
        CaptionEdit.Text := '';
        IndexEdit.Text := '';
        { запрещаем изменение параметров }
        DeleteButton.Enabled := False;
        PropertiesGroup.Enabled := False;
      end;
    end;
  end;

begin
  BeginRefresh;
  try
    RefreshListView;
    RefreshControls;
  finally
    Endrefresh;
  end;
end;

function TColumnsEditorForm.Execute(Grid: TCustomGridView): Boolean;
begin
  { запоминаем таблицу }
  FGrid := Grid;
  { считываем список столбцов }
  GetParams;
  { показываем диалог }
  Result := ShowModal = mrOK;
end;

procedure TColumnsEditorForm.EnableApply(Sender: TObject);
begin
  OKButton.Default := False;
  ApplyButton.Enabled := True;
  ApplyButton.Default := True;
end;

procedure TColumnsEditorForm.DisableApply(Sender: TObject);
begin
  ApplyButton.Default := False;
  ApplyButton.Enabled := False;
  OKButton.Default := True;
end;

procedure TColumnsEditorForm.FormCreate(Sender: TObject);
const
  LVM_SETEXTSTYLE      = $1000 + 54;
  LVS_EX_FULLROWSELECT = $00000020;
begin
  SendMessage(ColumnsList.Handle, LVM_SETEXTSTYLE, 0, LVS_EX_FULLROWSELECT);
  FColumns := TGridColumns.Create(nil);
end;

procedure TColumnsEditorForm.FormDestroy(Sender: TObject);
begin
  FColumns.Free;
end;

procedure TColumnsEditorForm.ColumnsListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if not (csDestroying in ComponentState) then RefreshView;
end;

procedure TColumnsEditorForm.ColumnsListChanging(Sender: TObject; Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
  if not (csDestroying in ComponentState) then
  begin
    try
      CheckColumn;
      PutColumn;
      RefreshView;
    except
      if FExceptCount = 0 then Application.HandleException(Self);
      Inc(FExceptCount);
    end;
    AllowChange := FExceptCount = 0;
  end;
end;

procedure TColumnsEditorForm.ColumnsListEnter(Sender: TObject);
begin
  FExceptCount := 0;
end;

procedure TColumnsEditorForm.ColumnsListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift = [] then
    case Key of
      VK_INSERT:
        begin
          with AddButton do if Enabled then Click;
          Key := 0;
        end;
      VK_DELETE:
        begin
          with DeleteButton do if Enabled then Click;
          Key := 0;
        end;
    end;
  if Shift = [ssCtrl] then
    case Key of
      VK_DELETE:
        begin
          DeleteAllColumns;
          Key := 0;
        end;
      VK_UP:
        begin
          CheckColumn;
          PutColumn;
          MoveColumnUp;
          Key := 0;
        end;
      VK_DOWN:
        begin
          CheckColumn;
          PutColumn;
          MoveColumnDown;
          Key := 0;
        end;
    end;
end;

procedure TColumnsEditorForm.IndexEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9']) then
  begin
    MessageBeep(0);
    Key := #0;
  end;
end;

procedure TColumnsEditorForm.OKButtonClick(Sender: TObject);
begin
  ApplyButtonClick(ApplyButton);
  ModalResult := mrOK;
end;

procedure TColumnsEditorForm.ApplyButtonClick(Sender: TObject);
begin
  { проверяем и вставляем параметры }
  CheckColumn;
  PutColumn;
  PutParams;
  { обновлем компоненты }
  GetParams;
  DisableApply(nil);
  { увеличиваем счетчик изменений }
  Inc(FChangeCount);
end;

procedure TColumnsEditorForm.AddButtonClick(Sender: TObject);
begin
  CheckColumn;
  PutColumn;
  AddColumn;
end;

procedure TColumnsEditorForm.DeleteButtonClick(Sender: TObject);
begin
  CheckColumn;
  PutColumn;
  DeleteColumn;
end;

end.


