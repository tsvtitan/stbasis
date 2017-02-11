unit tsvHtmlControls;

interface

uses Windows, Classes, Graphics, forms, stdctrls, tsvHtmlCore, DsgnIntf;

type

  TtsvHtmlLabel=class(TLabel,ItsvHtmlElement)
  protected
    // ItsvHtmlElement
    function GetBeginHtml: PChar; stdcall;
    function GetBodyHtml: PChar; stdcall;
    function GetEndHtml: PChar; stdcall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


  TtsvHtmlPage=class(TScrollBox,ItsvHtmlElement)
  protected
    // ItsvHtmlElement
    function GetBeginHtml: PChar; stdcall;
    function GetBodyHtml: PChar; stdcall;
    function GetEndHtml: PChar; stdcall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TtsvHtmlFrame=class(TScrollBox,ItsvHtmlElement)
  protected
    // ItsvHtmlElement
    function GetBeginHtml: PChar; stdcall;
    function GetBodyHtml: PChar; stdcall;
    function GetEndHtml: PChar; stdcall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


  THtmlElementEditor = class(TDefaultEditor)
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;


implementation

uses SysUtils, tsvHtmlView;

{ TtsvHtmlLabel }

constructor TtsvHtmlLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TtsvHtmlLabel.Destroy;
begin
  inherited;
end;

function FontToCss(Font: TFont): string;
begin
  Result := Format(';font-Size:%d;color:#%d;font-weight:', [Font.Size, Font.Color]);
  if fsBold in Font.Style then
    Result := Result + 'bold;'
  else
    Result := Result + 'normal;';
  Result := Result + 'font-family:' + Font.Name;
end;

function TtsvHtmlLabel.GetBeginHtml: PChar; stdcall;
var
  st: string;
begin
  st := Format('<LABEL style="position:absolute;Left:%d;Top:%d;Height:%d;Width:%d',
    [Left, Top, Height, Width]);
  st := st + FontToCss(Font) + '"';
  st := st + ' TITLE="' + Hint + '"';
  st := st + ' NAME=' + Name;
  st := st + '>';
  st := st + Caption + '</LABEL>';
  Result:=PChar(st);
end;

function TtsvHtmlLabel.GetBodyHtml: PChar; stdcall;
begin
  Result:='';
end;

function TtsvHtmlLabel.GetEndHtml: PChar; stdcall;
begin
  Result:='';
end;

{ TtsvHtmlPage }

constructor TtsvHtmlPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width:=200;
  Height:=150;
  ParentColor:=false;
  Color:=clWindow;
end;

destructor TtsvHtmlPage.Destroy;
begin
  inherited;
end;

function TtsvHtmlPage.GetBeginHtml: PChar; stdcall;
begin
  Result:='<HTML>';
end;

function TtsvHtmlPage.GetBodyHtml: PChar; stdcall;
begin
  Result:='1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '1234567890'+#13+
          '';
end;

function TtsvHtmlPage.GetEndHtml: PChar; stdcall;
begin
  Result:='</HTML>';
end;


{ TtsvHtmlFrame }

constructor TtsvHtmlFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width:=100;
  Height:=60;
  ParentColor:=false;
  Color:=clWindow;
  ParentCtl3D:=false;
  Ctl3D:=false;
end;

destructor TtsvHtmlFrame.Destroy;
begin
  inherited;
end;

function TtsvHtmlFrame.GetBeginHtml: PChar; stdcall;
begin
  Result:='<FRAME>';
end;

function TtsvHtmlFrame.GetBodyHtml: PChar; stdcall;
begin
  Result:='';
end;

function TtsvHtmlFrame.GetEndHtml: PChar; stdcall;
begin
  Result:='</FRAME>';
end;


{ THtmlElementEditor }

procedure THtmlElementEditor.Edit;
var
  fm: TfmHtmlView;
begin
  fm:=TfmHtmlView.Create(nil);
  try
    fm.PrepearHtml(Component);
    fm.ShowModal;
  finally
    fm.Free;
  end;  
end;

procedure THtmlElementEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: Edit;
  end;
end;

function THtmlElementEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Просмотр Html';
  else Result := '';
  end;
end;

function THtmlElementEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;



end.
