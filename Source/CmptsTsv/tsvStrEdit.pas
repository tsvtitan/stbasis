unit tsvStrEdit;

interface

uses {$IFDEF WIN32} Windows, {$ELSE} WinTypes, WinProcs, {$ENDIF} Classes, 
  Graphics, Forms, Controls, Buttons, Dialogs, StdCtrls, ExtCtrls,
  DsgnIntf, Menus, ImgList;

type
  TStrEditDlg = class(TForm)
    Memo: TMemo;
    LineCount: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    HelpBtn: TButton;
    LoadBtn: TButton;
    SaveBtn: TButton;
    bibOk: TButton;
    bibCancel: TButton;
    ImageList1: TImageList;
    procedure FileOpen(Sender: TObject);
    procedure FileSave(Sender: TObject);
    procedure UpdateStatus(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HelpBtnClick(Sender: TObject);
  private
    SingleLine: string[15];
    MultipleLines: string[15];
  public
    procedure SetCaption(AComponent: TComponent);

  end;

type
  TStringListProperty = class(TClassProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  THintProperty = class(TCaptionProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TStringListEditor = class(TComponentEditor)
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;


implementation

{$R *.DFM}

uses SysUtils, LibHelp, UCmptsTsvData, checklst, comctrls;

type
  TCharSet = TSysCharSet;

function WordCount(const S: string; const WordDelims: TCharSet): Integer;
var
  SLen, I: Cardinal;
begin
  Result := 0;
  I := 1;
  SLen := Length(S);
  while I <= SLen do begin
    while (I <= SLen) and (S[I] in WordDelims) do Inc(I);
    if I <= SLen then Inc(Result);
    while (I <= SLen) and not(S[I] in WordDelims) do Inc(I);
  end;
end;

{ TStrListEditDlg }

procedure TStrEditDlg.SetCaption(AComponent: TComponent);
begin
  if AComponent<>nil then
   Caption:=Format(fmtSetCaption,['Редактор текста',AComponent.Name])
  else
   Caption:='Редактор текста';
end;

procedure TStrEditDlg.FileOpen(Sender: TObject);
begin
  with OpenDialog do
    if Execute then Memo.Lines.LoadFromFile(FileName);
end;

procedure TStrEditDlg.FileSave(Sender: TObject);
begin
  SaveDialog.FileName := OpenDialog.FileName;
  with SaveDialog do
    if Execute then Memo.Lines.SaveToFile(FileName);
end;

procedure TStrEditDlg.UpdateStatus(Sender: TObject);
var
  Count: Integer;
begin
  Count := Memo.Lines.Count;
  if Count = 1 then
    LineCount.Caption := Format('%d %s', [Count, SingleLine])
  else
    LineCount.Caption := Format('%d %s', [Count, MultipleLines]);
end;

procedure TStrEditDlg.FormCreate(Sender: TObject);
begin
  HelpContext := hcDStringListEditor;
  OpenDialog.HelpContext := hcDStringListLoad;
  SaveDialog.HelpContext := hcDStringListSave;
  SingleLine := 'Линия';
  MultipleLines := 'Линий';
end;

procedure TStrEditDlg.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then bibCancel.Click;
end;

procedure TStrEditDlg.HelpBtnClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

{ TStringListProperty }

function TStringListProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog] - [paSubProperties];
end;

procedure TStringListProperty.Edit;
var
  comp: TPersistent;
begin
  with TStrEditDlg.Create(Application) do
  try
    Memo.Lines := TStrings(GetOrdValue);
    comp:=GetComponent(0);
    if comp is TComponent then
      SetCaption(TComponent(comp));
    UpdateStatus(nil);
    ActiveControl := Memo;
    case ShowModal of
      mrOk: SetOrdValue(Longint(Memo.Lines));
    end;
  finally
    Free;
  end;
end;

{ THintProperty }

function THintProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

procedure THintProperty.Edit;
var
  comp: TPersistent;
  Temp: string;
begin
  with TStrEditDlg.Create(Application) do
  try
    Temp := GetStrValue;
    Memo.Lines.Text:=Temp;
    comp:=GetComponent(0);
    if comp is TComponent then
      SetCaption(TComponent(comp));
    UpdateStatus(nil);
    if ShowModal = mrOk then begin
      Temp := Memo.Text;
      while (Length(Temp) > 0) and (Temp[Length(Temp)] < ' ') do
        System.Delete(Temp, Length(Temp), 1);
      SetStrValue(Temp);
    end;
  finally
    Free;
  end;
end;


procedure EditStringListEditor(Str: TStrings; AComponent: TComponent);
begin
  with TStrEditDlg.Create(Application) do
  try
    Memo.Lines.Text:=str.Text;
    SetCaption(AComponent);
    UpdateStatus(nil);
    ActiveControl := Memo;
    case ShowModal of
      mrOk: Str.Text:=Memo.Lines.Text;
    end;
  finally
    Free;
  end;
end;

{ TStringListEditor }

procedure TStringListEditor.Edit;
begin
  if Component is TMemo then begin
    EditStringListEditor(TMemo(Component).Lines,TMemo(Component));
    Designer.Modified;
  end;
  if Component is TListBox then begin
    EditStringListEditor(TListBox(Component).Items,TListBox(Component));
    Designer.Modified;
  end;
  if Component is TComboBox then begin
    EditStringListEditor(TComboBox(Component).Items,TComboBox(Component));
    Designer.Modified;
  end;
  if Component is TRadioGroup then begin
    EditStringListEditor(TRadioGroup(Component).Items,TRadioGroup(Component));
    Designer.Modified;
  end;
  if Component is TCheckListBox then begin
    EditStringListEditor(TCheckListBox(Component).Items,TCheckListBox(Component));
    Designer.Modified;
  end;
  if Component is TRichEdit then begin
    EditStringListEditor(TRichEdit(Component).Lines,TRichEdit(Component));
    Designer.Modified;
  end;
  if Component is TTabControl then begin
    EditStringListEditor(TTabControl(Component).Tabs,TTabControl(Component));
    Designer.Modified;
  end;
end;

procedure TStringListEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit;
end;

function TStringListEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then Result := 'Строки'
  else Result := '';
end;

function TStringListEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

end.
