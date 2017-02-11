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
*  z l u G l o b a l
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit contains the declarations of global
*                variables/constants/objects
*
*****************************************************************
* Revisions:
*
*****************************************************************}

unit zluGlobal;

interface

Uses
  Windows, Graphics, classes;
type
  TAppSetting = record
    Name: String;
    Setting: variant;
  end;

  TFontProps = record
    FontName: String;
    FontSize: Integer;
    FontColor: TColor;
    FontStyle: TFontStyles;
    FontHeight: Integer;
  end;

  TASCIIChars = set of 0..255;
  TAppSettings = array[0..17] of TAppSetting;

var
  gExternalApps: TStringList;
  gApplShutdown: boolean;
  gWinTempPath: String;
  gApplExePath: string;
  gRegServersKey: string;
  gRegSettingsKey: string;
  gRegToolsKey: string;
  gAppSettings: TAppSettings;            // initialized in TfrmMain.FormCreate

const
  { Transactions }
  TRA_DDL = 1;  // ddl transaction
  TRA_DFLT = 2;  // default transaction

  { Number of nodes starting at 0 }
  NODES = 41;

  { Tree Nodes.  Must be in the same order as NODE_ARRAY below! }
  NODE_SERVERS = 000;
  NODE_SERVER = 001;
  NODE_DATABASES = 002;
  NODE_DATABASE = 003;
  NODE_BACKUP_ALIASES = 004;
  NODE_BACKUP_ALIAS = 005;
  NODE_USERS = 006;
  NODE_USER = 007;
  NODE_CERTIFICATES = 008;
  NODE_CERTIFICATE = 009;
  NODE_DOMAINS = 010;
  NODE_DOMAIN = 011;
  NODE_TABLES = 012;
  NODE_TABLE = 013;
  NODE_VIEWS = 014;
  NODE_VIEW = 015;
  NODE_PROCEDURES = 016;
  NODE_PROCEDURE = 017;
  NODE_FUNCTIONS = 018;
  NODE_FUNCTION = 019;
  NODE_GENERATORS = 020;
  NODE_GENERATOR = 021;
  NODE_EXCEPTIONS = 022;
  NODE_EXCEPTION = 023;
  NODE_BLOB_FILTERS = 024;
  NODE_BLOB_FILTER = 025;
  NODE_ROLES = 026;
  NODE_ROLE = 027;
  NODE_COLUMNS = 028;
  NODE_COLUMN = 029;
  NODE_INDEXES = 030;
  NODE_INDEX = 031;
  NODE_REFERENTIAL_CONSTRAINTS = 032;
  NODE_REFERENTIAL_CONSTRAINT = 033;
  NODE_UNIQUE_CONSTRAINTS = 034;
  NODE_UNIQUE_CONSTRAINT = 035;
  NODE_CHECK_CONSTRAINTS = 036;
  NODE_CHECK_CONSTRAINT = 037;
  NODE_TRIGGERS = 038;
  NODE_TRIGGER = 039;
  NODE_LOGS = 040;
  NODE_UNK = 999;

  { Image list indexes }
  NODE_SERVERS_INACTIVE_IMG = 1;
  NODE_DATABASES_DISCONNECTED_IMG = 2;
  NODE_BACKUP_ALIAS_IMG = 3;
  NODE_USER_IMG = 4;
  NODE_CERTIFICATE_IMG = 5;
  NODE_DOMAINS_IMG = 6;
  NODE_TABLES_IMG = 7;
  NODE_VIEWS_IMG = 8;
  NODE_PROCEDURES_IMG = 9;
  NODE_FUNCTIONS_IMG = 10;
  NODE_GENERATORS_IMG = 11;
  NODE_EXCEPTIONS_IMG = 12;
  NODE_BLOB_FILTERS_IMG = 13;
  NODE_ROLES_IMG = 14;
  NODE_COLUMNS_IMG = 15;
  NODE_INDEXES_IMG = 16;
  NODE_REFERENTIAL_CONSTRAINTS_IMG = 17;
  NODE_UNIQUE_CONSTRAINTS_IMG = 18;
  NODE_CHECK_CONSTRAINTS_IMG = 19;
  NODE_TRIGGERS_IMG = 20;
  NODE_UNK_IMG = 21;
  NODE_SERVERS_ACTIVE_IMG = 22;
  NODE_DATABASES_CONNECTED_IMG = 23;
  NODE_DATABASES_IMG = 24;
  NODE_BACKUP_ALIASES_IMG = 25;
  NODE_USERS_IMG = 26;
  NODE_CERTIFICATES_IMG = 27;
  NODE_LOGS_IMG = 29;
  IMG_GRANT_OPT = 46;

  { This array must be in the same order as the node constants above }
  NODE_ARRAY: array [0..NODES] of String = (
    'Servers',
    'Server',
    'Databases',
    'Database',
    'Backup',
    'Backup',
    'Users',
    'User',
    'Certificates',
    'Certificate',
    'Domains',
    'Domain',
    'Tables',
    'Table',
    'Views',
    'View',
    'Stored Procedures',
    'Stored Procedure',
    'External Functions',
    'External Function',
    'Generators',
    'Generator',
    'Exceptions',
    'Exception',
    'Blob Filters',
    'Blob Filter',
    'Roles',
    'Role',
    'Columns',
    'Column',
    'Indexes',
    'Index',
    'Referential Constraints',
    'Referential Constraint',
    'Unique Constraints',
    'Unique Constraint',
    'Check Constraints',
    'Check Constraint',
    'Triggers',
    'Trigger',
    'Server Log',
    'Unknown');

  DEL = '~|';
  SING_QUOTE = '''';

  APP_VERSION = 'Version 1.0';

  ENABLE = true;
  DISABLE = false;

  SUCCESS = 0;
  FAILURE = -1;
  EMPTY = -2;
  CANCELED = -3;
  RETRY = -4;
  REGISTER_SERVER = 0;
  SELECT_SERVER = 1;

  FROM_MEMORY = 'M';
  FROM_FILE = 'F';

  DEP_TABLE = 0;
  DEP_VIEW = 1;
  DEP_TRIGGER = 2;
  DEP_COMPUTED_FIELD = 3;
  DEP_VALIDATION = 4;
  DEP_PROCEDURE = 5;
  DEP_EXPRESSION_INDEX = 6;
  DEP_EXCEPTION = 7;
  DEP_USER = 8;
  DEP_FIELD = 9;
  DEP_INDEX = 10;

  NULL_STR = '<null>';
  NULL_BLOB = '(Blob)';
  BLOB_STR = '(BLOB)';

{ From jrd\obj.h ... object types }
  obj_relation =           0;
  obj_view     =           1;
  obj_trigger  =           2;
  obj_computed =           3;
  obj_validation =         4;
  obj_procedure  =         5;
  obj_expression_index =   6;
  obj_exception        =   7;
  obj_user             =   8;
  obj_field            =   9;
  obj_index            =   10;
  obj_count            =   11;
  obj_user_group       =   12;
  obj_sql_role         =   13;

  NUM_SETTINGS = 18;

{ This list must be in the same order as the
  constants below!}

  SETTINGS: array [0..NUM_SETTINGS-1] of String = (
{Boolean Options}
    'SystemData',
    'Dependencies',
    'UseDefaultEditor',
    'ShowQueryPlan',
    'AutoCommitDDL',
    'ShowStatistics',
    'ShowInListFormat',
    'SaveISQLOutput',
    'UpdateOnConnect',
    'UpdateOnCreate',
    'ClearInput',

{String Options}
    'CharacterSet',
    'BlobDisplay',
    'BlobSubtype',
    'ISQLTerminator',

{Integer Settings}
    'CommitOnExit',
    'ViewStyle',
    'DefaultDialect'
    );

{This list is grouped by datatypes.  Change it and
 things will break!}
{Boolean Settings}
  SYSTEM_DATA = 0;
  DEPENDENCIES = 1;
  USE_DEFAULT_EDITOR = 2;
  SHOW_QUERY_PLAN = 3;
  AUTO_COMMIT_DDL = 4;
  SHOW_STATS = 5;
  SHOW_LIST = 6;
  SAVE_ISQL_OUTPUT = 7;
  UPDATE_ON_CONNECT = 8;
  UPDATE_ON_CREATE = 9;
  CLEAR_INPUT = 10;

{String Settings}
  CHARACTER_SET = 11;
  BLOB_DISPLAY = 12;
  BLOB_SUBTYPE = 13;
  ISQL_TERMINATOR = 14;

{Integer Settings}
  COMMIT_ON_EXIT = 15;
  VIEW_STYLE = 16;
  DEFAULT_DIALECT = 17;

  TAB_ACTIONS = 0;
  TAB_DEFINITION = 1;
  TAB_SUMMARY = 2;
  TAB_METADATA = 3;
  TAB_DATA = 4;
  TAB_ISQL = 5;

implementation

end.
