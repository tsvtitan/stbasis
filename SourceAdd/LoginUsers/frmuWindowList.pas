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

unit frmuWindowList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frmuDlgClass, StdCtrls;

type
  TdlgWindowList = class(TDialog)
    lbWindows: TListBox;
    btnSwitch: TButton;
    btnClose: TButton;
    procedure btnSwitchClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure lbWindowsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgWindowList: TdlgWindowList;

implementation

{$R *.DFM}

procedure TdlgWindowList.btnSwitchClick(Sender: TObject);
var
  frm: TForm;
begin
  inherited;
  if lbWindows.ItemIndex <> -1 then
  begin
    frm := TForm(lbWindows.Items.Objects[lbWindows.ItemIndex]);
    frm.Show;
  end;
  Close;
end;

procedure TdlgWindowList.btnCloseClick(Sender: TObject);
var
  frm: TForm;
begin
  inherited;
  if lbWindows.ItemIndex <> -1 then
  begin
    frm := TForm(lbWindows.Items.Objects[lbWindows.ItemIndex]);
    frm.Close;
  end;
  Close;
end;

procedure TdlgWindowList.lbWindowsClick(Sender: TObject);
begin
  inherited;
  btnSwitch.Enabled := true;
  btnClose.Enabled := true;
end;

end.
