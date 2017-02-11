{ --------------------------------------------------------------------------- }
{ AnyDAC monitor options dialog                                               }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fOptionsFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ExtCtrls, ComCtrls, Buttons,
  fMainFrm,
  daADGUIxFormsfOptsBase,
  daADStanIntf, CheckLst, daADGUIxFormsControls;

type
  TfrmOptions = class(TfrmADGUIxFormsOptsBase)
    SaveDialog1: TSaveDialog;
    pnlContainer: TADGUIxFormsPanel;
    tcPages: TADGUIxFormsTabControl;
    pnlData: TADGUIxFormsPanel;
    pnlBuffer: TADGUIxFormsPanel;
    pnlCategories: TADGUIxFormsPanel;
    pnlBottomSep: TADGUIxFormsPanel;
    pnlLeftSep: TADGUIxFormsPanel;
    pnlRightSep: TADGUIxFormsPanel;
    clbCategories: TCheckListBox;
    cbxBufferMode: TComboBox;
    Label1: TLabel;
    edtCount: TEdit;
    edtMemory: TEdit;
    lblCount: TLabel;
    lblMemory: TLabel;
    edtPageFile: TEdit;
    btnPageFile: TSpeedButton;
    lblPageFile: TLabel;
    pnlListening: TADGUIxFormsPanel;
    edtPort: TEdit;
    lblPort: TLabel;
    procedure btnPageFileClick(Sender: TObject);
    procedure cbxBufferModeChange(Sender: TObject);
    procedure tcPagesChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(AOptions: TADMoniOptions; AFocusOnPort: Boolean;
      var AClearBuffer: Boolean): Boolean;
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

{ ----------------------------------------------------------------------------- }
{ TfrmOptions                                                                   }
{ ----------------------------------------------------------------------------- }
procedure TfrmOptions.btnPageFileClick(Sender: TObject);
begin
  SaveDialog1.FileName := edtPageFile.Text;
  if SaveDialog1.Execute then
    edtPageFile.Text := SaveDialog1.FileName;
end;

{ ----------------------------------------------------------------------------- }
procedure TfrmOptions.cbxBufferModeChange(Sender: TObject);
begin
  edtCount.Enabled := TADMoniBufferMode(cbxBufferMode.ItemIndex) in [tmLimitItems, tmLimitItemsAndPage];
  lblCount.Enabled := edtCount.Enabled;
  if edtCount.Enabled and (edtCount.Text = '') then
    edtCount.Text := '1000';
  edtMemory.Enabled := TADMoniBufferMode(cbxBufferMode.ItemIndex) in [tmLimitMemory, tmLimitMemoryAndPage];
  lblMemory.Enabled := edtMemory.Enabled;
  if edtMemory.Enabled and (edtMemory.Text = '') then
    edtMemory.Text := '256';
  edtPageFile.Enabled := TADMoniBufferMode(cbxBufferMode.ItemIndex) in [tmLimitItemsAndPage, tmLimitMemoryAndPage];
  lblPageFile.Enabled := edtPageFile.Enabled;
  btnPageFile.Enabled := edtPageFile.Enabled;
  if edtPageFile.Enabled and (edtPageFile.Text = '') then
    edtPageFile.Text := 'Trace_' + FormatDateTime('yymmdd_hhnn', Now()) + '.log';
end;

{ ----------------------------------------------------------------------------- }
class function TfrmOptions.Execute(AOptions: TADMoniOptions; AFocusOnPort: Boolean;
  var AClearBuffer: Boolean): Boolean;
var
  eBufferMode: TADMoniBufferMode;
  eEventKind: TADMoniEventKind;
  i, iCapacity: Integer;
const
  C_DebugOptionNames: array [TADMoniEventKind] of string = (
    'Live cycle', 'Errors', 'Connection connect / disconnect',
    'Connection transact', 'Connection other', 'Command prepare / unprepare',
    'Command execute / open', 'Command data input', 'Command data output',
    'Adapter update', 'Vendor calls');

  C_BufferModeNames: array [TADMoniBufferMode] of string = (
    'Limit by count, overwrite', 'Limit by count, page out',
    'Limit by memory, overwrite', 'Limit by memory, page out');

begin
  if frmOptions = nil then
    frmOptions := TfrmOptions.Create(Application);
  AClearBuffer := False;
  with frmOptions do begin
    clbCategories.Clear;
    for eEventKind := Low(TADMoniEventKind) to High(TADMoniEventKind) do begin
      i := clbCategories.Items.Add(C_DebugOptionNames[eEventKind]);
      clbCategories.Checked[i] := eEventKind in AOptions.EventKinds;
    end;

    cbxBufferMode.Clear;
    for eBufferMode := Low(TADMoniBufferMode) to High(TADMoniBufferMode) do
      cbxBufferMode.Items.Add(C_BufferModeNames[eBufferMode]);

    cbxBufferMode.ItemIndex := Integer(AOptions.BufferMode);
    cbxBufferModeChange(nil);

    if edtCount.Enabled then
      edtCount.Text := IntToStr(AOptions.BufferCapacity)
    else
      edtCount.Text := '';
    if edtMemory.Enabled then
      edtMemory.Text := IntToStr(AOptions.BufferCapacity div 1024)
    else
      edtMemory.Text := '';
    edtPageFile.Text := AOptions.BufferPageFile;
    edtPort.Text := IntToStr(AOptions.ListeningPort);
    if AFocusOnPort then
      tcPages.TabIndex := 2
    else
      tcPages.TabIndex := 0;
    Result := (ShowModal = mrOK);
    if Result then begin
      AOptions.EventKinds := [];
      for i := 0 to clbCategories.Items.Count - 1 do
        if clbCategories.Checked[i] then
          AOptions.EventKinds := AOptions.EventKinds + [TADMoniEventKind(i)];
      eBufferMode := TADMoniBufferMode(cbxBufferMode.ItemIndex);
      if AOptions.BufferMode <> eBufferMode then begin
        AOptions.BufferMode := eBufferMode;
        AClearBuffer := True;
      end;
      if edtCount.Enabled then
        iCapacity := StrToIntDef(edtCount.Text, 1000)
      else if edtMemory.Enabled then
        iCapacity := StrToIntDef(edtMemory.Text, 256) * 1024
      else
        iCapacity := 0;
      if AOptions.BufferCapacity <> iCapacity then begin
        AOptions.BufferCapacity := iCapacity;
        AClearBuffer := True;
      end;
      if edtPageFile.Enabled then
        AOptions.BufferPageFile := edtPageFile.Text
      else
        AOptions.BufferPageFile := '';
      AOptions.ListeningPort := StrToInt(edtPort.Text);
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TfrmOptions.tcPagesChange(Sender: TObject);
begin
  if tcPages.TabIndex = 0 then begin
    pnlCategories.Visible := True;
    pnlBuffer.Visible := False;
    pnlListening.Visible := False;
  end
  else if tcPages.TabIndex = 1 then begin
    pnlBuffer.Visible := True;
    pnlCategories.Visible := False;
    pnlListening.Visible := False;
  end
  else begin
    pnlListening.Visible := True;
    pnlBuffer.Visible := False;
    pnlCategories.Visible := False;
  end;
end;

end.
