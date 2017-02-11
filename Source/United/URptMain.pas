unit URptMain;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, IBQuery, db, IBServices, IBDatabase, UMainUnited,
  IBCustomDataSet, UMainForm;

type
  TfmRptMain = class(TfmMainForm,IAdditionalRptForm)
    pnBut: TPanel;
    Panel2: TPanel;
    bibGen: TButton;
    bibClose: TButton;
    bibBreak: TButton;
    cbInString: TCheckBox;
    IBTran: TIBTransaction;
    Mainqr: TIBQuery;
    bibClear: TButton;
    procedure bibGenClick(Sender: TObject);
    procedure bibCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibBreakClick(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FhInterface: THandle;
  protected
    LastOrderStr: String;
    procedure LoadFromIni; override;
    procedure SaveToIni; override;
    procedure GenerateReport;dynamic;
  public
    procedure InitMdiChildParams(hInterface: THandle; Param: PParamReportInterface);dynamic;
    procedure SetInterfaceHandle(Value: THandle);
  end;

var
  fmRptMain: TfmRptMain;

implementation

uses URptThread;

{$R *.DFM}

procedure TfmRptMain.LoadFromIni;
begin
  try
    inherited;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmRptMain.SaveToIni;
begin
  try
    inherited;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmRptMain.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmRptMain.InitMdiChildParams(hInterface: THandle; Param: PParamReportInterface);
begin
  _OnVisibleInterface(hInterface,true);
  FhInterface:=hInterface;
  FormStyle:=fsMDIChild;
  if WindowState=wsMinimized then
   WindowState:=wsNormal;
  BringToFront;
  Show;
end;

procedure TfmRptMain.FormDestroy(Sender: TObject);
begin
 try
  inherited; 
  _OnVisibleInterface(FhInterface,false);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptMain.GenerateReport;
begin
end;

procedure TfmRptMain.bibBreakClick(Sender: TObject);
begin
  bibBreak.Enabled:=false;
  bibBreak.Default:=false;
  bibGen.Enabled:=true;
  bibGen.SetFocus;
end;

procedure TfmRptMain.bibGenClick(Sender: TObject);
begin
  bibBreak.Enabled:=true;
  bibBreak.SetFocus;
  bibGen.Enabled:=false;
  GenerateReport;
end;


procedure TfmRptMain.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmRptMain.SetInterfaceHandle(Value: THandle);
begin
  FhInterface:=Value;
end;


procedure TfmRptMain.FormCreate(Sender: TObject);
begin
  try
    inherited;
    
  finally

  end;
end;

end.
