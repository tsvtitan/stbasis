{

******************************************************************
******************************************************************

  DEMO REQUIRES  3rd PARTY COMPONENT !!!

******************************************************************
******************************************************************

}

{***************************************************************
 *
 * Project  : LiteBrowser
 * Unit Name: LiteBrows
 * Purpose  :
 * Version  : 1.0
 * Date  : Fri 13 Apr 2001  -  22:42:38
 * Author  :
 * History  : Tested by Allen O'Neill <allen_oneill@hotmail.com>
 *
 ****************************************************************}




{
This is a simple browser demo using the ThtmlLite HTML display component and
the HTTP component.  In order to compile this demo, you will need
to download and install THTMLLite from
http://www.pbear.com

This is a very basic demo designed to illustrate downloading and displaying an
HTML document and its images.  It demostrates the use of ThtmlLite's
OnImageRequest event and InsertImage method to handle the image downloading.
To keep things simple, many browser nicities (requirements) have been omitted,
such as:

  Form submission
  Non HTML downloads (zip files, etc)
  Disk Caching (although images are cached)
  Proxies
  Back button and History list.
  Frames

For examples that cover the above, see the two demos programs for the
TFrameBrowser component available at www.pbear.com, filename brzdemoXXX.zip.
}

unit LiteBrows;

interface

uses
  windows, messages, SysUtils, Classes, graphics, controls, forms, dialogs,
  gauges, HTMLLite, stdctrls, buttons, extctrls, UrlSubs,
  IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, comctrls, imglist, toolwin;

const
  wm_LoadURL = wm_User+124;
  wm_DoImages = wm_User+127;

type
  THTTPForm = class(TForm)
  Viewer: ThtmlLite;
  IdHTTP1: TIdHTTP;
  IdAntiFreeze1: TIdAntiFreeze;
  ProgressBar1: TProgressBar;
  StatusBar1: TStatusBar;
  CoolBar1: TCoolBar;
  Panel1: TPanel;
  Animate1: TAnimate;
  ToolBar1: TToolBar;
  ToolButton1: TToolButton;
  ToolButton2: TToolButton;
  ImageList1: TImageList;
  ToolButton3: TToolButton;
  AbortButton: TToolButton;
  Panel2: TPanel;
  ToolBar2: TToolBar;
  GoButton: TToolButton;
  URLComboBox: TComboBox;
  procedure GoButton1Click(Sender: TObject);
  procedure ViewerImageRequest(Sender: TObject; const SRC: String;
  var Stream: TMemoryStream);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
  procedure URLComboBoxKeyPress(Sender: TObject; var Key: Char);
  procedure ViewerHotSpotClick(Sender: TObject; const SRC: String;
  var Handled: Boolean);
  procedure AbortButton1Click(Sender: TObject);
  procedure ViewerHotSpotCovered(Sender: TObject; const SRC: String);
  procedure IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
  procedure IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
  procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
  procedure Panel2Resize(Sender: TObject);
  procedure ToolButton1Click(Sender: TObject);
  procedure ToolButton2Click(Sender: TObject);
  private
  { Private declarations }
  UrlBase: string;
  NewLoadUrl: string;
  ImageList: TStringList;  {a list of images to load}
  Content: TMemoryStream;
  PositionAtStart: Integer;
  procedure LoadViewer(const Url: string);
  procedure WMDoImages(var Message: TMessage); message WM_DoImages;
  procedure WMLoadURL(var Message: TMessage); message WM_LoadURL;
  procedure CheckEnableControls;
  procedure DisableControls;
  procedure EnableControls;
  function GetStream(const Url: string): TMemoryStream;
  public
  { Public declarations }
  end;

var
  HTTPForm: THTTPForm;

implementation

uses LiteUn2;  {for WaitStream definition}

{$R *.DFM}

procedure THTTPForm.FormCreate(Sender: TObject);
begin
  if Screen.Width <= 800 then  {make window fit appropriately}
  begin
  Left := Left div 2;
  Width := (Screen.Width * 9) div 10;
  Height := (Screen.Height * 7) div 8;
  end
  else
  begin
  Width := 850;
  Height := 600;
  end;

  ProgressBar1.Parent := StatusBar1;
  ProgressBar1.Top := 2;
  ProgressBar1.Left := 1;
  ImageList := TStringList.Create;
  // HttpCli.RcvdStream := TMemoryStream.Create;
  Content := TMemoryStream.Create;
end;

procedure THTTPForm.FormDestroy(Sender: TObject);
begin
  ImageList.Free;
  Content.Free;
  // HttpCli.RcvdStream.Free;
end;

function THTTPForm.GetStream(Const Url: string): TMemoryStream;
{download an HTML document or image.  Return it in stream form}
begin
  Content.Clear;
  try
  IdHTTP1.Get(URL, Content);
  except
  Content.Clear;
  end;
  {HttpCli.Url := Url;
  HttpCli.Get;}
  Result := Content;
end;

procedure THTTPForm.GoButton1Click(Sender: TObject);
{initiate loading of a main document}
var
  Url: string;
begin
  Url := Normalize(URLCombobox.Text);  {put in standard form}
  URLBase := GetBase(URL);  {save the base directory}
  DisableControls;
  ProgressBar1.Max := 1;
  // Status2.Caption := '';
  try
  Animate1.Active := true;
  LoadViewer(URL);
  if URLComboBox.Items.IndexOf(URL) = -1 then URLComboBox.Items.Add(URL);
  finally
  CheckEnableControls;
  Viewer.SetFocus;
  end;
end;

procedure THTTPForm.LoadViewer(const Url: string);
var
  Url1, Dest: string;
  I: integer;
  Stream: TMemoryStream;
begin
  DisableControls;
  Url1 := URL;
  I := Pos('#', Url1);  {see if Url has local destination part}
  if I >= 1 then
  begin
  Dest := System.Copy(Url1, I, Length(Url1)-I+1);  {local destination}
  Url1 := System.Copy(Url1, 1, I-1);  {document Url}
  end
  else
  Dest := '';  {no local destination}
  Stream := GetStream(Url1);  {do the download}
  {while Viewer is being loaded, a series of OnImageRequest events will occur.
  see ViewerImageRequest below}
  Viewer.LoadFromStream(Stream);
  if Dest <> '' then Viewer.PositionTo(Dest);
end;

procedure THTTPForm.ViewerImageRequest(Sender: TObject; const SRC: String;
  var Stream: TMemoryStream);
{the OnImageRequest handler}
begin
Stream := WaitStream;  {wait indicator, means image will be inserted later}
ImageList.Add(SRC);  {add to list of images to download}
if ImageList.Count = 1 then
  PostMessage(Handle, wm_DoImages, 0, 0);
end;

procedure THTTPForm.WMDoImages(var Message: TMessage);
{loop through the ImageList to download and insert the images}
var
  S, Src: string;
begin
if ImageList.Count > 0 then
  begin
  Src := ImageList[0];
  ImageList.Delete(0);
  if not IsFullUrl(Src) then
  S := Combine(UrlBase, Src)
  else S := Src;
  Viewer.InsertImage(Src, GetStream(S));
  if ImageList.Count > 0 then
  PostMessage(Handle, wm_DoImages, 0, 0) {more to do}
  else CheckEnableControls;
  end;
end;

procedure THTTPForm.URLComboBoxKeyPress(Sender: TObject; var Key: Char);
{trap CR in combobox}
begin
if (Key = #13) and (URLComboBox.Text <> '') then
  Begin
  Key := #0;
  GoButton.Click;
  end;
end;

procedure THTTPForm.ViewerHotSpotClick(Sender: TObject; const Src: String;
  var Handled: Boolean);
{the OnHotspotClick event handler, a link has been clicked}
begin
if (Length(Src) > 0) and (Src[1] = '#') then
  begin  {it's a local jump}
  Handled := False;
  Exit;
  end;

if not IsFullUrl(Src) then
  NewLoadUrl := Combine(UrlBase, Src)
else NewLoadUrl := Src;

if GetProtocol(NewLoadUrl) = 'http' then
  begin
  {download can't be done here.  Post a message to do it later at WMLoadUrl}
  PostMessage(handle, wm_LoadUrl, 0, 0);
  Handled := True;
  end
else Handled := False;
end;

procedure THTTPForm.WMLoadURL(var Message: TMessage);
begin
  UrlCombobox.Text := NewLoadUrl;
  GoButton.Click;
end;

procedure THTTPForm.AbortButton1Click(Sender: TObject);
begin
  try
  IdHTTP1.Disconnect;
  except
  end;
  // HttpCli.Abort;
  ImageList.Clear;
  CheckEnableControls;
end;

procedure THTTPForm.CheckEnableControls;
begin
  if ImageList.Count = 0 then begin
  EnableControls;
  Animate1.Active := false;
  StatusBar1.Panels[1].Text := 'Done.';
  end;
end;

procedure THTTPForm.DisableControls;
begin
  URLCombobox.Enabled:=false;
  AbortButton.Enabled:=true;
end;

procedure THTTPForm.EnableControls;
begin
  URLCombobox.Enabled:=true;
  AbortButton.Enabled:=false;
  ProgressBar1.Position := 0;
end;

procedure THTTPForm.ViewerHotSpotCovered(Sender: TObject;
  const SRC: String);
{mouse moved over or away from a link.  Change the status line}
begin
  // Status3.Caption := SRC;
  StatusBar1.Panels[1].Text := Src;
end;

procedure THTTPForm.IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
  ProgressBar1.Max := ProgressBar1.Max + AWorkCountMax;
  // ProgressBar1.Position := 0;
  PositionAtStart := ProgressBar1.Position;
end;

procedure THTTPForm.IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  // ProgressBar1.Position := 0;
end;

procedure THTTPForm.IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
  ProgressBar1.Position := PositionatStart + AWorkCount;
  StatusBar1.Panels[1].Text := Format('Downloaded %dKB of %dKB', [ProgressBar1.Position div 1024, ProgressBar1.Max div 1024]);
end;

procedure THTTPForm.Panel2Resize(Sender: TObject);
begin
  URLComboBox.Width := Panel2.Width - ToolBar2.Width - 1;
end;

procedure THTTPForm.ToolButton1Click(Sender: TObject);
begin
  if URLComboBox.Items.IndexOf(URLComboBox.Text) - 1 < 0 then exit;

  AbortButton.Click;

  URLComboBox.ItemIndex := URLComboBox.Items.IndexOf(URLComboBox.Text) - 1;
  GoButton.Click;
end;

procedure THTTPForm.ToolButton2Click(Sender: TObject);
begin
  if URLComboBox.Items.IndexOf(URLComboBox.Text) = URLComboBox.Items.Count - 1 then exit;

  AbortButton.Click;

  URLComboBox.ItemIndex := URLComboBox.Items.IndexOf(URLComboBox.Text) + 1;
  GoButton.Click;
end;

end.
{Version 8.02}
unit URLSubs;

interface

uses
  WinTypes, WinProcs, messages, SysUtils, liteun2;

function GetBase(const URL: string): string;
{Given an URL, get the base directory}

function Combine(Base, APath: string): string;
{combine a base and a path taking into account that overlap might exist}
{needs work for cases where directories might overlap}

function Normalize(const URL: string): string;
{lowercase, trim, and make sure a '/' terminates a hostname, adds http://}

function IsFullURL(Const URL: string): boolean;
{set if contains http://}

function GetProtocol(const URL: string): string;
{return the http, mailto, etc in lower case}

function GetURLExtension(const URL: string): string;
{returns extension without the '.', mixed case}

function GetURLFilenameAndExt(const URL: string): string;
{returns mixed case after last /}

function DosToHTML(FName: string): string;
{convert an Dos style filename to one for HTML.  Does not add the file:///}

procedure ParseURL(const url : String; var Proto, User, Pass, Host, Port, Path : String);
{François PIETTE's URL parsing procedure}

implementation

{----------------GetBase}
function GetBase(const URL: string): string;
{Given an URL, get the base directory}
var
  I, J, LastSlash: integer;
  S: string;
begin
S := Trim(URL);
J := Pos('?', S);  
if J > 0 then
  S := Copy(S, 1, J-1);  {remove Query}
J := Pos('//', S);
LastSlash := 0;
for I := J+2 to Length(S) do
  if S[I] = '/' then LastSlash := I;
if LastSlash = 0 then
  Result := S+'/'
else Result := Copy(S, 1, LastSlash);
end;

{----------------Combine}
function Combine(Base, APath: string): string;
{combine a base and a path taking into account that overlap might exist}
{needs work for cases where directories might overlap}
var
  I, J, K: integer;

begin
J := Pos('://', Base);
if J > 0 then
  J := Pos('/', Copy(Base, J+3, Length(Base)-(J+2)))+J+2  {third slash}
else
  J := Pos('/', Base);
if J = 0 then
  begin
  Base := Base+'/';  {needs a slash}
  J := Length(Base);
  end
else if Base[Length(Base)] <> '/' then
  Base := Base + '/';

APath := Trim(APath);
if (APath <> '') and (APath[1] = '/') then
  {remove path from base and use host only}
  Result := Copy(Base, 1, J) + Copy(APath, 2, Length(APath)-1)
else Result := Base+APath;

{remove any '..\'s to simply and standardize for cacheing}
I := Pos('/../', Result);
while I > 0 do
  begin
  if I > J then
  begin
  K := I;
  while (I > 1) and (Result[I-1] <> '/') do
  Dec(I);
  if I <= 1 then Break;
  Delete(Result, I, K-I+4);  {remove canceled directory and '/../'}
  end
  else
  Delete(Result, I+1, 3);  {remove '../' after host name}
  I := Pos('/../', Result);
  end;
{remove any './'s}
I := Pos('/./', Result);
while I > 0 do
  begin
  Delete(Result, I+1, 2);
  I := Pos('/./', Result);
  end;
end;

function Normalize(const URL: string): string;
{trim, and make sure a '/' terminates a hostname and http:// is present.
 In other words, if there is only 2 /'s, put one on the end}
var
  I, J, LastSlash: integer;
begin
Result := Trim(URL);
if Pos('://', Result) = 0 then
  Result := 'http://'+Result;  {add http protocol as a default}
J := Pos('/./', Result);
while J > 0 do
  begin
  Delete(Result, J+1, 2);  {remove './'s}
  J := Pos('/./', Result);
  end;
J := Pos('//', Result);
LastSlash := 0;
for I := J+2 to Length(Result) do
  if Result[I] = '/' then LastSlash := I;
if LastSlash = 0 then
  Result := Result+'/'
end;

function IsFullURL(Const URL: string): boolean;
begin
Result := (Pos('://', URL) <> 0) or (Pos('mailto:', Lowercase(URL)) <> 0);  
end;

function GetProtocol(const URL: string): string;
var
  User, Pass, Port, Host, Path: String;
  S: string;
  I: integer;
begin
I := Pos('?', URL);
if I > 0 then S := Copy(URL, 1, I-1)
  else S := URL;
ParseURL(S, Result, user, pass, Host, port, Path);
Result := Lowercase(Result);
end;

function GetURLExtension(const URL: string): string;
var
  I, N: integer;
begin
Result := '';
I := Pos('?', URL);
if I > 0 then N := I-1
  else N := Length(URL);
for I := N downto IntMax(1, N-5) do
  if URL[I] = '.' then
  begin
  Result := Copy(URL, I+1, 255);
  Break;
  end;
end;

function GetURLFilenameAndExt(const URL: string): string;
var
  I: integer;
begin
Result := URL;
for I := Length(URL) downto 1 do
  if URL[I] = '/' then
  begin
  Result := Copy(URL, I+1, 255);
  Break;
  end;
end;

{ Find the count'th occurence of the s string in the t string.  }
{ If count < 0 then look from the back  }
{Thanx to François PIETTE}
function Posn(const s , t : String; Count : Integer) : Integer;
var
  i, h, Last : Integer;
  u  : String;
begin
  u := t;
  if Count > 0 then begin
  Result := Length(t);
  for i := 1 to Count do begin
  h := Pos(s, u);
  if h > 0 then
  u := Copy(u, h + 1, Length(u))
  else begin
  u := '';
  Inc(Result);
  end;
  end;
  Result := Result - Length(u);
  end
  else if Count < 0 then begin
  Last := 0;
  for i := Length(t) downto 1 do begin
  u := Copy(t, i, Length(t));
  h := Pos(s, u);
  if (h <> 0) and ((h + i) <> Last) then begin
  Last := h + i - 1;
  Inc(count);
  if Count = 0 then
  break;
  end;
  end;
  if Count = 0 then
  Result := Last
  else
  Result := 0;
  end
  else
  Result := 0;
end;

{ Syntax of an URL: protocol://[user[:password]@]server[:port]/path  }
{Thanx to François PIETTE}
procedure ParseURL(
  const url : String;
  var Proto, User, Pass, Host, Port, Path : String);
var
  p, q : Integer;
  s  : String;
begin
  proto := '';
  User  := '';
  Pass  := '';
  Host  := '';
  Port  := '';
  Path  := '';

  if Length(url) < 1 then
  Exit;

  p := pos('://',url);
  if p = 0 then begin
  if (url[1] = '/') then begin
  { Relative path without protocol specified }
  proto := 'http';
  p  := 1;
  if (Length(url) > 1) and (url[2] <> '/') then begin
  { Relative path }
  Path := Copy(url, 1, Length(url));
  Exit;
  end;
  end
  else if lowercase(Copy(url, 1, 5)) = 'http:' then begin
  proto := 'http';
  p  := 6;
  if (Length(url) > 6) and (url[7] <> '/') then begin
  { Relative path }
  Path := Copy(url, 6, Length(url));
  Exit;
  end;
  end
  else if lowercase(Copy(url, 1, 7)) = 'mailto:' then begin
  proto := 'mailto';
  p := pos(':', url);
  end;
  end
  else begin
  proto := Copy(url, 1, p - 1);
  inc(p, 2);
  end;
  s := Copy(url, p + 1, Length(url));

  p := pos('/', s);
  if p = 0 then
  p := Length(s) + 1;
  Path := Copy(s, p, Length(s));
  s  := Copy(s, 1, p-1);

  p := Posn(':', s, -1);
  if p > Length(s) then
  p := 0;
  q := Posn('@', s, -1);
  if q > Length(s) then
  q := 0;
  if (p = 0) and (q = 0) then begin  { no user, password or port }
  Host := s;
  Exit;
  end
  else if q < p then begin  { a port given }
  Port := Copy(s, p + 1, Length(s));
  Host := Copy(s, q + 1, p - q - 1);
  if q = 0 then
  Exit; { no user, password }
  s := Copy(s, 1, q - 1);
  end
  else begin
  Host := Copy(s, q + 1, Length(s));
  s := Copy(s, 1, q - 1);
  end;
  p := pos(':', s);
  if p = 0 then
  User := s
  else begin
  User := Copy(s, 1, p - 1);
  Pass := Copy(s, p + 1, Length(s));
  end;
end;

function DosToHTML(FName: string): string;
{convert an Dos style filename to one for HTML.  Does not add the file:///}
var
  Colon: integer;

  procedure Replace(Old, New: char);
  var
  I: integer;
  begin
  I := Pos(Old, FName);
  while I > 0 do
  begin
  FName[I] := New;
  I := Pos(Old, FName);
  end;
  end;

begin
Colon := Pos('://', FName);  {css}
Replace(':', '|');
Replace('\', '/');
if Colon > 0 then
  FName[Colon] := ':';  {return it to a colon} {css}
Result := FName;
end;

end.
