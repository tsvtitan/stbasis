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

unit frmuModifyServerAlias;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, frmuDlgClass;

type
  TfrmModifyServerAlias = class(TDialog)
    Label1: TLabel;
    edtAliasName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtServerName: TEdit;
    edtUsername: TEdit;
    cbProtocol: TComboBox;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    stMessage: TStaticText;
    imgError: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function DisplayModifyAlias (const aliasName: String; var server, username: String;
                               var protocol: integer;
                               ErrMsg: String): integer;

implementation

{$R *.DFM}

function DisplayModifyAlias (const aliasName: String; var server, username: String;
                             var protocol: integer;
                             ErrMsg: String): integer;

var
  frmModifyAlias: TfrmModifyServerAlias;

begin
  frmModifyAlias := TfrmModifyServerAlias.Create (Application);
  with frmModifyAlias do begin
    stMessage.Caption := Format ('Error Reading alias %s:'#13#10'%s',[AliasName, ErrMsg]);
    edtAliasName.Text := AliasName;
    edtServerName.Text := Server;
    edtUserName.Text := UserName;
    cbProtocol.ItemIndex := protocol;
    result := ShowModal;

    if result = mrOK then
    begin
      Server := edtServerName.Text;
      UserName := edtUserName.Text;
      Protocol := cbProtocol.ItemIndex;
    end;
  end;
  frmModifyAlias.Free;
end;


end.
