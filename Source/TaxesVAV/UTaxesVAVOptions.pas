unit UTaxesVAVOptions;

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
    procedure OpenIni;
    procedure CloseIni;
  end;

var
  fmOptions: TfmOptions;

implementation


uses UMainUnited, UTaxesVAVCode, UTaxesVAVData;

{$R *.DFM}

procedure TfmOptions.FormCreate(Sender: TObject);
begin
  Left:=-1000;
  Top:=-1000;
end;

procedure TfmOptions.OpenIni;
begin
 try
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmOptions.CloseIni;
begin
 try
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;


end.
