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

unit frmuISQL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, Menus, Grids, StdCtrls, DBGrids, ExtCtrls, ImgList,
  Db, IBCustomDataSet;

type
  TfrmISQL = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Query1: TMenuItem;
    Help1: TMenuItem;
    Help2: TMenuItem;
    Open1: TMenuItem;
    SaveQuery1: TMenuItem;
    SaveOutput1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    N2: TMenuItem;
    SelectAll1: TMenuItem;
    ClearText1: TMenuItem;
    Execute1: TMenuItem;
    Next1: TMenuItem;
    Last1: TMenuItem;
    N3: TMenuItem;
    Preferences1: TMenuItem;
    Create1: TMenuItem;
    Connect1: TMenuItem;
    Properties1: TMenuItem;
    N4: TMenuItem;
    Extract1: TMenuItem;
    stbISQL: TStatusBar;
    CoolBar1: TCoolBar;
    imgToolBarsDisabled: TImageList;
    imgToolBarsEnabled: TImageList;
    reSQLInput: TRichEdit;
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    dbgData: TDBGrid;
    TabSheet2: TTabSheet;
    reSQLOutput: TMemo;
    TabSheet3: TTabSheet;
    StringGrid1: TStringGrid;
    ControlBar2: TControlBar;
    ControlBar1: TControlBar;
    tlbISQL: TToolBar;
    tbExecuteScript: TToolButton;
    tbPreviousScript: TToolButton;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    QryMenu: TPopupMenu;
    IBDataSet1: TIBDataSet;
    DataSource1: TDataSource;
    procedure Open1Click(Sender: TObject);
    procedure SaveOutput1Click(Sender: TObject);
    procedure Execute1Click(Sender: TObject);
    procedure reSQLInputKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure reSQLInputSelectionChange(Sender: TObject);
    procedure reSQLInputMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    procedure SetModified(IsModified: Boolean; IsReadOnly: boolean; StatusBar: TStatusBar);
    procedure UpdateCursorPos(Editor: TRichEdit; StatusBar: TStatusBar);
    procedure OpenFile(var Editor: TRichEdit; const sFileName: string);
  public
    { Public declarations }
  end;

var
  frmISQL: TfrmISQL;

implementation

{$R *.DFM}

uses
  zluSQL, RichEdit, frmuDBCreate;

procedure TfrmISQL.Open1Click(Sender: TObject);
var
  lOpenDialog: TOpenDialog;
begin
  lOpenDialog := nil;
  try
  begin
    lOpenDialog := TOpenDialog.Create(self);
    lOpenDialog.DefaultExt := 'sql';
    lOpenDialog.Filter := 'SQL Files (*.sql)|*.SQL|Text files (*.txt)|*.TXT|All files (*.*)|*.*';
    if lOpenDialog.Execute then
    begin
      OpenFile(reSQLInput, lOpenDialog.FileName);
    end;
  end
  finally
    lOpenDialog.free;
  end;
end;

procedure TfrmISQL.SaveOutput1Click(Sender: TObject);
var
  lSaveDialog: TSaveDialog;
begin
  lSaveDialog := nil;
  try
  begin
    lSaveDialog := TSaveDialog.Create(Self);
    lSaveDialog.Title := 'Export to';
    lSaveDialog.Filter := 'SQL (*.sql)|*.SQL|All files (*.*)|*.*';
    lSaveDialog.DefaultExt := 'sql';

    if lSaveDialog.Execute then
    begin
      if FileExists(lSaveDialog.FileName) then
        if MessageDlg(Format('OK to overwrite %s', [lSaveDialog.FileName]),
          mtConfirmation, mbYesNoCancel, 0) <> idYes then Exit;
      reSQLOutput.Lines.SaveToFile(lSaveDialog.FileName);
    end;
  end
  finally
    lSaveDialog.free;
  end;
end;

procedure TfrmISQL.Execute1Click(Sender: TObject);
begin
{ TODO : The second parameter should reflect any database currently attached to }
  DoIsql (reSQlInput.LineS, nil);
end;

procedure TfrmISQL.reSQLInputKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  SetModified(true,false,stbISQL);
end;

procedure TfrmISQL.reSQLInputSelectionChange(Sender: TObject);
begin
  UpdateCursorPos(reSQLInput,stbISQL);
end;

procedure TfrmISQL.reSQLInputMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    reSQLInput.SetFocus;
  end;
end;

procedure TfrmISQL.UpdateCursorPos(Editor: TRichEdit; StatusBar: TStatusBar);
var
  CharPos: TPoint;
begin
  CharPos.Y := SendMessage(Editor.Handle, EM_EXLINEFROMCHAR, 0, Editor.SelStart);
  CharPos.X := (Editor.SelStart - SendMessage(Editor.Handle, EM_LINEINDEX, CharPos.Y, 0));
  Inc(CharPos.Y);
  Inc(CharPos.X);
  StatusBar.Panels[0].Text := Format('%3d: %3d', [CharPos.Y, CharPos.X]);
end;

procedure TfrmISQL.SetModified(IsModified, IsReadOnly: boolean;
  StatusBar: TStatusBar);
begin
  if IsModified then
    StatusBar.Panels[1].Text := 'Modified'
  else
    StatusBar.Panels[1].Text := '';

  if IsReadOnly then
    StatusBar.Panels[1].Text := 'Read Only';
end;

procedure TfrmISQL.OpenFile(var Editor: TRichEdit;
  const sFileName: string);
begin
  try
    Screen.Cursor := crHourGlass;
    try
      Editor.Lines.LoadFromFile(sFileName);
    except
      on E:Exception do
      begin
        MessageDlg(E.Message + #10#13+
        Format('Could not open file "%s"!',[sFileName]), mtError, [mbOK], 0);
        Exit;
      end;
    end;
    Editor.SetFocus;
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
