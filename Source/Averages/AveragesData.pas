unit AveragesData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, IBDatabase;

type
  TdmAverages = class(TDataModule)
    ilAverages: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmAverages: TdmAverages;
  dbSTBasis: TIBDatabase;
  trDefault: TIBTransaction;

  ListOptionHandles: TList;
  ListToolBarHandles: TList;
  ListInterfaceHandles: TList;
  ListMenuHandles: TList;

  hMenuRBooks: THandle;

  hMenuAverageSickList: THandle;
  hInterfaceAverageSickList: THandle;
  hToolButtonAverageSickList: THandle;

  hMenuAverageLeaveList: THandle;
  hInterfaceAverageLeaveList: THandle;
  hToolButtonAverageLeaveList: THandle;

implementation

{$R *.DFM}

end.
