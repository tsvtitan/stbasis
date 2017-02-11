/*
 *	MODULE:		ibase.h
 *	DESCRIPTION:	OSRI entrypoints and defines
 *
 * The contents of this file are subject to the Interbase Public
 * License Version 1.0 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy
 * of the License at http://www.Inprise.com/IPL.html
 *
 * Software distributed under the License is distributed on an
 * "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code was created by Inprise Corporation
 * and its predecessors. Portions created by Inprise Corporation are
 * Copyright (C) Inprise Corporation.
 *
 * All Rights Reserved.
 * Contributor(s): ______________________________________.
 * Added TCP_NO_DELAY option for superserver on Linux
 * FSG 16.03.2001 
 * 2001.07.28: John Bellardo:  Added blr_skip
 * 2001.09.18: Ann Harrison:   New info codes
 * 17-Oct-2001 Mike Nordell: CPU affinity
 * 2001-04-16 Paul Beach: ISC_TIME_SECONDS_PRECISION_SCALE modified for HP10
 * Compiler Compatibility
 */
/*
$Id: ibase.h,v 1.20 2002/06/17 10:19:06 paul_reeves Exp $
 */

#ifndef _JRD_IBASE_H_
#define _JRD_IBASE_H_

#ifndef HARBOR_MERGE
#define HARBOR_MERGE
#endif

#define isc_version4

#define  ISC_TRUE	1
#define  ISC_FALSE	0
#if !(defined __cplusplus)
#define  ISC__TRUE	ISC_TRUE
#define  ISC__FALSE	ISC_FALSE
#endif

#if (defined __osf__ && defined __alpha)
#define  ISC_LONG	int
#define  ISC_ULONG	unsigned int
#else
#define  ISC_LONG	long
#define  ISC_ULONG	unsigned long
#endif

#define  ISC_USHORT	unsigned short
#define  ISC_STATUS	long

#define  DSQL_close     1
#define  DSQL_drop      2


/******************************************************************/
/* Define type, export and other stuff based on c/c++ and Windows */
/******************************************************************/

#if (defined(_MSC_VER) && defined(_WIN32)) || \
    (defined(__BORLANDC__) && (defined(__WIN32__) || defined(__OS2__)))
#define  ISC_FAR
#define  ISC_EXPORT	__stdcall
#define  ISC_EXPORT_VARARG	__cdecl
typedef           __int64  ISC_INT64;
typedef  unsigned __int64  ISC_UINT64;
#define  ISC_INT64_DEFINED
#else					/* Not Windows/NT */
#if (defined(__IBMC__) && defined(__OS2__))
#define  ISC_FAR
#define  ISC_EXPORT	_System
#define  ISC_EXPORT_VARARG	ISC_EXPORT
#else					/* not IBM C Set++ for OS/2 */
#if ( defined( _Windows) || defined( _WINDOWS))
#define  ISC_FAR	__far
#define  ISC_EXPORT     ISC_FAR __cdecl __loadds __export
#define  ISC_EXPORT_VARARG	ISC_EXPORT
#else					/* Not Windows/NT, OS/2 or Windows */
#define  ISC_FAR
#define  ISC_EXPORT
#define  ISC_EXPORT_VARARG
#endif					/* Windows and Not Windows/NT or OS/2 */
#endif					/* IBM C Set++ for OS/2 */
#endif   				/* Windows/NT */

/*******************************************************************/
/* 64 bit Integers                                                 */
/*******************************************************************/

#ifndef  ISC_INT64_DEFINED              
typedef           long long int  ISC_INT64;	
typedef  unsigned long long int  ISC_UINT64;	
#else
#undef  ISC_INT64_DEFINED
#endif

/*******************************************************************/
/* Time & Date Support                                             */
/*******************************************************************/

#ifndef _ISC_TIMESTAMP_
typedef long		ISC_DATE;
typedef unsigned long	ISC_TIME;
typedef struct {
    ISC_DATE 	timestamp_date;
    ISC_TIME	timestamp_time;
} ISC_TIMESTAMP;
#define _ISC_TIMESTAMP_			1
#endif

#define ISC_TIME_SECONDS_PRECISION          10000L
#define ISC_TIME_SECONDS_PRECISION_SCALE    (-4)

/*******************************************************************/
/* Blob id structure                                               */
/*******************************************************************/

typedef struct {
    ISC_LONG		gds_quad_high;
    unsigned ISC_LONG	gds_quad_low;
} GDS_QUAD;
#if !(defined __cplusplus)
typedef GDS_QUAD	GDS__QUAD;
#endif					/* !(defined __cplusplus) */

#define	ISC_QUAD	GDS_QUAD
#define	isc_quad_high	gds_quad_high
#define	isc_quad_low	gds_quad_low

typedef struct {
    short       	array_bound_lower;
    short       	array_bound_upper;
} ISC_ARRAY_BOUND;

typedef struct {
    unsigned char       array_desc_dtype;
    char                array_desc_scale;
    unsigned short      array_desc_length;
    char                array_desc_field_name [32];
    char                array_desc_relation_name [32];
    short               array_desc_dimensions;
    short               array_desc_flags;
    ISC_ARRAY_BOUND     array_desc_bounds [16];
} ISC_ARRAY_DESC;

typedef struct {
    short               blob_desc_subtype;
    short               blob_desc_charset;
    short               blob_desc_segment_size;
    unsigned char       blob_desc_field_name [32];
    unsigned char       blob_desc_relation_name [32];
} ISC_BLOB_DESC;


/***************************/
/* Blob control structure  */
/***************************/

typedef struct isc_blob_ctl{
    ISC_STATUS      (ISC_FAR *ctl_source)();	/* Source filter */
    struct isc_blob_ctl ISC_FAR *ctl_source_handle; /* Argument to pass to source */
						/* filter */
    short		  ctl_to_sub_type;  	/* Target type */
    short		  ctl_from_sub_type;	/* Source type */
    unsigned short  	  ctl_buffer_length;	/* Length of buffer */
    unsigned short  	  ctl_segment_length;  	/* Length of current segment */
    unsigned short  	  ctl_bpb_length;	/* Length of blob parameter */
					    	/* block */
    char	  ISC_FAR *ctl_bpb;		/* Address of blob parameter */ 
						/* block */
    unsigned char ISC_FAR *ctl_buffer;		/* Address of segment buffer */
    ISC_LONG     	  ctl_max_segment;	/* Length of longest segment */
    ISC_LONG	 	  ctl_number_segments; 	/* Total number of segments */
    ISC_LONG  		  ctl_total_length;  	/* Total length of blob */
    ISC_STATUS	  ISC_FAR *ctl_status;		/* Address of status vector */
    long		  ctl_data [8];	  	/* Application specific data */
} ISC_FAR *ISC_BLOB_CTL;

/***************************/
/* Blob stream definitions */ 
/***************************/

typedef struct bstream {
    void	ISC_FAR *bstr_blob;  	/* Blob handle */
    char	ISC_FAR *bstr_buffer;	/* Address of buffer */
    char	ISC_FAR *bstr_ptr;	/* Next character */
    short	  bstr_length;		/* Length of buffer */
    short	  bstr_cnt;		/* Characters in buffer */
    char      	  bstr_mode;  		/* (mode) ? OUTPUT : INPUT */
} BSTREAM;

#define getb(p)	(--(p)->bstr_cnt >= 0 ? *(p)->bstr_ptr++ & 0377: BLOB_get (p))
#define putb(x,p) (((x) == '\n' || (!(--(p)->bstr_cnt))) ? BLOB_put ((x),p) : ((int) (*(p)->bstr_ptr++ = (unsigned) (x))))
#define putbx(x,p) ((!(--(p)->bstr_cnt)) ? BLOB_put ((x),p) : ((int) (*(p)->bstr_ptr++ = (unsigned) (x))))


/********************************************************************/
/* CVC: Public blob interface definition held in val.h.             */
/* For some unknown reason, it was only documented in langRef       */
/* and being the structure passed by the engine to UDFs it never    */
/* made its way into this public definitions file.                  */
/* Being its original name "blob", I renamed it blobcallback here.  */
/* I did the full definition with the proper parameters instead of  */
/* the weak C declaration with any number and type of parameters.   */
/* Since the first parameter -BLB- is unknown outside the engine,   */
/* it's more accurate to use void* than int* as the blob pointer    */
/********************************************************************/

#if !defined(_JRD_VAL_H_) && !defined(REQUESTER)
/* Blob passing structure */

enum lseek_mode {blb_seek_relative = 1, blb_seek_from_tail = 2};

typedef struct blobcallback {
    short (ISC_FAR *blob_get_segment)
		(void ISC_FAR* hnd, unsigned char* buffer, ISC_USHORT buf_size, ISC_USHORT* result_len);
    void		ISC_FAR	*blob_handle;
    ISC_LONG	blob_number_segments;
    ISC_LONG	blob_max_segment;
    ISC_LONG	blob_total_length;
    void (ISC_FAR *blob_put_segment)
		(void ISC_FAR* hnd, unsigned char* buffer, ISC_USHORT buf_size);
    ISC_LONG (ISC_FAR *blob_lseek)
		(void ISC_FAR* hnd, ISC_USHORT mode, ISC_LONG offset);
} ISC_FAR *BLOBCALLBACK;
#endif /* !defined(_JRD_VAL_H_) && !defined(REQUESTER) */


/********************************************************************/
/* CVC: Public descriptor interface held in dsc.h.                  */
/* We need it documented to be able to recognize NULL in UDFs.      */
/* Being its original name "dsc", I renamed it paramdsc here.       */
/* Notice that I adjust to the original definition: contrary to     */
/* other cases, the typedef is the same struct not the pointer.     */
/* I included the enumeration of dsc_dtype possible values.         */
/* Ultimately, dsc.h should be part of the public interface.        */
/********************************************************************/

#if !defined(_JRD_DSC_H_)
/* This is the famous internal descriptor that UDFs can use, too. */
typedef struct paramdsc {
    unsigned char	dsc_dtype;
    signed char		dsc_scale;
    ISC_USHORT		dsc_length;
    short		dsc_sub_type;
    ISC_USHORT		dsc_flags;
    unsigned char	*dsc_address;
} PARAMDSC;

#if !defined(_JRD_VAL_H_)
/* This is a helper struct to work with varchars. */
typedef struct paramvary {
    ISC_USHORT		vary_length;
    unsigned char	vary_string [1];
} PARAMVARY;
#endif /* !defined(_JRD_VAL_H_) */

/* values for dsc_flags */
/* Note: DSC_null is only reliably set for local variables
   (blr_variable) */
#define DSC_null		1
#define DSC_no_subtype		2	/* dsc has no sub type specified */
#define DSC_nullable  		4	/* not stored. instead, is derived
                                	from metadata primarily to flag
                                 	SQLDA (in DSQL)               */

/* Overload text typing information into the dsc_sub_type field.
   See intl.h for definitions of text types */ 

#ifndef dsc_ttype
#define dsc_ttype	dsc_sub_type
#endif


/* Note that dtype_null actually means that we do not yet know the
   dtype for this descriptor.  A nice cleanup item would be to globally
   change it to dtype_unknown.  --chrisj 1999-02-17 */

#define dtype_null	0
#define dtype_text	1
#define dtype_cstring	2
#define dtype_varying	3

#define dtype_packed	6
#define dtype_byte	7
#define dtype_short	8
#define dtype_long	9
#define dtype_quad	10
#define dtype_real	11
#define dtype_double	12
#define dtype_d_float	13
#define dtype_sql_date	14
#define dtype_sql_time	15
#define dtype_timestamp	16
#define dtype_blob	17
#define dtype_array	18
#define dtype_int64     19
#define DTYPE_TYPE_MAX	20
#endif /* !defined(_JRD_DSC_H_) */


/***************************/
/* Dynamic SQL definitions */
/***************************/
 
/******************************/
/* Declare the extended SQLDA */
/******************************/

typedef struct {
    short	sqltype;		/* datatype of field */
    short	sqlscale;		/* scale factor */
    short	sqlsubtype;		/* datatype subtype - BLOBs & Text */
					/* types only */
    short	sqllen;			/* length of data area */
    char  ISC_FAR *sqldata;		/* address of data */
    short ISC_FAR *sqlind;		/* address of indicator variable */
    short  	sqlname_length;		/* length of sqlname field */
    char	sqlname [32];		/* name of field, name length + space */
					/* for NULL */
    short	relname_length;		/* length of relation name */
    char	relname [32];		/* field's relation name + space for */
					/* NULL */
    short	ownname_length;		/* length of owner name */
    char	ownname [32];		/* relation's owner name + space for */
					/* NULL */
    short	aliasname_length; 	/* length of alias name */
    char	aliasname [32];		/* relation's alias name + space for */
					/* NULL */
} XSQLVAR;

typedef struct {
    short	version;		/* version of this XSQLDA */
    char	sqldaid [8];		/* XSQLDA name field */
    ISC_LONG	sqldabc;		/* length in bytes of SQLDA */
    short	sqln;			/* number of fields allocated */
    short	sqld;			/* actual number of fields */
    XSQLVAR	sqlvar [1];		/* first field address */
} XSQLDA;

#define XSQLDA_LENGTH(n)	(sizeof (XSQLDA) + ((n)-1) * sizeof (XSQLVAR))

#define SQLDA_VERSION1			1

#define SQL_DIALECT_V5			1/* meaning is same as DIALECT_xsqlda */
#define SQL_DIALECT_V6_TRANSITION	2/* flagging anything that is delimited
                                            by double quotes as an error and
                                            flagging keyword DATE as an error */
#define SQL_DIALECT_V6			3/* supports SQL delimited identifier,
                                            SQLDATE/DATE, TIME, TIMESTAMP,
                                            CURRENT_DATE, CURRENT_TIME,
                                            CURRENT_TIMESTAMP, and 64-bit exact
                                            numeric type */
#define SQL_DIALECT_CURRENT		SQL_DIALECT_V6/* latest IB DIALECT */

/********************************/
/* InterBase Handle Definitions */
/********************************/

typedef void     ISC_FAR *isc_att_handle;

typedef void     ISC_FAR *isc_blob_handle;
typedef void     ISC_FAR *isc_db_handle;
typedef void     ISC_FAR *isc_form_handle;
typedef void     ISC_FAR *isc_req_handle;
typedef void     ISC_FAR *isc_stmt_handle;
typedef void     ISC_FAR *isc_svc_handle;
typedef void     ISC_FAR *isc_tr_handle;
typedef void     ISC_FAR *isc_win_handle;
typedef void    (ISC_FAR *isc_callback)();
typedef ISC_LONG	 isc_resv_handle;

/***************************/
/* OSRI database functions */
/***************************/

#if defined(__cplusplus) || defined(__STDC__) || defined(_Windows) || \
    (defined(_MSC_VER) && defined(WIN32)) || defined( _WINDOWS) || \
    (defined(__BORLANDC__) && (defined(__WIN32__) || defined(__OS2__))) || \
    (defined(__IBMC__) && defined(__OS2__)) || defined(AIX_PPC)

#ifdef __cplusplus
extern "C" {
#endif

ISC_STATUS  ISC_EXPORT isc_attach_database (ISC_STATUS ISC_FAR *, 
					    short, 
					    char ISC_FAR *, 
					    isc_db_handle ISC_FAR *, 
					    short, 
					    char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_array_gen_sdl (ISC_STATUS ISC_FAR *, 
					  ISC_ARRAY_DESC ISC_FAR *,
					  short ISC_FAR *, 
					  char ISC_FAR *, 
					  short ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_array_get_slice (ISC_STATUS ISC_FAR *, 
					    isc_db_handle ISC_FAR *, 
					    isc_tr_handle ISC_FAR *, 
					    ISC_QUAD ISC_FAR *, 
					    ISC_ARRAY_DESC ISC_FAR *, 
					    void ISC_FAR *, 
					    ISC_LONG ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_array_lookup_bounds (ISC_STATUS ISC_FAR *, 
						isc_db_handle ISC_FAR *, 
						isc_tr_handle ISC_FAR *, 
						char ISC_FAR *,
						char ISC_FAR *, 
						ISC_ARRAY_DESC ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_array_lookup_desc (ISC_STATUS ISC_FAR *, 
					      isc_db_handle ISC_FAR *,
					      isc_tr_handle ISC_FAR *, 
					      char ISC_FAR *, 
					      char ISC_FAR *, 
					      ISC_ARRAY_DESC ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_array_set_desc (ISC_STATUS ISC_FAR *, 
					   char ISC_FAR *, 
					   char ISC_FAR *,
					   short ISC_FAR *, 
					   short ISC_FAR *, 
					   short ISC_FAR *, 
					   ISC_ARRAY_DESC ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_array_put_slice (ISC_STATUS ISC_FAR *, 
					    isc_db_handle ISC_FAR *, 
					    isc_tr_handle ISC_FAR *, 
					    ISC_QUAD ISC_FAR *, 
					    ISC_ARRAY_DESC ISC_FAR *, 
					    void ISC_FAR *, 
					    ISC_LONG ISC_FAR *);

void       ISC_EXPORT isc_blob_default_desc (ISC_BLOB_DESC ISC_FAR *,
                                        unsigned char ISC_FAR *,
                                        unsigned char ISC_FAR *);

ISC_STATUS ISC_EXPORT isc_blob_gen_bpb (ISC_STATUS ISC_FAR *,
					ISC_BLOB_DESC ISC_FAR *,
					ISC_BLOB_DESC ISC_FAR *,
					unsigned short,
					unsigned char ISC_FAR *,
					unsigned short ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_blob_info (ISC_STATUS ISC_FAR *, 
				      isc_blob_handle ISC_FAR *, 
				      short,
 				      char ISC_FAR *, 
				      short, 
				      char ISC_FAR *);

ISC_STATUS ISC_EXPORT isc_blob_lookup_desc (ISC_STATUS ISC_FAR *,
					    isc_db_handle ISC_FAR *,
					    isc_tr_handle ISC_FAR *,
					    unsigned char ISC_FAR *,
					    unsigned char ISC_FAR *,
					    ISC_BLOB_DESC ISC_FAR *,
					    unsigned char ISC_FAR *);

ISC_STATUS ISC_EXPORT isc_blob_set_desc (ISC_STATUS ISC_FAR *,
					 unsigned char ISC_FAR *,
					 unsigned char ISC_FAR *,
					 short,
					 short,
					 short,
					 ISC_BLOB_DESC ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_cancel_blob (ISC_STATUS ISC_FAR *, 
				        isc_blob_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_cancel_events (ISC_STATUS ISC_FAR *, 
					  isc_db_handle ISC_FAR *, 
					  ISC_LONG ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_close_blob (ISC_STATUS ISC_FAR *, 
				       isc_blob_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_commit_retaining (ISC_STATUS ISC_FAR *, 
					     isc_tr_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_commit_transaction (ISC_STATUS ISC_FAR *, 
					       isc_tr_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_create_blob (ISC_STATUS ISC_FAR *, 
					isc_db_handle ISC_FAR *, 
					isc_tr_handle ISC_FAR *, 
					isc_blob_handle ISC_FAR *, 
					ISC_QUAD ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_create_blob2 (ISC_STATUS ISC_FAR *, 
					 isc_db_handle ISC_FAR *, 
					 isc_tr_handle ISC_FAR *, 
					 isc_blob_handle ISC_FAR *, 
					 ISC_QUAD ISC_FAR *, 
					 short,  
					 char ISC_FAR *); 

ISC_STATUS  ISC_EXPORT isc_create_database (ISC_STATUS ISC_FAR *, 
					    short, 
					    char ISC_FAR *, 
					    isc_db_handle ISC_FAR *, 
					    short, 
					    char ISC_FAR *, 
					    short);

ISC_STATUS  ISC_EXPORT isc_database_info (ISC_STATUS ISC_FAR *, 
					  isc_db_handle ISC_FAR *, 
					  short, 
					  char ISC_FAR *, 
					  short, 
					  char ISC_FAR *);

void        ISC_EXPORT isc_decode_date (ISC_QUAD ISC_FAR *, 
					void ISC_FAR *);

void        ISC_EXPORT isc_decode_sql_date (ISC_DATE ISC_FAR *, 
					void ISC_FAR *);

void        ISC_EXPORT isc_decode_sql_time (ISC_TIME ISC_FAR *, 
					void ISC_FAR *);

void        ISC_EXPORT isc_decode_timestamp (ISC_TIMESTAMP ISC_FAR *, 
					void ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_detach_database (ISC_STATUS ISC_FAR *,  
					    isc_db_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_drop_database (ISC_STATUS ISC_FAR *,  
					  isc_db_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_allocate_statement (ISC_STATUS ISC_FAR *, 
						    isc_db_handle ISC_FAR *, 
						    isc_stmt_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_alloc_statement2 (ISC_STATUS ISC_FAR *, 
						  isc_db_handle ISC_FAR *, 
						  isc_stmt_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_describe (ISC_STATUS ISC_FAR *, 
					  isc_stmt_handle ISC_FAR *, 
					  unsigned short, 
					  XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_describe_bind (ISC_STATUS ISC_FAR *, 
					       isc_stmt_handle ISC_FAR *, 
					       unsigned short, 
					       XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_exec_immed2 (ISC_STATUS ISC_FAR *, 
					     isc_db_handle ISC_FAR *, 
					     isc_tr_handle ISC_FAR *, 
					     unsigned short, 
					     char ISC_FAR *, 
					     unsigned short, 
					     XSQLDA ISC_FAR *, 
					     XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_execute (ISC_STATUS ISC_FAR *, 
					 isc_tr_handle ISC_FAR *,
					 isc_stmt_handle ISC_FAR *, 
					 unsigned short, 
					 XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_execute2 (ISC_STATUS ISC_FAR *, 
					  isc_tr_handle ISC_FAR *,
					  isc_stmt_handle ISC_FAR *, 
					  unsigned short, 
					  XSQLDA ISC_FAR *,
					  XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_execute_immediate (ISC_STATUS ISC_FAR *, 
						   isc_db_handle ISC_FAR *, 
						   isc_tr_handle ISC_FAR *, 
						   unsigned short, 
						   char ISC_FAR *, 
						   unsigned short, 
						   XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_fetch (ISC_STATUS ISC_FAR *, 
				       isc_stmt_handle ISC_FAR *, 
				       unsigned short, 
				       XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_finish (isc_db_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_free_statement (ISC_STATUS ISC_FAR *, 
						isc_stmt_handle ISC_FAR *, 
						unsigned short);

ISC_STATUS  ISC_EXPORT isc_dsql_insert (ISC_STATUS ISC_FAR *, 
				       isc_stmt_handle ISC_FAR *, 
				       unsigned short, 
				       XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_prepare (ISC_STATUS ISC_FAR *, 
					 isc_tr_handle ISC_FAR *, 
					 isc_stmt_handle ISC_FAR *, 
					 unsigned short, 
					 char ISC_FAR *, 
					 unsigned short, 
				 	 XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_set_cursor_name (ISC_STATUS ISC_FAR *, 
						 isc_stmt_handle ISC_FAR *, 
						 char ISC_FAR *, 
						 unsigned short);

ISC_STATUS  ISC_EXPORT isc_dsql_sql_info (ISC_STATUS ISC_FAR *, 
					  isc_stmt_handle ISC_FAR *, 
					  short, 
					  char ISC_FAR *, 
					  short, 
					  char ISC_FAR *);

void        ISC_EXPORT isc_encode_date (void ISC_FAR *, 
					ISC_QUAD ISC_FAR *);

void        ISC_EXPORT isc_encode_sql_date (void ISC_FAR *, 
					ISC_DATE ISC_FAR *);

void        ISC_EXPORT isc_encode_sql_time (void ISC_FAR *, 
					ISC_TIME ISC_FAR *);

void        ISC_EXPORT isc_encode_timestamp (void ISC_FAR *, 
					ISC_TIMESTAMP ISC_FAR *);

ISC_LONG    ISC_EXPORT_VARARG isc_event_block (char ISC_FAR * ISC_FAR *, 
					       char ISC_FAR * ISC_FAR *, 
					       unsigned short, ...);

void        ISC_EXPORT isc_event_counts (unsigned ISC_LONG ISC_FAR *, 
					 short, 
					 char ISC_FAR *,
					 char ISC_FAR *);

void        ISC_EXPORT_VARARG isc_expand_dpb (char ISC_FAR * ISC_FAR *, 
					      short ISC_FAR *, 
					      ...);

int        ISC_EXPORT isc_modify_dpb (char ISC_FAR * ISC_FAR *, 
					 short ISC_FAR *, unsigned short,
					 char ISC_FAR *, short );

ISC_LONG    ISC_EXPORT isc_free (char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_get_segment (ISC_STATUS ISC_FAR *, 
				        isc_blob_handle ISC_FAR *, 
				        unsigned short ISC_FAR *, 
				        unsigned short, 
				        char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_get_slice (ISC_STATUS ISC_FAR *, 
				      isc_db_handle ISC_FAR *, 
				      isc_tr_handle ISC_FAR *, 
 				      ISC_QUAD ISC_FAR *, 
 				      short, 
				      char ISC_FAR *, 
				      short, 
				      ISC_LONG ISC_FAR *, 
				      ISC_LONG, 
				      void ISC_FAR *, 
				      ISC_LONG ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_interprete (char ISC_FAR *, 
				       ISC_STATUS ISC_FAR * ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_open_blob (ISC_STATUS ISC_FAR *, 
				      isc_db_handle ISC_FAR *, 
				      isc_tr_handle ISC_FAR *, 
				      isc_blob_handle ISC_FAR *, 
				      ISC_QUAD ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_open_blob2 (ISC_STATUS ISC_FAR *, 
				       isc_db_handle ISC_FAR *, 
				       isc_tr_handle ISC_FAR *,
				       isc_blob_handle ISC_FAR *, 
				       ISC_QUAD ISC_FAR *, 
				       short,  
				       char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_prepare_transaction2 (ISC_STATUS ISC_FAR *, 
						 isc_tr_handle ISC_FAR *, 
						 short, 
						 char ISC_FAR *);

void        ISC_EXPORT isc_print_sqlerror (short, 
					   ISC_STATUS ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_print_status (ISC_STATUS ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_put_segment (ISC_STATUS ISC_FAR *, 
					isc_blob_handle ISC_FAR *, 
					unsigned short, 
					char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_put_slice (ISC_STATUS ISC_FAR *, 
				      isc_db_handle ISC_FAR *, 
				      isc_tr_handle ISC_FAR *, 
				      ISC_QUAD ISC_FAR *, 
				      short, 
				      char ISC_FAR *, 
				      short, 
				      ISC_LONG ISC_FAR *, 
				      ISC_LONG, 
				      void ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_que_events (ISC_STATUS ISC_FAR *, 
				       isc_db_handle ISC_FAR *, 
				       ISC_LONG ISC_FAR *, 
				       short, 
				       char ISC_FAR *, 
				       isc_callback, 
				       void ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_rollback_retaining (ISC_STATUS ISC_FAR *, 
						 isc_tr_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_rollback_transaction (ISC_STATUS ISC_FAR *, 
						 isc_tr_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_start_multiple (ISC_STATUS ISC_FAR *, 
					   isc_tr_handle ISC_FAR *, 
					   short, 
					   void ISC_FAR *);

ISC_STATUS  ISC_EXPORT_VARARG isc_start_transaction (ISC_STATUS ISC_FAR *, 
						     isc_tr_handle ISC_FAR *,
						     short, ...);

ISC_LONG    ISC_EXPORT isc_sqlcode (ISC_STATUS ISC_FAR *);

void        ISC_EXPORT isc_sql_interprete (short, 
					   char ISC_FAR *, 
					   short);

ISC_STATUS  ISC_EXPORT isc_transaction_info (ISC_STATUS ISC_FAR *,  
					     isc_tr_handle ISC_FAR *, 
					     short, 
					     char ISC_FAR *, 
					     short,  
					     char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_transact_request (ISC_STATUS ISC_FAR *,  
					     isc_db_handle ISC_FAR *, 
					     isc_tr_handle ISC_FAR *,
					     unsigned short, 
					     char ISC_FAR *, 
					     unsigned short,  
					     char ISC_FAR *,
					     unsigned short,
					     char ISC_FAR *);

ISC_LONG    ISC_EXPORT isc_vax_integer (char ISC_FAR *, 
					short);

ISC_INT64   ISC_EXPORT isc_portable_integer  (unsigned char ISC_FAR *,
                                              short);

/*************************************/
/* Security Functions and structures */
/*************************************/

#define sec_uid_spec		    0x01
#define sec_gid_spec		    0x02
#define sec_server_spec		    0x04
#define sec_password_spec	    0x08
#define sec_group_name_spec	    0x10
#define sec_first_name_spec	    0x20
#define sec_middle_name_spec        0x40
#define sec_last_name_spec	    0x80
#define sec_dba_user_name_spec      0x100
#define sec_dba_password_spec       0x200

#define sec_protocol_tcpip            1
#define sec_protocol_netbeui          2
#define sec_protocol_spx              3
#define sec_protocol_local            4

typedef struct {
    short  sec_flags;		     /* which fields are specified */
    int    uid;			     /* the user's id */
    int	   gid;			     /* the user's group id */
    int    protocol;		     /* protocol to use for connection */
    char   ISC_FAR *server;          /* server to administer */
    char   ISC_FAR *user_name;       /* the user's name */
    char   ISC_FAR *password;        /* the user's password */
    char   ISC_FAR *group_name;      /* the group name */
    char   ISC_FAR *first_name;	     /* the user's first name */
    char   ISC_FAR *middle_name;     /* the user's middle name */
    char   ISC_FAR *last_name;	     /* the user's last name */
    char   ISC_FAR *dba_user_name;   /* the dba user name */
    char   ISC_FAR *dba_password;    /* the dba password */
} USER_SEC_DATA;

int ISC_EXPORT isc_add_user (ISC_STATUS ISC_FAR *, USER_SEC_DATA *);

int ISC_EXPORT isc_delete_user (ISC_STATUS ISC_FAR *, USER_SEC_DATA *);

int ISC_EXPORT isc_modify_user (ISC_STATUS ISC_FAR *, USER_SEC_DATA *);

/**********************************/
/*  Other OSRI functions          */
/**********************************/
                                          
ISC_STATUS  ISC_EXPORT isc_compile_request (ISC_STATUS ISC_FAR *, 
					    isc_db_handle ISC_FAR *,
		  			    isc_req_handle ISC_FAR *, 
					    short, 
					    char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_compile_request2 (ISC_STATUS ISC_FAR *, 
					     isc_db_handle ISC_FAR *,
					     isc_req_handle ISC_FAR *, 
					     short, 
					     char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_ddl (ISC_STATUS ISC_FAR *,
			        isc_db_handle ISC_FAR *, 
			        isc_tr_handle ISC_FAR *,
			        short, 
			        char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_prepare_transaction (ISC_STATUS ISC_FAR *, 
						isc_tr_handle ISC_FAR *);


ISC_STATUS  ISC_EXPORT isc_receive (ISC_STATUS ISC_FAR *, 
				    isc_req_handle ISC_FAR *, 
				    short, 
			 	    short, 
				    void ISC_FAR *, 
				    short);

ISC_STATUS  ISC_EXPORT isc_reconnect_transaction (ISC_STATUS ISC_FAR *,
						  isc_db_handle ISC_FAR *, 
						  isc_tr_handle ISC_FAR *, 
						  short, 
						  char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_release_request (ISC_STATUS ISC_FAR *, 
					    isc_req_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_request_info (ISC_STATUS ISC_FAR *,  
					 isc_req_handle ISC_FAR *, 
					 short, 
	  				 short, 
					 char ISC_FAR *, 
					 short, 
					 char ISC_FAR *);	 

ISC_STATUS  ISC_EXPORT isc_seek_blob (ISC_STATUS ISC_FAR *, 
				      isc_blob_handle ISC_FAR *, 
				      short, 
				      ISC_LONG, 
				      ISC_LONG ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_send (ISC_STATUS ISC_FAR *, 
				 isc_req_handle ISC_FAR *, 
				 short, 
				 short,
				 void ISC_FAR *, 
				 short);

ISC_STATUS  ISC_EXPORT isc_start_and_send (ISC_STATUS ISC_FAR *, 
					   isc_req_handle ISC_FAR *, 
					   isc_tr_handle ISC_FAR *, 
					   short, 
					   short, 
					   void ISC_FAR *, 
					   short);

ISC_STATUS  ISC_EXPORT isc_start_request (ISC_STATUS ISC_FAR *, 
					  isc_req_handle ISC_FAR *,
					  isc_tr_handle ISC_FAR *,
					  short);

ISC_STATUS  ISC_EXPORT isc_unwind_request (ISC_STATUS ISC_FAR *, 
					   isc_tr_handle ISC_FAR *,
					   short);

ISC_STATUS  ISC_EXPORT isc_wait_for_event (ISC_STATUS ISC_FAR *, 
					   isc_db_handle ISC_FAR *, 
					   short, 
					   char ISC_FAR *, 
					   char ISC_FAR *);

/*****************************/
/* Other Sql functions       */
/*****************************/

ISC_STATUS  ISC_EXPORT isc_close (ISC_STATUS ISC_FAR *, 
				  char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_declare (ISC_STATUS ISC_FAR *, 
				    char ISC_FAR *, 
				    char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_describe (ISC_STATUS ISC_FAR *, 
				    char ISC_FAR *, 
				    XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_describe_bind (ISC_STATUS ISC_FAR *, 
					  char ISC_FAR *, 
					  XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_execute (ISC_STATUS ISC_FAR *, 
				    isc_tr_handle ISC_FAR *, 
				    char ISC_FAR *, 
				    XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_execute_immediate (ISC_STATUS ISC_FAR *, 
					      isc_db_handle ISC_FAR *,
					      isc_tr_handle ISC_FAR *, 
					      short ISC_FAR *, 
					      char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_fetch (ISC_STATUS ISC_FAR *, 
				  char ISC_FAR *, 
				  XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_open (ISC_STATUS ISC_FAR *, 
				 isc_tr_handle ISC_FAR *, 
				 char ISC_FAR *, 
				 XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_prepare (ISC_STATUS ISC_FAR *, 
				    isc_db_handle ISC_FAR *, 
				    isc_tr_handle ISC_FAR *, 
				    char ISC_FAR *, 
				    short ISC_FAR *, 
				    char ISC_FAR *, 
				    XSQLDA ISC_FAR *);

/*************************************/
/* Other Dynamic sql functions       */
/*************************************/

ISC_STATUS  ISC_EXPORT isc_dsql_execute_m (ISC_STATUS ISC_FAR *, 
					   isc_tr_handle ISC_FAR *,
					   isc_stmt_handle ISC_FAR *, 
					   unsigned short, 
					   char ISC_FAR *, 
					   unsigned short, 
					   unsigned short, 
					   char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_execute2_m (ISC_STATUS ISC_FAR *, 
					   isc_tr_handle ISC_FAR *,
					   isc_stmt_handle ISC_FAR *, 
					   unsigned short, 
					   char ISC_FAR *, 
					   unsigned short, 
					   unsigned short, 
					   char ISC_FAR *,
					   unsigned short, 
					   char ISC_FAR *, 
					   unsigned short, 
					   unsigned short, 
					   char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_execute_immediate_m (ISC_STATUS ISC_FAR *, 
						     isc_db_handle ISC_FAR *, 
						     isc_tr_handle ISC_FAR *, 
						     unsigned short, 
						     char ISC_FAR *, 
						     unsigned short, 
						     unsigned short, 
						     char ISC_FAR *,
						     unsigned short,
						     unsigned short,
						     char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_exec_immed3_m (ISC_STATUS ISC_FAR *, 
					       isc_db_handle ISC_FAR *, 
					       isc_tr_handle ISC_FAR *, 
					       unsigned short, 
					       char ISC_FAR *, 
					       unsigned short, 
					       unsigned short, 
					       char ISC_FAR *,
					       unsigned short,
					       unsigned short,
					       char ISC_FAR *,
					       unsigned short, 
					       char ISC_FAR *,
					       unsigned short,
					       unsigned short,
					       char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_fetch_m (ISC_STATUS ISC_FAR *, 
					 isc_stmt_handle ISC_FAR *, 
					 unsigned short, 
					 char ISC_FAR *, 
					 unsigned short, 
					 unsigned short, 
					 char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_insert_m (ISC_STATUS ISC_FAR *, 
					  isc_stmt_handle ISC_FAR *, 
					  unsigned short, 
					  char ISC_FAR *, 
					  unsigned short, 
					  unsigned short, 
					  char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_prepare_m (ISC_STATUS ISC_FAR *, 
					   isc_tr_handle ISC_FAR *,
				 	   isc_stmt_handle ISC_FAR *, 
					   unsigned short,  
					   char ISC_FAR *, 
					   unsigned short,
					   unsigned short, 
				  	   char ISC_FAR *, 
				 	   unsigned short,
					   char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_dsql_release (ISC_STATUS ISC_FAR *, 
					 char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_close (ISC_STATUS ISC_FAR *, 
					     char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_declare (ISC_STATUS ISC_FAR *, 
					      char ISC_FAR *, 
					      char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_describe (ISC_STATUS ISC_FAR *, 
						char ISC_FAR *, 
						unsigned short, 
						XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_describe_bind (ISC_STATUS ISC_FAR *, 
						     char ISC_FAR *, 
						     unsigned short, 
						     XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_execute (ISC_STATUS ISC_FAR *, 
					       isc_tr_handle ISC_FAR *,
					       char ISC_FAR *, 
					       unsigned short, 
					       XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_execute2 (ISC_STATUS ISC_FAR *,
						isc_tr_handle ISC_FAR *,
						char ISC_FAR *,
						unsigned short,
						XSQLDA ISC_FAR *,
						XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_execute_immed (ISC_STATUS ISC_FAR *, 
						     isc_db_handle ISC_FAR *, 
						     isc_tr_handle ISC_FAR *, 
						     unsigned short, 
						     char ISC_FAR *, 	
						     unsigned short, 
						     XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_fetch (ISC_STATUS ISC_FAR *, 
					     char ISC_FAR *, 
					     unsigned short, 
					     XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_open (ISC_STATUS ISC_FAR *, 
					    isc_tr_handle ISC_FAR *, 
					    char ISC_FAR *, 
					    unsigned short, 
					    XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_open2 (ISC_STATUS ISC_FAR *, 
					     isc_tr_handle ISC_FAR *, 
					     char ISC_FAR *, 
					     unsigned short, 
					     XSQLDA ISC_FAR *,
					     XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_insert (ISC_STATUS ISC_FAR *, 
					      char ISC_FAR *, 
					      unsigned short, 
					      XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_prepare (ISC_STATUS ISC_FAR *, 
					       isc_db_handle ISC_FAR *,
					       isc_tr_handle ISC_FAR *, 
					       char ISC_FAR *, 
					       unsigned short, 
					       char ISC_FAR *, 
					       unsigned short, 
					       XSQLDA ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_embed_dsql_release (ISC_STATUS ISC_FAR *, 
					       char ISC_FAR *);

/******************************/
/* Other Blob functions       */
/******************************/

BSTREAM     ISC_FAR * ISC_EXPORT BLOB_open (isc_blob_handle,  
				        char ISC_FAR *,  
				        int);

int  	    ISC_EXPORT BLOB_put (char, 
				 BSTREAM ISC_FAR *);

int  	    ISC_EXPORT BLOB_close (BSTREAM ISC_FAR *);

int  	    ISC_EXPORT BLOB_get (BSTREAM ISC_FAR *);

int         ISC_EXPORT BLOB_display (ISC_QUAD ISC_FAR *, 
				     isc_db_handle, 
				     isc_tr_handle,
				     char ISC_FAR *);

int         ISC_EXPORT BLOB_dump (ISC_QUAD ISC_FAR *, 
				  isc_db_handle, 
				  isc_tr_handle,
				  char ISC_FAR *);

int         ISC_EXPORT BLOB_edit (ISC_QUAD ISC_FAR *, 
				  isc_db_handle, 
				  isc_tr_handle,
				  char ISC_FAR *);

int         ISC_EXPORT BLOB_load (ISC_QUAD ISC_FAR *, 
				  isc_db_handle, 
				  isc_tr_handle,
				  char ISC_FAR *);

int         ISC_EXPORT BLOB_text_dump (ISC_QUAD ISC_FAR *, 
				  isc_db_handle, 
				  isc_tr_handle,
				  char ISC_FAR *);

int         ISC_EXPORT BLOB_text_load (ISC_QUAD ISC_FAR *, 
				  isc_db_handle, 
				  isc_tr_handle,
				  char ISC_FAR *);

BSTREAM     ISC_FAR * ISC_EXPORT Bopen (ISC_QUAD ISC_FAR *, 
			       	    isc_db_handle, 
			       	    isc_tr_handle,  
			       	    char ISC_FAR *);

BSTREAM     ISC_FAR * ISC_EXPORT Bopen2 (ISC_QUAD ISC_FAR *, 
				     isc_db_handle,  
				     isc_tr_handle,  
				     char ISC_FAR *,
				     unsigned short);

/******************************/
/* Other Misc functions       */
/******************************/

ISC_LONG    ISC_EXPORT isc_ftof (char ISC_FAR *, 
				 unsigned short, 
				 char ISC_FAR *, 
				 unsigned short);

ISC_STATUS  ISC_EXPORT isc_print_blr (char ISC_FAR *, 
				      isc_callback, 
				      void ISC_FAR *, 
				      short);

void        ISC_EXPORT isc_set_debug (int);

void        ISC_EXPORT isc_qtoq (ISC_QUAD ISC_FAR *, 
				 ISC_QUAD ISC_FAR *);

void        ISC_EXPORT isc_vtof (char ISC_FAR *, 
				 char ISC_FAR *,
				 unsigned short);

void        ISC_EXPORT isc_vtov (char ISC_FAR *, 
				 char ISC_FAR *, 
				 short);

int         ISC_EXPORT isc_version (isc_db_handle ISC_FAR *, 
				    isc_callback, 
				    void ISC_FAR *);

ISC_LONG    ISC_EXPORT isc_reset_fpe (unsigned short);

/*****************************************/
/* Service manager functions             */
/*****************************************/

#define ADD_SPB_LENGTH(p, length)	{*(p)++ = (length); \
    					 *(p)++ = (length) >> 8;}

#define ADD_SPB_NUMERIC(p, data)	{*(p)++ = (data); \
    					 *(p)++ = (data) >> 8; \
					 *(p)++ = (data) >> 16; \
					 *(p)++ = (data) >> 24;}

ISC_STATUS  ISC_EXPORT isc_service_attach (ISC_STATUS ISC_FAR *, 
					   unsigned short, 
					   char ISC_FAR *,
					   isc_svc_handle ISC_FAR *, 
					   unsigned short, 
					   char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_service_detach (ISC_STATUS ISC_FAR *, 
					   isc_svc_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_service_query (ISC_STATUS ISC_FAR *, 
					  isc_svc_handle ISC_FAR *,
                      		          isc_resv_handle ISC_FAR *,
					  unsigned short, 
					  char ISC_FAR *, 
					  unsigned short, 
					  char ISC_FAR *, 
					  unsigned short, 
					  char ISC_FAR *);

ISC_STATUS ISC_EXPORT isc_service_start (ISC_STATUS ISC_FAR *,
    					 isc_svc_handle ISC_FAR *,
                         		 isc_resv_handle ISC_FAR *,
    					 unsigned short,
    					 char ISC_FAR*);

/*******************************/
/* Forms functions             */
/*******************************/

ISC_STATUS  ISC_EXPORT isc_compile_map (ISC_STATUS ISC_FAR *, 
					isc_form_handle ISC_FAR *,
					isc_req_handle ISC_FAR *, 
					short ISC_FAR *, 
					char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_compile_menu (ISC_STATUS ISC_FAR *, 
					 isc_form_handle ISC_FAR *,
					 isc_req_handle ISC_FAR *, 
					 short ISC_FAR *, 
				 	 char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_compile_sub_map (ISC_STATUS ISC_FAR *, 
					    isc_win_handle ISC_FAR *,
					    isc_req_handle ISC_FAR *, 
					    short ISC_FAR *, 
					    char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_create_window (ISC_STATUS ISC_FAR *, 
					  isc_win_handle ISC_FAR *, 
					  short ISC_FAR *, 
					  char ISC_FAR *, 
					  short ISC_FAR *, 
					  short ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_delete_window (ISC_STATUS ISC_FAR *, 
					  isc_win_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_drive_form (ISC_STATUS ISC_FAR *, 
				       isc_db_handle ISC_FAR *, 
				       isc_tr_handle ISC_FAR *, 
				       isc_win_handle ISC_FAR *, 
				       isc_req_handle ISC_FAR *, 
				       unsigned char ISC_FAR *, 
				       unsigned char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_drive_menu (ISC_STATUS ISC_FAR *, 
				       isc_win_handle ISC_FAR *, 
				       isc_req_handle ISC_FAR *, 
				       short ISC_FAR *, 
				       char ISC_FAR *, 
				       short ISC_FAR *, 
				       char ISC_FAR *,
				       short ISC_FAR *, 
				       short ISC_FAR *, 
				       char ISC_FAR *, 
				       ISC_LONG ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_form_delete (ISC_STATUS ISC_FAR *, 
					isc_form_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_form_fetch (ISC_STATUS ISC_FAR *, 
				       isc_db_handle ISC_FAR *, 
				       isc_tr_handle ISC_FAR *, 
				       isc_req_handle ISC_FAR *, 
				       unsigned char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_form_insert (ISC_STATUS ISC_FAR *, 
					isc_db_handle ISC_FAR *, 
					isc_tr_handle ISC_FAR *, 
					isc_req_handle ISC_FAR *, 
					unsigned char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_get_entree (ISC_STATUS ISC_FAR *, 
				       isc_req_handle ISC_FAR *, 
				       short ISC_FAR *, 
				       char ISC_FAR *, 
				       ISC_LONG ISC_FAR *, 
				       short ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_initialize_menu (ISC_STATUS ISC_FAR *, 
					    isc_req_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_menu (ISC_STATUS ISC_FAR *, 
				 isc_win_handle ISC_FAR *, 
				 isc_req_handle ISC_FAR *, 
			 	 short ISC_FAR *, 
				 char ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_load_form (ISC_STATUS ISC_FAR *, 
				      isc_db_handle ISC_FAR *, 
				      isc_tr_handle ISC_FAR *, 
				      isc_form_handle ISC_FAR *, 
				      short ISC_FAR *, 
				      char ISC_FAR *);
																
ISC_STATUS  ISC_EXPORT isc_pop_window (ISC_STATUS ISC_FAR *, 
				       isc_win_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_put_entree (ISC_STATUS ISC_FAR *, 
				       isc_req_handle ISC_FAR *, 
				       short ISC_FAR *, 
				       char ISC_FAR *, 
				       ISC_LONG ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_reset_form (ISC_STATUS ISC_FAR *, 
				       isc_req_handle ISC_FAR *);

ISC_STATUS  ISC_EXPORT isc_suspend_window (ISC_STATUS ISC_FAR *, 
					   isc_win_handle ISC_FAR *);

#ifdef __cplusplus
};
#endif

#else 					/* __cplusplus || __STDC__ */
 
ISC_STATUS  ISC_EXPORT isc_attach_database();
ISC_STATUS  ISC_EXPORT isc_array_gen_sdl();
ISC_STATUS  ISC_EXPORT isc_array_get_slice();
ISC_STATUS  ISC_EXPORT isc_array_lookup_bounds();
ISC_STATUS  ISC_EXPORT isc_array_lookup_desc();
ISC_STATUS  ISC_EXPORT isc_array_set_desc();
ISC_STATUS  ISC_EXPORT isc_array_put_slice();
ISC_STATUS  ISC_EXPORT isc_blob_gen_bpb();
ISC_STATUS  ISC_EXPORT isc_blob_info();
ISC_STATUS  ISC_EXPORT isc_blob_lookup_desc();
ISC_STATUS  ISC_EXPORT isc_blob_set_desc();
ISC_STATUS  ISC_EXPORT isc_cancel_blob();
ISC_STATUS  ISC_EXPORT isc_cancel_events();
ISC_STATUS  ISC_EXPORT isc_close_blob();
ISC_STATUS  ISC_EXPORT isc_commit_retaining();
ISC_STATUS  ISC_EXPORT isc_commit_transaction();
ISC_STATUS  ISC_EXPORT isc_compile_request();
ISC_STATUS  ISC_EXPORT isc_compile_request2();
ISC_STATUS  ISC_EXPORT isc_create_blob();
ISC_STATUS  ISC_EXPORT isc_create_blob2();
ISC_STATUS  ISC_EXPORT isc_create_database();
ISC_STATUS  ISC_EXPORT isc_database_info();
ISC_STATUS  ISC_EXPORT isc_ddl();
void        ISC_EXPORT isc_decode_date();
void        ISC_EXPORT isc_decode_sql_date();
void        ISC_EXPORT isc_decode_sql_time();
void        ISC_EXPORT isc_decode_timestamp();
ISC_STATUS  ISC_EXPORT isc_detach_database();
ISC_STATUS  ISC_EXPORT isc_drop_database();
void        ISC_EXPORT isc_encode_date();
void        ISC_EXPORT isc_encode_sql_date();
void        ISC_EXPORT isc_encode_sql_time();
void        ISC_EXPORT isc_encode_timestamp();
ISC_LONG    ISC_EXPORT isc_event_block();
void        ISC_EXPORT isc_event_counts();
void        ISC_EXPORT isc_expand_dpb();
int         ISC_EXPORT isc_modify_dpb();
ISC_LONG    ISC_EXPORT isc_free();
ISC_STATUS  ISC_EXPORT isc_get_segment();
ISC_STATUS  ISC_EXPORT isc_get_slice();
ISC_STATUS  ISC_EXPORT isc_interprete();
ISC_STATUS  ISC_EXPORT isc_open_blob();
ISC_STATUS  ISC_EXPORT isc_open_blob2();
ISC_STATUS  ISC_EXPORT isc_prepare_transaction();
ISC_STATUS  ISC_EXPORT isc_prepare_transaction2();
void        ISC_EXPORT isc_print_sqlerror();
ISC_STATUS  ISC_EXPORT isc_print_status();
ISC_STATUS  ISC_EXPORT isc_put_segment();
ISC_STATUS  ISC_EXPORT isc_put_slice();
ISC_STATUS  ISC_EXPORT isc_que_events();
ISC_STATUS  ISC_EXPORT isc_receive();
ISC_STATUS  ISC_EXPORT isc_reconnect_transaction();
ISC_STATUS  ISC_EXPORT isc_release_request();
ISC_STATUS  ISC_EXPORT isc_request_info();
ISC_LONG    ISC_EXPORT isc_reset_fpe ();
ISC_STATUS  ISC_EXPORT isc_rollback_transaction();
ISC_STATUS  ISC_EXPORT isc_rollback_retaining();
ISC_STATUS  ISC_EXPORT isc_seek_blob();
ISC_STATUS  ISC_EXPORT isc_send();
ISC_STATUS  ISC_EXPORT isc_service_attach();
ISC_STATUS  ISC_EXPORT isc_service_detach();
ISC_STATUS  ISC_EXPORT isc_service_query();
ISC_STATUS  ISC_EXPORT isc_service_start();
ISC_STATUS  ISC_EXPORT isc_start_and_send();
ISC_STATUS  ISC_EXPORT isc_start_multiple();
ISC_STATUS  ISC_EXPORT isc_start_request();
ISC_STATUS  ISC_EXPORT isc_start_transaction();
ISC_LONG    ISC_EXPORT isc_sqlcode();
ISC_STATUS  ISC_EXPORT isc_transaction_info();
ISC_STATUS  ISC_EXPORT isc_transact_request();
ISC_STATUS  ISC_EXPORT isc_unwind_request();
ISC_STATUS  ISC_EXPORT isc_wait_for_event();
ISC_LONG    ISC_EXPORT isc_ftof();
ISC_STATUS  ISC_EXPORT isc_print_blr();
void        ISC_EXPORT isc_set_debug();
void        ISC_EXPORT isc_qtoq();
ISC_LONG    ISC_EXPORT isc_vax_integer();
void        ISC_EXPORT isc_vtof();
void        ISC_EXPORT isc_vtov();
int         ISC_EXPORT isc_version();

#ifndef __STDC__

/******************/
/* Blob functions */
/******************/

BSTREAM   ISC_FAR * ISC_EXPORT Bopen();
BSTREAM   ISC_FAR * ISC_EXPORT BLOB_open();
BSTREAM   ISC_FAR * ISC_EXPORT Bopen2();
#endif					/* __STDC__ */

#endif                                  /* __cplusplus || __STDC__ */

/***************************************************/
/* Actions to pass to the blob filter (ctl_source) */
/***************************************************/

#define isc_blob_filter_open             0
#define isc_blob_filter_get_segment      1
#define isc_blob_filter_close            2
#define isc_blob_filter_create           3
#define isc_blob_filter_put_segment      4
#define isc_blob_filter_alloc            5
#define isc_blob_filter_free             6
#define isc_blob_filter_seek             7

/*******************/
/* Blr definitions */
/*******************/

#ifndef _JRD_BLR_H_

#define blr_word(n) ((n) % 256), ((n) / 256)

#define blr_text                           14
#define blr_text2                          15
#define blr_short                          7
#define blr_long                           8
#define blr_quad                           9
#define blr_int64                          16
#define blr_float                          10
#define blr_double                         27
#define blr_d_float                        11
#define blr_timestamp                      35
#define blr_varying                        37
#define blr_varying2                       38
#define blr_blob                           261
#define blr_cstring                        40
#define blr_cstring2                       41	
#define blr_blob_id                        45
#define blr_sql_date                       12
#define blr_sql_time                       13

/* Historical alias for pre V6 applications */
#define blr_date                           blr_timestamp

#define blr_inner                          0
#define blr_left                           1
#define blr_right                          2
#define blr_full                           3

#define blr_gds_code                       0
#define blr_sql_code                       1
#define blr_exception                      2
#define blr_trigger_code                   3
#define blr_default_code                   4

#define blr_version4                       4
#define blr_version5                       5
#define blr_eoc                            76
#define blr_end                            255

#define blr_assignment                     1
#define blr_begin                          2
#define blr_dcl_variable                   3
#define blr_message                        4
#define blr_erase                          5
#define blr_fetch                          6
#define blr_for                            7
#define blr_if                             8
#define blr_loop                           9
#define blr_modify                         10
#define blr_handler                        11
#define blr_receive                        12
#define blr_select                         13
#define blr_send                           14
#define blr_store                          15
#define blr_label                          17
#define blr_leave                          18
#define blr_store2                         19
#define blr_post                           20

#define blr_literal                        21
#define blr_dbkey                          22
#define blr_field                          23
#define blr_fid                            24
#define blr_parameter                      25
#define blr_variable                       26
#define blr_average                        27
#define blr_count                          28
#define blr_maximum                        29
#define blr_minimum                        30
#define blr_total                          31
#define blr_add                            34
#define blr_subtract                       35
#define blr_multiply                       36
#define blr_divide                         37
#define blr_negate                         38
#define blr_concatenate                    39
#define blr_substring                      40
#define blr_parameter2                     41
#define blr_from                           42
#define blr_via                            43
#define blr_user_name                      44
#define blr_null                           45

#define blr_eql                            47
#define blr_neq                            48
#define blr_gtr                            49
#define blr_geq                            50
#define blr_lss                            51
#define blr_leq                            52
#define blr_containing                     53
#define blr_matching                       54
#define blr_starting                       55
#define blr_between                        56
#define blr_or                             57
#define blr_and                            58
#define blr_not                            59
#define blr_any                            60
#define blr_missing                        61
#define blr_unique                         62
#define blr_like                           63

#define blr_stream                         65
#define blr_set_index                      66
#define blr_rse                            67
#define blr_first                          68
#define blr_project                        69
#define blr_sort                           70
#define blr_boolean                        71
#define blr_ascending                      72
#define blr_descending                     73
#define blr_relation                       74
#define blr_rid                            75
#define blr_union                          76
#define blr_map                            77
#define blr_group_by                       78
#define blr_aggregate                      79
#define blr_join_type                      80

#define blr_agg_count                      83
#define blr_agg_max                        84
#define blr_agg_min                        85
#define blr_agg_total                      86
#define blr_agg_average                    87
#define blr_parameter3                     88
#define	blr_run_count                      118
#define	blr_run_max                        89
#define	blr_run_min                        90
#define	blr_run_total                      91
#define	blr_run_average                    92
#define blr_agg_count2                     93
#define blr_agg_count_distinct             94
#define blr_agg_total_distinct             95
#define blr_agg_average_distinct           96

#define blr_function                       100
#define blr_gen_id                         101
#define blr_prot_mask                      102
#define blr_upcase                         103
#define blr_lock_state                     104
#define blr_value_if                       105
#define blr_matching2                      106
#define blr_index                          107
#define blr_ansi_like                      108
#define blr_bookmark                       109
#define blr_crack                          110
#define blr_force_crack                    111
#define blr_seek                           112
#define blr_find                           113

#define blr_continue                       0
#define blr_forward                        1
#define blr_backward                       2
#define blr_bof_forward                    3
#define blr_eof_backward                   4

#define blr_lock_relation                  114
#define blr_lock_record                    115
#define blr_set_bookmark		   116
#define blr_get_bookmark		   117
#define blr_rs_stream                      119
#define blr_exec_proc                      120
#define blr_begin_range                    121
#define blr_end_range                      122
#define blr_delete_range                   123
#define blr_procedure                      124
#define blr_pid                            125
#define blr_exec_pid                       126
#define blr_singular                       127
#define blr_abort                          128
#define blr_block                          129
#define blr_error_handler                  130
#define blr_cast                           131
#define blr_release_lock                   132
#define blr_release_locks                  133
#define blr_start_savepoint                134
#define blr_end_savepoint                  135
#define blr_find_dbkey                     136
#define blr_range_relation                 137
#define blr_delete_ranges                  138

#define blr_plan                           139
#define blr_merge                          140
#define blr_join                           141
#define blr_sequential                     142
#define blr_navigational                   143
#define blr_indices                        144
#define blr_retrieve                       145

#define blr_relation2                      146
#define blr_rid2                           147
#define blr_reset_stream                   148
#define blr_release_bookmark               149
#define blr_set_generator                  150
#define blr_ansi_any			   151   
#define blr_exists			   152
#define blr_cardinality			   153

#define blr_record_version		   154		/* get tid of record */
#define blr_stall			   155		/* fake server stall */
#define blr_seek_no_warn		   156
#define blr_find_dbkey_version		   157
#define blr_ansi_all			   158   

#define blr_extract                        159

/* sub parameters for blr_extract */

#define blr_extract_year                   0
#define blr_extract_month                  1
#define blr_extract_day	                   2
#define blr_extract_hour                   3
#define blr_extract_minute                 4
#define blr_extract_second                 5
#define blr_extract_weekday                6
#define blr_extract_yearday                7

#define blr_current_date                   160
#define blr_current_timestamp              161
#define blr_current_time                   162

/* These verbs were added in 6.0, primarily to support 64-bit integers */

#define blr_add2	          163
#define blr_subtract2	          164
#define blr_multiply2             165
#define blr_divide2	          166
#define blr_agg_total2            167
#define blr_agg_total_distinct2   168
#define blr_agg_average2          169
#define blr_agg_average_distinct2 170
#define blr_average2		  171
#define blr_gen_id2		  172
#define blr_set_generator2        173
#define blr_current_role          174
#define blr_skip			   175
#endif					/* _JRD_BLR_H_ */

/**********************************/
/* Database parameter block stuff */
/**********************************/

#define isc_dpb_version1                  1
#define isc_dpb_cdd_pathname              1
#define isc_dpb_allocation                2
#define isc_dpb_journal                   3
#define isc_dpb_page_size                 4
#define isc_dpb_num_buffers               5
#define isc_dpb_buffer_length             6
#define isc_dpb_debug                     7
#define isc_dpb_garbage_collect           8
#define isc_dpb_verify                    9
#define isc_dpb_sweep                     10
#define isc_dpb_enable_journal            11
#define isc_dpb_disable_journal           12
#define isc_dpb_dbkey_scope               13
#define isc_dpb_number_of_users           14
#define isc_dpb_trace                     15
#define isc_dpb_no_garbage_collect        16
#define isc_dpb_damaged                   17
#define isc_dpb_license                   18
#define isc_dpb_sys_user_name             19
#define isc_dpb_encrypt_key               20
#define isc_dpb_activate_shadow           21
#define isc_dpb_sweep_interval            22
#define isc_dpb_delete_shadow             23
#define isc_dpb_force_write               24
#define isc_dpb_begin_log                 25
#define isc_dpb_quit_log                  26
#define isc_dpb_no_reserve                27
#define isc_dpb_user_name                 28
#define isc_dpb_password                  29
#define isc_dpb_password_enc              30
#define isc_dpb_sys_user_name_enc         31
#define isc_dpb_interp                    32
#define isc_dpb_online_dump               33
#define isc_dpb_old_file_size             34
#define isc_dpb_old_num_files             35
#define isc_dpb_old_file                  36
#define isc_dpb_old_start_page            37
#define isc_dpb_old_start_seqno           38
#define isc_dpb_old_start_file            39
#define isc_dpb_drop_walfile              40
#define isc_dpb_old_dump_id               41
#define isc_dpb_wal_backup_dir            42
#define isc_dpb_wal_chkptlen              43
#define isc_dpb_wal_numbufs               44
#define isc_dpb_wal_bufsize               45
#define isc_dpb_wal_grp_cmt_wait          46
#define isc_dpb_lc_messages               47
#define isc_dpb_lc_ctype                  48
#define isc_dpb_cache_manager		  49
#define isc_dpb_shutdown		  50
#define isc_dpb_online			  51
#define isc_dpb_shutdown_delay		  52
#define isc_dpb_reserved		  53
#define isc_dpb_overwrite		  54
#define isc_dpb_sec_attach		  55
#define isc_dpb_disable_wal		  56
#define isc_dpb_connect_timeout           57
#define isc_dpb_dummy_packet_interval     58
#define isc_dpb_gbak_attach               59
#define isc_dpb_sql_role_name             60
#define isc_dpb_set_page_buffers          61
#define isc_dpb_working_directory         62
#define isc_dpb_sql_dialect               63
#define isc_dpb_set_db_readonly           64
#define isc_dpb_set_db_sql_dialect        65
#define isc_dpb_gfix_attach		  66
#define isc_dpb_gstat_attach		  67

/*********************************/
/* isc_dpb_verify specific flags */
/*********************************/

#define isc_dpb_pages                     1
#define isc_dpb_records                   2
#define isc_dpb_indices                   4
#define isc_dpb_transactions              8
#define isc_dpb_no_update                 16
#define isc_dpb_repair                    32
#define isc_dpb_ignore                    64

/***********************************/
/* isc_dpb_shutdown specific flags */
/***********************************/

#define isc_dpb_shut_cache               1
#define isc_dpb_shut_attachment          2
#define isc_dpb_shut_transaction         4
#define isc_dpb_shut_force               8

/**************************************/
/* Bit assignments in RDB$SYSTEM_FLAG */
/**************************************/

#define RDB_system                         1
#define RDB_id_assigned                    2

/*************************************/
/* Transaction parameter block stuff */
/*************************************/

#define isc_tpb_version1                  1
#define isc_tpb_version3                  3
#define isc_tpb_consistency               1
#define isc_tpb_concurrency               2
#define isc_tpb_shared                    3
#define isc_tpb_protected                 4
#define isc_tpb_exclusive                 5
#define isc_tpb_wait                      6
#define isc_tpb_nowait                    7
#define isc_tpb_read                      8
#define isc_tpb_write                     9
#define isc_tpb_lock_read                 10
#define isc_tpb_lock_write                11
#define isc_tpb_verb_time                 12
#define isc_tpb_commit_time               13
#define isc_tpb_ignore_limbo              14
#define isc_tpb_read_committed		  15
#define isc_tpb_autocommit		  16
#define isc_tpb_rec_version		  17
#define isc_tpb_no_rec_version		  18
#define isc_tpb_restart_requests	  19
#define isc_tpb_no_auto_undo              20

/************************/
/* Blob Parameter Block */
/************************/

#define isc_bpb_version1                  1
#define isc_bpb_source_type               1
#define isc_bpb_target_type               2
#define isc_bpb_type                      3
#define isc_bpb_source_interp             4
#define isc_bpb_target_interp             5
#define isc_bpb_filter_parameter          6

#define isc_bpb_type_segmented            0
#define isc_bpb_type_stream               1

/*********************************/
/* Service parameter block stuff */
/*********************************/

#define isc_spb_version1                  1
#define isc_spb_current_version           2
#define isc_spb_version			  isc_spb_current_version
#define isc_spb_user_name                 isc_dpb_user_name 
#define isc_spb_sys_user_name             isc_dpb_sys_user_name
#define isc_spb_sys_user_name_enc         isc_dpb_sys_user_name_enc
#define isc_spb_password                  isc_dpb_password
#define isc_spb_password_enc              isc_dpb_password_enc
#define isc_spb_command_line              105
#define isc_spb_dbname                    106
#define isc_spb_verbose                   107
#define isc_spb_options                   108

#define isc_spb_connect_timeout           isc_dpb_connect_timeout
#define isc_spb_dummy_packet_interval     isc_dpb_dummy_packet_interval
#define isc_spb_sql_role_name             isc_dpb_sql_role_name

/*********************************/
/* Information call declarations */
/*********************************/

/****************************/
/* Common, structural codes */
/****************************/

#define isc_info_end                      1
#define isc_info_truncated                2
#define isc_info_error                    3
#define isc_info_data_not_ready	          4
#define isc_info_flag_end		  127

/******************************/
/* Database information items */
/******************************/

enum db_info_types
    {
	isc_info_db_id = 4,
	isc_info_reads = 5,
	isc_info_writes = 6,
	isc_info_fetches = 7,
	isc_info_marks = 8,

	isc_info_implementation = 11,
	isc_info_isc_version = 12,
	isc_info_base_level = 13,
	isc_info_page_size = 14,
	isc_info_num_buffers = 15,
	isc_info_limbo = 16,
	isc_info_current_memory = 17,
	isc_info_max_memory = 18,
	isc_info_window_turns = 19,
	isc_info_license = 20,   

	isc_info_allocation = 21,
	isc_info_attachment_id = 22,
	isc_info_read_seq_count = 23,
	isc_info_read_idx_count = 24,
	isc_info_insert_count = 25,
	isc_info_update_count = 26,
	isc_info_delete_count = 27,
	isc_info_backout_count = 28,
	isc_info_purge_count = 29,
	isc_info_expunge_count = 30, 

	isc_info_sweep_interval = 31,
	isc_info_ods_version = 32,
	isc_info_ods_minor_version = 33,
	isc_info_no_reserve = 34,
	isc_info_logfile = 35,
	isc_info_cur_logfile_name = 36,
	isc_info_cur_log_part_offset = 37,
	isc_info_num_wal_buffers = 38,
	isc_info_wal_buffer_size = 39,
	isc_info_wal_ckpt_length = 40,   

	isc_info_wal_cur_ckpt_interval = 41,  
	isc_info_wal_prv_ckpt_fname = 42,
	isc_info_wal_prv_ckpt_poffset = 43,
	isc_info_wal_recv_ckpt_fname = 44,
	isc_info_wal_recv_ckpt_poffset = 45,
	isc_info_wal_grpc_wait_usecs = 47,
	isc_info_wal_num_io = 48,
	isc_info_wal_avg_io_size = 49,
	isc_info_wal_num_commits = 50,  

	isc_info_wal_avg_grpc_size = 51,
	isc_info_forced_writes = 52,
	isc_info_user_names = 53,
	isc_info_page_errors = 54,
	isc_info_record_errors = 55,
	isc_info_bpage_errors = 56,
	isc_info_dpage_errors = 57,
	isc_info_ipage_errors = 58,
	isc_info_ppage_errors = 59,
	isc_info_tpage_errors = 60,

	isc_info_set_page_buffers = 61,
	isc_info_db_sql_dialect = 62,   
	isc_info_db_read_only = 63,
	isc_info_db_size_in_pages = 64,

    /* Values 65 -100 unused to avoid conflict with InterBase */
	
	frb_info_att_charset = 101,
	isc_info_db_class = 102,
	isc_info_firebird_version = 103,
	isc_info_oldest_transaction = 104,
	isc_info_oldest_active = 105,
	isc_info_oldest_snapshot = 106,
	isc_info_next_transaction = 107,
	isc_info_db_provider = 108,

	isc_info_db_last_value   /* Leave this LAST! */
    };


#define isc_info_version isc_info_isc_version

/**************************************/
/* Database information return values */
/**************************************/


enum  info_db_implementations
    {
	isc_info_db_impl_rdb_vms = 1,
	isc_info_db_impl_rdb_eln = 2,
	isc_info_db_impl_rdb_eln_dev = 3,
	isc_info_db_impl_rdb_vms_y = 4,
	isc_info_db_impl_rdb_eln_y = 5,
	isc_info_db_impl_jri = 6,
	isc_info_db_impl_jsv = 7,

	isc_info_db_impl_isc_apl_68K = 25,
	isc_info_db_impl_isc_vax_ultr = 26,
	isc_info_db_impl_isc_vms = 27,
	isc_info_db_impl_isc_sun_68k = 28,
	isc_info_db_impl_isc_os2 = 29,
	isc_info_db_impl_isc_sun4 = 30,	   /* 30 */
	
	isc_info_db_impl_isc_hp_ux = 31,
	isc_info_db_impl_isc_sun_386i = 32,
	isc_info_db_impl_isc_vms_orcl = 33,
	isc_info_db_impl_isc_mac_aux = 34,
	isc_info_db_impl_isc_rt_aix = 35,
	isc_info_db_impl_isc_mips_ult = 36,
	isc_info_db_impl_isc_xenix = 37,
	isc_info_db_impl_isc_dg = 38,
	isc_info_db_impl_isc_hp_mpexl = 39,
	isc_info_db_impl_isc_hp_ux68K = 40,	  /* 40 */

	isc_info_db_impl_isc_sgi = 41,
	isc_info_db_impl_isc_sco_unix = 42,
	isc_info_db_impl_isc_cray = 43,
	isc_info_db_impl_isc_imp = 44,
	isc_info_db_impl_isc_delta = 45,
	isc_info_db_impl_isc_next = 46,
	isc_info_db_impl_isc_dos = 47,
	isc_info_db_impl_m88K = 48,
	isc_info_db_impl_unixware = 49,
	isc_info_db_impl_isc_winnt_x86 = 50,

	isc_info_db_impl_isc_epson = 51,
	isc_info_db_impl_alpha_osf = 52,
	isc_info_db_impl_alpha_vms = 53,
	isc_info_db_impl_netware_386 = 54, 
	isc_info_db_impl_win_only = 55,
	isc_info_db_impl_ncr_3000 = 56,
	isc_info_db_impl_winnt_ppc = 57,
	isc_info_db_impl_dg_x86 = 58,
	isc_info_db_impl_sco_ev = 59,
	isc_info_db_impl_i386 = 60,

	isc_info_db_impl_freebsd = 61,
	isc_info_db_impl_netbsd = 62,
	isc_info_db_impl_darwin = 63,
	isc_info_db_impl_sinixz = 64,

	isc_info_db_impl_last_value   /* Leave this LAST! */
    };

#define isc_info_db_impl_isc_a            isc_info_db_impl_isc_apl_68K
#define isc_info_db_impl_isc_u            isc_info_db_impl_isc_vax_ultr
#define isc_info_db_impl_isc_v            isc_info_db_impl_isc_vms
#define isc_info_db_impl_isc_s            isc_info_db_impl_isc_sun_68k



enum	info_db_class
    {
	isc_info_db_class_access = 1,
	isc_info_db_class_y_valve = 2,
	isc_info_db_class_rem_int = 3,
	isc_info_db_class_rem_srvr = 4,
	isc_info_db_class_pipe_int = 7,
	isc_info_db_class_pipe_srvr = 8,
	isc_info_db_class_sam_int = 9,
	isc_info_db_class_sam_srvr = 10,
	isc_info_db_class_gateway = 11,
	isc_info_db_class_cache = 12,
	isc_info_db_class_classic_access = 13,
	isc_info_db_class_server_access = 14,

	isc_info_db_class_last_value   /* Leave this LAST! */
    };

enum	info_db_provider
    {
	isc_info_db_code_rdb_eln = 1,
	isc_info_db_code_rdb_vms = 2,
	isc_info_db_code_interbase = 3,
	isc_info_db_code_firebird = 4,

	isc_info_db_code_last_value   /* Leave this LAST! */
    };


/*****************************/
/* Request information items */
/*****************************/

#define isc_info_number_messages          4
#define isc_info_max_message              5
#define isc_info_max_send                 6
#define isc_info_max_receive              7
#define isc_info_state                    8
#define isc_info_message_number           9
#define isc_info_message_size             10
#define isc_info_request_cost             11
#define isc_info_access_path              12
#define isc_info_req_select_count         13
#define isc_info_req_insert_count         14
#define isc_info_req_update_count         15
#define isc_info_req_delete_count         16

/*********************/
/* Access path items */
/*********************/

#define isc_info_rsb_end		   0
#define isc_info_rsb_begin		   1
#define isc_info_rsb_type		   2
#define isc_info_rsb_relation		   3
#define isc_info_rsb_plan                  4

/*************/
/* Rsb types */
/*************/

#define isc_info_rsb_unknown		   1
#define isc_info_rsb_indexed		   2
#define isc_info_rsb_navigate		   3
#define isc_info_rsb_sequential	 	   4
#define isc_info_rsb_cross		   5
#define isc_info_rsb_sort		   6
#define isc_info_rsb_first		   7
#define isc_info_rsb_boolean		   8
#define isc_info_rsb_union		   9
#define isc_info_rsb_aggregate		  10
#define isc_info_rsb_merge		  11
#define isc_info_rsb_ext_sequential	  12
#define isc_info_rsb_ext_indexed	  13
#define isc_info_rsb_ext_dbkey		  14
#define isc_info_rsb_left_cross	 	  15
#define isc_info_rsb_select		  16
#define isc_info_rsb_sql_join		  17
#define isc_info_rsb_simulate		  18
#define isc_info_rsb_sim_cross		  19
#define isc_info_rsb_once		  20
#define isc_info_rsb_procedure		  21

/**********************/
/* Bitmap expressions */
/**********************/

#define isc_info_rsb_and		1
#define isc_info_rsb_or			2
#define isc_info_rsb_dbkey		3
#define isc_info_rsb_index		4

#define isc_info_req_active               2
#define isc_info_req_inactive             3
#define isc_info_req_send                 4
#define isc_info_req_receive              5
#define isc_info_req_select               6
#define isc_info_req_sql_stall		  7

/**************************/
/* Blob information items */
/**************************/

#define isc_info_blob_num_segments        4
#define isc_info_blob_max_segment         5
#define isc_info_blob_total_length        6
#define isc_info_blob_type                7

/*********************************/
/* Transaction information items */
/*********************************/

#define isc_info_tra_id                   4

/*****************************
 * Service action items      *
 *****************************/

#define isc_action_svc_backup          1 /* Starts database backup process on the server */ 
#define isc_action_svc_restore         2 /* Starts database restore process on the server */ 
#define isc_action_svc_repair          3 /* Starts database repair process on the server */ 
#define isc_action_svc_add_user        4 /* Adds a new user to the security database */ 
#define isc_action_svc_delete_user     5 /* Deletes a user record from the security database */ 
#define isc_action_svc_modify_user     6 /* Modifies a user record in the security database */
#define isc_action_svc_display_user    7 /* Displays a user record from the security database */
#define isc_action_svc_properties      8 /* Sets database properties */ 
#define isc_action_svc_add_license     9 /* Adds a license to the license file */ 
#define isc_action_svc_remove_license 10 /* Removes a license from the license file */ 
#define isc_action_svc_db_stats	      11 /* Retrieves database statistics */
#define isc_action_svc_get_ib_log     12 /* Retrieves the InterBase log file from the server */

/*****************************
 * Service information items *
 *****************************/

#define isc_info_svc_svr_db_info      50 /* Retrieves the number of attachments and databases */ 
#define isc_info_svc_get_license      51 /* Retrieves all license keys and IDs from the license file */
#define isc_info_svc_get_license_mask 52 /* Retrieves a bitmask representing licensed options on the server */ 
#define isc_info_svc_get_config       53 /* Retrieves the parameters and values for IB_CONFIG */ 
#define isc_info_svc_version          54 /* Retrieves the version of the services manager */ 
#define isc_info_svc_server_version   55 /* Retrieves the version of the InterBase server */ 
#define isc_info_svc_implementation   56 /* Retrieves the implementation of the InterBase server */ 
#define isc_info_svc_capabilities     57 /* Retrieves a bitmask representing the server's capabilities */ 
#define isc_info_svc_user_dbpath      58 /* Retrieves the path to the security database in use by the server */ 
#define isc_info_svc_get_env	      59 /* Retrieves the setting of $INTERBASE */
#define isc_info_svc_get_env_lock     60 /* Retrieves the setting of $INTERBASE_LCK */
#define isc_info_svc_get_env_msg      61 /* Retrieves the setting of $INTERBASE_MSG */
#define isc_info_svc_line             62 /* Retrieves 1 line of service output per call */
#define isc_info_svc_to_eof           63 /* Retrieves as much of the server output as will fit in the supplied buffer */
#define isc_info_svc_timeout          64 /* Sets / signifies a timeout value for reading service information */
#define isc_info_svc_get_licensed_users 65 /* Retrieves the number of users licensed for accessing the server */
#define isc_info_svc_limbo_trans	66 /* Retrieve the limbo transactions */
#define isc_info_svc_running		67 /* Checks to see if a service is running on an attachment */
#define isc_info_svc_get_users		68 /* Returns the user information from isc_action_svc_display_users */

/******************************************************
 * Parameters for isc_action_{add|delete|modify)_user *
 ******************************************************/

#define isc_spb_sec_userid            5
#define isc_spb_sec_groupid           6
#define isc_spb_sec_username          7
#define isc_spb_sec_password          8
#define isc_spb_sec_groupname         9
#define isc_spb_sec_firstname         10
#define isc_spb_sec_middlename        11
#define isc_spb_sec_lastname          12

/*******************************************************
 * Parameters for isc_action_svc_(add|remove)_license, *
 * isc_info_svc_get_license                            *
 *******************************************************/

#define isc_spb_lic_key               5
#define isc_spb_lic_id                6
#define isc_spb_lic_desc              7


/*****************************************
 * Parameters for isc_action_svc_backup  *
 *****************************************/

#define isc_spb_bkp_file                 5 
#define isc_spb_bkp_factor               6
#define isc_spb_bkp_length               7
#define isc_spb_bkp_ignore_checksums     0x01
#define isc_spb_bkp_ignore_limbo         0x02
#define isc_spb_bkp_metadata_only        0x04
#define isc_spb_bkp_no_garbage_collect   0x08
#define isc_spb_bkp_old_descriptions     0x10
#define isc_spb_bkp_non_transportable    0x20
#define isc_spb_bkp_convert              0x40
#define isc_spb_bkp_expand		 0x80

/********************************************
 * Parameters for isc_action_svc_properties *
 ********************************************/

#define isc_spb_prp_page_buffers		5
#define isc_spb_prp_sweep_interval		6
#define isc_spb_prp_shutdown_db			7
#define isc_spb_prp_deny_new_attachments	9
#define isc_spb_prp_deny_new_transactions	10
#define isc_spb_prp_reserve_space		11
#define isc_spb_prp_write_mode			12
#define isc_spb_prp_access_mode			13
#define isc_spb_prp_set_sql_dialect		14
#define isc_spb_prp_activate			0x0100
#define isc_spb_prp_db_online			0x0200

/********************************************
 * Parameters for isc_spb_prp_reserve_space *
 ********************************************/

#define isc_spb_prp_res_use_full	35
#define isc_spb_prp_res			36

/******************************************
 * Parameters for isc_spb_prp_write_mode  *
 ******************************************/

#define isc_spb_prp_wm_async		37
#define isc_spb_prp_wm_sync		38

/******************************************
 * Parameters for isc_spb_prp_access_mode *
 ******************************************/

#define isc_spb_prp_am_readonly		39
#define isc_spb_prp_am_readwrite	40

/*****************************************
 * Parameters for isc_action_svc_repair  *
 *****************************************/

#define isc_spb_rpr_commit_trans		15
#define isc_spb_rpr_rollback_trans		34
#define isc_spb_rpr_recover_two_phase		17
#define isc_spb_tra_id                     	18
#define isc_spb_single_tra_id			19
#define isc_spb_multi_tra_id			20
#define isc_spb_tra_state			21
#define isc_spb_tra_state_limbo			22
#define isc_spb_tra_state_commit		23
#define isc_spb_tra_state_rollback		24
#define isc_spb_tra_state_unknown		25
#define isc_spb_tra_host_site			26
#define isc_spb_tra_remote_site			27
#define isc_spb_tra_db_path			28
#define isc_spb_tra_advise			29
#define isc_spb_tra_advise_commit		30
#define isc_spb_tra_advise_rollback		31
#define isc_spb_tra_advise_unknown		33

#define isc_spb_rpr_validate_db			0x01
#define isc_spb_rpr_sweep_db			0x02
#define isc_spb_rpr_mend_db			0x04
#define isc_spb_rpr_list_limbo_trans		0x08
#define isc_spb_rpr_check_db			0x10
#define isc_spb_rpr_ignore_checksum		0x20
#define isc_spb_rpr_kill_shadows		0x40
#define isc_spb_rpr_full			0x80

/*****************************************
 * Parameters for isc_action_svc_restore *
 *****************************************/

#define isc_spb_res_buffers			9
#define isc_spb_res_page_size			10 
#define isc_spb_res_length			11
#define isc_spb_res_access_mode			12
#define isc_spb_res_deactivate_idx		0x0100
#define isc_spb_res_no_shadow			0x0200
#define isc_spb_res_no_validity			0x0400
#define isc_spb_res_one_at_a_time		0x0800
#define isc_spb_res_replace			0x1000
#define isc_spb_res_create			0x2000
#define isc_spb_res_use_all_space		0x4000

/******************************************
 * Parameters for isc_spb_res_access_mode  *
 ******************************************/

#define isc_spb_res_am_readonly			isc_spb_prp_am_readonly
#define isc_spb_res_am_readwrite		isc_spb_prp_am_readwrite

/*******************************************
 * Parameters for isc_info_svc_svr_db_info *
 *******************************************/

#define isc_spb_num_att               5 
#define isc_spb_num_db                6

/*****************************************
 * Parameters for isc_info_svc_db_stats  *
 *****************************************/

#define isc_spb_sts_data_pages		0x01
#define isc_spb_sts_db_log		0x02
#define isc_spb_sts_hdr_pages		0x04
#define isc_spb_sts_idx_pages		0x08
#define isc_spb_sts_sys_relations	0x10

/*************************/
/* SQL information items */
/*************************/

#define isc_info_sql_select               4
#define isc_info_sql_bind                 5
#define isc_info_sql_num_variables        6
#define isc_info_sql_describe_vars        7
#define isc_info_sql_describe_end         8
#define isc_info_sql_sqlda_seq            9
#define isc_info_sql_message_seq          10
#define isc_info_sql_type                 11
#define isc_info_sql_sub_type             12
#define isc_info_sql_scale                13
#define isc_info_sql_length               14
#define isc_info_sql_null_ind             15
#define isc_info_sql_field                16
#define isc_info_sql_relation             17
#define isc_info_sql_owner                18
#define isc_info_sql_alias                19
#define isc_info_sql_sqlda_start          20
#define isc_info_sql_stmt_type            21
#define isc_info_sql_get_plan             22
#define isc_info_sql_records		  23
#define isc_info_sql_batch_fetch	  24

/*********************************/
/* SQL information return values */
/*********************************/

#define isc_info_sql_stmt_select          1
#define isc_info_sql_stmt_insert          2
#define isc_info_sql_stmt_update          3
#define isc_info_sql_stmt_delete          4
#define isc_info_sql_stmt_ddl             5
#define isc_info_sql_stmt_get_segment     6
#define isc_info_sql_stmt_put_segment     7
#define isc_info_sql_stmt_exec_procedure  8
#define isc_info_sql_stmt_start_trans     9
#define isc_info_sql_stmt_commit          10
#define isc_info_sql_stmt_rollback        11
#define isc_info_sql_stmt_select_for_upd  12
#define isc_info_sql_stmt_set_generator   13

/***********************************/
/* Server configuration key values */
/***********************************/

#define	ISCCFG_LOCKMEM_KEY	0
#define ISCCFG_LOCKSEM_KEY	1
#define ISCCFG_LOCKSIG_KEY	2
#define ISCCFG_EVNTMEM_KEY	3
#define ISCCFG_DBCACHE_KEY	4
#define ISCCFG_PRIORITY_KEY	5
#define ISCCFG_IPCMAP_KEY	6
#define ISCCFG_MEMMIN_KEY	7
#define ISCCFG_MEMMAX_KEY	8
#define	ISCCFG_LOCKORDER_KEY	9
#define	ISCCFG_ANYLOCKMEM_KEY	10
#define ISCCFG_ANYLOCKSEM_KEY	11
#define ISCCFG_ANYLOCKSIG_KEY	12
#define ISCCFG_ANYEVNTMEM_KEY	13
#define ISCCFG_LOCKHASH_KEY	14
#define ISCCFG_DEADLOCK_KEY	15
#define ISCCFG_LOCKSPIN_KEY	16
#define ISCCFG_CONN_TIMEOUT_KEY 17
#define ISCCFG_DUMMY_INTRVL_KEY 18
#define ISCCFG_TRACE_POOLS_KEY  19   /* Internal Use only */
#define ISCCFG_REMOTE_BUFFER_KEY	20

#ifdef SET_TCP_NO_DELAY
#define ISCCFG_NO_NAGLE_KEY	21 
#endif

#ifdef WIN_NT
#if defined SET_TCP_NO_DELAY
#error Currently unsupported configuration
#endif
#define ISCCFG_CPU_AFFINITY_KEY	21
#endif


/***************/
/* Error codes */
/***************/

#define isc_facility                       20
#define isc_err_base                       335544320L
#define isc_err_factor                     1
#define isc_arg_end                        0
#define isc_arg_gds                        1
#define isc_arg_string                     2
#define isc_arg_cstring                    3
#define isc_arg_number                     4
#define isc_arg_interpreted                5
#define isc_arg_vms                        6
#define isc_arg_unix                       7
#define isc_arg_domain                     8
#define isc_arg_dos                        9
#define isc_arg_mpexl                      10
#define isc_arg_mpexl_ipc                  11
#define isc_arg_next_mach		   15
#define isc_arg_netware		           16
#define isc_arg_win32                      17
#define isc_arg_warning                    18

#ifdef DARWIN
#include <Firebird/iberror.h>
#else
#include <iberror.h>
#endif

/**********************************************/
/* Dynamic Data Definition Language operators */
/**********************************************/

/******************/
/* Version number */
/******************/

#define isc_dyn_version_1                 1
#define isc_dyn_eoc                       255

/******************************/
/* Operations (may be nested) */
/******************************/

#define isc_dyn_begin                     2
#define isc_dyn_end                       3
#define isc_dyn_if                        4
#define isc_dyn_def_database              5
#define isc_dyn_def_global_fld            6
#define isc_dyn_def_local_fld             7
#define isc_dyn_def_idx                   8
#define isc_dyn_def_rel                   9
#define isc_dyn_def_sql_fld               10
#define isc_dyn_def_view                  12
#define isc_dyn_def_trigger               15
#define isc_dyn_def_security_class        120
#define isc_dyn_def_dimension             140
#define isc_dyn_def_generator             24
#define isc_dyn_def_function              25
#define isc_dyn_def_filter                26
#define isc_dyn_def_function_arg          27
#define isc_dyn_def_shadow                34
#define isc_dyn_def_trigger_msg           17
#define isc_dyn_def_file                  36
#define isc_dyn_mod_database              39
#define isc_dyn_mod_rel                   11
#define isc_dyn_mod_global_fld            13
#define isc_dyn_mod_idx                   102
#define isc_dyn_mod_local_fld             14
#define isc_dyn_mod_sql_fld		  216
#define isc_dyn_mod_view                  16
#define isc_dyn_mod_security_class        122
#define isc_dyn_mod_trigger               113
#define isc_dyn_mod_trigger_msg           28
#define isc_dyn_delete_database           18
#define isc_dyn_delete_rel                19
#define isc_dyn_delete_global_fld         20
#define isc_dyn_delete_local_fld          21
#define isc_dyn_delete_idx                22
#define isc_dyn_delete_security_class     123
#define isc_dyn_delete_dimensions         143
#define isc_dyn_delete_trigger            23
#define isc_dyn_delete_trigger_msg        29
#define isc_dyn_delete_filter             32
#define isc_dyn_delete_function           33
#define isc_dyn_delete_shadow             35
#define isc_dyn_grant                     30
#define isc_dyn_revoke                    31
#define isc_dyn_def_primary_key           37
#define isc_dyn_def_foreign_key           38
#define isc_dyn_def_unique                40
#define isc_dyn_def_procedure             164
#define isc_dyn_delete_procedure          165
#define isc_dyn_def_parameter             135
#define isc_dyn_delete_parameter          136
#define isc_dyn_mod_procedure             175
#define isc_dyn_def_log_file              176
#define isc_dyn_def_cache_file            180
#define isc_dyn_def_exception             181
#define isc_dyn_mod_exception             182
#define isc_dyn_del_exception             183
#define isc_dyn_drop_log                  194
#define isc_dyn_drop_cache                195
#define isc_dyn_def_default_log           202

/***********************/
/* View specific stuff */
/***********************/

#define isc_dyn_view_blr                  43
#define isc_dyn_view_source               44
#define isc_dyn_view_relation             45
#define isc_dyn_view_context              46
#define isc_dyn_view_context_name         47

/**********************/
/* Generic attributes */
/**********************/

#define isc_dyn_rel_name                  50
#define isc_dyn_fld_name                  51
#define isc_dyn_new_fld_name		  215
#define isc_dyn_idx_name                  52
#define isc_dyn_description               53
#define isc_dyn_security_class            54
#define isc_dyn_system_flag               55
#define isc_dyn_update_flag               56
#define isc_dyn_prc_name                  166
#define isc_dyn_prm_name                  137
#define isc_dyn_sql_object                196
#define isc_dyn_fld_character_set_name    174

/********************************/
/* Relation specific attributes */
/********************************/

#define isc_dyn_rel_dbkey_length          61
#define isc_dyn_rel_store_trig            62
#define isc_dyn_rel_modify_trig           63
#define isc_dyn_rel_erase_trig            64
#define isc_dyn_rel_store_trig_source     65
#define isc_dyn_rel_modify_trig_source    66
#define isc_dyn_rel_erase_trig_source     67
#define isc_dyn_rel_ext_file              68
#define isc_dyn_rel_sql_protection        69
#define isc_dyn_rel_constraint            162
#define isc_dyn_delete_rel_constraint     163

/************************************/
/* Global field specific attributes */
/************************************/

#define isc_dyn_fld_type                  70
#define isc_dyn_fld_length                71
#define isc_dyn_fld_scale                 72
#define isc_dyn_fld_sub_type              73
#define isc_dyn_fld_segment_length        74
#define isc_dyn_fld_query_header          75
#define isc_dyn_fld_edit_string           76
#define isc_dyn_fld_validation_blr        77
#define isc_dyn_fld_validation_source     78
#define isc_dyn_fld_computed_blr          79
#define isc_dyn_fld_computed_source       80
#define isc_dyn_fld_missing_value         81
#define isc_dyn_fld_default_value         82
#define isc_dyn_fld_query_name            83
#define isc_dyn_fld_dimensions            84
#define isc_dyn_fld_not_null              85
#define isc_dyn_fld_precision             86
#define isc_dyn_fld_char_length           172
#define isc_dyn_fld_collation             173
#define isc_dyn_fld_default_source        193
#define isc_dyn_del_default               197
#define isc_dyn_del_validation            198
#define isc_dyn_single_validation         199
#define isc_dyn_fld_character_set         203

/***********************************/
/* Local field specific attributes */
/***********************************/

#define isc_dyn_fld_source                90
#define isc_dyn_fld_base_fld              91
#define isc_dyn_fld_position              92
#define isc_dyn_fld_update_flag           93

/*****************************/
/* Index specific attributes */
/*****************************/

#define isc_dyn_idx_unique                100
#define isc_dyn_idx_inactive              101
#define isc_dyn_idx_type                  103
#define isc_dyn_idx_foreign_key           104
#define isc_dyn_idx_ref_column            105
#define isc_dyn_idx_statistic		  204

/*******************************/
/* Trigger specific attributes */
/*******************************/

#define isc_dyn_trg_type                  110
#define isc_dyn_trg_blr                   111
#define isc_dyn_trg_source                112
#define isc_dyn_trg_name                  114
#define isc_dyn_trg_sequence              115
#define isc_dyn_trg_inactive              116
#define isc_dyn_trg_msg_number            117
#define isc_dyn_trg_msg                   118

/**************************************/
/* Security Class specific attributes */
/**************************************/

#define isc_dyn_scl_acl                   121
#define isc_dyn_grant_user                130
#define isc_dyn_grant_user_explicit       219
#define isc_dyn_grant_proc                186
#define isc_dyn_grant_trig                187
#define isc_dyn_grant_view                188
#define isc_dyn_grant_options             132
#define isc_dyn_grant_user_group          205
#define isc_dyn_grant_role                218


/**********************************/
/* Dimension specific information */
/**********************************/

#define isc_dyn_dim_lower                 141
#define isc_dyn_dim_upper                 142

/****************************/
/* File specific attributes */
/****************************/

#define isc_dyn_file_name                 125
#define isc_dyn_file_start                126
#define isc_dyn_file_length               127
#define isc_dyn_shadow_number             128
#define isc_dyn_shadow_man_auto           129
#define isc_dyn_shadow_conditional        130

/********************************/
/* Log file specific attributes */
/********************************/

#define isc_dyn_log_file_sequence         177
#define isc_dyn_log_file_partitions       178
#define isc_dyn_log_file_serial           179
#define isc_dyn_log_file_overflow         200
#define isc_dyn_log_file_raw		  201

/***************************/
/* Log specific attributes */
/***************************/

#define isc_dyn_log_group_commit_wait     189 
#define isc_dyn_log_buffer_size           190
#define isc_dyn_log_check_point_length    191
#define isc_dyn_log_num_of_buffers        192

/********************************/
/* Function specific attributes */
/********************************/

#define isc_dyn_function_name             145
#define isc_dyn_function_type             146
#define isc_dyn_func_module_name          147
#define isc_dyn_func_entry_point          148
#define isc_dyn_func_return_argument      149
#define isc_dyn_func_arg_position         150
#define isc_dyn_func_mechanism            151
#define isc_dyn_filter_in_subtype         152
#define isc_dyn_filter_out_subtype        153


#define isc_dyn_description2		  154	
#define isc_dyn_fld_computed_source2	  155	
#define isc_dyn_fld_edit_string2	  156
#define isc_dyn_fld_query_header2	  157
#define isc_dyn_fld_validation_source2	  158
#define isc_dyn_trg_msg2		  159
#define isc_dyn_trg_source2		  160
#define isc_dyn_view_source2		  161
#define isc_dyn_xcp_msg2		  184

/*********************************/
/* Generator specific attributes */
/*********************************/

#define isc_dyn_generator_name            95
#define isc_dyn_generator_id              96

/*********************************/
/* Procedure specific attributes */
/*********************************/

#define isc_dyn_prc_inputs                167
#define isc_dyn_prc_outputs               168
#define isc_dyn_prc_source                169
#define isc_dyn_prc_blr                   170
#define isc_dyn_prc_source2               171

/*********************************/
/* Parameter specific attributes */
/*********************************/

#define isc_dyn_prm_number                138
#define isc_dyn_prm_type                  139

/********************************/
/* Relation specific attributes */
/********************************/

#define isc_dyn_xcp_msg                   185

/**********************************************/
/* Cascading referential integrity values     */
/**********************************************/
#define isc_dyn_foreign_key_update        205
#define isc_dyn_foreign_key_delete        206
#define isc_dyn_foreign_key_cascade       207
#define isc_dyn_foreign_key_default       208
#define isc_dyn_foreign_key_null          209
#define isc_dyn_foreign_key_none          210

/***********************/
/* SQL role values     */
/***********************/
#define isc_dyn_def_sql_role              211
#define isc_dyn_sql_role_name             212
#define isc_dyn_grant_admin_options       213
#define isc_dyn_del_sql_role              214
/* 215 & 216 are used some lines above. */

/**********************************************/
/* Generators again                           */
/**********************************************/

#ifndef __cplusplus                     /* c definitions */
#define gds__dyn_delete_generator          217
#else                                   /* c++ definitions */
const unsigned char gds__dyn_delete_generator       = 217;
#endif


/****************************/
/* Last $dyn value assigned */
/****************************/

#define isc_dyn_last_dyn_value            219



/******************************************/
/* Array slice description language (SDL) */
/******************************************/

#define isc_sdl_version1                  1
#define isc_sdl_eoc                       255
#define isc_sdl_relation                  2
#define isc_sdl_rid                       3
#define isc_sdl_field                     4
#define isc_sdl_fid                       5
#define isc_sdl_struct                    6
#define isc_sdl_variable                  7
#define isc_sdl_scalar                    8
#define isc_sdl_tiny_integer              9
#define isc_sdl_short_integer             10
#define isc_sdl_long_integer              11
#define isc_sdl_literal                   12
#define isc_sdl_add                       13
#define isc_sdl_subtract                  14
#define isc_sdl_multiply                  15
#define isc_sdl_divide                    16
#define isc_sdl_negate                    17
#define isc_sdl_eql                       18
#define isc_sdl_neq                       19
#define isc_sdl_gtr                       20
#define isc_sdl_geq                       21
#define isc_sdl_lss                       22
#define isc_sdl_leq                       23
#define isc_sdl_and                       24
#define isc_sdl_or                        25
#define isc_sdl_not                       26
#define isc_sdl_while                     27
#define isc_sdl_assignment                28
#define isc_sdl_label                     29
#define isc_sdl_leave                     30
#define isc_sdl_begin                     31
#define isc_sdl_end                       32
#define isc_sdl_do3                       33
#define isc_sdl_do2                       34
#define isc_sdl_do1                       35
#define isc_sdl_element                   36

/********************************************/
/* International text interpretation values */
/********************************************/

#define isc_interp_eng_ascii              0
#define isc_interp_jpn_sjis               5
#define isc_interp_jpn_euc                6

/*******************/
/* SQL definitions */
/*******************/

#define SQL_TEXT                           452
#define SQL_VARYING                        448
#define SQL_SHORT                          500
#define SQL_LONG                           496
#define SQL_FLOAT                          482
#define SQL_DOUBLE                         480
#define SQL_D_FLOAT                        530
#define SQL_TIMESTAMP                      510
#define SQL_BLOB                           520
#define SQL_ARRAY                          540
#define SQL_QUAD                           550
#define SQL_TYPE_TIME			   560
#define SQL_TYPE_DATE                      570
#define SQL_INT64			   580

/* Historical alias for pre V6 applications */
#define SQL_DATE			SQL_TIMESTAMP

/*****************/
/* Blob Subtypes */
/*****************/

/* types less than zero are reserved for customer use */

#define isc_blob_untyped                   0

/* internal subtypes */

#define isc_blob_text                      1
#define isc_blob_blr                       2
#define isc_blob_acl                       3
#define isc_blob_ranges                    4
#define isc_blob_summary                   5
#define isc_blob_format                    6
#define isc_blob_tra                       7
#define isc_blob_extfile                   8

/* the range 20-30 is reserved for dBASE and Paradox types */

#define isc_blob_formatted_memo            20
#define isc_blob_paradox_ole               21
#define isc_blob_graphic                   22
#define isc_blob_dbase_ole                 23
#define isc_blob_typed_binary              24

/* Deprecated definitions maintained for compatibility only */

#define isc_info_db_SQL_dialect           62
#define isc_dpb_SQL_dialect               63
#define isc_dpb_set_db_SQL_dialect        65

#endif  				/* _JRD_IBASE_H_ */
/*
 *	PROGRAM:	C preprocessor
 *	MODULE:		gdsold.h
 *	DESCRIPTION:	BLR constants
 *
 * The contents of this file are subject to the Interbase Public
 * License Version 1.0 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy
 * of the License at http://www.Inprise.com/IPL.html
 *
 * Software distributed under the License is distributed on an
 * "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code was created by Inprise Corporation
 * and its predecessors. Portions created by Inprise Corporation are
 * Copyright (C) Inprise Corporation.
 *
 * All Rights Reserved.
 * Contributor(s): ______________________________________.
 */

#ifndef _JRD_GDSOLD_H_
#define _JRD_GDSOLD_H_

#ifndef HARBOR_MERGE
#define HARBOR_MERGE
#endif

#define gds_version3

#define GDS_TRUE	1
#define GDS_FALSE	0
#if !(defined __cplusplus)
#define GDS__TRUE	GDS_TRUE
#define GDS__FALSE	GDS_FALSE
#endif

#if (defined __osf__ && defined __alpha)
#define GDS_LONG	int
#define GDS_ULONG	unsigned int
#else
#define GDS_LONG	long
#define GDS_ULONG	unsigned long
#endif

#define GDS_STATUS	long

#ifndef apollo				/* if not apollo */
#define GDS_VAL(val)	val
#define GDS_REF(val)	&val
#define GDS_TYPE	GDS_STATUS
#else					/* else apollo */
#define GDS_VAL(val)	(*val)
#define GDS_REF(val)	val
#define GDS_TYPE	std_$call
#endif					/* endif apollo */

#define CANCEL_disable	1		
#define CANCEL_enable	2
#define CANCEL_raise	3

/******************************************************************/
/* define type, export and other stuff based on c/c++ and Windows */
/******************************************************************/

#define  GDS_FAR	ISC_FAR
#define  GDS_EXPORT     ISC_EXPORT

typedef void 	GDS_FAR *gds_db_handle;
typedef void 	GDS_FAR *gds_req_handle;
typedef void 	GDS_FAR *gds_tr_handle;
typedef void 	GDS_FAR *gds_blob_handle;
typedef void 	GDS_FAR *gds_win_handle;
typedef void 	GDS_FAR *gds_form_handle;
typedef void 	GDS_FAR *gds_stmt_handle;
typedef void 	GDS_FAR *gds_svc_handle;
typedef void   (GDS_FAR *gds_callback)();

/*************************/
/* Old OSRI entrypoints  */
/*************************/

#ifndef NO_OSRI_ENTRYPOINTS

#ifndef __cplusplus

#if (defined(__STDC__) && !defined(apollo)) || defined(_Windows) || \
    (defined(_MSC_VER) && defined(WIN32)) || defined(_WINDOWS) || \
    (defined(__BORLANDC__) && (defined(__WIN32__) || defined(__OS2__))) || \
    (defined(__IBMC__) && defined(__OS2__)) || defined(AIX_PPC)


GDS_STATUS GDS_EXPORT gds__attach_database (GDS_STATUS GDS_FAR *, 
					    short,
					    char GDS_FAR *,
					    void GDS_FAR * GDS_FAR *,
					    short, 
					    char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__blob_info (GDS_STATUS GDS_FAR *, 
				      void GDS_FAR * GDS_FAR *, 
				      short,
				      char GDS_FAR *,
				      short,
				      char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__cancel_blob (GDS_STATUS GDS_FAR *,
					void GDS_FAR * GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__close_blob (GDS_STATUS GDS_FAR *,
				       void GDS_FAR * GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__commit_transaction (GDS_STATUS GDS_FAR *, 
					       void GDS_FAR * GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__compile_request (GDS_STATUS GDS_FAR *,
					    void GDS_FAR * GDS_FAR *,
					    void GDS_FAR * GDS_FAR *,
					    short,
					    char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__compile_request2 (GDS_STATUS GDS_FAR *,
					     void GDS_FAR * GDS_FAR *,
					     void GDS_FAR * GDS_FAR *,
					     short,
					     char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__create_blob (GDS_STATUS GDS_FAR *,
					void GDS_FAR * GDS_FAR *,
					void GDS_FAR * GDS_FAR *,
					void GDS_FAR * GDS_FAR *,
					GDS__QUAD GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__create_blob2 (GDS_STATUS GDS_FAR *,
					 void GDS_FAR * GDS_FAR *,
					 void GDS_FAR * GDS_FAR	*,
					 void GDS_FAR * GDS_FAR *, 
					 GDS__QUAD GDS_FAR *,
					 short,
					 char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__create_database (GDS_STATUS GDS_FAR *,
					    short,
					    char GDS_FAR *,
					    void GDS_FAR * GDS_FAR *,
					    short,
					    char GDS_FAR *,
					    short);

GDS_STATUS GDS_EXPORT gds__database_info (GDS_STATUS GDS_FAR *, 
					  void GDS_FAR * GDS_FAR *,
					  short,
					  char GDS_FAR *,
					  short,
					  char GDS_FAR *);

void       GDS_EXPORT gds__decode_date (GDS__QUAD GDS_FAR *, 
					void GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__detach_database (GDS_STATUS GDS_FAR *,
					    void GDS_FAR * GDS_FAR *);

GDS_ULONG  GDS_EXPORT gds__free (void GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__get_segment (GDS_STATUS GDS_FAR *,
					void GDS_FAR * GDS_FAR *,
					unsigned short GDS_FAR *,
					unsigned short,
					char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__open_blob (GDS_STATUS GDS_FAR *,
				      void GDS_FAR * GDS_FAR *,
				      void GDS_FAR * GDS_FAR *,
				      void GDS_FAR * GDS_FAR *,
				      GDS__QUAD GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__open_blob2 (GDS_STATUS GDS_FAR *,
				       void GDS_FAR * GDS_FAR *,
				       void GDS_FAR * GDS_FAR *,
				       void GDS_FAR * GDS_FAR *,
				       GDS__QUAD GDS_FAR *,
				       short,
				       char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__prepare_transaction (GDS_STATUS GDS_FAR *,
					        void GDS_FAR * GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__prepare_transaction2 (GDS_STATUS GDS_FAR *,
					   	 void GDS_FAR * GDS_FAR *,
						 short,
						 char GDS_FAR *);
	
GDS_STATUS GDS_EXPORT gds__put_segment (GDS_STATUS GDS_FAR *, 
					void GDS_FAR * GDS_FAR *, 
					unsigned short,
					char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__receive (GDS_STATUS GDS_FAR *, 
				    void GDS_FAR * GDS_FAR *,
				    short,
				    short,
				    void GDS_FAR *,
				    short);

GDS_STATUS GDS_EXPORT gds__reconnect_transaction (GDS_STATUS GDS_FAR *,
						  void GDS_FAR * GDS_FAR *,
						  void GDS_FAR * GDS_FAR *,
						  short,
						  char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__request_info (GDS_STATUS GDS_FAR *, 
					 void GDS_FAR * GDS_FAR *,
					 short,
					 short,
					 char GDS_FAR *,
					 short,
					 char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__release_request (GDS_STATUS GDS_FAR *, 
					    void GDS_FAR * GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__rollback_transaction (GDS_STATUS GDS_FAR *, 
						 void GDS_FAR * GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__seek_blob (GDS_STATUS GDS_FAR *, 
				      void GDS_FAR * GDS_FAR *,
				      short,
				      GDS_LONG,
				      GDS_LONG GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__send (GDS_STATUS GDS_FAR *, 
				 void GDS_FAR * GDS_FAR *, 
				 short,
				 short,
				 void GDS_FAR *,
				 short);

void       GDS_EXPORT gds__set_debug (int);

GDS_STATUS GDS_EXPORT gds__start_and_send (GDS_STATUS GDS_FAR *, 
					   void GDS_FAR * GDS_FAR *,
					   void GDS_FAR * GDS_FAR *,
					   short,
					   short,
					   void GDS_FAR *, 
					   short);

GDS_STATUS GDS_EXPORT gds__start_multiple (GDS_STATUS GDS_FAR *, 
					   void GDS_FAR * GDS_FAR *,
					   short,
					   void GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__start_request (GDS_STATUS GDS_FAR *,
					  void GDS_FAR * GDS_FAR *,
					  void GDS_FAR * GDS_FAR *,
					  short);

GDS_STATUS GDS_EXPORT gds__start_transaction (GDS_STATUS GDS_FAR *, 
					      void GDS_FAR * GDS_FAR *,
					      short, ...);

GDS_STATUS GDS_EXPORT gds__transaction_info (GDS_STATUS GDS_FAR *, 
					     void GDS_FAR * GDS_FAR *,
					     short,
					     char GDS_FAR *, 
					     short,
					     char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__unwind_request (GDS_STATUS GDS_FAR *, 
					   void GDS_FAR * GDS_FAR *,
					   short);

GDS_LONG   GDS_EXPORT gds__ftof (char GDS_FAR *,
				 unsigned short,
				 char GDS_FAR *,
				 unsigned short);

void       GDS_EXPORT gds__vtov (char GDS_FAR *, 
				 char GDS_FAR *, 
				 short);

int        GDS_EXPORT gds__version (void GDS_FAR * GDS_FAR *, 
				    void (GDS_FAR *)(), 
				    void GDS_FAR *);

int	   GDS_EXPORT gds__disable_subsystem (char GDS_FAR *);

int	   GDS_EXPORT gds__enable_subsystem (char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__print_status (GDS_STATUS GDS_FAR *);

GDS_LONG   GDS_EXPORT gds__sqlcode (GDS_STATUS GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__ddl (GDS_STATUS GDS_FAR *, 
				void GDS_FAR * GDS_FAR *,
				void GDS_FAR * GDS_FAR *,
				short,
				char GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__commit_retaining (GDS_STATUS GDS_FAR *, 
					     void GDS_FAR * GDS_FAR *);

void       GDS_EXPORT gds__encode_date (void GDS_FAR *, 
					GDS__QUAD GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__que_events (GDS_STATUS GDS_FAR *,
				       void GDS_FAR * GDS_FAR *, 
				       GDS_LONG GDS_FAR *,
				       short,
				       char GDS_FAR *,
				       void (GDS_FAR *)(), 
				       void GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__cancel_events (GDS_STATUS GDS_FAR *, 
					  void GDS_FAR * GDS_FAR *,
					  GDS_LONG GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__event_wait (GDS_STATUS GDS_FAR *, 
				       void GDS_FAR * GDS_FAR *, 
				       short,
				       char GDS_FAR *,
				       char GDS_FAR *);

void       GDS_EXPORT gds__event_counts (unsigned GDS_LONG GDS_FAR *,
					 short,
					 char GDS_FAR *,
					 char GDS_FAR *);

GDS_LONG   GDS_EXPORT gds__event_block (char GDS_FAR * GDS_FAR *, 
					char GDS_FAR * GDS_FAR *,
					unsigned short, ...);

GDS_STATUS GDS_EXPORT gds__get_slice (GDS_STATUS GDS_FAR *, 
				      void GDS_FAR * GDS_FAR *, 
				      void GDS_FAR * GDS_FAR *,
				      GDS__QUAD GDS_FAR *, 
				      short,
				      char GDS_FAR *, 
				      short, 
				      GDS_LONG GDS_FAR *,
				      GDS_LONG, 
				      void GDS_FAR *,
				      GDS_LONG GDS_FAR *);

GDS_STATUS GDS_EXPORT gds__put_slice (GDS_STATUS GDS_FAR *, 
				      void GDS_FAR * GDS_FAR *, 
				      void GDS_FAR * GDS_FAR *,
				      GDS__QUAD GDS_FAR *, 
				      short, 
				      char GDS_FAR *, 
				      short, 
				      GDS_LONG GDS_FAR *,
				      GDS_LONG, 
				      void GDS_FAR *);

void       GDS_EXPORT gds__vtof (char GDS_FAR *, 
				 char GDS_FAR *, 
				 unsigned short);

#else					/* __STDC__ && !apollo */


#ifndef _Windows
#ifndef _WINDOWS
GDS_TYPE  GDS_EXPORT gds__attach_database();
GDS_TYPE  GDS_EXPORT gds__blob_info();
GDS_TYPE  GDS_EXPORT gds__cancel_blob();
GDS_TYPE  GDS_EXPORT gds__close_blob();
GDS_TYPE  GDS_EXPORT gds__commit_transaction();
GDS_TYPE  GDS_EXPORT gds__compile_request();
GDS_TYPE  GDS_EXPORT gds__compile_request2();
GDS_TYPE  GDS_EXPORT gds__create_blob();
GDS_TYPE  GDS_EXPORT gds__create_blob2();
GDS_TYPE  GDS_EXPORT gds__create_database();
GDS_TYPE  GDS_EXPORT gds__database_info();
GDS_TYPE  GDS_EXPORT gds__detach_database();
GDS_TYPE  GDS_EXPORT gds__get_segment();
GDS_TYPE  GDS_EXPORT gds__open_blob();
GDS_TYPE  GDS_EXPORT gds__open_blob2();
GDS_TYPE  GDS_EXPORT gds__prepare_transaction();
GDS_TYPE  GDS_EXPORT gds__prepare_transaction2();
GDS_TYPE  GDS_EXPORT gds__put_segment();
GDS_TYPE  GDS_EXPORT gds__receive();
GDS_TYPE  GDS_EXPORT gds__reconnect_transaction();
GDS_TYPE  GDS_EXPORT gds__request_info();
GDS_TYPE  GDS_EXPORT gds__release_request();
GDS_TYPE  GDS_EXPORT gds__rollback_transaction();
GDS_TYPE  GDS_EXPORT gds__seek_blob();
GDS_TYPE  GDS_EXPORT gds__send();
GDS_TYPE  GDS_EXPORT gds__start_and_send();
GDS_TYPE  GDS_EXPORT gds__start_multiple();
GDS_TYPE  GDS_EXPORT gds__start_request();
GDS_TYPE  GDS_EXPORT gds__start_transaction();
GDS_TYPE  GDS_EXPORT gds__transaction_info();
GDS_TYPE  GDS_EXPORT gds__unwind_request();
GDS_TYPE  GDS_EXPORT gds__ftof();
GDS_TYPE  GDS_EXPORT gds__print_status();
GDS_TYPE  GDS_EXPORT gds__sqlcode();
GDS_TYPE  GDS_EXPORT gds__ddl();
GDS_TYPE  GDS_EXPORT gds__commit_retaining();
GDS_TYPE  GDS_EXPORT gds__que_events();
GDS_TYPE  GDS_EXPORT gds__cancel_events();
GDS_TYPE  GDS_EXPORT gds__event_wait();
GDS_TYPE  GDS_EXPORT gds__event_block();
GDS_TYPE  GDS_EXPORT gds__get_slice();
GDS_TYPE  GDS_EXPORT gds__put_slice();
GDS_TYPE  GDS_EXPORT gds__seek_blob();

void 	  GDS_EXPORT gds__event_counts();
void 	  GDS_EXPORT gds__set_debug();
void      GDS_EXPORT gds__vtof();


#endif					/* _WINDOWS */

#endif					/* _Windows */

#endif					/* __STDC__ && !apollo */

#endif					/* __cplusplus */

#endif					/* NO_OSRI_ENTRYPOINTS */



/**********************************/
/* Database parameter block stuff */
/**********************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dpb_version1                  1
#define gds__dpb_cdd_pathname              1
#define gds__dpb_allocation                2
#define gds__dpb_journal                   3
#define gds__dpb_page_size                 4
#define gds__dpb_num_buffers               5
#define gds__dpb_buffer_length             6
#define gds__dpb_debug                     7
#define gds__dpb_garbage_collect           8
#define gds__dpb_verify                    9
#define gds__dpb_sweep                     10
#define gds__dpb_enable_journal            11
#define gds__dpb_disable_journal           12
#define gds__dpb_dbkey_scope               13
#define gds__dpb_number_of_users           14
#define gds__dpb_trace                     15
#define gds__dpb_no_garbage_collect        16
#define gds__dpb_damaged                   17
#define gds__dpb_license                   18
#define gds__dpb_sys_user_name             19
#define gds__dpb_encrypt_key               20
#define gds__dpb_activate_shadow           21
#define gds__dpb_sweep_interval            22
#define gds__dpb_delete_shadow             23
#define gds__dpb_force_write               24
#define gds__dpb_begin_log                 25
#define gds__dpb_quit_log                  26
#define gds__dpb_no_reserve                27
#define gds__dpb_user_name                 28
#define gds__dpb_password                  29
#define gds__dpb_password_enc              30
#define gds__dpb_sys_user_name_enc         31
#define gds__dpb_interp                    32
#define gds__dpb_online_dump               33
#define gds__dpb_old_file_size             34
#define gds__dpb_old_num_files             35
#define gds__dpb_old_file                  36
#define gds__dpb_old_start_page            37
#define gds__dpb_old_start_seqno           38
#define gds__dpb_old_start_file            39
#define gds__dpb_drop_walfile              40
#define gds__dpb_old_dump_id               41
#define gds__dpb_wal_backup_dir            42
#define gds__dpb_wal_chkptlen              43
#define gds__dpb_wal_numbufs               44
#define gds__dpb_wal_bufsize               45
#define gds__dpb_wal_grp_cmt_wait          46
#define gds__dpb_lc_messages               47
#define gds__dpb_lc_ctype                  48
#define gds__dpb_cache_manager		   49
#define gds__dpb_shutdown		   50
#define gds__dpb_online			   51
#define gds__dpb_shutdown_delay		   52
#define gds__dpb_reserved		   53
#define gds__dpb_overwrite		   54
#define gds__dpb_sec_attach		   55
#define gds__dpb_disable_wal		   56
#define gds__dpb_connect_timeout	   57
#define gds__dpb_dummy_packet_interval     58

#else					/* c++ definitions */

const char gds_dpb_version1                = 1;
const char gds_dpb_cdd_pathname            = 1;
const char gds_dpb_allocation              = 2;
const char gds_dpb_journal                 = 3;
const char gds_dpb_page_size               = 4;
const char gds_dpb_num_buffers             = 5;
const char gds_dpb_buffer_length           = 6;
const char gds_dpb_debug                   = 7;
const char gds_dpb_garbage_collect         = 8;
const char gds_dpb_verify                  = 9;
const char gds_dpb_sweep                   = 10;
const char gds_dpb_enable_journal          = 11;
const char gds_dpb_disable_journal         = 12;
const char gds_dpb_dbkey_scope             = 13;
const char gds_dpb_number_of_users         = 14;
const char gds_dpb_trace                   = 15;
const char gds_dpb_no_garbage_collect      = 16;
const char gds_dpb_damaged                 = 17;
const char gds_dpb_license                 = 18;
const char gds_dpb_sys_user_name           = 19;
const char gds_dpb_encrypt_key             = 20;
const char gds_dpb_activate_shadow         = 21;
const char gds_dpb_sweep_interval          = 22;
const char gds_dpb_delete_shadow           = 23;
const char gds_dpb_force_write             = 24;
const char gds_dpb_begin_log               = 25;
const char gds_dpb_quit_log                = 26;
const char gds_dpb_no_reserve              = 27;
const char gds_dpb_user_name               = 28;
const char gds_dpb_password                = 29;
const char gds_dpb_password_enc            = 30;
const char gds_dpb_sys_user_name_enc       = 31;
const char gds_dpb_interp                  = 32;
const char gds_dpb_online_dump             = 33;
const char gds_dpb_old_file_size           = 34;
const char gds_dpb_old_num_files           = 35;
const char gds_dpb_old_file                = 36;
const char gds_dpb_old_start_page          = 37;
const char gds_dpb_old_start_seqno         = 38;
const char gds_dpb_old_start_file          = 39;
const char gds_dpb_drop_walfile            = 40;
const char gds_dpb_old_dump_id             = 41;
const char gds_dpb_wal_backup_dir          = 42;
const char gds_dpb_wal_chkptlen            = 43;
const char gds_dpb_wal_numbufs             = 44;
const char gds_dpb_wal_bufsize             = 45;
const char gds_dpb_wal_grp_cmt_wait        = 46;
const char gds_dpb_lc_messages             = 47;
const char gds_dpb_lc_ctype                = 48;
const char gds_dpb_cache_manager	   = 49;
const char gds_dpb_shutdown		   = 50;
const char gds_dpb_online		   = 51;
const char gds_dpb_shutdown_delay	   = 52;
const char gds_dpb_reserved		   = 53;
const char gds_dpb_overwrite		   = 54;
const char gds_dpb_sec_attach		   = 55;
const char gds_dpb_disable_wal		   = 56;
const char gds_dpb_connect_timeout         = 57;
const char gds_dpb_dummy_packet_interval   = 58;

#endif


/**********************************/
/* gds__dpb_verify specific flags */
/**********************************/


#ifndef	__cplusplus			/* c definitions */

#define gds__dpb_pages                     1
#define gds__dpb_records                   2
#define gds__dpb_indices                   4
#define gds__dpb_transactions              8
#define gds__dpb_no_update                 16
#define gds__dpb_repair                    32
#define gds__dpb_ignore                    64

#else					/* c++ definitions */

const char gds_dpb_pages                   = 1;
const char gds_dpb_records                 = 2;
const char gds_dpb_indices                 = 4;
const char gds_dpb_transactions            = 8;
const char gds_dpb_no_update               = 16;
const char gds_dpb_repair                  = 32;
const char gds_dpb_ignore                  = 64;

#endif

/************************************/
/* gds__dpb_shutdown specific flags */
/************************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dpb_shut_cache               1
#define gds__dpb_shut_attachment          2
#define gds__dpb_shut_transaction         4
#define gds__dpb_shut_force               8

#else					/* c++ definitions */

const char gds_dpb_shut_cache             = 1;
const char gds_dpb_shut_attachment        = 2;
const char gds_dpb_shut_transaction       = 4;
const char gds_dpb_shut_force             = 8;

#endif


/*************************************/
/* Transaction parameter block stuff */
/*************************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__tpb_version1                  1
#define gds__tpb_version3                  3
#define gds__tpb_consistency               1
#define gds__tpb_concurrency               2
#define gds__tpb_shared                    3
#define gds__tpb_protected                 4
#define gds__tpb_exclusive                 5
#define gds__tpb_wait                      6
#define gds__tpb_nowait                    7
#define gds__tpb_read                      8
#define gds__tpb_write                     9
#define gds__tpb_lock_read                 10
#define gds__tpb_lock_write                11
#define gds__tpb_verb_time                 12
#define gds__tpb_commit_time               13
#define gds__tpb_ignore_limbo              14
#define gds__tpb_read_committed		   15
#define gds__tpb_autocommit		   16
#define gds__tpb_rec_version		   17
#define gds__tpb_no_rec_version		   18
#define gds__tpb_restart_requests	   19
#define gds__tpb_no_auto_undo              20

#else					/* c++ definitions */

const char gds_tpb_version1                = 1;
const char gds_tpb_version3                = 3;
const char gds_tpb_consistency             = 1;
const char gds_tpb_concurrency             = 2;
const char gds_tpb_shared                  = 3;
const char gds_tpb_protected               = 4;
const char gds_tpb_exclusive               = 5;
const char gds_tpb_wait                    = 6;
const char gds_tpb_nowait                  = 7;
const char gds_tpb_read                    = 8;
const char gds_tpb_write                   = 9;
const char gds_tpb_lock_read               = 10;
const char gds_tpb_lock_write              = 11;
const char gds_tpb_verb_time               = 12;
const char gds_tpb_commit_time             = 13;
const char gds_tpb_ignore_limbo            = 14;
const char gds_tpb_read_committed	   = 15;
const char gds_tpb_autocommit		   = 16;
const char gds_tpb_rec_version		   = 17;
const char gds_tpb_no_rec_version	   = 18;
const char gds_tpb_restart_requests	   = 19;
const char gds_tpb_no_auto_undo		   = 20;

#endif



/************************/
/* Blob Parameter Block */
/************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__bpb_version1                  1
#define gds__bpb_source_type               1
#define gds__bpb_target_type               2
#define gds__bpb_type                      3
#define gds__bpb_source_interp             4
#define gds__bpb_target_interp             5

#else					/* c++ definitions */

const char gds_bpb_version1                = 1;
const char gds_bpb_source_type             = 1;
const char gds_bpb_target_type             = 2;
const char gds_bpb_type                    = 3;
const char gds_bpb_source_interp           = 4;
const char gds_bpb_target_interp           = 5;

#endif


#ifndef	__cplusplus			/* c definitions */

#define gds__bpb_type_segmented            0
#define gds__bpb_type_stream               1

#else					/* c++ definitions */

const char gds_bpb_type_segmented          = 0;
const char gds_bpb_type_stream             = 1;

#endif


/*********************************/
/* Service parameter block stuff */
/*********************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__spb_version1                  1
#define gds__spb_user_name                 2
#define gds__spb_sys_user_name             3
#define gds__spb_sys_user_name_enc         4
#define gds__spb_password                  5
#define gds__spb_password_enc              6
#define gds__spb_command_line              7
#define gds__spb_connect_timeout           8
#define gds__spb_dummy_packet_interval     9

#else					/* c++ definitions */

const char gds_spb_version1                = 1;
const char gds_spb_user_name               = 2;
const char gds_spb_sys_user_name           = 3;
const char gds_spb_sys_user_name_enc       = 4;
const char gds_spb_password                = 5;
const char gds_spb_password_enc            = 6;
const char gds_spb_command_line            = 7;
const char gds_spb_connect_timeout         = 8;
const char gds_spb_dummy_packet_interval   = 9;

#endif




/*********************************/
/* Information call declarations */
/*********************************/

/****************************/
/* Common, structural codes */
/****************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__info_end                      1
#define gds__info_truncated                2
#define gds__info_error                    3

#else					/* c++ definitions */

const char gds_info_end                    = 1;
const char gds_info_truncated              = 2;
const char gds_info_error                  = 3;

#endif



/******************************/
/* Database information items */
/******************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__info_db_id                    4
#define gds__info_reads                    5
#define gds__info_writes                   6
#define gds__info_fetches                  7
#define gds__info_marks                    8
#define gds__info_implementation           11
#define gds__info_version                  12
#define gds__info_base_level               13
#define gds__info_page_size                14
#define gds__info_num_buffers              15
#define gds__info_limbo                    16
#define gds__info_current_memory           17
#define gds__info_max_memory               18
#define gds__info_window_turns             19
#define gds__info_license                  20
#define gds__info_allocation               21
#define gds__info_attachment_id            22
#define gds__info_read_seq_count           23
#define gds__info_read_idx_count           24
#define gds__info_insert_count             25
#define gds__info_update_count             26
#define gds__info_delete_count             27
#define gds__info_backout_count            28
#define gds__info_purge_count              29
#define gds__info_expunge_count            30
#define gds__info_sweep_interval           31
#define gds__info_ods_version              32
#define gds__info_ods_minor_version        33
#define gds__info_no_reserve               34
#define gds__info_logfile                  35
#define gds__info_cur_logfile_name         36
#define gds__info_cur_log_part_offset      37
#define gds__info_num_wal_buffers          38
#define gds__info_wal_buffer_size          39
#define gds__info_wal_ckpt_length          40
#define gds__info_wal_cur_ckpt_interval    41
#define gds__info_wal_prv_ckpt_fname       42
#define gds__info_wal_prv_ckpt_poffset     43
#define gds__info_wal_recv_ckpt_fname      44
#define gds__info_wal_recv_ckpt_poffset    45
#define gds__info_wal_grpc_wait_usecs      47
#define gds__info_wal_num_io               48
#define gds__info_wal_avg_io_size          49
#define gds__info_wal_num_commits          50
#define gds__info_wal_avg_grpc_size        51
#define gds__info_forced_writes		   52

#else					/* c++ definitions */

const char gds_info_db_id                  = 4;
const char gds_info_reads                  = 5;
const char gds_info_writes                 = 6;
const char gds_info_fetches                = 7;
const char gds_info_marks                  = 8;
const char gds_info_implementation         = 11;
const char gds_info_version                = 12;
const char gds_info_base_level             = 13;
const char gds_info_page_size              = 14;
const char gds_info_num_buffers            = 15;
const char gds_info_limbo                  = 16;
const char gds_info_current_memory         = 17;
const char gds_info_max_memory             = 18;
const char gds_info_window_turns           = 19;
const char gds_info_license                = 20;
const char gds_info_allocation             = 21;
const char gds_info_attachment_id          = 22;
const char gds_info_read_seq_count         = 23;
const char gds_info_read_idx_count         = 24;
const char gds_info_insert_count           = 25;
const char gds_info_update_count           = 26;
const char gds_info_delete_count           = 27;
const char gds_info_backout_count          = 28;
const char gds_info_purge_count            = 29;
const char gds_info_expunge_count          = 30;
const char gds_info_sweep_interval         = 31;
const char gds_info_ods_version            = 32;
const char gds_info_ods_minor_version      = 33;
const char gds_info_no_reserve             = 34;
const char gds_info_logfile                = 35;
const char gds_info_cur_logfile_name       = 36;
const char gds_info_cur_log_part_offset    = 37;
const char gds_info_num_wal_buffers        = 38;
const char gds_info_wal_buffer_size        = 39;
const char gds_info_wal_ckpt_length        = 40;
const char gds_info_wal_cur_ckpt_interval  = 41;
const char gds_info_wal_prv_ckpt_fname     = 42;
const char gds_info_wal_prv_ckpt_poffset   = 43;
const char gds_info_wal_recv_ckpt_fname    = 44;
const char gds_info_wal_recv_ckpt_poffset  = 45;
const char gds_info_wal_grpc_wait_usecs    = 47;
const char gds_info_wal_num_io             = 48;
const char gds_info_wal_avg_io_size        = 49;
const char gds_info_wal_num_commits        = 50;
const char gds_info_wal_avg_grpc_size      = 51;
const char gds_info_forced_writes	   = 52;

#endif


/**************************************/
/* Database information return values */
/**************************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__info_db_impl_rdb_vms          1
#define gds__info_db_impl_rdb_eln          2
#define gds__info_db_impl_rdb_eln_dev      3
#define gds__info_db_impl_rdb_vms_y        4
#define gds__info_db_impl_rdb_eln_y        5
#define gds__info_db_impl_jri              6
#define gds__info_db_impl_jsv              7
#define gds__info_db_impl_isc_a            25
#define gds__info_db_impl_isc_u            26
#define gds__info_db_impl_isc_v            27
#define gds__info_db_impl_isc_s            28
#define gds__info_db_impl_isc_apl_68K      25
#define gds__info_db_impl_isc_vax_ultr     26
#define gds__info_db_impl_isc_vms          27
#define gds__info_db_impl_isc_sun_68k      28
#define gds__info_db_impl_isc_os2          29
#define gds__info_db_impl_isc_sun4         30
#define gds__info_db_impl_isc_hp_ux        31
#define gds__info_db_impl_isc_sun_386i     32
#define gds__info_db_impl_isc_vms_orcl     33
#define gds__info_db_impl_isc_mac_aux      34
#define gds__info_db_impl_isc_rt_aix       35
#define gds__info_db_impl_isc_mips_ult     36
#define gds__info_db_impl_isc_xenix        37
#define gds__info_db_impl_isc_dg           38
#define gds__info_db_impl_isc_hp_mpexl     39
#define gds__info_db_impl_isc_hp_ux68K     40
#define gds__info_db_impl_isc_sgi          41
#define gds__info_db_impl_isc_sco_unix     42
#define gds__info_db_impl_isc_cray         43
#define gds__info_db_impl_isc_imp          44
#define gds__info_db_impl_isc_delta        45
#define gds__info_db_impl_isc_next         46
#define gds__info_db_impl_isc_dos          47
#define gds__info_db_impl_isc_winnt        48
#define gds__info_db_impl_isc_epson        49

#define gds__info_db_class_access          1
#define gds__info_db_class_y_valve         2
#define gds__info_db_class_rem_int         3
#define gds__info_db_class_rem_srvr        4
#define gds__info_db_class_pipe_int        7
#define gds__info_db_class_pipe_srvr       8
#define gds__info_db_class_sam_int         9
#define gds__info_db_class_sam_srvr        10
#define gds__info_db_class_gateway         11
#define gds__info_db_class_cache           12

#else					/* c++ definitions */

const char gds_info_db_impl_rdb_vms        = 1;
const char gds_info_db_impl_rdb_eln        = 2;
const char gds_info_db_impl_rdb_eln_dev    = 3;
const char gds_info_db_impl_rdb_vms_y      = 4;
const char gds_info_db_impl_rdb_eln_y      = 5;
const char gds_info_db_impl_jri            = 6;
const char gds_info_db_impl_jsv            = 7;
const char gds_info_db_impl_isc_a          = 25;
const char gds_info_db_impl_isc_u          = 26;
const char gds_info_db_impl_isc_v          = 27;
const char gds_info_db_impl_isc_s          = 28;
const char gds_info_db_impl_isc_apl_68K    = 25;
const char gds_info_db_impl_isc_vax_ultr   = 26;
const char gds_info_db_impl_isc_vms        = 27;
const char gds_info_db_impl_isc_sun_68k    = 28;
const char gds_info_db_impl_isc_os2        = 29;
const char gds_info_db_impl_isc_sun4       = 30;
const char gds_info_db_impl_isc_hp_ux      = 31;
const char gds_info_db_impl_isc_sun_386i   = 32;
const char gds_info_db_impl_isc_vms_orcl   = 33;
const char gds_info_db_impl_isc_mac_aux    = 34;
const char gds_info_db_impl_isc_rt_aix     = 35;
const char gds_info_db_impl_isc_mips_ult   = 36;
const char gds_info_db_impl_isc_xenix      = 37;
const char gds_info_db_impl_isc_dg         = 38;
const char gds_info_db_impl_isc_hp_mpexl   = 39;
const char gds_info_db_impl_isc_hp_ux68K   = 40;
const char gds_info_db_impl_isc_sgi        = 41;
const char gds_info_db_impl_isc_sco_unix   = 42;
const char gds_info_db_impl_isc_cray       = 43;
const char gds_info_db_impl_isc_imp        = 44;
const char gds_info_db_impl_isc_delta      = 45;
const char gds_info_db_impl_isc_next       = 46;
const char gds_info_db_impl_isc_dos        = 47;
const char gds_info_db_impl_isc_winnt      = 48;
const char gds_info_db_impl_isc_epson      = 49;

const char gds_info_db_class_access        = 1;
const char gds_info_db_class_y_valve       = 2;
const char gds_info_db_class_rem_int       = 3;
const char gds_info_db_class_rem_srvr      = 4;
const char gds_info_db_class_pipe_int      = 7;
const char gds_info_db_class_pipe_srvr     = 8;
const char gds_info_db_class_sam_int       = 9;
const char gds_info_db_class_sam_srvr      = 10;
const char gds_info_db_class_gateway       = 11;
const char gds_info_db_class_cache         = 12;

#endif

 


/*****************************/
/* Request information items */
/*****************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__info_number_messages          4
#define gds__info_max_message              5
#define gds__info_max_send                 6
#define gds__info_max_receive              7
#define gds__info_state                    8
#define gds__info_message_number           9
#define gds__info_message_size             10
#define gds__info_request_cost             11
#define gds__info_access_path              12
#define gds__info_req_select_count         13
#define gds__info_req_insert_count         14
#define gds__info_req_update_count         15
#define gds__info_req_delete_count         16

/*********************/
/* access path items */
/*********************/

#define gds__info_rsb_end		   0
#define gds__info_rsb_begin		   1
#define gds__info_rsb_type		   2
#define gds__info_rsb_relation		   3
#define gds__info_rsb_plan                 4

/*************/
/* rsb types */
/*************/

#define gds__info_rsb_unknown		   1
#define gds__info_rsb_indexed		   2
#define gds__info_rsb_navigate		   3
#define gds__info_rsb_sequential	   4
#define gds__info_rsb_cross		   5
#define gds__info_rsb_sort		   6
#define gds__info_rsb_first		   7
#define gds__info_rsb_boolean		   8
#define gds__info_rsb_union		   9
#define gds__info_rsb_aggregate		  10
#define gds__info_rsb_merge		  11
#define gds__info_rsb_ext_sequential	  12
#define gds__info_rsb_ext_indexed	  13
#define gds__info_rsb_ext_dbkey		  14
#define gds__info_rsb_left_cross	  15
#define gds__info_rsb_select		  16
#define gds__info_rsb_sql_join		  17
#define gds__info_rsb_simulate		  18
#define gds__info_rsb_sim_cross		  19
#define gds__info_rsb_once		  20
#define gds__info_rsb_procedure		  21
#define gds__info_rsb_skip		  22

/**********************/
/* bitmap expressions */
/**********************/

#define gds__info_rsb_and		1
#define gds__info_rsb_or		2
#define gds__info_rsb_dbkey		3
#define gds__info_rsb_index		4

#define gds__info_req_active               2
#define gds__info_req_inactive             3
#define gds__info_req_send                 4
#define gds__info_req_receive              5
#define gds__info_req_select               6

#else					/* c++ definitions */

const char gds_info_number_messages        = 4;
const char gds_info_max_message            = 5;
const char gds_info_max_send               = 6;
const char gds_info_max_receive            = 7;
const char gds_info_state                  = 8;
const char gds_info_message_number         = 9;
const char gds_info_message_size           = 10;
const char gds_info_request_cost           = 11;
const char gds_info_access_path            = 12;
const char gds_info_req_select_count       = 13;
const char gds_info_req_insert_count       = 14;
const char gds_info_req_update_count       = 15;
const char gds_info_req_delete_count       = 16;

/*********************/
/* access path items */
/*********************/

const char gds_info_rsb_end		   = 0;
const char gds_info_rsb_begin		   = 1;
const char gds_info_rsb_type		   = 2;
const char gds_info_rsb_relation	   = 3;


/*************/
/* rsb types */
/*************/

const char gds_info_rsb_unknown		   = 1;
const char gds_info_rsb_indexed		   = 2;
const char gds_info_rsb_navigate	   = 3;
const char gds_info_rsb_sequential	   = 4;
const char gds_info_rsb_cross		   = 5;
const char gds_info_rsb_sort		   = 6;
const char gds_info_rsb_first		   = 7;
const char gds_info_rsb_boolean		   = 8;
const char gds_info_rsb_union		   = 9;
const char gds_info_rsb_aggregate	   = 10;
const char gds_info_rsb_merge		   = 11;
const char gds_info_rsb_ext_sequential	   = 12;
const char gds_info_rsb_ext_indexed	   = 13;
const char gds_info_rsb_ext_dbkey	   = 14;
const char gds_info_rsb_left_cross	   = 15;
const char gds_info_rsb_select		   = 16;
const char gds_info_rsb_sql_join	   = 17;
const char gds_info_rsb_simulate	   = 18;
const char gds_info_rsb_sim_cross	   = 19;
const char gds_info_rsb_once		   = 20;
const char gds_info_rsb_procedure	   = 21;
const char gds_info_rsb_first		   = 22;

/**********************/
/* bitmap expressions */
/**********************/

const char gds_info_rsb_and		   = 1;
const char gds_info_rsb_or		   = 2;
const char gds_info_rsb_dbkey 		   = 3;
const char gds_info_rsb_index    	   = 4;

const char gds_info_req_active             = 2;
const char gds_info_req_inactive           = 3;
const char gds_info_req_send               = 4;
const char gds_info_req_receive            = 5;
const char gds_info_req_select             = 6;

#endif


/**************************/
/* Blob information items */
/**************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__info_blob_num_segments        4
#define gds__info_blob_max_segment         5
#define gds__info_blob_total_length        6
#define gds__info_blob_type                7

#else					/* c++ definitions */

const char gds_info_blob_num_segments      = 4;
const char gds_info_blob_max_segment       = 5;
const char gds_info_blob_total_length      = 6;
const char gds_info_blob_type              = 7;

#endif



/*********************************/
/* Transaction information items */
/*********************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__info_tra_id                   4

#else					/* c++ definitions */

const char gds_info_tra_id                 = 4;

#endif


/*****************************/
/* Service information items */
/*****************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__info_svc_version              4
#define gds__info_svc_message              5
#define gds__info_svc_total_length         6
#define gds__info_svc_response             7
#define gds__info_svc_response_more        8
#define gds__info_svc_line                 9
#define gds__info_svc_to_eof               10
#define gds__info_svc_timeout              11

#else					/* c++ definitions */

const char gds_info_svc_version            = 4;
const char gds_info_svc_message            = 5;
const char gds_info_svc_total_length       = 6;
const char gds_info_svc_response           = 7;
const char gds_info_svc_response_more      = 8;
const char gds_info_svc_line               = 9;
const char gds_info_svc_to_eof             = 10;
const char gds_info_svc_timeout            = 11;

#endif

/*************************/
/* SQL information items */
/*************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__info_sql_select               4
#define gds__info_sql_bind                 5
#define gds__info_sql_num_variables        6
#define gds__info_sql_describe_vars        7
#define gds__info_sql_describe_end         8
#define gds__info_sql_sqlda_seq            9
#define gds__info_sql_message_seq          10
#define gds__info_sql_type                 11
#define gds__info_sql_sub_type             12
#define gds__info_sql_scale                13
#define gds__info_sql_length               14
#define gds__info_sql_null_ind             15
#define gds__info_sql_field                16
#define gds__info_sql_relation             17
#define gds__info_sql_owner                18
#define gds__info_sql_alias                19
#define gds__info_sql_sqlda_start          20
#define gds__info_sql_stmt_type            21
#define gds__info_sql_get_plan             22
#define gds__info_sql_records		   23

#else					/* c++ definitions */

const char gds_info_sql_select             = 4;
const char gds_info_sql_bind               = 5;
const char gds_info_sql_num_variables      = 6;
const char gds_info_sql_describe_vars      = 7;
const char gds_info_sql_describe_end       = 8;
const char gds_info_sql_sqlda_seq          = 9;
const char gds_info_sql_message_seq        = 10;
const char gds_info_sql_type               = 11;
const char gds_info_sql_sub_type           = 12;
const char gds_info_sql_scale              = 13;
const char gds_info_sql_length             = 14;
const char gds_info_sql_null_ind           = 15;
const char gds_info_sql_field              = 16;
const char gds_info_sql_relation           = 17;
const char gds_info_sql_owner              = 18;
const char gds_info_sql_alias              = 19;
const char gds_info_sql_sqlda_start        = 20;
const char gds_info_sql_stmt_type          = 21;
const char gds_info_sql_get_plan           = 22;
const char gds_info_sql_records		   = 23;

#endif



/*********************************/
/* SQL information return values */
/*********************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__info_sql_stmt_select          1
#define gds__info_sql_stmt_insert          2
#define gds__info_sql_stmt_update          3
#define gds__info_sql_stmt_delete          4
#define gds__info_sql_stmt_ddl             5
#define gds__info_sql_stmt_get_segment     6
#define gds__info_sql_stmt_put_segment     7
#define gds__info_sql_stmt_exec_procedure  8
#define gds__info_sql_stmt_start_trans     9
#define gds__info_sql_stmt_commit          10
#define gds__info_sql_stmt_rollback        11
#define gds__info_sql_stmt_select_for_upd  12

#else					/* c++ definitions */

const char gds_info_sql_stmt_select        = 1;
const char gds_info_sql_stmt_insert        = 2;
const char gds_info_sql_stmt_update        = 3;
const char gds_info_sql_stmt_delete        = 4;
const char gds_info_sql_stmt_ddl           = 5;
const char gds_info_sql_stmt_get_segment   = 6;
const char gds_info_sql_stmt_put_segment   = 7;
const char gds_info_sql_stmt_exec_procedure = 8;
const char gds_info_sql_stmt_start_trans   = 9;
const char gds_info_sql_stmt_commit        = 10;
const char gds_info_sql_stmt_rollback      = 11;
const char gds_info_sql_stmt_select_for_upd = 12;

#endif

/***************/
/* Error codes */
/***************/

#ifndef	__cplusplus			/* c definitions */

#define gds_facility                       20
#define gds_err_base                       335544320L
#define gds_err_factor                     1
#define gds_arg_end                        0
#define gds_arg_gds                        1
#define gds_arg_string                     2
#define gds_arg_cstring                    3
#define gds_arg_number                     4
#define gds_arg_interpreted                5
#define gds_arg_vms                        6
#define gds_arg_unix                       7
#define gds_arg_domain                     8
#define gds_arg_dos                        9
#define gds_arg_mpexl                      10
#define gds_arg_mpexl_ipc                  11
#define gds_arg_next_mach		   15
#define gds_arg_netware		           16
#define gds_arg_win32                      17

#else					/* c++ definitions */

const GDS_LONG gds_facility                    = 20;
const GDS_LONG gds_err_base                    = 335544320L;
const GDS_LONG gds_err_factor                  = 1;
const GDS_LONG gds_arg_end                     = 0;
const GDS_LONG gds_arg_gds                     = 1;
const GDS_LONG gds_arg_string                  = 2;
const GDS_LONG gds_arg_cstring                 = 3;
const GDS_LONG gds_arg_number                  = 4;
const GDS_LONG gds_arg_interpreted             = 5;
const GDS_LONG gds_arg_vms                     = 6;
const GDS_LONG gds_arg_unix                    = 7;
const GDS_LONG gds_arg_domain                  = 8;
const GDS_LONG gds_arg_dos                     = 9;
const GDS_LONG gds_arg_mpexl                   = 10;
const GDS_LONG gds_arg_mpexl_ipc               = 11;
const GDS_LONG gds_arg_next_mach               = 15;
const GDS_LONG gds_arg_netware                 = 16;
const GDS_LONG gds_arg_win32                   = 17;

#endif

#ifndef	__cplusplus			/* c definitions */

#define gds__arith_except                  335544321L
#define gds__bad_dbkey                     335544322L
#define gds__bad_db_format                 335544323L
#define gds__bad_db_handle                 335544324L
#define gds__bad_dpb_content               335544325L
#define gds__bad_dpb_form                  335544326L
#define gds__bad_req_handle                335544327L
#define gds__bad_segstr_handle             335544328L
#define gds__bad_segstr_id                 335544329L
#define gds__bad_tpb_content               335544330L
#define gds__bad_tpb_form                  335544331L
#define gds__bad_trans_handle              335544332L
#define gds__bug_check                     335544333L
#define gds__convert_error                 335544334L
#define gds__db_corrupt                    335544335L
#define gds__deadlock                      335544336L
#define gds__excess_trans                  335544337L
#define gds__from_no_match                 335544338L
#define gds__infinap                       335544339L
#define gds__infona                        335544340L
#define gds__infunk                        335544341L
#define gds__integ_fail                    335544342L
#define gds__invalid_blr                   335544343L
#define gds__io_error                      335544344L
#define gds__lock_conflict                 335544345L
#define gds__metadata_corrupt              335544346L
#define gds__not_valid                     335544347L
#define gds__no_cur_rec                    335544348L
#define gds__no_dup                        335544349L
#define gds__no_finish                     335544350L
#define gds__no_meta_update                335544351L
#define gds__no_priv                       335544352L
#define gds__no_recon                      335544353L
#define gds__no_record                     335544354L
#define gds__no_segstr_close               335544355L
#define gds__obsolete_metadata             335544356L
#define gds__open_trans                    335544357L
#define gds__port_len                      335544358L
#define gds__read_only_field               335544359L
#define gds__read_only_rel                 335544360L
#define gds__read_only_trans               335544361L
#define gds__read_only_view                335544362L
#define gds__req_no_trans                  335544363L
#define gds__req_sync                      335544364L
#define gds__req_wrong_db                  335544365L
#define gds__segment                       335544366L
#define gds__segstr_eof                    335544367L
#define gds__segstr_no_op                  335544368L
#define gds__segstr_no_read                335544369L
#define gds__segstr_no_trans               335544370L
#define gds__segstr_no_write               335544371L
#define gds__segstr_wrong_db               335544372L
#define gds__sys_request                   335544373L
#define gds__stream_eof                    335544374L
#define gds__unavailable                   335544375L
#define gds__unres_rel                     335544376L
#define gds__uns_ext                       335544377L
#define gds__wish_list                     335544378L
#define gds__wrong_ods                     335544379L
#define gds__wronumarg                     335544380L
#define gds__imp_exc                       335544381L
#define gds__random                        335544382L
#define gds__fatal_conflict                335544383L
#define gds__badblk                        335544384L
#define gds__invpoolcl                     335544385L
#define gds__nopoolids                     335544386L
#define gds__relbadblk                     335544387L
#define gds__blktoobig                     335544388L
#define gds__bufexh                        335544389L
#define gds__syntaxerr                     335544390L
#define gds__bufinuse                      335544391L
#define gds__bdbincon                      335544392L
#define gds__reqinuse                      335544393L
#define gds__badodsver                     335544394L
#define gds__relnotdef                     335544395L
#define gds__fldnotdef                     335544396L
#define gds__dirtypage                     335544397L
#define gds__waifortra                     335544398L
#define gds__doubleloc                     335544399L
#define gds__nodnotfnd                     335544400L
#define gds__dupnodfnd                     335544401L
#define gds__locnotmar                     335544402L
#define gds__badpagtyp                     335544403L
#define gds__corrupt                       335544404L
#define gds__badpage                       335544405L
#define gds__badindex                      335544406L
#define gds__dbbnotzer                     335544407L
#define gds__tranotzer                     335544408L
#define gds__trareqmis                     335544409L
#define gds__badhndcnt                     335544410L
#define gds__wrotpbver                     335544411L
#define gds__wroblrver                     335544412L
#define gds__wrodpbver                     335544413L
#define gds__blobnotsup                    335544414L
#define gds__badrelation                   335544415L
#define gds__nodetach                      335544416L
#define gds__notremote                     335544417L
#define gds__trainlim                      335544418L
#define gds__notinlim                      335544419L
#define gds__traoutsta                     335544420L
#define gds__connect_reject                335544421L
#define gds__dbfile                        335544422L
#define gds__orphan                        335544423L
#define gds__no_lock_mgr                   335544424L
#define gds__ctxinuse                      335544425L
#define gds__ctxnotdef                     335544426L
#define gds__datnotsup                     335544427L
#define gds__badmsgnum                     335544428L
#define gds__badparnum                     335544429L
#define gds__virmemexh                     335544430L
#define gds__blocking_signal               335544431L
#define gds__lockmanerr                    335544432L
#define gds__journerr                      335544433L
#define gds__keytoobig                     335544434L
#define gds__nullsegkey                    335544435L
#define gds__sqlerr                        335544436L
#define gds__wrodynver                     335544437L
#define gds__funnotdef                     335544438L
#define gds__funmismat                     335544439L
#define gds__bad_msg_vec                   335544440L
#define gds__bad_detach                    335544441L
#define gds__noargacc_read                 335544442L
#define gds__noargacc_write                335544443L
#define gds__read_only                     335544444L
#define gds__ext_err                       335544445L
#define gds__non_updatable                 335544446L
#define gds__no_rollback                   335544447L
#define gds__bad_sec_info                  335544448L
#define gds__invalid_sec_info              335544449L
#define gds__misc_interpreted              335544450L
#define gds__update_conflict               335544451L
#define gds__unlicensed                    335544452L
#define gds__obj_in_use                    335544453L
#define gds__nofilter                      335544454L
#define gds__shadow_accessed               335544455L
#define gds__invalid_sdl                   335544456L
#define gds__out_of_bounds                 335544457L
#define gds__invalid_dimension             335544458L
#define gds__rec_in_limbo                  335544459L
#define gds__shadow_missing                335544460L
#define gds__cant_validate                 335544461L
#define gds__cant_start_journal            335544462L
#define gds__gennotdef                     335544463L
#define gds__cant_start_logging            335544464L
#define gds__bad_segstr_type               335544465L
#define gds__foreign_key                   335544466L
#define gds__high_minor                    335544467L
#define gds__tra_state                     335544468L
#define gds__trans_invalid                 335544469L
#define gds__buf_invalid                   335544470L
#define gds__indexnotdefined               335544471L
#define gds__login                         335544472L
#define gds__invalid_bookmark              335544473L
#define gds__bad_lock_level                335544474L
#define gds__relation_lock                 335544475L
#define gds__record_lock                   335544476L
#define gds__max_idx                       335544477L
#define gds__jrn_enable                    335544478L
#define gds__old_failure                   335544479L
#define gds__old_in_progress               335544480L
#define gds__old_no_space                  335544481L
#define gds__no_wal_no_jrn                 335544482L
#define gds__num_old_files                 335544483L
#define gds__wal_file_open                 335544484L
#define gds__bad_stmt_handle               335544485L
#define gds__wal_failure                   335544486L
#define gds__walw_err                      335544487L
#define gds__logh_small                    335544488L
#define gds__logh_inv_version              335544489L
#define gds__logh_open_flag                335544490L
#define gds__logh_open_flag2               335544491L
#define gds__logh_diff_dbname              335544492L
#define gds__logf_unexpected_eof           335544493L
#define gds__logr_incomplete               335544494L
#define gds__logr_header_small             335544495L
#define gds__logb_small                    335544496L
#define gds__wal_illegal_attach            335544497L
#define gds__wal_invalid_wpb               335544498L
#define gds__wal_err_rollover              335544499L
#define gds__no_wal                        335544500L
#define gds__drop_wal                      335544501L
#define gds__stream_not_defined            335544502L
#define gds__wal_subsys_error              335544503L
#define gds__wal_subsys_corrupt            335544504L
#define gds__no_archive                    335544505L
#define gds__shutinprog                    335544506L
#define gds__range_in_use                  335544507L
#define gds__range_not_found               335544508L
#define gds__charset_not_found             335544509L
#define gds__lock_timeout                  335544510L
#define gds__prcnotdef                     335544511L
#define gds__prcmismat                     335544512L
#define gds__wal_bugcheck                  335544513L
#define gds__wal_cant_expand               335544514L
#define gds__codnotdef                     335544515L
#define gds__xcpnotdef                     335544516L
#define gds__except                        335544517L
#define gds__cache_restart                 335544518L
#define gds__bad_lock_handle               335544519L
#define gds__jrn_present                   335544520L
#define gds__wal_err_rollover2             335544521L
#define gds__wal_err_logwrite              335544522L
#define gds__wal_err_jrn_comm              335544523L
#define gds__wal_err_expansion             335544524L
#define gds__wal_err_setup                 335544525L
#define gds__wal_err_ww_sync               335544526L
#define gds__wal_err_ww_start              335544527L
#define gds__shutdown                      335544528L
#define gds__existing_priv_mod             335544529L
#define gds__primary_key_ref               335544530L
#define gds__primary_key_notnull           335544531L
#define gds__ref_cnstrnt_notfound          335544532L
#define gds__foreign_key_notfound          335544533L
#define gds__ref_cnstrnt_update            335544534L
#define gds__check_cnstrnt_update          335544535L
#define gds__check_cnstrnt_del             335544536L
#define gds__integ_index_seg_del           335544537L
#define gds__integ_index_seg_mod           335544538L
#define gds__integ_index_del               335544539L
#define gds__integ_index_mod               335544540L
#define gds__check_trig_del                335544541L
#define gds__check_trig_update             335544542L
#define gds__cnstrnt_fld_del               335544543L
#define gds__cnstrnt_fld_rename            335544544L
#define gds__rel_cnstrnt_update            335544545L
#define gds__constaint_on_view             335544546L
#define gds__invld_cnstrnt_type            335544547L
#define gds__primary_key_exists            335544548L
#define gds__systrig_update                335544549L
#define gds__not_rel_owner                 335544550L
#define gds__grant_obj_notfound            335544551L
#define gds__grant_fld_notfound            335544552L
#define gds__grant_nopriv                  335544553L
#define gds__nonsql_security_rel           335544554L
#define gds__nonsql_security_fld           335544555L
#define gds__wal_cache_err                 335544556L
#define gds__shutfail                      335544557L
#define gds__check_constraint              335544558L
#define gds__bad_svc_handle                335544559L
#define gds__shutwarn                      335544560L
#define gds__wrospbver                     335544561L
#define gds__bad_spb_form                  335544562L
#define gds__svcnotdef                     335544563L
#define gds__no_jrn                        335544564L
#define gds__transliteration_failed        335544565L
#define gds__start_cm_for_wal              335544566L
#define gds__wal_ovflow_log_required       335544567L
#define gds__text_subtype                  335544568L
#define gds__dsql_error                    335544569L
#define gds__dsql_command_err              335544570L
#define gds__dsql_constant_err             335544571L
#define gds__dsql_cursor_err               335544572L
#define gds__dsql_datatype_err             335544573L
#define gds__dsql_decl_err                 335544574L
#define gds__dsql_cursor_update_err        335544575L
#define gds__dsql_cursor_open_err          335544576L
#define gds__dsql_cursor_close_err         335544577L
#define gds__dsql_field_err                335544578L
#define gds__dsql_internal_err             335544579L
#define gds__dsql_relation_err             335544580L
#define gds__dsql_procedure_err            335544581L
#define gds__dsql_request_err              335544582L
#define gds__dsql_sqlda_err                335544583L
#define gds__dsql_var_count_err            335544584L
#define gds__dsql_stmt_handle              335544585L
#define gds__dsql_function_err             335544586L
#define gds__dsql_blob_err                 335544587L
#define gds__collation_not_found           335544588L
#define gds__collation_not_for_charset     335544589L
#define gds__dsql_dup_option               335544590L
#define gds__dsql_tran_err                 335544591L
#define gds__dsql_invalid_array            335544592L
#define gds__dsql_max_arr_dim_exceeded     335544593L
#define gds__dsql_arr_range_error          335544594L
#define gds__dsql_trigger_err              335544595L
#define gds__dsql_subselect_err            335544596L
#define gds__dsql_crdb_prepare_err         335544597L
#define gds__specify_field_err             335544598L
#define gds__num_field_err                 335544599L
#define gds__col_name_err                  335544600L
#define gds__where_err                     335544601L
#define gds__table_view_err                335544602L
#define gds__distinct_err                  335544603L
#define gds__key_field_count_err           335544604L
#define gds__subquery_err                  335544605L
#define gds__expression_eval_err           335544606L
#define gds__node_err                      335544607L
#define gds__command_end_err               335544608L
#define gds__index_name                    335544609L
#define gds__exception_name                335544610L
#define gds__field_name                    335544611L
#define gds__token_err                     335544612L
#define gds__union_err                     335544613L
#define gds__dsql_construct_err            335544614L
#define gds__field_aggregate_err           335544615L
#define gds__field_ref_err                 335544616L
#define gds__order_by_err                  335544617L
#define gds__return_mode_err               335544618L
#define gds__extern_func_err               335544619L
#define gds__alias_conflict_err            335544620L
#define gds__procedure_conflict_error      335544621L
#define gds__relation_conflict_err         335544622L
#define gds__dsql_domain_err               335544623L
#define gds__idx_seg_err                   335544624L
#define gds__node_name_err                 335544625L
#define gds__table_name                    335544626L
#define gds__proc_name                     335544627L
#define gds__idx_create_err                335544628L
#define gds__wal_shadow_err                335544629L
#define gds__dependency                    335544630L
#define gds__idx_key_err                   335544631L
#define gds__dsql_file_length_err          335544632L
#define gds__dsql_shadow_number_err        335544633L
#define gds__dsql_token_unk_err            335544634L
#define gds__dsql_no_relation_alias        335544635L
#define gds__indexname                     335544636L
#define gds__no_stream_plan                335544637L
#define gds__stream_twice                  335544638L
#define gds__stream_not_found              335544639L
#define gds__collation_requires_text       335544640L
#define gds__dsql_domain_not_found         335544641L
#define gds__index_unused                  335544642L
#define gds__dsql_self_join                335544643L
#define gds__stream_bof                    335544644L
#define gds__stream_crack                  335544645L
#define gds__db_or_file_exists             335544646L
#define gds__invalid_operator              335544647L
#define gds__conn_lost                     335544648L
#define gds__bad_checksum                  335544649L
#define gds__page_type_err                 335544650L
#define gds__ext_readonly_err              335544651L
#define gds__sing_select_err               335544652L
#define gds__psw_attach                    335544653L
#define gds__psw_start_trans               335544654L
#define gds__invalid_direction             335544655L
#define gds__dsql_var_conflict             335544656L
#define gds__dsql_no_blob_array            335544657L
#define gds__dsql_base_table               335544658L
#define gds__duplicate_base_table          335544659L
#define gds__view_alias                    335544660L
#define gds__index_root_page_full          335544661L
#define gds__dsql_blob_type_unknown        335544662L
#define gds__req_max_clones_exceeded       335544663L
#define gds__dsql_duplicate_spec           335544664L
#define gds__unique_key_violation          335544665L
#define gds__srvr_version_too_old          335544666L
#define gds__drdb_completed_with_errs      335544667L
#define gds__dsql_procedure_use_err        335544668L
#define gds__dsql_count_mismatch           335544669L
#define gds__blob_idx_err                  335544670L
#define gds__array_idx_err                 335544671L
#define gds__key_field_err                 335544672L
#define gds__no_delete                     335544673L
#define gds__del_last_field                335544674L
#define gds__sort_err                      335544675L
#define gds__sort_mem_err                  335544676L
#define gds__version_err                   335544677L
#define gds__inval_key_posn                335544678L
#define gds__no_segments_err               335544679L
#define gds__crrp_data_err                 335544680L
#define gds__rec_size_err                  335544681L
#define gds__dsql_field_ref                335544682L
#define gds__req_depth_exceeded            335544683L
#define gds__no_field_access               335544684L
#define gds__no_dbkey                      335544685L
#define gds__jrn_format_err                335544686L
#define gds__jrn_file_full                 335544687L
#define gds__dsql_open_cursor_request      335544688L
#define gds__ib_error                         335544689L
#define gds__cache_redef                      335544690L
#define gds__cache_too_small                  335544691L
#define gds__log_redef                        335544692L
#define gds__log_too_small                    335544693L
#define gds__partition_too_small              335544694L
#define gds__partition_not_supp               335544695L
#define gds__log_length_spec                  335544696L
#define gds__precision_err                    335544697L
#define gds__scale_nogt                       335544698L
#define gds__expec_short                      335544699L
#define gds__expec_long                       335544700L
#define gds__expec_ushort                     335544701L
#define gds__like_escape_invalid              335544702L
#define gds__svcnoexe                         335544703L
#define gds__net_lookup_err                   335544704L
#define gds__service_unknown                  335544705L
#define gds__host_unknown                     335544706L
#define gds__grant_nopriv_on_base             335544707L
#define gds__dyn_fld_ambiguous                335544708L
#define gds__dsql_agg_ref_err                 335544709L
#define gds__complex_view                     335544710L
#define gds__unprepared_stmt                  335544711L
#define gds__expec_positive                   335544712L
#define gds__dsql_sqlda_value_err             335544713L
#define gds__invalid_array_id                 335544714L
#define gds__extfile_uns_op                   335544715L
#define gds__svc_in_use                       335544716L
#define gds__err_stack_limit                  335544717L
#define gds__invalid_key                      335544718L
#define gds__net_init_error                   335544719L
#define gds__loadlib_failure                  335544720L
#define gds__network_error                    335544721L
#define gds__net_connect_err                  335544722L
#define gds__net_connect_listen_err           335544723L
#define gds__net_event_connect_err            335544724L
#define gds__net_event_listen_err             335544725L
#define gds__net_read_err                     335544726L
#define gds__net_write_err                    335544727L
#define gds__integ_index_deactivate           335544728L
#define gds__integ_deactivate_primary         335544729L
#define gds__cse_not_supported                335544730L
#define gds__tra_must_sweep                   335544731L
#define gds__unsupported_network_drive        335544732L
#define gds__io_create_err                    335544733L
#define gds__io_open_err                      335544734L
#define gds__io_close_err                     335544735L
#define gds__io_read_err                      335544736L
#define gds__io_write_err                     335544737L
#define gds__io_delete_err                    335544738L
#define gds__io_access_err                    335544739L
#define gds__udf_exception                    335544740L
#define gds__lost_db_connection               335544741L
#define gds__no_write_user_priv               335544742L
#define gds__token_too_long                   335544743L
#define gds__max_att_exceeded                 335544744L
#define gds__login_same_as_role_name          335544745L
#define gds__reftable_requires_pk             335544746L
#define gds__usrname_too_long                 335544747L
#define gds__password_too_long                335544748L
#define gds__usrname_required                 335544749L
#define gds__password_required                335544750L
#define gds__bad_protocol                     335544751L
#define gds__dup_usrname_found                335544752L
#define gds__usrname_not_found                335544753L
#define gds__error_adding_sec_record          335544754L
#define gds__error_modifying_sec_record       335544755L
#define gds__error_deleting_sec_record        335544756L
#define gds__error_updating_sec_db            335544757L
#define gds__sort_rec_size_err                335544758L
#define gds__bad_default_value                335544759L
#define gds__invalid_clause                   335544760L
#define gds__too_many_handles                 335544761L
#define gds__optimizer_blk_exc                335544762L
#define gds__invalid_string_constant          335544763L
#define gds__transitional_date                335544764L
#define gds__read_only_database               335544765L
#define gds__must_be_dialect_2_and_up         335544766L
#define gds__blob_filter_exception            335544767L
#define gds__exception_access_violation       335544768L
#define gds__exception_datatype_missalignment 335544769L
#define gds__exception_array_bounds_exceeded  335544770L
#define gds__exception_float_denormal_operand 335544771L
#define gds__exception_float_divide_by_zero   335544772L
#define gds__exception_float_inexact_result   335544773L
#define gds__exception_float_invalid_operand  335544774L
#define gds__exception_float_overflow         335544775L
#define gds__exception_float_stack_check      335544776L
#define gds__exception_float_underflow        335544777L
#define gds__exception_integer_divide_by_zero 335544778L
#define gds__exception_integer_overflow       335544779L
#define gds__exception_unknown                335544780L
#define gds__exception_stack_overflow         335544781L
#define gds__exception_sigsegv                335544782L
#define gds__exception_sigill                 335544783L
#define gds__exception_sigbus                 335544784L
#define gds__exception_sigfpe                 335544785L
#define gds__ext_file_delete                  335544786L
#define gds__ext_file_modify                  335544787L
#define gds__adm_task_denied                  335544788L
#define gds__extract_input_mismatch           335544789L
#define gds__insufficient_svc_privileges      335544790L
#define gds__file_in_use                      335544791L
#define gds__service_att_err                  335544792L
#define gds__ddl_not_allowed_by_db_sql_dial   335544793L
#define gds__cancelled                        335544794L
#define gds__unexp_spb_form                   335544795L
#define gds__sql_dialect_datatype_unsupport   335544796L
#define gds__svcnouser                        335544797L
#define gds__depend_on_uncommitted_rel        335544798L
#define gds__svc_name_missing                 335544799L
#define gds__too_many_contexts                335544800L
#define gds__datype_notsup                    335544801L
#define gds__dialect_reset_warning            335544802L
#define gds__dialect_not_changed              335544803L
#define gds__database_create_failed           335544804L
#define gds__inv_dialect_specified            335544805L
#define gds__valid_db_dialects                335544806L
#define gds__sqlwarn                          335544807L
#define gds__dtype_renamed                    335544808L
#define gds__extern_func_dir_error            335544809L
#define gds__date_range_exceeded              335544810L
#define gds__inv_client_dialect_specified     335544811L
#define gds__valid_client_dialects            335544812L
#define gds__optimizer_between_err            335544813L
#define gds__service_not_supported            335544814L
#define gds__generator_name                   335544815L
#define gds__udf_name                         335544816L
#define gds__gfix_db_name                     335740929L
#define gds__gfix_invalid_sw                  335740930L
#define gds__gfix_incmp_sw                    335740932L
#define gds__gfix_replay_req                  335740933L
#define gds__gfix_pgbuf_req                   335740934L
#define gds__gfix_val_req                     335740935L
#define gds__gfix_pval_req                    335740936L
#define gds__gfix_trn_req                     335740937L
#define gds__gfix_full_req                    335740940L
#define gds__gfix_usrname_req                 335740941L
#define gds__gfix_pass_req                    335740942L
#define gds__gfix_subs_name                   335740943L
#define gds__gfix_wal_req                     335740944L
#define gds__gfix_sec_req                     335740945L
#define gds__gfix_nval_req                    335740946L
#define gds__gfix_type_shut                   335740947L
#define gds__gfix_retry                       335740948L
#define gds__gfix_retry_db                    335740951L
#define gds__gfix_exceed_max                  335740991L
#define gds__gfix_corrupt_pool                335740992L
#define gds__gfix_mem_exhausted               335740993L
#define gds__gfix_bad_pool                    335740994L
#define gds__gfix_trn_not_valid               335740995L
#define gds__gfix_unexp_eoi                   335741012L
#define gds__gfix_recon_fail                  335741018L
#define gds__gfix_trn_unknown                 335741036L
#define gds__gfix_mode_req                    335741038L
#define gds__gfix_opt_SQL_dialect             335741039L
#define gds__dsql_dbkey_from_non_table        336003074L
#define gds__dsql_transitional_numeric        336003075L
#define gds__dsql_dialect_warning_expr        336003076L
#define gds__sql_db_dialect_dtype_unsupport   336003077L
#define gds__isc_sql_dialect_conflict_num     336003079L
#define gds__dsql_warning_number_ambiguous    336003080L
#define gds__dsql_warning_number_ambiguous1   336003081L
#define gds__dsql_warn_precision_ambiguous    336003082L
#define gds__dsql_warn_precision_ambiguous1   336003083L
#define gds__dsql_warn_precision_ambiguous2   336003084L
#define gds__dyn_role_does_not_exist          336068796L
#define gds__dyn_no_grant_admin_opt           336068797L
#define gds__dyn_user_not_role_member         336068798L
#define gds__dyn_delete_role_failed           336068799L
#define gds__dyn_grant_role_to_user           336068800L
#define gds__dyn_inv_sql_role_name            336068801L
#define gds__dyn_dup_sql_role                 336068802L
#define gds__dyn_kywd_spec_for_role           336068803L
#define gds__dyn_roles_not_supported          336068804L
#define gds__dyn_domain_name_exists           336068812L
#define gds__dyn_field_name_exists            336068813L
#define gds__dyn_dependency_exists            336068814L
#define gds__dyn_dtype_invalid                336068815L
#define gds__dyn_char_fld_too_small           336068816L
#define gds__dyn_invalid_dtype_conversion     336068817L
#define gds__dyn_dtype_conv_invalid           336068818L
#define gds__dyn_zero_len_id                  336068820L
#define gds__gbak_unknown_switch              336330753L
#define gds__gbak_page_size_missing           336330754L
#define gds__gbak_page_size_toobig            336330755L
#define gds__gbak_redir_ouput_missing         336330756L
#define gds__gbak_switches_conflict           336330757L
#define gds__gbak_unknown_device              336330758L
#define gds__gbak_no_protection               336330759L
#define gds__gbak_page_size_not_allowed       336330760L
#define gds__gbak_multi_source_dest           336330761L
#define gds__gbak_filename_missing            336330762L
#define gds__gbak_dup_inout_names             336330763L
#define gds__gbak_inv_page_size               336330764L
#define gds__gbak_db_specified                336330765L
#define gds__gbak_db_exists                   336330766L
#define gds__gbak_unk_device                  336330767L
#define gds__gbak_blob_info_failed            336330772L
#define gds__gbak_unk_blob_item               336330773L
#define gds__gbak_get_seg_failed              336330774L
#define gds__gbak_close_blob_failed           336330775L
#define gds__gbak_open_blob_failed            336330776L
#define gds__gbak_put_blr_gen_id_failed       336330777L
#define gds__gbak_unk_type                    336330778L
#define gds__gbak_comp_req_failed             336330779L
#define gds__gbak_start_req_failed            336330780L
#define gds__gbak_rec_failed                  336330781L
#define gds__gbak_rel_req_failed              336330782L
#define gds__gbak_db_info_failed              336330783L
#define gds__gbak_no_db_desc                  336330784L
#define gds__gbak_db_create_failed            336330785L
#define gds__gbak_decomp_len_error            336330786L
#define gds__gbak_tbl_missing                 336330787L
#define gds__gbak_blob_col_missing            336330788L
#define gds__gbak_create_blob_failed          336330789L
#define gds__gbak_put_seg_failed              336330790L
#define gds__gbak_rec_len_exp                 336330791L
#define gds__gbak_inv_rec_len                 336330792L
#define gds__gbak_exp_data_type               336330793L
#define gds__gbak_gen_id_failed               336330794L
#define gds__gbak_unk_rec_type                336330795L
#define gds__gbak_inv_bkup_ver                336330796L
#define gds__gbak_missing_bkup_desc           336330797L
#define gds__gbak_string_trunc                336330798L
#define gds__gbak_cant_rest_record            336330799L
#define gds__gbak_send_failed                 336330800L
#define gds__gbak_no_tbl_name                 336330801L
#define gds__gbak_unexp_eof                   336330802L
#define gds__gbak_db_format_too_old           336330803L
#define gds__gbak_inv_array_dim               336330804L
#define gds__gbak_xdr_len_expected            336330807L
#define gds__gbak_open_bkup_error             336330817L
#define gds__gbak_open_error                  336330818L
#define gds__gbak_missing_block_fac           336330934L
#define gds__gbak_inv_block_fac               336330935L
#define gds__gbak_block_fac_specified         336330936L
#define gds__gbak_missing_username            336330940L
#define gds__gbak_missing_password            336330941L
#define gds__gbak_missing_skipped_bytes       336330952L
#define gds__gbak_inv_skipped_bytes           336330953L
#define gds__gbak_err_restore_charset         336330965L
#define gds__gbak_err_restore_collation       336330967L
#define gds__gbak_read_error                  336330972L
#define gds__gbak_write_error                 336330973L
#define gds__gbak_db_in_use                   336330985L
#define gds__gbak_sysmemex                    336330990L
#define gds__gbak_restore_role_failed         336331002L
#define gds__gbak_role_op_missing             336331005L
#define gds__gbak_page_buffers_missing        336331010L
#define gds__gbak_page_buffers_wrong_param    336331011L
#define gds__gbak_page_buffers_restore        336331012L
#define gds__gbak_inv_size                    336331014L
#define gds__gbak_file_outof_sequence         336331015L
#define gds__gbak_join_file_missing           336331016L
#define gds__gbak_stdin_not_supptd            336331017L
#define gds__gbak_stdout_not_supptd           336331018L
#define gds__gbak_bkup_corrupt                336331019L
#define gds__gbak_unk_db_file_spec            336331020L
#define gds__gbak_hdr_write_failed            336331021L
#define gds__gbak_disk_space_ex               336331022L
#define gds__gbak_size_lt_min                 336331023L
#define gds__gbak_svc_name_missing            336331025L
#define gds__gbak_not_ownr                    336331026L
#define gds__gbak_mode_req                    336331031L
#define gds__gsec_cant_open_db                336723983L
#define gds__gsec_switches_error              336723984L
#define gds__gsec_no_op_spec                  336723985L
#define gds__gsec_no_usr_name                 336723986L
#define gds__gsec_err_add                     336723987L
#define gds__gsec_err_modify                  336723988L
#define gds__gsec_err_find_mod                336723989L
#define gds__gsec_err_rec_not_found           336723990L
#define gds__gsec_err_delete                  336723991L
#define gds__gsec_err_find_del                336723992L
#define gds__gsec_err_find_disp               336723996L
#define gds__gsec_inv_param                   336723997L
#define gds__gsec_op_specified                336723998L
#define gds__gsec_pw_specified                336723999L
#define gds__gsec_uid_specified               336724000L
#define gds__gsec_gid_specified               336724001L
#define gds__gsec_proj_specified              336724002L
#define gds__gsec_org_specified               336724003L
#define gds__gsec_fname_specified             336724004L
#define gds__gsec_mname_specified             336724005L
#define gds__gsec_lname_specified             336724006L
#define gds__gsec_inv_switch                  336724008L
#define gds__gsec_amb_switch                  336724009L
#define gds__gsec_no_op_specified             336724010L
#define gds__gsec_params_not_allowed          336724011L
#define gds__gsec_incompat_switch             336724012L
#define gds__gsec_inv_username                336724044L
#define gds__gsec_inv_pw_length               336724045L
#define gds__gsec_db_specified                336724046L
#define gds__gsec_db_admin_specified          336724047L
#define gds__gsec_db_admin_pw_specified       336724048L
#define gds__gsec_sql_role_specified          336724049L
#define gds__license_no_file                  336789504L
#define gds__license_op_specified             336789523L
#define gds__license_op_missing               336789524L
#define gds__license_inv_switch               336789525L
#define gds__license_inv_switch_combo         336789526L
#define gds__license_inv_op_combo             336789527L
#define gds__license_amb_switch               336789528L
#define gds__license_inv_parameter            336789529L
#define gds__license_param_specified          336789530L
#define gds__license_param_req                336789531L
#define gds__license_syntx_error              336789532L
#define gds__license_dup_id                   336789534L
#define gds__license_inv_id_key               336789535L
#define gds__license_err_remove               336789536L
#define gds__license_err_update               336789537L
#define gds__license_err_convert              336789538L
#define gds__license_err_unk                  336789539L
#define gds__license_svc_err_add              336789540L
#define gds__license_svc_err_remove           336789541L
#define gds__license_eval_exists              336789563L
#define gds__gstat_unknown_switch             336920577L
#define gds__gstat_retry                      336920578L
#define gds__gstat_wrong_ods                  336920579L
#define gds__gstat_unexpected_eof             336920580L
#define gds__gstat_open_err                   336920605L
#define gds__gstat_read_err                   336920606L
#define gds__gstat_sysmemex                   336920607L

#define gds_err_max                          699

#else					/* c++ definitions */

const GDS_LONG gds_arith_except                = 335544321L;
const GDS_LONG gds_bad_dbkey                   = 335544322L;
const GDS_LONG gds_bad_db_format               = 335544323L;
const GDS_LONG gds_bad_db_handle               = 335544324L;
const GDS_LONG gds_bad_dpb_content             = 335544325L;
const GDS_LONG gds_bad_dpb_form                = 335544326L;
const GDS_LONG gds_bad_req_handle              = 335544327L;
const GDS_LONG gds_bad_segstr_handle           = 335544328L;
const GDS_LONG gds_bad_segstr_id               = 335544329L;
const GDS_LONG gds_bad_tpb_content             = 335544330L;
const GDS_LONG gds_bad_tpb_form                = 335544331L;
const GDS_LONG gds_bad_trans_handle            = 335544332L;
const GDS_LONG gds_bug_check                   = 335544333L;
const GDS_LONG gds_convert_error               = 335544334L;
const GDS_LONG gds_db_corrupt                  = 335544335L;
const GDS_LONG gds_deadlock                    = 335544336L;
const GDS_LONG gds_excess_trans                = 335544337L;
const GDS_LONG gds_from_no_match               = 335544338L;
const GDS_LONG gds_infinap                     = 335544339L;
const GDS_LONG gds_infona                      = 335544340L;
const GDS_LONG gds_infunk                      = 335544341L;
const GDS_LONG gds_integ_fail                  = 335544342L;
const GDS_LONG gds_invalid_blr                 = 335544343L;
const GDS_LONG gds_io_error                    = 335544344L;
const GDS_LONG gds_lock_conflict               = 335544345L;
const GDS_LONG gds_metadata_corrupt            = 335544346L;
const GDS_LONG gds_not_valid                   = 335544347L;
const GDS_LONG gds_no_cur_rec                  = 335544348L;
const GDS_LONG gds_no_dup                      = 335544349L;
const GDS_LONG gds_no_finish                   = 335544350L;
const GDS_LONG gds_no_meta_update              = 335544351L;
const GDS_LONG gds_no_priv                     = 335544352L;
const GDS_LONG gds_no_recon                    = 335544353L;
const GDS_LONG gds_no_record                   = 335544354L;
const GDS_LONG gds_no_segstr_close             = 335544355L;
const GDS_LONG gds_obsolete_metadata           = 335544356L;
const GDS_LONG gds_open_trans                  = 335544357L;
const GDS_LONG gds_port_len                    = 335544358L;
const GDS_LONG gds_read_only_field             = 335544359L;
const GDS_LONG gds_read_only_rel               = 335544360L;
const GDS_LONG gds_read_only_trans             = 335544361L;
const GDS_LONG gds_read_only_view              = 335544362L;
const GDS_LONG gds_req_no_trans                = 335544363L;
const GDS_LONG gds_req_sync                    = 335544364L;
const GDS_LONG gds_req_wrong_db                = 335544365L;
const GDS_LONG gds_segment                     = 335544366L;
const GDS_LONG gds_segstr_eof                  = 335544367L;
const GDS_LONG gds_segstr_no_op                = 335544368L;
const GDS_LONG gds_segstr_no_read              = 335544369L;
const GDS_LONG gds_segstr_no_trans             = 335544370L;
const GDS_LONG gds_segstr_no_write             = 335544371L;
const GDS_LONG gds_segstr_wrong_db             = 335544372L;
const GDS_LONG gds_sys_request                 = 335544373L;
const GDS_LONG gds_stream_eof                  = 335544374L;
const GDS_LONG gds_unavailable                 = 335544375L;
const GDS_LONG gds_unres_rel                   = 335544376L;
const GDS_LONG gds_uns_ext                     = 335544377L;
const GDS_LONG gds_wish_list                   = 335544378L;
const GDS_LONG gds_wrong_ods                   = 335544379L;
const GDS_LONG gds_wronumarg                   = 335544380L;
const GDS_LONG gds_imp_exc                     = 335544381L;
const GDS_LONG gds_random                      = 335544382L;
const GDS_LONG gds_fatal_conflict              = 335544383L;
const GDS_LONG gds_badblk                      = 335544384L;
const GDS_LONG gds_invpoolcl                   = 335544385L;
const GDS_LONG gds_nopoolids                   = 335544386L;
const GDS_LONG gds_relbadblk                   = 335544387L;
const GDS_LONG gds_blktoobig                   = 335544388L;
const GDS_LONG gds_bufexh                      = 335544389L;
const GDS_LONG gds_syntaxerr                   = 335544390L;
const GDS_LONG gds_bufinuse                    = 335544391L;
const GDS_LONG gds_bdbincon                    = 335544392L;
const GDS_LONG gds_reqinuse                    = 335544393L;
const GDS_LONG gds_badodsver                   = 335544394L;
const GDS_LONG gds_relnotdef                   = 335544395L;
const GDS_LONG gds_fldnotdef                   = 335544396L;
const GDS_LONG gds_dirtypage                   = 335544397L;
const GDS_LONG gds_waifortra                   = 335544398L;
const GDS_LONG gds_doubleloc                   = 335544399L;
const GDS_LONG gds_nodnotfnd                   = 335544400L;
const GDS_LONG gds_dupnodfnd                   = 335544401L;
const GDS_LONG gds_locnotmar                   = 335544402L;
const GDS_LONG gds_badpagtyp                   = 335544403L;
const GDS_LONG gds_corrupt                     = 335544404L;
const GDS_LONG gds_badpage                     = 335544405L;
const GDS_LONG gds_badindex                    = 335544406L;
const GDS_LONG gds_dbbnotzer                   = 335544407L;
const GDS_LONG gds_tranotzer                   = 335544408L;
const GDS_LONG gds_trareqmis                   = 335544409L;
const GDS_LONG gds_badhndcnt                   = 335544410L;
const GDS_LONG gds_wrotpbver                   = 335544411L;
const GDS_LONG gds_wroblrver                   = 335544412L;
const GDS_LONG gds_wrodpbver                   = 335544413L;
const GDS_LONG gds_blobnotsup                  = 335544414L;
const GDS_LONG gds_badrelation                 = 335544415L;
const GDS_LONG gds_nodetach                    = 335544416L;
const GDS_LONG gds_notremote                   = 335544417L;
const GDS_LONG gds_trainlim                    = 335544418L;
const GDS_LONG gds_notinlim                    = 335544419L;
const GDS_LONG gds_traoutsta                   = 335544420L;
const GDS_LONG gds_connect_reject              = 335544421L;
const GDS_LONG gds_dbfile                      = 335544422L;
const GDS_LONG gds_orphan                      = 335544423L;
const GDS_LONG gds_no_lock_mgr                 = 335544424L;
const GDS_LONG gds_ctxinuse                    = 335544425L;
const GDS_LONG gds_ctxnotdef                   = 335544426L;
const GDS_LONG gds_datnotsup                   = 335544427L;
const GDS_LONG gds_badmsgnum                   = 335544428L;
const GDS_LONG gds_badparnum                   = 335544429L;
const GDS_LONG gds_virmemexh                   = 335544430L;
const GDS_LONG gds_blocking_signal             = 335544431L;
const GDS_LONG gds_lockmanerr                  = 335544432L;
const GDS_LONG gds_journerr                    = 335544433L;
const GDS_LONG gds_keytoobig                   = 335544434L;
const GDS_LONG gds_nullsegkey                  = 335544435L;
const GDS_LONG gds_sqlerr                      = 335544436L;
const GDS_LONG gds_wrodynver                   = 335544437L;
const GDS_LONG gds_funnotdef                   = 335544438L;
const GDS_LONG gds_funmismat                   = 335544439L;
const GDS_LONG gds_bad_msg_vec                 = 335544440L;
const GDS_LONG gds_bad_detach                  = 335544441L;
const GDS_LONG gds_noargacc_read               = 335544442L;
const GDS_LONG gds_noargacc_write              = 335544443L;
const GDS_LONG gds_read_only                   = 335544444L;
const GDS_LONG gds_ext_err                     = 335544445L;
const GDS_LONG gds_non_updatable               = 335544446L;
const GDS_LONG gds_no_rollback                 = 335544447L;
const GDS_LONG gds_bad_sec_info                = 335544448L;
const GDS_LONG gds_invalid_sec_info            = 335544449L;
const GDS_LONG gds_misc_interpreted            = 335544450L;
const GDS_LONG gds_update_conflict             = 335544451L;
const GDS_LONG gds_unlicensed                  = 335544452L;
const GDS_LONG gds_obj_in_use                  = 335544453L;
const GDS_LONG gds_nofilter                    = 335544454L;
const GDS_LONG gds_shadow_accessed             = 335544455L;
const GDS_LONG gds_invalid_sdl                 = 335544456L;
const GDS_LONG gds_out_of_bounds               = 335544457L;
const GDS_LONG gds_invalid_dimension           = 335544458L;
const GDS_LONG gds_rec_in_limbo                = 335544459L;
const GDS_LONG gds_shadow_missing              = 335544460L;
const GDS_LONG gds_cant_validate               = 335544461L;
const GDS_LONG gds_cant_start_journal          = 335544462L;
const GDS_LONG gds_gennotdef                   = 335544463L;
const GDS_LONG gds_cant_start_logging          = 335544464L;
const GDS_LONG gds_bad_segstr_type             = 335544465L;
const GDS_LONG gds_foreign_key                 = 335544466L;
const GDS_LONG gds_high_minor                  = 335544467L;
const GDS_LONG gds_tra_state                   = 335544468L;
const GDS_LONG gds_trans_invalid               = 335544469L;
const GDS_LONG gds_buf_invalid                 = 335544470L;
const GDS_LONG gds_indexnotdefined             = 335544471L;
const GDS_LONG gds_login                       = 335544472L;
const GDS_LONG gds_invalid_bookmark            = 335544473L;
const GDS_LONG gds_bad_lock_level              = 335544474L;
const GDS_LONG gds_relation_lock               = 335544475L;
const GDS_LONG gds_record_lock                 = 335544476L;
const GDS_LONG gds_max_idx                     = 335544477L;
const GDS_LONG gds_jrn_enable                  = 335544478L;
const GDS_LONG gds_old_failure                 = 335544479L;
const GDS_LONG gds_old_in_progress             = 335544480L;
const GDS_LONG gds_old_no_space                = 335544481L;
const GDS_LONG gds_no_wal_no_jrn               = 335544482L;
const GDS_LONG gds_num_old_files               = 335544483L;
const GDS_LONG gds_wal_file_open               = 335544484L;
const GDS_LONG gds_bad_stmt_handle             = 335544485L;
const GDS_LONG gds_wal_failure                 = 335544486L;
const GDS_LONG gds_walw_err                    = 335544487L;
const GDS_LONG gds_logh_small                  = 335544488L;
const GDS_LONG gds_logh_inv_version            = 335544489L;
const GDS_LONG gds_logh_open_flag              = 335544490L;
const GDS_LONG gds_logh_open_flag2             = 335544491L;
const GDS_LONG gds_logh_diff_dbname            = 335544492L;
const GDS_LONG gds_logf_unexpected_eof         = 335544493L;
const GDS_LONG gds_logr_incomplete             = 335544494L;
const GDS_LONG gds_logr_header_small           = 335544495L;
const GDS_LONG gds_logb_small                  = 335544496L;
const GDS_LONG gds_wal_illegal_attach          = 335544497L;
const GDS_LONG gds_wal_invalid_wpb             = 335544498L;
const GDS_LONG gds_wal_err_rollover            = 335544499L;
const GDS_LONG gds_no_wal                      = 335544500L;
const GDS_LONG gds_drop_wal                    = 335544501L;
const GDS_LONG gds_stream_not_defined          = 335544502L;
const GDS_LONG gds_wal_subsys_error            = 335544503L;
const GDS_LONG gds_wal_subsys_corrupt          = 335544504L;
const GDS_LONG gds_no_archive                  = 335544505L;
const GDS_LONG gds_shutinprog                  = 335544506L;
const GDS_LONG gds_range_in_use                = 335544507L;
const GDS_LONG gds_range_not_found             = 335544508L;
const GDS_LONG gds_charset_not_found           = 335544509L;
const GDS_LONG gds_lock_timeout                = 335544510L;
const GDS_LONG gds_prcnotdef                   = 335544511L;
const GDS_LONG gds_prcmismat                   = 335544512L;
const GDS_LONG gds_wal_bugcheck                = 335544513L;
const GDS_LONG gds_wal_cant_expand             = 335544514L;
const GDS_LONG gds_codnotdef                   = 335544515L;
const GDS_LONG gds_xcpnotdef                   = 335544516L;
const GDS_LONG gds_except                      = 335544517L;
const GDS_LONG gds_cache_restart               = 335544518L;
const GDS_LONG gds_bad_lock_handle             = 335544519L;
const GDS_LONG gds_jrn_present                 = 335544520L;
const GDS_LONG gds_wal_err_rollover2           = 335544521L;
const GDS_LONG gds_wal_err_logwrite            = 335544522L;
const GDS_LONG gds_wal_err_jrn_comm            = 335544523L;
const GDS_LONG gds_wal_err_expansion           = 335544524L;
const GDS_LONG gds_wal_err_setup               = 335544525L;
const GDS_LONG gds_wal_err_ww_sync             = 335544526L;
const GDS_LONG gds_wal_err_ww_start            = 335544527L;
const GDS_LONG gds_shutdown                    = 335544528L;
const GDS_LONG gds_existing_priv_mod           = 335544529L;
const GDS_LONG gds_primary_key_ref             = 335544530L;
const GDS_LONG gds_primary_key_notnull         = 335544531L;
const GDS_LONG gds_ref_cnstrnt_notfound        = 335544532L;
const GDS_LONG gds_foreign_key_notfound        = 335544533L;
const GDS_LONG gds_ref_cnstrnt_update          = 335544534L;
const GDS_LONG gds_check_cnstrnt_update        = 335544535L;
const GDS_LONG gds_check_cnstrnt_del           = 335544536L;
const GDS_LONG gds_integ_index_seg_del         = 335544537L;
const GDS_LONG gds_integ_index_seg_mod         = 335544538L;
const GDS_LONG gds_integ_index_del             = 335544539L;
const GDS_LONG gds_integ_index_mod             = 335544540L;
const GDS_LONG gds_check_trig_del              = 335544541L;
const GDS_LONG gds_check_trig_update           = 335544542L;
const GDS_LONG gds_cnstrnt_fld_del             = 335544543L;
const GDS_LONG gds_cnstrnt_fld_rename          = 335544544L;
const GDS_LONG gds_rel_cnstrnt_update          = 335544545L;
const GDS_LONG gds_constaint_on_view           = 335544546L;
const GDS_LONG gds_invld_cnstrnt_type          = 335544547L;
const GDS_LONG gds_primary_key_exists          = 335544548L;
const GDS_LONG gds_systrig_update              = 335544549L;
const GDS_LONG gds_not_rel_owner               = 335544550L;
const GDS_LONG gds_grant_obj_notfound          = 335544551L;
const GDS_LONG gds_grant_fld_notfound          = 335544552L;
const GDS_LONG gds_grant_nopriv                = 335544553L;
const GDS_LONG gds_nonsql_security_rel         = 335544554L;
const GDS_LONG gds_nonsql_security_fld         = 335544555L;
const GDS_LONG gds_wal_cache_err               = 335544556L;
const GDS_LONG gds_shutfail                    = 335544557L;
const GDS_LONG gds_check_constraint            = 335544558L;
const GDS_LONG gds_bad_svc_handle              = 335544559L;
const GDS_LONG gds_shutwarn                    = 335544560L;
const GDS_LONG gds_wrospbver                   = 335544561L;
const GDS_LONG gds_bad_spb_form                = 335544562L;
const GDS_LONG gds_svcnotdef                   = 335544563L;
const GDS_LONG gds_no_jrn                      = 335544564L;
const GDS_LONG gds_transliteration_failed      = 335544565L;
const GDS_LONG gds_start_cm_for_wal            = 335544566L;
const GDS_LONG gds_wal_ovflow_log_required     = 335544567L;
const GDS_LONG gds_text_subtype                = 335544568L;
const GDS_LONG gds_dsql_error                  = 335544569L;
const GDS_LONG gds_dsql_command_err            = 335544570L;
const GDS_LONG gds_dsql_constant_err           = 335544571L;
const GDS_LONG gds_dsql_cursor_err             = 335544572L;
const GDS_LONG gds_dsql_datatype_err           = 335544573L;
const GDS_LONG gds_dsql_decl_err               = 335544574L;
const GDS_LONG gds_dsql_cursor_update_err      = 335544575L;
const GDS_LONG gds_dsql_cursor_open_err        = 335544576L;
const GDS_LONG gds_dsql_cursor_close_err       = 335544577L;
const GDS_LONG gds_dsql_field_err              = 335544578L;
const GDS_LONG gds_dsql_internal_err           = 335544579L;
const GDS_LONG gds_dsql_relation_err           = 335544580L;
const GDS_LONG gds_dsql_procedure_err          = 335544581L;
const GDS_LONG gds_dsql_request_err            = 335544582L;
const GDS_LONG gds_dsql_sqlda_err              = 335544583L;
const GDS_LONG gds_dsql_var_count_err          = 335544584L;
const GDS_LONG gds_dsql_stmt_handle            = 335544585L;
const GDS_LONG gds_dsql_function_err           = 335544586L;
const GDS_LONG gds_dsql_blob_err               = 335544587L;
const GDS_LONG gds_collation_not_found         = 335544588L;
const GDS_LONG gds_collation_not_for_charset   = 335544589L;
const GDS_LONG gds_dsql_dup_option             = 335544590L;
const GDS_LONG gds_dsql_tran_err               = 335544591L;
const GDS_LONG gds_dsql_invalid_array          = 335544592L;
const GDS_LONG gds_dsql_max_arr_dim_exceeded   = 335544593L;
const GDS_LONG gds_dsql_arr_range_error        = 335544594L;
const GDS_LONG gds_dsql_trigger_err            = 335544595L;
const GDS_LONG gds_dsql_subselect_err          = 335544596L;
const GDS_LONG gds_dsql_crdb_prepare_err       = 335544597L;
const GDS_LONG gds_specify_field_err           = 335544598L;
const GDS_LONG gds_num_field_err               = 335544599L;
const GDS_LONG gds_col_name_err                = 335544600L;
const GDS_LONG gds_where_err                   = 335544601L;
const GDS_LONG gds_table_view_err              = 335544602L;
const GDS_LONG gds_distinct_err                = 335544603L;
const GDS_LONG gds_key_field_count_err         = 335544604L;
const GDS_LONG gds_subquery_err                = 335544605L;
const GDS_LONG gds_expression_eval_err         = 335544606L;
const GDS_LONG gds_node_err                    = 335544607L;
const GDS_LONG gds_command_end_err             = 335544608L;
const GDS_LONG gds_index_name                  = 335544609L;
const GDS_LONG gds_exception_name              = 335544610L;
const GDS_LONG gds_field_name                  = 335544611L;
const GDS_LONG gds_token_err                   = 335544612L;
const GDS_LONG gds_union_err                   = 335544613L;
const GDS_LONG gds_dsql_construct_err          = 335544614L;
const GDS_LONG gds_field_aggregate_err         = 335544615L;
const GDS_LONG gds_field_ref_err               = 335544616L;
const GDS_LONG gds_order_by_err                = 335544617L;
const GDS_LONG gds_return_mode_err             = 335544618L;
const GDS_LONG gds_extern_func_err             = 335544619L;
const GDS_LONG gds_alias_conflict_err          = 335544620L;
const GDS_LONG gds_procedure_conflict_error    = 335544621L;
const GDS_LONG gds_relation_conflict_err       = 335544622L;
const GDS_LONG gds_dsql_domain_err             = 335544623L;
const GDS_LONG gds_idx_seg_err                 = 335544624L;
const GDS_LONG gds_node_name_err               = 335544625L;
const GDS_LONG gds_table_name                  = 335544626L;
const GDS_LONG gds_proc_name                   = 335544627L;
const GDS_LONG gds_idx_create_err              = 335544628L;
const GDS_LONG gds_wal_shadow_err              = 335544629L;
const GDS_LONG gds_dependency                  = 335544630L;
const GDS_LONG gds_idx_key_err                 = 335544631L;
const GDS_LONG gds_dsql_file_length_err        = 335544632L;
const GDS_LONG gds_dsql_shadow_number_err      = 335544633L;
const GDS_LONG gds_dsql_token_unk_err          = 335544634L;
const GDS_LONG gds_dsql_no_relation_alias      = 335544635L;
const GDS_LONG gds_indexname                   = 335544636L;
const GDS_LONG gds_no_stream_plan              = 335544637L;
const GDS_LONG gds_stream_twice                = 335544638L;
const GDS_LONG gds_stream_not_found            = 335544639L;
const GDS_LONG gds_collation_requires_text     = 335544640L;
const GDS_LONG gds_dsql_domain_not_found       = 335544641L;
const GDS_LONG gds_index_unused                = 335544642L;
const GDS_LONG gds_dsql_self_join              = 335544643L;
const GDS_LONG gds_stream_bof                  = 335544644L;
const GDS_LONG gds_stream_crack                = 335544645L;
const GDS_LONG gds_db_or_file_exists           = 335544646L;
const GDS_LONG gds_invalid_operator            = 335544647L;
const GDS_LONG gds_conn_lost                   = 335544648L;
const GDS_LONG gds_bad_checksum                = 335544649L;
const GDS_LONG gds_page_type_err               = 335544650L;
const GDS_LONG gds_ext_readonly_err            = 335544651L;
const GDS_LONG gds_sing_select_err             = 335544652L;
const GDS_LONG gds_psw_attach                  = 335544653L;
const GDS_LONG gds_psw_start_trans             = 335544654L;
const GDS_LONG gds_invalid_direction           = 335544655L;
const GDS_LONG gds_dsql_var_conflict           = 335544656L;
const GDS_LONG gds_dsql_no_blob_array          = 335544657L;
const GDS_LONG gds_dsql_base_table             = 335544658L;
const GDS_LONG gds_duplicate_base_table        = 335544659L;
const GDS_LONG gds_view_alias                  = 335544660L;
const GDS_LONG gds_index_root_page_full        = 335544661L;
const GDS_LONG gds_dsql_blob_type_unknown      = 335544662L;
const GDS_LONG gds_req_max_clones_exceeded     = 335544663L;
const GDS_LONG gds_dsql_duplicate_spec         = 335544664L;
const GDS_LONG gds_unique_key_violation        = 335544665L;
const GDS_LONG gds_srvr_version_too_old        = 335544666L;
const GDS_LONG gds_drdb_completed_with_errs    = 335544667L;
const GDS_LONG gds_dsql_procedure_use_err      = 335544668L;
const GDS_LONG gds_dsql_count_mismatch         = 335544669L;
const GDS_LONG gds_blob_idx_err                = 335544670L;
const GDS_LONG gds_array_idx_err               = 335544671L;
const GDS_LONG gds_key_field_err               = 335544672L;
const GDS_LONG gds_no_delete                   = 335544673L;
const GDS_LONG gds_del_last_field              = 335544674L;
const GDS_LONG gds_sort_err                    = 335544675L;
const GDS_LONG gds_sort_mem_err                = 335544676L;
const GDS_LONG gds_version_err                 = 335544677L;
const GDS_LONG gds_inval_key_posn              = 335544678L;
const GDS_LONG gds_no_segments_err             = 335544679L;
const GDS_LONG gds_crrp_data_err               = 335544680L;
const GDS_LONG gds_rec_size_err                = 335544681L;
const GDS_LONG gds_dsql_field_ref              = 335544682L;
const GDS_LONG gds_req_depth_exceeded          = 335544683L;
const GDS_LONG gds_no_field_access             = 335544684L;
const GDS_LONG gds_no_dbkey                    = 335544685L;
const GDS_LONG gds_jrn_format_err              = 335544686L;
const GDS_LONG gds_jrn_file_full               = 335544687L;
const GDS_LONG gds_dsql_open_cursor_request    = 335544688L;
const GDS_LONG gds_ib_error                         = 335544689L;
const GDS_LONG gds_cache_redef                      = 335544690L;
const GDS_LONG gds_cache_too_small                  = 335544691L;
const GDS_LONG gds_log_redef                        = 335544692L;
const GDS_LONG gds_log_too_small                    = 335544693L;
const GDS_LONG gds_partition_too_small              = 335544694L;
const GDS_LONG gds_partition_not_supp               = 335544695L;
const GDS_LONG gds_log_length_spec                  = 335544696L;
const GDS_LONG gds_precision_err                    = 335544697L;
const GDS_LONG gds_scale_nogt                       = 335544698L;
const GDS_LONG gds_expec_short                      = 335544699L;
const GDS_LONG gds_expec_long                       = 335544700L;
const GDS_LONG gds_expec_ushort                     = 335544701L;
const GDS_LONG gds_like_escape_invalid              = 335544702L;
const GDS_LONG gds_svcnoexe                         = 335544703L;
const GDS_LONG gds_net_lookup_err                   = 335544704L;
const GDS_LONG gds_service_unknown                  = 335544705L;
const GDS_LONG gds_host_unknown                     = 335544706L;
const GDS_LONG gds_grant_nopriv_on_base             = 335544707L;
const GDS_LONG gds_dyn_fld_ambiguous                = 335544708L;
const GDS_LONG gds_dsql_agg_ref_err                 = 335544709L;
const GDS_LONG gds_complex_view                     = 335544710L;
const GDS_LONG gds_unprepared_stmt                  = 335544711L;
const GDS_LONG gds_expec_positive                   = 335544712L;
const GDS_LONG gds_dsql_sqlda_value_err             = 335544713L;
const GDS_LONG gds_invalid_array_id                 = 335544714L;
const GDS_LONG gds_extfile_uns_op                   = 335544715L;
const GDS_LONG gds_svc_in_use                       = 335544716L;
const GDS_LONG gds_err_stack_limit                  = 335544717L;
const GDS_LONG gds_invalid_key                      = 335544718L;
const GDS_LONG gds_net_init_error                   = 335544719L;
const GDS_LONG gds_loadlib_failure                  = 335544720L;
const GDS_LONG gds_network_error                    = 335544721L;
const GDS_LONG gds_net_connect_err                  = 335544722L;
const GDS_LONG gds_net_connect_listen_err           = 335544723L;
const GDS_LONG gds_net_event_connect_err            = 335544724L;
const GDS_LONG gds_net_event_listen_err             = 335544725L;
const GDS_LONG gds_net_read_err                     = 335544726L;
const GDS_LONG gds_net_write_err                    = 335544727L;
const GDS_LONG gds_integ_index_deactivate           = 335544728L;
const GDS_LONG gds_integ_deactivate_primary         = 335544729L;
const GDS_LONG gds_cse_not_supported                = 335544730L;
const GDS_LONG gds_tra_must_sweep                   = 335544731L;
const GDS_LONG gds_unsupported_network_drive        = 335544732L;
const GDS_LONG gds_io_create_err                    = 335544733L;
const GDS_LONG gds_io_open_err                      = 335544734L;
const GDS_LONG gds_io_close_err                     = 335544735L;
const GDS_LONG gds_io_read_err                      = 335544736L;
const GDS_LONG gds_io_write_err                     = 335544737L;
const GDS_LONG gds_io_delete_err                    = 335544738L;
const GDS_LONG gds_io_access_err                    = 335544739L;
const GDS_LONG gds_udf_exception                    = 335544740L;
const GDS_LONG gds_lost_db_connection               = 335544741L;
const GDS_LONG gds_no_write_user_priv               = 335544742L;
const GDS_LONG gds_token_too_long                   = 335544743L;
const GDS_LONG gds_max_att_exceeded                 = 335544744L;
const GDS_LONG gds_login_same_as_role_name          = 335544745L;
const GDS_LONG gds_reftable_requires_pk             = 335544746L;
const GDS_LONG gds_usrname_too_long                 = 335544747L;
const GDS_LONG gds_password_too_long                = 335544748L;
const GDS_LONG gds_usrname_required                 = 335544749L;
const GDS_LONG gds_password_required                = 335544750L;
const GDS_LONG gds_bad_protocol                     = 335544751L;
const GDS_LONG gds_dup_usrname_found                = 335544752L;
const GDS_LONG gds_usrname_not_found                = 335544753L;
const GDS_LONG gds_error_adding_sec_record          = 335544754L;
const GDS_LONG gds_error_modifying_sec_record       = 335544755L;
const GDS_LONG gds_error_deleting_sec_record        = 335544756L;
const GDS_LONG gds_error_updating_sec_db            = 335544757L;
const GDS_LONG gds_sort_rec_size_err                = 335544758L;
const GDS_LONG gds_bad_default_value                = 335544759L;
const GDS_LONG gds_invalid_clause                   = 335544760L;
const GDS_LONG gds_too_many_handles                 = 335544761L;
const GDS_LONG gds_optimizer_blk_exc                = 335544762L;
const GDS_LONG gds_invalid_string_constant          = 335544763L;
const GDS_LONG gds_transitional_date                = 335544764L;
const GDS_LONG gds_read_only_database               = 335544765L;
const GDS_LONG gds_must_be_dialect_2_and_up         = 335544766L;
const GDS_LONG gds_blob_filter_exception            = 335544767L;
const GDS_LONG gds_exception_access_violation       = 335544768L;
const GDS_LONG gds_exception_datatype_missalignment = 335544769L;
const GDS_LONG gds_exception_array_bounds_exceeded  = 335544770L;
const GDS_LONG gds_exception_float_denormal_operand = 335544771L;
const GDS_LONG gds_exception_float_divide_by_zero   = 335544772L;
const GDS_LONG gds_exception_float_inexact_result   = 335544773L;
const GDS_LONG gds_exception_float_invalid_operand  = 335544774L;
const GDS_LONG gds_exception_float_overflow         = 335544775L;
const GDS_LONG gds_exception_float_stack_check      = 335544776L;
const GDS_LONG gds_exception_float_underflow        = 335544777L;
const GDS_LONG gds_exception_integer_divide_by_zero = 335544778L;
const GDS_LONG gds_exception_integer_overflow       = 335544779L;
const GDS_LONG gds_exception_unknown                = 335544780L;
const GDS_LONG gds_exception_stack_overflow         = 335544781L;
const GDS_LONG gds_exception_sigsegv                = 335544782L;
const GDS_LONG gds_exception_sigill                 = 335544783L;
const GDS_LONG gds_exception_sigbus                 = 335544784L;
const GDS_LONG gds_exception_sigfpe                 = 335544785L;
const GDS_LONG gds_ext_file_delete                  = 335544786L;
const GDS_LONG gds_ext_file_modify                  = 335544787L;
const GDS_LONG gds_adm_task_denied                  = 335544788L;
const GDS_LONG gds_extract_input_mismatch           = 335544789L;
const GDS_LONG gds_insufficient_svc_privileges      = 335544790L;
const GDS_LONG gds_file_in_use                      = 335544791L;
const GDS_LONG gds_service_att_err                  = 335544792L;
const GDS_LONG gds_ddl_not_allowed_by_db_sql_dial   = 335544793L;
const GDS_LONG gds_cancelled                        = 335544794L;
const GDS_LONG gds_unexp_spb_form                   = 335544795L;
const GDS_LONG gds_sql_dialect_datatype_unsupport   = 335544796L;
const GDS_LONG gds_svcnouser                        = 335544797L;
const GDS_LONG gds_depend_on_uncommitted_rel        = 335544798L;
const GDS_LONG gds_svc_name_missing                 = 335544799L;
const GDS_LONG gds_too_many_contexts                = 335544800L;
const GDS_LONG gds_datype_notsup                    = 335544801L;
const GDS_LONG gds_dialect_reset_warning            = 335544802L;
const GDS_LONG gds_dialect_not_changed              = 335544803L;
const GDS_LONG gds_database_create_failed           = 335544804L;
const GDS_LONG gds_inv_dialect_specified            = 335544805L;
const GDS_LONG gds_valid_db_dialects                = 335544806L;
const GDS_LONG gds_sqlwarn                          = 335544807L;
const GDS_LONG gds_dtype_renamed                    = 335544808L;
const GDS_LONG gds_extern_func_dir_error            = 335544809L;
const GDS_LONG gds_date_range_exceeded              = 335544810L;
const GDS_LONG gds_inv_client_dialect_specified     = 335544811L;
const GDS_LONG gds_valid_client_dialects            = 335544812L;
const GDS_LONG gds_optimizer_between_err            = 335544813L;
const GDS_LONG gds_service_not_supported            = 335544814L;
const GDS_LONG gds_generator_name                   = 335544815L;
const GDS_LONG gds_udf_name                         = 335544816L;
const GDS_LONG gds_gfix_db_name                     = 335740929L;
const GDS_LONG gds_gfix_invalid_sw                  = 335740930L;
const GDS_LONG gds_gfix_incmp_sw                    = 335740932L;
const GDS_LONG gds_gfix_replay_req                  = 335740933L;
const GDS_LONG gds_gfix_pgbuf_req                   = 335740934L;
const GDS_LONG gds_gfix_val_req                     = 335740935L;
const GDS_LONG gds_gfix_pval_req                    = 335740936L;
const GDS_LONG gds_gfix_trn_req                     = 335740937L;
const GDS_LONG gds_gfix_full_req                    = 335740940L;
const GDS_LONG gds_gfix_usrname_req                 = 335740941L;
const GDS_LONG gds_gfix_pass_req                    = 335740942L;
const GDS_LONG gds_gfix_subs_name                   = 335740943L;
const GDS_LONG gds_gfix_wal_req                     = 335740944L;
const GDS_LONG gds_gfix_sec_req                     = 335740945L;
const GDS_LONG gds_gfix_nval_req                    = 335740946L;
const GDS_LONG gds_gfix_type_shut                   = 335740947L;
const GDS_LONG gds_gfix_retry                       = 335740948L;
const GDS_LONG gds_gfix_retry_db                    = 335740951L;
const GDS_LONG gds_gfix_exceed_max                  = 335740991L;
const GDS_LONG gds_gfix_corrupt_pool                = 335740992L;
const GDS_LONG gds_gfix_mem_exhausted               = 335740993L;
const GDS_LONG gds_gfix_bad_pool                    = 335740994L;
const GDS_LONG gds_gfix_trn_not_valid               = 335740995L;
const GDS_LONG gds_gfix_unexp_eoi                   = 335741012L;
const GDS_LONG gds_gfix_recon_fail                  = 335741018L;
const GDS_LONG gds_gfix_trn_unknown                 = 335741036L;
const GDS_LONG gds_gfix_mode_req                    = 335741038L;
const GDS_LONG gds_gfix_opt_SQL_dialect             = 335741039L;
const GDS_LONG gds_dsql_dbkey_from_non_table        = 336003074L;
const GDS_LONG gds_dsql_transitional_numeric        = 336003075L;
const GDS_LONG gds_dsql_dialect_warning_expr        = 336003076L;
const GDS_LONG gds_sql_db_dialect_dtype_unsupport   = 336003077L;
const GDS_LONG gds_isc_sql_dialect_conflict_num     = 336003079L;
const GDS_LONG gds_dsql_warning_number_ambiguous    = 336003080L;
const GDS_LONG gds_dsql_warning_number_ambiguous1   = 336003081L;
const GDS_LONG gds_dsql_warn_precision_ambiguous    = 336003082L;
const GDS_LONG gds_dsql_warn_precision_ambiguous1   = 336003083L;
const GDS_LONG gds_dsql_warn_precision_ambiguous2   = 336003084L;
const GDS_LONG gds_dyn_role_does_not_exist          = 336068796L;
const GDS_LONG gds_dyn_no_grant_admin_opt           = 336068797L;
const GDS_LONG gds_dyn_user_not_role_member         = 336068798L;
const GDS_LONG gds_dyn_delete_role_failed           = 336068799L;
const GDS_LONG gds_dyn_grant_role_to_user           = 336068800L;
const GDS_LONG gds_dyn_inv_sql_role_name            = 336068801L;
const GDS_LONG gds_dyn_dup_sql_role                 = 336068802L;
const GDS_LONG gds_dyn_kywd_spec_for_role           = 336068803L;
const GDS_LONG gds_dyn_roles_not_supported          = 336068804L;
const GDS_LONG gds_dyn_domain_name_exists           = 336068812L;
const GDS_LONG gds_dyn_field_name_exists            = 336068813L;
const GDS_LONG gds_dyn_dependency_exists            = 336068814L;
const GDS_LONG gds_dyn_dtype_invalid                = 336068815L;
const GDS_LONG gds_dyn_char_fld_too_small           = 336068816L;
const GDS_LONG gds_dyn_invalid_dtype_conversion     = 336068817L;
const GDS_LONG gds_dyn_dtype_conv_invalid           = 336068818L;
const GDS_LONG gds_dyn_zero_len_id                  = 336068820L;
const GDS_LONG gds_gbak_unknown_switch              = 336330753L;
const GDS_LONG gds_gbak_page_size_missing           = 336330754L;
const GDS_LONG gds_gbak_page_size_toobig            = 336330755L;
const GDS_LONG gds_gbak_redir_ouput_missing         = 336330756L;
const GDS_LONG gds_gbak_switches_conflict           = 336330757L;
const GDS_LONG gds_gbak_unknown_device              = 336330758L;
const GDS_LONG gds_gbak_no_protection               = 336330759L;
const GDS_LONG gds_gbak_page_size_not_allowed       = 336330760L;
const GDS_LONG gds_gbak_multi_source_dest           = 336330761L;
const GDS_LONG gds_gbak_filename_missing            = 336330762L;
const GDS_LONG gds_gbak_dup_inout_names             = 336330763L;
const GDS_LONG gds_gbak_inv_page_size               = 336330764L;
const GDS_LONG gds_gbak_db_specified                = 336330765L;
const GDS_LONG gds_gbak_db_exists                   = 336330766L;
const GDS_LONG gds_gbak_unk_device                  = 336330767L;
const GDS_LONG gds_gbak_blob_info_failed            = 336330772L;
const GDS_LONG gds_gbak_unk_blob_item               = 336330773L;
const GDS_LONG gds_gbak_get_seg_failed              = 336330774L;
const GDS_LONG gds_gbak_close_blob_failed           = 336330775L;
const GDS_LONG gds_gbak_open_blob_failed            = 336330776L;
const GDS_LONG gds_gbak_put_blr_gen_id_failed       = 336330777L;
const GDS_LONG gds_gbak_unk_type                    = 336330778L;
const GDS_LONG gds_gbak_comp_req_failed             = 336330779L;
const GDS_LONG gds_gbak_start_req_failed            = 336330780L;
const GDS_LONG gds_gbak_rec_failed                  = 336330781L;
const GDS_LONG gds_gbak_rel_req_failed              = 336330782L;
const GDS_LONG gds_gbak_db_info_failed              = 336330783L;
const GDS_LONG gds_gbak_no_db_desc                  = 336330784L;
const GDS_LONG gds_gbak_db_create_failed            = 336330785L;
const GDS_LONG gds_gbak_decomp_len_error            = 336330786L;
const GDS_LONG gds_gbak_tbl_missing                 = 336330787L;
const GDS_LONG gds_gbak_blob_col_missing            = 336330788L;
const GDS_LONG gds_gbak_create_blob_failed          = 336330789L;
const GDS_LONG gds_gbak_put_seg_failed              = 336330790L;
const GDS_LONG gds_gbak_rec_len_exp                 = 336330791L;
const GDS_LONG gds_gbak_inv_rec_len                 = 336330792L;
const GDS_LONG gds_gbak_exp_data_type               = 336330793L;
const GDS_LONG gds_gbak_gen_id_failed               = 336330794L;
const GDS_LONG gds_gbak_unk_rec_type                = 336330795L;
const GDS_LONG gds_gbak_inv_bkup_ver                = 336330796L;
const GDS_LONG gds_gbak_missing_bkup_desc           = 336330797L;
const GDS_LONG gds_gbak_string_trunc                = 336330798L;
const GDS_LONG gds_gbak_cant_rest_record            = 336330799L;
const GDS_LONG gds_gbak_send_failed                 = 336330800L;
const GDS_LONG gds_gbak_no_tbl_name                 = 336330801L;
const GDS_LONG gds_gbak_unexp_eof                   = 336330802L;
const GDS_LONG gds_gbak_db_format_too_old           = 336330803L;
const GDS_LONG gds_gbak_inv_array_dim               = 336330804L;
const GDS_LONG gds_gbak_xdr_len_expected            = 336330807L;
const GDS_LONG gds_gbak_open_bkup_error             = 336330817L;
const GDS_LONG gds_gbak_open_error                  = 336330818L;
const GDS_LONG gds_gbak_missing_block_fac           = 336330934L;
const GDS_LONG gds_gbak_inv_block_fac               = 336330935L;
const GDS_LONG gds_gbak_block_fac_specified         = 336330936L;
const GDS_LONG gds_gbak_missing_username            = 336330940L;
const GDS_LONG gds_gbak_missing_password            = 336330941L;
const GDS_LONG gds_gbak_missing_skipped_bytes       = 336330952L;
const GDS_LONG gds_gbak_inv_skipped_bytes           = 336330953L;
const GDS_LONG gds_gbak_err_restore_charset         = 336330965L;
const GDS_LONG gds_gbak_err_restore_collation       = 336330967L;
const GDS_LONG gds_gbak_read_error                  = 336330972L;
const GDS_LONG gds_gbak_write_error                 = 336330973L;
const GDS_LONG gds_gbak_db_in_use                   = 336330985L;
const GDS_LONG gds_gbak_sysmemex                    = 336330990L;
const GDS_LONG gds_gbak_restore_role_failed         = 336331002L;
const GDS_LONG gds_gbak_role_op_missing             = 336331005L;
const GDS_LONG gds_gbak_page_buffers_missing        = 336331010L;
const GDS_LONG gds_gbak_page_buffers_wrong_param    = 336331011L;
const GDS_LONG gds_gbak_page_buffers_restore        = 336331012L;
const GDS_LONG gds_gbak_inv_size                    = 336331014L;
const GDS_LONG gds_gbak_file_outof_sequence         = 336331015L;
const GDS_LONG gds_gbak_join_file_missing           = 336331016L;
const GDS_LONG gds_gbak_stdin_not_supptd            = 336331017L;
const GDS_LONG gds_gbak_stdout_not_supptd           = 336331018L;
const GDS_LONG gds_gbak_bkup_corrupt                = 336331019L;
const GDS_LONG gds_gbak_unk_db_file_spec            = 336331020L;
const GDS_LONG gds_gbak_hdr_write_failed            = 336331021L;
const GDS_LONG gds_gbak_disk_space_ex               = 336331022L;
const GDS_LONG gds_gbak_size_lt_min                 = 336331023L;
const GDS_LONG gds_gbak_svc_name_missing            = 336331025L;
const GDS_LONG gds_gbak_not_ownr                    = 336331026L;
const GDS_LONG gds_gbak_mode_req                    = 336331031L;
const GDS_LONG gds_gsec_cant_open_db                = 336723983L;
const GDS_LONG gds_gsec_switches_error              = 336723984L;
const GDS_LONG gds_gsec_no_op_spec                  = 336723985L;
const GDS_LONG gds_gsec_no_usr_name                 = 336723986L;
const GDS_LONG gds_gsec_err_add                     = 336723987L;
const GDS_LONG gds_gsec_err_modify                  = 336723988L;
const GDS_LONG gds_gsec_err_find_mod                = 336723989L;
const GDS_LONG gds_gsec_err_rec_not_found           = 336723990L;
const GDS_LONG gds_gsec_err_delete                  = 336723991L;
const GDS_LONG gds_gsec_err_find_del                = 336723992L;
const GDS_LONG gds_gsec_err_find_disp               = 336723996L;
const GDS_LONG gds_gsec_inv_param                   = 336723997L;
const GDS_LONG gds_gsec_op_specified                = 336723998L;
const GDS_LONG gds_gsec_pw_specified                = 336723999L;
const GDS_LONG gds_gsec_uid_specified               = 336724000L;
const GDS_LONG gds_gsec_gid_specified               = 336724001L;
const GDS_LONG gds_gsec_proj_specified              = 336724002L;
const GDS_LONG gds_gsec_org_specified               = 336724003L;
const GDS_LONG gds_gsec_fname_specified             = 336724004L;
const GDS_LONG gds_gsec_mname_specified             = 336724005L;
const GDS_LONG gds_gsec_lname_specified             = 336724006L;
const GDS_LONG gds_gsec_inv_switch                  = 336724008L;
const GDS_LONG gds_gsec_amb_switch                  = 336724009L;
const GDS_LONG gds_gsec_no_op_specified             = 336724010L;
const GDS_LONG gds_gsec_params_not_allowed          = 336724011L;
const GDS_LONG gds_gsec_incompat_switch             = 336724012L;
const GDS_LONG gds_gsec_inv_username                = 336724044L;
const GDS_LONG gds_gsec_inv_pw_length               = 336724045L;
const GDS_LONG gds_gsec_db_specified                = 336724046L;
const GDS_LONG gds_gsec_db_admin_specified          = 336724047L;
const GDS_LONG gds_gsec_db_admin_pw_specified       = 336724048L;
const GDS_LONG gds_gsec_sql_role_specified          = 336724049L;
const GDS_LONG gds_license_no_file                  = 336789504L;
const GDS_LONG gds_license_op_specified             = 336789523L;
const GDS_LONG gds_license_op_missing               = 336789524L;
const GDS_LONG gds_license_inv_switch               = 336789525L;
const GDS_LONG gds_license_inv_switch_combo         = 336789526L;
const GDS_LONG gds_license_inv_op_combo             = 336789527L;
const GDS_LONG gds_license_amb_switch               = 336789528L;
const GDS_LONG gds_license_inv_parameter            = 336789529L;
const GDS_LONG gds_license_param_specified          = 336789530L;
const GDS_LONG gds_license_param_req                = 336789531L;
const GDS_LONG gds_license_syntx_error              = 336789532L;
const GDS_LONG gds_license_dup_id                   = 336789534L;
const GDS_LONG gds_license_inv_id_key               = 336789535L;
const GDS_LONG gds_license_err_remove               = 336789536L;
const GDS_LONG gds_license_err_update               = 336789537L;
const GDS_LONG gds_license_err_convert              = 336789538L;
const GDS_LONG gds_license_err_unk                  = 336789539L;
const GDS_LONG gds_license_svc_err_add              = 336789540L;
const GDS_LONG gds_license_svc_err_remove           = 336789541L;
const GDS_LONG gds_license_eval_exists              = 336789563L;
const GDS_LONG gds_gstat_unknown_switch             = 336920577L;
const GDS_LONG gds_gstat_retry                      = 336920578L;
const GDS_LONG gds_gstat_wrong_ods                  = 336920579L;
const GDS_LONG gds_gstat_unexpected_eof             = 336920580L;
const GDS_LONG gds_gstat_open_err                   = 336920605L;
const GDS_LONG gds_gstat_read_err                   = 336920606L;
const GDS_LONG gds_gstat_sysmemex                   = 336920607L;

const GDS_LONG gds_err_max                          = 699L;


#endif

#undef GDS_LONG


/**********************************************/
/* Dynamic Data Definition Language operators */
/**********************************************/

/******************/
/* Version number */
/******************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_version_1                 1
#define gds__dyn_eoc                       -1

#else					/* c++ definitions */

const char gds_dyn_version_1             = 1;
const char gds_dyn_eoc                   = -1;

#endif

/******************************/
/* Operations (may be nested) */
/******************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_begin                     2
#define gds__dyn_end                       3
#define gds__dyn_if                        4
#define gds__dyn_def_database              5
#define gds__dyn_def_global_fld            6
#define gds__dyn_def_local_fld             7
#define gds__dyn_def_idx                   8
#define gds__dyn_def_rel                   9
#define gds__dyn_def_sql_fld               10
#define gds__dyn_def_view                  12
#define gds__dyn_def_trigger               15
#define gds__dyn_def_security_class        120
#define gds__dyn_def_dimension             140
#define gds__dyn_def_generator             24
#define gds__dyn_def_function              25
#define gds__dyn_def_filter                26
#define gds__dyn_def_function_arg          27
#define gds__dyn_def_shadow                34
#define gds__dyn_def_trigger_msg           17
#define gds__dyn_def_file                  36
#define gds__dyn_mod_database              39
#define gds__dyn_mod_rel                   11
#define gds__dyn_mod_global_fld            13
#define gds__dyn_mod_idx                   102
#define gds__dyn_mod_local_fld             14
#define gds__dyn_mod_view                  16
#define gds__dyn_mod_security_class        122
#define gds__dyn_mod_trigger               113
#define gds__dyn_mod_trigger_msg           28
#define gds__dyn_delete_database           18
#define gds__dyn_delete_rel                19
#define gds__dyn_delete_global_fld         20
#define gds__dyn_delete_local_fld          21
#define gds__dyn_delete_idx                22
#define gds__dyn_delete_security_class     123
#define gds__dyn_delete_dimensions         143
#define gds__dyn_delete_trigger            23
#define gds__dyn_delete_trigger_msg        29
#define gds__dyn_delete_filter             32
#define gds__dyn_delete_function           33
#define gds__dyn_delete_shadow             35
#define gds__dyn_grant                     30
#define gds__dyn_revoke                    31
#define gds__dyn_def_primary_key           37
#define gds__dyn_def_foreign_key           38
#define gds__dyn_def_unique                40
#define gds__dyn_def_procedure             164
#define gds__dyn_delete_procedure          165
#define gds__dyn_def_parameter             135
#define gds__dyn_delete_parameter          136
#define gds__dyn_mod_procedure             175
#define gds__dyn_def_log_file              176
#define gds__dyn_def_cache_file            180
#define gds__dyn_def_exception             181
#define gds__dyn_mod_exception             182
#define gds__dyn_del_exception             183
#define gds__dyn_drop_log                  194
#define gds__dyn_drop_cache                195
#define gds__dyn_def_default_log           202

#else					/* c++ definitions */

const char gds_dyn_begin                   = 2;
const char gds_dyn_end                     = 3;
const char gds_dyn_if                      = 4;
const char gds_dyn_def_database            = 5;
const char gds_dyn_def_global_fld          = 6;
const char gds_dyn_def_local_fld           = 7;
const char gds_dyn_def_idx                 = 8;
const char gds_dyn_def_rel                 = 9;
const char gds_dyn_def_sql_fld             = 10;
const char gds_dyn_def_view                = 12;
const char gds_dyn_def_trigger             = 15;
const char gds_dyn_def_security_class      = 120;
const char gds_dyn_def_dimension           = 140;
const char gds_dyn_def_generator           = 24;
const char gds_dyn_def_function            = 25;
const char gds_dyn_def_filter              = 26;
const char gds_dyn_def_function_arg        = 27;
const char gds_dyn_def_shadow              = 34;
const char gds_dyn_def_trigger_msg         = 17;
const char gds_dyn_def_file                = 36;
const char gds_dyn_mod_database            = 39;
const char gds_dyn_mod_rel                 = 11;
const char gds_dyn_mod_global_fld          = 13;
const char gds_dyn_mod_idx                 = 102;
const char gds_dyn_mod_local_fld           = 14;
const char gds_dyn_mod_view                = 16;
const char gds_dyn_mod_security_class      = 122;
const char gds_dyn_mod_trigger             = 113;
const char gds_dyn_mod_trigger_msg         = 28;
const char gds_dyn_delete_database         = 18;
const char gds_dyn_delete_rel              = 19;
const char gds_dyn_delete_global_fld       = 20;
const char gds_dyn_delete_local_fld        = 21;
const char gds_dyn_delete_idx              = 22;
const char gds_dyn_delete_security_class   = 123;
const char gds_dyn_delete_dimensions       = 143;
const char gds_dyn_delete_trigger          = 23;
const char gds_dyn_delete_trigger_msg      = 29;
const char gds_dyn_delete_filter           = 32;
const char gds_dyn_delete_function         = 33;
const char gds_dyn_delete_shadow           = 35;
const char gds_dyn_grant                   = 30;
const char gds_dyn_revoke                  = 31;
const char gds_dyn_def_primary_key         = 37;
const char gds_dyn_def_foreign_key         = 38;
const char gds_dyn_def_unique              = 40;
const char gds_dyn_def_procedure           = 164;
const char gds_dyn_delete_procedure        = 165;
const char gds_dyn_def_parameter           = 135;
const char gds_dyn_delete_parameter        = 136;
const char gds_dyn_mod_procedure           = 175;
const char gds_dyn_def_log_file            = 176;
const char gds_dyn_def_cache_file          = 180;
const char gds_dyn_def_exception           = 181;
const char gds_dyn_mod_exception           = 182;
const char gds_dyn_del_exception           = 183;
const char gds_dyn_drop_log                = 194;
const char gds_dyn_drop_cache              = 195;
const char gds_dyn_def_default_log         = 202;

#endif



/***********************/
/* View specific stuff */
/***********************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_view_blr                  43
#define gds__dyn_view_source               44
#define gds__dyn_view_relation             45
#define gds__dyn_view_context              46
#define gds__dyn_view_context_name         47

#else					/* c++ definitions */

const char gds_dyn_view_blr                = 43;
const char gds_dyn_view_source             = 44;
const char gds_dyn_view_relation           = 45;
const char gds_dyn_view_context            = 46;
const char gds_dyn_view_context_name       = 47;

#endif

/**********************/
/* Generic attributes */
/**********************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_rel_name                  50
#define gds__dyn_fld_name                  51
#define gds__dyn_idx_name                  52
#define gds__dyn_description               53
#define gds__dyn_security_class            54
#define gds__dyn_system_flag               55
#define gds__dyn_update_flag               56
#define gds__dyn_prc_name                  166
#define gds__dyn_prm_name                  137
#define gds__dyn_sql_object                196
#define gds__dyn_fld_character_set_name    174

#else					/* c++ definitions */

const char gds_dyn_rel_name                = 50;
const char gds_dyn_fld_name                = 51;
const char gds_dyn_idx_name                = 52;
const char gds_dyn_description             = 53;
const char gds_dyn_security_class          = 54;
const char gds_dyn_system_flag             = 55;
const char gds_dyn_update_flag             = 56;
const char gds_dyn_prc_name                = 166;
const char gds_dyn_prm_name                = 137;
const char gds_dyn_fld_character_set_name  = 174;

#endif

/********************************/
/* Relation specific attributes */
/********************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_rel_dbkey_length          61
#define gds__dyn_rel_store_trig            62
#define gds__dyn_rel_modify_trig           63
#define gds__dyn_rel_erase_trig            64
#define gds__dyn_rel_store_trig_source     65
#define gds__dyn_rel_modify_trig_source    66
#define gds__dyn_rel_erase_trig_source     67
#define gds__dyn_rel_ext_file              68
#define gds__dyn_rel_sql_protection        69
#define gds__dyn_rel_constraint            162
#define gds__dyn_delete_rel_constraint     163

#else					/* c++ definitions */

const char gds_dyn_rel_dbkey_length        = 61;
const char gds_dyn_rel_store_trig          = 62;
const char gds_dyn_rel_modify_trig         = 63;
const char gds_dyn_rel_erase_trig          = 64;
const char gds_dyn_rel_store_trig_source   = 65;
const char gds_dyn_rel_modify_trig_source  = 66;
const char gds_dyn_rel_erase_trig_source   = 67;
const char gds_dyn_rel_ext_file            = 68;
const char gds_dyn_rel_sql_protection      = 69;
const char gds_dyn_rel_constraint          = 162;
const char gds_dyn_delete_rel_constraint   = 163;

#endif


/************************************/
/* Global field specific attributes */
/************************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_fld_type                  70
#define gds__dyn_fld_length                71
#define gds__dyn_fld_scale                 72
#define gds__dyn_fld_sub_type              73
#define gds__dyn_fld_segment_length        74
#define gds__dyn_fld_query_header          75
#define gds__dyn_fld_edit_string           76
#define gds__dyn_fld_validation_blr        77
#define gds__dyn_fld_validation_source     78
#define gds__dyn_fld_computed_blr          79
#define gds__dyn_fld_computed_source       80
#define gds__dyn_fld_missing_value         81
#define gds__dyn_fld_default_value         82
#define gds__dyn_fld_query_name            83
#define gds__dyn_fld_dimensions            84
#define gds__dyn_fld_not_null              85
#define gds__dyn_fld_char_length           172
#define gds__dyn_fld_collation             173
#define gds__dyn_fld_default_source        193
#define gds__dyn_del_default               197
#define gds__dyn_del_validation            198
#define gds__dyn_single_validation         199
#define gds__dyn_fld_character_set         203

#else					/* c++ definitions */

const char gds_dyn_fld_type                = 70;
const char gds_dyn_fld_length              = 71;
const char gds_dyn_fld_scale               = 72;
const char gds_dyn_fld_sub_type            = 73;
const char gds_dyn_fld_segment_length      = 74;
const char gds_dyn_fld_query_header        = 75;
const char gds_dyn_fld_edit_string         = 76;
const char gds_dyn_fld_validation_blr      = 77;
const char gds_dyn_fld_validation_source   = 78;
const char gds_dyn_fld_computed_blr        = 79;
const char gds_dyn_fld_computed_source     = 80;
const char gds_dyn_fld_missing_value       = 81;
const char gds_dyn_fld_default_value       = 82;
const char gds_dyn_fld_query_name          = 83;
const char gds_dyn_fld_dimensions          = 84;
const char gds_dyn_fld_not_null            = 85;
const char gds_dyn_fld_char_length         = 172;
const char gds_dyn_fld_collation           = 173;
const char gds_dyn_fld_default_source      = 193;
const char gds_dyn_del_default             = 197;
const char gds_dyn_del_validation          = 198;
const char gds_dyn_single_validation       = 199;
const char gds_dyn_fld_character_set       = 203;

#endif


/***********************************/
/* Local field specific attributes */
/***********************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_fld_source                90
#define gds__dyn_fld_base_fld              91
#define gds__dyn_fld_position              92
#define gds__dyn_fld_update_flag           93

#else					/* c++ definitions */

const char gds_dyn_fld_source              = 90;
const char gds_dyn_fld_base_fld            = 91;
const char gds_dyn_fld_position            = 92;
const char gds_dyn_fld_update_flag         = 93;

#endif


/*****************************/
/* Index specific attributes */
/*****************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_idx_unique                100
#define gds__dyn_idx_inactive              101
#define gds__dyn_idx_type                  103
#define gds__dyn_idx_foreign_key           104
#define gds__dyn_idx_ref_column            105
#define gds__dyn_idx_statistic		   204

#else					/* c++ definitions */

const char gds_dyn_idx_unique              = 100;
const char gds_dyn_idx_inactive            = 101;
const char gds_dyn_idx_type                = 103;
const char gds_dyn_idx_foreign_key         = 104;
const char gds_dyn_idx_ref_column          = 105;
const char gds_dyn_idx_statistic	   = 204;

#endif


/*******************************/
/* Trigger specific attributes */
/*******************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_trg_type                  110
#define gds__dyn_trg_blr                   111
#define gds__dyn_trg_source                112
#define gds__dyn_trg_name                  114
#define gds__dyn_trg_sequence              115
#define gds__dyn_trg_inactive              116
#define gds__dyn_trg_msg_number            117
#define gds__dyn_trg_msg                   118

#else					/* c++ definitions */

const char gds_dyn_trg_type                = 110;
const char gds_dyn_trg_blr                 = 111;
const char gds_dyn_trg_source              = 112;
const char gds_dyn_trg_name                = 114;
const char gds_dyn_trg_sequence            = 115;
const char gds_dyn_trg_inactive            = 116;
const char gds_dyn_trg_msg_number          = 117;
const char gds_dyn_trg_msg                 = 118;

#endif


/**************************************/
/* Security Class specific attributes */
/**************************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_scl_acl                   121
#define gds__dyn_grant_user                130
#define gds__dyn_grant_proc                186
#define gds__dyn_grant_trig                187
#define gds__dyn_grant_view                188
#define gds__dyn_grant_options             132

#else					/* c++ definitions */

const char gds_dyn_scl_acl                 = 121;
const char gds_dyn_grant_user              = 130;
const char gds_dyn_grant_proc              = 186;
const char gds_dyn_grant_trig              = 187;
const char gds_dyn_grant_view              = 188;
const char gds_dyn_grant_options           = 132;

#endif


/**********************************/
/* Dimension specific information */
/**********************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_dim_lower                 141
#define gds__dyn_dim_upper                 142

#else					/* c++ definitions */

const char gds_dyn_dim_lower               = 141;
const char gds_dyn_dim_upper               = 142;

#endif


/****************************/
/* File specific attributes */
/****************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_file_name                 125
#define gds__dyn_file_start                126
#define gds__dyn_file_length               127
#define gds__dyn_shadow_number             128
#define gds__dyn_shadow_man_auto           129
#define gds__dyn_shadow_conditional        130

#else					/* c++ definitions */

const char gds_dyn_file_name               = 125;
const char gds_dyn_file_start              = 126;
const char gds_dyn_file_length             = 127;
const char gds_dyn_shadow_number           = 128;
const char gds_dyn_shadow_man_auto         = 129;
const char gds_dyn_shadow_conditional      = 130;

#endif

/********************************/
/* Log file specific attributes */
/********************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_log_file_sequence         177
#define gds__dyn_log_file_partitions       178
#define gds__dyn_log_file_serial           179
#define gds__dyn_log_file_overflow         200
#define gds__dyn_log_file_raw		   201

#else					/* c++ definitions */

const char gds_dyn_log_file_sequence       = 177;
const char gds_dyn_log_file_partitions     = 178;
const char gds_dyn_log_file_serial         = 179;
const char gds_dyn_log_file_overflow       = 200;
const char gds_dyn_log_file_raw		   = 201;

#endif


/***************************/
/* Log specific attributes */
/***************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_log_group_commit_wait     189 
#define gds__dyn_log_buffer_size           190
#define gds__dyn_log_check_point_length    191
#define gds__dyn_log_num_of_buffers        192

#else					/* c++ definitions */

const char gds_dyn_log_group_commit_wait  = 189;
const char gds_dyn_log_buffer_size        = 190;
const char gds_dyn_log_check_point_length = 191;
const char gds_dyn_log_num_of_buffers     = 192;

#endif

/********************************/
/* Function specific attributes */
/********************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_function_name             145
#define gds__dyn_function_type             146
#define gds__dyn_func_module_name          147
#define gds__dyn_func_entry_point          148
#define gds__dyn_func_return_argument      149
#define gds__dyn_func_arg_position         150
#define gds__dyn_func_mechanism            151
#define gds__dyn_filter_in_subtype         152
#define gds__dyn_filter_out_subtype        153

#else					/* c++ definitions */

const char gds_dyn_function_name           = 145;
const char gds_dyn_function_type           = 146;
const char gds_dyn_func_module_name        = 147;
const char gds_dyn_func_entry_point        = 148;
const char gds_dyn_func_return_argument    = 149;
const char gds_dyn_func_arg_position       = 150;
const char gds_dyn_func_mechanism          = 151;
const char gds_dyn_filter_in_subtype       = 152;
const char gds_dyn_filter_out_subtype      = 153;

#endif


#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_description2		   154	
#define gds__dyn_fld_computed_source2	   155	
#define gds__dyn_fld_edit_string2	   156
#define gds__dyn_fld_query_header2	   157
#define gds__dyn_fld_validation_source2    158
#define gds__dyn_trg_msg2	   	   159
#define gds__dyn_trg_source2	   	   160
#define gds__dyn_view_source2		   161
#define gds__dyn_xcp_msg2                  184

#else					/* c++ definitions */

const char gds_dyn_description2	           = 154;
const char gds_dyn_fld_computed_source2    = 155;
const char gds_dyn_fld_edit_string2	   = 156;
const char gds_dyn_fld_query_header2	   = 157;
const char gds_dyn_fld_validation_source2  = 158;
const char gds_dyn_trg_msg2	   	   = 159;
const char gds_dyn_trg_source2	   	   = 160;
const char gds_dyn_view_source2	           = 161;
const char gds_dyn_xcp_msg2                = 184;

#endif



/*********************************/
/* Generator specific attributes */
/*********************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_generator_name            95
#define gds__dyn_generator_id              96

#else					/* c++ definitions */

const char gds_dyn_generator_name          = 95;
const char gds_dyn_generator_id            = 96;

#endif


/*********************************/
/* Procedure specific attributes */
/*********************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_prc_inputs                167
#define gds__dyn_prc_outputs               168
#define gds__dyn_prc_source                169
#define gds__dyn_prc_blr                   170
#define gds__dyn_prc_source2               171

#else					/* c++ definitions */

const char gds_dyn_prc_inputs             = 167;
const char gds_dyn_prc_outputs            = 168;
const char gds_dyn_prc_source             = 169;
const char gds_dyn_prc_blr                = 170;
const char gds_dyn_prc_source2            = 171;

#endif


/*********************************/
/* Parameter specific attributes */
/*********************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__dyn_prm_number                138
#define gds__dyn_prm_type                  139

#else					/* c++ definitions */

const char gds_dyn_prm_number             = 138;
const char gds_dyn_prm_type               = 139;

#endif

/********************************/
/* Relation specific attributes */
/********************************/

#ifndef       __cplusplus                /* c definitions */

#define gds__dyn_xcp_msg                   185

#else                                    /* c++ definitions */

const char gds_dyn_xcp_msg               = 185;

#endif


/**********************************************/
/* Cascading referential integrity values     */
/**********************************************/
#ifndef __cplusplus                     /* c definitions */

#define gds__dyn_foreign_key_update        205
#define gds__dyn_foreign_key_delete        206
#define gds__dyn_foreign_key_cascade       207
#define gds__dyn_foreign_key_default       208
#define gds__dyn_foreign_key_null          209
#define gds__dyn_foreign_key_none          210

#else                                   /* c++ definitions */

const gds__dyn_foreign_key_update          = 205;
const gds__dyn_foreign_key_delete          = 206;
const gds__dyn_foreign_key_cascade         = 207;
const gds__dyn_foreign_key_default         = 208;
const gds__dyn_foreign_key_null            = 209;
const gds__dyn_foreign_key_none            = 210;

#endif


/****************************/
/* Last $dyn value assigned */
/****************************/

/* CVC: This is not the last value! Please read ibase.h
where the saga continues.

#ifndef	__cplusplus	  		c definitions

#define gds__dyn_last_dyn_value            210

#else					c++ definitions

const char gds_dyn_last_dyn_value          = 210;

#endif
*/


/******************************************/
/* Array slice description language (SDL) */
/******************************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__sdl_version1                  1
#define gds__sdl_eoc                       -1
#define gds__sdl_relation                  2
#define gds__sdl_rid                       3
#define gds__sdl_field                     4
#define gds__sdl_fid                       5
#define gds__sdl_struct                    6
#define gds__sdl_variable                  7
#define gds__sdl_scalar                    8
#define gds__sdl_tiny_integer              9
#define gds__sdl_short_integer             10
#define gds__sdl_long_integer              11
#define gds__sdl_literal                   12
#define gds__sdl_add                       13
#define gds__sdl_subtract                  14
#define gds__sdl_multiply                  15
#define gds__sdl_divide                    16
#define gds__sdl_negate                    17
#define gds__sdl_eql                       18
#define gds__sdl_neq                       19
#define gds__sdl_gtr                       20
#define gds__sdl_geq                       21
#define gds__sdl_lss                       22
#define gds__sdl_leq                       23
#define gds__sdl_and                       24
#define gds__sdl_or                        25
#define gds__sdl_not                       26
#define gds__sdl_while                     27
#define gds__sdl_assignment                28
#define gds__sdl_label                     29
#define gds__sdl_leave                     30
#define gds__sdl_begin                     31
#define gds__sdl_end                       32
#define gds__sdl_do3                       33
#define gds__sdl_do2                       34
#define gds__sdl_do1                       35
#define gds__sdl_element                   36

#else					/* c++ definitions */

const char gds_sdl_version1                = 1;
const char gds_sdl_eoc                     = -1;
const char gds_sdl_relation                = 2;
const char gds_sdl_rid                     = 3;
const char gds_sdl_field                   = 4;
const char gds_sdl_fid                     = 5;
const char gds_sdl_struct                  = 6;
const char gds_sdl_variable                = 7;
const char gds_sdl_scalar                  = 8;
const char gds_sdl_tiny_integer            = 9;
const char gds_sdl_short_integer           = 10;
const char gds_sdl_long_integer            = 11;
const char gds_sdl_literal                 = 12;
const char gds_sdl_add                     = 13;
const char gds_sdl_subtract                = 14;
const char gds_sdl_multiply                = 15;
const char gds_sdl_divide                  = 16;
const char gds_sdl_negate                  = 17;
const char gds_sdl_eql                     = 18;
const char gds_sdl_neq                     = 19;
const char gds_sdl_gtr                     = 20;
const char gds_sdl_geq                     = 21;
const char gds_sdl_lss                     = 22;
const char gds_sdl_leq                     = 23;
const char gds_sdl_and                     = 24;
const char gds_sdl_or                      = 25;
const char gds_sdl_not                     = 26;
const char gds_sdl_while                   = 27;
const char gds_sdl_assignment              = 28;
const char gds_sdl_label                   = 29;
const char gds_sdl_leave                   = 30;
const char gds_sdl_begin                   = 31;
const char gds_sdl_end                     = 32;
const char gds_sdl_do3                     = 33;
const char gds_sdl_do2                     = 34;
const char gds_sdl_do1                     = 35;
const char gds_sdl_element                 = 36;

#endif


/********************************************/
/* International text interpretation values */
/********************************************/

#ifndef	__cplusplus			/* c definitions */

#define gds__interp_eng_ascii              0
#define gds__interp_jpn_sjis               5
#define gds__interp_jpn_euc                6

#else					/* c++ definitions */

const char gds_interp_eng_ascii          =  0;
const char gds_interp_jpn_sjis           =  5;
const char gds_interp_jpn_euc            =  6;

#endif


/*****************************/
/* Forms Package definitions */
/*****************************/

/************************************/
/* Map definition block definitions */
/************************************/

#ifndef	__cplusplus			/* c definitions */

#define PYXIS__MAP_VERSION1                1
#define PYXIS__MAP_FIELD2                  2
#define PYXIS__MAP_FIELD1                  3
#define PYXIS__MAP_MESSAGE                 4
#define PYXIS__MAP_TERMINATOR              5
#define PYXIS__MAP_TERMINATING_FIELD       6
#define PYXIS__MAP_OPAQUE                  7
#define PYXIS__MAP_TRANSPARENT             8
#define PYXIS__MAP_TAG                     9
#define PYXIS__MAP_SUB_FORM                10
#define PYXIS__MAP_ITEM_INDEX              11
#define PYXIS__MAP_SUB_FIELD               12
#define PYXIS__MAP_END                     -1

#else					/* c++ definitions */

const char PYXIS_MAP_VERSION1              = 1;
const char PYXIS_MAP_FIELD2                = 2;
const char PYXIS_MAP_FIELD1                = 3;
const char PYXIS_MAP_MESSAGE               = 4;
const char PYXIS_MAP_TERMINATOR            = 5;
const char PYXIS_MAP_TERMINATING_FIELD     = 6;
const char PYXIS_MAP_OPAQUE                = 7;
const char PYXIS_MAP_TRANSPARENT           = 8;
const char PYXIS_MAP_TAG                   = 9;
const char PYXIS_MAP_SUB_FORM              = 10;
const char PYXIS_MAP_ITEM_INDEX            = 11;
const char PYXIS_MAP_SUB_FIELD             = 12;
const char PYXIS_MAP_END                   = -1;

#endif


/******************************************/
/* Field option flags for display options */
/******************************************/

#ifndef	__cplusplus			/* c definitions */

#define PYXIS__OPT_DISPLAY                 1
#define PYXIS__OPT_UPDATE                  2
#define PYXIS__OPT_WAKEUP                  4
#define PYXIS__OPT_POSITION                8

#else					/* c++ definitions */

const char PYXIS_OPT_DISPLAY               = 1;
const char PYXIS_OPT_UPDATE                = 2;
const char PYXIS_OPT_WAKEUP                = 4;
const char PYXIS_OPT_POSITION              = 8;

#endif


/*****************************************/
/* Field option values following display */
/*****************************************/

#ifndef	__cplusplus			/* c definitions */

#define PYXIS__OPT_NULL                    1
#define PYXIS__OPT_DEFAULT                 2
#define PYXIS__OPT_INITIAL                 3
#define PYXIS__OPT_USER_DATA               4

#else					/* c++ definitions */

const char PYXIS_OPT_NULL                  = 1;
const char PYXIS_OPT_DEFAULT               = 2;
const char PYXIS_OPT_INITIAL               = 3;
const char PYXIS_OPT_USER_DATA             = 4;

#endif


/**************************/
/* Pseudo key definitions */
/**************************/

#ifndef	__cplusplus			/* c definitions */

#define PYXIS__KEY_DELETE                  127
#define PYXIS__KEY_UP                      128
#define PYXIS__KEY_DOWN                    129
#define PYXIS__KEY_RIGHT                   130
#define PYXIS__KEY_LEFT                    131
#define PYXIS__KEY_PF1                     132
#define PYXIS__KEY_PF2                     133
#define PYXIS__KEY_PF3                     134
#define PYXIS__KEY_PF4                     135
#define PYXIS__KEY_PF5                     136
#define PYXIS__KEY_PF6                     137
#define PYXIS__KEY_PF7                     138
#define PYXIS__KEY_PF8                     139
#define PYXIS__KEY_PF9                     140
#define PYXIS__KEY_ENTER                   141
#define PYXIS__KEY_SCROLL_TOP              146
#define PYXIS__KEY_SCROLL_BOTTOM           147

#else					/* c++ definitions */

const char PYXIS_KEY_DELETE                = 127;
const char PYXIS_KEY_UP                    = 128;
const char PYXIS_KEY_DOWN                  = 129;
const char PYXIS_KEY_RIGHT                 = 130;
const char PYXIS_KEY_LEFT                  = 131;
const char PYXIS_KEY_PF1                   = 132;
const char PYXIS_KEY_PF2                   = 133;
const char PYXIS_KEY_PF3                   = 134;
const char PYXIS_KEY_PF4                   = 135;
const char PYXIS_KEY_PF5                   = 136;
const char PYXIS_KEY_PF6                   = 137;
const char PYXIS_KEY_PF7                   = 138;
const char PYXIS_KEY_PF8                   = 139;
const char PYXIS_KEY_PF9                   = 140;
const char PYXIS_KEY_ENTER                 = 141;
const char PYXIS_KEY_SCROLL_TOP            = 146;
const char PYXIS_KEY_SCROLL_BOTTOM         = 147;

#endif


/*************************/
/* Menu definition stuff */
/*************************/

#ifndef	__cplusplus			/* c definitions */

#define PYXIS__MENU_VERSION1               1
#define PYXIS__MENU_LABEL                  2
#define PYXIS__MENU_ENTREE                 3
#define PYXIS__MENU_OPAQUE                 4
#define PYXIS__MENU_TRANSPARENT            5
#define PYXIS__MENU_HORIZONTAL             6
#define PYXIS__MENU_VERTICAL               7
#define PYXIS__MENU_END                    -1

#else					/* c++ definitions */

const char PYXIS_MENU_VERSION1             = 1;
const char PYXIS_MENU_LABEL                = 2;
const char PYXIS_MENU_ENTREE               = 3;
const char PYXIS_MENU_OPAQUE               = 4;
const char PYXIS_MENU_TRANSPARENT          = 5;
const char PYXIS_MENU_HORIZONTAL           = 6;
const char PYXIS_MENU_VERTICAL             = 7;
const char PYXIS_MENU_END                  = -1;

#endif

#endif					/* _JRD_GDSOLD_H_ */
