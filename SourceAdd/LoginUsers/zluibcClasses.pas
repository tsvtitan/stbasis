{
 * The contents of this file are subject to the InterBase Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License.
 * 
 * You may obtain a copy of the License at http://www.Inprise.com/IPL.html.
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
 * the License for the specific language governing rights and limitations
 * under the License.  The Original Code was created by Inprise
 * Corporation and its predecessors.
 * 
 * Portions created by Inprise Corporation are Copyright (C) Inprise
 * Corporation. All Rights Reserved.
 * 
 * Contributor(s): ______________________________________.
}

{****************************************************************
*
*  z l u i b c C l a s s e s
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit contains custom class definitions/
*                implementations
*
*****************************************************************
* Revisions:
*
*****************************************************************}

unit zluibcClasses;

interface

uses
  Forms, SysUtils, Classes, WinTypes, WinProcs, CommCtrl, IBDatabase, IB,
  IBServices, IBSQL, DB, IBCustomDataSet, Controls, frmuObjectWindow, zluGlobal,
  frmuTextViewer;

type

  TibcTreeNode = class(TComponent)
  private
    FNodeID: HTreeItem;
    FNodeName: string;
    FNodeType: word;
    FShowSystem: boolean;
    FObjectList: TStringList;
  protected
  public
    property NodeID: HTreeItem read FNodeID;
    property NodeName: string read FNodeName write FNodeName;
    property NodeType: word read FNodeType;
    property ShowSystem: boolean read FShowSystem write FShowSystem;
    property ObjectList: TStringList read FObjectList write FObjectList;

    constructor Create(AOwner: TComponent; const NodeID: HTreeItem; const NodeName: string; const NodeType: word); reintroduce;
    destructor Destroy(); override;
  published
  end;

  TibcServerNode = class(TibcTreeNode)
  private
    FServerName: string;
    FUserName: string;
    FPassword: string;
    FVersion : Integer;
    FDatabasesID: HTreeItem;
    FBackupFilesID: HTreeItem;
    FServer: TIBServerProperties;
    FDescription: string;
    FLastAccessed: TDateTime;
    FOutputWindow: TfrmTextViewer;
  protected
  public
    property Servername: string read FServername write FServername;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
    property DatabasesID: HTreeItem read FDatabasesID write FDatabasesID;
    property Version : Integer read FVersion write FVersion;
    property Description: string read FDescription write FDescription;
    property LastAccessed: TDateTime read FLastAccessed write FLastAccessed;
    property BackupFilesID: HTreeItem read FBackupFilesID write FBackupFilesID;
    property Server: TIBServerProperties read FServer write FServer;
    property OutputWindow: TfrmTextViewer read FOutputWindow;

    constructor Create(AOwner: TComponent; const NodeID: HTreeItem; const NodeName,ServerName,UserName,Password, Description: string; const Protocol: TProtocol; const LastAccessed: TDateTime; const NodeType: word);
    destructor Destroy(); override;
    procedure ShowText (const Data: TStringList; const Title: String;
        const readonly: boolean=true);
    procedure OpenTextViewer (const Service: TIBControlAndQueryService;
        const Title: String; const readonly: boolean=true);
  published
  end;

  TibcDatabaseNode = class(TibcTreeNode)
  private
    FDatabaseFiles: TStringList;
    FUserName: string;
    FPassword: string;
    FRole: string;
    FCaseSensitiveRole: boolean;
    FDefaultBackupAlias: string;
    FSQLBuffer: TStringList;
    FSQLBufferPos: integer;
    FDatabase: TIBDatabase;
    FTransaction: TIBTransaction;
    FQryTransaction: TIBTransaction;
    FDataSet: TIBDataSet;
    FQryDataSet: TIBDataSet;
    FDataSource: TDataSource;
    FQryDataSource: TDataSource;
    FQuery: TIBSQL;

    FTablesID: HTreeItem;
    FDomainsID: HTreeItem;
    FViewsID: HTreeItem;
    FProceduresID: HTreeItem;
    FFunctionsID: HTreeItem;
    FGeneratorsID: HTreeItem;
    FExceptionsID: HTreeItem;
    FFiltersID: HTreeItem;
    FRolesID: HTreeItem;
    FTriggersID: HTreeItem;

    FObjectViewer: TFrmObjectView;

  protected
  public
    property DatabaseFiles: TStringList read FDatabaseFiles write FDatabaseFiles;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
    property Role: string read FRole write FRole;
    property CaseSensitiveRole: boolean read FCaseSensitiveRole write FCaseSensitiveRole;
    property DefaultBackupAlias: string read FDefaultBackupAlias write FDefaultBackupAlias;
    property SQLBuffer: TStringList read FSQLBuffer write FSQLBuffer;
    property SQLBufferPos: integer read FSQLBufferPos write FSQLBufferPos;
    property Database: TIBDatabase read FDatabase write FDatabase;
    property Transaction: TIBTransaction read FTransaction write FTransaction;
    property QryTransaction: TIBTransaction read FQryTransaction write FQryTransaction;
    property DataSet: TIBDataSet read FDataSet write FDataSet;
    property QryDataSet: TIBDataSet read FQryDataSet write FQryDataSet;
    property DataSource: TDataSource read FDatasource write FDatasource;
    property QryDataSource: TDataSource read FQryDatasource write FQryDatasource;
    property Query: TIBSQL read FQuery write FQuery;

    property TablesID: HTreeItem read FTablesID write FTablesID;
    property DomainsID: HTreeItem read FDomainsID write FDomainsID;
    property ViewsID: HTreeItem read FViewsID write FViewsID;
    property ProceduresID: HTreeItem read FProceduresID write FProceduresID;
    property FunctionsID: HTreeItem read FFunctionsID write FFunctionsID;
    property GeneratorsID: HTreeItem read FGeneratorsID write FGeneratorsID;
    property ExceptionsID: HTreeItem read FExceptionsID write FExceptionsID;
    property FiltersID: HTreeItem read FFiltersID write FFiltersID;
    property RolesID: HTreeItem read FRolesID write FRolesID;
    property TriggersID: HTreeItem read FTriggersID write FTriggersID;

    property ObjectViewer: TFrmObjectView read FObjectViewer;

    constructor Create(AOwner: TComponent; const NodeID: HTreeItem;
      const NodeName: string; const NodeType: word;
      const DatabaseFiles: TStringList; var NewDatabase: TIBDatabase);
    destructor Destroy(); override;
    procedure CreateObjectViewer;
  published
  end;

  TibcBackupAliasNode = class(TibcTreeNode)
  private
    FSourceDBServer: string;
    FSourceDBAlias: string;
    FBackupFiles: TStringList;
    FCreated: TDateTime;
    FLastAccessed: TDateTime;
  protected
  public
    property SourceDBServer: string read FSourceDBServer write FSourceDBServer;
    property SourceDBAlias: string read FSourceDBAlias write FSourceDBAlias;
    property BackupFiles: TStringList read FBackupFiles write FBackupFiles;
    property Created: TDateTime read FCreated write FCreated;
    property LastAccessed: TDateTime read FLastAccessed write FLastAccessed;
    constructor Create(AOwner: TComponent; const NodeID: HTreeItem; const NodeName: string; const Created, LastAccessed: TDateTime; const NodeType: word);
    destructor Destroy(); override;
  published
  end;

implementation

constructor TibcTreeNode.Create(AOwner: TComponent; const NodeID: HTreeItem; const NodeName: string; const NodeType: word);
begin
  inherited Create(AOwner);
  FNodeID := NodeID;
  FNodeName := NodeName;
  FNodeType := NodeType;
  FObjectList := TStringList.Create;
  FShowSystem := false;
end;

destructor TibcTreeNode.Destroy();
begin
  FObjectList.Free;
  inherited Destroy();
end;

constructor TibcServerNode.Create(AOwner: TComponent; const NodeID: HTreeItem; const NodeName,Servername,UserName,Password, Description: string; const Protocol: TProtocol; const LastAccessed: TDateTime; const NodeType: word);
begin
  inherited Create(AOwner,NodeID,NodeName,NodeType);
  FServername := Servername;
  FUserName := UserName;
  FPassword := Password;
  FVersion := 6;
  FServer := TIBServerProperties.Create(nil);
  FServer.ServerName := ServerName;
  FServer.Protocol := Protocol;
  FServer.LoginPrompt := false;
  FDescription := Description;
  FLastAccessed := LastAccessed;
  FOutputWindow := nil;
end;

destructor TibcServerNode.Destroy();
begin
  try
    if Self.Server.Active then
      FServer.Detach;
    FServer.Free;
  except on E: Exception do
    FServer.Free;
  end;
  inherited Destroy();
end;

constructor TibcDatabaseNode.Create(AOwner: TComponent; const NodeID: HTreeItem;
  const NodeName: string; const NodeType: word; const DatabaseFiles: TStringList;
  var NewDatabase: TIBDatabase);
var
  tmp: string;
begin
  inherited Create(AOwner,NodeID,NodeName,NodeType);

  FObjectViewer := nil;
  FDatabaseFiles := TStringList.Create;

  if not Assigned(NewDatabase) then
    FDatabase := TIBDatabase.Create(AOwner)
  else
    FDatabase := NewDatabase;

  FTransaction := TIBTransaction.Create(AOwner);
  FQryTransaction := TIBTransaction.Create(AOwner);
  FDataSet := TIBDataSet.Create (AOwner);
  FQryDataSet := TIBDataSet.Create (AOwner);
  FDataSource := TDataSource.Create (AOwner);
  FQryDataSource := TDataSource.Create (AOwner);
  FQuery := TIBSQL.Create(AOwner);
  FQuery.Database := FDatabase;
  FQuery.Transaction := FTransaction;

  with FDataSet do
  begin
    Database := FDatabase;
    Transaction := FTransaction;
    ObjectView := true;
    SparseArrays := true;
  end;

  with FQryDataSet do
  begin
    Database := FDatabase;
    Transaction := FQryTransaction;
    ObjectView := true;
    SparseArrays := true;
  end;

  FTransaction.DefaultDatabase := FDatabase;
  FQryTransaction.DefaultDatabase := FDatabase;
  FQryDataSource.DataSet := FQryDataset;

  FDataSource.DataSet := FDataSet;
  FDataSource.AutoEdit := false;

  FQuery.GoToFirstRecordOnExecute := true;
  FSQLBuffer := TStringList.Create;
  FSQLBufferPos := 0;
  FDatabaseFiles.Assign(DatabaseFiles);
  FDatabase.LoginPrompt := false;
  if FDatabaseFiles.Count > 0  then
  begin
    { Force the database to have a full path }
    if ExtractFilePath(FDatabaseFiles.Strings[0]) = '' then
    begin
      tmp := ExtractFilePath(Application.ExeName);
      FDatabase.DatabaseName := tmp + FDatabaseFiles.Strings[0];
    end
    else
      FDatabase.DatabaseName := FDatabaseFiles.Strings[0];
  end;
  FDatabase.DefaultTransaction := FTransaction;  
  
end;

procedure TibcDatabaseNode.CreateObjectViewer;
begin
  if not Assigned(FObjectViewer) then
    FObjectViewer := TfrmObjectView.Create(Application)
  else
    FObjectViewer.WindowState := wsNormal;
end;

destructor TibcDatabaseNode.Destroy();
begin
  if Assigned (FDatabase) and Assigned(FDatabase.Handle) then
  begin
    try
      FDatabase.Connected := false;
    except on E: Exception do
      FDatabase.Free;
    end;
  end;
  FSQLBuffer.Free;
  FDatabaseFiles.Free;
  FTransaction.Free;
  inherited Destroy();
end;

constructor TibcBackupAliasNode.Create(AOwner: TComponent; const NodeID: HTreeItem; const NodeName: string; const Created, LastAccessed: TDateTime; const NodeType: word);
begin
  inherited Create(AOwner,NodeID,NodeName,NodeType);
  FBackupFiles := TStringList.Create;
  FCreated := Created;
  FLastAccessed := LastAccessed
end;

destructor TibcBackupAliasNode.Destroy();
begin
  FBackupFiles.Free;
  inherited Destroy();
end;

procedure TibcServerNode.ShowText(const Data: TStringList;
  const Title: String; const readonly:boolean=true);
begin
  if not Assigned (FOutputwindow) then
    FOutputWindow := TfrmTextViewer.Create(Application);
  FOutputWindow.ShowText(Data, Title, Readonly);
end;

procedure TibcServerNode.OpenTextViewer(const Service: TIBControlAndQueryService;
  const Title: String; const readonly:boolean=true);
begin
  if not Assigned (FOutputwindow) then
    FOutputWindow := TfrmTextViewer.Create(Application);
  FOutputWindow.OpenTextViewer (Service, Title, readonly); 
end;

end.
