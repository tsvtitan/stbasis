-- $DEFINE DELIMITER /

DROP PROCEDURE ADQA_All_values/

CREATE PROCEDURE ADQA_All_values(
out o_bigint bigint,
out o_binary binary(50),
out o_bit bit,
out o_char char(10),
out o_date date,
out o_time time,
out o_decimal decimal(19,4),
out o_double double,
out o_float float,
out o_longbinary long binary,
out o_int int,
out o_numeric numeric(10,8),
out o_real real,
out o_smallint smallint,
out o_longvarchar long varchar,
out o_timestamp timestamp,
out o_tinyint tinyint,
out o_varbinary varbinary(50),
out o_varchar varchar(50)
)
begin
  set o_bigint = -123456;
  set o_binary = cast ('klmnoklmnoklmnoklmnoklmnoklmnoklmnoklmno' as binary(50));
  set o_bit = 0;
  set o_char = 'ABCDE';
  set o_date = convert(date, '1756/12/31', 111);
  set o_time = convert(time, '22:04:59', 8);
  set o_decimal = 8563434747.0343;
  set o_double = 1.234567;
  set o_float = -2.3456789;
  set o_longbinary = 0x6b6c6d6e6f;
  set o_int = -234567;
  set o_numeric = 34.56789;
  set o_real = 34.56789;
  set o_smallint = -456;
  set o_longvarchar = 'vuwxy1';
  set o_timestamp = convert(timestamp, '1970-10-05 23:59:59', 120);
  set o_tinyint = 1;
  set o_varbinary = cast ('klmno1' as binary(50));
  set o_varchar = 'pqrst';
end/

DROP PROCEDURE ADQA_Get_cursor/

CREATE PROCEDURE ADQA_Get_cursor()
begin
  DECLARE  OutCrsr  CURSOR FOR
  SELECT *
  FROM ADQA_All_types;

  OPEN OutCrsr;
end/

DROP PROCEDURE ADQA_Get_values/

CREATE PROCEDURE ADQA_Get_values()
begin
  select *  from ADQA_All_types
end/

DROP FUNCTION ADQA_Identity_return/

CREATE FUNCTION ADQA_Identity_return()
RETURNS INTEGER
NOT DETERMINISTIC
begin
  insert into ADQA_Identity_tab(descr) values('field');
  --select ID = @@Identity;
  RETURN @@Identity
end/

DROP PROCEDURE ADQA_Set_values/

CREATE PROCEDURE ADQA_Set_values(
in i_bigint bigint,
in i_binary binary(50),
in i_bit bit,
in i_char char(10),
in i_date date,
in i_time time,
in i_decimal decimal(19,4),
in i_double double,
in i_float float,
in i_longbinary long binary,
in i_int int,
in i_numeric numeric(10,8),
in i_real real,
in i_smallint smallint,
in i_longvarchar long varchar,
in i_timestamp timestamp,
in i_tinyint tinyint,
in i_varbinary varbinary(50),
in i_varchar varchar(50)
)
begin
  insert into ADQA_All_types(tbigint, tbinary, tbit, tchar, tdate, ttime, tdecimal,
                        tdouble, tfloat, tlongbinary, tint, tnumeric, treal,
                        tsmallint, tlongvarchar, ttimestamp, ttinyint, tvarbinary, tvarchar)
              values   (i_bigint, i_binary, i_bit, i_char, i_date, i_time, i_decimal, i_double,
                        i_float, i_longbinary, i_int, i_numeric, i_real, i_smallint,
                        i_longvarchar, i_timestamp, i_tinyint, i_varbinary, i_varchar)
end/