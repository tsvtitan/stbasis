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
*  z l u D D L E x t r a c t i o n
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides all the necessary functions
*                to extract metadata from the various InterBase
*                database objects.
*
*****************************************************************
* Revisions:
*
*****************************************************************}

unit zluDDLExtraction;

interface

uses
  SysUtils, Classes, zluibcClasses, dmuMain, IB, frmuMessage, IBSql,
  zluUtility, zluGlobal, IBDatabase, IBDatabaseInfo;

type

function GetDDLBlobFilters(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean; const ObjName: String): boolean;
function GetDDLCheckConst(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
function GetDDLColumns(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
function GetDDLDatabase(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): boolean;
function GetDDLDomains(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean; const ObjName: String): boolean;
function GetDDLExceptions(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean; const ObjName: String): boolean;
function GetDDLFunctions(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean; const ObjName: String): boolean;
function GetDDLGenerators(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean; const ObjName: String): boolean;
function GetDDLIndexes(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
function GetDDLProcedures(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean; const ObjName: String): boolean;
function GetDDLReferentialConst(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
function GetDDLRoles(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean; const ObjName: String): boolean;
function GetDDLTable(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
function GetDDLTables(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): boolean;
function GetDDLTriggers(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
function GetDDLUniqueConst(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
function GetDDLViews(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean; const ObjName: String): boolean;
function GetDependencies(var Dependencies: TStringList; const SelDatabaseNode: TIBDatabase; const ObjectName:String; const ObjectType: Integer): integer;

implementation

const
  MAXSUBTYPES = 8;
  TERMINATOR = '!!';           // Define new terminator to use with procedures and triggers


  { Flags for RDB$FILE_FLAGS }
  FILE_shadow   = $01;
  FILE_inactive	= $02;
  FILE_manual   = $04;
  FILE_cache    = $08;
  FILE_conditional = $10;

  { flags for RDB$LOG_FILES }
  LOG_serial    = $01;
  LOG_default   = $02;
  LOG_raw       = $04;
  LOG_overflow  = $08;

  { flags for RDB$RELATIONS }
  REL_sql       = $01;

  { flags for RDB$TRIGGERS }
  TRG_sql          = $01
  TRG_ignore_perm  = $02;

{****************************************************************
*
*  G e t D D L B l o b F i l t e r s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for blob filters.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          Boolean (value)          - Specifies whether or not to include system data.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all blob filters in the database.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLBlobFilters(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase;
                           const SystemData: boolean; const ObjName: String): boolean;
var
  lSQLStr: string;
  lqryGetObjList: TIBSql;
begin
  // initialize
  lqryGetObjList := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // quert to get list of BLOB filters
    lqryGetObjList := TIBSql.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      lSQLStr := 'SELECT RDB$FUNCTION_NAME,RDB$MODULE_NAME,RDB$ENTRYPOINT,';
      lSQLStr := Format('%s RDB$INPUT_SUB_TYPE,RDB$OUTPUT_SUB_TYPE FROM RDB$FILTERS',[lSQLStr]);

      // if the system data menu item is selected then include system data in query
      if not SystemData then
      begin
        lSQLStr := Format('%s WHERE (RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL)',[lSQLStr]);
      end;

      if ObjName <> '' then
      begin
        if not SystemData then
          lSQLStr := Format('%s AND RDB$FUNCTION_NAME = ''%s''', [lSQLStr, ObjName])
        else
          lSQLStr := Format('%s WHERE RDB$FUNCTION_NAME = ''%s''', [lSQLStr, ObjName]);
      end;

      lSQLStr := Format('%s ORDER BY RDB$FUNCTION_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Prepare;
        ExecQuery;
        result := false;
        while not EOF do
        begin
          SQLScript.Add(Format('/*  Blob Filter: %s  */',[Trim(FieldbyName('RDB$FUNCTION_NAME').AsString)]));
          SQLScript.Add(Format('DECLARE FILTER %s ',[Trim(FieldbyName('RDB$FUNCTION_NAME').AsString)]));
          SQLScript.Add(Format('INPUT_TYPE %s OUTPUT_TYPE %s',[Trim(FieldbyName('RDB$INPUT_SUB_TYPE').AsString),Trim(FieldbyName('RDB$OUTPUT_SUB_TYPE').AsString)]));
          SQLScript.Add(Format('ENTRY_POINT ''%s'' MODULE_NAME ''%s''',[Trim(FieldbyName('RDB$ENTRYPOINT').AsString),Trim(FieldbyName('RDB$MODULE_NAME').AsString)]));

          SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + ';';
          SQLScript.Add(' ');
          Next;                                // increment lqryGetObjList pointer
          // return result as true
          result := true;
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch it and show error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close dataset and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjList.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L C h e c k C o n s t ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for check constraints.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          String (value)           - Specifies a table name.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all check constraints in a specified table.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLCheckConst(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
var
  lSQLStr: string;
  lqryGetObjList : TIBSQL;
  lqryGetObjDetails: TIBSQL;
begin
  lqryGetObjList := nil;
  lqryGetObjDetails := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query to get list of check constraints
    lqryGetObjList := TIBSql.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      // get check constraints and source
      lSQLStr := 'SELECT A.RDB$CONSTRAINT_NAME, A.RDB$TRIGGER_NAME, B.RDB$TRIGGER_NAME,';
      lSQLStr := Format('%s B.RDB$RELATION_NAME, B.RDB$TRIGGER_SOURCE, B.RDB$TRIGGER_TYPE FROM', [lSQLStr]);
      lSQLStr := Format('%s RDB$CHECK_CONSTRAINTS A, RDB$TRIGGERS B WHERE', [lSQLStr]);
      lSQLStr := Format('%s B.RDB$RELATION_NAME = ''%s''', [lSQLStr, TableName]);
      lSQLStr := Format('%s AND A.RDB$TRIGGER_NAME = B.RDB$TRIGGER_NAME AND', [lSQLStr]);
      lSQLStr := Format('%s B.RDB$TRIGGER_TYPE = 1', [lSQLStr]);
      lSQLStr := Format('%s ORDER BY RDB$CONSTRAINT_NAME ASC', [lSQLStr]);

      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Prepare;
        ExecQuery;
        result := false;
        while not EOF do
        begin
          // show check constraint source
          SQLScript.Add(Format('/*  Check Constraint: %s  */',[Trim(FieldbyName('RDB$CONSTRAINT_NAME').AsString)]));
          SQLScript.Add(Format('ALTER TABLE %s',[Trim(FieldbyName('RDB$RELATION_NAME').AsString)]));
          SQLScript.Add(FORMAT('  ADD CONSTRAINT %s', [Trim(FIeldByName('RDB$CONSTRAINT_NAME').AsString)]));
          SQLScript.Add(Format('  %s', [FIeldByName('RDB$TRIGGER_SOURCE').AsString]));

          SQLScript.Add(' ');
          Next;                                // increment lqryGetObjList pointer
          result := true;
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch it and show error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close datasets and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjDetails.Close;
    lqryGetObjList.Free;
  end;
end;
{****************************************************************
*
*  G e t D D L C o l u m n s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for columns.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          String (value)           - Specifies a table name.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all columns in a specified table.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLColumns(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
var
  lSQLStr: string;
  lStr: string;
  lqryGetObjList : TIBSQL;

begin
  // initialize
  lqryGetObjList := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query to get list of columns and details
    lqryGetObjList := TIBSql.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      lSQLStr:='SELECT A.RDB$FIELD_NAME, A.RDB$RELATION_NAME, A.RDB$NULL_FLAG NOTNULL,';
      lSQLStr:=Format('%s A.RDB$FIELD_POSITION, A.RDB$FIELD_SOURCE, B.RDB$COMPUTED_SOURCE,', [lSQLStr]);
      lSQLStr:=Format('%s A.RDB$DEFAULT_SOURCE DEF, B.RDB$FIELD_NAME, B.RDB$FIELD_TYPE,', [lSQLStr]);
      lSQLStr:=Format('%s B.RDB$FIELD_SUB_TYPE, B.RDB$SEGMENT_LENGTH, B.RDB$DIMENSIONS,', [lSQLStr]);
      lSQLStr:=Format('%s B.RDB$FIELD_LENGTH, B.RDB$FIELD_SCALE, B.CHARACTER_LENGTH, B.FIELD_PRECISION', [lSQLStr]);
      lSQLStr:=Format('%s FROM RDB$RELATION_FIELDS A, RDB$FIELDS B WHERE', [lSQLStr]);
      lSQLStr:=FOrmat('%s A.RDB$RELATION_NAME = ''%s'' AND', [lSQLStr, TableName]);
      lSQLStr:=Format('%s A.RDB$FIELD_SOURCE = B.RDB$FIELD_NAME', [lSQLStr]);
      lSQLStr := Format('%s ORDER BY RDB$FIELD_POSITION',[lSQLStr]);

      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Prepare;
        ExecQuery;
        result := false;
        while not EOF do
        begin
          // determine if current column is based on a domain or
          // natural data type and whether or not this is a computed column
          // if none of the above then determine the data type
          if (StrPos(PChar(FieldByName('RDB$FIELD_SOURCE').AsString), PChar('RDB$')) <> Nil) and
            (Trim(FieldByName('RDB$COMPUTED_SOURCE').AsString) = '') then
          begin
            if FieldByName('RDB$DIMENSIONS').AsInteger > 0 then
               GetArrayField(lStr, Database, Trim(FieldByName('RDB$FIELD_SOURCE').AsString));

            lStr := Format('%s %s',[lStr , GetFieldType (FieldByName('RDB$FIELD_TYPE').AsInteger,
                                                 FieldByName('RDB$FIELD_SUB_TYPE').AsInteger,
                                                 FieldByName('RDB$FIELD_LENGTH').AsInteger,
                                                 FieldByName('RDB$FIELD_SCALE').AsInteger,
                                                 FieldByName('RDB$CHARACTER_LENGTH').AsInteger,
                                                 FieldByName('RDB$FIELD_PRECISION').AsInteger)]);
          end // not a domain
          else
            if Trim(FieldByName('RDB$COMPUTED_SOURCE').AsString) <> '' then
              lStr:='COMPUTED BY ' + Trim(FieldByName('RDB$COMPUTED_SOURCE').AsString)
            else                               // otherwise use the domain as the datatype
              lStr:=Trim(FieldByName('RDB$FIELD_SOURCE').AsString);

          // add to script
          SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + lStr;

          // add default source, if any
          if not FieldByName('DEF').IsNull then
          begin
            SQLScript.Strings[SQLScript.Count - 1] :=
              SQLScript.Strings[SQLScript.Count - 1] + ' ' +
              Trim(FieldByName('DEF').AsString);
          end;

          // determine if column is NULL or NOT NULL
          if (not FieldByName('NOTNULL').IsNull) and
            (FieldByName('NOTNULL').AsInteger = 1) then
          begin
            SQLScript.Strings[SQLScript.Count - 1] :=
              SQLScript.Strings[SQLScript.Count - 1] + ' NOT NULL';
          end;

          SQLScript.Strings[SQLScript.Count - 1] :=
            SQLScript.Strings[SQLScript.Count - 1] + ';';

          SQLScript.Add(' ');
          Next;                                // increment lqryGetObjList pointer
          result := true;
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch it and show error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close datasets and deallocate memeory
    lqryGetObjList.Close;
    lqryGetObjList.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L D a t a b a s e ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for tables.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          Boolean (value)          - Specifies whether or not to include system data.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all tables in the database.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLDatabase(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): boolean;
var
  lStr: String;
  lCnt: integer;
  lRelations: TStringList;
  lQry: TIBSql;
  lDbInfo: TIBDatabaseInfo;

begin
  lRelations := TStringList.Create;
  try
    // Get a list of all the relations
    dmMain.GetTableList (lRelations, SelDatabaseNode, SystemData);

    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // show header
    lDbInfo := TIBDatabaseInfo.Create (nil);
    lDBInfo.Database := SelDatabaseNode;
    lStr := Format('/* CREATE DATABASE ''%s'' PAGE_SIZE %ld;', [SelDatabaseNode.DatabaseName, lDbInfo.PageSize ])

    lQry := TIBSql.Create (nil);
    with lQry do
    begin
      Transaction := SelDatabaseNode.DefaultTransaction;
      Database := SelDatabaseNode;
      SQL.Add ('select * from rdb$database where rdb$character_set_name is not null and rdb$character_set_name != '' ''');
      Prepare;
      ExecQuery;
      if not EOF then
        lStr := Format ('%s DEFAULT CHARACTER SET %s', [lStr, Trim(FieldByName('RDB$CHARACTER_SET'))]);
      Close;

      SQLSCript.Add(lStr);
      SQLScript.Add('');

      { Now list all secondary files and shadow files for the database }
      SQL.Clear;
      SQL.Add ('select * from rdb$files order by rdb$shadow_number, rdb$file_sequence');
      Prepare;
      ExecQuery;

      if not EOF then
        SQLScript.Add ('/* Add secondary files in comments');
      while not EOF do
      begin
        if (FieldByName('RDB$FILE_FLAGS').AsInteger = 0 then
        begin
          SQLSCript.Add (Format('ALTER DATABASE ADD FILE ''%s''',[Trim(FieldByName('RDB$FILE_NAME'))]));
          if not (FieldByName('RDB$FILE_START').IsNull) then
            SQLScript.Add (Format('STARTING %ld', [FieldByName('RDB$FILE_START').AsInteger]));

          if not (FieldByName('RDB$FILE_LENGTH').IsNull) then
            SQLScript.Add (Format('LENGTH %ld', [FieldByName('RDB$FILE_LENGTH').AsInteger]));
          Next;
          Continue;
        end;

        if (FieldByName('RDB$FILE_FLAGS').AsInteger and FILE_cache) then
        begin
          SqlScript.Add (Format('ALTER DATABASE ADD CACHE ''%s'' LENGTH %ld',[Trim(FieldByName('RDB$FILE_NAME')),
                                                                              FieldByName('RDB$FILE_LENGTH').AsInteger]));
          Next;
          Continue;
        end;

        if (FieldByName('RDB$FILE_FLAGS').AsInteger and FILE_shadow) then
        begin
          if FieldByName('RDB$FILE_SEQUENCE').AsInteger > 0 then
            SqlScript.Add (Format ('FILE ''%s''', [Trim(FieldByName('RDB$FILE_NAME').AsString])
          else
          begin
            lStr := Format ('CREATE SHADOW %d ''%s''', [FieldByName('RDB$SHADOW_NUMBER').AsInteger,
                                                        Trim(FieldByName('RDB$FILE_NAME').AsString)]);

            if FieldByName ('RDB$FILE_FLAGS').AsInteger and FILE_inactive) then
              lStr := Format ('%s INACITVE', [lStr]);

            if FieldByName ('RDB$FILE_FLAGS').AsInteger and FILE_manual) then
              lStr := Format ('%s MANUAL', [lStr])
            else
              lStr := Format ('%s AUTO', [lStr]);

            if FieldByName ('RDB$FILE_FLAGS').AsInteger and FILE_conditional) then
              lStr := Format ('%s CONDITIONAL', [lStr]);

            SqlScript.Add (lStr);
          end;

          if FieldByName('RDB$FILE_LENGTH').AsInteger > 0 then
            SqlScript.Add (Format ('LENGTH %ld', [FieldByName('RDB$FILE_LENGTH').AsInteger]));

          if FieldByName('RDB$FILE_START').AsInteger > 0 then
            SqlScript.Add (Format ('STARTING %ld', [FieldByName('RDB$FILE_START').AsInteger]));
          Next;
          Continue;
        end;
      end;
    end;


    GetDDLBlobFilters (SQLScript, SelDatabasenode, SystemData, '');
    GetDDLFunctions (SQLScript, SelDatabaseNode, SystemData, '');
    GetDDLDomains (SqlScript, SelDatabaseNode, SystemData, '');
    GetDDLTables (SQLScript, SeldatabaseNode, SystemData);

    { TODO : Extract all indexes }
    for lCnt := 0 to lRelations.Count - 1 do
      GetDDLIndexes (SqlScript, SeldatabaseNode, lRelations.Strings[lCnt]);

    { TODO : Extract foriegn keys }
    for lCnt := 0 to lRelations.Count - 1 do
      GetDDLUniqueConst (SQLScript, SelDatabaseNode, lRelations.Strings[lCnt]);

    for lCnt := 0 to lRelations.Count - 1 do
      GetDDLReferentialConst (SQLScript, SelDatabaseNode, lRelations.Strings[lCnt]);

    GetDDLGenerators (SQLScript, SeldatabaseNode, SystemData, '');
    GetDDLViews (SqlScript, SelDatabaseNode, SystemData, '');

    { TODO : Extract all check constraints }
    for lCnt := 0 to lRelations.Count - 1 do
      GetDDLCheckConst (SqlScript, SelDatabaseNode, lRelations.Strings[lCnt]);

    GetDDLExceptions (SqlScript, SelDatabaseNode, SystemData, '');
    GetDDLProcedures (SqlScript, SelDatabaseNode, SystemData, '');

    { TODO : Extract all triggers }
    for lCnt := 0 to lRelations.Count - 1 do
      GetDDLTriggers (SqlScript, SelDatabaseNode, lRelations.Strings[lCnt]);

    GetDDLRoles (SqlScript, SelDatabaseNode, SystemData, '');

    { TODO : Extract all permissions }
  finally
    lRelations.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L D o m a i n s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with domain metadata.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          Boolean (value)          - Specifies whether or not to include system data.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for domains.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
// Missing support for collation sequences
function GetDDLDomains(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase;
                       const SystemData: boolean; const ObjName: String): boolean;
var
  lStr, lSQLStr: string;
  lqryGetObjList: TIBSQL;

begin
  // initialize
  lqryGetObjList := nil;

  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query for field names
    lqryGetObjList := TIBSQL.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      // get all field names from the RDB$FIELDS system table
      lSQLStr := 'SELECT RDB$FIELD_NAME,RDB$FIELD_TYPE,RDB$FIELD_SUB_TYPE,RDB$FIELD_LENGTH,RDB$FIELD_SCALE,RDB$NULL_FLAG,RDB$SEGMENT_LENGTH,';
      lSQLStr := Format('%s RDB$DEFAULT_SOURCE,RDB$VALIDATION_SOURCE,RDB$DESCRIPTION,RDB$DIMENSIONS FROM RDB$FIELDS',[lSQLStr]);

      // check whether or not to include columns/domains belonging to system tables
      if not SystemData then
      begin
        lSQLStr := Format('%s WHERE (RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL)',[lSQLStr]);
      end;

      if ObjName <> '' then
      begin
        if not SystemData then
          lSQLStr := Format('%s AND RDB$FIELD_NAME = ''%s''', [lSQLStr, ObjName])
        else
          lSQLStr := Format('%s WHERE RDB$FIELD_NAME = ''%s''', [lSQLStr, ObjName]);
      end;

      lSQLStr := Format('%s ORDER BY RDB$FIELD_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Prepare;
        ExecQuery;
        result := false;
        while not EOF do
        begin
          // loop through list of fields (this is the reference point)
          SQLScript.Add(Format('/*  Type: %s  */',[Trim(FieldbyName('RDB$FIELD_NAME').AsString)]));
          SQLScript.Add(Format('CREATE DOMAIN %s AS ',[Trim(FieldbyName('RDB$FIELD_NAME').AsString)]));

          if FieldByName('RDB$DIMENSIONS').AsInteger > 0 then
             GetArrayField(lStr, Database, Trim(FieldByName('RDB$FIELD_SOURCE').AsString));

          lStr := Format('%s %s',[lStr , GetFieldType (FieldByName('RDB$FIELD_TYPE').AsInteger,
                                               FieldByName('RDB$FIELD_SUB_TYPE').AsInteger,
                                               FieldByName('RDB$FIELD_LENGTH').AsInteger,
                                               FieldByName('RDB$FIELD_SCALE').AsInteger,
                                               FieldByName('RDB$CHARACTER_LENGTH').AsInteger,
                                               FieldByName('RDB$FIELD_PRECISION').AsInteger)]);
          // add to script
          SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + lStr;

          // add default source, if any
          if not FieldByName('RDB$DEFAULT_SOURCE').IsNull then
          begin
            SQLScript.Strings[SQLScript.Count - 1] :=
              SQLScript.Strings[SQLScript.Count - 1] + ' ' +
              Trim(FieldByName('RDB$DEFAULT_SOURCE').AsString);
          end;

          // determine if column is NULL or NOT NULL
          if (not FieldByName('RDB$NULL_FLAG').IsNull) and
            (FieldByName('RDB$NULL_FLAG').AsInteger = 1) then
          begin
            SQLScript.Strings[SQLScript.Count - 1] :=
              SQLScript.Strings[SQLScript.Count - 1] + ' NOT NULL';
          end;

          SQLScript.Strings[SQLScript.Count - 1] :=
            SQLScript.Strings[SQLScript.Count - 1] + ';';

          SQLScript.Add(' ');
          Next;                                // increment lqryGetObjList pointer
          result := true;
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch it and display the error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close queries and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjList.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L E x c e p t i o n s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for exceptions.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          Boolean (value)          - Specifies whether or not to include system data.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all exceptions in the database.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLExceptions(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase;
                          const SystemData: boolean; const ObjName: String): boolean;
var
  lSQLStr: string;
  lqryGetObjList: TIBSql;
begin
  // initialize
  lqryGetObjList := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query to get list of exceptions
    lqryGetObjList := TIBSql.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      lSQLStr := 'SELECT RDB$EXCEPTION_NAME,RDB$MESSAGE FROM RDB$EXCEPTIONS';

      // if the system data menu item is selected then include system data in query
      if not SystemData then
      begin
        lSQLStr := Format('%s WHERE (RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL)',[lSQLStr]);
      end;

      if ObjName <> '' then
      begin
        if not SystemData then
          lSQLStr := Format('%s AND RDB$EXCEPTION_NAME = ''%s''', [lSQLStr, ObjName])
        else
          lSQLStr := Format('%s WHERE RDB$EXCEPTION_NAME = ''%s''', [lSQLStr, ObjName]);
      end;

      lSQLStr := Format('%s ORDER BY RDB$EXCEPTION_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Prepare;
        ExecQuery;
        result := false;
        while not EOF do
        begin
          // show header
          SQLScript.Add(Format('/*  Exception %s  */',[Trim(FieldbyName('RDB$EXCEPTION_NAME').AsString)]));
          SQLScript.Add(Format('CREATE EXCEPTION %s ''%s'';',[Trim(FieldbyName('RDB$EXCEPTION_NAME').AsString),
            Trim(FieldbyName('RDB$MESSAGE').AsString)]));
          SQLScript.Add(' ');
          Next;                                // increment lqryGetObhList pointer
          // return result as true
          result := true;
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch it and show error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close dataset and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjList.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L F u n c t i o n s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for functions.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          Boolean (value)          - Specifies whether or not to include system data.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all functions in the database.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLFunctions(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase;
                         const SystemData: boolean; const ObjName: String): boolean;
var
  lSQLStr   : string;
  lStr      : string;                  // temporary string
  lReturn   : string;                  // stores what functionr returns
  lFirst    : Boolean;

  lqryGetObjList : TIBSql;
  lqryGetObjDetails : TIBSql;
begin
  // initialize
  lqryGetObjList := nil;
  lqryGetObjDetails := nil;

  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query to get functions
    lqryGetObjList := TIBSql.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    // query to get function details
    lqryGetObjDetails := TIBSql.Create(dmMain);
    lqryGetObjDetails.Database := SelDatabaseNode;
    lqryGetObjDetails.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      lSQLStr := 'SELECT RDB$FUNCTION_NAME, RDB$MODULE_NAME, RDB$ENTRYPOINT ENTRY,';
      lSQLStr := Format('%s RDB$RETURN_ARGUMENT FROM RDB$FUNCTIONS', [lSQLStr]);

      // if the system data menu item is selected then include system data in query
      if not SystemData then
      begin
        lSQLStr := Format('%s WHERE (RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL)',[lSQLStr]);
      end;

      if ObjName <> '' then
      begin
        if not SystemData then
          lSQLStr := Format('%s AND RDB$FUNCTION_NAME = ''%s''', [lSQLStr, ObjName])
        else
          lSQLStr := Format('%s WHERE RDB$FUNCTION_NAME = ''%s''', [lSQLStr, ObjName]);
      end;

      lSQLStr := Format('%s ORDER BY RDB$FUNCTION_NAME', [lSQLStr]);

      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Prepare;
        ExecQuery;
        result := false;
        while not EOF do
        begin
          // loop through list of functions
          // this is the main compare loop
          lStr:='';
          // show header
          SQLScript.Add(Format('/*  Function: %s  */',[Trim(FieldbyName('RDB$FUNCTION_NAME').AsString)]));
          SQLScript.Add(Format('DECLARE EXTERNAL FUNCTION %s',[Trim(FieldbyName('RDB$FUNCTION_NAME').AsString)]));
          SQLScript.Add('  ');

          lFirst := True;

          // get function arguments
          lqryGetObjDetails.Close;
          lqryGetObjDetails.SQL.Clear;
          lqryGetObjDetails.SQL.Add('SELECT * FROM RDB$FUNCTION_ARGUMENTS');
          lqryGetObjDetails.SQL.Add(Format('WHERE RDB$FUNCTION_NAME = ''%s''',
            [Trim(FieldByName('RDB$FUNCTION_NAME').AsString)]));
          lqryGetObjDetails.SQL.Add('ORDER BY RDB$ARGUMENT_POSITION ASC');

          try
            with lQryGetObjDetails do
            begin
              lqryGetObjDetails.Prepare;
              lqryGetObjDetails.ExecQuery;
              while not lqryGetObjDetails.EOF do
              begin
                  // determine the data type of the arguements
                lStr := GetFieldType (FieldByName('RDB$FIELD_TYPE').AsInteger,
                                      FieldByName('RDB$FIELD_SUB_TYPE').AsInteger,
                                      FieldByName('RDB$FIELD_LENGTH').AsInteger,
                                      FieldByName('RDB$FIELD_SCALE').AsInteger,
                                      FieldByName('RDB$CHARACTER_LENGTH').AsInteger,
                                      FieldByName('RDB$FIELD_PRECISION').AsInteger);


                // first determine if the current argument is the return argument
                if FieldByName('RDB$ARGUMENT_POSITION').AsInteger =
                  FieldByName('RDB$RETURN_ARGUMENT').AsInteger then
                begin

                  // determine if the argument is passed by reference or by value
                  case FieldByName('RDB$MECHANISM').AsInteger of
                    0 : lReturn:=Format('  RETURNS %s BY VALUE', [lStr]);
                    1 : lReturn:=Format('  RETURNS %s BY REFERENCE', [lStr]);
                    else
                    begin
                      case FieldbyName('RDB$FIELD_TYPE').AsInteger of
                        261 :
                          lReturn:=Format('  %s RETURNS PARAMETER %s',[lStr, Trim(FieldByName('RDB$RETURN_ARGUMENT').AsString)]);
                        else
                          lReturn:=Format('  RETURNS %s %s',[lStr, Trim(FieldByName('RDB$MECHANISM').AsString)]);;
                      end;  // of case statement
                    end;  // of else not returned by reference or by value
                  end;
                end
                else
                begin
                  lFirst := False;
                  // if this is not the return argument then just add to script as argument
                  SQLScript.Strings[SQLScript.Count - 1] :=
                    SQLScript.Strings[SQLScript.Count - 1] + lStr;
                end;
                Next;        // increment the lqryGetObjDetails pointer

                // add a comma if this is not the first argument
                if (not lFirst) and (not lqryGetObjDetails.EOF) then
                  SQLScript.Strings[SQLScript.Count - 1] :=
                    SQLScript.Strings[SQLScript.Count - 1] + ', ';

                lFirst := False;
              end;
              // add return format and entry point to script
              SQLScript.Add(lReturn);
              SQLScript.Add(Format('  ENTRY_POINT "%s" MODULE_NAME "%s";',
                [Trim(FieldByName('ENTRY').AsString),
                Trim(FieldByName('RDB$MODULE_NAME').AsString)]));
            end;
          except
            on E:EIBError do
            begin
              // if an exception occurs then
              // return result as false
              result := false;
            end;
          end;
          SQLScript.Add(' ');
          Next;                                // increment the lqryGetObjList pointer
          result := true;                        // return result as true
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch hit and show error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close datasets and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjDetails.Close;
    lqryGetObjList.Free;
    lqryGetObjDetails.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L G e n e r a t o r s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for generators.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          Boolean (value)          - Specifies whether or not to include system data.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all generators in the database.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLGenerators(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase;
                          const SystemData: boolean; const ObjName: String): boolean;
var
  lSQLStr: string;
  lqryGetObjList: TIBSql;
  
begin
  // initialize
  lqryGetObjList := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query to get generator information
    lqryGetObjList := TIBSql.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      lSQLStr := 'SELECT RDB$GENERATOR_NAME FROM RDB$GENERATORS';

      // if the system data menu item is selected then include system data in query
      if not SystemData then
      begin
        lSQLStr := Format('%s WHERE (RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL)',[lSQLStr]);
      end;

      if ObjName <> '' then
      begin
        if not SystemData then
          lSQLStr := Format('%s AND RDB$GENERATOR_NAME = ''%s''', [lSQLStr, ObjName])
        else
          lSQLStr := Format('%s WHERE RDB$GENERATOR_NAME = ''%s''', [lSQLStr, ObjName]);
      end;

      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Prepare;
        ExecQuery;
        result := false;
        while not EOF do
        begin
          // show header
          SQLScript.Add(Format('/*  Generator: %s  */',[Trim(FieldbyName('RDB$GENERATOR_NAME').AsString)]));
          SQLScript.Add(Format('CREATE GENERATOR %s;',[Trim(FieldbyName('RDB$GENERATOR_NAME').AsString)]));
          SQLScript.Add(' ');
          Next;                                // increment lqryGetObjList pointer
          // return result as true
          result := true;
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch it and show error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close dataset and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjList.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L I n d i c e s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for indexes.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          String (value)           - Specifies a table name.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all indexes in a specified table.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLIndexes(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
var
  lSQLStr: string;
  lStr : string;
  lqryGetObjList : TIBSql;
  lqryGetObjDetails : TIBSql;
begin
  // initialize
  lqryGetObjList := nil;
  lqryGetObjDetails := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query to get list of indexes
    lqryGetObjList := TIBsql.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    // query to get index information
    lqryGetObjDetails := TIBsql.Create(dmMain);
    lqryGetObjDetails.Database := SelDatabaseNode;
    lqryGetObjDetails.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      // get all index information pertaining to specific table
      lSQLStr:='SELECT RDB$INDEX_NAME, RDB$RELATION_NAME, RDB$UNIQUE_FLAG, RDB$INDEX_TYPE FROM RDB$INDICES ';
      lSQLStr:=Format('%s WHERE RDB$RELATION_NAME = ''' + TableName + ''' ORDER BY RDB$INDEX_NAME', [lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Prepare;
        ExecQuery;
        result := false;
        while not EOF do
        begin
            lStr:='';
            // show header
            SQLScript.Add(Format('/*  Index: %s  */',[Trim(FieldbyName('RDB$INDEX_NAME').AsString)]));

            // if unique flag is set then add the UNIQUE token
            if FieldByName('RDB$UNIQUE_FLAG').AsInteger = 1 then
              lStr:=' UNIQUE';

            // determine if this index is ascending or descending
            if FieldByName('RDB$INDEX_TYPE').AsInteger = 1 then
              lStr:=lStr + ' DESCENDING'
            else
              lStr:=lStr + ' ASCENDING';

            // create script
            SQLScript.Add(Format('CREATE' + lStr + ' INDEX %s ON %s',
                [Trim(FieldbyName('RDB$INDEX_NAME').AsString),
                Trim(FieldByName('RDB$RELATION_NAME').AsString)]));

            // get index details
            lqryGetObjDetails.Close;
            lqryGetObjDetails.SQL.Clear;
            lqryGetObjDetails.SQL.Add('SELECT RDB$INDEX_NAME, RDB$FIELD_NAME, RDB$FIELD_POSITION');
            lqryGetObjDetails.SQL.Add(' FROM RDB$INDEX_SEGMENTS WHERE ');
            lqryGetObjDetails.SQL.Add(Format(' RDB$INDEX_NAME = ''%s'' ORDER BY RDB$FIELD_POSITION',
                [Trim(FieldbyName('RDB$INDEX_NAME').AsString)]));
            try
              with lqryGetObjDetails do
              begin
                Prepare;
                ExecQuery;
                if not EOF then
                  SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + ' (';
                while not EOF do
                begin
                  lStr:=Trim(lqryGetObjDetails.FieldByName('RDB$FIELD_NAME').AsString);
                  SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + lStr;
                  lqryGetObjDetails.Next;        // increment lqryObjDetails pointer

                  // if there are more fields then add comma
                  if Not lqryGetObjDetails.EOF then
                    SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + ', ';
                end;
                SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + '); ';
              end;
            except
              on E:EIBError do
              begin
                // if an exception occurs then catch it
                // return result as false
                result := false;
              end;
            end;

            SQLScript.Add(' ');
            Next;                                // increment lqryGetObjList pointer
          result := true;
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an except occurs then catch it and shoe error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close datasets and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjDetails.Close;
    lqryGetObjList.Free;
    lqryGetObjDetails.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L P r o c e d u r e s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for procedures.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          Boolean (value)          - Specifies whether or not to include system data.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all procedures in the database.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLProcedures(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase;
                          const SystemData: boolean; const ObjName: String): boolean;
var
  lStr, lSQLStr: string;
  lqryGetObjList : TIBSql;
  lqryGetObjDetails : TIBSql;
begin
  // initialize
  lqryGetObjList := nil;
  lqryGetObjDetails := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query to get list of procedures
    lqryGetObjList := TIBSql.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    // query to get procedure details
    lqryGetObjDetails := TIBsql.Create(dmMain);
    lqryGetObjDetails.Database := SelDatabaseNode;
    lqryGetObjDetails.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      lSQLStr := 'SELECT RDB$PROCEDURE_NAME,RDB$OWNER_NAME,RDB$PROCEDURE_SOURCE FROM RDB$PROCEDURES';

      // if the system data menu item is selected then include system data in query
      if not SystemData then
      begin
        lSQLStr := Format('%s WHERE (RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL)',[lSQLStr]);
      end;

      if ObjName <> '' then
      begin
        if not SystemData then
          lSQLStr := Format('%s AND RDB$PROCEDURE_NAME = ''%s''', [lSQLStr, ObjName])
        else
          lSQLStr := Format('%s WHERE RDB$PROCEDURE_NAME = ''%s''', [lSQLStr, ObjName]);
      end;

      lSQLStr := Format('%s ORDER BY RDB$PROCEDURE_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Prepare;
        ExecQuery;
        result := false;
        if not EOF then
        begin
          // set terminator to the terminator defined in TERMINATOR constant
          SQLScript.Add(Format('SET TERM %s ;', [TERMINATOR]));
          SQLScript.Add('');
        end;

          // get list of procedures
          // this is the main compare loop
        while not EOF do
          begin
            // show header
            SQLScript.Add(Format('/*  Procedure %s, Owner: %s  */',[Trim(FieldbyName('RDB$PROCEDURE_NAME').AsString),
              Trim(FieldbyName('RDB$OWNER_NAME').AsString)]));
            SQLScript.Add(Format('CREATE PROCEDURE %s ',[Trim(FieldbyName('RDB$PROCEDURE_NAME').AsString)]));

            // get input Parameters
            lqryGetObjDetails.Close;
            lqryGetObjDetails.SQL.Clear;
            lqryGetObjDetails.SQL.Add('SELECT A.RDB$PARAMETER_NAME,B.RDB$FIELD_TYPE,B.RDB$FIELD_SCALE,B.RDB$FIELD_LENGTH');
            lqryGetObjDetails.SQL.Add('FROM RDB$PROCEDURE_PARAMETERS A, RDB$FIELDS B');
            lqryGetObjDetails.SQL.Add('WHERE A.RDB$FIELD_SOURCE = B.RDB$FIELD_NAME');
            lqryGetObjDetails.SQL.Add(Format('AND A.RDB$PROCEDURE_NAME = ''%s''',[Trim(FieldbyName('RDB$PROCEDURE_NAME').AsString)]));
            lqryGetObjDetails.SQL.Add('AND A.RDB$PARAMETER_TYPE = 0');
            lqryGetObjDetails.SQL.Add('ORDER BY A.RDB$PARAMETER_NUMBER');
            try
              with lqryGetObjDetails do
              begin
                Prepare;
                ExecQuery;
                if not lqryGetObjDetails.EOF then
                  SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + ' (';

                while not EOF do
                begin
                  lStr := GetFieldType (FieldByName('RDB$FIELD_TYPE').AsInteger,
                                        FieldByName('RDB$FIELD_SUB_TYPE').AsInteger,
                                        FieldByName('RDB$FIELD_LENGTH').AsInteger,
                                        FieldByName('RDB$FIELD_SCALE').AsInteger,
                                        FieldByName('RDB$CHARACTER_LENGTH').AsInteger,
                                        FieldByName('RDB$FIELD_PRECISION').AsInteger);
                  SQLScript.Add(lStr+',');
                  Next;
                end;
                SQLScript.Strings[SQLScript.Count - 1] := Copy(SQLScript.Strings[SQLScript.Count - 1],1,Length(SQLScript.Strings[SQLScript.Count - 1]) - 1 ) + ')';
                Close;
              end;
            except
              on E:EIBError do
              begin
                // if an exception occurs then catch it
                // return result as false
                result := false;
              end;
            end;

            // get output parameters
            lqryGetObjDetails.Close;
            lqryGetObjDetails.SQL.Clear;
            lqryGetObjDetails.SQL.Add('SELECT A.RDB$PARAMETER_NAME,B.RDB$FIELD_TYPE,B.RDB$FIELD_SCALE,B.RDB$FIELD_LENGTH');
            lqryGetObjDetails.SQL.Add('FROM RDB$PROCEDURE_PARAMETERS A, RDB$FIELDS B');
            lqryGetObjDetails.SQL.Add('WHERE A.RDB$FIELD_SOURCE = B.RDB$FIELD_NAME');
            lqryGetObjDetails.SQL.Add(Format('AND A.RDB$PROCEDURE_NAME = ''%s''',[Trim(FieldbyName('RDB$PROCEDURE_NAME').AsString)]));
            lqryGetObjDetails.SQL.Add('AND A.RDB$PARAMETER_TYPE = 1');
            lqryGetObjDetails.SQL.Add('ORDER BY A.RDB$PARAMETER_NUMBER');

            try
              with lqryGetObjDetails do
              begin
                Prepare;
                ExecQuery;
                if not lqryGetObjDetails.EOF then
                  SQLScript.Add('RETURNS (');

                while not EOF do
                begin
                  lStr := GetFieldType (FieldByName('RDB$FIELD_TYPE').AsInteger,
                                        FieldByName('RDB$FIELD_SUB_TYPE').AsInteger,
                                        FieldByName('RDB$FIELD_LENGTH').AsInteger,
                                        FieldByName('RDB$FIELD_SCALE').AsInteger,
                                        FieldByName('RDB$CHARACTER_LENGTH').AsInteger,
                                        FieldByName('RDB$FIELD_PRECISION').AsInteger);
                  SQLScript.Add(lStr+',');
                  Next;
                end;
                SQLScript.Strings[SQLScript.Count - 1] := Copy(SQLScript.Strings[SQLScript.Count - 1],1,Length(SQLScript.Strings[SQLScript.Count - 1]) - 1 ) + ')';
                Close;
              end;
            except
              on E:EIBError do
              begin
                // if an exception occurs then catch it
                // return result as false
                result := false;
              end;
            end;
            SQLScript.Add(Format('AS %s',[Trim(FieldbyName('RDB$PROCEDURE_SOURCE').AsString)]));
            Next;                                // increment the lqryGetObjList pointer
            SQLScript.Strings[SQLScript.Count - 1] :=
              SQLScript.Strings[SQLScript.Count - 1] + TERMINATOR;
            SQLScript.Add(' ');                  // add new terminator to end of procedure definition
          // reset the terminator
          SQLScript.Add(Format('COMMIT WORK%s', [TERMINATOR]));
          SQLScript.Add(Format('SET TERM ; %s', [TERMINATOR]));
          result := true;
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch it and display error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close datasets and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjDetails.Close;
    lqryGetObjList.Free;
    lqryGetObjDetails.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L R e f e r e n t i a l C o n s t ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for referential constraints.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          String (value)           - Specifies a table name.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all referential constraints in a specified table.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLReferentialConst(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
var
  lSQLStr: string;
  lStr: string;
  lqryGetObjList : TIBSql;
  lqryGetObjDetails : TIBSql;
begin
  // initialize
  lqryGetObjList := nil;
  lqryGetObjDetails := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query to get referential constraints
    lqryGetObjList := TIBSql.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    // query to get child and parent columns that are
    // part of the referential constraint
    lqryGetObjDetails := TIBSql.Create(dmMain);
    lqryGetObjDetails.Database := SelDatabaseNode;
    lqryGetObjDetails.Transaction := SelDatabaseNode.DefaultTransaction;

    try
      // get columns that are part of the referential constraint
      lqryGetObjDetails.Close;
      lqryGetObjDetails.SQL.Clear;
      lqryGetObjDetails.SQL.Add('SELECT RDB$INDEX_NAME, RDB$FIELD_NAME,');
      lqryGetObjDetails.SQL.Add('RDB$FIELD_POSITION FROM RDB$INDEX_SEGMENTS');
      lqryGetObjDetails.SQL.Add('ORDER BY RDB$INDEX_NAME, RDB$FIELD_POSITION');
      lqryGetObjDetails.Prepare;
      lqryGetObjDetails.ExecQuery;
    except
      on E:EIBError do
      begin
        // if an exception occurs then catch it and show error message
        // return result as false
        DisplayMsg(ERR_GET_DDL, E.Message);
        result := false;
      end;
    end;

    with lqryGetObjList do
    begin
      // get list of referential constraints pertaining to a specific table
      lSQLStr:='SELECT A.RDB$CONSTRAINT_NAME, A.RDB$CONSTRAINT_TYPE, A.RDB$RELATION_NAME,';
      lSQLStr:=Format('%s A.RDB$INDEX_NAME, B.RDB$INDEX_NAME, B.RDB$RELATION_NAME,', [lSQLStr]);
      lSQLStr:=Format('%s B.RDB$FOREIGN_KEY, C.RDB$FOREIGN_KEY, C.RDB$RELATION_NAME PARENT', [lSQLStr]);
      lSQLStr:=Format('%s FROM RDB$RELATION_CONSTRAINTS A, RDB$INDICES B, RDB$INDICES C', [lSQLStr]);
      lSQLStr:=Format('%s WHERE A.RDB$RELATION_NAME=''%s'' AND', [lSQLStr, TableName]);
      lSQLStr:=Format('%s B.RDB$RELATION_NAME=''%s'' AND', [lSQLStr, TableName]);
      lSQLStr:=Format('%s A.RDB$CONSTRAINT_TYPE=''FOREIGN KEY'' AND', [lSQLStr]);
      lSQLStr:=Format('%s B.RDB$FOREIGN_KEY = C.RDB$INDEX_NAME AND', [lSQLStr]);
      lSQLStr:=Format('%s A.RDB$INDEX_NAME=B.RDB$INDEX_NAME', [lSQLStr]);
      lSQLStr:=Format('%s ORDER BY A.RDB$CONSTRAINT_NAME', [lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Prepare;
        ExecQuery;
        result := false;
        while not EOF do
        begin
          SQLScript.Add(Format('/*  Foreign Key: %s  */',[Trim(FieldbyName('RDB$CONSTRAINT_NAME').AsString)]));
          SQLScript.Add(Format('ALTER TABLE %s ',[Trim(FieldbyName('RDB$RELATION_NAME').AsString)]));
          SQLScript.Add(Format('  ADD CONSTRAINT %s',[Trim(FieldbyName('RDB$CONSTRAINT_NAME').AsString)]));
          SQLScript.Add('  FOREIGN KEY');
          lStr:='';
          try
            // get child columns
            lqryGetObjDetails.ExecQuery;

            // increment pointer to first child column in referential constaint
            while (not lqryGetObjDetails.EOF) and
              (Trim(FieldByName('RDB$INDEX_NAME').AsString) <> Trim(lqryGetObjDetails.FieldByName('RDB$INDEX_NAME').AsString)) do
              lqryGetObjDetails.Next;

            // determine whether or not at end of dataset
            if not lqryGetObjDetails.EOF then
              SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + '(';

            // loop though list of constraint details
            while (not lqryGetObjDetails.EOF) and
              (Trim(FieldByName('RDB$INDEX_NAME').AsString) = Trim(lqryGetObjDetails.FieldByName('RDB$INDEX_NAME').AsString)) do
            begin
              // store first child column
              lStr:=Trim(lqryGetObjDetails.FieldByName('RDB$FIELD_NAME').AsString);

              lqryGetObjDetails.Next;          // increment lqryGetObjDetails pointer

              // add child column to script
              SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + lStr;

              // if there are more child columns then add a comma between them
              if (not lqryGetObjDetails.EOF) and
                (Trim(FieldByName('RDB$INDEX_NAME').AsString) = Trim(lqryGetObjDetails.FieldByName('RDB$INDEX_NAME').AsString))
                then
                SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + ', ';
            end;
            SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + ') ';
            SQLScript.Add(Format('  REFERENCES %s', [Trim(FieldByName('PARENT').AsString)]));

            // Get parent columns
            lqryGetObjDetails.ExecQuery;
            // increment pointer to first parent column in referential constaint
            while (not lqryGetObjDetails.EOF) and
              (Trim(FieldByName('RDB$FOREIGN_KEY').AsString) <> Trim(lqryGetObjDetails.FieldByName('RDB$INDEX_NAME').AsString)) do
              lqryGetObjDetails.Next;

            // determine whether or not at end of dataset
            if not lqryGetObjDetails.EOF then
              SQLScript[SQLScript.Count - 1] := SQLScript[SQLScript.Count - 1] + '(';

            // loop though list of constraint details
            while (not lqryGetObjDetails.EOF) and
              (Trim(FieldByName('RDB$FOREIGN_KEY').AsString) = Trim(lqryGetObjDetails.FieldByName('RDB$INDEX_NAME').AsString)) do
            begin
              // store first parent column
              lStr:=Trim(lqryGetObjDetails.FieldByName('RDB$FIELD_NAME').AsString);

              lqryGetObjDetails.Next;          // increment lqryGetObjDetails pointer

              // add parent column to script
              SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + lStr;

              // if there are more parent columns then add a comma between them
              if (not lqryGetObjDetails.EOF) and
                (Trim(FieldByName('RDB$FOREIGN_KEY').AsString) = Trim(lqryGetObjDetails.FieldByName('RDB$INDEX_NAME').AsString))
                then
                SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + ', ';

            end;
            SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + ');';
          except
            on E:EIBError do
            begin
              // if an exception occurs then catch it
              // return result as false
              result := false;
            end;
          end;

          SQLScript.Add(' ');
          Next;                                // increment lqryGetObjList pointer
          result := true;
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch it and show error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close datasets and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjDetails.Close;
    lqryGetObjList.Free;
    lqryGetObjDetails.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L D D L R o l e s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for roles.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          Boolean (value)          - Specifies whether or not to include system data.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all roles in the database.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLRoles(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase;
                     const SystemData: boolean; const ObjName: String): boolean;
var
  lSQLStr: String;
  lqryGetObjList: TIBSql;
  lqryGetObjDetails: TIBSql;
  lTableName : String;
  lUserName : String;
  lGrantOption : Integer;
  lStr : String;

begin
  // initialize
  lqryGetObjList := nil;
  lqryGetObjDetails := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query to get list of roles
    lqryGetObjList := TIBSql.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    // query to get array information
    lqryGetObjDetails := TIBSql.Create(dmMain);
    lqryGetObjDetails.Database := SelDatabaseNode;
    lqryGetObjDetails.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      lSQLStr := 'SELECT RDB$ROLE_NAME,RDB$OWNER_NAME';
      lSQLStr := Format('%s FROM RDB$ROLES',[lSQLStr]);

      if ObjName <> '' then
          lSQLStr := Format('%s WHERE RDB$ROLE_NAME = ''%s''', [lSQLStr, ObjName]);

      lSQLStr := Format('%s ORDER BY RDB$OWNER_NAME, RDB$ROLE_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Prepare;
        ExecQuery;
        result := false;
        while not EOF do
        begin
          SQLScript.Add(Format('/*  Role: %s, Owner: %s  */',[Trim(FieldbyName('RDB$ROLE_NAME').AsString),
            Trim(FieldbyName('RDB$OWNER_NAME').AsString)]));
          SQLScript.Add(Format('CREATE ROLE %s;',[Trim(FieldbyName('RDB$ROLE_NAME').AsString)]));
          SQLScript.Add('');

          lqryGetObjDetails.SQL.Clear;
          lqryGetObjDetails.SQL.Add('SELECT * FROM RDB$USER_PRIVILEGES');
          lqryGetObjDetails.SQL.Add('WHERE RDB$RELATION_NAME NOT LIKE ''RDB$%''');
          lqryGetObjDetails.SQL.Add('AND RDB$USER <> ''SYSDBA'' AND RDB$USER <> RDB$GRANTOR');
          lqryGetObjDetails.SQL.Add(Format('AND RDB$USER = ''%s''', [Trim(FieldbyName('RDB$ROLE_NAME').AsString)]));
          lqryGetObjDetails.SQL.Add('ORDER BY RDB$OBJECT_TYPE, RDB$RELATION_NAME, RDB$USER, RDB$PRIVILEGE');

          try
            lqryGetObjDetails.Prepare;
            lqryGetObjDetails.ExecQuery;

            if not lqryGetObjDetails.EOF then
            begin
              lStr:='';
              SQLScript.Add(Format('/*  SQL Privileges for Role %s  */', [Trim(FieldbyName('RDB$ROLE_NAME').AsString)]));
            end;

            while not lqryGetObjDetails.EOF do
            begin
            // determine the privilege
              if Trim(lqryGetObjDetails.FieldByName('RDB$PRIVILEGE').AsString) = 'X' then
              begin
                lStr:='EXECUTE';
                SQLScript.Add(Format('GRANT EXECUTE ON PROCEDURE %s TO %s;',
                  [Trim(lqryGetObjDetails.FieldByName('RDB$RELATION_NAME').AsString),
                  Trim(lqryGetObjDetails.FieldByName('RDB$USER').AsString)]));
                lStr:='';
                Continue;
              end;

              if Trim(lqryGetObjDetails.FieldByName('RDB$PRIVILEGE').AsString) = 'D' then
                lStr:=lStr + 'DELETE'
              else if Trim(lqryGetObjDetails.FieldByName('RDB$PRIVILEGE').AsString) = 'S' then
                lStr:=lStr + 'SELECT'
              else if Trim(lqryGetObjDetails.FieldByName('RDB$PRIVILEGE').AsString) = 'U' then
                lStr:=lStr + 'UPDATE'
              else if Trim(lqryGetObjDetails.FieldByName('RDB$PRIVILEGE').AsString) = 'I' then
                lStr:=lStr + 'INSERT'
              else if Trim(lqryGetObjDetails.FieldByName('RDB$PRIVILEGE').AsString) = 'R' then
                lStr:=lStr + 'REFERENCES';

              // store tablename, username, grant options and object type
              lTableName:=Trim(lqryGetObjDetails.FieldByName('RDB$RELATION_NAME').AsString);
              lUserName:=Trim(lqryGetObjDetails.FieldByName('RDB$USER').AsString);
              lGrantOption:=lqryGetObjDetails.FieldByName('RDB$GRANT_OPTION').AsInteger;
              // lObjectType:=lqryGetObjDetails.FieldByName('RDB$OBJECT_TYPE').AsInteger;

              lqryGetObjDetails.Next;                                // increment lqryGetObjList

              if (lStr <> '') and
                ((lTableName <> Trim(lqryGetObjDetails.FieldByName('RDB$RELATION_NAME').AsString))
                or (lqryGetObjDetails.Eof)) then
              begin
                if lStr <> '' then
                  lStr:=lStr + ' ON ';

                // determine grant option
                SQLScript.Add(Format('GRANT %s%s TO %s', [lStr, lTableName, lUserName]));
                case lGrantOption of
                  0 : SQLScript[SQLScript.Count - 1] := SQLScript[SQLScript.Count - 1] + ';';
                  1 : SQLScript[SQLScript.Count - 1] := SQLScript[SQLScript.Count - 1] + ' WITH GRANT OPTION;';
                  2 : SQLScript[SQLScript.Count - 1] := SQLScript[SQLScript.Count - 1] + ' WITH ADMIN OPTION;';
                end;
                lStr:='';
              end;

              // add comma between privileges
              if lStr <> '' then
                lStr:=lStr + ', ';
            end;
          except
            on E:EIBError do
            begin
              // if an exception occurs then catch it and show error message
              // return result as false
              DisplayMsg(ERR_GET_DDL, E.Message);
              result := false;
            end;
          end;
          Next;                                // increment lqryGetObjList pointer
          result := true;
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch it and show error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close dataset and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjDetails.Close;
    lqryGetObjList.Free;
    lqryGetObjDetails.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L T a b l e ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for one table.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          String (value)           - Specifies a table name.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for a specified table.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLTable(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
var
  lQry: TIBSql;
  lSQLStr: string;
  lCnt: integer;
  lDomains: TStringList;
begin
  lDomains := TStringList.Create;
  GetDDLDomains (lDomains, SelDatabaseNode, False, TableName);

  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    lQry := TIBSQL.Create (dmMain);

    // show header
    SQLScript.Add(Format('/*  Extract Table %s  */', [TableName]));
    SQLScript.Add('');
    SQLScript.Add('/*  Domain Definitions  */');
    SQLSCript.Add('');
    for lCnt := 0 to lDomains.Count-1 do
      SQLSCript.Add (lDomains.Strings[lCnt]);

    SQLScript.Add('');

    // extract column information
    with lQry do
    begin
      lQry.Transaction := SeldatabaseNode.DefaultTransaction;
      lQry.Database := SeldatabaseNode;

      lSQLStr := 'SELECT RDB$RELATION_NAME,RDB$OWNER_NAME,RDB$DESCRIPTION FROM RDB$RELATIONS';
      lSQLStr := Format('%s WHERE RDB$RELATION_NAME NOT IN (',[lSQLStr]);
      lSQLStr := Format('%s SELECT RDB$VIEW_NAME FROM RDB$VIEW_RELATIONS)',[lSQLStr]);

      lQry.SQL.Add (lSQlStr);

      Prepare;
      ExecQuery;
      // show header
      SQLScript.Add(Format('/*  Table: %s, Owner: %s  */',[TableName, Trim(FieldByName('RDB$OWNER_NAME').AsString)]));
      SQLScript.Add(Format('CREATE TABLE %s ',[TableName]));
      SQLScript.Add('(');
      Close;
      Free;
    end;
    GetDDLColumns (SQLScript, SelDatabaseNode, TableName);
  finally
    lDomains.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L T a b l e s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for tables.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          Boolean (value)          - Specifies whether or not to include system data.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all tables in the database.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLTables(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): boolean;
var
  lSQLStr : string;
  lStr : string;
  lTok : string;                                 // token to search for when filtering out domains
  lTableName : string;                           // stores previous tablename
  lLastTable : string;
  lUsername : string;
  lGrantOption : Integer;
  lObjectType : Integer;
  lHeader : Boolean;                             // specifies whether or not to print a section header
  lDuplicates : TStringList;                     // stores duplicate domain entries
  lqryGetObjList : TIBSql;
  lqryGetObjDetails : TIBSql;
  lqryGetObjDimensions : TIBSql;
  lqryGetObjIndexes : TIBSql;
  lqryGetObjPrimary : TIBSql;
begin
  // initialize
  lqryGetObjList := nil;
  lqryGetObjDimensions := nil;
  lqryGetObjIndexes := nil;
  lqryGetObjPrimary := nil;
  lqryGetObjDetails := nil;
  lDuplicates := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // stringlist to store duplicate domains
    lDuplicates:=TStringList.Create;
    lDuplicates.Clear;

    // query to get list of tables
    lqryGetObjList := TIBSql.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    // query to get array dimensions
    lqryGetObjDimensions := TIBSql.Create(dmMain);
    lqryGetObjDimensions.Database := SelDatabaseNode;
    lqryGetObjDimensions.Transaction := SelDatabaseNode.DefaultTransaction;

    // query to get a list of indexes
    lqryGetObjIndexes := TIBSql.Create(dmMain);
    lqryGetObjIndexes.Database := SelDatabaseNode;
    lqryGetObjIndexes.Transaction := SelDatabaseNode.DefaultTransaction;

    // query to get primary key information
    lqryGetObjPrimary := TIBSql.Create(dmMain);
    lqryGetObjPrimary.Database := SelDatabaseNode;
    lqryGetObjPrimary.Transaction := SelDatabaseNode.DefaultTransaction;

    // query to get sql priviliges
    lqryGetObjDetails := TIBSql.Create(dmMain);
    lqryGetObjDetails.Database := SelDatabaseNode;
    lqryGetObjDetails.Transaction := SelDatabaseNode.DefaultTransaction;

    try
      // get a list of fields/domains
      lqryGetObjDimensions.SQL.Clear;
      lqryGetObjDimensions.SQL.Add('SELECT RDB$FIELD_NAME, RDB$DIMENSION, RDB$LOWER_BOUND, ');
      lqryGetObjDimensions.SQL.Add('RDB$UPPER_BOUND FROM RDB$FIELD_DIMENSIONS');
      lqryGetObjDimensions.SQL.ADD('ORDER BY RDB$FIELD_NAME, RDB$DIMENSION');
      lqryGetObjDimensions.Prepare;
      lqryGetObjDimensions.ExecQuery;

      // get a list of indexes
      lqryGetObjIndexes.SQL.Clear;
      lqryGetObjIndexes.SQL.Add('SELECT A.RDB$CONSTRAINT_NAME, A.RDB$RELATION_NAME, A.RDB$CONSTRAINT_TYPE,');
      lqryGetObjIndexes.SQL.Add('A.RDB$INDEX_NAME, B.RDB$INDEX_NAME, B.RDB$FIELD_NAME, B.RDB$FIELD_POSITION');
      lqryGetObjIndexes.SQL.Add('FROM RDB$RELATION_CONSTRAINTS A, RDB$INDEX_SEGMENTS B');
      lqryGetObjIndexes.SQL.Add('WHERE A.RDB$INDEX_NAME = B.RDB$INDEX_NAME AND');
      lqryGetObjIndexes.SQL.Add('A.RDB$CONSTRAINT_TYPE = ''UNIQUE''');
      lqryGetObjIndexes.SQL.Add('ORDER BY A.RDB$RELATION_NAME, B.RDB$FIELD_POSITION');
      lqryGetObjIndexes.Prepare;
      lqryGetObjIndexes.Execquery;

      // get a list of primary key columns
      lqryGetObjPrimary.SQL.Clear;
      lqryGetObjPrimary.SQL.Add('SELECT A.RDB$RELATION_NAME, A.RDB$CONSTRAINT_TYPE, A.RDB$INDEX_NAME,');
      lqryGetObjPrimary.SQL.Add('B.RDB$INDEX_NAME, B.RDB$FIELD_NAME, B.RDB$FIELD_POSITION');
      lqryGetObjPrimary.SQL.Add('FROM RDB$RELATION_CONSTRAINTS A, RDB$INDEX_SEGMENTS B');
      lqryGetObjPrimary.SQL.Add('WHERE A.RDB$INDEX_NAME = B.RDB$INDEX_NAME AND');
      lqryGetObjPrimary.SQL.Add('A.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY''');
      lqryGetObjPrimary.SQL.Add('ORDER BY A.RDB$RELATION_NAME, B.RDB$FIELD_POSITION');
      lqryGetObjPrimary.Prepare;
      lqryGetObjPrimary.ExecQuery;

      // get a list of sql prviliges
      lqryGetObjDetails.SQL.Clear;
      lqryGetObjDetails.SQL.Add('SELECT * FROM RDB$USER_PRIVILEGES');
      lqryGetObjDetails.SQL.Add('WHERE RDB$RELATION_NAME NOT LIKE ''RDB$%''');
      lqryGetObjDetails.SQL.Add('AND RDB$USER <> ''SYSDBA'' AND RDB$USER <> RDB$GRANTOR');
      lqryGetObjDetails.SQL.Add('AND RDB$OBJECT_TYPE = 0');
      lqryGetObjDetails.SQL.Add('ORDER BY RDB$OBJECT_TYPE, RDB$RELATION_NAME, RDB$USER, RDB$PRIVILEGE');
      lqryGetObjDetails.Prepare;
      lqryGetObjDetails.ExecQuery;
    except
      on E:EIBError do
      begin
        DisplayMsg(ERR_GET_DDL, E.Message);
        result := false;
      end;
    end;

    // determine which domains must be created before the table
    with lqryGetObjList do
    begin
      // get list of tables and their columns
      lSQLStr:='SELECT A.RDB$FIELD_NAME, A.RDB$RELATION_NAME, A.RDB$NULL_FLAG NOTNULL, A.RDB$FIELD_POSITION,';
      lSQLStr:=Format('%s A.RDB$DEFAULT_SOURCE DEF, A.RDB$FIELD_SOURCE, B.RDB$FIELD_NAME, B.RDB$NULL_FLAG DOMNULL,', [lSQLStr]);
      lSQLStr:=FOrmat('%s B.RDB$DIMENSIONS, B.RDB$FIELD_TYPE, B.RDB$VALIDATION_SOURCE,', [lSQLStr]);
      lSQLStr:=Format('%s B.RDB$FIELD_SUB_TYPE, B.RDB$SEGMENT_LENGTH, B.RDB$COMPUTED_SOURCE,', [lSQLStr]);
      lSQLStr:=Format('%s B.RDB$FIELD_LENGTH, B.RDB$FIELD_SCALE, C.RDB$OWNER_NAME', [lSQLStr]);
      lSQLStr:=Format('%s FROM RDB$RELATION_FIELDS A, RDB$FIELDS B, RDB$RELATIONS C WHERE', [lSQLStr]);

      // check whether or not to include system data
      if not SystemData then
      begin
        lSQLStr:=Format('%s B.RDB$SYSTEM_FLAG <> 1 AND', [lSQLStr]);
        SQLScript.Add('/*  Extract All Tables (Not Including System Tables)  */');
        lTok:='RDB$';                            // prefix signifies an InterBase created domain
      end
      else
      begin
        SQLScript.Add('/*  Extract All Tables (Including System Tables)  */');
        lTok:='';
      end;

      lSQLStr:=Format('%s A.RDB$FIELD_SOURCE = B.RDB$FIELD_NAME AND', [lSQLStr]);
      lSQLStr:=Format('%s A.RDB$RELATION_NAME = C.RDB$RELATION_NAME', [lSQLStr]);
      lSQLStr:=Format('%s AND C.RDB$VIEW_SOURCE IS NULL', [lSQLStr]);
      lSQLStr := Format('%s ORDER BY A.RDB$RELATION_NAME, RDB$FIELD_POSITION', [lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        // open dataset and place cursor at the beginning
        Prepare;
        ExecQuery;
        lHeader:=False;
        while not EOF do
        begin
          // loop through list of domains, if lTok = 'RDB$' then do not show system data
          if StrPos(PChar(FieldByName('RDB$FIELD_SOURCE').AsString), PChar(lTok)) = Nil then
          begin
            // if lHeader is false then add the Domain Definitions header to script
            if not lHeader then
            begin
              lHeader:=True;
              SQLScript.Add('/*  Domain Definitions  */');
            end;

            // check if this domain has already been acknowledged - if not then add to script
            // duplicate domains will be added to the lDuplicates stringlist
            if lDuplicates.IndexOf(Trim(FieldbyName('RDB$FIELD_SOURCE').AsString)) = -1 then
            begin
              SQLScript.Add(Format('CREATE DOMAIN %s AS ',[Trim(FieldbyName('RDB$FIELD_SOURCE').AsString)]));
              GetDDLDomains (SQLScript, SeldatabaseNode, SystemData, Trim(FieldbyName('RDB$FIELD_SOURCE').AsString);
              lDuplicates.Add(Trim(FieldByName('RDB$FIELD_SOURCE').AsString));
            end;
          end;
          Next;                                  // increment lqryGetObjList pointer
        end;
        // return result as true
        Result:=True;
      except
        on E:EIBError do
        begin
          // if an exception occurs catch it and display error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;

    // extract column information
    with lqryGetObjList do
    begin
      try
        SQLScript.Add('');
        if not EOF then
        begin
          SQLScript.Add(Format('/*  Table: %s, Owner: %s  */',[Trim(FieldByName('RDB$RELATION_NAME').AsString), Trim(FieldByName('RDB$OWNER_NAME').AsString)]));
          SQLScript.Add(Format('CREATE TABLE %s ',[Trim(FieldByName('RDB$RELATION_NAME').AsString)]));
          SQLScript.Add('(');
          SQLScript.Add('  ');
          // store current table name
          lLastTable:=Trim(FieldByName('RDB$RELATION_NAME').AsString);
          while not EOF do
          begin
          GetDDLColumns (SqlScript, SeldatabaseNode, lLastTable);

          // loop through list of tables and columns
          repeat
          begin
            Next;                                // increment lqryGetObjList pointer

            // start getting index information once all field type data has
            // been extracted for the specific table
            if (lLastTable <> Trim(FieldByName('RDB$RELATION_NAME').AsString)) and (not EOF) then
            begin
              // extract unique index information
              with lqryGetObjIndexes do
              begin
                try
                  First;

                  // advance pointer to first index associated with the current table
                  while (not EOF) and (lLastTable <> Trim(FieldByName('RDB$RELATION_NAME').AsString)) do
                    Next;

                  // if an index associated with the current table is found then add to script
                  if (not EOF) and (lLastTable = Trim(lqryGetObjIndexes.FieldByName('RDB$RELATION_NAME').AsString)) then
                  begin
                    // determine if there is a column name present
                    if FieldByName('RDB$FIELD_NAME').AsString <> '' then
                    begin
                      // add a comma to the last line in the script
                      SQLScript[SQLScript.Count - 1] :=
                        SQLScript[SQLScript.Count - 1] + ',';

                      // determine if the unique constraint has a user defined name
                      // if so then add it to script
                      if StrPos(PChar(FieldByName('RDB$CONSTRAINT_NAME').AsString), PChar('INTEG')) = Nil then
                        lStr:='  CONSTRAINT UNIQUE ' + Trim(FIeldByName('RDB$CONSTRAINT_NAME').AsString) + ' ('
                      else
                        lStr:='  UNIQUE (';

                      // keep adding column names to temporary string
                      while (not EOF) and (lLastTable = Trim(FieldByName('RDB$RELATION_NAME').AsString)) do
                      begin
                        lStr:=lStr + Trim(FieldByName('RDB$FIELD_NAME').AsString);
                        Next;                    // increment lqryGetObjIndices pointer
                        // if there is more column information then put a comma between them
                        if (not EOF) and (lLastTable = Trim(FieldByName('RDB$RELATION_NAME').AsString)) then
                          lStr:=lStr + ', ';
                      end;
                      lStr:=lStr + ')';
                      SQLScript.Add(lStr);
                    end;
                  end;
                  Result:=True;                  // return result as true
                except
                  on E:EIBError do
                  begin
                    // if an exception occurs then catch it
                    // return result as false
                    DisplayMsg(ERR_GET_DDL, E.Message);
                    result := false;
                  end;
                end;
              end;

              // once all the field and unique index information has been gathered
              // extract primary key information
              with lqryGetObjPrimary do
              begin
                try
                  First;

                  // advance pointer to first primary key column associated with the current table
                  while (not EOF) and (lLastTable <> Trim(FieldByName('RDB$RELATION_NAME').AsString)) do
                    Next;

                  // make sure information is for the current table and the data set is not at the end
                  if (not EOF) and (lLastTable = Trim(FieldByName('RDB$RELATION_NAME').AsString)) then
                  begin
                    // if there is information present then add comma to previous line in script
                    if FieldByName('RDB$FIELD_NAME').AsString <> '' then
                    begin
                      SQLScript[SQLScript.Count - 1] :=
                        SQLScript[SQLScript.Count - 1] + ',';
                      lStr:='  PRIMARY KEY (';

                      // keep adding primary key columns
                      while (not EOF) and (lLastTable = Trim(FieldByName('RDB$RELATION_NAME').AsString)) do
                      begin
                        lStr:=lStr + Trim(FieldByName('RDB$FIELD_NAME').AsString);
                        Next;                    // increment lqryGetObjPrimary pointer

                        // if there is another primary key column then place a comma between them
                        if (not EOF) and (lLastTable = Trim(FieldByName('RDB$RELATION_NAME').AsString)) then
                          lStr:=lStr + ', ';
                      end;
                      lStr:=lStr + ')';
                      SQLScript.Add(lStr);
                    end;
                  end;
                  // return result as true
                  Result:=True;
                except
                  on E:EIBError do
                  begin
                    // if an exception occurs then catch it
                    // return result as false
                    DisplayMsg(ERR_GET_DDL, E.Message);
                    result := false;
                  end;
                end;
              end;

              // store next table name
              //lLastTable:=Trim(FieldByName('RDB$RELATION_NAME').AsString);
              SQLScript.Add(');');
              SQLScript.Add('');

              // add SQL privileges - while not EOF, also checks for privileges when EOF later
              with lqryGetObjDetails do
              begin
                First;
                while (not EOF) and (lLastTable <> Trim(FieldByName('RDB$RELATION_NAME').AsString)) do
                  Next;
                try
                // show header
                  if not EOF then
                  begin
                    lStr:='';
                    SQLScript.Add(Format('/*  SQL Privileges for Table %s  */', [lLastTable]));

                    // get permissions for all objects except procedures
                    while (not EOF) and (lLastTable = Trim(FieldByName('RDB$RELATION_NAME').AsString)) do
                    begin
                      // determine the privilege
                      if Trim(FieldByName('RDB$PRIVILEGE').AsString) = 'D' then
                        lStr:=lStr + 'DELETE'
                      else if Trim(FieldByName('RDB$PRIVILEGE').AsString) = 'S' then
                        lStr:=lStr + 'SELECT'
                      else if Trim(FieldByName('RDB$PRIVILEGE').AsString) = 'U' then
                        lStr:=lStr + 'UPDATE'
                      else if Trim(FieldByName('RDB$PRIVILEGE').AsString) = 'I' then
                        lStr:=lStr + 'INSERT'
                      else if Trim(FieldByName('RDB$PRIVILEGE').AsString) = 'R' then
                        lStr:=lStr + 'REFERENCES';

                      // store tablename, username, grant options and object type
                      lTableName:=Trim(FieldByName('RDB$RELATION_NAME').AsString);
                      lUserName:=Trim(FieldByName('RDB$USER').AsString);
                      lGrantOption:=FieldByName('RDB$GRANT_OPTION').AsInteger;
                      lObjectType:=FieldByName('RDB$OBJECT_TYPE').AsInteger;

                      Next;              // increment lqryGetObjList

                      // if no longer the same table, user, grant option or
                      // object is a role then add to script
                      if ((lTableName <> Trim(FieldByName('RDB$RELATION_NAME').AsString)) or
                        (lUserName <> Trim(FieldByName('RDB$USER').AsString)) or
                        (lGrantOption <> FieldByName('RDB$GRANT_OPTION').AsInteger)) and
                        (lStr <> '') and (lObjectType = 0) or EOF then
                      begin
                        if lStr <> '' then
                          lStr:=lStr + ' ON ';

                        // determine grant option
                        SQLScript.Add(Format('GRANT %s%s TO %s', [lStr, lTableName, lUserName]));
                        case lGrantOption of
                          0 :
                          begin
                            SQLScript[SQLScript.Count - 1] := SQLScript[SQLScript.Count - 1] + ';';
                          end;
                          1 :
                          begin
                            SQLScript[SQLScript.Count - 1] :=
                              SQLScript[SQLScript.Count - 1] + ' WITH GRANT OPTION;';
                          end;
                          2 :
                          begin
                            SQLScript[SQLScript.Count - 1] :=
                              SQLScript[SQLScript.Count - 1] + ' WITH ADMIN OPTION;';
                          end;
                        end;
                        lStr:='';
                      end;

                      // add comma between privileges
                      if lStr <> '' then
                        lStr:=lStr + ', ';
                    end;
                    SQLScript.Add('');
                  end;
                except
                  on E:EIBError do
                  begin
                    // if an exception occurs then catch it and show error message
                    // return result as false
                    DisplayMsg(ERR_GET_DDL, E.Message);
                    result := false;
                  end;
                end;
              end;

              lLastTable:=Trim(FieldByName('RDB$RELATION_NAME').AsString);

              // start header for next table
              SQLScript.Add(Format('/*  Table: %s, Owner: %s  */',[Trim(FieldByName('RDB$RELATION_NAME').AsString), Trim(FieldByName('RDB$OWNER_NAME').AsString)]));
              SQLScript.Add(Format('CREATE TABLE %s ',[Trim(FieldByName('RDB$RELATION_NAME').AsString)]));
              SQLScript.Add('(');
              SQLScript.Add('  ');

            end
            else if (lLastTable = Trim(FieldByName('RDB$RELATION_NAME').AsString)) and (not EOF) then
            begin
              // if same table then there is more column information, add a comma
              SQLScript.Strings[SQLScript.Count - 1] :=
                SQLScript.Strings[SQLScript.Count - 1] + ',';
              SQLScript.Add('  ');
            end
            else if EOF then
            begin
              SQLScript.Add(');');
              SQLScript.Add('');

              // add SQL priviliges - check for SQL privileges when EOF
              with lqryGetObjDetails do
              begin
                First;

                while (not EOF) and (lLastTable <> Trim(FieldByName('RDB$RELATION_NAME').AsString)) do
                  Next;

                try
                  // show header
                  if not EOF then
                  begin
                    lStr:='';
                    SQLScript.Add(Format('/*  SQL Privileges for Table %s  */', [lLastTable]));

                    // get permissions for all objects except procedures
                    while (not EOF) and (lLastTable = Trim(FieldByName('RDB$RELATION_NAME').AsString)) do
                    begin

                      // determine the privilege
                      if Trim(FieldByName('RDB$PRIVILEGE').AsString) = 'D' then
                        lStr:=lStr + 'DELETE'
                      else if Trim(FieldByName('RDB$PRIVILEGE').AsString) = 'S' then
                        lStr:=lStr + 'SELECT'
                      else if Trim(FieldByName('RDB$PRIVILEGE').AsString) = 'U' then
                        lStr:=lStr + 'UPDATE'
                      else if Trim(FieldByName('RDB$PRIVILEGE').AsString) = 'I' then
                        lStr:=lStr + 'INSERT'
                      else if Trim(FieldByName('RDB$PRIVILEGE').AsString) = 'R' then
                        lStr:=lStr + 'REFERENCES';

                      // store tablename, username, grant options and object type
                      lTableName:=Trim(FieldByName('RDB$RELATION_NAME').AsString);
                      lUserName:=Trim(FieldByName('RDB$USER').AsString);
                      lGrantOption:=FieldByName('RDB$GRANT_OPTION').AsInteger;
                      lObjectType:=FieldByName('RDB$OBJECT_TYPE').AsInteger;

                      Next;              // increment lqryGetObjList

                      // if no longer the same table, user, grant option or
                      // object is a role then add to script
                      if ((lTableName <> Trim(FieldByName('RDB$RELATION_NAME').AsString)) or
                        (lUserName <> Trim(FieldByName('RDB$USER').AsString)) or
                        (lGrantOption <> FieldByName('RDB$GRANT_OPTION').AsInteger)) and
                        (lStr <> '') and (lObjectType = 0) or EOF then
                      begin
                        if lStr <> '' then
                          lStr:=lStr + ' ON ';

                        // determine grant option
                        SQLScript.Add(Format('GRANT %s%s TO %s', [lStr, lTableName, lUserName]));
                        case lGrantOption of
                          0 :
                          begin
                            SQLScript[SQLScript.Count - 1] := SQLScript[SQLScript.Count - 1] + ';';
                          end;
                          1 :
                          begin
                            SQLScript[SQLScript.Count - 1] :=
                              SQLScript[SQLScript.Count - 1] + ' WITH GRANT OPTION;';
                          end;
                          2 :
                          begin
                            SQLScript[SQLScript.Count - 1] :=
                              SQLScript[SQLScript.Count - 1] + ' WITH ADMIN OPTION;';
                          end;
                        end;
                        lStr:='';
                      end;

                      // add comma between privileges
                      if lStr <> '' then
                        lStr:=lStr + ', ';

                    end;
                    SQLScript.Add('');
                  end;
                except
                  on E:EIBError do
                  begin
                    // if an exception occurs then catch it and show error message
                    // return result as false
                    DisplayMsg(ERR_GET_DDL, E.Message);
                    result := false;
                  end;
                end;  // of try block
              end;  // of with lqryGetObjDetails
            end;  // of else EOF
          end;
          until EOF;
          // return result as true
          result := true;
        end
        else
        begin
          // if there is no column information then return result as false
          result := false;
        end;
        Close;                                   // close lqryGetObjList
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch it and show error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close queries and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjDimensions.Close;
    lqryGetObjIndexes.Close;
    lqryGetObjPrimary.Close;
    lqryGetObjDetails.Close;
    lqryGetObjList.Free;
    lqryGetObjDimensions.Free;
    lqryGetObjIndexes.Free;
    lqryGetObjPrimary.Free;
    lqryGetObjDetails.Free;
    lDuplicates.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L T r i g g e r s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for triggers.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          String (value)           - Specifies a table name.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all triggers in a specified table.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLTriggers(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
var
  lSQLStr: string;
  lTriggerType: string;
  lqryGetObjList : TIBQuery;
  lqryGetObjDetails: TIBQuery;
begin
  // initialize
  lqryGetObjList := nil;
  lqryGetObjDetails := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query to get triggers
    lqryGetObjList := TIBQuery.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    // NOT USED
    lqryGetObjDetails := TIBQuery.Create(dmMain);
    lqryGetObjDetails.Database := SelDatabaseNode;
    lqryGetObjDetails.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      // get trigger list and trigger source
      lSQLStr := 'SELECT RDB$TRIGGER_NAME,RDB$RELATION_NAME,RDB$TRIGGER_SEQUENCE,RDB$TRIGGER_TYPE,';
      lSQLStr := Format('%s RDB$TRIGGER_SOURCE FROM RDB$TRIGGERS WHERE', [lSQLStr]);
      lSQLStr := Format('%s RDB$RELATION_NAME = ''' + TableName + ''' ORDER BY RDB$TRIGGER_NAME', [lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Open;
        if not EOF then
        begin
          // set script terminator to terminator defined in TERMINATOR constant
          SQLScript.Add(Format('SET TERM %s ;', [TERMINATOR]));
          SQLScript.Add('');

          // loop through list
          repeat
          begin
            // show header
            SQLScript.Add(Format('/*  Trigger: %s  */',[Trim(FieldbyName('RDB$TRIGGER_NAME').AsString)]));
            SQLScript.Add(Format('CREATE TRIGGER %s FOR %s',
                [Trim(FieldbyName('RDB$TRIGGER_NAME').AsString),
                Trim(FieldByName('RDB$RELATION_NAME').AsString)]));

            // determine when trigger is fired
            case FieldbyName('RDB$TRIGGER_TYPE').AsInteger of
              1: lTriggerType := ' BEFORE INSERT';
              2: lTriggerType := ' AFTER INSERT';
              3: lTriggerType := ' BEFORE UPDATE';
              4: lTriggerType := ' AFTER UPDATE';
              5: lTriggerType := ' BEFORE DELETE';
              6: lTriggerType := ' AFTER DELETE';
            else
              lTriggerType := '';
            end;

            // add position
            SQLScript.Strings[SQLScript.Count - 1] :=
              SQLScript.Strings[SQLScript.Count - 1] + lTriggerType +
              ' POSITION ' + FieldByName('RDB$TRIGGER_SEQUENCE').AsString + ' ';

            // add trigger source
            SQLScript.Add(Trim(FieldByName('RDB$TRIGGER_SOURCE').AsString));

            // add new terminator at the end
            SQLScript.Strings[SQLScript.Count - 1] :=
              SQLScript.Strings[SQLScript.Count - 1] + TERMINATOR;

            SQLScript.Add(' ');
            Next;
          end;
          until EOF;
          // reset script terminator
          SQLScript.Add(Format('COMMIT WORK%s', [TERMINATOR]));
          SQLScript.Add(Format('SET TERM ; %s', [TERMINATOR]));
          // return result as true
          result := true;
        end
        else
        begin
          // if there are no triggers
          // return result as false
          result := false;
        end;
        Close;
        except
          on E:EIBError do
          begin
            // if an exception occurs then catch it and show error message
            // return result as false
            DisplayMsg(ERR_GET_DDL, E.Message);
            result := false;
          end;
      end;
    end;
  finally
    // close all datasets and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjDetails.Close;
    lqryGetObjList.Free;
    lqryGetObjDetails.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L U n i q u e C o n s t ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for unique constraints.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          String (value)           - Specifies a table name.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all unique constraints in a specified table.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLUniqueConst(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): boolean;
var
  lSQLStr: string;
  lStr     : string;
  lqryGetObjList : TIBQuery;
  lqryGetObjDetails: TIBQuery;
begin
  // initialize
  lqryGetObjList := nil;
  lqryGetObjDetails := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query to get list of unique constraints
    lqryGetObjList := TIBQuery.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    // query to get columns participating in unique constraints
    lqryGetObjDetails := TIBQuery.Create(dmMain);
    lqryGetObjDetails.Database := SelDatabaseNode;
    lqryGetObjDetails.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      // get list of unique constraints
      lSQLStr := 'SELECT RDB$CONSTRAINT_NAME, RDB$RELATION_NAME, RDB$INDEX_NAME FROM';
      lSQLStr := Format('%s RDB$RELATION_CONSTRAINTS WHERE RDB$CONSTRAINT_TYPE = ''UNIQUE''', [lSQLStr]);
      lSQLStr := Format('%s AND RDB$RELATION_NAME = ''' + TableName + '''', [lSQLStr]);
      lSQLStr := Format('%s ORDER BY RDB$CONSTRAINT_NAME ASC', [lSQLStr]);

      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Open;
        if not EOF then
        begin
          // loop through list of unique constraints
          // this is the main compare loop
          repeat
          begin
            lStr:='';
            // show header
            SQLScript.Add(Format('/*  Unique Constraint: %s  */',[Trim(FieldbyName('RDB$CONSTRAINT_NAME').AsString)]));
            SQLScript.Add(Format('ALTER TABLE %s',[Trim(FieldbyName('RDB$RELATION_NAME').AsString)]));
            SQLScript.Add(FORMAT('  ADD CONSTRAINT %s', [Trim(FIeldByName('RDB$CONSTRAINT_NAME').AsString)]));
            SQLScript.Add('  UNIQUE');

            // get columns participating in unique constraint
            lqryGetObjDetails.Close;
            lqryGetObjDetails.SQL.Clear;
            lqryGetObjDetails.SQL.Add('SELECT * FROM RDB$INDEX_SEGMENTS WHERE ');
            lqryGetObjDetails.SQL.Add(Format('RDB$INDEX_NAME = ''%s''', [Trim(lqryGetObjList.FieldByName('RDB$INDEX_NAME').AsString)]));
            lqryGetObjDetails.SQL.Add('ORDER BY RDB$FIELD_POSITION ASC');
            try
              lqryGetObjDetails.Open;
              if not lqryGetObjDetails.EOF then
              begin
                SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + ' (';
                // loop through details
                repeat
                begin
                  // add column to script
                  lStr:=Trim(lqryGetObjDetails.FieldByName('RDB$FIELD_NAME').AsString);
                  SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + lStr;

                  lqryGetObjDetails.Next;        // increment lqryGetObjDetails pointer

                  // if there are more columns in list then add a comma
                  if Not lqryGetObjDetails.EOF then
                    SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + ', ';

                end;
                until lqryGetObjDetails.EOF;
                SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + '); ';
              end;
            except
              on E:EIBError do
              begin
                // if an exception occurs then
                // resturn result as false
                result := false;
              end;
            end;

            SQLScript.Add(' ');
            Next;                                // increment lqryGetObjList pointer
          end;
          until EOF;
          // return result as true
          result := true;
        end
        else
        begin
          // if there are no unique constraints
          // return result as false
          result := false;
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch it and show error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close datasets and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjDetails.Close;
    lqryGetObjList.Free;
    lqryGetObjDetails.Free;
  end;
end;

{****************************************************************
*
*  G e t D D L V i e w s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  TStringList (variable)   - Gets populated with metadata for views.
*          TibcDatabaseNode (value) - Specifies the target database/transaction.
*          Boolean (value)          - Specifies whether or not to include system data.
*
*  Return: Boolean - Indicates the success/failure of the operation
*
*  Description:  Retrieves metadata for all views in the database.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDDLViews(var SQLScript: TStringList; const SelDatabaseNode: TIBDatabase;
                     const SystemData: boolean; const ObjName: String): boolean;
var
  lSQLStr: string;
  lqryGetObjList : TIBQuery;
  lqryGetObjDetails : TIBQuery;
begin
  // initialize
  lqryGetObjList := nil;
  lqryGetObjDetails := nil;
  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query to get list of views
    lqryGetObjList := TIBQuery.Create(dmMain);
    lqryGetObjList.Database := SelDatabaseNode;
    lqryGetObjList.Transaction := SelDatabaseNode.DefaultTransaction;

    // query to get details for a specific view
    lqryGetObjDetails := TIBQuery.Create(dmMain);
    lqryGetObjDetails.Database := SelDatabaseNode;
    lqryGetObjDetails.Transaction := SelDatabaseNode.DefaultTransaction;

    with lqryGetObjList do
    begin
      // get list of views
      // this is the main compare loop
      lSQLStr := 'SELECT DISTINCT A.RDB$RELATION_NAME,A.RDB$OWNER_NAME,A.RDB$VIEW_SOURCE';
      lSQLStr := Format('%s FROM RDB$RELATIONS A, RDB$VIEW_RELATIONS B', [lSQLStr]);
      lSQLStr := Format('%s WHERE A.RDB$RELATION_NAME = B.RDB$VIEW_NAME', [lSQLStr]);

      if ObjName <> '' then
      begin
        lSQLStr := Format('%s AND B.RDB$VIEW_NAME = ''%s''', [lSQLStr, ObjName])
      end;

      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        Open;
        if not EOF then
        begin
          repeat
          begin
            // show header
            SQLScript.Add(Format('/*  View: %s, Owner: %s */',[Trim(FieldbyName('RDB$RELATION_NAME').AsString),Trim(FieldbyName('RDB$OWNER_NAME').AsString)]));
            SQLScript.Add(Format('CREATE VIEW %s (',[Trim(FieldbyName('RDB$RELATION_NAME').AsString)]));

            // set up query to retrieve view information
            lqryGetObjDetails.Close;
            lqryGetObjDetails.SQL.Clear;
            lqryGetObjDetails.SQL.Add('SELECT RDB$FIELD_NAME,RDB$FIELD_POSITION FROM RDB$RELATION_FIELDS');
            lqryGetObjDetails.SQL.Add(Format('WHERE RDB$RELATION_NAME = ''%s'' ORDER BY RDB$FIELD_POSITION',[Trim(FieldbyName('RDB$RELATION_NAME').AsString)]));
            try
              lqryGetObjDetails.Open;
              if not lqryGetObjDetails.EOF then
              begin
                // loop through query details
                repeat
                begin
                  SQLScript.Strings[SQLScript.Count - 1] := Format('%s %s,',[SQLScript.Strings[SQLScript.Count - 1],Trim(lqryGetObjDetails.FieldByName('RDB$FIELD_NAME').AsString)]);
                  lqryGetObjDetails.Next;        // increment lqryGetObjDetails pointer
                end;
                until lqryGetObjDetails.EOF;
                SQLScript.Strings[SQLScript.Count - 1] := Copy(SQLScript.Strings[SQLScript.Count - 1],1,Length(SQLScript.Strings[SQLScript.Count - 1]) - 1);
              end;
            except
              on E:EIBError do
              begin
                // if an exception occurs then catch it
                // return result as false
                result := false;
              end;
            end;
            // add to script
            SQLScript.Add(Format(') AS %s',[Trim(FieldbyName('RDB$VIEW_SOURCE').AsString)]));
            SQLScript.Strings[SQLScript.Count - 1] := SQLScript.Strings[SQLScript.Count - 1] + ';';
            SQLScript.Add(' ');
            Next;
          end;
          until EOF;
          // return result as true
          result := true;
        end
        else
        begin
          // if no detail information then return result as false
          result := false;
        end;
        Close;
      except
        on E:EIBError do
        begin
          // if an exception occurs then catch it and show error message
          // return result as false
          DisplayMsg(ERR_GET_DDL, E.Message);
          result := false;
        end;
      end;
    end;
  finally
    // close datasets and deallocate memory
    lqryGetObjList.Close;
    lqryGetObjDetails.Close;
    lqryGetObjList.Free;
    lqryGetObjDetails.Free;
  end;
end;

{****************************************************************
*
*  G e t D e p e n d e n c i e s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Dependencies - A list containing object details
*          SelDatabaseNode - The database to be queried
*          ObjectName - The object to be queried
*          TypeId - The type of the object
*
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of dependencies for the specified object
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetDependencies(var Dependencies: TStringList; const SelDatabaseNode: TIBDatabase;
  const ObjectName: string; const ObjectType: Integer): integer;
var
  lDependenciesType: string;
  lqryDependencies: TIBQuery;
begin
  // initialize
  lqryDependencies := nil;
//  Dependencies.Add(Format('Name%sType',[DEL]));

  try
    if not SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.StartTransaction;

    // query for object dependencies
    lqryDependencies := TIBQuery.Create(dmMain);
    lqryDependencies.Database := SelDatabaseNode;
    lqryDependencies.Transaction := SelDatabaseNode.DefaultTransaction;

     with lqryDependencies do
     begin
       if ObjectType = DEP_COMPUTED_FIELD then // if Computed field
       begin
         SQL.Add('SELECT RDB$DEPENDENT_NAME,RDB$DEPENDENT_TYPE FROM RDB$DEPENDENCIES');
         SQL.Add('WHERE RDB$FIELD_NAME = :ObjectName');
         SQL.Add('GROUP BY RDB$DEPENDENT_NAME,RDB$DEPENDENT_TYPE');
         SQL.Add('ORDER BY RDB$DEPENDENT_NAME,RDB$DEPENDENT_TYPE');
         Params[0].AsString := ObjectName;
       end
       else
       begin
         SQL.Add('SELECT RDB$DEPENDENT_NAME,RDB$DEPENDENT_TYPE FROM RDB$DEPENDENCIES');
         SQL.Add('WHERE RDB$DEPENDED_ON_NAME = :ObjectName');
         SQL.Add('AND RDB$DEPENDED_ON_TYPE = :TypeID');
         SQL.Add('GROUP BY RDB$DEPENDENT_NAME,RDB$DEPENDENT_TYPE');
         SQL.Add('ORDER BY RDB$DEPENDENT_NAME,RDB$DEPENDENT_TYPE');
         Params[0].AsString := ObjectName;
         Params[1].AsInteger := ObjectType;
       end;
       try
         Open;
         if not EOF then
         begin
           repeat
           begin
             case FieldbyName('RDB$DEPENDENT_TYPE').AsInteger of
               DEP_TABLE: lDependenciesType := 'Table';
               DEP_VIEW: lDependenciesType := 'View';
               DEP_TRIGGER: lDependenciesType := 'Trigger';
               DEP_COMPUTED_FIELD: lDependenciesType := 'Computed field';
               DEP_VALIDATION: lDependenciesType := 'Validation';
               DEP_PROCEDURE: lDependenciesType := 'Stored Procedure';
               DEP_EXPRESSION_INDEX: lDependenciesType := 'Expression index';
               DEP_EXCEPTION: lDependenciesType := 'Exception';
               DEP_USER: lDependenciesType := 'User';
               DEP_FIELD: lDependenciesType := 'Field';
               DEP_INDEX: lDependenciesType := 'Index';
             else
               lDependenciesType := '';
             end;
             Dependencies.Add(Format('%s%s%s',[Trim(Fields[0].AsString),DEL,lDependenciesType]));
             Next;
           end;
           until EOF;
           result := SUCCESS;
         end
         else
          begin
           result := EMPTY;
          end;
         Close;
       except
         on E:EIBError do
         begin
            DisplayMsg(ERR_GET_DEPENDENCIES, E.Message);
            result := FAILURE;
         end;
       end;
     end;
  finally
    lqryDependencies.Close;
    lqryDependencies.Free;
  end;
end;

end.


