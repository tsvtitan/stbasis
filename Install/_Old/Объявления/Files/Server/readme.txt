
==================================
Firebird 1.0.2       (Win32 Build)
==================================


o Introduction
o Intended Users
o Bugs fixed in this release
o Installation
o Known Issues
o Reporting Bugs
o Requesting New Features


Introduction
============

Welcome to Firebird 1.0.2. This represents the latest bug-fix release
of the Firebird 1.0 series. The Release Notes document has details of 
all the new features and the bug-fixes in the original release of 
Firebird 1.0. 

There are no new features in this release.

There was no official Firebird 1.0.1 release for any platform except 
Mac OS X. That release was made to cater for an operating system upgrade.

This readme explains the bug-fixes that make up Firebird 1.0.2. 


Intended Users
==============

Overall we believe this release to be more stable and more reliable than ANY 
previous release of Firebird or InterBase 6.n. The initial release of Firebird 1.0
has seen around 200,000 downloads from the main Sourceforge site. As such there 
is no reason to be overly concerned about using this release in a production 
environment, especially as it contains no new features. However, before deploying 
ANY software into a production environment it should always be tested properly 
on a development system. This is standard practice.


Bugs fixed in this release (all platforms)
==========================================

The main bugs fixed are :

o There was problem with connection strings on Unix platforms that
  could lead to database corruption.

o 64-bit file i/o is now properly supported under Linux

o Table name aliases are now allowed in INSERT statements. 

o String expression evaluation now throws an error if the expression 
  could be greater than 64k. Previously an error was thrown if the 
  expression evaluated to a possible size of greater than 32k.

o Minor problems with Two-Phase commit were fixed.

o INT64 datatype now supported correctly in Arrays.

o SF Bug #545725 - internal connections to database now reported 
  as user.

o SF Bug #538201 - crash with extract from null date.

o SF Bug #534208 - select failed when udf was returning blob.

o SF Bug #533915 - Deferred work trashed the contents of 
  RDB$RUNTIME.

o SF Bug #526204 - GPRE Cobol Variable problems fixed.


Installing the self-installing executable
=========================================

Please run the executable and read the accompanying installation 
instructions that are contained within the setup wizard.


Known Issues
============

There are no known issues at this time. (05-Dec-2002). 
  

Reporting Bugs
==============

o Are you sure you understand how Firebird works?

  Perhaps you are seeing the correct behaviour and you really have a 
  support question. In this case contact the ib-support list server.
 
  You may subscribe here: 

    mailto:ib-support-subscribe@yahoogroups.com


o Still think it is a bug? 

  Check the list of Open Bugs. This can be found at

    http://prdownloads.sourceforge.net/firebird/Firebird_v1_OpenBugs.html

  An older version is contained in the doc directory of this release.

Otherwise, if you are reasonably sure it is a bug then please 
try to develop a reproducible test case. You can then submit it
to the Firebird bug tracker at:

  http://sourceforge.net/tracker/?atid=109028&group_id=9028&func=browse


Requesting New Features
=======================

Before submitting feature requests please review the existing 
feature request list. Chances are that someone has already thought 
of it. See this link for a current list:

  http://prdownloads.sourceforge.net/firebird/Firebird_v1_OpenFeatures.html

or look in the doc directory of this release for a slightly older version.

Feature requests should be submitted via:

  http://sourceforge.net/tracker/?atid=109028&group_id=9028&func=browse


