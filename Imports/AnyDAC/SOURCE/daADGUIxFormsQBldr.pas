{ --------------------------------------------------------------------------- }
{ AnyDAC Query Builder engine                                                 }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{ Portions copyright:                                                         }
{ - Sergey Orlik, 1996-99. The source is based on Open Query Builder.         }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsQBldr;

interface

uses
  Windows, Messages, SysUtils, Classes, DB,
  daADPhysIntf, daADCompClient, daADGUIxFormsfQBldr;

type
  TADGUIxFormsQBldrEngine = class(TADGUIxFormsQBldrEngineBase)
  private
    FQuery: TADQuery;
    function GetConnection: TADCustomConnection;
    procedure ReleaseConnection(AConn: TADCustomConnection);
  protected
    procedure SetConnectionName(const AValue: String); override;
    procedure SetConnection(const AValue: TCustomConnection); override;
    function  SelectConnection: boolean; override;
    procedure ReadTableList(ATables: TStrings;
      out ASQLDialect: TADGUIxFormsQBldrSQLJoinDialect); override;
    procedure ReadFieldList(const ATableName: String;
      AFields: TStrings); override;
    procedure ClearQuerySQL; override;
    procedure SetQuerySQL(AValue: String); override;
    function  ResultQuery : TDataSet; override;
    procedure SaveResultQueryData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  Controls, Forms, Dialogs, StdCtrls,
  daADStanIntf, daADGUIxFormsfQBldrConn, daADCompDataMove;

{ --------------------------------------------------------------------------- }
{ TADGUIxFormsQBldrEngine                                                     }
{ --------------------------------------------------------------------------- }
constructor TADGUIxFormsQBldrEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQuery := TADQuery.Create(Self);
end;

{ --------------------------------------------------------------------------- }
destructor TADGUIxFormsQBldrEngine.Destroy;
begin
  FreeAndNil(FQuery);
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngine.SetConnection(const AValue: TCustomConnection);
begin
  inherited SetConnection(AValue);
  FQuery.Connection := TADCustomConnection(AValue);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngine.SetConnectionName(const AValue: String);
begin
  inherited SetConnectionName(AValue);
  FQuery.ConnectionName := AValue;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrEngine.GetConnection: TADCustomConnection;
begin
  if Connection = nil then
    Result := ADManager.OpenConnection(ConnectionName)
  else
    Result := TADCustomConnection(Connection);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngine.ReleaseConnection(AConn: TADCustomConnection);
begin
  if Connection = nil then
    ADManager.CloseConnection(AConn);
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrEngine.SelectConnection: Boolean;
var
  oConnFrm: TfrmADGUIxFormsQBldrConn;
begin
  oConnFrm := TfrmADGUIxFormsQBldrConn.Create(nil);
  try
    ADManager.GetConnectionDefNames(oConnFrm.ComboDB.Items);
    if oConnFrm.ComboDB.Items.Count <> 0 then
      oConnFrm.ComboDB.ItemIndex := 0
    else begin
      oConnFrm.ComboDB.Enabled := False;
      oConnFrm.cbMy.Enabled := False;
      oConnFrm.cbSystem.Enabled := False;
      oConnFrm.cbOther.Enabled := False;
    end;
    oConnFrm.cbMy.Checked := ssMy in ShowTables;
    oConnFrm.cbOther.Checked := ssOther in ShowTables;
    oConnFrm.cbSystem.Checked := ssSystem in ShowTables;
    if oConnFrm.ShowModal = mrOk then begin
      ConnectionName := oConnFrm.ComboDB.Items[oConnFrm.ComboDB.ItemIndex];
      ShowTables := [];
      if oConnFrm.cbMy.Checked then
        ShowTables := ShowTables + [ssMy];
      if oConnFrm.cbOther.Checked then
        ShowTables := ShowTables + [ssOther];
      if oConnFrm.cbSystem.Checked then
        ShowTables := ShowTables + [ssSystem];
      Result := True;
    end
    else
      Result := False;
  finally
    oConnFrm.Free;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngine.ReadTableList(ATables: TStrings;
  out ASQLDialect: TADGUIxFormsQBldrSQLJoinDialect);
const
  CRDBMS2Dialect: array [TADRDBMSKind] of TADGUIxFormsQBldrSQLJoinDialect =
    (sdAnsiSQL, sdOracle, sdAnsiSQL, sdMSAccess, sdAnsiSQL, sdAnsiSQL, sdAnsiSQL,
     sdAnsiSQL, sdAnsiSQL);
var
  oConn: TADCustomConnection;
begin
  oConn := GetConnection;
  try
    oConn.GetTableNames('', '', '', ATables, TADPhysObjectScopes(ShowTables));
    ASQLDialect := CRDBMS2Dialect[oConn.RDBMSKind];
  finally
    ReleaseConnection(oConn);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngine.ReadFieldList(const ATableName: String; AFields: TStrings);
var
  oConn: TADCustomConnection;
begin
  oConn := GetConnection;
  try
    oConn.GetFieldNames('', '', ATableName, '', AFields);
    AFields.Insert(0, '*');
  finally
    ReleaseConnection(oConn);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngine.ClearQuerySQL;
begin
  FQuery.SQL.Clear;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngine.SetQuerySQL(AValue: String);
begin
  FQuery.SQL.Text := AValue;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrEngine.ResultQuery: TDataSet;
begin
  Result := FQuery;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngine.SaveResultQueryData;
var
  oDlg: TSaveDialog;
  oMove: TADDataMove;
begin
  oDlg := TSaveDialog.Create(Self);
  try
    oDlg.Filter := 'Text Files (*.txt)|*.txt|CSV Files (*.csv)|*.csv|All files (*.*)|*.*';
    oDlg.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist];
    if oDlg.Execute then begin
      oMove := TADDataMove.Create(Self);
      try
        oMove.Source := FQuery;
        oMove.SourceKind := skDataSet;
        oMove.DestinationKind := skAscii;
        oMove.AsciiFileName := oDlg.FileName;
        oMove.Mode := dmAppend;
        oMove.Execute;
      finally
        oMove.Free;
      end;
    end;
  finally
    oDlg.Free;
  end;
end;

end.

