-- $DEFINE DELIMITER GO

DROP PROCEDURE `ADQA_All_values`
GO

CREATE PROCEDURE `ADQA_All_values` (
  out `o_ttinyint` tinyint(4),
  out `o_tbit` tinyint(1),
  out `o_tbool` tinyint(1),
  out `o_tsmallint` smallint(6),
  out `o_tmediumint` mediumint(9),
  out `o_tint` int(11),
  out `o_tinteger` int(11),
  out `o_tbigint` bigint(20),
  out `o_treal` double,
  out `o_tdouble` double,
  out `o_tfloat` float,
  out `o_tdecimal` decimal(19,4),
  out `o_tnumeric` decimal(10,0),
  out `o_tchar` varchar(100),
  out `o_tvarchar` varchar(100),
  out `o_tdate` date,
  out `o_ttime` time,
  out `o_tyear` year(4),
  out `o_ttimestamp` timestamp(14),
  out `o_tdatetime` datetime)
BEGIN
  set `o_ttinyint` = 1234;
  set `o_tbit` = 1;
  set `o_tbool` = 0;
  set `o_tsmallint` = 42345;
  set `o_tmediumint` = 52345678;
  set `o_tint` = 623456789;
  set `o_tinteger` = 723456789;
  set `o_tbigint` = 823456789012345;
  set `o_treal` = 923.456;
  set `o_tdouble` = 1023.456;
  set `o_tfloat` = 1123.456;
  set `o_tdecimal` = 1223.456;
  set `o_tnumeric` = 1323456;
  set `o_tchar` = '14qweqweqweqweqwe';
  set `o_tvarchar` = '15qweqweqweqweqwe';
  set `o_tdate` = curdate();
  set `o_ttime` = curtime();
  set `o_tyear` = 1969;
  set `o_ttimestamp` = CURRENT_TIMESTAMP();
  set `o_tdatetime` = now(); 
END;
GO

DROP PROCEDURE `ADQA_All`
GO

CREATE PROCEDURE `ADQA_All`(IN `in_1` int, IN in_2 int, 
                            OUT `out_1` int, OUT out_2 int,
                            INOUT `inout_1` int, INOUT inout_2 int)
BEGIN
  SET `out_1` = `in_1` * 10;
  SET out_2 = in_2 * 20;
  SET `inout_1` = `inout_1` * 30;
  SET inout_2 = inout_2 * 40;
  SELECT * FROM `Categories`;
  SELECT * FROM `Territories`;
END;
GO

DROP PROCEDURE `ADQA_NoPars`
GO

CREATE PROCEDURE `ADQA_NoPars`()
BEGIN
END;
GO

DROP FUNCTION `ADQA_Func`
GO

CREATE FUNCTION `ADQA_Func`(`in_1` int) RETURNS int
BEGIN
  RETURN in_1 * 10;
END;
GO

DROP PROCEDURE `ADQA_BlobOnly`
GO

CREATE PROCEDURE `ADQA_BlobOnly`(`in_1` LONGBLOB) 
BEGIN
END;
GO
