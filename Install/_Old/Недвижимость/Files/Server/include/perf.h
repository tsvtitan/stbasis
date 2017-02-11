/*
 *	PROGRAM:	JRD Access Method
 *	MODULE:		perf.h
 *	DESCRIPTION:	Peformance tool block
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

#ifdef VMS
#define NOTIME
#endif
#if (defined (_MSC_VER) && defined (WIN32)) || (defined (__BORLANDC__) && defined (__WIN32__))
#define NOTIME
#endif
#if defined (NETWARE_386) || defined (PC_PLATFORM)
#define NOTIME
#endif
#if defined (__OS2__)
#define NOTIME
#endif

#ifdef LINUX
#include <libio.h>
#endif

#ifndef NOTIME
#include <sys/types.h>
#include <sys/times.h>
#else
#ifdef VMS
#include <types.h>
#else
#include <sys/types.h>
#endif

/*
 * Structure returned by times()
 */
struct tms {
    time_t	tms_utime;		/* user time */
    time_t	tms_stime;		/* system time */
    time_t	tms_cutime;		/* user time, children */
    time_t	tms_cstime;		/* system time, children */
};

#ifdef NETWARE_386
#undef NULL
#include <sys/time.h>
struct timezon {
    int		tz_minuteswest;
    int		tz_dsttime;
};
#endif

#endif

typedef struct perf {
    long	perf_fetches;
    long	perf_marks;
    long	perf_reads;
    long	perf_writes;
    long	perf_current_memory;
    long	perf_max_memory;
    long	perf_buffers;
    long	perf_page_size;
    long	perf_elapsed;
    struct tms	perf_times;
} PERF;

/* Letter codes controlling printing of statistics:

	!f - fetches
	!m - marks
	!r - reads
	!w - writes
	!e - elapsed time (in seconds)
	!u - user times
	!s - system time
	!p - page size
	!b - number buffers
	!d - delta memory
	!c - current memory
	!x - max memory

*/

#ifdef __cplusplus
extern "C" {

int ISC_EXPORT	perf_format (struct perf ISC_FAR *,
			     struct perf ISC_FAR *,
			     char ISC_FAR *,
			     char ISC_FAR *,
			     short ISC_FAR *);

void ISC_EXPORT perf_get_info (isc_db_handle ISC_FAR *,
			       struct perf ISC_FAR *);

void ISC_EXPORT perf_report (struct perf ISC_FAR *,
			     struct perf ISC_FAR *,
			     char ISC_FAR *,
			     short ISC_FAR *);

};
#endif

