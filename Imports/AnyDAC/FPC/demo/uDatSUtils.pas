{-------------------------------------------------------------------------------}
{ AnyDAC console functions                                                      }
{ Copyright (c) 2004 by Dmitry Arefiev (www.da-soft.com)                        }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit uDatSUtils;

interface

uses
  SysUtils, Classes, Controls,
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}  
  StdCtrls, daADDatSManager, daADStanIntf;

  procedure PrintHeader(ATab: TADDatSTable; AConsole: TStrings;
    const ALabel: String = ''; AWithState: Boolean = False);
  procedure PrintRow(ARow: TADDatSRow; AConsole: TStrings;
    const ALabel: String = ''; AWithState: Boolean = False); overload;
  procedure PrintRow(ARow: TADDatSRow; AConsole: TStrings;
    ARowVer: TADDatSRowVersion; const ALabel: String = '';
    AWithState: Boolean = False); overload;
  procedure PrintRows(ATab: TADDatSTable; AConsole: TStrings;
    const ALabel: String = ''; AWithState: Boolean = False); overload;
  procedure PrintRows(AView: TADDatSView; AConsole: TStrings;
    const ALabel: String = ''; AWithState: Boolean = False); overload;
  procedure PrintRowVersion(ARow: TADDatSRow; AConsole: TStrings);
  procedure PrintRowStates(ATab: TADDatSTable; AConsole: TStrings; const ALabel: String = '');

const
  RowStates: array [TADDatSRowState] of String = (
    'rsInitializing', 'rsDetached', 'rsInserted', 'rsDeleted', 'rsModified',
    'rsUnchanged', 'rsEditing', 'rsCalculating', 'rsChecking', 'rsDestroying',
    'rsForceWrite', 'rsImportingCurent', 'rsImportingOriginal', 'rsImportingProposed');

  RowVersions: array [TADDatSRowVersion] of String = ('rvDefault', 'rvCurrent',
    'rvOriginal', 'rvPrevious', 'rvProposed');

implementation

{-------------------------------------------------------------------------------}
function PadVal(AColumn: TADDatSColumn; const AVal: String): String;
var
  iDispWidth: Integer;
begin
  iDispWidth := AColumn.DisplayWidth;
  if Length(AVal) > iDispWidth then
    Result := Copy(AVal, 1, iDispWidth - 4) + ' ...'
  else
    Result := AVal;
  if AColumn.DataType in [dtAnsiString, dtWideString, dtByteString,
                          dtBlob, dtMemo, dtWideMemo,
                          dtHBlob, dtHMemo, dtWideHMemo,
                          dtHBFile] then
    Result := Result + StringOfChar(' ', iDispWidth - Length(Result))
  else
    Result := StringOfChar(' ', iDispWidth - Length(Result)) + Result;
end;

{-------------------------------------------------------------------------------}
procedure PrintHeader(ATab: TADDatSTable; AConsole: TStrings;
  const ALabel: String = ''; AWithState: Boolean = False);
var
  i: Integer;
  s: String;
begin
  if ALabel <> '' then
    AConsole.Add(ALabel);
  with ATab do begin
    if AWithState then
      s := 'State      '
    else
      s := '';
    for i := 0 to Columns.Count - 1 do
      s := s + '  ' + PadVal(Columns[i], Columns[i].Name);
    AConsole.Add(s);
  end;
end;

{-------------------------------------------------------------------------------}
procedure PrintRow(ARow: TADDatSRow; AConsole: TStrings; ARowVer: TADDatSRowVersion;
  const ALabel: String = ''; AWithState: Boolean = False);
var
  c: Integer;
  s: String;
begin
  if ALabel <> '' then
    AConsole.Add(ALabel);
  if AWithState then begin
    s := RowStates[ARow.RowState];
    if Length(s) < 11 then
      s := s + StringOfChar(' ', 11 - Length(s));
  end
  else
    s := '';
  for c := 0 to ARow.Table.Columns.Count - 1 do
    if ARow.Table.Columns[c].DataType <> dtTime then
      s := s + '  ' + PadVal(ARow.Table.Columns[c], VarToStr(ARow.GetData(c, ARowVer)))
    else
      s := s + '  ' + PadVal(ARow.Table.Columns[c], TimeToStr(VarAsType(ARow.GetData(c, ARowVer), varDate)));
  AConsole.Add(s);
end;

{-------------------------------------------------------------------------------}
procedure PrintRow(ARow: TADDatSRow; AConsole: TStrings; const ALabel: String = '';
  AWithState: Boolean = False);
begin
  PrintRow(ARow, AConsole, rvDefault, ALabel, AWithState);
end;

{-------------------------------------------------------------------------------}
procedure PrintRows(ATab: TADDatSTable; AConsole: TStrings;
  const ALabel: String = ''; AWithState: Boolean = False);
var
  i: Integer;
begin
  PrintHeader(ATab, AConsole, ALabel, AWithState);
  with ATab do
    for i := 0 to Rows.Count - 1 do
      PrintRow(Rows[i], AConsole, '', AWithState);
  AConsole.Add('');
end;

{-------------------------------------------------------------------------------}
procedure PrintRows(AView: TADDatSView; AConsole: TStrings;
  const ALabel: String = ''; AWithState: Boolean = False);
var
  i: Integer;
begin
  PrintHeader(AView.Table, AConsole, ALabel, AWithState);
  with AView.Table do
    for i := 0 to AView.Rows.Count - 1 do
      PrintRow(AView.Rows[i], AConsole, '', AWithState);
  AConsole.Add('');
end;

{-------------------------------------------------------------------------------}
procedure PrintRowVersion(ARow: TADDatSRow; AConsole: TStrings);
var
  i: Integer;
  sVer: String;
begin
  for i := 0 to 4 do
    if ARow.HasVersion(TADDatSRowVersion(i)) then begin
      case i of
      0: sVer := 'rvDefault';
      1: sVer := 'rvCurrent';
      2: sVer := 'rvOriginal';
      3: sVer := 'rvPrevious';
      4: sVer := 'rvProposed';
      end;
      PrintRow(ARow, AConsole, TADDatSRowVersion(i), 'Row version is ' + sVer);
    end
end;

{-------------------------------------------------------------------------------}
procedure PrintRowStates(ATab: TADDatSTable; AConsole: TStrings; const ALabel: String = '');
var
  i: Integer;
begin
  if ALabel = '' then
    AConsole.Add('Row states...')
  else
    AConsole.Add(ALabel);
  for i := 0 to ATab.Rows.Count - 1 do
    AConsole.Add(RowStates[ATab.Rows[i].RowState]);
end;

end.
