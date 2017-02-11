unit USplash;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, jpeg, StdCtrls;

type

  TNewBevel=class(TBevel)
  protected
   procedure Paint;override;
  end;

  TfmSplash = class(TForm)
    im: TImage;
    ImLabel: TImage;
    lbVersion: TLabel;
    lbStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure imClick(Sender: TObject);
  private
    dTop,dWidth: Integer;
    bv: TNewBevel;
    FCloseOnClick: Boolean;
  protected
    procedure Paint;override;
  public
    isTest: Boolean;
    procedure AppOnExcept(Sender: TObject; E: Exception);

    property CloseOnClick: Boolean read FCloseOnClick write FCloseOnClick;
  end;

implementation

uses UMainUnited, UMainData, UMainCode;

{$R *.DFM}

type
  TStatusLabel=class(TLabel)
  private
    function GetShortString(w: integer; str,text: string): string;
  protected
    function GetLabelText: string; override;
  end;

{ TStatusLabel }

function TStatusLabel.GetShortString(w: integer; str,text: string): string;
var
  i: Integer;
  tmps: string;
  neww: Integer;
begin
  result:=text;
  for i:=1 to Length(text) do begin
    tmps:=tmps+text[i];
    neww:=Canvas.TextWidth(tmps+str);
    if neww>=(w-Canvas.TextWidth(str)) then begin
     result:=tmps+str;
     exit;
    end;
  end;
end;

function TStatusLabel.GetLabelText: string;
var
  strx: Integer;
begin
  strx:=Canvas.TextWidth(Caption);
  if strx>=Width then begin
    Result:=GetShortString(Width,'...',Caption);
  end else Result:=Caption;
end;

procedure TfmSplash.FormCreate(Sender: TObject);
var
  lb: TStatusLabel;
begin
  dTop:=5;
  dWidth:=5;
  
  lb:=TStatusLabel.Create(Self);
  lb.Parent:=lbStatus.Parent;
  lb.AutoSize:=lbStatus.AutoSize;
  lb.Caption:=lbStatus.Caption;
  lb.Font.Assign(lbStatus.Font);
  lb.Transparent:=lbStatus.Transparent;
  lb.SetBounds(lbStatus.Left,lbStatus.Top,lbStatus.Width,lbStatus.Height);
  lbStatus.Free;
  lb.Name:='lbStatus';
  lbStatus:=lb;  

  Application.OnException:=AppOnExcept;
  bv:=TNewBevel.Create(Self);
  bv.Parent:=self;
  bv.Align:=alClient;
  bv.OnMouseDown:=lbMainMouseDown;
 // Brush.Bitmap:=im.Picture.Bitmap;
  lbVersion.Caption:=GetApplicationExeVersion;
  isTest:=false;
end;

procedure TfmSplash.Paint;
begin
  inherited;
  with Canvas do begin
   Brush.Style:=bsClear;
   Pen.color:=clBlack;
   Rectangle(GetClientRect);
  end;

end;

procedure TNewBevel.Paint;
begin
  with Canvas do begin
   Brush.Style:=bsClear;
   Pen.color:=clBlack;
   Rectangle(GetClientRect);
  end;
end;

procedure TfmSplash.AppOnExcept(Sender: TObject; E: Exception);
begin
   AddErrorToJournal_(Pchar(E.Message),E.ClassType);
end;

procedure TfmSplash.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
    if isTest then Close;
end;

procedure TfmSplash.lbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if isTest then Close;
end;

procedure TfmSplash.FormResize(Sender: TObject);
begin
  lbStatus.SetBounds(lbStatus.Left,ClientHeight-lbStatus.Height-dTop,ClientWidth-DWidth,lbStatus.Height);
end;

procedure TfmSplash.imClick(Sender: TObject);
begin
  if CloseOnClick then
    Close;
end;

end.
