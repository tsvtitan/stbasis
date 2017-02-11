-- $DEFINE DELIMITER /

CREATE OR REPLACE PROCEDURE ADQA_set_values(
  IN_nvarchar2 IN NVARCHAR2, IN_varchar2 IN VARCHAR2, IN_number IN NUMBER, IN_float IN FLOAT,
  IN_long IN LONG, IN_varchar IN VARCHAR, IN_date IN DATE, IN_raw IN RAW, IN_rowid IN ROWID,
  IN_nchar IN NCHAR, IN_char IN CHAR, /*IN_nclob IN NCLOB,*/ IN_clob IN CLOB, IN_blob IN BLOB) IS
BEGIN
  INSERT INTO "ADQA_All_types"(tnvarchar2, tvarchar2, tnumber, tfloat, tlong, tvarchar, tdate, traw, trowid,
    tnchar, tchar, /*tnclob,*/ tclob, tblob/*, tbfile, turowid*/)
  VALUES(IN_nvarchar2, IN_varchar2, IN_number, IN_float, IN_long, IN_varchar, IN_date, IN_raw, IN_rowid,
    IN_nchar, IN_char, /*IN_nclob,*/ IN_clob, IN_blob/*, IN_bfile, IN_urowid*/);
END;
/

CREATE OR REPLACE PROCEDURE ADQA_all_values(
  i_nvarchar2 IN NVARCHAR2, i_varchar2 IN VARCHAR2, i_number IN NUMBER, i_float IN FLOAT,
  /*i_long IN LONG,*/ i_varchar IN VARCHAR, i_date IN DATE, i_raw IN RAW, i_rowid IN ROWID,
  i_nchar IN NCHAR, i_char IN CHAR, /*i_nclob IN NCLOB,*/ i_clob IN CLOB, i_blob IN BLOB, --i_bfile IN BFILE, i_urowid IN UROWID,
  o_nvarchar2 OUT NVARCHAR2, o_varchar2 OUT VARCHAR2, o_number OUT NUMBER, o_float OUT FLOAT, --o_long OUT LONG,
  o_varchar OUT VARCHAR, o_date OUT DATE, o_raw OUT RAW, o_rowid OUT ROWID, o_nchar OUT NCHAR, o_char OUT CHAR, --o_nclob OUT NCLOB,
  o_clob OUT CLOB, o_blob OUT BLOB /*,o_bfile OUT BFILE, o_urowid OUT UROWID*/) IS
BEGIN
  o_nvarchar2 := i_nvarchar2;
  o_varchar2 := i_varchar2;
  o_number := i_number;
  o_float := i_float;
  --o_long := i_long;
  o_varchar := i_varchar;
  o_date := i_date;
  o_raw := i_raw;
  o_rowid := i_rowid;
  o_nchar := i_nchar;
  o_char := i_char;
  --o_nclob := i_nclob;
  o_clob := i_clob;
  o_blob := i_blob;
  --o_bfile := i_bfile;
  --o_urowid := i_urowid;
END;
/

CREATE OR REPLACE PROCEDURE ADQA_all_vals(
  i_nvarchar2 IN NVARCHAR2, i_varchar2 IN VARCHAR2, i_number IN NUMBER, i_float IN FLOAT,
  i_long IN LONG, i_varchar IN VARCHAR, i_date IN DATE, i_raw IN RAW, i_rowid IN ROWID,
  i_nchar IN NCHAR, i_char IN CHAR, i_nclob IN NCLOB, i_clob IN CLOB, i_blob IN BLOB,
  i_bfile IN BFILE, i_urowid IN !_ora_UROWID, o_nvarchar2 OUT NVARCHAR2, o_varchar2 OUT VARCHAR2,
  o_number OUT NUMBER, o_float OUT FLOAT, o_long OUT LONG, o_varchar OUT VARCHAR, o_date OUT DATE,
  o_raw OUT RAW, o_rowid OUT ROWID, o_nchar OUT NCHAR, o_char OUT CHAR, o_nclob OUT NCLOB,
  o_clob OUT CLOB, o_blob OUT BLOB ,o_bfile OUT BFILE, o_urowid OUT !_ora_UROWID) IS
BEGIN 
  o_nvarchar2 := i_nvarchar2;
  o_varchar2  := i_varchar2;
  o_number    := i_number;
  o_float     := i_float;
  o_long      := i_long;
  o_varchar   := i_varchar;
  o_date      := i_date;
  o_raw       := i_raw;
  o_rowid     := i_rowid;
  o_nchar     := i_nchar;
  o_char      := i_char;
  o_nclob     := i_nclob;
  o_clob      := i_clob;
  o_blob      := i_blob;
  o_bfile     := i_bfile;
  o_urowid    := i_urowid;
END;
/

CREATE OR REPLACE PROCEDURE ADQA_setnget_values(
  io_nvarchar2 IN OUT NVARCHAR2, io_varchar2 IN OUT VARCHAR2, io_number IN OUT NUMBER, io_float IN OUT FLOAT,
  io_long IN OUT LONG, io_varchar IN OUT VARCHAR, io_date IN OUT DATE, io_raw IN OUT RAW, io_rowid IN OUT ROWID,
  io_nchar IN OUT NCHAR, io_char IN OUT CHAR, /*io_nclob IN OUT NCLOB,*/ io_clob IN OUT CLOB, io_blob IN OUT BLOB) IS
BEGIN
  INSERT INTO "ADQA_All_types"(tnvarchar2, tvarchar2, tnumber, tfloat, tlong, tvarchar, tdate, traw,
      trowid, tnchar, tchar, /*tnclob,*/ tclob, tblob/*, tbfile, turowid*/)
  VALUES(io_nvarchar2, io_varchar2, io_number, io_float, io_long, io_varchar, io_date, io_raw, io_rowid,
      io_nchar, io_char, /*io_nclob,*/ io_clob, io_blob/*, io_bfile, io_urowid*/);
  SELECT tnvarchar2, tvarchar2, tnumber, tfloat, tlong, tvarchar, tdate, traw, trowid,
      tnchar, tchar, /*tnclob,*/ tclob, tblob --tbfile, turowid
  INTO io_nvarchar2, io_varchar2, io_number, io_float, io_long, io_varchar, io_date, io_raw, io_rowid,
      io_nchar, io_char, /*io_nclob,*/ io_clob, io_blob /*io_bfile, io_urowid*/ FROM "ADQA_All_types"
  WHERE ROWNUM = 1;
END;
/

CREATE OR REPLACE PROCEDURE ADQA_get_values(
  out_nvarchar2 OUT NVARCHAR2, out_varchar2 OUT VARCHAR2, out_number OUT NUMBER, out_float OUT FLOAT,
  out_long OUT LONG, out_varchar OUT VARCHAR, out_date OUT DATE, out_raw OUT RAW, out_rowid OUT ROWID,
  out_nchar OUT NCHAR, out_char OUT CHAR, /*out_nclob OUT NCLOB,*/ out_clob OUT CLOB, out_blob OUT BLOB) IS
BEGIN
  SELECT tnvarchar2, tvarchar2, tnumber, tfloat, tlong, tvarchar, tdate, traw, trowid,
         tnchar, tchar, /*tnclob,*/ tclob, tblob --tbfile, turowid
  INTO   out_nvarchar2, out_varchar2, out_number, out_float, out_long, out_varchar, out_date, out_raw, out_rowid,
         out_nchar, out_char, /*out_nclob,*/ out_clob, out_blob --out_bfile, out_urowid
  FROM "ADQA_All_types"
  WHERE ROWNUM = 1;
END;
/

CREATE OR REPLACE PACKAGE ADQA_all_types_pack is
  TYPE TCursor IS REF CURSOR RETURN "ADQA_All_types"%Rowtype;
  FUNCTION Get_Valuesf RETURN TCursor;
  PROCEDURE Get_Valuesp (Cur OUT TCursor);
END;
/

CREATE OR REPLACE PACKAGE BODY ADQA_all_types_pack is
  FUNCTION Get_Valuesf RETURN TCURSOR IS
    Cur TCURSOR;
  BEGIN
    OPEN Cur FOR SELECT * FROM "ADQA_All_types";
    RETURN Cur;
  END;
  PROCEDURE Get_Valuesp (Cur OUT TCursor) IS
  BEGIN
    OPEN Cur FOR SELECT * FROM "ADQA_All_types";
  END;
END;
/

CREATE OR REPLACE PACKAGE ADQA_pack_cursors AS
  TYPE TCursor1 IS REF CURSOR RETURN "Shippers"%Rowtype;
  TYPE TCursor2 IS REF CURSOR RETURN "Categories"%Rowtype;
  TYPE TCursor3 IS REF CURSOR RETURN "Suppliers"%Rowtype;
  PROCEDURE getCursors(Cur1 IN OUT TCursor1, Cur2 IN OUT TCursor2, Cur3 IN OUT TCursor3);
END ADQA_pack_Cursors;
/

CREATE OR REPLACE PACKAGE body ADQA_pack_cursors AS
  PROCEDURE getCursors(Cur1 IN OUT TCursor1, Cur2 IN OUT TCursor2, Cur3 IN OUT TCursor3) IS
  BEGIN
    OPEN Cur1 FOR SELECT * FROM "Shippers";
    OPEN Cur2 FOR SELECT * FROM "Categories";
    OPEN Cur3 FOR SELECT * FROM "Suppliers";
  END;
END ADQA_pack_Cursors;
/

CREATE OR REPLACE PACKAGE ADQA_testpack AS
  TYPE TCursor IS REF Cursor RETURN "Shippers"%Rowtype;
  PROCEDURE selectshippers(Cur IN OUT TCursor);
END ADQA_testpack;
/

CREATE OR REPLACE PACKAGE body ADQA_testpack AS
  PROCEDURE selectshippers(Cur IN OUT TCursor) IS
  BEGIN
    OPEN Cur FOR SELECT * FROM "Shippers";
  END;
END ADQA_testpack;
/

CREATE OR REPLACE PROCEDURE ADQA_outparam(tchar OUT CHAR, tlong IN OUT LONG) IS BEGIN
  tchar := 'ABCDE';
  INSERT INTO "ADQA_MaxLength"(memos) VALUES(tlong);
  tlong := CONCAT(tlong, 'abcde');
END;
/
