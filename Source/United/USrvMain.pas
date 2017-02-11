unit USrvMain;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, IBQuery, db, IBServices, IBDatabase, UMainUnited,
  IBCustomDataSet, UMainForm;

type
  TfmSrvMain = class(TfmMainForm,IAdditionalSrvForm)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FhInterface: THandle;
  protected
    procedure LoadFromIni; override;
    procedure SaveToIni; override;
  public
    procedure InitMdiChildParams(hInterface: THandle; Param: PParamServiceInterface);dynamic;
    procedure SetInterfaceHandle(Value: THandle);
  end;

var
  fmSrvMain: TfmSrvMain;

implementation

{$R *.DFM}

procedure TfmSrvMain.LoadFromIni;
begin
  try
    inherited;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmSrvMain.SaveToIni;
begin
  try
     inherited;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmSrvMain.InitMdiChildParams(hInterface: THandle; Param: PParamServiceInterface);
begin
  _OnVisibleInterface(hInterface,true);
  FhInterface:=hInterface;
  FormStyle:=fsMDIChild;
  if WindowState=wsMinimized then
    WindowState:=wsNormal;
  BringToFront;
  Show;
end;

procedure TfmSrvMain.FormDestroy(Sender: TObject);
begin
 try
  inherited;
  _OnVisibleInterface(FhInterface,false);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmSrvMain.SetInterfaceHandle(Value: THandle);
begin
  FhInterface:=Value;
end;

procedure TfmSrvMain.FormCreate(Sender: TObject);
begin
  try
    inherited;
    
  finally

  end;
end;

end.
