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

unit frmuDispMemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, DBCtrls, DB, IBCustomDataSet, frmuDlgClass;

type
  TfrmDispMemo = class(TDialog)
    Memo: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

  procedure DisplayMemo (const Owner: TForm; const Field: TField; const DataSet: TIBDataSet);

implementation

{$R *.DFM}
var
  frmDispMemo: TFrmDispMemo;

procedure DisplayMemo (const Owner: TForm; const Field: TField; const DataSet: TIBDataSet);
var
  MemoStr: TStream;

begin
  if not Assigned (frmDispMemo) then
    frmDispMemo := TfrmDispMemo.Create(Owner);
  MemoStr := DataSet.CreateBlobStream (Field, bmRead);
  with frmDispMemo do begin
    Caption := Field.DisplayName;
    Memo.Lines.LoadFromStream (MemoStr);
    Show;
  end;
end;

procedure TfrmDispMemo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmDispMemo.Free;
  frmDispMemo := nil;
end;

end.
