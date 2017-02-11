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

{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

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
