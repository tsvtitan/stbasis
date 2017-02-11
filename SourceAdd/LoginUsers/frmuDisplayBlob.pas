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

unit frmuDisplayBlob;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, dbTables, IBCustomDataset, DB, frmuDlgClass;

type
  TfrmDisplayBlob = class(TDialog)
    Bevel1: TBevel;
    Image: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure DisplayBlob (const Owner: TComponent; const Field: TField; const DataSet: TIBDataSet);

 implementation

{$R *.DFM}

uses
  frmuMessage, jpeg;

var
  frmDispBlob: TFrmDisplayBlob;

procedure DisplayBlob (const Owner: TComponent; const Field: TField; const DataSet: TIBDataSet);

var
  jpg: TBitmap;
  BlobStr: TStream;

begin
  if not Assigned (frmDispBlob) then
    frmDispBlob := TfrmDisplayBlob.Create(Owner);

  BlobStr := DataSet.CreateBlobStream (Field, bmRead);
  with frmDispBlob do begin
    Caption := Field.DisplayName;
    try
      jpg := TBitmap.Create;
      jpg.LoadFromStream (BlobStr);
      Image.Picture.Assign (jpg);
      Show;
    except on E: Exception do
      DisplayMsg ( ERR_BAD_FORMAT, E.Message);
    end;
  end;
end;

procedure TfrmDisplayBlob.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmDispBlob.Free;
  frmDispBlob := nil;
end;

end.
