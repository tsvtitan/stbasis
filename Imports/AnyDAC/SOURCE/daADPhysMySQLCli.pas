{-------------------------------------------------------------------------------}
{ AnyDAC MySQL API                                                              }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysMySQLCli;

interface

uses
  daADStanIntf;

{------------------------------------------------------------------------------}
{ mysql_com.h                                                                  }
{ Common definition between mysql server & client                              }
{------------------------------------------------------------------------------}

const
  NAME_LEN              = 64;     // Field/table name length
  HOSTNAME_LENGTH       = 60;
  USERNAME_LENGTH       = 16;
  SERVER_VERSION_LENGTH = 60;
  SQLSTATE_LENGTH       = 5;

  LOCAL_HOST            = 'localhost';
  LOCAL_HOST_NAMEDPIPE  = '.';

  MYSQL_PORT            = 3306;   // Alloced by ISI for MySQL
  MYSQL_UNIX_ADDR       = '/tmp/mysql.sock';
  MYSQL_NAMEDPIPE       = 'MySQL';
  MYSQL_SERVICENAME     = 'MySql';

type
  my_bool       = Byte;
  Pmy_bool      = ^my_bool;
  my_socket     = Integer;
  GPtr          = PChar;
  PPByte        = ^PChar;

  PNET = Pointer;
  PMEM_ROOT = Pointer;
  PMYSQL_FIELD = Pointer;
  PMYSQL_ROWS = Pointer;
  PPMYSQL_ROWS = ^PMYSQL_ROWS;
  PMYSQL_DATA = Pointer;
  PMYSQL_OPTIONS = Pointer;
  PMYSQL = Pointer;
  PMYSQL_RES = Pointer;
  PMYSQL_BIND = Pointer;
  PMYSQL_STMT = Pointer;
  PMYSQL_METHODS = Pointer;

type
  enum_server_command = Byte;
const
  COM_SLEEP = 0;
  COM_QUIT = 1;
  COM_INIT_DB = 2;
  COM_QUERY = 3;
  COM_FIELD_LIST = 4;
  COM_CREATE_DB = 5;
  COM_DROP_DB = 6;
  COM_REFRESH = 7;
  COM_SHUTDOWN = 8;
  COM_STATISTICS = 9;
  COM_PROCESS_INFO = 10;
  COM_CONNECT = 11;
  COM_PROCESS_KILL = 12;
  COM_DEBUG = 13;
  COM_PING = 14;
  COM_TIME = 15;
  COM_DELAYED_INSERT = 16;
  COM_CHANGE_USER = 17;
  COM_BINLOG_DUMP = 18;
  COM_TABLE_DUMP = 19;
  COM_CONNECT_OUT = 20;
{>= 4.0}
  COM_REGISTER_SLAVE = 21;
{>= 4.1}
  COM_PREPARE = 22;
  COM_EXECUTE = 23;
  COM_LONG_DATA = 24;
  COM_CLOSE_STMT = 25;
  COM_RESET_STMT = 26;
  COM_SET_OPTION = 27;
{>= 5.0}
  COM_FETCH = 28;
  COM_END = 29;

const
  SCRAMBLE_LENGTH     = 20;
  SCRAMBLE_LENGTH_323 = 8;

  NOT_NULL_FLAG       = 1;    // Field can't be NULL
  PRI_KEY_FLAG        = 2;    // Field is part of a primary key
  UNIQUE_KEY_FLAG     = 4;    // Field is part of a unique key
  MULTIPLE_KEY_FLAG   = 8;    // Field is part of a key
  BLOB_FLAG           = 16;   // Field is a blob
  UNSIGNED_FLAG       = 32;   // Field is unsigned
  ZEROFILL_FLAG       = 64;   // Field is zerofill
  BINARY_FLAG         = 128;
  // The following are only sent to new clients
  ENUM_FLAG           = 256;    // field is an enum
  AUTO_INCREMENT_FLAG = 512;    // field is a autoincrement field
  TIMESTAMP_FLAG      = 1024;   // Field is a timestamp
  SET_FLAG            = 2048;   // field is a set
  NUM_FLAG            = 32768;  // Field is num (for clients)
  PART_KEY_FLAG       = 16384;  // Intern; Part of some key
  GROUP_FLAG          = 32768;  // Intern: Group field
  UNIQUE_FLAG         = 65536;  // Intern: Used by sql_yacc
{>= 4.1 begin}
  BINCMP_FLAG         = 131072; // Intern: Used by sql_yacc
{>= 4.1 end}

  REFRESH_GRANT   = 1;    // Refresh grant tables
  REFRESH_LOG     = 2;    // Start on new log file
  REFRESH_TABLES  = 4;    // close all tables
  REFRESH_HOSTS   = 8;    // Flush host cache
  REFRESH_STATUS  = 16;   // Flush status variables
  REFRESH_THREADS = 32;   // Flush status variables
  REFRESH_SLAVE   = 64;   // Reset master info and restart slave thread
  REFRESH_MASTER  = 128;  // Remove all bin logs in the index and truncate the index

  // The following can't be set with mysql_refresh()
  REFRESH_READ_LOCK = 16384;  // Lock tables for read
  REFRESH_FAST      = 32768;  // Intern flag

{>= 4.0 begin}
  // RESET (remove all queries) from query cache
  REFRESH_QUERY_CACHE         = 65536;
  REFRESH_QUERY_CACHE_FREE    = $20000;  // pack query cache
  REFRESH_DES_KEY_FILE        = $40000;
  REFRESH_USER_RESOURCES      = $80000;
{>= 4.0 end}

  CLIENT_LONG_PASSWORD    = 1;    // new more secure passwords
  CLIENT_FOUND_ROWS       = 2;    // Found instead of affected rows
  CLIENT_LONG_FLAG        = 4;    // Get all column flags
  CLIENT_CONNECT_WITH_DB  = 8;    // One can specify db on connect
  CLIENT_NO_SCHEMA        = 16;   // Don't allow database.table.column
  CLIENT_COMPRESS         = 32;   // Can use compression protocol
  CLIENT_ODBC             = 64;   // Odbc client
  CLIENT_LOCAL_FILES      = 128;  // Can use LOAD DATA LOCAL
  CLIENT_IGNORE_SPACE     = 256;  // Ignore spaces before '('
{>= 4.0 begin}
  CLIENT_CHANGE_USER      = 512;  // Support the mysql_change_user()
  AD_50_CLIENT_PROTOCOL_41= 512;  // New 4.1 protocol
{>= 4.0 end}
  CLIENT_INTERACTIVE      = 1024; // This is an interactive client
  CLIENT_SSL              = 2048; // Switch to SSL after handshake
  CLIENT_IGNORE_SIGPIPE   = 4096; // IGNORE sigpipes
  CLIENT_TRANSACTIONS     = 8192; // Client knows about transactions
{>= 4.1 begin}
  CLIENT_PROTOCOL_41       = 16384; // New 4.1 protocol
  AD_50_CLIENT_RESERVED    = 16384; // Old flag for 4.1 protocol
  CLIENT_SECURE_CONNECTION = 32768; // New 4.1 authentication
  CLIENT_MULTI_STATEMENTS  = 65536; // Enable/disable multi-stmt support
  CLIENT_MULTI_QUERIES     = CLIENT_MULTI_STATEMENTS;
  CLIENT_MULTI_RESULTS     = 131072; // Enable/disable multi-results
{>= 4.1 end}
{>= 5.0.6 begin}
  CLIENT_REMEMBER_OPTIONS	 = 1 shl 31;
{>= 5.0.6 end}

  SERVER_STATUS_IN_TRANS          = 1;    // Transaction has started
  SERVER_STATUS_AUTOCOMMIT        = 2;    // Server in auto_commit mode
{>= 4.1 begin}
  SERVER_STATUS_MORE_RESULTS      = 4;    // More results on server
  SERVER_MORE_RESULTS_EXISTS      = 8;    // Multi query - next query exists
  SERVER_QUERY_NO_GOOD_INDEX_USED = 16;
  SERVER_QUERY_NO_INDEX_USED      = 32;
{>= 5.0.6 begin}
  // The server was able to fulfill client request and open read-only
  // non-scrollable cursor for the query.  This flag comes in server
  // status with reply to COM_EXECUTE and COM_EXECUTE_DIRECT commands.
  SERVER_STATUS_CURSOR_EXISTS     = 64;
  // This flag is sent with last row of read-only cursor, in reply to
  // COM_FETCH command.
  SERVER_STATUS_LAST_ROW_SENT     = 128;
{>= 5.0.6 end}
  SERVER_STATUS_DB_DROPPED        = 256;
{>= 4.1 end}

  MYSQL_ERRMSG_SIZE = 200;
  NET_READ_TIMEOUT  = 30;       // Timeout on read
  NET_WRITE_TIMEOUT = 60;       // Timeout on write
  NET_WAIT_TIMEOUT  = 8*60*60;  // Wait for new query

type
  PNET0506 = ^NET0506;
  NET0506 = packed record
    vio:              Pointer;
    buff,
    buff_end,
    write_pos,
    read_pos:         PChar;
    fd:               my_socket;
    max_packet,
    max_packet_size:  LongWord;
    pkt_nr,
    compress_pkt_nr:  LongWord;
    write_timeout,
    read_timeout,
    retry_count:      LongWord;
    fcntl:            Integer;
    compress:         my_bool;
    // The following variable is set if we are doing several queries in one
    // command ( as in LOAD TABLE ... FROM MASTER ),
    // and do not want to confuse the client with OK at the wrong time
    remain_in_buf,
    length,
    buf_length,
    where_b:          LongWord;
    return_status:    PLongWord;
    reading_or_writing:Byte;
    save_char:        Char;
    no_send_ok:       my_bool; // For SPs and other things that do multiple stmts
    no_send_eof:      my_bool; // For SPs' first version read-only cursors
    // Set if OK packet is already sent, and we do not need to send error
    // messages
    no_send_error:    my_bool;
    // Pointer to query object in query cache, do not equal NULL (0) for
    // queries in cache that have not stored its results yet
    last_error:       array[0 .. MYSQL_ERRMSG_SIZE - 1] of Char;
    sqlstate:         array[0 .. SQLSTATE_LENGTH] of Char;
    last_errno:       LongWord;
    error:            Byte;
    query_cache_query:GPtr;
    report_error:     my_bool; // We should report error (we have unreported error)
    return_errno:     my_bool;
  end;
  PNET0500 = ^NET0500;
  NET0500 = packed record
    vio:              Pointer;
    buff,
    buff_end,
    write_pos,
    read_pos:         PChar;
    fd:               my_socket;
    max_packet,
    max_packet_size:  LongWord;
    pkt_nr,
    compress_pkt_nr:  LongWord;
    write_timeout,
    read_timeout,
    retry_count:      LongWord;
    fcntl:            Integer;
    compress:         my_bool;
    // The following variable is set if we are doing several queries in one
    // command ( as in LOAD TABLE ... FROM MASTER ),
    // and do not want to confuse the client with OK at the wrong time
    remain_in_buf,
    length,
    buf_length,
    where_b:          LongWord;
    return_status:    PLongWord;
    reading_or_writing:Byte;
    save_char:        Char;
    no_send_ok:       my_bool; // For SPs and other things that do multiple stmts
    no_send_eof:      my_bool; // For SPs' first version read-only cursors
    // Pointer to query object in query cache, do not equal NULL (0) for
    // queries in cache that have not stored its results yet
    last_error:       array[0 .. MYSQL_ERRMSG_SIZE - 1] of Char;
    sqlstate:         array[0 .. SQLSTATE_LENGTH] of Char;
    last_errno:       LongWord;
    error:            Byte;
    query_cache_query:GPtr;
    report_error:     my_bool; // We should report error (we have unreported error)
    return_errno:     my_bool;
  end;
  PNET0410 = ^NET0410;
  NET0410 = packed record
    vio:              Pointer;
    buff,
    buff_end,
    write_pos,
    read_pos:         PChar;
    fd:               my_socket;
    max_packet,
    max_packet_size:  LongWord;
    pkt_nr,
    compress_pkt_nr:  LongWord;
    write_timeout,
    read_timeout,
    retry_count:      LongWord;
    fcntl:            Integer;
    compress:         my_bool;
    // The following variable is set if we are doing several queries in one
    // command ( as in LOAD TABLE ... FROM MASTER ),
    // and do not want to confuse the client with OK at the wrong time
    remain_in_buf,
    length,
    buf_length,
    where_b:          LongWord;
    return_status:    PLongWord;
    reading_or_writing:Byte;
    save_char:        Char;
    no_send_ok:       my_bool; // For SPs and other things that do multiple stmts
    // Pointer to query object in query cache, do not equal NULL (0) for
    // queries in cache that have not stored its results yet
    last_error:       array[0 .. MYSQL_ERRMSG_SIZE - 1] of Char;
    sqlstate:         array[0 .. SQLSTATE_LENGTH] of Char;
    last_errno:       LongWord;
    error:            Byte;
    query_cache_query:GPtr;
    report_error:     my_bool; // We should report error (we have unreported error)
    return_errno:     my_bool;
  end;
  PNET0400 = ^NET0400;
  NET0400 = packed record
    vio:              Pointer;
    buff,
    buff_end,
    write_pos,
    read_pos:         PChar;
    fd:               my_socket;
    max_packet,
    max_packet_size:  LongWord;
    last_errno,
    pkt_nr,
    compress_pkt_nr:  LongWord;
    write_timeout,
    read_timeout,
    retry_count:      LongWord;
    fcntl:            Integer;
    last_error:       array[0 .. MYSQL_ERRMSG_SIZE - 1] of Char;
    error:            Byte;
    return_errno,
    compress:         my_bool;
    // The following variable is set if we are doing several queries in one
    // command ( as in LOAD TABLE ... FROM MASTER ),
    // and do not want to confuse the client with OK at the wrong time
    remain_in_buf,
    length,
    buf_length,
    where_b:          LongWord;
    return_status:    PLongWord;
    reading_or_writing: Byte;
    save_char:     Char;
    no_send_ok:    my_bool;
    query_cache_query: GPtr;
  end;
  PNET0323 = ^NET0323;
  NET0323 = packed record
    vio:           Pointer;
    fd:            my_socket;
    fcntl:         Integer;   // For Perl DBI/dbd
    buff,
    buff_end,
    write_pos,
    read_pos:      PChar;
    last_error:    array[0 .. MYSQL_ERRMSG_SIZE - 1] of Char;
    last_errno,
    max_packet,
    timeout,
    pkt_nr:        LongWord;
    error:         Byte;
    return_errno,
    compress,
    no_send_ok:    my_bool; // needed if we are doing several queries in one
      // command ( as in LOAD TABLE ... FROM MASTER ), and do not want to confuse
      // the client with OK at the wrong time
    remain_in_buf,
    length,
    buf_length,
    where_b:       LongWord;
    return_status: PLongWord;
    reading_or_writing: Byte;
    save_char:     Char;
  end;
  PNET0320 = ^NET0320;
  NET0320 = packed record
    vio:           Pointer;
    fd:            my_socket;
    fcntl:         Integer;   // For Perl DBI/dbd
    buff,
    buff_end,
    write_pos,
    read_pos:      PChar;
    last_error:    array[0 .. MYSQL_ERRMSG_SIZE - 1] of Char;
    last_errno,
    max_packet,
    timeout,
    pkt_nr:        LongWord;
    error:         Byte;
    return_errno,
    compress:      my_bool;
    remain_in_buf,
    length,
    buf_length,
    where_b:       LongWord;
    more:          Byte;
    save_char:     Char;
  end;

const
  // enum_field_types
  FIELD_TYPE_DECIMAL    = 0;
  FIELD_TYPE_TINY       = 1;
  FIELD_TYPE_SHORT      = 2;
  FIELD_TYPE_LONG       = 3;
  FIELD_TYPE_FLOAT      = 4;
  FIELD_TYPE_DOUBLE     = 5;
  FIELD_TYPE_NULL       = 6;
  FIELD_TYPE_TIMESTAMP  = 7;
  FIELD_TYPE_LONGLONG   = 8;
  FIELD_TYPE_INT24      = 9;
  FIELD_TYPE_DATE       = 10;
  FIELD_TYPE_TIME       = 11;
  FIELD_TYPE_DATETIME   = 12;
  FIELD_TYPE_YEAR       = 13;
  FIELD_TYPE_NEWDATE    = 14;
{>= 5.0.6 begin}
  FIELD_TYPE_VARCHAR    = 15;
  FIELD_TYPE_BIT        = 16;
  FIELD_TYPE_NEWDECIMAL = 246;
{>= 5.0.6 end}
  FIELD_TYPE_ENUM       = 247;
  FIELD_TYPE_SET        = 248;
  FIELD_TYPE_TINY_BLOB  = 249;
  FIELD_TYPE_MEDIUM_BLOB= 250;
  FIELD_TYPE_LONG_BLOB  = 251;
  FIELD_TYPE_BLOB       = 252;
  FIELD_TYPE_VAR_STRING = 253;
  FIELD_TYPE_STRING     = 254;
{>= 4.0 begin}
  FIELD_TYPE_GEOMETRY   = 255;
{>= 4.0 end}
  FIELD_TYPE_CHAR      = FIELD_TYPE_TINY; // For Compatibility
  FIELD_TYPE_INTERVAL  = FIELD_TYPE_ENUM; // For Compatibility

{------------------------------------------------------------------------------}
{ mysql.h                                                                      }
{ defines for the Libmysql                                                     }
{------------------------------------------------------------------------------}

type
  PUSED_MEM = ^USED_MEM;
  USED_MEM = packed record   // struct for once_alloc
    next: PUSED_MEM;         // Next block in use
    left: LongWord;          // memory left in block
    size: LongWord;          // size of block
  end;

  TVoidProc = procedure;
  PVoidProc = ^TVoidProc;

  PMEM_ROOT0410 = ^MEM_ROOT0410;
  MEM_ROOT0410 = packed record
    free:          PUSED_MEM;
    used:          PUSED_MEM;
    pre_alloc:     PUSED_MEM;
    min_malloc:    LongWord;
    block_size:    LongWord;
    block_num:     LongWord;
    first_block_usage:LongWord;
    error_handler: PVoidProc;
  end;
  PMEM_ROOT0323 = ^MEM_ROOT0323;
  MEM_ROOT0323 = packed record
    free:          PUSED_MEM;
    used:          PUSED_MEM;
    pre_alloc:     PUSED_MEM;
    min_malloc:    LongWord;
    block_size:    LongWord;
    error_handler: PVoidProc;
  end;
  PMEM_ROOT0320 = ^MEM_ROOT0320;
  MEM_ROOT0320 = packed record
    free:          PUSED_MEM;
    used:          PUSED_MEM;
    min_malloc:    LongWord;
    block_size:    LongWord;
    error_handler: PVoidProc;
  end;

  PMYSQL_FIELD0410 = ^MYSQL_FIELD0410;
  MYSQL_FIELD0410 = record
    name:             PChar;    // Name of column
    org_name:         PChar;    // Original column name, if an alias
    table:            PChar;    // Table of column if column was a field
    org_table:        PChar;    // Org table name if table was an alias
    db:               PChar;    // Database for table
    catalog:          PChar;    // Catalog for table
    def:              PChar;    // Default value (set by mysql_list_fields)
    length:           LongWord; // Width of column
    max_length:       LongWord; // Max width of selected set
    name_length:      LongWord;
    org_name_length:  LongWord;
    table_length:     LongWord;
    org_table_length: LongWord;
    db_length:        LongWord;
    catalog_length:   LongWord;
    def_length:       LongWord;
    flags:            LongWord; // Div flags
    decimals:         LongWord; // Number of decimals in field
    charsetnr:        LongWord; // Character set
    type_:            Byte;     // Type of field. Se enum_field_types.
  end;
  PMYSQL_FIELD0401 = ^MYSQL_FIELD0401;
  MYSQL_FIELD0401 = record
    name:             PChar;    // Name of column
    org_name:         PChar;    // Original column name, if an alias
    table:            PChar;    // Table of column if column was a field
    org_table:        PChar;    // Org table name if table was an alias
    db:               PChar;    // Database for table
    def:              PChar;    // Default value (set by mysql_list_fields)
    length:           LongWord; // Width of column
    max_length:       LongWord; // Max width of selected set
    name_length:      LongWord;
    org_name_length:  LongWord;
    table_length:     LongWord;
    org_table_length: LongWord;
    db_length:        LongWord;
    def_length:       LongWord;
    flags:            LongWord; // Div flags
    decimals:         LongWord; // Number of decimals in field
    charsetnr:        LongWord; // Character set
    type_:            Byte;     // Type of field. Se mysql_com.h for types
  end;
  PMYSQL_FIELD0400 = ^MYSQL_FIELD0400;
  MYSQL_FIELD0400 = record
    name:       PChar;    // Name of column
    table:      PChar;    // Table of column if column was a field
    org_table:  PChar;    // Org table name if table was an alias
    db:         PChar;    // Database for table
    def:        PChar;    // Default value (set by mysql_list_fields)
    length:     LongWord; // Width of column
    max_length: LongWord; // Max width of selected set
    flags:      LongWord; // Div flags
    decimals:   LongWord; // Number of decimals in field
    type_:      Byte;     // Type of field. Se mysql_com.h for types
  end;
  PMYSQL_FIELD0320 = ^MYSQL_FIELD0320;
  MYSQL_FIELD0320 = record
    name:       PChar;    // Name of column
    table:      PChar;    // Table of column if column was a field
    def:        PChar;    // Default value (set by mysql_list_fields)
    type_:      Byte;     // Type of field. Se mysql_com.h for types
    length:     LongWord; // Width of column
    max_length: LongWord; // Max width of selected set
    flags:      LongWord; // Div flags
    decimals:   LongWord; // Number of decimals in field
  end;

  PMYSQL_ROW = ^MYSQL_ROW;
  MYSQL_ROW = array[00..$FFFF] of PChar;  // return data as array of strings
  MYSQL_FIELD_OFFSET = LongWord;          // offset to current field

type
  my_ulonglong = Int64;
const
  MYSQL_COUNT_ERROR: my_ulonglong = -1;

type
  PMYSQL_ROWS0410 = ^MYSQL_ROWS0410;
  MYSQL_ROWS0410 = record
    next: PMYSQL_ROWS;  // list of rows
    data: MYSQL_ROW;
    length: LongWord;
  end;
  PMYSQL_ROWS0320 = ^MYSQL_ROWS0320;
  MYSQL_ROWS0320 = record
    next: PMYSQL_ROWS;  // list of rows
    data: MYSQL_ROW;
  end;

  MYSQL_ROW_OFFSET = PMYSQL_ROWS;  // offset to current row

  PMYSQL_DATA0506 = ^MYSQL_DATA0506;
  MYSQL_DATA0506 = record
    rows:   my_ulonglong;
    fields: LongWord;
    data:   PMYSQL_ROWS;
    alloc:  MEM_ROOT0410;
    prev_ptr: PPMYSQL_ROWS; // ???
  end;
  PMYSQL_DATA0410 = ^MYSQL_DATA0410;
  MYSQL_DATA0410 = record
    rows:   my_ulonglong;
    fields: LongWord;
    data:   PMYSQL_ROWS;
    alloc:  MEM_ROOT0410;
  end;
  PMYSQL_DATA0323 = ^MYSQL_DATA0323;
  MYSQL_DATA0323 = record
    rows:   my_ulonglong;
    fields: LongWord;
    data:   PMYSQL_ROWS;
    alloc:  MEM_ROOT0323;
  end;
  PMYSQL_DATA0320 = ^MYSQL_DATA0320;
  MYSQL_DATA0320 = record
    rows:   my_ulonglong;
    fields: LongWord;
    data:   PMYSQL_ROWS;
    alloc:  MEM_ROOT0320;
  end;

type
  mysql_option = Byte;
const
  MYSQL_OPT_CONNECT_TIMEOUT = 0;
  MYSQL_OPT_COMPRESS = 1;
  MYSQL_OPT_NAMED_PIPE = 2;
  MYSQL_INIT_COMMAND = 3;
  MYSQL_READ_DEFAULT_FILE = 4;
  MYSQL_READ_DEFAULT_GROUP = 5;
  MYSQL_SET_CHARSET_DIR = 6;
  MYSQL_SET_CHARSET_NAME = 7;
  MYSQL_OPT_LOCAL_INFILE = 8;
{>= 4.1 begin}
  MYSQL_OPT_PROTOCOL = 9;
  MYSQL_SHARED_MEMORY_BASE_NAME = 10;
  MYSQL_OPT_READ_TIMEOUT = 11;
  MYSQL_OPT_WRITE_TIMEOUT = 12;
  MYSQL_OPT_USE_RESULT = 13;
  MYSQL_OPT_USE_REMOTE_CONNECTION = 14;
  MYSQL_OPT_USE_EMBEDDED_CONNECTION = 15;
  MYSQL_OPT_GUESS_CONNECTION = 16;
  MYSQL_SET_CLIENT_IP = 17;
  MYSQL_SECURE_AUTH = 18;
{>= 4.1 end}
{>= 5.0.6 begin}
  MYSQL_REPORT_DATA_TRUNCATION = 19;
{>= 5.0.6 end}

type
  PMYSQL_OPTIONS0506 = ^MYSQL_OPTIONS0506;
  MYSQL_OPTIONS0506 = record
    connect_timeout,
    read_timeout,
    write_timeout,
    port,
    protocol,
    client_flag:     LongWord;
    host,
    user,
    password,
    unix_socket,
    db:              PChar;
    init_commands:   Pointer;  // DA???
    my_cnf_file,
    my_cnf_group:    PChar;
    charset_dir,
    charset_name:    PChar;
    ssl_key,                            // PEM key file
    ssl_cert,                           // PEM cert file
    ssl_ca,                             // PEM CA file
    ssl_capath,                         // PEM directory of CA-s?
    ssl_cipher:      PChar;             // cipher to use
    shared_memory_base_name: PChar;
    max_allowed_packet: LongWord;
    use_ssl:         my_bool;   // if to use SSL or not
    compress,
    named_pipe:      my_bool;
    // On connect, find out the replication role of the server, and
    // establish connections to all the peers
    rpl_probe:       my_bool;
    // Each call to mysql_real_query() will parse it to tell if it is a read
    // or a write, and direct it to the slave or the master
    rpl_parse:       my_bool;
    // If set, never read from a master,only from slave, when doing
    // a read that is replication-aware
    no_master_reads: my_bool;
    separate_thread: my_bool; // ???
    methods_to_use:  mysql_option;
    client_ip:       PChar;
    // Refuse client connecting to server if it uses old (pre-4.1.1) protocol
    secure_auth:     my_bool;
    // 0 - never report, 1 - always report (default)
    report_data_truncation: my_bool;
    // function pointers for local infile support
    local_infile_init: Pointer;
    local_infile_read: Pointer;
    local_infile_end:  Pointer;
    local_infile_error:Pointer;
    local_infile_userdata: Pointer;
  end;
  PMYSQL_OPTIONS0410 = ^MYSQL_OPTIONS0410;
  MYSQL_OPTIONS0410 = record
    connect_timeout,
    read_timeout,
    write_timeout,
    port,
    protocol,
    client_flag:     LongWord;
    host,
    user,
    password,
    unix_socket,
    db:              PChar;
    init_commands:   Pointer;  // DA???
    my_cnf_file,
    my_cnf_group:    PChar;
    charset_dir,
    charset_name:    PChar;
    ssl_key,                            // PEM key file
    ssl_cert,                           // PEM cert file
    ssl_ca,                             // PEM CA file
    ssl_capath,                         // PEM directory of CA-s?
    ssl_cipher:      PChar;             // cipher to use
    shared_memory_base_name: PChar;
    max_allowed_packet: LongWord;
    use_ssl:         my_bool;   // if to use SSL or not
    compress,
    named_pipe:      my_bool;
    // On connect, find out the replication role of the server, and
    // establish connections to all the peers
    rpl_probe:       my_bool;
    // Each call to mysql_real_query() will parse it to tell if it is a read
    // or a write, and direct it to the slave or the master
    rpl_parse:       my_bool;
    // If set, never read from a master,only from slave, when doing
    // a read that is replication-aware
    no_master_reads: my_bool;
    methods_to_use:  mysql_option;
    client_ip:       PChar;
    // Refuse client connecting to server if it uses old (pre-4.1.1) protocol
    secure_auth:     my_bool;
    // function pointers for local infile support
    local_infile_init: Pointer;
    local_infile_read: Pointer;
    local_infile_end:  Pointer;
    local_infile_error:Pointer;
    local_infile_userdata: Pointer;
  end;
  PMYSQL_OPTIONS0400 = ^MYSQL_OPTIONS0400;
  MYSQL_OPTIONS0400 = record
    connect_timeout,
    client_flag:     LongWord;
    port:            LongWord;
    host,
    init_command,
    user,
    password,
    unix_socket,
    db:              PChar;
    my_cnf_file,
    my_cnf_group:    PChar;
    charset_dir,
    charset_name:    PChar;
    ssl_key,                            // PEM key file
    ssl_cert,                           // PEM cert file
    ssl_ca,                             // PEM CA file
    ssl_capath,                         // PEM directory of CA-s?
    ssl_cipher:      PChar;             // cipher to use
    max_allowed_packet: LongWord;
    use_ssl:         my_bool;   // if to use SSL or not
    compress,
    named_pipe:      my_bool;
    // On connect, find out the replication role of the server, and
    // establish connections to all the peers
    rpl_probe:       my_bool;
    // Each call to mysql_real_query() will parse it to tell if it is a read
    // or a write, and direct it to the slave or the master
    rpl_parse:       my_bool;
    // If set, never read from a master,only from slave, when doing
    // a read that is replication-aware
    no_master_reads: my_bool;
  end;
  PMYSQL_OPTIONS0320 = ^MYSQL_OPTIONS0320;
  MYSQL_OPTIONS0320 = record
    connect_timeout,
    client_flag:     LongWord;
    compress,
    named_pipe:      my_bool;
    port:            LongWord;
    host,
    init_command,
    user,
    password,
    unix_socket,
    db:              PChar;
    my_cnf_file,
    my_cnf_group:    PChar;
    charset_dir,
    charset_name:    PChar;
    use_ssl:         my_bool;   // if to use SSL or not
    ssl_key,                            // PEM key file
    ssl_cert,                           // PEM cert file
    ssl_ca,                             // PEM CA file
    ssl_capath:      PChar;             // PEM directory of CA-s?
  end;

type
  mysql_status = Byte;
const
  MYSQL_STATUS_READY = 0;
  MYSQL_STATUS_GET_RESULT = 1;
  MYSQL_STATUS_USE_RESULT = 2;

{>= 4.1 begin}
type
  mysql_protocol_type = Byte;
const
  MYSQL_PROTOCOL_DEFAULT = 0;
  MYSQL_PROTOCOL_TCP = 1;
  MYSQL_PROTOCOL_SOCKET = 2;
  MYSQL_PROTOCOL_PIPE = 3;
  MYSQL_PROTOCOL_MEMORY = 4;
{>= 4.1 end}

{>= 4.0 begin}
  // There are three types of queries - the ones that have to go to
  // the master, the ones that go to a slave, and the adminstrative
  // type which must happen on the pivot connectioin
type
  mysql_rpl_type = Byte;
const
  MYSQL_RPL_MASTER = 0;
  MYSQL_RPL_SLAVE = 1;
  MYSQL_RPL_ADMIN = 2;
{>= 4.0 end}

{>= 4.1 begin}
type
  PMYSQL_METHODS0506 = ^MYSQL_METHODS0506;
  MYSQL_METHODS0506 = record
    read_query_result: function (mysql: PMYSQL): my_bool;
    advanced_command: function (mysql: PMYSQL; command: enum_server_command;
      header: PChar; header_length: LongWord; arg: PChar; arg_length: LongWord;
      skip_check: my_bool): my_bool;
    read_rows: function (mysql: PMYSQL; mysql_fields: PMYSQL_FIELD;
      fields: LongWord): PMYSQL_DATA;
    use_result: function (mysql: PMYSQL): PMYSQL_RES;
    fetch_lengths: procedure (_to: PLongWord; column: MYSQL_ROW;
      field_count: LongWord);
    flush_use_result: procedure (mysql: PMYSQL);
    list_fields: function (mysql: PMYSQL): PMYSQL_FIELD;
    read_prepare_result: function (mysql: PMYSQL; stmt: PMYSQL_STMT): my_bool;
    stmt_execute: function (stmt: PMYSQL_STMT): Integer;
    read_binary_rows: function (stmt: PMYSQL_STMT): Integer;
    unbuffered_fetch: function (mysql: PMYSQL; row: PPChar): Integer;
    free_embedded_thd: procedure (mysql: PMYSQL);
    read_statistics: function (mysql: PMYSQL): PChar;
    next_result: function (mysql: PMYSQL): my_bool;
    read_change_user_result: function (mysql: PMYSQL; buff: PChar;
      passwd: PChar): Integer;
  end;
  PMYSQL_METHODS0410 = ^MYSQL_METHODS0410;
  MYSQL_METHODS0410 = record
    read_query_result: function (mysql: PMYSQL): my_bool;
    advanced_command: function (mysql: PMYSQL; command: enum_server_command;
      header: PChar; header_length: LongWord; arg: PChar; arg_length: LongWord;
      skip_check: my_bool): my_bool;
    read_rows: function (mysql: PMYSQL; mysql_fields: PMYSQL_FIELD;
      fields: LongWord): PMYSQL_DATA;
    use_result: function (mysql: PMYSQL): PMYSQL_RES;
    fetch_lengths: procedure (_to: PLongWord; column: MYSQL_ROW;
      field_count: LongWord);
    list_fields: function (mysql: PMYSQL): PMYSQL_FIELD;
    read_prepare_result: function (mysql: PMYSQL; stmt: PMYSQL_STMT): my_bool;
    stmt_execute: function (stmt: PMYSQL_STMT): Integer;
    read_binary_rows: function (stmt: PMYSQL_STMT): Integer;
    unbuffered_fetch: function (mysql: PMYSQL; row: PPChar): Integer;
    free_embedded_thd: procedure (mysql: PMYSQL);
    read_statistics: function (mysql: PMYSQL): PChar;
    next_result: function (mysql: PMYSQL): my_bool;
    read_change_user_result: function (mysql: PMYSQL; buff: PChar;
      passwd: PChar): Integer;
  end;
{>= 4.1 end}

  PMYSQL_LIST = ^MYSQL_LIST;
  MYSQL_LIST = packed record
    prev, next: PMYSQL_LIST;
    data: Pointer;
  end;

  PMY_CHARSET_INFO = ^MY_CHARSET_INFO;
  MY_CHARSET_INFO = packed record
    number:   LongWord;  // character set number
    state:    LongWord;  // character set state
    csname:   PChar;     // collation name
    name:     PChar;     // character set name
    comment:  PChar;     // comment
    dir:      PChar;     // character set directory
    mbminlen: LongWord;  // min. length for multibyte strings
    mbmaxlen: LongWord;  // max. length for multibyte strings
  end;

  PMYSQL0506 = ^MYSQL0506;
  MYSQL0506 = record
    net:                  NET0506;      // Communication parameters
    connector_fd:         GPtr;         // ConnectorFd for SSL
    host,
    user,
    passwd,
    unix_socket,
    server_version,
    host_info,
    info,
    db:                   PChar;
    charset:              PMY_CHARSET_INFO;
    fields:               PMYSQL_FIELD;
    field_alloc:          MEM_ROOT0410;
    affected_rows,
    insert_id,                          // id if insert on table with NEXTNR
    extra_info:           my_ulonglong; // Used by mysqlshow
    thread_id:            LongInt;      // Id for connection in server
    packet_length:        LongWord;
    port,
    client_flag,
    server_capabilities:  LongWord;
    protocol_version:     LongWord;
    field_count:          LongWord;
    server_status:        LongWord;
    server_language:      LongWord;
    warning_count:        LongWord;
    options:              MYSQL_OPTIONS0506;
    status:               mysql_status;
    free_me,                            // If free in mysql_close
    reconnect:            my_bool;      // set to 1 if automatic reconnect
    scramble:             array[0..SCRAMBLE_LENGTH] of Char;
    // Set if this is the original connection, not a master or a slave we have
    // added though mysql_rpl_probe() or mysql_set_master()/ mysql_add_slave()
    rpl_pivot:            my_bool;
    // Pointers to the master, and the next slave connections, points to
    // itself if lone connection.
    master,
    next_slave:           PMYSQL;
    last_used_slave:      PMYSQL;       // needed for round-robin slave pick
    // needed for send/read/store/use result to work correctly with replication
    last_used_con:        PMYSQL;
    stmts:                PMYSQL_LIST;  // list of all statements
    methods:              PMYSQL_METHODS0506;
    thd:                  Pointer;
    // Points to boolean flag in MYSQL_RES  or MYSQL_STMT. We set this flag
    // from mysql_stmt_close if close had to cancel result set of this object.
    unbuffered_fetch_owner: my_bool;
    // needed for embedded server - no net buffer to store the 'info'
    info_buffer:          PChar;
  end;
  PMYSQL0500 = ^MYSQL0500;
  MYSQL0500 = record
    net:                  NET0500;      // Communication parameters
    connector_fd:         GPtr;         // ConnectorFd for SSL
    host,
    user,
    passwd,
    unix_socket,
    server_version,
    host_info,
    info,
    db:                   PChar;
    charset:              PMY_CHARSET_INFO;
    fields:               PMYSQL_FIELD;
    field_alloc:          MEM_ROOT0410;
    affected_rows,
    insert_id,                          // id if insert on table with NEXTNR
    extra_info:           my_ulonglong; // Used by mysqlshow
    thread_id:            LongInt;      // Id for connection in server
    packet_length:        LongWord;
    port,
    client_flag,
    server_capabilities:  LongWord;
    protocol_version:     LongWord;
    field_count:          LongWord;
    server_status:        LongWord;
    server_language:      LongWord;
    warning_count:        LongWord;
    options:              MYSQL_OPTIONS0410;
    status:               mysql_status;
    free_me,                            // If free in mysql_close
    reconnect:            my_bool;      // set to 1 if automatic reconnect
    scramble:             array[0..SCRAMBLE_LENGTH] of Char;
    // Set if this is the original connection, not a master or a slave we have
    // added though mysql_rpl_probe() or mysql_set_master()/ mysql_add_slave()
    rpl_pivot:            my_bool;
    // Pointers to the master, and the next slave connections, points to
    // itself if lone connection.
    master,
    next_slave:           PMYSQL;
    last_used_slave:      PMYSQL;       // needed for round-robin slave pick
    // needed for send/read/store/use result to work correctly with replication
    last_used_con:        PMYSQL;
    stmts:                PMYSQL_LIST;  // list of all statements
    methods:              PMYSQL_METHODS;
    thd:                  Pointer;
    // Points to boolean flag in MYSQL_RES  or MYSQL_STMT. We set this flag
    // from mysql_stmt_close if close had to cancel result set of this object.
    unbuffered_fetch_owner: my_bool;
    // needed for embedded server - no net buffer to store the 'info'
    info_buffer:          PChar;
  end;
  PMYSQL0410 = ^MYSQL0410;
  MYSQL0410 = record
    net:                  NET0410;      // Communication parameters
    connector_fd:         GPtr;         // ConnectorFd for SSL
    host,
    user,
    passwd,
    unix_socket,
    server_version,
    host_info,
    info,
    db:                   PChar;
    charset:              PMY_CHARSET_INFO;
    fields:               PMYSQL_FIELD;
    field_alloc:          MEM_ROOT0410;
    affected_rows,
    insert_id,                          // id if insert on table with NEXTNR
    extra_info:           my_ulonglong; // Used by mysqlshow
    thread_id:            LongInt;      // Id for connection in server
    packet_length:        LongWord;
    port,
    client_flag,
    server_capabilities:  LongWord;
    protocol_version:     LongWord;
    field_count:          LongWord;
    server_status:        LongWord;
    server_language:      LongWord;
    warning_count:        LongWord;
    options:              MYSQL_OPTIONS0410;
    status:               mysql_status;
    free_me,                            // If free in mysql_close
    reconnect:            my_bool;      // set to 1 if automatic reconnect
    scramble:             array[0..SCRAMBLE_LENGTH] of Char;
    // Set if this is the original connection, not a master or a slave we have
    // added though mysql_rpl_probe() or mysql_set_master()/ mysql_add_slave()
    rpl_pivot:            my_bool;
    // Pointers to the master, and the next slave connections, points to
    // itself if lone connection.
    master,
    next_slave:           PMYSQL;
    last_used_slave:      PMYSQL;       // needed for round-robin slave pick
    // needed for send/read/store/use result to work correctly with replication
    last_used_con:        PMYSQL;
    stmts:                PMYSQL_LIST;  // list of all statements
    methods:              PMYSQL_METHODS;
    thd:                  Pointer;
    // Points to boolean flag in MYSQL_RES  or MYSQL_STMT. We set this flag
    // from mysql_stmt_close if close had to cancel result set of this object.
    unbuffered_fetch_owner: my_bool;
  end;
  PMYSQL0400 = ^MYSQL0400;
  MYSQL0400 = record
    net:                  NET0400;      // Communication parameters
    connector_fd:         GPtr;         // ConnectorFd for SSL
    host,
    user,
    passwd,
    unix_socket,
    server_version,
    host_info,
    info,
    db:                   PChar;
    charset:              PMY_CHARSET_INFO;
    fields:               PMYSQL_FIELD;
    field_alloc:          MEM_ROOT0323;
    affected_rows,
    insert_id,                          // id if insert on table with NEXTNR
    extra_info:           my_ulonglong; // Used by mysqlshow
    thread_id:            LongInt;      // Id for connection in server
    packet_length:        LongWord;
    port,
    client_flag,
    server_capabilities:  LongWord;
    protocol_version:     LongWord;
    field_count:          LongWord;
    server_status:        LongWord;
    server_language:      LongWord;
    options:              MYSQL_OPTIONS0400;
    status:               mysql_status;
    free_me,                            // If free in mysql_close
    reconnect:            my_bool;      // set to 1 if automatic reconnect
    scramble_buff:        array[0..SCRAMBLE_LENGTH_323] of Char;
    // Set if this is the original connection, not a master or a slave we have
    // added though mysql_rpl_probe() or mysql_set_master()/ mysql_add_slave()
    rpl_pivot:            my_bool;
    // Pointers to the master, and the next slave connections, points to
    // itself if lone connection.
    master,
    next_slave:           PMYSQL;
    last_used_slave:      PMYSQL;       // needed for round-robin slave pick
    // needed for send/read/store/use result to work correctly with replication
    last_used_con:        PMYSQL;
  end;
  PMYSQL0323 = ^MYSQL0323;
  MYSQL0323 = record
    net:                  NET0323;      // Communication parameters
    connector_fd:         GPtr;         // ConnectorFd for SSL
    host,
    user,
    passwd,
    unix_socket,
    server_version,
    host_info,
    info,
    db:                   PChar;
    port,
    client_flag,
    server_capabilities:  LongWord;
    protocol_version:     LongWord;
    field_count:          LongWord;
    server_status:        LongWord;
    thread_id:            LongInt;      // Id for connection in server
    affected_rows,
    insert_id,                          // id if insert on table with NEXTNR
    extra_info:           my_ulonglong; // Used by mysqlshow
    packet_length:        LongWord;
    status:               mysql_status;
    fields:               PMYSQL_FIELD;
    field_alloc:          MEM_ROOT0323;
    free_me,                            // If free in mysql_close
    reconnect:            my_bool;      // set to 1 if automatic reconnect
    options:              MYSQL_OPTIONS0320;
    scramble_buff:        array[0..SCRAMBLE_LENGTH_323] of Char;
    charset:              PMY_CHARSET_INFO;
    server_language:      LongWord;
  end;
  PMYSQL0320 = ^MYSQL0320;
  MYSQL0320 = record
    net:                  NET0320;      // Communication parameters
    connector_fd:         GPtr;         // ConnectorFd for SSL
    host,
    user,
    passwd,
    unix_socket,
    server_version,
    host_info,
    info,
    db:                   PChar;
    port,
    client_flag,
    server_capabilities:  LongWord;
    protocol_version:     LongWord;
    field_count:          LongWord;
    thread_id:            LongInt;      // Id for connection in server
    affected_rows,
    insert_id,                          // id if insert on table with NEXTNR
    extra_info:           my_ulonglong; // Used by mysqlshow
    packet_length:        LongWord;
    status:               mysql_status;
    fields:               PMYSQL_FIELD;
    field_alloc:          MEM_ROOT0320;
    free_me,                            // If free in mysql_close
    reconnect:            my_bool;      // set to 1 if automatic reconnect
    options:              MYSQL_OPTIONS0320;
    scramble_buff:        array[0..SCRAMBLE_LENGTH_323] of Char;
    charset:              PMY_CHARSET_INFO;
  end;

  PMYSQL_RES0410 = ^MYSQL_RES0410;
  MYSQL_RES0410 = packed record
    row_count:       my_ulonglong;
    fields:          PMYSQL_FIELD;
    data:            PMYSQL_DATA;
    data_cursor:     PMYSQL_ROWS;
    lengths:         PLongInt;    // column lengths of current row
    handle:          PMYSQL;      // for unbuffered reads
    field_alloc:     MEM_ROOT0410;
    field_count,
    current_field:   LongWord;
    row:             MYSQL_ROW;   // If unbuffered read
    current_row:     MYSQL_ROW;   // buffer to current row
    eof:             my_bool;     // Used my mysql_fetch_row
    // mysql_stmt_close() had to cancel this result
    unbuffered_fetch_cancelled: my_bool;
    methods:         PMYSQL_METHODS;
  end;
  PMYSQL_RES0323 = ^MYSQL_RES0323;
  MYSQL_RES0323 = packed record
    row_count:       my_ulonglong;
    field_count,
    current_field:   LongWord;
    fields:          PMYSQL_FIELD;
    data:            PMYSQL_DATA;
    data_cursor:     PMYSQL_ROWS;
    field_alloc:     MEM_ROOT0323;
    row:             MYSQL_ROW;   // If unbuffered read
    current_row:     MYSQL_ROW;   // buffer to current row
    lengths:         PLongInt;    // column lengths of current row
    handle:          PMYSQL;      // for unbuffered reads
    eof:             my_bool;     // Used my mysql_fetch_row
  end;
  PMYSQL_RES0320 = ^MYSQL_RES0320;
  MYSQL_RES0320 = packed record
    row_count:       my_ulonglong;
    field_count,
    current_field:   LongWord;
    fields:          PMYSQL_FIELD;
    data:            PMYSQL_DATA;
    data_cursor:     PMYSQL_ROWS;
    field_alloc:     MEM_ROOT0320;
    row:             MYSQL_ROW;   // If unbuffered read
    current_row:     MYSQL_ROW;   // buffer to current row
    lengths:         PLongInt;    // column lengths of current row
    handle:          PMYSQL;      // for unbuffered reads
    eof:             my_bool;     // Used my mysql_fetch_row
  end;

{------------------------------------------------------------------------------}
{  The following definitions are added for the enhanced                        }
{  client-server protocol                                                      }
{------------------------------------------------------------------------------}
type
  enum_field_types = Byte;
const
  MYSQL_TYPE_DECIMAL = 0;
  MYSQL_TYPE_TINY = 1;
  MYSQL_TYPE_SHORT = 2;
  MYSQL_TYPE_LONG = 3;
  MYSQL_TYPE_FLOAT = 4;
  MYSQL_TYPE_DOUBLE = 5;
  MYSQL_TYPE_NULL = 6;
  MYSQL_TYPE_TIMESTAMP = 7;
  MYSQL_TYPE_LONGLONG = 8;
  MYSQL_TYPE_INT24 = 9;
  MYSQL_TYPE_DATE = 10;
  MYSQL_TYPE_TIME = 11;
  MYSQL_TYPE_DATETIME = 12;
  MYSQL_TYPE_YEAR = 13;
  MYSQL_TYPE_NEWDATE = 14;
{>= 5.0.6 begin}
  MYSQL_TYPE_NEWDECIMAL=246;
{>= 5.0.6 end}
  MYSQL_TYPE_ENUM=247;
  MYSQL_TYPE_SET=248;
  MYSQL_TYPE_TINY_BLOB=249;
  MYSQL_TYPE_MEDIUM_BLOB=250;
  MYSQL_TYPE_LONG_BLOB=251;
  MYSQL_TYPE_BLOB=252;
  MYSQL_TYPE_VAR_STRING=253;
  MYSQL_TYPE_STRING=254;
  MYSQL_TYPE_GEOMETRY=255;

type
  // statement state
  PREP_STMT_STATE0410 = Byte;
const
  MY_ST_UNKNOWN = 0;
  MY_ST_PREPARE = 1;
  MY_ST_EXECUTE = 2;

type
  PREP_STMT_STATE0411 = Byte;
const
  MYSQL_STMT_INIT_DONE = 1;
  MYSQL_STMT_PREPARE_DONE = 2;
  MYSQL_STMT_EXECUTE_DONE = 3;
  MYSQL_STMT_FETCH_DONE = 4;

type
  // client TIME structure to handle TIME, DATE and TIMESTAMP directly in
  // binary protocol
  mysql_st_timestamp_type = Byte;
const
  OLD_MYSQL_TIMESTAMP_NONE = 0;
  OLD_MYSQL_TIMESTAMP_DATE = 1;
  OLD_MYSQL_TIMESTAMP_FULL = 2;
  OLD_MYSQL_TIMESTAMP_TIME = 3;

{>= 5.0.6 begin}
type
  enum_mysql_timestamp_type = Byte;
const
  MYSQL_TIMESTAMP_NONE = -2;
  MYSQL_TIMESTAMP_ERROR = -1;
  MYSQL_TIMESTAMP_DATE = 0;
  MYSQL_TIMESTAMP_DATETIME = 1;
  MYSQL_TIMESTAMP_TIME = 2;

  // Structure which is used to represent datetime values inside MySQL.

  // We assume that values in this structure are normalized, i.e. year <= 9999,
  // month <= 12, day <= 31, hour <= 23, hour <= 59, hour <= 59. Many functions
  // in server such as my_system_gmt_sec() or make_time() family of functions
  // rely on this (actually now usage of make_*() family relies on a bit weaker
  // restriction). Also functions that produce MYSQL_TIME as result ensure this.
  // There is one exception to this rule though if this structure holds time
  // value (time_type == MYSQL_TIMESTAMP_TIME) days and hour member can hold
  // bigger values.
type
  PMYSQL_TIME0506 = ^MYSQL_TIME0506;
  MYSQL_TIME0506 = packed record
    year, month, day,
    hour, minute, second: LongWord;
    second_part:          LongWord;
    neg:                  my_bool;
    time_type:            enum_mysql_timestamp_type;
  end;
{>= 5.0.6 end}
  PMYSQL_TIME0410 = ^MYSQL_TIME0410;
  MYSQL_TIME0410 = packed record
    year, month, day,
    hour, minute, second: LongWord;
    second_part:          LongWord;
    neg:                  my_bool;
    time_type:            mysql_st_timestamp_type;
  end;

  // bind structure
  TMYSQL_BIND_store_param_func = procedure(net: PNET; param: PMYSQL_BIND); stdcall;
  TMYSQL_BIND_fetch_result = procedure(p1: PMYSQL_BIND; row: PPByte); stdcall;
  TMYSQL_BIND_skip_result = procedure(p1: PMYSQL_BIND; p2: PMYSQL_FIELD; row: PPByte); stdcall;


  PMYSQL_BIND0506 = ^MYSQL_BIND0506;
  MYSQL_BIND0506 = packed record
    length: PLongWord;              // output length pointer
    is_null: Pmy_bool;              // Pointer to null indicators
    buffer: PChar;                  // buffer to get/put data
    // set this if you want to track data truncations happened during fetch
    error: Pmy_bool;
    buffer_type: enum_field_types;  // buffer type
    // Must be set for string/blob data
    buffer_length: LongWord;        // buffer length
    // Following are for internal use. Set by mysql_stmt_bind_param
    row_ptr: PChar;                 // for the current data position
    offset: LongWord;               // offset position for char/binary fetch
    length_value: LongWord;         // Used if length is 0
    param_number: Longword;         // For null count and error messages
    pack_length: LongWord;	        // Internal length for packed data
    error_value: my_bool;           // used if error is 0 */
    is_unsigned: my_bool;           // set if integer type is unsigned
    long_data_used: my_bool;	      // If used with mysql_send_long_data
    is_null_value: my_bool;         // Used if is_null is 0
    store_param_func: TMYSQL_BIND_store_param_func;
    fetch_result: TMYSQL_BIND_fetch_result;
    skip_result: TMYSQL_BIND_skip_result;
  end;
  PMYSQL_BIND0411 = ^MYSQL_BIND0411;
  MYSQL_BIND0411 = packed record
    length: PLongWord;              // output length pointer
    is_null: Pmy_bool;              // Pointer to null indicators
    buffer: PChar;                  // buffer to get/put data
    buffer_type: enum_field_types;  // buffer type
    // Must be set for string/blob data
    buffer_length: LongWord;        // buffer length
    // Following are for internal use. Set by mysql_stmt_bind_param
    inter_buffer: PChar;            // for the current data position
    offset: LongWord;               // offset position for char/binary fetch
    internal_length: LongWord;      // Used if length is 0
    param_number: Longword;         // For null count and error messages
    pack_length: LongWord;	    // Internal length for packed data
    is_unsigned: my_bool;           // set if integer type is unsigned
    long_data_used: my_bool;	    // If used with mysql_send_long_data
    internal_is_null: my_bool;      // Used if is_null is 0
    store_param_func: TMYSQL_BIND_store_param_func;
    fetch_result: TMYSQL_BIND_fetch_result;
    skip_result: TMYSQL_BIND_skip_result;
  end;
  PMYSQL_BIND0410 = ^MYSQL_BIND0410;
  MYSQL_BIND0410 = packed record
    length: PLongWord;              // output length pointer
    is_null: Pmy_bool;              // Pointer to null indicators
    buffer: PChar;                  // buffer to get/put data
    buffer_type: enum_field_types;  // buffer type
    // Must be set for string/blob data
    buffer_length: LongWord;        // buffer length
    // The following are for internal use. Set by mysql_bind_param
    param_number: LongWord;         // For null count and error messages
    long_data_used: my_bool;        // If used with mysql_send_long_data
//    store_param_func: TMYSQL_BIND_store_param_func;
//    fetch_result: TMYSQL_BIND_fetch_result;
  end;

  // statement handler
  TMYSQL_STMT_read_row_func = function (stmt: PMYSQL_STMT; row: PPChar): Integer;

  PMYSQL_STMT0506 = ^MYSQL_STMT0506;
  MYSQL_STMT0506 = packed record
    mem_root: MEM_ROOT0410;        // root allocations
    list: MYSQL_LIST;              // list to keep track of all stmts
    mysql: PMYSQL;                 // connection handle
    params: PMYSQL_BIND;           // input parameters
    bind: PMYSQL_BIND;             // row binding
    fields: PMYSQL_FIELD;          // prepare meta info
    result: PMYSQL_RES;            // resultset
    data_cursor: PMYSQL_ROWS;      // current row in cached result
    // copy of mysql->affected_rows after statement execution
    affected_rows: my_ulonglong;
    insert_id: my_ulonglong;       // copy of mysql->insert_id
    // mysql_stmt_fetch() calls this function to fetch one row (it's different
    // for buffered, unbuffered and cursor fetch).
    read_row_func: TMYSQL_STMT_read_row_func;
    stmt_id: LongWord;              // Id for prepared statement
    flags: LongWord;                // i.e. type of cursor to open
    prefetch_rows: LongWord;        // number of rows per one COM_FETCH
    server_status: LongWord;
    last_errno: LongWord;          // error code
    param_count: LongWord;         // parameters count
    field_count: LongWord;         // fields count
    state: PREP_STMT_STATE0411;    // statement state
    last_error: array [0 .. MYSQL_ERRMSG_SIZE - 1] of char; // error message
    sqlstate: array [0 .. SQLSTATE_LENGTH] of char;
    // Types of input parameters should be sent to server
    send_types_to_server: my_bool; // Types sent to server
    bind_param_done: my_bool;      // input buffers were supplied
    bind_result_done: my_bool;     // output buffers were supplied
    // mysql_stmt_close() had to cancel this result
    unbuffered_fetch_cancelled: my_bool;
    // Is set to true if we need to calculate field->max_length for
    // metadata fields when doing mysql_stmt_store_result.
    update_max_length: my_bool;
  end;
  PMYSQL_STMT0411 = ^MYSQL_STMT0411;
  MYSQL_STMT0411 = packed record
    mem_root: MEM_ROOT0410;        // root allocations
    list: MYSQL_LIST;              // list to keep track of all stmts
    mysql: PMYSQL;                 // connection handle
    params: PMYSQL_BIND;           // input parameters
    bind: PMYSQL_BIND;             // row binding
    fields: PMYSQL_FIELD;          // prepare meta info
    result: PMYSQL_RES;            // resultset
    data_cursor: PMYSQL_ROWS;      // current row in cached result
    // copy of mysql->affected_rows after statement execution
    affected_rows: my_ulonglong;
    insert_id: my_ulonglong;       // copy of mysql->insert_id
    // mysql_stmt_fetch() calls this function to fetch one row (it's different
    // for buffered, unbuffered and cursor fetch).
    read_row_func: TMYSQL_STMT_read_row_func;
    stmt_id: LongWord;             // Id for prepared statement
    last_errno: LongWord;          // error code
    param_count: LongWord;         // parameters count
    field_count: LongWord;         // fields count
    state: PREP_STMT_STATE0411;    // statement state
    last_error: array [0 .. MYSQL_ERRMSG_SIZE - 1] of char; // error message
    sqlstate: array [0 .. SQLSTATE_LENGTH] of char;
    // Types of input parameters should be sent to server
    send_types_to_server: my_bool; // Types sent to server
    bind_param_done: my_bool;      // input buffers were supplied
    bind_result_done: my_bool;     // output buffers were supplied
    // mysql_stmt_close() had to cancel this result
    unbuffered_fetch_cancelled: my_bool;
    // Is set to true if we need to calculate field->max_length for
    // metadata fields when doing mysql_stmt_store_result.
    update_max_length: my_bool;
  end;
  PMYSQL_STMT0410 = ^MYSQL_STMT0410;
  MYSQL_STMT0410 = packed record
    mysql: PMYSQL;                 // connection handle
    params: PMYSQL_BIND;           // input parameters
    result: PMYSQL_RES;            // resultset
    bind: PMYSQL_BIND;             // row binding
    fields: PMYSQL_FIELD;          // prepare meta info
    list: MYSQL_LIST;              // list to keep track of all stmts
    query: PChar;                  // query buffer
    mem_root: MEM_ROOT0323;        // root allocations
    param_count: LongWord;         // parameters count
    field_count: LongWord;         // fields count
    stmt_id: LongWord;             // Id for prepared statement
    last_errno: LongWord;          // error code
    state: PREP_STMT_STATE0410;    // statement state
    last_error: array [0 .. MYSQL_ERRMSG_SIZE - 1] of char; // error message
    long_alloced: my_bool;         // flag to indicate long alloced
    send_types_to_server: my_bool; // Types sent to server
    param_buffers: my_bool;        // param bound buffers
    res_buffers: my_bool;          // output bound buffers
    result_buffered: my_bool;      // Results buffered
  end;

type
  enum_stmt_attr_type = Byte;
const
  // When doing mysql_stmt_store_result calculate max_length attribute
  // of statement metadata. This is to be consistent with the old API,
  // where this was done automatically.
  // In the new API we do that only by request because it slows down
  // mysql_stmt_store_result sufficiently.
  STMT_ATTR_UPDATE_MAX_LENGTH = 0;
{>= 5.0.6 begin}
  // unsigned long with combination of cursor flags (read only, for update,
  // etc)
  STMT_ATTR_CURSOR_TYPE = 1;
  // Amount of rows to retrieve from server per one fetch if using cursors.
  // Accepts unsigned long attribute in the range 1 - ulong_max
  STMT_ATTR_PREFETCH_ROWS = 2;
{>= 5.0.6 end}

  // new status messages
  MYSQL_SUCCESS = 0;
  MYSQL_STATUS_ERROR = 1;
  MYSQL_NO_DATA = 100;
{>= 5.0.6 begin}
  MYSQL_DATA_TRUNCATED = 101;
{>= 5.0.6 end}
  MYSQL_NEED_DATA = 99;
  
{------------------------------------------------------------------------------}
{ mysql_error.h                                                                }
{ Definefile for error messagenumbers                                          }
{------------------------------------------------------------------------------}
const
  ER_ACCESS_DENIED_ERROR = 1045;
  ER_BAD_TABLE_ERROR = 1051;
  ER_DUP_ENTRY = 1062;
  ER_PARSE_ERROR = 1064;
  ER_NO_SUCH_TABLE = 1146;
  ER_LOCK_WAIT_TIMEOUT = 1205;
  ER_NO_REFERENCED_ROW = 1216;
  ER_ROW_IS_REFERENCED = 1217;
  ER_SP_DOES_NOT_EXIST = 1305;
  ER_SERVER_GONE_ERROR = 2006;
  ER_SERVER_LOST = 2013;
type
  TPrcmysql_num_rows = function(res: PMYSQL_RES): my_ulonglong; stdcall;
  TPrcmysql_num_fields = function(res: PMYSQL_RES): LongWord; stdcall;
  TPrcmysql_eof = function(res: PMYSQL_RES): my_bool; stdcall;
  TPrcmysql_fetch_field_direct = function(res: PMYSQL_RES; fieldnr: Integer): PMYSQL_FIELD; stdcall;
  TPrcmysql_fetch_fields = function(res: PMYSQL_RES): PMYSQL_FIELD; stdcall;
  TPrcmysql_row_tell = function(res: PMYSQL_RES): PMYSQL_ROWS; stdcall;
  TPrcmysql_field_tell = function(res: PMYSQL_RES): LongWord; stdcall;

  TPrcmysql_field_count = function(mysql: PMYSQL): LongWord; stdcall;
  TPrcmysql_affected_rows = function(mysql: PMYSQL): my_ulonglong; stdcall;
  TPrcmysql_insert_id = function(mysql: PMYSQL): my_ulonglong; stdcall;
  TPrcmysql_errno = function(mysql: PMYSQL): LongWord; stdcall;
  TPrcmysql_error = function(mysql: PMYSQL): PChar; stdcall;
  TPrcmysql_info = function(mysql: PMYSQL): PChar; stdcall;
  TPrcmysql_thread_id = function(mysql: PMYSQL): LongWord; stdcall;
  TPrcmysql_character_set_name = function(mysql: PMYSQL): PChar; stdcall;
  TPrcmysql_get_character_set_info = procedure (mysql: PMYSQL; var charset: MY_CHARSET_INFO); stdcall;
  TPrcmysql_set_character_set = function (mysql: PMYSQL; cs_name: PChar): Integer; stdcall;

  TPrcmysql_warning_count = function(mysql: PMYSQL): LongWord; stdcall;

  TPrcmysql_init = function(mysql: PMYSQL): PMYSQL; stdcall;
  TPrcmysql_ssl_set = function(mysql: PMYSQL; const key, cert, ca, capath: PChar): Integer; stdcall;
  TPrcmysql_change_user = function(mysql: PMYSQL; const user, passwd, db: PChar): my_bool; stdcall;
  TPrcmysql_real_connect = function(mysql: PMYSQL; const host, user, passwd, db: PChar;
    port: LongWord; const unix_socket: PChar; clientflag: LongWord): PMYSQL; stdcall;
  TPrcmysql_close = procedure(sock: PMYSQL); stdcall;
  TPrcmysql_select_db = function(mysql: PMYSQL; const db: PChar): Integer; stdcall;
  TPrcmysql_query = function(mysql: PMYSQL; const q: PChar): Integer; stdcall;
  TPrcmysql_send_query = function(mysql: PMYSQL; const q: PChar; length: LongWord): Integer; stdcall;
  TPrcmysql_read_query_result = function(mysql: PMYSQL): Integer; stdcall;
  TPrcmysql_real_query = function(mysql: PMYSQL; const q: PChar; length: LongWord): Integer; stdcall;

  TPrcmysql_shutdown = function(mysql: PMYSQL): Integer; stdcall;
  TPrcmysql_dump_debug_info = function(mysql: PMYSQL): Integer; stdcall;
  TPrcmysql_refresh = function(mysql: PMYSQL; refresh_options: LongWord): Integer; stdcall;
  TPrcmysql_kill = function(mysql: PMYSQL; pid: Integer): Integer; stdcall;
  TPrcmysql_ping = function(mysql: PMYSQL): Integer; stdcall;
  TPrcmysql_stat = function(mysql: PMYSQL): PChar; stdcall;
  TPrcmysql_get_server_info = function(mysql: PMYSQL): PChar; stdcall;
  TPrcmysql_get_client_info = function: PChar; stdcall;
  TPrcmysql_get_host_info = function(mysql: PMYSQL): PChar; stdcall;
  TPrcmysql_get_proto_info = function(mysql: PMYSQL): Integer; stdcall;
  TPrcmysql_list_dbs = function(mysql: PMYSQL; const wild: PChar): PMYSQL_RES; stdcall;
  TPrcmysql_list_tables = function(mysql: PMYSQL; const wild: PChar): PMYSQL_RES; stdcall;
  TPrcmysql_list_fields = function(mysql: PMYSQL; const table, wild: PChar): PMYSQL_RES; stdcall;
  TPrcmysql_list_processes = function(mysql: PMYSQL): PMYSQL_RES; stdcall;
  TPrcmysql_store_result = function(mysql: PMYSQL): PMYSQL_RES; stdcall;
  TPrcmysql_use_result = function(mysql: PMYSQL): PMYSQL_RES; stdcall;
  TPrcmysql_options = function(mysql: PMYSQL; option: mysql_option; const arg: PChar): Integer; stdcall;
  TPrcmysql_free_result = procedure(res: PMYSQL_RES); stdcall;
  TPrcmysql_data_seek0320 = procedure(res: PMYSQL_RES; offset: LongWord); stdcall;
  TPrcmysql_data_seek0323 = procedure(res: PMYSQL_RES; offset: my_ulonglong); stdcall;
  TPrcmysql_row_seek = function(res: PMYSQL_RES; Row: MYSQL_ROW_OFFSET): MYSQL_ROW_OFFSET; stdcall;
  TPrcmysql_field_seek = function(res: PMYSQL_RES; offset: MYSQL_FIELD_OFFSET): MYSQL_FIELD_OFFSET; stdcall;
  TPrcmysql_fetch_row = function(res: PMYSQL_RES): PMYSQL_ROW; stdcall;
  TPrcmysql_fetch_lengths = function(res: PMYSQL_RES): PLongInt; stdcall;
  TPrcmysql_fetch_field = function(res: PMYSQL_RES): PMYSQL_FIELD; stdcall;
  TPrcmysql_escape_string = function(szTo: PChar; const szFrom: PChar; from_length: LongWord): LongWord; stdcall;
  TPrcmysql_real_escape_string = function(mysql: PMYSQL; szTo: PChar; const szFrom: PChar;
    length: LongWord): LongWord; stdcall;
  TPrcmysql_debug = procedure(const debug: PChar); stdcall;
  TPrcmyodbc_remove_escape = procedure(mysql: PMYSQL; name: PChar); stdcall;
  TPrcmysql_thread_safe = function: Integer; stdcall;

  // USE_OLD_FUNCTIONS
  TPrcmysql_connect = function(mysql: PMYSQL; const host, user, passwd: PChar): PMYSQL; stdcall;
  TPrcmysql_create_db = function(mysql: PMYSQL; const DB: PChar): Integer; stdcall;
  TPrcmysql_drop_db = function(mysql: PMYSQL; const DB: PChar): Integer; stdcall;

  // 4.1
  TPrcmysql_autocommit = function(mysql: PMYSQL; mode: my_bool): my_bool; stdcall;
  TPrcmysql_commit = function(mysql: PMYSQL): my_bool; stdcall;
  TPrcmysql_rollback = function(mysql: PMYSQL): my_bool; stdcall;

  TPrcmysql_more_results = function(mysql: PMYSQL): my_bool; stdcall;
  TPrcmysql_next_result = function(mysql: PMYSQL): my_bool; stdcall;

  // 5.0
  TPrcmysql_stmt_init = function(mysql: PMYSQL): PMYSQL_STMT; stdcall;
  TPrcmysql_stmt_prepare = function(mysql: PMYSQL; const query: PChar;
    length: LongWord): PMYSQL_STMT; stdcall;
  TPrcmysql_stmt_execute = function (stmt: PMYSQL_STMT): Integer; stdcall;
  TPrcmysql_stmt_fetch = function(stmt: PMYSQL_STMT): Integer; stdcall;
  TPrcmysql_stmt_fetch_column = function(stmt: PMYSQL_STMT; bind: PMYSQL_BIND;
    column: LongWord; offset: LongWord): Integer; stdcall;
  TPrcmysql_stmt_store_result = function(stmt: PMYSQL_STMT): Integer; stdcall;
  TPrcmysql_stmt_param_count = function(stmt: PMYSQL_STMT): LongWord; stdcall;
  TPrcmysql_stmt_attr_set = function(stmt: PMYSQL_STMT; attr_type: enum_stmt_attr_type;
    attr: Pointer): my_bool; stdcall;
  TPrcmysql_stmt_attr_get = function(stmt: PMYSQL_STMT; attr_type: enum_stmt_attr_type;
    attr: Pointer): my_bool; stdcall;
  TPrcmysql_stmt_bind_param = function(stmt: PMYSQL_STMT; bnd: PMYSQL_BIND): my_bool; stdcall;
  TPrcmysql_stmt_bind_result = function(stmt: PMYSQL_STMT; bnd: PMYSQL_BIND): my_bool; stdcall;
  TPrcmysql_stmt_close = function(stmt: PMYSQL_STMT): my_bool; stdcall;
  TPrcmysql_stmt_reset = function(stmt: PMYSQL_STMT): my_bool; stdcall;
  TPrcmysql_stmt_free_result = function(stmt: PMYSQL_STMT): my_bool; stdcall;
  TPrcmysql_stmt_send_long_data = function(stmt: PMYSQL_STMT; param_number: LongWord;
    const data: PChar; length: LongWord): my_bool; stdcall;
  TPrcmysql_stmt_result_metadata = function(stmt: PMYSQL_STMT): PMYSQL_RES; stdcall;
  TPrcmysql_stmt_errno = function(stmt: PMYSQL_STMT): LongWord; stdcall;
  TPrcmysql_stmt_error = function(stmt: PMYSQL_STMT): PChar; stdcall;
  TPrcmysql_stmt_sqlstate = function(stmt: PMYSQL_STMT): PChar; stdcall;
  TPrcmysql_stmt_row_seek = function(stmt: PMYSQL_STMT; offset: MYSQL_ROW_OFFSET):
    MYSQL_ROW_OFFSET; stdcall;
  TPrcmysql_stmt_row_tell = function(stmt: PMYSQL_STMT): MYSQL_ROW_OFFSET; stdcall;
  TPrcmysql_stmt_data_seek = procedure (stmt: PMYSQL_STMT; offset: my_ulonglong); stdcall;
  TPrcmysql_stmt_num_rows = function (stmt: PMYSQL_STMT): my_ulonglong; stdcall;
  TPrcmysql_stmt_affected_rows = function (stmt: PMYSQL_STMT): my_ulonglong; stdcall;
  TPrcmysql_stmt_insert_id = function (stmt: PMYSQL_STMT): my_ulonglong; stdcall;
  TPrcmysql_stmt_field_count = function (stmt: PMYSQL_STMT): LongWord; stdcall;

  // Set up and bring down the server; to ensure that applications will
  // work when linked against either the standard client library or the
  // embedded server library, these functions should be called.
  TPrcmysql_server_init = function (argc: Integer; argv: PPChar; groups: PPChar): Integer; stdcall;
  TPrcmysql_server_end = procedure (); stdcall;

  // Set up and bring down a thread; these function should be called
  // for each thread in an application which opens at least one MySQL
  // connection.  All uses of the connection(s) should be between these
  // function calls.
  TPrcmysql_thread_init = function (): my_bool; stdcall;
  TPrcmysql_thread_end = procedure (); stdcall;

implementation

end.
