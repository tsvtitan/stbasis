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

unit frmuFormClass;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TIBCForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IBCForm: TIBCForm;

implementation

{$R *.DFM}
type
  TFontClass = class (TControl);  { needed to get at font property to scale }

const
  ScreenWidth: LongInt = 1600;
  ScreenHeight: LongInt = 1200;

procedure TIBCForm.FormCreate(Sender: TObject);
var
  i: integer;
  OldHeight,
  OldWidth: LongInt;

begin
  { Scale the size of the form }
{
  if Screen.Width <> ScreenWidth then
  begin
    OldWidth := Width;
    OldHeight := Height;

    Height := LongInt(Height) * LongInt(Screen.Height) div ScreenHeight;
    Width := LongInt(Width) * LongInt(Screen.Width) div ScreenWidth;
    ScaleBy (ScreenWidth, Screen.Width);
    { Scale all the fonts 

    for i := ControlCount - 1 downto 0 do
      TFontClass(Controls[i]).Font.Size :=
        (Width div OldWidth) * TFontClass(Controls[i]).Font.Size;

  end;
}
end;

end.
