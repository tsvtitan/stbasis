unit UCmptsTsvDM;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList;

type
  Tdm = class(TDataModule)
    ILStandart: TImageList;
    ILTsv: TImageList;
    ILFastReport: TImageList;
    ILRx: TImageList;
    ILStbasis: TImageList;
    ILInterbase: TImageList;
    ilTsvHtml: TImageList;
    ILIndy: TImageList;
    ILAbbrevia: TImageList;
    ILAnyDac: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{$R *.DFM}

end.
