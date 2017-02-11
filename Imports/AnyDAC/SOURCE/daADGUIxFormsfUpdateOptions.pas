{ --------------------------------------------------------------------------- }
{ AnyDAC fetch options editing frame                                          }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfUpdateOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls,
    Menus, Buttons,
  daADStanOption,
  daADGUIxFormsControls;

type
  TfrmADGUIxFormsUpdateOptions = class(TFrame)
    uo_GroupBox3: TADGUIxFormsPanel;
    uo_Label4: TLabel;
    uo_Label5: TLabel;
    uo_edtUpdateTableName: TEdit;
    uo_cbxUpdateMode: TComboBox;
    uo_cbUpdateChangedFields: TCheckBox;
    uo_cbCountUpdatedRecords: TCheckBox;
    uo_cbCacheUpdateCommands: TCheckBox;
    uo_GroupBox2: TADGUIxFormsPanel;
    uo_Label1: TLabel;
    uo_Label2: TLabel;
    uo_cbxLockMode: TComboBox;
    uo_cbxLockPoint: TComboBox;
    uo_cbLockWait: TCheckBox;
    uo_GroupBox4: TADGUIxFormsPanel;
    uo_cbUseProviderFlags: TCheckBox;
    uo_Panel6: TADGUIxFormsPanel;
    uo_PopupMenu1: TPopupMenu;
    uo_ReadOnly1: TMenuItem;
    uo_ReadWrite1: TMenuItem;
    uo_N1: TMenuItem;
    uo_Fastupdates1: TMenuItem;
    uo_Standardupdates1: TMenuItem;
    uo_cbEnableInsert: TCheckBox;
    uo_cbEnableUpdate: TCheckBox;
    uo_cbEnableDelete: TCheckBox;
    Panel1: TADGUIxFormsPanel;
    Panel2: TADGUIxFormsPanel;
    uo_SpeedButton1: TSpeedButton;
    Label1: TLabel;
    uo_cbRefreshMode: TComboBox;
    procedure uo_Change(Sender: TObject);
    procedure uo_ReadOnly1Click(Sender: TObject);
    procedure uo_ReadWrite1Click(Sender: TObject);
    procedure uo_Fastupdates1Click(Sender: TObject);
    procedure uo_Standardupdates1Click(Sender: TObject);
    procedure uo_SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    FOnModified: TNotifyEvent;
    FModifiedLocked: Boolean;
    FSQLGenerator: Boolean;
    FTableOptions: Boolean;
    procedure SetSQLGenerator(const AValue: Boolean);
    procedure SetTableOptions(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadFrom(AOpts: TADUpdateOptions);
    procedure SaveTo(AOpts: TADUpdateOptions);
  published
    property SQLGenerator: Boolean read FSQLGenerator write SetSQLGenerator
      default False;
    property TableOptions: Boolean read FTableOptions write SetTableOptions
      default True;
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
  end;

implementation

{$R *.dfm}

uses
  DB;

{ --------------------------------------------------------------------------- }
constructor TfrmADGUIxFormsUpdateOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTableOptions := True;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUpdateOptions.LoadFrom(AOpts: TADUpdateOptions);
begin
  FModifiedLocked := True;
  try
    if uo_cbEnableDelete.Enabled then
      uo_cbEnableDelete.Checked := AOpts.EnableDelete;
    if uo_cbEnableInsert.Enabled then
      uo_cbEnableInsert.Checked := AOpts.EnableInsert;
    if uo_cbEnableUpdate.Enabled then
      uo_cbEnableUpdate.Checked := AOpts.EnableUpdate;
    if uo_cbxLockMode.Enabled then
      uo_cbxLockMode.ItemIndex := Integer(AOpts.LockMode);
    if uo_cbxLockPoint.Enabled then
      uo_cbxLockPoint.ItemIndex := Integer(AOpts.LockPoint);
    if uo_cbLockWait.Enabled then
      uo_cbLockWait.Checked := AOpts.LockWait;
    if uo_cbUpdateChangedFields.Enabled then
      uo_cbUpdateChangedFields.Checked := AOpts.UpdateChangedFields;
    if uo_cbxUpdateMode.Enabled then
      uo_cbxUpdateMode.ItemIndex := Integer(AOpts.UpdateMode);
    if uo_cbCountUpdatedRecords.Enabled then
      uo_cbCountUpdatedRecords.Checked := AOpts.CountUpdatedRecords;
    if uo_cbRefreshMode.Enabled then
      uo_cbRefreshMode.ItemIndex := Integer(AOpts.RefreshMode);
    if uo_cbCacheUpdateCommands.Enabled then
      uo_cbCacheUpdateCommands.Checked := AOpts.CacheUpdateCommands;
    if uo_cbUseProviderFlags.Enabled then
      uo_cbUseProviderFlags.Checked := AOpts.UseProviderFlags;
    if uo_edtUpdateTableName.Enabled and (AOpts is TADBottomUpdateOptions) then
      uo_edtUpdateTableName.Text := TADBottomUpdateOptions(AOpts).UpdateTableName;
  finally
    FModifiedLocked := False;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUpdateOptions.SaveTo(AOpts: TADUpdateOptions);
begin
  if uo_cbEnableDelete.Enabled and (AOpts.EnableDelete <> uo_cbEnableDelete.Checked) then
    AOpts.EnableDelete := uo_cbEnableDelete.Checked;
  if uo_cbEnableInsert.Enabled and (AOpts.EnableInsert <> uo_cbEnableInsert.Checked) then
    AOpts.EnableInsert := uo_cbEnableInsert.Checked;
  if uo_cbEnableUpdate.Enabled and (AOpts.EnableUpdate <> uo_cbEnableUpdate.Checked) then
    AOpts.EnableUpdate := uo_cbEnableUpdate.Checked;
  if uo_cbxLockMode.Enabled and (AOpts.LockMode <> TADLockMode(uo_cbxLockMode.ItemIndex)) then
    AOpts.LockMode := TADLockMode(uo_cbxLockMode.ItemIndex);
  if uo_cbxLockPoint.Enabled and (AOpts.LockPoint <> TADLockPoint(uo_cbxLockPoint.ItemIndex)) then
    AOpts.LockPoint := TADLockPoint(uo_cbxLockPoint.ItemIndex);
  if uo_cbLockWait.Enabled and (AOpts.LockWait <> uo_cbLockWait.Checked) then
    AOpts.LockWait := uo_cbLockWait.Checked;
  if uo_cbUpdateChangedFields.Enabled and (AOpts.UpdateChangedFields <> uo_cbUpdateChangedFields.Checked) then
    AOpts.UpdateChangedFields := uo_cbUpdateChangedFields.Checked;
  if uo_cbxUpdateMode.Enabled and (AOpts.UpdateMode <> TUpdateMode(uo_cbxUpdateMode.ItemIndex)) then
    AOpts.UpdateMode := TUpdateMode(uo_cbxUpdateMode.ItemIndex);
  if uo_cbCountUpdatedRecords.Enabled and (AOpts.CountUpdatedRecords <> uo_cbCountUpdatedRecords.Checked) then
    AOpts.CountUpdatedRecords := uo_cbCountUpdatedRecords.Checked;
  if uo_cbRefreshMode.Enabled and (AOpts.RefreshMode <> TADRefreshMode(uo_cbRefreshMode.ItemIndex)) then
    AOpts.RefreshMode := TADRefreshMode(uo_cbRefreshMode.ItemIndex);
  if uo_cbCacheUpdateCommands.Enabled and (AOpts.CacheUpdateCommands <> uo_cbCacheUpdateCommands.Checked) then
    AOpts.CacheUpdateCommands := uo_cbCacheUpdateCommands.Checked;
  if uo_cbUseProviderFlags.Enabled and (AOpts.UseProviderFlags <> uo_cbUseProviderFlags.Checked) then
    AOpts.UseProviderFlags := uo_cbUseProviderFlags.Checked;
  if uo_edtUpdateTableName.Enabled and (AOpts is TADBottomUpdateOptions) and
     (TADBottomUpdateOptions(AOpts).UpdateTableName <> uo_edtUpdateTableName.Text) then
    TADBottomUpdateOptions(AOpts).UpdateTableName := uo_edtUpdateTableName.Text;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUpdateOptions.uo_Change(Sender: TObject);
begin
  if not FModifiedLocked and Assigned(FOnModified) then
    FOnModified(Self);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUpdateOptions.SetSQLGenerator(const AValue: Boolean);
begin
  if FSQLGenerator <> AValue then begin
    FSQLGenerator := AValue;
    FModifiedLocked := True;
    try
      uo_Label2.Enabled := not AValue;
      uo_cbxLockPoint.Enabled := not AValue;
      uo_cbUpdateChangedFields.Enabled := not AValue;
      uo_cbUpdateChangedFields.Checked := False;
      uo_cbCountUpdatedRecords.Enabled := not AValue;
      uo_cbCountUpdatedRecords.Checked := True;
      uo_cbCacheUpdateCommands.Enabled := not AValue;
      uo_cbCacheUpdateCommands.Checked := True;
      uo_cbUseProviderFlags.Enabled := not AValue;
      uo_cbUseProviderFlags.Checked := False;
      uo_Label5.Enabled := not AValue;
      uo_edtUpdateTableName.Enabled := not AValue;
      uo_edtUpdateTableName.Text := '';
    finally
      FModifiedLocked := False;
    end;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUpdateOptions.SetTableOptions(const Value: Boolean);
begin
  if FTableOptions <> Value then begin
    FTableOptions := Value;
    {
    if FTableOptions then begin
      uo_GroupBox5.Left := 2;
      uo_GroupBox5.Top := 77;
      uo_GroupBox4.Left := 277;
      uo_GroupBox4.Top := 97;
      uo_GroupBox5.Visible := True;
    end
    else begin
      uo_GroupBox5.Visible := False;
      uo_GroupBox4.Left := 2;
      uo_GroupBox4.Top := 77;
    end;
    }
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUpdateOptions.uo_ReadOnly1Click(Sender: TObject);
begin
  uo_cbEnableInsert.Checked := False;
  uo_cbEnableUpdate.Checked := False;
  uo_cbEnableDelete.Checked := False;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUpdateOptions.uo_ReadWrite1Click(Sender: TObject);
begin
  uo_cbEnableInsert.Checked := True;
  uo_cbEnableUpdate.Checked := True;
  uo_cbEnableDelete.Checked := True;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUpdateOptions.uo_Fastupdates1Click(Sender: TObject);
begin
  uo_cbUpdateChangedFields.Checked := False;
  uo_cbxUpdateMode.ItemIndex := 2;
  uo_cbxLockMode.ItemIndex := 2;
  uo_cbRefreshMode.ItemIndex := 0;
  uo_cbCacheUpdateCommands.Checked := True;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUpdateOptions.uo_Standardupdates1Click(Sender: TObject);
begin
  uo_cbUpdateChangedFields.Checked := True;
  uo_cbxUpdateMode.ItemIndex := 0;
  uo_cbxLockMode.ItemIndex := 2;
  uo_cbRefreshMode.ItemIndex := 1;
  uo_cbCacheUpdateCommands.Checked := False;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUpdateOptions.uo_SpeedButton1Click(Sender: TObject);
var
  P: TPoint;
begin
  P := uo_Panel6.ClientToScreen(uo_SpeedButton1.BoundsRect.TopLeft);
  uo_PopupMenu1.Popup(P.X, P.Y);
end;

end.
