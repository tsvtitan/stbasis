unit tsvInterpreterDialogs;

interface

uses UMainUnited, tsvInterpreterCore;

  { TCommonDialog }
procedure TCommonDialog_Read_Handle(var Value: Variant; Args: TArguments);
procedure TCommonDialog_Read_Ctl3D(var Value: Variant; Args: TArguments);
procedure TCommonDialog_Write_Ctl3D(const Value: Variant; Args: TArguments);
procedure TCommonDialog_Read_HelpContext(var Value: Variant; Args: TArguments);
procedure TCommonDialog_Write_HelpContext(const Value: Variant; Args: TArguments);

  { TOpenDialog }
procedure TOpenDialog_Create(var Value: Variant; Args: TArguments);
procedure TOpenDialog_Execute(var Value: Variant; Args: TArguments);
procedure TOpenDialog_Read_FileEditStyle(var Value: Variant; Args: TArguments);
procedure TOpenDialog_Write_FileEditStyle(const Value: Variant; Args: TArguments);
procedure TOpenDialog_Read_Files(var Value: Variant; Args: TArguments);
procedure TOpenDialog_Read_HistoryList(var Value: Variant; Args: TArguments);
procedure TOpenDialog_Write_HistoryList(const Value: Variant; Args: TArguments);
procedure TOpenDialog_Read_DefaultExt(var Value: Variant; Args: TArguments);
procedure TOpenDialog_Write_DefaultExt(const Value: Variant; Args: TArguments);
procedure TOpenDialog_Read_FileName(var Value: Variant; Args: TArguments);
procedure TOpenDialog_Write_FileName(const Value: Variant; Args: TArguments);
procedure TOpenDialog_Read_Filter(var Value: Variant; Args: TArguments);
procedure TOpenDialog_Write_Filter(const Value: Variant; Args: TArguments);
procedure TOpenDialog_Read_FilterIndex(var Value: Variant; Args: TArguments);
procedure TOpenDialog_Write_FilterIndex(const Value: Variant; Args: TArguments);
procedure TOpenDialog_Read_InitialDir(var Value: Variant; Args: TArguments);
procedure TOpenDialog_Write_InitialDir(const Value: Variant; Args: TArguments);
procedure TOpenDialog_Read_Options(var Value: Variant; Args: TArguments);
procedure TOpenDialog_Write_Options(const Value: Variant; Args: TArguments);
procedure TOpenDialog_Read_Title(var Value: Variant; Args: TArguments);
procedure TOpenDialog_Write_Title(const Value: Variant; Args: TArguments);

  { TSaveDialog }
procedure TSaveDialog_Create(var Value: Variant; Args: TArguments);
procedure TSaveDialog_Execute(var Value: Variant; Args: TArguments);

  { TColorDialog }
procedure TColorDialog_Create(var Value: Variant; Args: TArguments);
procedure TColorDialog_Execute(var Value: Variant; Args: TArguments);
procedure TColorDialog_Read_Color(var Value: Variant; Args: TArguments);
procedure TColorDialog_Write_Color(const Value: Variant; Args: TArguments);
procedure TColorDialog_Read_CustomColors(var Value: Variant; Args: TArguments);
procedure TColorDialog_Write_CustomColors(const Value: Variant; Args: TArguments);
procedure TColorDialog_Read_Options(var Value: Variant; Args: TArguments);
procedure TColorDialog_Write_Options(const Value: Variant; Args: TArguments);

  { TFontDialog }
procedure TFontDialog_Create(var Value: Variant; Args: TArguments);
procedure TFontDialog_Execute(var Value: Variant; Args: TArguments);
procedure TFontDialog_Read_Font(var Value: Variant; Args: TArguments);
procedure TFontDialog_Write_Font(const Value: Variant; Args: TArguments);
procedure TFontDialog_Read_Device(var Value: Variant; Args: TArguments);
procedure TFontDialog_Write_Device(const Value: Variant; Args: TArguments);
procedure TFontDialog_Read_MinFontSize(var Value: Variant; Args: TArguments);
procedure TFontDialog_Write_MinFontSize(const Value: Variant; Args: TArguments);
procedure TFontDialog_Read_MaxFontSize(var Value: Variant; Args: TArguments);
procedure TFontDialog_Write_MaxFontSize(const Value: Variant; Args: TArguments);
procedure TFontDialog_Read_Options(var Value: Variant; Args: TArguments);
procedure TFontDialog_Write_Options(const Value: Variant; Args: TArguments);

  { TPrinterSetupDialog }
procedure TPrinterSetupDialog_Create(var Value: Variant; Args: TArguments);
procedure TPrinterSetupDialog_Execute(var Value: Variant; Args: TArguments);

  { TPrintDialog }
procedure TPrintDialog_Create(var Value: Variant; Args: TArguments);
procedure TPrintDialog_Execute(var Value: Variant; Args: TArguments);
procedure TPrintDialog_Read_Collate(var Value: Variant; Args: TArguments);
procedure TPrintDialog_Write_Collate(const Value: Variant; Args: TArguments);
procedure TPrintDialog_Read_Copies(var Value: Variant; Args: TArguments);
procedure TPrintDialog_Write_Copies(const Value: Variant; Args: TArguments);
procedure TPrintDialog_Read_FromPage(var Value: Variant; Args: TArguments);
procedure TPrintDialog_Write_FromPage(const Value: Variant; Args: TArguments);
procedure TPrintDialog_Read_MinPage(var Value: Variant; Args: TArguments);
procedure TPrintDialog_Write_MinPage(const Value: Variant; Args: TArguments);
procedure TPrintDialog_Read_MaxPage(var Value: Variant; Args: TArguments);
procedure TPrintDialog_Write_MaxPage(const Value: Variant; Args: TArguments);
procedure TPrintDialog_Read_Options(var Value: Variant; Args: TArguments);
procedure TPrintDialog_Write_Options(const Value: Variant; Args: TArguments);
procedure TPrintDialog_Read_PrintToFile(var Value: Variant; Args: TArguments);
procedure TPrintDialog_Write_PrintToFile(const Value: Variant; Args: TArguments);
procedure TPrintDialog_Read_PrintRange(var Value: Variant; Args: TArguments);
procedure TPrintDialog_Write_PrintRange(const Value: Variant; Args: TArguments);
procedure TPrintDialog_Read_ToPage(var Value: Variant; Args: TArguments);
procedure TPrintDialog_Write_ToPage(const Value: Variant; Args: TArguments);

  { TFindDialog }
procedure TFindDialog_Create(var Value: Variant; Args: TArguments);
procedure TFindDialog_CloseDialog(var Value: Variant; Args: TArguments);
procedure TFindDialog_Execute(var Value: Variant; Args: TArguments);
procedure TFindDialog_Read_Left(var Value: Variant; Args: TArguments);
procedure TFindDialog_Write_Left(const Value: Variant; Args: TArguments);
procedure TFindDialog_Read_Top(var Value: Variant; Args: TArguments);
procedure TFindDialog_Write_Top(const Value: Variant; Args: TArguments);
procedure TFindDialog_Read_FindText(var Value: Variant; Args: TArguments);
procedure TFindDialog_Write_FindText(const Value: Variant; Args: TArguments);
procedure TFindDialog_Read_Options(var Value: Variant; Args: TArguments);
procedure TFindDialog_Write_Options(const Value: Variant; Args: TArguments);

  { TReplaceDialog }
procedure TReplaceDialog_Create(var Value: Variant; Args: TArguments);
procedure TReplaceDialog_Read_ReplaceText(var Value: Variant; Args: TArguments);
procedure TReplaceDialog_Write_ReplaceText(const Value: Variant; Args: TArguments);

procedure Dialogs_CreateMessageDialog(var Value: Variant; Args: TArguments);
procedure Dialogs_MessageDlg(var Value: Variant; Args: TArguments);
procedure Dialogs_MessageDlgPos(var Value: Variant; Args: TArguments);
procedure Dialogs_MessageDlgPosHelp(var Value: Variant; Args: TArguments);
procedure Dialogs_ShowMessage(var Value: Variant; Args: TArguments);
procedure Dialogs_ShowMessagePos(var Value: Variant; Args: TArguments);
procedure Dialogs_InputBox(var Value: Variant; Args: TArguments);
procedure Dialogs_InputQuery(var Value: Variant; Args: TArguments);

implementation

uses
  Classes,
  Graphics, Controls, Dialogs;

  { TCommonDialog }

{ property Read Handle: HWnd }
procedure TCommonDialog_Read_Handle(var Value: Variant; Args: TArguments);
begin
  Value := Integer(TCommonDialog(Args.Obj).Handle);
end;

{ property Read Ctl3D: Boolean }
procedure TCommonDialog_Read_Ctl3D(var Value: Variant; Args: TArguments);
begin
  Value := TCommonDialog(Args.Obj).Ctl3D;
end;

{ property Write Ctl3D(Value: Boolean) }
procedure TCommonDialog_Write_Ctl3D(const Value: Variant; Args: TArguments);
begin
  TCommonDialog(Args.Obj).Ctl3D := Value;
end;

{ property Read HelpContext: THelpContext }
procedure TCommonDialog_Read_HelpContext(var Value: Variant; Args: TArguments);
begin
  Value := TCommonDialog(Args.Obj).HelpContext;
end;

{ property Write HelpContext(Value: THelpContext) }
procedure TCommonDialog_Write_HelpContext(const Value: Variant; Args: TArguments);
begin
  TCommonDialog(Args.Obj).HelpContext := Value;
end;

  { TOpenDialog }

{ constructor Create(AOwner: TComponent) }
procedure TOpenDialog_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TOpenDialog.Create(V2O(Args.Values[0]) as TComponent));
end;

{  function Execute: Boolean; }
procedure TOpenDialog_Execute(var Value: Variant; Args: TArguments);
begin
  Value := TOpenDialog(Args.Obj).Execute;
end;

{ property Read FileEditStyle: TFileEditStyle }
procedure TOpenDialog_Read_FileEditStyle(var Value: Variant; Args: TArguments);
begin
  Value := TOpenDialog(Args.Obj).FileEditStyle;
end;

{ property Write FileEditStyle(Value: TFileEditStyle) }
procedure TOpenDialog_Write_FileEditStyle(const Value: Variant; Args: TArguments);
begin
  TOpenDialog(Args.Obj).FileEditStyle := Value;
end;

{ property Read Files: TStrings }
procedure TOpenDialog_Read_Files(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TOpenDialog(Args.Obj).Files);
end;

{ property Read HistoryList: TStrings }
procedure TOpenDialog_Read_HistoryList(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TOpenDialog(Args.Obj).HistoryList);
end;

{ property Write HistoryList(Value: TStrings) }
procedure TOpenDialog_Write_HistoryList(const Value: Variant; Args: TArguments);
begin
  TOpenDialog(Args.Obj).HistoryList := V2O(Value) as TStrings;
end;

{ property Read DefaultExt: string }
procedure TOpenDialog_Read_DefaultExt(var Value: Variant; Args: TArguments);
begin
  Value := TOpenDialog(Args.Obj).DefaultExt;
end;

{ property Write DefaultExt(Value: string) }
procedure TOpenDialog_Write_DefaultExt(const Value: Variant; Args: TArguments);
begin
  TOpenDialog(Args.Obj).DefaultExt := Value;
end;

{ property Read FileName: TFileName }
procedure TOpenDialog_Read_FileName(var Value: Variant; Args: TArguments);
begin
  Value := TOpenDialog(Args.Obj).FileName;
end;

{ property Write FileName(Value: TFileName) }
procedure TOpenDialog_Write_FileName(const Value: Variant; Args: TArguments);
begin
  TOpenDialog(Args.Obj).FileName := Value;
end;

{ property Read Filter: string }
procedure TOpenDialog_Read_Filter(var Value: Variant; Args: TArguments);
begin
  Value := TOpenDialog(Args.Obj).Filter;
end;

{ property Write Filter(Value: string) }
procedure TOpenDialog_Write_Filter(const Value: Variant; Args: TArguments);
begin
  TOpenDialog(Args.Obj).Filter := Value;
end;

{ property Read FilterIndex: Integer }
procedure TOpenDialog_Read_FilterIndex(var Value: Variant; Args: TArguments);
begin
  Value := TOpenDialog(Args.Obj).FilterIndex;
end;

{ property Write FilterIndex(Value: Integer) }
procedure TOpenDialog_Write_FilterIndex(const Value: Variant; Args: TArguments);
begin
  TOpenDialog(Args.Obj).FilterIndex := Value;
end;

{ property Read InitialDir: string }
procedure TOpenDialog_Read_InitialDir(var Value: Variant; Args: TArguments);
begin
  Value := TOpenDialog(Args.Obj).InitialDir;
end;

{ property Write InitialDir(Value: string) }
procedure TOpenDialog_Write_InitialDir(const Value: Variant; Args: TArguments);
begin
  TOpenDialog(Args.Obj).InitialDir := Value;
end;

{ property Read Options: TOpenOptions }
procedure TOpenDialog_Read_Options(var Value: Variant; Args: TArguments);
begin
  Value := S2V(Integer(TOpenDialog(Args.Obj).Options));
end;

{ property Write Options(Value: TOpenOptions) }
procedure TOpenDialog_Write_Options(const Value: Variant; Args: TArguments);
begin
  TOpenDialog(Args.Obj).Options := TOpenOptions(V2S(Value));
end;

{ property Read Title: string }
procedure TOpenDialog_Read_Title(var Value: Variant; Args: TArguments);
begin
  Value := TOpenDialog(Args.Obj).Title;
end;

{ property Write Title(Value: string) }
procedure TOpenDialog_Write_Title(const Value: Variant; Args: TArguments);
begin
  TOpenDialog(Args.Obj).Title := Value;
end;

  { TSaveDialog }

{ constructor Create(AOwner: TComponent) }
procedure TSaveDialog_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TSaveDialog.Create(V2O(Args.Values[0]) as TComponent));
end;

{ function Execute: Boolean; }
procedure TSaveDialog_Execute(var Value: Variant; Args: TArguments);
begin
  Value := TSaveDialog(Args.Obj).Execute;
end;

  { TColorDialog }

{ constructor Create(AOwner: TComponent) }
procedure TColorDialog_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TColorDialog.Create(V2O(Args.Values[0]) as TComponent));
end;

{  function Execute: Boolean; }
procedure TColorDialog_Execute(var Value: Variant; Args: TArguments);
begin
  Value := TColorDialog(Args.Obj).Execute;
end;

{ property Read Color: TColor }
procedure TColorDialog_Read_Color(var Value: Variant; Args: TArguments);
begin
  Value := TColorDialog(Args.Obj).Color;
end;

{ property Write Color(Value: TColor) }
procedure TColorDialog_Write_Color(const Value: Variant; Args: TArguments);
begin
  TColorDialog(Args.Obj).Color := Value;
end;

{ property Read CustomColors: TStrings }
procedure TColorDialog_Read_CustomColors(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TColorDialog(Args.Obj).CustomColors);
end;

{ property Write CustomColors(Value: TStrings) }
procedure TColorDialog_Write_CustomColors(const Value: Variant; Args: TArguments);
begin
  TColorDialog(Args.Obj).CustomColors := V2O(Value) as TStrings;
end;

{ property Read Options: TColorDialogOptions }
procedure TColorDialog_Read_Options(var Value: Variant; Args: TArguments);
begin
  Value := S2V(Byte(TColorDialog(Args.Obj).Options));
end;

{ property Write Options(Value: TColorDialogOptions) }
procedure TColorDialog_Write_Options(const Value: Variant; Args: TArguments);
begin
  TColorDialog(Args.Obj).Options := TColorDialogOptions(Byte(V2S(Value)));
end;

  { TFontDialog }

{ constructor Create(AOwner: TComponent) }
procedure TFontDialog_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TFontDialog.Create(V2O(Args.Values[0]) as TComponent));
end;

{  function Execute: Boolean; }
procedure TFontDialog_Execute(var Value: Variant; Args: TArguments);
begin
  Value := TFontDialog(Args.Obj).Execute;
end;

{ property Read Font: TFont }
procedure TFontDialog_Read_Font(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TFontDialog(Args.Obj).Font);
end;

{ property Write Font(Value: TFont) }
procedure TFontDialog_Write_Font(const Value: Variant; Args: TArguments);
begin
  TFontDialog(Args.Obj).Font := V2O(Value) as TFont;
end;

{ property Read Device: TFontDialogDevice }
procedure TFontDialog_Read_Device(var Value: Variant; Args: TArguments);
begin
  Value := TFontDialog(Args.Obj).Device;
end;

{ property Write Device(Value: TFontDialogDevice) }
procedure TFontDialog_Write_Device(const Value: Variant; Args: TArguments);
begin
  TFontDialog(Args.Obj).Device := Value;
end;

{ property Read MinFontSize: Integer }
procedure TFontDialog_Read_MinFontSize(var Value: Variant; Args: TArguments);
begin
  Value := TFontDialog(Args.Obj).MinFontSize;
end;

{ property Write MinFontSize(Value: Integer) }
procedure TFontDialog_Write_MinFontSize(const Value: Variant; Args: TArguments);
begin
  TFontDialog(Args.Obj).MinFontSize := Value;
end;

{ property Read MaxFontSize: Integer }
procedure TFontDialog_Read_MaxFontSize(var Value: Variant; Args: TArguments);
begin
  Value := TFontDialog(Args.Obj).MaxFontSize;
end;

{ property Write MaxFontSize(Value: Integer) }
procedure TFontDialog_Write_MaxFontSize(const Value: Variant; Args: TArguments);
begin
  TFontDialog(Args.Obj).MaxFontSize := Value;
end;

{ property Read Options: TFontDialogOptions }
procedure TFontDialog_Read_Options(var Value: Variant; Args: TArguments);
begin
  Value := S2V(Word(TFontDialog(Args.Obj).Options));
end;

{ property Write Options(Value: TFontDialogOptions) }
procedure TFontDialog_Write_Options(const Value: Variant; Args: TArguments);
begin
  TFontDialog(Args.Obj).Options := TFontDialogOptions(Word(V2S(Value)));
end;

  { TPrinterSetupDialog }

{ constructor Create(AOwner: TComponent) }
procedure TPrinterSetupDialog_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TPrinterSetupDialog.Create(V2O(Args.Values[0]) as TComponent));
end;

{  function Execute: Boolean; }
procedure TPrinterSetupDialog_Execute(var Value: Variant; Args: TArguments);
begin
  Value := TPrinterSetupDialog(Args.Obj).Execute;
end;

  { TPrintDialog }

{ constructor Create(AOwner: TComponent) }
procedure TPrintDialog_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TPrintDialog.Create(V2O(Args.Values[0]) as TComponent));
end;

{  function Execute: Boolean; }
procedure TPrintDialog_Execute(var Value: Variant; Args: TArguments);
begin
  Value := TPrintDialog(Args.Obj).Execute;
end;

{ property Read Collate: Boolean }
procedure TPrintDialog_Read_Collate(var Value: Variant; Args: TArguments);
begin
  Value := TPrintDialog(Args.Obj).Collate;
end;

{ property Write Collate(Value: Boolean) }
procedure TPrintDialog_Write_Collate(const Value: Variant; Args: TArguments);
begin
  TPrintDialog(Args.Obj).Collate := Value;
end;

{ property Read Copies: Integer }
procedure TPrintDialog_Read_Copies(var Value: Variant; Args: TArguments);
begin
  Value := TPrintDialog(Args.Obj).Copies;
end;

{ property Write Copies(Value: Integer) }
procedure TPrintDialog_Write_Copies(const Value: Variant; Args: TArguments);
begin
  TPrintDialog(Args.Obj).Copies := Value;
end;

{ property Read FromPage: Integer }
procedure TPrintDialog_Read_FromPage(var Value: Variant; Args: TArguments);
begin
  Value := TPrintDialog(Args.Obj).FromPage;
end;

{ property Write FromPage(Value: Integer) }
procedure TPrintDialog_Write_FromPage(const Value: Variant; Args: TArguments);
begin
  TPrintDialog(Args.Obj).FromPage := Value;
end;

{ property Read MinPage: Integer }
procedure TPrintDialog_Read_MinPage(var Value: Variant; Args: TArguments);
begin
  Value := TPrintDialog(Args.Obj).MinPage;
end;

{ property Write MinPage(Value: Integer) }
procedure TPrintDialog_Write_MinPage(const Value: Variant; Args: TArguments);
begin
  TPrintDialog(Args.Obj).MinPage := Value;
end;

{ property Read MaxPage: Integer }
procedure TPrintDialog_Read_MaxPage(var Value: Variant; Args: TArguments);
begin
  Value := TPrintDialog(Args.Obj).MaxPage;
end;

{ property Write MaxPage(Value: Integer) }
procedure TPrintDialog_Write_MaxPage(const Value: Variant; Args: TArguments);
begin
  TPrintDialog(Args.Obj).MaxPage := Value;
end;

{ property Read Options: TPrintDialogOptions }
procedure TPrintDialog_Read_Options(var Value: Variant; Args: TArguments);
begin
  Value := S2V(Byte(TPrintDialog(Args.Obj).Options));
end;

{ property Write Options(Value: TPrintDialogOptions) }
procedure TPrintDialog_Write_Options(const Value: Variant; Args: TArguments);
begin
  TPrintDialog(Args.Obj).Options := TPrintDialogOptions(Byte(V2S(Value)));
end;

{ property Read PrintToFile: Boolean }
procedure TPrintDialog_Read_PrintToFile(var Value: Variant; Args: TArguments);
begin
  Value := TPrintDialog(Args.Obj).PrintToFile;
end;

{ property Write PrintToFile(Value: Boolean) }
procedure TPrintDialog_Write_PrintToFile(const Value: Variant; Args: TArguments);
begin
  TPrintDialog(Args.Obj).PrintToFile := Value;
end;

{ property Read PrintRange: TPrintRange }
procedure TPrintDialog_Read_PrintRange(var Value: Variant; Args: TArguments);
begin
  Value := TPrintDialog(Args.Obj).PrintRange;
end;

{ property Write PrintRange(Value: TPrintRange) }
procedure TPrintDialog_Write_PrintRange(const Value: Variant; Args: TArguments);
begin
  TPrintDialog(Args.Obj).PrintRange := Value;
end;

{ property Read ToPage: Integer }
procedure TPrintDialog_Read_ToPage(var Value: Variant; Args: TArguments);
begin
  Value := TPrintDialog(Args.Obj).ToPage;
end;

{ property Write ToPage(Value: Integer) }
procedure TPrintDialog_Write_ToPage(const Value: Variant; Args: TArguments);
begin
  TPrintDialog(Args.Obj).ToPage := Value;
end;

  { TFindDialog }

{ constructor Create(AOwner: TComponent) }
procedure TFindDialog_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TFindDialog.Create(V2O(Args.Values[0]) as TComponent));
end;

{  procedure CloseDialog; }
procedure TFindDialog_CloseDialog(var Value: Variant; Args: TArguments);
begin
  TFindDialog(Args.Obj).CloseDialog;
end;

{  function Execute: Boolean; }
procedure TFindDialog_Execute(var Value: Variant; Args: TArguments);
begin
  Value := TFindDialog(Args.Obj).Execute;
end;

{ property Read Left: Integer }
procedure TFindDialog_Read_Left(var Value: Variant; Args: TArguments);
begin
  Value := TFindDialog(Args.Obj).Left;
end;

{ property Write Left(Value: Integer) }
procedure TFindDialog_Write_Left(const Value: Variant; Args: TArguments);
begin
  TFindDialog(Args.Obj).Left := Value;
end;

{ property Read Top: Integer }
procedure TFindDialog_Read_Top(var Value: Variant; Args: TArguments);
begin
  Value := TFindDialog(Args.Obj).Top;
end;

{ property Write Top(Value: Integer) }
procedure TFindDialog_Write_Top(const Value: Variant; Args: TArguments);
begin
  TFindDialog(Args.Obj).Top := Value;
end;

{ property Read FindText: string }
procedure TFindDialog_Read_FindText(var Value: Variant; Args: TArguments);
begin
  Value := TFindDialog(Args.Obj).FindText;
end;

{ property Write FindText(Value: string) }
procedure TFindDialog_Write_FindText(const Value: Variant; Args: TArguments);
begin
  TFindDialog(Args.Obj).FindText := Value;
end;

{ property Read Options: TFindOptions }
procedure TFindDialog_Read_Options(var Value: Variant; Args: TArguments);
begin
  Value := S2V(Word(TFindDialog(Args.Obj).Options));
end;

{ property Write Options(Value: TFindOptions) }
procedure TFindDialog_Write_Options(const Value: Variant; Args: TArguments);
begin
  TFindDialog(Args.Obj).Options := TFindOptions(Word(V2S(Value)));
end;

  { TReplaceDialog }

{ constructor Create(AOwner: TComponent) }
procedure TReplaceDialog_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TReplaceDialog.Create(V2O(Args.Values[0]) as TComponent));
end;

{ property Read ReplaceText: string }
procedure TReplaceDialog_Read_ReplaceText(var Value: Variant; Args: TArguments);
begin
  Value := TReplaceDialog(Args.Obj).ReplaceText;
end;

{ property Write ReplaceText(Value: string) }
procedure TReplaceDialog_Write_ReplaceText(const Value: Variant; Args: TArguments);
begin
  TReplaceDialog(Args.Obj).ReplaceText := Value;
end;


{ function CreateMessageDialog(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): TForm; }
procedure Dialogs_CreateMessageDialog(var Value: Variant; Args: TArguments);
begin
  Value := O2V(CreateMessageDialog(Args.Values[0], Args.Values[1], TMsgDlgButtons(Word(V2S(Args.Values[2])))));
end;

{ function MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer; }
procedure Dialogs_MessageDlg(var Value: Variant; Args: TArguments);
begin
  Value := MessageDlg(Args.Values[0], Args.Values[1], TMsgDlgButtons(Word(V2S(Args.Values[2]))), Args.Values[3]);
end;

{ function MessageDlgPos(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer; }
procedure Dialogs_MessageDlgPos(var Value: Variant; Args: TArguments);
begin
  Value := MessageDlgPos(Args.Values[0], Args.Values[1], TMsgDlgButtons(Word(V2S(Args.Values[2]))), Args.Values[3], Args.Values[4], Args.Values[5]);
end;

{ function MessageDlgPosHelp(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer; const HelpFileName: string): Integer; }
procedure Dialogs_MessageDlgPosHelp(var Value: Variant; Args: TArguments);
begin
  Value := MessageDlgPosHelp(Args.Values[0], Args.Values[1], TMsgDlgButtons(Word(V2S(Args.Values[2]))), Args.Values[3], Args.Values[4], Args.Values[5], Args.Values[6]);
end;

{ procedure ShowMessage(const Msg: string); }
procedure Dialogs_ShowMessage(var Value: Variant; Args: TArguments);
begin
  ShowMessage(Args.Values[0]);
end;

{ procedure ShowMessagePos(const Msg: string; X, Y: Integer); }
procedure Dialogs_ShowMessagePos(var Value: Variant; Args: TArguments);
begin
  ShowMessagePos(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function InputBox(const ACaption, APrompt, ADefault: string): string; }
procedure Dialogs_InputBox(var Value: Variant; Args: TArguments);
begin
  Value := InputBox(Args.Values[0], Args.Values[1], Args.Values[2]);
end;

{ function InputQuery(const ACaption, APrompt: string; var Value: string): Boolean; }
procedure Dialogs_InputQuery(var Value: Variant; Args: TArguments);
begin
  Value := InputQuery(Args.Values[0], Args.Values[1], string(TVarData(Args.Values[2]).vString));
end;

(*

procedure RegisterDialogsAdapter(DialogsAdapter: TDialogsAdapter);
begin
  with DialogsAdapter do
  begin
   { TCommonDialog }
    AddClass('Dialogs', TCommonDialog, 'TCommonDialog');
   {$IFDEF RA_D3H}
    AddGet(TCommonDialog, 'Handle', TCommonDialog_Read_Handle, 0, [0], varEmpty);
   {$ENDIF RA_D3H}
   {$IFDEF RA_VCL}
    AddGet(TCommonDialog, 'Ctl3D', TCommonDialog_Read_Ctl3D, 0, [0], varEmpty);
    AddSet(TCommonDialog, 'Ctl3D', TCommonDialog_Write_Ctl3D, 0, [0]);
   {$ENDIF RA_VCL}
    AddGet(TCommonDialog, 'HelpContext', TCommonDialog_Read_HelpContext, 0, [0], varEmpty);
    AddSet(TCommonDialog, 'HelpContext', TCommonDialog_Write_HelpContext, 0, [0]);
   { TOpenOption }
   {$IFDEF RA_VCL}
    AddConst('Dialogs', 'ofReadOnly', Integer(ofReadOnly));
   {$ENDIF RA_VCL}
    AddConst('Dialogs', 'ofOverwritePrompt', Integer(ofOverwritePrompt));
   {$IFDEF RA_VCL}
    AddConst('Dialogs', 'ofHideReadOnly', Integer(ofHideReadOnly));
    AddConst('Dialogs', 'ofNoChangeDir', Integer(ofNoChangeDir));
    AddConst('Dialogs', 'ofShowHelp', Integer(ofShowHelp));
    AddConst('Dialogs', 'ofNoValidate', Integer(ofNoValidate));
   {$ENDIF RA_VCL}
    AddConst('Dialogs', 'ofAllowMultiSelect', Integer(ofAllowMultiSelect));
    AddConst('Dialogs', 'ofExtensionDifferent', Integer(ofExtensionDifferent));
    AddConst('Dialogs', 'ofPathMustExist', Integer(ofPathMustExist));
    AddConst('Dialogs', 'ofFileMustExist', Integer(ofFileMustExist));
   {$IFDEF RA_VCL}
    AddConst('Dialogs', 'ofCreatePrompt', Integer(ofCreatePrompt));
    AddConst('Dialogs', 'ofShareAware', Integer(ofShareAware));
    AddConst('Dialogs', 'ofNoReadOnlyReturn', Integer(ofNoReadOnlyReturn));
    AddConst('Dialogs', 'ofNoTestFileCreate', Integer(ofNoTestFileCreate));
    AddConst('Dialogs', 'ofNoNetworkButton', Integer(ofNoNetworkButton));
    AddConst('Dialogs', 'ofNoLongNames', Integer(ofNoLongNames));
    AddConst('Dialogs', 'ofOldStyleDialog', Integer(ofOldStyleDialog));
    AddConst('Dialogs', 'ofNoDereferenceLinks', Integer(ofNoDereferenceLinks));
   { TFileEditStyle }
    AddConst('Dialogs', 'fsEdit', Integer(fsEdit));
    AddConst('Dialogs', 'fsComboBox', Integer(fsComboBox));
   {$ENDIF RA_VCL}
   { TOpenDialog }
    AddClass('Dialogs', TOpenDialog, 'TOpenDialog');
    AddGet(TOpenDialog, 'Create', TOpenDialog_Create, 1, [varEmpty], varEmpty);
    AddGet(TOpenDialog, 'Execute', TOpenDialog_Execute, 0, [0], varEmpty);
   {$IFDEF RA_VCL}
    AddGet(TOpenDialog, 'FileEditStyle', TOpenDialog_Read_FileEditStyle, 0, [0], varEmpty);
    AddSet(TOpenDialog, 'FileEditStyle', TOpenDialog_Write_FileEditStyle, 0, [0]);
   {$ENDIF RA_VCL}
    AddGet(TOpenDialog, 'Files', TOpenDialog_Read_Files, 0, [0], varEmpty);
    AddGet(TOpenDialog, 'HistoryList', TOpenDialog_Read_HistoryList, 0, [0], varEmpty);
    AddSet(TOpenDialog, 'HistoryList', TOpenDialog_Write_HistoryList, 0, [0]);
    AddGet(TOpenDialog, 'DefaultExt', TOpenDialog_Read_DefaultExt, 0, [0], varEmpty);
    AddSet(TOpenDialog, 'DefaultExt', TOpenDialog_Write_DefaultExt, 0, [0]);
    AddGet(TOpenDialog, 'FileName', TOpenDialog_Read_FileName, 0, [0], varEmpty);
    AddSet(TOpenDialog, 'FileName', TOpenDialog_Write_FileName, 0, [0]);
    AddGet(TOpenDialog, 'Filter', TOpenDialog_Read_Filter, 0, [0], varEmpty);
    AddSet(TOpenDialog, 'Filter', TOpenDialog_Write_Filter, 0, [0]);
    AddGet(TOpenDialog, 'FilterIndex', TOpenDialog_Read_FilterIndex, 0, [0], varEmpty);
    AddSet(TOpenDialog, 'FilterIndex', TOpenDialog_Write_FilterIndex, 0, [0]);
    AddGet(TOpenDialog, 'InitialDir', TOpenDialog_Read_InitialDir, 0, [0], varEmpty);
    AddSet(TOpenDialog, 'InitialDir', TOpenDialog_Write_InitialDir, 0, [0]);
    AddGet(TOpenDialog, 'Options', TOpenDialog_Read_Options, 0, [0], varEmpty);
    AddSet(TOpenDialog, 'Options', TOpenDialog_Write_Options, 0, [0]);
    AddGet(TOpenDialog, 'Title', TOpenDialog_Read_Title, 0, [0], varEmpty);
    AddSet(TOpenDialog, 'Title', TOpenDialog_Write_Title, 0, [0]);
   { TSaveDialog }
    AddClass('Dialogs', TSaveDialog, 'TSaveDialog');
    AddGet(TSaveDialog, 'Create', TSaveDialog_Create, 1, [varEmpty], varEmpty);
    AddGet(TSaveDialog, 'Execute', TSaveDialog_Execute, 0, [0], varEmpty);
   {$IFDEF RA_VCL}
   { TColorDialogOption }
    AddConst('Dialogs', 'cdFullOpen', Integer(cdFullOpen));
    AddConst('Dialogs', 'cdPreventFullOpen', Integer(cdPreventFullOpen));
    AddConst('Dialogs', 'cdShowHelp', Integer(cdShowHelp));
    AddConst('Dialogs', 'cdSolidColor', Integer(cdSolidColor));
    AddConst('Dialogs', 'cdAnyColor', Integer(cdAnyColor));
   {$ENDIF RA_VCL}
   { TColorDialog }
    AddClass('Dialogs', TColorDialog, 'TColorDialog');
    AddGet(TColorDialog, 'Create', TColorDialog_Create, 1, [varEmpty], varEmpty);
    AddGet(TColorDialog, 'Execute', TColorDialog_Execute, 0, [0], varEmpty);
    AddGet(TColorDialog, 'Color', TColorDialog_Read_Color, 0, [0], varEmpty);
    AddSet(TColorDialog, 'Color', TColorDialog_Write_Color, 0, [0]);
    AddGet(TColorDialog, 'CustomColors', TColorDialog_Read_CustomColors, 0, [0], varEmpty);
    AddSet(TColorDialog, 'CustomColors', TColorDialog_Write_CustomColors, 0, [0]);
   {$IFDEF RA_VCL}
    AddGet(TColorDialog, 'Options', TColorDialog_Read_Options, 0, [0], varEmpty);
    AddSet(TColorDialog, 'Options', TColorDialog_Write_Options, 0, [0]);
   {$ENDIF RA_VCL}
   {$IFDEF RA_VCL}
   { TFontDialogOption }
    AddConst('Dialogs', 'fdAnsiOnly', Integer(fdAnsiOnly));
    AddConst('Dialogs', 'fdTrueTypeOnly', Integer(fdTrueTypeOnly));
    AddConst('Dialogs', 'fdEffects', Integer(fdEffects));
    AddConst('Dialogs', 'fdFixedPitchOnly', Integer(fdFixedPitchOnly));
    AddConst('Dialogs', 'fdForceFontExist', Integer(fdForceFontExist));
    AddConst('Dialogs', 'fdNoFaceSel', Integer(fdNoFaceSel));
    AddConst('Dialogs', 'fdNoOEMFonts', Integer(fdNoOEMFonts));
    AddConst('Dialogs', 'fdNoSimulations', Integer(fdNoSimulations));
    AddConst('Dialogs', 'fdNoSizeSel', Integer(fdNoSizeSel));
    AddConst('Dialogs', 'fdNoStyleSel', Integer(fdNoStyleSel));
    AddConst('Dialogs', 'fdNoVectorFonts', Integer(fdNoVectorFonts));
    AddConst('Dialogs', 'fdShowHelp', Integer(fdShowHelp));
    AddConst('Dialogs', 'fdWysiwyg', Integer(fdWysiwyg));
    AddConst('Dialogs', 'fdLimitSize', Integer(fdLimitSize));
    AddConst('Dialogs', 'fdScalableOnly', Integer(fdScalableOnly));
    AddConst('Dialogs', 'fdApplyButton', Integer(fdApplyButton));
   { TFontDialogDevice }
    AddConst('Dialogs', 'fdScreen', Integer(fdScreen));
    AddConst('Dialogs', 'fdPrinter', Integer(fdPrinter));
    AddConst('Dialogs', 'fdBoth', Integer(fdBoth));
   {$ENDIF RA_VCL}
   { TFontDialog }
    AddClass('Dialogs', TFontDialog, 'TFontDialog');
    AddGet(TFontDialog, 'Create', TFontDialog_Create, 1, [varEmpty], varEmpty);
    AddGet(TFontDialog, 'Execute', TFontDialog_Execute, 0, [0], varEmpty);
    AddGet(TFontDialog, 'Font', TFontDialog_Read_Font, 0, [0], varEmpty);
    AddSet(TFontDialog, 'Font', TFontDialog_Write_Font, 0, [0]);
   {$IFDEF RA_VCL}
    AddGet(TFontDialog, 'Device', TFontDialog_Read_Device, 0, [0], varEmpty);
    AddSet(TFontDialog, 'Device', TFontDialog_Write_Device, 0, [0]);
    AddGet(TFontDialog, 'MinFontSize', TFontDialog_Read_MinFontSize, 0, [0], varEmpty);
    AddSet(TFontDialog, 'MinFontSize', TFontDialog_Write_MinFontSize, 0, [0]);
    AddGet(TFontDialog, 'MaxFontSize', TFontDialog_Read_MaxFontSize, 0, [0], varEmpty);
    AddSet(TFontDialog, 'MaxFontSize', TFontDialog_Write_MaxFontSize, 0, [0]);
    AddGet(TFontDialog, 'Options', TFontDialog_Read_Options, 0, [0], varEmpty);
    AddSet(TFontDialog, 'Options', TFontDialog_Write_Options, 0, [0]);
   {$ENDIF RA_VCL}
   {$IFDEF RA_VCL}
   { TPrinterSetupDialog }
    AddClass('Dialogs', TPrinterSetupDialog, 'TPrinterSetupDialog');
    AddGet(TPrinterSetupDialog, 'Create', TPrinterSetupDialog_Create, 1, [varEmpty], varEmpty);
    AddGet(TPrinterSetupDialog, 'Execute', TPrinterSetupDialog_Execute, 0, [0], varEmpty);
   { TPrintRange }
    AddConst('Dialogs', 'prAllPages', Integer(prAllPages));
    AddConst('Dialogs', 'prSelection', Integer(prSelection));
    AddConst('Dialogs', 'prPageNums', Integer(prPageNums));
   { TPrintDialogOption }
    AddConst('Dialogs', 'poPrintToFile', Integer(poPrintToFile));
    AddConst('Dialogs', 'poPageNums', Integer(poPageNums));
    AddConst('Dialogs', 'poSelection', Integer(poSelection));
    AddConst('Dialogs', 'poWarning', Integer(poWarning));
    AddConst('Dialogs', 'poHelp', Integer(poHelp));
    AddConst('Dialogs', 'poDisablePrintToFile', Integer(poDisablePrintToFile));
   { TPrintDialog }
    AddClass('Dialogs', TPrintDialog, 'TPrintDialog');
    AddGet(TPrintDialog, 'Create', TPrintDialog_Create, 1, [varEmpty], varEmpty);
    AddGet(TPrintDialog, 'Execute', TPrintDialog_Execute, 0, [0], varEmpty);
    AddGet(TPrintDialog, 'Collate', TPrintDialog_Read_Collate, 0, [0], varEmpty);
    AddSet(TPrintDialog, 'Collate', TPrintDialog_Write_Collate, 0, [0]);
    AddGet(TPrintDialog, 'Copies', TPrintDialog_Read_Copies, 0, [0], varEmpty);
    AddSet(TPrintDialog, 'Copies', TPrintDialog_Write_Copies, 0, [0]);
    AddGet(TPrintDialog, 'FromPage', TPrintDialog_Read_FromPage, 0, [0], varEmpty);
    AddSet(TPrintDialog, 'FromPage', TPrintDialog_Write_FromPage, 0, [0]);
    AddGet(TPrintDialog, 'MinPage', TPrintDialog_Read_MinPage, 0, [0], varEmpty);
    AddSet(TPrintDialog, 'MinPage', TPrintDialog_Write_MinPage, 0, [0]);
    AddGet(TPrintDialog, 'MaxPage', TPrintDialog_Read_MaxPage, 0, [0], varEmpty);
    AddSet(TPrintDialog, 'MaxPage', TPrintDialog_Write_MaxPage, 0, [0]);
    AddGet(TPrintDialog, 'Options', TPrintDialog_Read_Options, 0, [0], varEmpty);
    AddSet(TPrintDialog, 'Options', TPrintDialog_Write_Options, 0, [0]);
    AddGet(TPrintDialog, 'PrintToFile', TPrintDialog_Read_PrintToFile, 0, [0], varEmpty);
    AddSet(TPrintDialog, 'PrintToFile', TPrintDialog_Write_PrintToFile, 0, [0]);
    AddGet(TPrintDialog, 'PrintRange', TPrintDialog_Read_PrintRange, 0, [0], varEmpty);
    AddSet(TPrintDialog, 'PrintRange', TPrintDialog_Write_PrintRange, 0, [0]);
    AddGet(TPrintDialog, 'ToPage', TPrintDialog_Read_ToPage, 0, [0], varEmpty);
    AddSet(TPrintDialog, 'ToPage', TPrintDialog_Write_ToPage, 0, [0]);
   {$ENDIF RA_VCL}
   { TFindOption }
    AddConst('Dialogs', 'frDown', Integer(frDown));
    AddConst('Dialogs', 'frFindNext', Integer(frFindNext));
    AddConst('Dialogs', 'frHideMatchCase', Integer(frHideMatchCase));
    AddConst('Dialogs', 'frHideWholeWord', Integer(frHideWholeWord));
    AddConst('Dialogs', 'frHideUpDown', Integer(frHideUpDown));
    AddConst('Dialogs', 'frMatchCase', Integer(frMatchCase));
    AddConst('Dialogs', 'frDisableMatchCase', Integer(frDisableMatchCase));
    AddConst('Dialogs', 'frDisableUpDown', Integer(frDisableUpDown));
    AddConst('Dialogs', 'frDisableWholeWord', Integer(frDisableWholeWord));
    AddConst('Dialogs', 'frReplace', Integer(frReplace));
    AddConst('Dialogs', 'frReplaceAll', Integer(frReplaceAll));
    AddConst('Dialogs', 'frWholeWord', Integer(frWholeWord));
    AddConst('Dialogs', 'frShowHelp', Integer(frShowHelp));
   { TFindDialog }
    AddClass('Dialogs', TFindDialog, 'TFindDialog');
    AddGet(TFindDialog, 'Create', TFindDialog_Create, 1, [varEmpty], varEmpty);
   {$IFDEF RA_VCL}
    AddGet(TFindDialog, 'CloseDialog', TFindDialog_CloseDialog, 0, [0], varEmpty);
   {$ENDIF RA_VCL}
    AddGet(TFindDialog, 'Execute', TFindDialog_Execute, 0, [0], varEmpty);
   {$IFDEF RA_VCL}
    AddGet(TFindDialog, 'Left', TFindDialog_Read_Left, 0, [0], varEmpty);
    AddSet(TFindDialog, 'Left', TFindDialog_Write_Left, 0, [0]);
   {$ENDIF RA_VCL}
    AddGet(TFindDialog, 'Position', TFindDialog_Read_Position, 0, [0], varEmpty);
    AddSet(TFindDialog, 'Position', TFindDialog_Write_Position, 0, [0]);
   {$IFDEF RA_VCL}
    AddGet(TFindDialog, 'Top', TFindDialog_Read_Top, 0, [0], varEmpty);
    AddSet(TFindDialog, 'Top', TFindDialog_Write_Top, 0, [0]);
   {$ENDIF RA_VCL}
    AddGet(TFindDialog, 'FindText', TFindDialog_Read_FindText, 0, [0], varEmpty);
    AddSet(TFindDialog, 'FindText', TFindDialog_Write_FindText, 0, [0]);
    AddGet(TFindDialog, 'Options', TFindDialog_Read_Options, 0, [0], varEmpty);
    AddSet(TFindDialog, 'Options', TFindDialog_Write_Options, 0, [0]);
   { TReplaceDialog }
    AddClass('Dialogs', TReplaceDialog, 'TReplaceDialog');
    AddGet(TReplaceDialog, 'Create', TReplaceDialog_Create, 1, [varEmpty], varEmpty);
    AddGet(TReplaceDialog, 'ReplaceText', TReplaceDialog_Read_ReplaceText, 0, [0], varEmpty);
    AddSet(TReplaceDialog, 'ReplaceText', TReplaceDialog_Write_ReplaceText, 0, [0]);
   { TMsgDlgType }
    AddConst('Dialogs', 'mtWarning', Integer(mtWarning));
    AddConst('Dialogs', 'mtError', Integer(mtError));
    AddConst('Dialogs', 'mtInformation', Integer(mtInformation));
    AddConst('Dialogs', 'mtConfirmation', Integer(mtConfirmation));
    AddConst('Dialogs', 'mtCustom', Integer(mtCustom));
   { TMsgDlgBtn }
    AddConst('Dialogs', 'mbYes', Integer(mbYes));
    AddConst('Dialogs', 'mbNo', Integer(mbNo));
    AddConst('Dialogs', 'mbOK', Integer(mbOK));
    AddConst('Dialogs', 'mbCancel', Integer(mbCancel));
    AddConst('Dialogs', 'mbAbort', Integer(mbAbort));
    AddConst('Dialogs', 'mbRetry', Integer(mbRetry));
    AddConst('Dialogs', 'mbIgnore', Integer(mbIgnore));
   {$IFDEF RA_VCL}
    AddConst('Dialogs', 'mbAll', Integer(mbAll));
   {$IFDEF RA_D3H}
    AddConst('Dialogs', 'mbNoToAll', Integer(mbNoToAll));
    AddConst('Dialogs', 'mbYesToAll', Integer(mbYesToAll));
   {$ENDIF RA_D3H}
    AddConst('Dialogs', 'mbHelp', Integer(mbHelp));
   {$ENDIF RA_VCL}
    AddConst('Dialogs', 'mrNone', Integer(mrNone));
    AddConst('Dialogs', 'mrOk', Integer(mrOk));
    AddConst('Dialogs', 'mrCancel', Integer(mrCancel));
    AddConst('Dialogs', 'mrAbort', Integer(mrAbort));
    AddConst('Dialogs', 'mrRetry', Integer(mrRetry));
    AddConst('Dialogs', 'mrIgnore', Integer(mrIgnore));
    AddConst('Dialogs', 'mrYes', Integer(mrYes));
    AddConst('Dialogs', 'mrNo', Integer(mrNo));
    AddConst('Dialogs', 'mrAll', Integer(mrAll));
   {$IFDEF RA_D3H}
    AddConst('Dialogs', 'mrNoToAll', Integer(mrNoToAll));
    AddConst('Dialogs', 'mrYesToAll', Integer(mrYesToAll));
   {$ENDIF RA_D3H}
   {$IFDEF RA_VCL}
    AddFun('Dialogs', 'CreateMessageDialog', Dialogs_CreateMessageDialog, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
   {$ENDIF RA_VCL}
    AddFun('Dialogs', 'MessageDlg', Dialogs_MessageDlg, 4, [varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('Dialogs', 'MessageDlgPos', Dialogs_MessageDlgPos, 6, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
   {$IFDEF RA_VCL}
   {$IFDEF RA_D3H}
    AddFun('Dialogs', 'MessageDlgPosHelp', Dialogs_MessageDlgPosHelp, 7, [varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty, varEmpty], varEmpty);
   {$ENDIF RA_D3H}
   {$ENDIF RA_VCL}
    AddFun('Dialogs', 'ShowMessage', Dialogs_ShowMessage, 1, [varEmpty], varEmpty);
   {$IFDEF RA_D3H}
    AddFun('Dialogs', 'ShowMessageFmt', Dialogs_ShowMessageFmt, 2, [varEmpty, varEmpty], varEmpty);
   {$ENDIF RA_D3H}
    AddFun('Dialogs', 'ShowMessagePos', Dialogs_ShowMessagePos, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('Dialogs', 'InputBox', Dialogs_InputBox, 3, [varEmpty, varEmpty, varEmpty], varEmpty);
    AddFun('Dialogs', 'InputQuery', Dialogs_InputQuery, 3, [varEmpty, varEmpty, varByRef], varEmpty);
  end;    { with }
  RegisterClasses([TOpenDialog, TSaveDialog, TFontDialog, TColorDialog,
  {$IFDEF RA_VCL}
  TPrintDialog, TPrinterSetupDialog,
  {$ENDIF RA_VCL}
  TFindDialog, TReplaceDialog]);
end;    { RegisterDialogsAdapter }
  *)

end.

