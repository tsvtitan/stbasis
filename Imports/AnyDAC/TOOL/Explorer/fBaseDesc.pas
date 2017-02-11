{ --------------------------------------------------------------------------- }
{ AnyDAC Explorer base class for property pages                               }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fBaseDesc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, DB, fExplorer;

type
  {--------------------------------------------------------------------------}
  TfrmBaseDesc = class(TFrame)
    procedure CtrlChange(Sender: TObject);
  private
    FReadOnly: Boolean;
    { Private declarations }
    procedure SetReadOnly(AValue: Boolean);
  protected
    FExplNode: TADExplorerNode;
    FModified: Boolean;
  public
    { Public declarations }
    procedure LoadData; virtual;
    procedure SaveData; virtual;
    procedure UpdateReadOnly; virtual;
    procedure PostChanges; virtual;
    procedure ResetState(AClear: Boolean); virtual;
    procedure ResetPageData; virtual;
    function GetMenu: TMainMenu; virtual;
    function GetPopup: TPopupMenu; virtual;
    function RunWizard: Boolean; virtual;
    procedure Test; virtual;
    procedure DoKeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure SetDS(ADataSource: TDataSource);
    property ExplNode: TADExplorerNode read FExplNode write FExplNode;
    property Modified: Boolean read FModified;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
  end;

implementation

{$R *.DFM}

{----------------------------------------------------------------------------}
{ TfrmBaseDesc                                                               }
{----------------------------------------------------------------------------}
procedure TfrmBaseDesc.CtrlChange(Sender: TObject);
begin
  FModified := True;
end;

{----------------------------------------------------------------------------}
function TfrmBaseDesc.GetMenu: TMainMenu;
begin
  Result := nil;
end;

{----------------------------------------------------------------------------}
function TfrmBaseDesc.GetPopup: TPopupMenu;
begin
  Result := nil;
end;

{----------------------------------------------------------------------------}
procedure TfrmBaseDesc.LoadData;
begin
  FModified := False;
end;

{----------------------------------------------------------------------------}
procedure TfrmBaseDesc.SaveData;
begin
  FModified := False;
end;

{----------------------------------------------------------------------------}
procedure TfrmBaseDesc.SetReadOnly(AValue: Boolean);
begin
  if FReadOnly <> AValue then begin
    FReadOnly := AValue;
    UpdateReadOnly;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmBaseDesc.UpdateReadOnly;
begin
  // nop
end;

{----------------------------------------------------------------------------}
procedure TfrmBaseDesc.PostChanges;
begin
  // nop
end;

{----------------------------------------------------------------------------}
procedure TfrmBaseDesc.ResetState(AClear: Boolean);
begin
  FModified := False;
end;

{----------------------------------------------------------------------------}
procedure TfrmBaseDesc.SetDS(ADataSource: TDataSource);
begin
  ExplNode.Explorer.DBNavigator1.DataSource := ADataSource;
end;

{----------------------------------------------------------------------------}
procedure TfrmBaseDesc.DoKeyDown(var Key: Word; Shift: TShiftState);
begin
  // nop
end;

{----------------------------------------------------------------------------}
procedure TfrmBaseDesc.ResetPageData;
begin
  // nop
end;

{----------------------------------------------------------------------------}
function TfrmBaseDesc.RunWizard: Boolean;
begin
  // nop
  Result := False;
end;

{----------------------------------------------------------------------------}
procedure TfrmBaseDesc.Test;
begin
  // nop
end;

end.

