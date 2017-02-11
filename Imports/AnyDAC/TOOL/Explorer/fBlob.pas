{ --------------------------------------------------------------------------- }
{ AnyDAC Explorer Blob viewer form                                            }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fBlob;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ExtCtrls, Menus, jpeg, OleCtrls, SHDocVw,
  daADGUIxFormsControls;

type
  TfrmBlob = class(TForm)
    imgData: TImage;
    mmData: TMemo;
    mmBinary: TMemo;
    PopupMenu1: TPopupMenu;
    ForceText1: TMenuItem;
    ForceBinary1: TMenuItem;
    ForceGraphic1: TMenuItem;
    N1: TMenuItem;
    StayOnTop1: TMenuItem;
    Default1: TMenuItem;
    DataSource1: TDataSource;
    pnlMain: TADGUIxFormsPanel;
    wbHTML: TWebBrowser;
    ForceHTML1: TMenuItem;
    procedure ForceClick(Sender: TObject);
    procedure StayOnTop1Click(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FForceText,
    FForceBlob,
    FForceGraphic,
    FForceHTML: Boolean;
    FField: TField;
  public
    { Public declarations }
    procedure FocusField(AField: TField);
  end;

var
  frmBlob: TfrmBlob;

implementation

{$R *.dfm}

uses
  ActiveX;

{-----------------------------------------------------------------------------}
{ TfrmBlob                                                                    }
{-----------------------------------------------------------------------------}
procedure TfrmBlob.FocusField(AField: TField);
var
  s1, s2: String;
  oDs: TDataSet;
  oPSI: IPersistStreamInit;

  procedure ShowHTML(const AStr: String);
  begin
    TWinControl(wbHTML).Visible := True;
    if not Visible then
      Show;
    Application.ProcessMessages;
    wbHTML.Navigate('about:blank');
    repeat
      Application.ProcessMessages;
      Sleep(0);
    until wbHTML.ReadyState = READYSTATE_COMPLETE;
    if (wbHTML.Document.QueryInterface(IPersistStreamInit, oPSI) = S_OK) and
       (oPSI.InitNew = S_OK) then
      oPSI.Load(
        TStreamAdapter.Create(
          TStringStream.Create(AField.AsString),
          soOwned
        )
      );
  end;

begin
  FField := AField;
  imgData.Visible := False;
  imgData.Picture.Bitmap := nil;
  mmData.Visible := False;
  mmData.Text := '';
  mmBinary.Visible := False;
  mmBinary.Text := '';
  TWinControl(wbHTML).Visible := False;
  if AField <> nil then
    if FForceText or
      (AField.DataType in [ftString, ftSmallint, ftInteger, ftWord,
        ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate, ftTime, ftDateTime,
        ftAutoInc, ftMemo, ftFmtMemo, ftFixedChar, ftWideString, ftLargeint,
        ftOraClob, ftGuid
{$IFDEF AnyDAC_D6}
        , ftTimeStamp, ftFMTBcd
{$ENDIF}
        ]) then begin
      s1 := AField.AsString;
      if FForceText or (UpperCase(Copy(s1, 1, 6)) <> '<HTML>') then begin
        mmData.Text := s1;
        mmData.Visible := True;
      end
      else
        ShowHTML(s1);
    end
    else if FForceBlob or
      (AField.DataType in [ftBytes, ftVarBytes, ftBlob, ftOraBlob]) then begin
      s1 := AField.AsString;
      if FForceBlob or (UpperCase(Copy(s1, 1, 6)) <> '<HTML>') then begin
        SetLength(s2, Length(s1) * 2);
        BinToHex(PChar(s1), PChar(s2), Length(s1));
        mmBinary.Text := s2;
        mmBinary.Visible := True;
      end
      else
        ShowHTML(s1);
    end
    else if FForceGraphic or
      (AField.DataType in [ftGraphic]) then begin
      imgData.Picture.Assign(TBlobField(AField));
      imgData.Visible := True;
    end
    else if FForceHTML then
      ShowHTML(AField.AsString);
  if not Visible then
    Show;
  if FField = nil then
    oDs := nil
  else
    oDs := FField.DataSet;
  if DataSource1.DataSet <> oDs then
    DataSource1.DataSet := oDs;
end;

{-----------------------------------------------------------------------------}
procedure TfrmBlob.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  if (Field = nil) and (DataSource1.DataSet = FField.DataSet) and Visible then
    FocusField(FField);
end;

{-----------------------------------------------------------------------------}
procedure TfrmBlob.ForceClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  FForceText := ForceText1.Checked;
  FForceBlob := ForceBinary1.Checked;
  FForceGraphic := ForceGraphic1.Checked;
  FForceHTML := ForceHTML1.Checked;
  FocusField(FField);
end;

{-----------------------------------------------------------------------------}
procedure TfrmBlob.StayOnTop1Click(Sender: TObject);
var
  lVisible: Boolean;
begin
  StayOnTop1.Checked := not StayOnTop1.Checked;
  lVisible := Visible;
  Hide;
  if StayOnTop1.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
  if lVisible then
    Show;
end;

{-----------------------------------------------------------------------------}
procedure TfrmBlob.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    Key := 0;
    Hide;
  end;
end;

end.
