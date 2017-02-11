{ --------------------------------------------------------------------------- }
{ AnyDAC Explorer Import BDE Aliases dialog                                   }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fImpAliases;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, CheckLst,
  daADGUIxFormsfOptsBase;

type
  TfrmImportAliases = class(TfrmADGUIxFormsOptsBase)
    lvAliases: TListView;
    cbOverwrite: TCheckBox;
    btnSelectAll: TButton;
    btnUnselectAll: TButton;
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnUnselectAllClick(Sender: TObject);
    procedure lvAliasesColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvAliasesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
  private
    { Private declarations }
    FLastColumn: Integer;
    procedure OverwriteConDef(const AName: String; var AOverwrite: Integer);
  public
    { Public declarations }
    class function Execute(const AConnectionDefFileName: String;
      ABDEOverwriteConnectionDef: Boolean): Boolean;
  end;

var
  frmImportAliases: TfrmImportAliases;

implementation

{$R *.dfm}

uses
  DBTables, BDE,
  daADCompBDEAliasImport;

{ --------------------------------------------------------------------------- }
procedure TfrmImportAliases.btnSelectAllClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvAliases.Items.Count - 1 do
    lvAliases.Items[i].Checked := True;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmImportAliases.btnUnselectAllClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvAliases.Items.Count - 1 do
    lvAliases.Items[i].Checked := False;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmImportAliases.lvAliasesColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if FLastColumn = Column.Index + 1 then
    FLastColumn := -FLastColumn
  else
    FLastColumn := Column.Index + 1;
  lvAliases.AlphaSort;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmImportAliases.lvAliasesCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if FLastColumn = 1 then
    Compare := lstrcmp(PChar(Item1.Caption), PChar(Item2.Caption))
  else if FLastColumn = -1 then
    Compare := lstrcmp(PChar(Item2.Caption), PChar(Item1.Caption))
  else if FLastColumn > 1 then
    Compare := lstrcmp(PChar(Item1.SubItems[FLastColumn - 2]), PChar(Item2.SubItems[FLastColumn - 2]))
  else if FLastColumn < -1 then
    Compare := lstrcmp(PChar(Item2.SubItems[-FLastColumn - 2]), PChar(Item1.SubItems[-FLastColumn - 2]))
  else
    Compare := 0;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmImportAliases.OverwriteConDef(const AName: String;
  var AOverwrite: Integer);
begin
  case MessageDlg('Would you like to overwrite existing connection [' + AName + ']?',
                  mtConfirmation, mbYesNoCancel, -1) of
  mrYes:    AOverwrite := 1;
  mrNo:     AOverwrite := 0;
  mrCancel: AOverwrite := -1;
  end;
end;

{ --------------------------------------------------------------------------- }
class function TfrmImportAliases.Execute(const AConnectionDefFileName: String;
  ABDEOverwriteConnectionDef: Boolean): Boolean;
var
  iCursor: HDBICur;
  rDesc: DBDesc;
  oMig: TADBDEAliasImporter;
  i: Integer;
begin
  with TfrmImportAliases.Create(nil) do
  try
    Screen.Cursor := crHourGlass;
    try
      Session.Active := True;
      lvAliases.Items.Clear;
      DBTables.Check(DbiOpenDatabaseList(iCursor));
      try
        while DbiGetNextRecord(iCursor, dbiNOLOCK, @rDesc, nil) = 0 do begin
          OemToChar(rDesc.szName, rDesc.szName);
          with lvAliases.Items.Add do begin
            Caption := rDesc.szName;
            SubItems.Add(rDesc.szDbType);
          end;
        end;
      finally
        DbiCloseCursor(iCursor);
      end;
      btnSelectAllClick(nil);
    finally
      Screen.Cursor := crDefault;
    end;
    cbOverwrite.Checked := ABDEOverwriteConnectionDef;
    Result := ShowModal = mrOK;
    if Result then begin
      oMig := TADBDEAliasImporter.Create;
      Screen.Cursor := crHourGlass;
      try
        oMig.ConnectionDefFileName := AConnectionDefFileName;
        oMig.OverwriteDefs := cbOverwrite.Checked;
        oMig.OnOverwrite := OverwriteConDef;
        oMig.AliasesToImport.Clear;
        for i := 0 to lvAliases.Items.Count - 1 do
          if lvAliases.Items[i].Checked then
            oMig.AliasesToImport.Add(lvAliases.Items[i].Caption);
        if oMig.AliasesToImport.Count = 0 then
          Result := False
        else
          oMig.Execute;
      finally
        Screen.Cursor := crDefault;
        oMig.Free;
      end;
    end;
  finally
    Free;
  end;
end;

end.
