{
 * The contents of this file are subject to the InterBase Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License.
 * 
 * You may obtain a copy of the License at http://www.Inprise.com/IPL.html.
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
 * the License for the specific language governing rights and limitations
 * under the License.  The Original Code was created by Inprise
 * Corporation and its predecessors.
 * 
 * Portions created by Inprise Corporation are Copyright (C) Inprise
 * Corporation. All Rights Reserved.
 * 
 * Contributor(s): ______________________________________.
}

unit frmuTools;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frmuDlgClass, StdCtrls, Buttons, ActnList;

type
  TTool = class (TObject)
  private
    FAppTitle,
    FProgName,
    FWorkingDir,
    FParams: String;
    
  published
    property AppTitle: String read FAppTitle write FAppTitle;
    property ProgName: String read FProgName write FProgName;
    property WorkingDir: String  read FWorkingDir write FWorkingDir;
    property Params: String read FParams write FParams;
  end;

  TfrmTools = class(TDialog)
    btnAdd: TButton;
    btnDelete: TButton;
    btnEdit: TButton;
    Label1: TLabel;
    lbTools: TListBox;
    btnActions: TActionList;
    ToolAdd: TAction;
    ToolDelete: TAction;
    ToolEdit: TAction;
    ToolBtnUp: TAction;
    ToolBtnDown: TAction;
    Button1: TButton;
    ToolBtnClose: TAction;
    procedure ToolDeleteUpdate(Sender: TObject);
    procedure lbToolsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ToolAddExecute(Sender: TObject);
    procedure ToolEditExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolDeleteExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses registry, zluGlobal, frmuAddTool;

procedure TfrmTools.ToolDeleteUpdate(Sender: TObject);
var
  lcnt: integer;
begin
  inherited;

  for lCnt := 0 to lbTools.Items.Count - 1 do
    if lbTools.Selected[lCnt] then
    begin
      (Sender as TAction).Enabled := true;
      exit;
    end;
  (Sender as TAction).Enabled := false;
end;

procedure TfrmTools.lbToolsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  FontHeight: integer;
  Flags: LongInt;
begin
  inherited;
  with lbTools.Canvas do
  begin
    FillRect(Rect);
    Font := Self.Font;

    if odSelected in State then
      Font.Color := clHighlightText;

    FontHeight := TextHeight('W');
    with Rect do
    begin
      Top := ((Bottom + Top) - FontHeight) div 2;
      Bottom := Top + FontHeight;
      Left := Left+TextWidth('W');
    end;

    Flags := DT_EXPANDTABS or DT_VCENTER;
    Flags := DrawTextBiDiModeFlags(Flags);
    DrawText(Handle, PChar(lbTools.Items[Index]), -1, Rect, Flags);
  end;
end;

procedure TfrmTools.ToolAddExecute(Sender: TObject);
var
  toolDlg: TfrmAddTools;
  Reg: TRegistry;
  lPos: integer;
begin
  inherited;
  toolDlg := TfrmAddTools.Create (self);
  with toolDlg do
  begin
    if ShowModal = mrOK then
    begin
      Reg := TRegistry.Create;
      with Reg do
      begin
        lbTools.Items.Add (edtTitle.text);
        gExternalApps.Add (edtTitle.text);
        OpenKey (gRegToolsKey, true);
        if ValueExists('Count') then
          lPos := ReadInteger('Count')
        else
          lPos := 0;
        WriteString (Format('Title%d', [lPos]), edtTitle.text);
        WriteString (Format('Path%d', [lPos]), edtProgram.text);
        writeString (Format('WorkingDir%d', [lPos]), edtWorkingDir.text);
        WriteString (Format('Params%d', [lPos]), edtParams.text);
        Inc(lPos);
        WriteInteger ('Count', lPos);
        CloseKey;
        Free;
      end;
    end;
  end;
end;

procedure TfrmTools.ToolEditExecute(Sender: TObject);
var
  toolDlg: TfrmAddTools;
  Reg: TRegistry;
  lPos: integer;
begin
  inherited;
  toolDlg := TfrmAddTools.Create (self);
  with toolDlg do
  begin
    Reg := TRegistry.Create;
    with Reg do
    begin
      OpenKey (gRegToolsKey, false);
      edtTitle.text := ReadString (Format('Title%d',[lbTools.ItemIndex]));
      edtProgram.text := ReadString (Format('Path%d',[lbTools.ItemIndex]));
      edtWorkingDir.text := ReadString (Format('WorkingDir%d',[lbTools.ItemIndex]));
      edtParams.text := ReadString (Format('Params%d',[lbTools.ItemIndex]));
      CloseKey;
      Free;
    end;
    if ShowModal = mrOK then
    begin
      Reg := TRegistry.Create;
      with Reg do
      begin
        lbTools.Items.BeginUpdate;
        lbTools.Items.Strings[lbTools.ItemIndex] := edtTitle.Text;
        lbTools.Items.EndUpdate;
        gExternalApps.Strings[lbTools.ItemIndex] :=  edtTitle.text;
        OpenKey (gRegToolsKey, true);
        lPos := lbTools.ItemIndex;
        WriteString (Format('Title%d', [lPos]), edtTitle.text);
        WriteString (Format('Path%d', [lPos]), edtProgram.text);
        writeString (Format('WorkingDir%d', [lPos]), edtWorkingDir.text);
        WriteString (Format('Params%d', [lPos]), edtParams.text);
        CloseKey;
        Free;
      end;
    end;
  end;
end;

procedure TfrmTools.FormShow(Sender: TObject);
begin
  inherited;
  lbTools.Items.AddStrings(gExternalApps);
end;

procedure TfrmTools.ToolDeleteExecute(Sender: TObject);
var
  Reg:  TRegistry;
  lPos, idx: integer;
  str:  TstringList;
  value: String;
begin
  inherited;
  Reg := TRegistry.Create;
  Str := TStringList.Create;
  with Reg do
  begin
    OpenKey (gRegToolsKey, true);
    lPos := lbTools.ItemIndex;
    DeleteValue (Format('Title%d', [lPos]));
    DeleteValue (Format('Path%d', [lPos]));
    DeleteValue (Format('WorkingDir%d', [lPos]));
    DeleteValue (Format('Params%d', [lPos]));
    GetValueNames (Str);
    Str.Delete (Str.IndexOf('Count'));

    for lPos := 0 to Str.Count-1 do
    begin
      Value := Str.Strings[lPos];
      idx := lPos div 4;  { 4 is the number of entries }
      if Pos ('Title', Value) = 1 then
        RenameValue (Value, Format('Title%d', [idx]));
      if Pos ('Path', Value) = 1 then
        RenameValue (Value, Format('Path%d', [idx]));
      if Pos ('WorkingDir', Value) = 1 then
        RenameValue (Value, Format('WorkingDir%d', [idx]));
      if Pos ('Params', Value) = 1 then
        RenameValue (Value, Format('Params%d', [idx]));
    end;
    gExternalApps.Clear;
    for lPos := 0 to lbTools.Items.Count-2 do
      gExternalApps.Add (ReadString (Format('Title%d', [lPos])));
    lbTools.Items.BeginUpdate;
    lbTools.Items.Clear;
    lbTools.Items.AddStrings(gExternalApps);
    lbTools.Items.EndUpdate;
    WriteInteger('Count', lbTools.Items.Count);    
    CloseKey;
    Free;
  end;
  Str.Free;
end;

end.
