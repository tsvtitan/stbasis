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

unit frmuQryProgress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, frmuDlgClass;

type
  TdlgProgress = class(TDialog)
    txtCurrentStatement: TMemo;
    ProgressBar: TProgressBar;
    btnCancel: TButton;
    btnDetails: TButton;
    Bevel1: TBevel;
    procedure btnDetailsClick(Sender: TObject);
    procedure Cancel(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DoStep;
  end;

var
  dlgProgress: TdlgProgress;

implementation

{$R *.DFM}

var
  dlgHeight: integer;

procedure TdlgProgress.btnDetailsClick(Sender: TObject);
begin
  with dlgProgress do
  begin
    if AutoSize then
    begin
      AutoSize := false;
      Height := dlgHeight;
      btnDetails.Caption := 'Details >>';
    end
    else
    begin
      dlgHeight := Height;
      AutoSize := true;
      btnDetails.Caption := 'Details <<';
    end;
    Update;
    Application.ProcessMessages;
  end;
end;

procedure TdlgProgress.Cancel(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close
end;

procedure TdlgProgress.DoStep;
begin
  ProgressBar.Stepit;
  Application.ProcessMessages;
end;

end.
