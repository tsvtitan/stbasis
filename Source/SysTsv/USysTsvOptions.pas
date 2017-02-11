unit USysTsvOptions;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, IBServices, CheckLst,
  menus, ImgList, Grids, IBQuery, IBDatabase;

type

  TfmOptions = class(TForm)
    ilShortCut: TImageList;
    ilOptions: TImageList;
    pc: TPageControl;
  private
  public
    procedure LoadFromIni(OptionHandle: THandle);
    procedure SaveToIni(OptionHandle: THandle);
  end;

var
  fmOptions: TfmOptions;

implementation


uses UMainUnited, USysTsvCode, USysTsvData;

{$R *.DFM}

procedure TfmOptions.LoadFromIni(OptionHandle: THandle);
begin
end;

procedure TfmOptions.SaveToIni(OptionHandle: THandle);
begin
end;

end.
