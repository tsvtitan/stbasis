unit USysTsvForToolBars;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, IBServices, CheckLst,
  menus, ImgList, Grids, IBQuery, IBDatabase;

type
  TfmForToolBars = class(TForm)
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  fmForToolBars: TfmForToolBars;

implementation


uses UMainUnited;

{$R *.DFM}

procedure TfmForToolBars.FormCreate(Sender: TObject);
begin
  Left:=-1000;
  Top:=-1000;
end;


end.
