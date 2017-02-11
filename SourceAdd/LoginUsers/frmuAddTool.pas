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

unit frmuAddTool;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frmuDlgClass, StdCtrls;

type
  TfrmAddTools = class(TDialog)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtTitle: TEdit;
    edtProgram: TEdit;
    edtWorkingDir: TEdit;
    edtParams: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    btnBrowse: TButton;
    procedure btnBrowseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses zluGlobal;

{$R *.DFM}

procedure TfrmAddTools.btnBrowseClick(Sender: TObject);
var
  OpenDlg: TOpenDialog;
begin
  inherited;
  OpenDlg := TOpenDialog.Create (self);

  with OpenDlg do
  begin
    DefaultExt := '.EXE';
    Options := Options + [ofPathMustExist, ofFileMustExist];
    Filter := 'Program Files | *.EXE; *.BAT; *.COM;';
    if Execute then
    begin
      edtProgram.Text := FileName;
      if Length(edtTitle.Text) = 0 then
        edtTitle.Text := ExtractFileName(FileName);
    end;
    Free;
  end;
end;

end.
