unit tsvHtmlView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ActiveX, OleCtrls, SHDocVw, UMainForm, tsvHtmlCore, mshtml;

type
  TfmHtmlView = class(TfmMainForm)
    pnBottom: TPanel;
    btClose: TButton;
    pnView: TPanel;
    wbView: TWebBrowser;
    procedure btCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure wbViewProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
    procedure wbViewDownloadBegin(Sender: TObject);
    procedure wbViewDownloadComplete(Sender: TObject);
  private
    pbMain: THandle;
//    procedure ExtractDefaultHtml;
    function GetDefaultUrl: string;
    procedure PrepearHtmlByWinControl(WinControl: TWinControl);
    procedure PrepearHtmlByComponent(Component: TComponent);
    procedure ViewInBrowser(Html: String);
  public
    procedure PrepearHtml(Component: TComponent);
  end;

var
  fmHtmlView: TfmHtmlView;

implementation

uses UMainUnited,UCmptsTsvData,FileCtrl;

threadvar
  objHTML: IHTMLDocument2;

{$R *.DFM}

procedure TfmHtmlView.btCloseClick(Sender: TObject);
begin
  Close;
end;

{procedure TfmHtmlView.ExtractDefaultHtml;
var
  rs: TResourceStream;
  s: String;
begin
  rs:=TResourceStream.Create(HINSTANCE,'DEFAULT','HTML');
  try
    SetLength(s,rs.Size);
    Move(rs.Memory^,Pointer(s)^,rs.Size);
  finally
    rs.Free;
  end;
end;}

procedure TfmHtmlView.FormCreate(Sender: TObject);
begin
  LoadFromIni;
end;

procedure TfmHtmlView.FormDestroy(Sender: TObject);
begin
  SaveToIni;
end;

function TfmHtmlView.GetDefaultUrl: string;
begin
  Result:=ConstProtocolRes+GetDllName+'/html/default';
end;

procedure TfmHtmlView.PrepearHtml(Component: TComponent);
begin
  wbView.Navigate(GetDefaultUrl);
  if wbView.Document=nil then exit;
  if Failed(wbView.Document.QueryInterface(IID_IHTMLDocument2,objHTML)) then exit;
  try
    objHTML.Clear;
    if Component=nil then exit;
    if Component is TWinControl then begin
      PrepearHtmlByWinControl(TWinControl(Component));
    end else begin
      PrepearHtmlByComponent(Component);
    end;
    objHTML.close;
  finally
    objHTML:=nil;
  end;  
end;

procedure TfmHtmlView.PrepearHtmlByComponent(Component: TComponent);
var
  obj: ItsvHtmlElement;
begin
  if not Component.GetInterface(IID_ItsvHtmlElement,obj) then exit;
  try
    ViewInBrowser(obj.GetBeginHtml);
    ViewInBrowser(obj.GetBodyHtml);
    ViewInBrowser(obj.GetEndHtml);
  finally
    obj:=nil;
  end;  
end;

procedure TfmHtmlView.PrepearHtmlByWinControl(WinControl: TWinControl);
var
  obj: ItsvHtmlElement;
  ct: TComponent;
  i: Integer;
begin
  if not WinControl.GetInterface(IID_ItsvHtmlElement,obj) then exit;
  try
    ViewInBrowser(obj.GetBeginHtml);
    ViewInBrowser(obj.GetBodyHtml);
    for i:=0 to WinControl.ControlCount-1 do begin
      ct:=WinControl.Controls[i];
      if ct is TWinControl then PrepearHtmlByWinControl(TWinControl(ct))
      else PrepearHtmlByComponent(ct);
    end;
    ViewInBrowser(obj.GetEndHtml);
  finally
    obj:=nil;
  end;
end;

procedure TfmHtmlView.ViewInBrowser(Html: String);
var
  v: Variant;
  L,Apos: Integer;
const
  MaxLength=10;
begin
  v:=VarArrayCreate([0,0], varVariant);
  l:=Length(Html);
  if l>MaxLength then begin
    Apos:=1;
    while Apos<L do begin
      v[0]:=Copy(Html,APos,MaxLength);
      objHTML.Write(PSafeArray(TVarData(v).VArray));
      Apos:=Apos+MaxLength
    end;
  end else begin
    v[0]:=Html;
    objHTML.Write(PSafeArray(TVarData(v).VArray));
  end;
end;

procedure TfmHtmlView.wbViewProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
var
  TSPBS: TSetProgressBarStatus;
begin
  FillChar(TSPBS,SizeOf(TSPBS),0);
  if ProgressMax>0 then
    TSPBS.Progress:=Round(Progress*100/ProgressMax)
  else TSPBS.Progress:=100;
  _SetProgressBarStatus(pbMain,@TSPBS);
end;

procedure TfmHtmlView.wbViewDownloadBegin(Sender: TObject);
var
  TCPB: TCreateProgressBar;
begin
  FillChar(TCPB,SizeOf(TCPB),0);
  TCPB.Min:=0;
  TCPB.Max:=100;
  TCPB.Color:=clNavy;
  pbMain:=_CreateProgressBar(@TCPB);
end;

procedure TfmHtmlView.wbViewDownloadComplete(Sender: TObject);
begin
  _FreeProgressBar(pbMain);
end;

end.
