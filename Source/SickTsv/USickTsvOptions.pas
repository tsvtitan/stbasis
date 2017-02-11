unit USickTsvOptions;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, IBServices, CheckLst,
  menus, ImgList, Grids, IBQuery, IBDatabase;

type
  TfmOptions = class(TForm)
    pc: TPageControl;
    procedure FormCreate(Sender: TObject);
  private
  public
    procedure LoadFromIni;
    procedure SaveToIni;
  end;

var
  fmOptions: TfmOptions;

implementation


uses UMainUnited, USickTsvCode, USickTsvData;

{$R *.DFM}

procedure TfmOptions.FormCreate(Sender: TObject);
begin
  Left:=-1000;
  Top:=-1000;
end;

procedure TfmOptions.LoadFromIni;
begin
end;

procedure TfmOptions.SaveToIni;
begin
end;

end.
