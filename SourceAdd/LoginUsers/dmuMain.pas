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
*  d m u M a i n
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit contains non GUI, database related
*                functions
*
*****************************************************************
* Revisions:
*
*****************************************************************}

unit dmuMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBQuery, IBDatabase, Db, IB, zluibcClasses,
  DBTables, IBTable, StdCtrls, IBHEADER, IBServices, Grids, DBGrids, IBSql,
  IBDatabaseInfo;

type
  TdmMain = class(TDataModule)
  private
    { Private declarations }
    function GetNextGenValue (const Database: TIBDatabase; const GenName: String): String;
  public
    { Public declarations }
    function GetBlobFilterList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
    function GetCheckConstList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): integer;
    function GetColumnList(var ObjectList: TStringList; const Database: TIBDatabase; const TableName: string): integer;
    function GetDBFiles(var ObjectList: TStringList; const SelServerNode: TibcServerNode; const SelDatabaseNode: TibcDatabaseNode): integer;
    function GetDomainList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
    function GetExceptionList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
    function GetFunctionList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
    function GetGeneratorList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
    function GetIndexList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): integer;
    function GetProcedureList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
    function GetProcedureInfo(var ObjectList: TStringList; var Source: TStringList; const SelDatabaseNode: TIBDatabase; const ProcName: String): integer;
    function GetReferentialConstList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): integer;
    function GetRoleList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase): integer;
    function GetTableData(var SelDatabaseNode: TIBDatabase; var DataSet: TIBDataset; const SelTableName: string): boolean;
    function GetOwnerInfo(var OwnerName, Description: string; const SelDatabaseNode: TIBDatabase; const Node: TibcTreeNode): integer;
    function GetTableList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
    function GetTriggerList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): integer;
    function GetUniqueConstList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): integer;
    function GetViewList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
    function GetFunctiondata(var ObjectList: TStringList; out ModuleName, EntryPoint, Returnval: String;const SelDatabaseNode: TIBDatabase; const FuncName: String): integer;
    function GetFilterData (var ObjectList: TStringList;const SelDatabaseNode: TIBDatabase; const FuncName: String): integer;
    function GetRoleData (var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const RoleName: String): integer;
    function GetExceptionData (var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const ExceptionName: String): integer;
    function GetGeneratorData (var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const ShowSystem: boolean): integer;
    function GetViewData (var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const ViewName: String): integer;
    function GetDomainData (var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const ShowSystem: boolean): integer;
    function GetProcedureSource(var ObjectList: TStringList; const InDatabase: TIBDatabase; const ProcName: String): integer;
  end;

var
  dmMain: TdmMain;

implementation

uses
  zluGlobal, frmuMessage, zluUtility, frmuDBConnect, IBExtract;

{$R *.DFM}

{****************************************************************
*
*  G e t B l o b F i l t e r L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          SystemData - A flag indicating whether or not to
*                       display system data
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of blob filters for the specified database
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetBlobFilterList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
var
 lQry: TIBSql;

 lSQLStr: string;
begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;

  ObjectList.Add(Format('Name%sModule%sEntry%sInput%sOutput%sDescription',[DEL,DEL,DEL,DEL,DEL]));

  lQry := nil;
  try
    lQry := TIBSQL.Create (self);

    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT RDB$FUNCTION_NAME,RDB$MODULE_NAME,RDB$ENTRYPOINT,';
      lSQLStr := Format('%s RDB$INPUT_SUB_TYPE,RDB$OUTPUT_SUB_TYPE, RDB$DESCRIPTION FROM RDB$FILTERS',[lSQLStr]);

      if not SystemData then
      begin
        lSQLStr := Format('%s WHERE RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL',[lSQLStr]);
      end;

      lSQLStr := Format('%s ORDER BY RDB$FUNCTION_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            ObjectList.Add(Format('%s%s%s%s%s%s%s%s%s%s%s',[Fields[0].AsString,
              DEL,Fields[1].AsString,DEL,Fields[2].AsString,DEL,Fields[3].AsString,
              DEL,Fields[4].AsString, DEL, Fields[5].AsString]));
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
          DisplayMsg(ERR_GET_BLOB_FILTERS, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    SelDatabaseNode.DefaultTransaction.Commit;
    lQry.Free;
  end;
end;

{****************************************************************
*
*  G e t C h e c k C o n s t L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          TableName - The table to be queried
*
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of check constraints for
*  the specified database/table
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetCheckConstList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): integer;
var
  lLastConstraint,lSQLStr: string;
  lStrIdx: integer;
  lQry: TIBSql;

begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Name%sCan Defer%sInitially Deferred',
                  [DEL,DEL]));

  lQry := nil;
  try
    lQry := TIBSql.Create (self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT A.RDB$CONSTRAINT_NAME,A.RDB$DEFERRABLE,A.RDB$INITIALLY_DEFERRED,C.RDB$TRIGGER_SOURCE';
      lSQLStr := Format('%s FROM RDB$RELATION_CONSTRAINTS A,RDB$CHECK_CONSTRAINTS B,RDB$TRIGGERS C',[lSQLStr]);
      lSQLStr := Format('%s WHERE A.RDB$CONSTRAINT_NAME = B.RDB$CONSTRAINT_NAME',[lSQLStr]);
      lSQLStr := Format('%s AND B.RDB$TRIGGER_NAME = C.RDB$TRIGGER_NAME',[lSQLStr]);
      lSQLStr := Format('%s AND A.RDB$RELATION_NAME = ''%s''',[lSQLStr,TableName]);
      lSQLStr := Format('%s ORDER BY A.RDB$CONSTRAINT_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          lLastConstraint := '';
          repeat
          begin
            if lLastConstraint <> Fields[0].AsString then
            begin
              lStrIdx := ObjectList.Add(Format('%s%s%s%s%s%s%s',[Trim(Fields[0].AsString),DEL,Trim(Fields[1].AsString),DEL,
                Trim(Fields[2].AsString),DEL,Trim(Fields[3].AsString)]));
              ObjectList.Strings[lStrIdx] := ObjectList.Strings[lStrIdx];
            end;
            lLastConstraint := Fields[0].AsString;
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
          DisplayMsg(ERR_GET_CHECK_CONST, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    SelDatabaseNode.DefaultTransaction.Commit;
    lQry.Free;
  end;
end;

{****************************************************************
*
*  G e t C o l u m n L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          TableName - The table to be queried
*
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of columns for the specified database/table
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetColumnList(var ObjectList: TStringList; const Database: TIBDatabase;
                               const TableName: string): integer;
var
  Charset, Collation,
  lFieldType,lAllowNulls,lSQLStr,lDefault : string;
  lqry: TIBSql;
  len: integer;
  IBExtract: TIBExtract;
begin
  if Database.DefaultTransaction.InTransaction then
    Database.DefaultTransaction.Commit;

  Database.DefaultTransaction.StartTransaction;

  ObjectList.Add(Format('Name%sType%sCharacter Set%sCollation%sDefault Value%sAllow Nulls', [DEL,DEL,DEL,DEL,DEL]));

  lQry := nil;
  IBExtract := nil;
  try
    lQry := TIBSQl.Create (self);
    IBExtract := TIBExtract.Create (self);
    IBExtract.Database := Database;
    lQry.Database := Database;
    with lQry do
    begin
      Transaction := Database.DefaultTransaction;

      lSQLStr := 'SELECT A.RDB$FIELD_NAME, A.RDB$FIELD_SOURCE,B.RDB$FIELD_TYPE, B.RDB$SEGMENT_LENGTH,';
      lSQLStr := Format('%s B.RDB$FIELD_SUB_TYPE,B.RDB$FIELD_LENGTH,B.RDB$FIELD_SCALE,', [lSQLStr]);
      lSQLStr := Format('%s B.RDB$DEFAULT_SOURCE DEF_DOM,A.RDB$DEFAULT_SOURCE DEF_NATIVE,', [lSQLStr]);
      lSQLStr := Format('%s A.RDB$NULL_FLAG NULLS1, B.RDB$NULL_FLAG NULLS2, B.RDB$SYSTEM_FLAG,', [lSQLStr]);
      lSQLStr := Format('%s B.RDB$DIMENSIONS, B.RDB$CHARACTER_LENGTH, B.RDB$FIELD_PRECISION,', [lSQLStr]);
      lSQLStr := Format('%s B.RDB$CHARACTER_SET_ID, B.RDB$COLLATION_ID FROM RDB$RELATION_FIELDS A, RDB$FIELDS B WHERE', [lSQLStr]);
      lSQLStr := Format('%s A.RDB$RELATION_NAME = ''%s'' AND', [lSQLStr, TableName]);
      lSQLStr := Format('%s A.RDB$FIELD_SOURCE = B.RDB$FIELD_NAME', [lSQLStr]);
      lSQLStr := Format('%s ORDER BY A.RDB$RELATION_NAME, RDB$FIELD_POSITION', [lSQLStr]);

      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            lFieldType := '';
            if FieldByName('RDB$DIMENSIONS').AsInteger > 0 then
               lFieldType := IBExtract.GetArrayField(Trim(FieldByName('RDB$FIELD_SOURCE').AsString));

            if Pos('RDB$', TableName) = 1 then
              len := FieldByName('RDB$FIELD_LENGTH').AsInteger
            else
              len := FieldByName('RDB$CHARACTER_LENGTH').AsInteger;

            lFieldType := Format('%s %s',[lFieldType , IBExtract.GetFieldType (FieldByName('RDB$FIELD_TYPE').AsInteger,
                                                         FieldByName('RDB$FIELD_SUB_TYPE').AsInteger,
                                                         FieldByName('RDB$FIELD_SCALE').AsInteger,
                                                         Len,
                                                         FieldByName('RDB$FIELD_PRECISION').AsInteger,
                                                         FieldByName('RDB$SEGMENT_LENGTH').AsInteger)]);

            Charset := '';
            if not (FieldByName('RDB$CHARACTER_SET_ID').IsNull) and
               (FieldByName('RDB$CHARACTER_SET_ID').AsInteger <> 0) then
              Charset := IBExtract.GetCharacterSet (FieldByName('RDB$CHARACTER_SET_ID').AsInteger, 0, false);

            Collation := '';
            if (not FieldByName('RDB$COLLATION_ID').IsNull) and
               (FieldByName('RDB$COLLATION_ID').AsInteger <> 0) then
              Collation := IBExtract.GetCharacterSet (FieldByName('RDB$CHARACTER_SET_ID').AsInteger,
                                                      FieldByName('RDB$COLLATION_ID').AsInteger, false);


            lAllowNulls := 'Yes';
            if FieldByName('NULLS1').AsInteger = 1 then lAllowNulls := 'No';
            if FieldByName('NULLS2').AsInteger = 1 then lAllowNulls := 'No';

            lDefault := '';
            if not FieldByName('DEF_DOM').IsNull then
              lDefault := Trim(FieldByName('DEF_DOM').AsString);

            if not FieldByName('DEF_NATIVE').IsNull then
              lDefault := Trim(FieldByName('DEF_NATIVE').AsString);

            if (Pos('RDB$', FieldByName('RDB$FIELD_SOURCE').AsString) = 0) or
               (FieldByName('RDB$SYSTEM_FLAG').AsInteger = 1) then
              lFieldType := Format('(%s) %s', [Trim(FieldByName('RDB$FIELD_SOURCE').AsString), lFieldType]);

            ObjectList.Add(Format('%s%s%s%s%s%s%s%s%s%s%s',[FieldByName('RDB$FIELD_NAME').AsString,DEL,
                                                    lFieldType,DEL,
                                                    Charset,DEL,
                                                    Collation,DEL,
                                                    lDefault, DEL,
                                                    lAllowNulls]));
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
          DisplayMsg(ERR_GET_COLUMNS, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    IBExtract.Free;
    Database.DefaultTransaction.Commit;    
  end;
end;

{****************************************************************
*
*  G e t D o m a i n L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          SystemData - A flag indicating whether or not to
*                       display system data
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of domains for the specified database
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetDomainList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
var
  lSQLStr: string;
  lQry: TIBSql;

begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;

  ObjectList.Clear;
  ObjectList.Append (Format('Name%sDescription', [DEL]));

  lQry := nil;
  try
    lQry := TIBSql.Create (self);
    with lQry do
    begin
      result := EMPTY;
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT RDB$FIELD_NAME,RDB$DESCRIPTION FROM RDB$FIELDS';
      if not SystemData then
      begin
        lSQLStr := Format('%s WHERE RDB$FIELD_NAME NOT STARTING WITH ''RDB$''',[lSQLStr]);
        lSQLStr := Format('%s AND RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL',[lSQLStr]);
      end
      else
      begin
        lSQLStr := Format('%s WHERE (RDB$FIELD_NAME NOT STARTING WITH ''RDB$''',[lSQLStr]);
        lSQLStr := Format('%s AND RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL)',[lSQLStr]);
        lSQLStr := Format('%s or rdb$system_flag = 1', [lSqlStr]);        
      end;

      lSQLStr := Format('%s ORDER BY RDB$FIELD_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        while not EOF do
        begin
          ObjectList.Append (Fields[0].AsString+DEL+Fields[1].AsString);
          result := Success;
          Next;
        end;
      except
        on E:EIBError do
        begin
          DisplayMsg(ERR_GET_DOMAINS, E.Message);
          result := FAILURE;
        end;
      end;
      Close;
    end;
  finally
    SelDatabaseNode.DefaultTransaction.Commit;
    lQry.Free;
  end;
end;

{****************************************************************
*
*  G e t E x c e p t i o n L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          SystemData - A flag indicating whether or not to
*                       display system data
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of exceptions for the specified database
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetExceptionList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
var
  lSQLStr: string;
  lQry: TIBSql;

begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Name%sMessage%sDescription',[DEL,DEL]));

  lQry := nil;
  try
    lQry := TIBSQL.create(self);

    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT RDB$EXCEPTION_NAME,RDB$MESSAGE,RDB$DESCRIPTION FROM RDB$EXCEPTIONS';

      if not SystemData then
      begin
        lSQLStr := Format('%s WHERE RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL',[lSQLStr]);
      end;

      lSQLStr := Format('%s ORDER BY RDB$EXCEPTION_NUMBER',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            ObjectList.Add(Format('%s%s%s%s%s',[Fields[0].AsString,DEL,Fields[1].AsString,
              DEL, Fields[2].AsString]));
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
          DisplayMsg(ERR_GET_EXCEPTIONS, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    SelDatabaseNode.DefaultTransaction.Commit;
    lQry.Free;
  end;
end;

{****************************************************************
*
*  G e t F u n c t i o n L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          SystemData - A flag indicating whether or not to
*                       display system data
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of functions for the specified database
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetFunctionList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
var
  lSQLStr: string;
  lQry: TIBSql;

begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Name%sModule%sEntry%sDescription',[DEL,DEL,DEL]));

  lQry := nil;
  try
    lQry := TIBSQL.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT RDB$FUNCTION_NAME,RDB$MODULE_NAME,RDB$ENTRYPOINT,RDB$DESCRIPTION FROM RDB$FUNCTIONS';

      lSQLStr := Format('%s ORDER BY RDB$FUNCTION_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            ObjectList.Add(Format('%s%s%s%s%s%s%s',[Fields[0].AsString,DEL,
              Fields[1].AsString,DEL,Fields[2].AsString, DEL, Fields[3].AsString]));
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
          DisplayMsg(ERR_GET_FUNCTIONS, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    SelDatabaseNode.DefaultTransaction.Commit;
    lQry.Free;
  end;
end;

{****************************************************************
*
*  G e t G e n e r a t o r L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          SystemData - A flag indicating whether or not to
*                       display system data
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of generators for the specified database
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetGeneratorList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
var
  lSQLStr: string;
  lQry, lqryGetGenNextVal: TIBSql;
  lCurrGenVal: string;
begin
  lqryGetGenNextVal := nil;
  lQry := nil;

  try
    lQry := TIBSql.Create(self);

    if SelDatabaseNode.DefaultTransaction.InTransaction then
      SelDatabaseNode.DefaultTransaction.Commit;

    SelDatabaseNode.DefaultTransaction.StartTransaction;
    ObjectList.Add(Format('Name%sCurrent Value',[DEL]));

    lqryGetGenNextVal := TIBSQL.Create(self);
    lqryGetGenNextVal.Database := SelDatabaseNode;
    lqryGetGenNextVal.Transaction := SelDatabaseNode.DefaultTransaction;
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT RDB$GENERATOR_NAME FROM RDB$GENERATORS';

      if not SystemData then
      begin
      lSQLStr := Format('%s WHERE RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL',[lSQLStr]);
      end;

      lSQLStr := Format('%s ORDER BY RDB$GENERATOR_ID',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            lCurrGenVal := '0';
            lqryGetGenNextVal.Close;
            lqryGetGenNextVal.SQL.Clear;
            lqryGetGenNextVal.SQL.Add(Format('SELECT GEN_ID(%s, 0) FROM RDB$DATABASE',[Trim(Fields[0].AsString)]));
            try
              lqryGetGenNextVal.ExecQuery;
              if not lqryGetGenNextVal.EOF then
                lCurrGenVal := lqryGetGenNextVal.Fields[0].AsString;
            except
              on E:EIBError do
              begin
                result := FAILURE;
              end;
            end;

            ObjectList.Add(Format('%s%s%s',[Fields[0].AsString,DEL,lCurrGenVal]));
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
          DisplayMsg(ERR_GET_GENERATORS, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lqryGetGenNextVal.Close;
    lqryGetGenNextVal.Free;
    SelDatabaseNode.DefaultTransaction.Commit;
    lQry.Free;
  end;
end;

{****************************************************************
*
*  G e t I n d e x L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          TableName - The table to be queried
*
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of indexes for the specified database/table
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetIndexList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): integer;
var
  lUnique,lDescending,lActive,lSQLStr: string;
  lQry: TIBSql;

begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Name%sUnique%sDescending%sActive',[DEL,DEL,DEL]));

  lQry := nil;
  try
    lQry := TIBSQL.Create (self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT RDB$INDEX_NAME,RDB$UNIQUE_FLAG,RDB$INDEX_TYPE,RDB$INDEX_INACTIVE';
      lSQLStr := Format('%s  FROM RDB$INDICES WHERE RDB$RELATION_NAME = ''%s''',[lSQLStr,TableName]);
      lSQLStr := Format('%s ORDER BY RDB$INDEX_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            case FieldbyName('RDB$UNIQUE_FLAG').AsInteger of
              1: lUnique := 'Yes';
            else
              lUnique := 'No';
            end;

            case FieldbyName('RDB$INDEX_TYPE').AsInteger of
              1: lDescending := 'Yes';
            else
              lDescending := 'No';
            end;

            case FieldByName('RDB$INDEX_INACTIVE').AsInteger of
              1 : lActive := 'No';
            else
              lActive := 'Yes';
            end;

            ObjectList.Add(Format('%s%s%s%s%s%s%s',[Fields[0].AsString,DEL,lUnique,DEL,lDescending,DEL,lActive]));
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
          DisplayMsg(ERR_GET_INDICES, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;
  end;
end;

{****************************************************************
*
*  G e t P r o c e d u r e L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          SystemData - A flag indicating whether or not to
*                       display system data
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of procedures for the specified database
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetProcedureList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
var
  lSQLStr: string;
  lQry: TIBSql;

begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Name%sOwner%sDescription',[DEL,DEL]));

  lQry := nil;
  try
    lQry := TIBSQL.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT RDB$PROCEDURE_NAME,RDB$OWNER_NAME, RDB$DESCRIPTION FROM RDB$PROCEDURES';

      if not SystemData then
      begin
        lSQLStr := Format('%s WHERE RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL',[lSQLStr]);
      end;

      lSQLStr := Format('%s ORDER BY RDB$PROCEDURE_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            ObjectList.Add(Format('%s%s%s%s%s',[Fields[0].AsString,DEL,Fields[1].AsString, DEL, Fields[2].AsString]));
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
          DisplayMsg(ERR_GET_PROCEDURES, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;
  end;
end;

{****************************************************************
*
*  G e t R e f e r e n t i a l C o n s t L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          TableName - The table to be queried
*
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of referential integrity contraints
*  for the specified database/table
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetReferentialConstList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): integer;
var
  lSQLStr: string;
  lQry: TIBSql;

begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Name%sCan Defer%sInitially Deferred%sMatch Option%sUpdate Rule%sDelete Rule%sIndex%sReference Table',
                  [DEL,DEL,DEL,DEL,DEL,DEL,DEL]));

  lQry := nil;
  try
    lQry := TIBSQL.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT A.RDB$CONSTRAINT_NAME,A.RDB$DEFERRABLE,A.RDB$INITIALLY_DEFERRED,';
      lSQLStr := Format('%s B.RDB$MATCH_OPTION,B.RDB$UPDATE_RULE,B.RDB$DELETE_RULE,A.RDB$INDEX_NAME,C.RDB$RELATION_NAME',[lSQLStr]);
      lSQLStr := Format('%s FROM RDB$RELATION_CONSTRAINTS A, RDB$REF_CONSTRAINTS B, RDB$RELATION_CONSTRAINTS C',[lSQLStr]);
      lSQLStr := Format('%s WHERE A.RDB$CONSTRAINT_NAME = B.RDB$CONSTRAINT_NAME',[lSQLStr]);
      lSQLStr := Format('%s AND C.RDB$CONSTRAINT_NAME = B.RDB$CONST_NAME_UQ',[lSQLStr]);
      lSQLStr := Format('%s AND A.RDB$RELATION_NAME = ''%s''',[lSQLStr,TableName]);
      lSQLStr := Format('%s AND (A.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY'' OR A.RDB$CONSTRAINT_TYPE = ''FOREIGN KEY'')',[lSQLStr]);
      lSQLStr := Format('%s ORDER BY A.RDB$CONSTRAINT_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            ObjectList.Add(Format('%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s',[Fields[0].AsString,DEL,Fields[1].AsString,DEL,
              Fields[2].AsString,DEL,Fields[3].AsString,DEL,Fields[4].AsString,DEL,Fields[5].AsString,DEL,Fields[6].AsString,DEL,
              Fields[7].AsString]));
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
          DisplayMsg(ERR_GET_REFERENTIAL_CONST, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;    
  end;
end;

{****************************************************************
*
*  G e t R o l e L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of roles for the specified database
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetRoleList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase): integer;
var
  lSQLStr: string;
  lQry: TIBSql;

begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Name%sOwner',[DEL]));

  lQry := nil;
  try
    lQry := TIBSQL.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT RDB$ROLE_NAME,RDB$OWNER_NAME';
      lSQLStr := Format('%s FROM RDB$ROLES',[lSQLStr]);
      lSQLStr := Format('%s ORDER BY RDB$OWNER_NAME, RDB$ROLE_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            ObjectList.Add(Format('%s%s%s',[Fields[0].AsString,DEL,Fields[1].AsString]));
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
          DisplayMsg(ERR_GET_ROLES, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;
  end;
end;

{****************************************************************
*
*  G e t T a b l e D a t a ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  SelDatabaseNode - The database to be queried
*          SelTableName - The table to be queried
*
*
*  Return: boolean - Success/Failure indicator
*
*  Description:  Retrieves the data for the specified table
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetTableData(var SelDatabaseNode: TIBDatabase;
                              var DataSet: TIBDataSet;
                              const SelTableName: string): boolean;
var
  tableName: string;

begin
  result := true;
  try
    with Dataset do
    begin
      if Active then
      begin
        ApplyUpdates;
        if Transaction.InTransaction then
          Transaction.Commit;
        Active := false;
      end;
      Transaction.StartTransaction;
    end;
    if SelDatabaseNode.SQLDialect > 1 then
      tableName := Format('"%s"', [SelTableName])
    else
      tableName := SelTableName;

    Dataset.SelectSQL.Text :=  Format('SELECT * FROM %s',[TableName]);
//    Dataset.RefreshSQL.Text := Format('SELECT * FROM %s',[TableName]);
    Dataset.Prepare;
//    Dataset.Open;
//    CreateDynSQL(Dataset, TableName);
//    Dataset.Close;
    Dataset.Open;
    Dataset.FetchAll;
  except
    on E:EIBError do
    begin
      DisplayMsg(ERR_GET_TABLE_DATA, E.Message);
      Screen.Cursor := crDefault;
      result := false;
    end;
  end;
end;

{****************************************************************
*
*  G e t O w n e r I n f o ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves detail info for a specified table
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetOwnerInfo(var OwnerName, Description: string; const SelDatabaseNode: TIBDatabase; const Node: TibcTreeNode): integer;
var
  lSQLStr,
  FldName,
  RelName,
  Flds,
  ObjName:  string;

  lQry: TIBSql;

begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;

  ObjName := Node.NodeName;
  case Node.NodeType of
    NODE_PROCEDURE:
    begin
      Flds := 'RDB$OWNER_NAME, RDB$DESCRIPTION';
      FldName := 'RDB$PROCEDURE_NAME';
      RelName := 'RDB$PROCEDURES';
    end;

    NODE_TABLE,
    NODE_VIEW:
    begin
      Flds := 'RDB$OWNER_NAME, RDB$DESCRIPTION';
      FldName := 'RDB$RELATION_NAME';
      RelName := 'RDB$RELATIONS';
    end;
    NODE_ROLE:
    begin
      Flds := 'RDB$OWNER_NAME';
      FldName := 'RDB$ROLE_NAME';
      RelName := 'RDB$ROLES';
    end;
    else
    begin
      result := Failure;
      exit;
    end;
  end;

  lQry := nil;
  try
    lQry := TIBSQL.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := Format('SELECT %s FROM %s', [Flds, RelName]);
      lSQLStr := Format('%s WHERE %s = ''%s''',[lSQLStr, FldName, ObjName]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          OwnerName := Fields[0].AsString;

          if Node.NodeType <> NODE_ROLE then
            Description := Fields[1].AsString;
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
          DisplayMsg(ERR_GET_TABLES, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;
  end;
end;

{****************************************************************
*
*  G e t T a b l e L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          SystemData - A flag indicating whether or not to
*                       display system data
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of tables for the specified database
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetTableList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
var
  lSQLStr: string;
  lQry: TIBSql;
begin

  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Name%sOwner%sDescription',[DEL,DEL]));
  lQry := nil;
  try
    lQry := TIBSQL.Create (self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT RDB$RELATION_NAME,RDB$OWNER_NAME,RDB$DESCRIPTION FROM RDB$RELATIONS';
      lSQLStr := Format('%s WHERE RDB$RELATION_NAME NOT IN (',[lSQLStr]);
      lSQLStr := Format('%s SELECT RDB$VIEW_NAME FROM RDB$VIEW_RELATIONS)',[lSQLStr]);

      if not SystemData then
      begin
        lSQLStr := Format('%s AND RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL',[lSQLStr]);
      end;

      lSQLStr := Format('%s ORDER BY RDB$RELATION_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            ObjectList.Add(Format('%s%s%s%s%s',[Fields[0].AsString,DEL,Fields[1].AsString,DEL,Fields[2].AsString]));
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
          DisplayMsg(ERR_GET_TABLES, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;    
  end;
end;

{****************************************************************
*
*  G e t T r i g g e r L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          TableName - The table to be queried
*
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of triggers for the specified database/table
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetTriggerList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): integer;
var
  lQry: TIBSql;
  lActive, lSource,
  lTriggerType, lSQLStr: string;
begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Name%sType%sActive',[DEL,DEL]));
  lQry := nil;

  try
    lQry := TIBSQl.Create (self);

    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT RDB$TRIGGER_NAME,RDB$TRIGGER_TYPE, RDB$TRIGGER_INACTIVE,';
      lSQLStr := Format('%s RDB$TRIGGER_SOURCE FROM RDB$TRIGGERS', [lSqlStr]);
      lSQLStr := Format('%s WHERE RDB$RELATION_NAME = ''%s''',[lSQLStr,TableName]);
      lSQLStr := Format('%s AND RDB$TRIGGER_NAME NOT IN ', [lSQLStr]);
      lSQLStr := Format('%s (SELECT RDB$TRIGGER_NAME FROM RDB$CHECK_CONSTRAINTS)',[lSQLStr]);
      lSQLStr := Format('%s ORDER BY RDB$TRIGGER_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            case FieldbyName('RDB$TRIGGER_TYPE').AsInteger of
              1: lTriggerType := 'BEFORE INSERT';
              2: lTriggerType := 'AFTER INSERT';
              3: lTriggerType := 'BEFORE UPDATE';
              4: lTriggerType := 'AFTER UPDATE';
              5: lTriggerType := 'BEFORE DELETE';
              6: lTriggerType := 'AFTER DELETE';
            else
              lTriggerType := '';
            end;

            if FieldByName('RDB$TRIGGER_TYPE').AsInteger = 1 then
              lActive := 'InActive'
            else
              lActive := 'Active';

            if FieldByName('RDB$TRIGGER_SOURCE').IsNull then
              lSource := 'Not Available'
            else
              lSource := FieldByName('RDB$TRIGGER_SOURCE').AsString;

            ObjectList.Add(Format('%s%s%s%s%s%s%s',[Fields[0].AsString,DEL,
              lTriggerType, DEL, lActive, DEL, lSource]));
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
          DisplayMsg(ERR_GET_TRIGGERS, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    SelDatabaseNode.DefaultTransaction.Commit;
    lQry.Free;
  end;
end;

{****************************************************************
*
*  G e t U n i q u e C o n s t L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          TableName - The table to be queried
*
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of unique constraints for
*  the specified database/table
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetUniqueConstList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const TableName: string): integer;
var
  lSQLStr: string;
  lQry: TIBSql;
begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Name%sCan Defer%sInitially Deferred%sIndex',[DEL,DEL,DEL]));

  lQry := nil;
  try
    lQry := TIBSQL.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'SELECT RDB$CONSTRAINT_NAME,RDB$DEFERRABLE,RDB$INITIALLY_DEFERRED,RDB$INDEX_NAME FROM RDB$RELATION_CONSTRAINTS';
      lSQLStr := Format('%s WHERE RDB$RELATION_NAME = ''%s''',[lSQLStr,TableName]);
      lSQLStr := Format('%s AND RDB$CONSTRAINT_TYPE = ''UNIQUE''',[lSQLStr]);
      lSQLStr := Format('%s ORDER BY RDB$CONSTRAINT_NAME',[lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            ObjectList.Add(Format('%s%s%s%s%s%s%s',[Fields[0].AsString,DEL,Fields[1].AsString,DEL,Fields[2].AsString,DEL,Fields[3].AsString]));
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
          DisplayMsg(ERR_GET_UNIQUE_CONST, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;    
  end;
end;

{****************************************************************
*
*  G e t V i e w L i s t ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ObjectList - A list containing object details
*          SelDatabaseNode - The database to be queried
*          SystemData - A flag indicating whether or not to
*                       display system data
*  Return: integer - Success/Failure indicator
*
*  Description:  Retrieves a list of views for the specified database
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetViewList(var ObjectList: TStringList; const SelDatabaseNode: TIBDatabase; const SystemData: boolean): integer;
var
  lSQLStr   : String;
  lQry: TIBSQl;

begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Name%sOwner%sDescription',[DEL,DEL]));

  lQry := nil;
  try
    lQry := TIBSQL.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;

      lSQLStr := 'SELECT DISTINCT A.RDB$RELATION_NAME,A.RDB$OWNER_NAME,A.RDB$DESCRIPTION';
      lSQLStr := Format('%s FROM RDB$RELATIONS A, RDB$VIEW_RELATIONS B', [lSQLStr]);
      lSQLStr := Format('%s WHERE A.RDB$RELATION_NAME = B.RDB$VIEW_NAME', [lSQLStr]);
      lSQLStr := Format('%s ORDER BY A.RDB$RELATION_ID', [lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
        begin
          repeat
          begin
            ObjectList.Add(Format('%s%s%s%s%s',[Fields[0].AsString,DEL,Fields[1].AsString,DEL,Fields[2].AsString]));
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
          DisplayMsg(ERR_GET_VIEWS, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;
  end;
end;

{****************************************************************
*
*  G e t D B F i l e s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return: integer - Success/Failure indicator
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TdmMain.GetDBFiles(var ObjectList: TStringList; const SelServerNode: TibcServerNode; const SelDatabaseNode: TibcDatabaseNode): integer;
var
  lqryDBFiles: TIBSql;
  IsDBConnected: boolean;
begin
  lqryDBFiles := TIBSQL.Create(Self);
  IsDBConnected := False;
  Result := SUCCESS;
  try
    IsDBConnected := SelDatabaseNode.Database.Connected;
    if not SelDatabaseNode.Database.Connected then
    begin
      if SelDatabaseNode.DatabaseFiles.Count > 0 then
      begin
        case SelServerNode.Server.Protocol of
          TCP: SelDatabaseNode.Database.DatabaseName := Format('%s:%s',[SelServerNode.ServerName,SelDatabaseNode.DatabaseFiles.Strings[0]]);
          NamedPipe: SelDatabaseNode.Database.DatabaseName := Format('\\%s\%s',[SelServerNode.ServerName,SelDatabaseNode.DatabaseFiles.Strings[0]]);
          SPX: SelDatabaseNode.Database.DatabaseName := Format('%s@%s',[SelServerNode.ServerName,SelDatabaseNode.DatabaseFiles.Strings[0]]);
          Local: SelDatabaseNode.Database.DatabaseName := SelDatabaseNode.DatabaseFiles.Strings[0];
        end;
      end;
      SelDatabaseNode.Database.Params.Clear;
      SelDatabaseNode.Database.Params.Add(Format('isc_dpb_user_name=%s',[SelServerNode.UserName]));
      SelDatabaseNode.Database.Params.Add(Format('isc_dpb_password=%s',[SelServerNode.Password]));
      SelDatabaseNode.Database.Connected := true;
      Application.ProcessMessages;
    end;

    if SelDatabaseNode.Database.DefaultTransaction.InTransaction then
      SelDatabaseNode.Database.DefaultTransaction.Commit;

    SelDatabaseNode.Database.DefaultTransaction.StartTransaction;

    lqryDBFiles.Database := SelDatabaseNode.Database;
    lqryDBFiles.Transaction := SelDatabaseNode.Database.DefaultTransaction;

     with lqryDBFiles do
     begin
       SQL.Clear;
       SQL.Add('SELECT RDB$FILE_NAME, RDB$FILE_LENGTH FROM RDB$FILES ' +
               'WHERE RDB$SHADOW_NUMBER < 1 OR RDB$SHADOW_NUMBER IS NULL ' +
               'ORDER BY RDB$FILE_SEQUENCE ASC');
       try
         ExecQuery;
         while not EOF do
         begin
           ObjectList.Add(Format('%s%s%s',[Fields[0].AsString,DEL,Fields[1].AsString]));
           Next;
         end;
       except
         on E:EIBError do
         begin
           DisplayMsg(ERR_GET_DB_PROPERTIES,E.Message + ' Secondary files unavailable.');
           Result := FAILURE;
         end;
       end;
     end;
  finally
    lqryDBFiles.Close;
    lqryDBFiles.Free;
    if not SelDatabaseNode.Database.Connected = IsDBConnected then
      SelDatabaseNode.Database.Connected := IsDBConnected;
  end;
end;

/////////////////////////////////////////////////////////////////////////////////////////
function TdmMain.GetProcedureInfo(var ObjectList: TStringList;
                                  var Source: TStringList;
  const SelDatabaseNode: TIBDatabase; const ProcName: String): integer;
var
  lSQLStr,
  lParamType,
  lFieldType: String;
  lQry: TIBSql;
  IBExtract: TIBExtract;

begin
  result := FAILURE;
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Parameter%sType%sInput/Output',[DEL,DEL]));

  lQry := nil;
  IBExtract := nil;
  try
    lQry := TIBSQL.Create(self);
    IBExtract := TIBExtract.create(self);
    IBExtract.Database := SelDatabaseNode;
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'select p.rdb$procedure_source, p.rdb$description, pp.rdb$parameter_name,';
      lSQLStr := Format('%s pp.rdb$parameter_type, f.rdb$field_type, f.rdb$field_sub_type,',[lSQLStr]);
      lSQLStr := Format('%s f.rdb$FIELD_length, f.rdb$field_scale, f.rdb$character_length,',[lSQLStr]);
      lSQLStr := Format('%s f.rdb$field_precision from rdb$procedures p,', [lSQLStr]);
      lSQLStr := Format('%s rdb$procedure_parameters pp,rdb$fields f where', [lSQLStr]);
      lSQLStr := Format('%s p.rdb$procedure_name = ''%s'' and', [lSQLStr, ProcName]);
      lSQLStr := Format('%s pp.rdb$procedure_name = p.rdb$procedure_name and', [lSQLStr]);
      lSQLStr := Format('%s f.rdb$field_name = pp.rdb$field_source', [lSQLStr]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
          Source.Add (FieldByName('RDB$PROCEDURE_SOURCE').AsString);
        while not EOF do
        begin
          lFieldType := IBExtract.GetFieldType (FieldByName('RDB$FIELD_TYPE').AsInteger,
                          FieldByName('RDB$FIELD_SUB_TYPE').AsInteger,
                          FieldByName('RDB$FIELD_SCALE').AsInteger,
                          FieldByName('RDB$CHARACTER_LENGTH').AsInteger,
                          FieldByName('RDB$FIELD_PRECISION').AsInteger,
                          0);
          lParamType := 'Output';
          if FieldByName('RDB$PARAMETER_TYPE').AsInteger = 0 then
            lParamType := 'Input';

          ObjectList.Add(Format('%s%s%s%s%s',[FieldByName('RDB$PARAMETER_NAME').AsString,
                                                  DEL,
                                                  lFieldType,
                                                  DEL,
                                                  lParamType]));

          Next;
          result := SUCCESS;
        end;
        Close;
      except
        on E:EIBError do
        begin
          DisplayMsg(ERR_GET_PROCEDURES, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    IBExtract.Free;
    SelDatabaseNode.DefaultTransaction.Commit;
  end;
end;

function TdmMain.GetFunctiondata(var ObjectList: TStringList;
                                 out ModuleName,
                                     EntryPoint,
                                     Returnval: String;
                                 const SelDatabaseNode: TIBDatabase;
                                 const FuncName: String): integer;
var
  lSQLStr,
  lParamType,
  lFieldType: String;
  lQry: TIBSQL;
  IBExtract: TIBExtract;
begin
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  ObjectList.Add(Format('Parameter%sType',[DEL]));

  lQry := nil;
  IBExtract := nil;
  try
    lQry := TIBSQL.Create(self);
    IBExtract := TIBExtract.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      lSQLStr := 'select rdb$return_argument, rdb$argument_position, rdb$mechanism,';
      lSQLStr := Format('%s rdb$module_name, rdb$entrypoint, rdb$field_type,', [lSQLStr]);
      lSQLStr := Format('%s rdb$field_scale, rdb$field_length, rdb$field_sub_type,',[lSQLStr]);
      lSQLStr := Format('%s rdb$field_precision, rdb$character_length from rdb$functions f,',[lSQLStr]);
      lSQLStr := Format('%s rdb$function_arguments fa where rdb$function_name = ''%s''',[lSQLStr, FuncName]);
      lSQLStr := Format('%s and fa.rdb$function_name = f.rdb$function_name',[lSQLStr, FuncName]);

      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        while not EOF do
        begin
          ModuleName := Trim(FieldByName('RDB$MODULE_NAME').AsString);
          EntryPoint := Trim(FieldByName('RDB$ENTRYPOINT').AsString);

          lFieldType := IBExtract.GetFieldType (FieldByName('RDB$FIELD_TYPE').AsInteger,
                          FieldByName('RDB$FIELD_SUB_TYPE').AsInteger,
                          FieldByName('RDB$FIELD_SCALE').AsInteger,
                          FieldByName('RDB$CHARACTER_LENGTH').AsInteger,
                          FieldByName('RDB$FIELD_PRECISION').AsInteger,
                          0);

          lParamType := '';
          if Abs(FieldByName('RDB$MECHANISM').AsInteger) = 1 then
            lParamType := 'BY REFERENCE';

          if FieldByName('RDB$MECHANISM').AsInteger < 0 then
            lParamType := Format ('%s FREE IT', [lParamType]);

          if (FieldByName('RDB$RETURN_ARGUMENT').AsInteger <>
              FieldByName('RDB$ARGUMENT_POSITION').AsInteger) then
              ObjectList.Add(Format('Parameter %d%s%s',
                             [FieldByName('RDB$ARGUMENT_POSITION').AsInteger,
                             DEL,
                             lFieldType]))
          else
            ReturnVal := Format ('RETURNS %s %s', [lFieldType, lParamType]);

          Next;
        end;
        result := SUCCESS;
        Close;
      except
        on E:EIBError do
        begin
          DisplayMsg(ERR_GET_FUNCTIONS, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    IBExtract.Free;
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;
  end;
end;

function TdmMain.GetFilterData(var ObjectList: TStringList;
  const SelDatabaseNode: TIBDatabase; const FuncName: String): integer;
var
  lQry: TIBSQL;

begin
  result := FAILURE;
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;

  lQry := nil;
  try
    lQry := TIBSQL.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      SQL.Clear;
      SQL.Add('select * from rdb$filters order by rdb$function_name');
      try
        ExecQuery;
        while not EOF do
        begin
          ObjectList.Add(Format('%s%s%s%s%s%s%s%s',[FieldByName('RDB$MODULE_NAME').AsString,
                         DEL,
                         FieldByName('RDB$ENTRYPOINT').AsString,
                         DEL,
                         FieldByName('RDB$INPUT_SUB_TYPE').AsString,
                         DEL,
                         FieldByName('RDB$OUTPUT_SUB_TYPE').AsString,
                         DEL,
                         FieldByName('RDB$DESCRIPTION').AsString]));
          Next;
          result := SUCCESS;
        end;
        Close;
      except
        on E:EIBError do
        begin
          DisplayMsg(ERR_GET_BLOB_FILTERS, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;    
  end;
end;

function TdmMain.GetRoleData(var ObjectList: TStringList;
  const SelDatabaseNode: TIBDatabase; const RoleName: String): integer;
var
  lSQLStr: String;
  lQry: TIBSql;

begin
  result := FAILURE;
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  lSQLStr := 'select rdb$role_name, rdb$owner_name, rdb$user from rdb$roles, rdb$user_privileges';
  lSQLStr := Format('%s where rdb$relation_name=rdb$role_name', [lSQLStr]);
  lSQLStr := Format('%s order by rdb$role_name', [lSQLStr]);  
  ObjectList.Add(Format('Owner%sMember',[DEL]));

  lQry := nil;
  try
    lQry := TIBSQL.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        while not EOF do
        begin
          ObjectList.Add(Format('%s%s%s',[FieldByName('RDB$OWNER_NAME').AsString,
                         DEL,
                         FieldByName('RDB$USER').AsString]));
          Next;
          result := SUCCESS;
        end;
        Close;
      except
        on E:EIBError do
        begin
          DisplayMsg(ERR_GET_ROLES, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;
  end;
end;

function TdmMain.GetExceptionData(var ObjectList: TStringList;
  const SelDatabaseNode: TIBDatabase; const ExceptionName: String): integer;
var
  lQry: TIBSQl;
  
begin
  result := FAILURE;
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;

  lQry := nil;
  try
    lQry := TIBSQl.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      SQL.Clear;
      SQL.Add('select * from rdb$exceptions order by rdb$exception_number');
      try
        ExecQuery;
        while not EOF do
        begin
          ObjectList.Add(Format('%s%s%s%s%s',[FieldByName('RDB$EXCEPTION_NUMBER').AsString,
                         DEL,
                         FieldByName('RDB$MESSAGE').AsString,
                         DEL,
                         FieldByName('RDB$DESCRIPTION').AsString]));
          Next;
          result := SUCCESS;
        end;
        Close;
      except
        on E:EIBError do
        begin
          DisplayMsg(ERR_GET_EXCEPTIONS, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;    
  end;
end;

function TdmMain.GetGeneratorData(var ObjectList: TStringList;
  const SelDatabaseNode: TIBDatabase; const Showsystem: boolean): integer;
var
  lSqlStr: String;
  lQry: TIBSql;

begin
  result := FAILURE;
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;


  lSqlStr := 'select * from rdb$Generators';

  if not ShowSystem then
    lSQLStr := Format('%s Where RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL',[lSQLStr]);
    
  lSqlStr := Format('%s order by rdb$generator_id', [lSqlStr]);

  lQry := nil;
  try
    lQry := TIBSQL.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      SQL.Clear;
      SQL.Add(lSqlStr);
      try
        ExecQuery;
        while not EOF do
        begin
          ObjectList.Add(Format('%s%s%s',[FieldByName('RDB$GENERATOR_ID').AsString,
                         DEL,
                         GetNextGenValue (SelDatabaseNode, Trim(FieldByName('RDB$GENERATOR_NAME').AsString))]));
          Next;
          result := SUCCESS;
        end;
        Close;
      except
        on E:EIBError do
        begin
          DisplayMsg(ERR_GET_EXCEPTIONS, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;    
  end;
end;

function TdmMain.GetNextGenValue(const Database: TIBDatabase;
  const GenName: String): String;
var
  trans: TIBTransaction;
  qry: TIBSql;
begin
  trans := TIBTransaction.Create (self);
  trans.DefaultDatabase := Database;

  qry := TIBSql.Create (self);
  Trans.StartTransaction;
  with qry do
  begin
    Database := Database;
    Transaction := trans;
    SQL.Add (Format('select GEN_ID(%s,0) from RDB$DATABASE', [GenName]));
    Prepare;
    ExecQuery;
    result := FieldByName('GEN_ID').AsString;
    trans.Commit;
    close;
    Free;
  end;
  trans.free;
end;

function TdmMain.GetViewData(var ObjectList: TStringList;
  const SelDatabaseNode: TIBDatabase; const ViewName: String): integer;
var
  lSQLStr: String;
  lQry: TIBSql;

begin
  result := FAILURE;
  if SelDatabaseNode.DefaultTransaction.InTransaction then
    SelDatabaseNode.DefaultTransaction.Commit;

  SelDatabaseNode.DefaultTransaction.StartTransaction;
  lSqlStr := 'select rdb$description, rdb$view_source from rdb$relations';
  lSQLStr := Format('%s where rdb$relation_name in (select rdb$view_name', [lSQLStr]);
  lSQLStr := Format('%s from rdb$view_relations)', [lSQLStr]);
  lSQLStr := Format('%s ORDER BY RDB$RELATION_ID', [lSQLStr]);

  lQry := nil;
  try
    lQry := TIBSQL.Create(self);
    with lQry do
    begin
      Database := SelDatabaseNode;
      Transaction := SelDatabaseNode.DefaultTransaction;
      SQL.Clear;
      SQL.Add(lSqlStr);
      try
        ExecQuery;
        while not EOF do
        begin
          ObjectList.Add(Format('%s%s%s',[FieldByName('RDB$DESCRIPTION').AsString,
                         DEL,
                         FieldByName('RDB$VIEW_SOURCE').AsString]));
          Next;
        end;
        Close;
      except
        on E:EIBError do
        begin
          DisplayMsg(ERR_GET_EXCEPTIONS, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    SelDatabaseNode.DefaultTransaction.Commit;
  end;
end;

function TdmMain.GetDomainData(var ObjectList: TStringList;
  const SelDatabaseNode: TIBDatabase; const ShowSystem: boolean): integer;
var
  Qry: TIBSQL;
  Trans: TIBTransaction;
  lSQLStr,
  NullFlg,
  Charset,
  Collation,
  FieldType: String;
  len: integer;
  IBExtract: TIBExtract;

begin
  Qry := nil;
  Trans := nil;
  IBExtract := nil;
  result := FAILURE;
  try
    Screen.Cursor := crHourGlass;
    try
      IBExtract := TIBExtract.Create(self);
      IBExtract.Database := SelDatabaseNode;
      Qry := TIBSQL.Create (self);
      Trans := TIBTransaction.Create(Self);
      Trans.DefaultDatabase := SelDatabaseNode;
      with Qry do
      begin
        Transaction := Trans;
        lSQLStr := 'SELECT * FROM RDB$FIELDS';

        if not Showsystem then
        begin
          lSQLStr := Format('%s WHERE RDB$FIELD_NAME NOT STARTING WITH ''RDB$''',[lSQLStr]);
          lSQLStr := Format('%s AND RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL',[lSQLStr]);
        end
        else
        begin
          lSQLStr := Format('%s WHERE (RDB$FIELD_NAME NOT STARTING WITH ''RDB$''',[lSQLStr]);
          lSQLStr := Format('%s AND RDB$SYSTEM_FLAG <> 1 OR RDB$SYSTEM_FLAG is NULL)',[lSQLStr]);
          lSQLStr := Format('%s or rdb$system_flag = 1', [lSqlStr]);
        end;

        lSQLStr := Format('%s ORDER BY RDB$FIELD_NAME',[lSQLStr]);

        SQL.Add(lSqlStr);
        Trans.StartTransaction;
        Prepare;
        ExecQuery;

        while not EOF do
        begin
          FieldType := '';
          if FieldByName('RDB$DIMENSIONS').AsInteger > 0 then
            FieldType := IBExtract.GetArrayField(Trim(FieldByName('RDB$FIELD_NAME').AsString));

          if Showsystem then
            len := FieldByName('RDB$FIELD_LENGTH').AsInteger
          else
            len := FieldByName('RDB$CHARACTER_LENGTH').AsInteger;

          FieldType := Format('%s %s',[FieldType , IBExtract.GetFieldType (FieldByName('RDB$FIELD_TYPE').AsInteger,
                                                    FieldByName('RDB$FIELD_SUB_TYPE').AsInteger,
                                                    FieldByName('RDB$FIELD_SCALE').AsInteger,
                                                    Len,
                                                    FieldByName('RDB$FIELD_PRECISION').AsInteger,
                                                    FieldByName('RDB$SEGMENT_LENGTH').AsInteger)]);

          Charset := '';
          if not (FieldByName('RDB$CHARACTER_SET_ID').IsNull) and
             (FieldByName('RDB$CHARACTER_SET_ID').AsInteger <> 0) then
            Charset := IBExtract.GetCharacterSet (FieldByName('RDB$CHARACTER_SET_ID').AsInteger, 0, false);

          Collation := '';
          if (not FieldByName('RDB$COLLATION_ID').IsNull) and
             (FieldByName('RDB$COLLATION_ID').AsInteger <> 0) then
            Collation := IBExtract.GetCharacterSet (FieldByName('RDB$CHARACTER_SET_ID').AsInteger,
                           FieldByName('RDB$COLLATION_ID').AsInteger, false);


          NullFlg := 'No';
          if FieldByName('RDB$NULL_FLAG').IsNull then
            NullFlg := 'Yes';

          ObjectList.Add (Format('%s%s%s%s%s%s%s%s%s%s%s%s', [FieldType, DEL,
                                                      Charset, DEL,
                                                      Collation, DEL,
                                                      FieldByName('RDB$DEFAULT_SOURCE').AsString,
                                                      DEL,
                                                      NullFlg,
                                                      DEL,
                                                      FieldByName('RDB$VALIDATION_SOURCE').AsString,
                                                      DEL,
                                                      FieldByName('RDB$DESCRIPTION').AsString]));
          Next;
        end;
      end;
    except
      on E: Exception do
        DisplayMsg (ERR_PROPERTIES, E.Message);

    end;
  finally
    Screen.Cursor := crDefault;
    if Assigned(Qry) then
      Qry.Free;
    if Assigned(Trans) then
      Trans.Free;
    if Assigned (IBExtract) then
      IBExtract.Free;
  end;
end;
function TdmMain.GetProcedureSource(var ObjectList: TStringList;
  const InDatabase: TIBDatabase; const ProcName: String): integer;
var
  lSQLStr: string;
  lQry: TIBSql;

begin
  result := FAILURE;
  if InDatabase.DefaultTransaction.InTransaction then
    InDatabase.DefaultTransaction.Commit;

  InDatabase.DefaultTransaction.StartTransaction;

  lQry := nil;
  try
    lQry := TIBSQL.Create(self);
    with lQry do
    begin
      Database := InDatabase;
      Transaction := InDatabase.DefaultTransaction;
      lSQLStr := 'select rdb$procedure_source';
      lSQLStr := Format('%s from rdb$procedures', [lSQLStr]);
      lSQLStr := Format('%s where rdb$procedure_name = ''%s''', [lSQLStr, ProcName]);
      SQL.Clear;
      SQL.Add(lSQLStr);
      try
        ExecQuery;
        if not EOF then
          ObjectList.Add (FieldByName('RDB$PROCEDURE_SOURCE').AsString);
        Close;
      except
        on E:EIBError do
        begin
          DisplayMsg(ERR_GET_PROCEDURES, E.Message);
          result := FAILURE;
        end;
      end;
    end;
  finally
    lQry.Free;
    InDatabase.DefaultTransaction.Commit;
  end;
end;

end.

