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
{****************************************************************
*
*  f r m u A d d C e r t i f i c a t e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides an interface for adding
*                certificates
*
*****************************************************************
* Revisions:
*
*****************************************************************}
unit frmuAddCertificate;

interface

uses
  Windows, Forms, ExtCtrls, StdCtrls, Classes, Controls, Messages, frmuDlgClass;

type
  TfrmAddCertificate = class(TDialog)
    lblCertificateKey: TLabel;
    lblCertificateID: TLabel;
    edtCertificateID: TEdit;
    edtCertificateKey: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    memInstructions: TMemo;
    function FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    function VerifyInputData(): boolean;
    procedure WMNCLButtonDown( var Message: TWMNCLBUTTONDOWN ); message WM_NCLBUTTONDOWN ;
  public
    { Public declarations }
  end;

function AddCertificate(var CertificateID,CertificateKey: string): boolean;

implementation

uses frmuMessage, zluContextHelp;

{$R *.DFM}

{****************************************************************
*
*  A d d C e r t i f i c a t e ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  CertificateID  - a string containing the certificate
*                           ID
*          CertificateKey - a string containing the certificate
*                           key
*
*  Return: Boolean - inidicates whether or not a certificate ID
*                    and certificate key are to be added
*
*  Description: This form is used to capture a valid
*               certificate ID and certificate key.  The actual
*               adding of the license is handled by the main
*               form.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function AddCertificate(var CertificateID,CertificateKey: string): boolean;
var
  frmAddCertificate: TfrmAddCertificate;
begin
  frmAddCertificate := TfrmAddCertificate.Create(Application);
  try
    // display id and key if supplied
    frmAddCertificate.edtCertificateID.Text := CertificateID;
    frmAddCertificate.edtCertificateKey.Text := CertificateKey;
    frmAddCertificate.ShowModal;       // show form as modal dialog box
    if frmAddCertificate.ModalResult = mrOK then
    begin
      // set certificate id and key
      CertificateID := frmAddCertificate.edtCertificateID.Text;
      CertificateKey := frmAddCertificate.edtCertificateKey.Text;
      result := true;
    end
    else
      result := false;
  finally
    // deallocate memory
    frmAddCertificate.Free;
  end;
end;


function TfrmAddCertificate.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
  // call WinHelp and show Server Certificates topic
  Result := WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,SERVER_CERTIFICATES);
end;

procedure TfrmAddCertificate.btnCancelClick(Sender: TObject);
begin
  // clear fields and return ModalResult as mrCancel
  edtCertificateID.Text := '';
  edtCertificateKey.Text := '';
  ModalResult := mrCancel;
end;

procedure TfrmAddCertificate.btnOKClick(Sender: TObject);
begin
  // check if all fields have been populated and
  // return ModalResult as mrOK
  if VerifyInputData() then
    ModalResult := mrOK;
end;

function TfrmAddCertificate.VerifyInputData(): boolean;
begin
  result := true;

  // if no certificate id is specified
  if (edtCertificateID.Text = '') or (edtCertificateID.Text = ' ') then
  begin                                // show error message
    DisplayMsg(ERR_INVALID_CERTIFICATE,'');
    edtCertificateID.SetFocus;         // gice focus to this control
    result := false;
    Exit;
  end;

  // if no certificate key is specified
  if (edtCertificateKey.Text = '') or (edtCertificateKey.Text = ' ') then
  begin                                // show error messaage
    DisplayMsg(ERR_INVALID_CERTIFICATE,'');
    edtCertificateKey.SetFocus;        // give focus to this control
    result := false;
    Exit;
  end;
end;

procedure TfrmAddCertificate.WMNCLButtonDown( var Message: TWMNCLButtonDown );
var
  ScreenPt: TPoint;
  ClientPt: TPoint;
begin
  ScreenPt.X := Message.XCursor;
  ScreenPt.Y := Message.YCursor;
  ClientPt := ScreenToClient( ScreenPt );
  if( ClientPt.X > Width-45 )and (ClientPt.X < Width-29) then
   begin
    WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,SERVER_CERTIFICATES);
    Message.Result := 0;
  end else
   inherited;
end;

end.
