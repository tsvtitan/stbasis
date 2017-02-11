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
*  z l u C o n t e x t H e l p
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description: This is an interface unit containing integer
*  mappings of Topic IDs (names of Help
*  Topics) which are located in ibconsole.rtf
*  This file is re-written by RoboHELP
*  whenever ibtools.rtf is saved.
*
*  However, the numeric values stored in
*  ibtools.hh are the 'master values' and if you
*  modify the value in ibtools.hh and then
*  save the ibtools.rtf again, this file will
*  reflect the changed values.
*
*
*****************************************************************
* Revisions:
*
*****************************************************************}

Unit zluContextHelp;
  Interface
    Const
      SQL_REFERENCE = 'sqlref.hlp';
      CONTEXT_HELP_FILE='ibconsole.hlp';
      INTERBASE_HELP_FILE='ib32.hlp';
      SERVER_SECURITY = 1;
      SERVER_LOGIN = 2;
      DATABASE_REGISTER = 3;
      SERVER_CERTIFICATES = 4;
      FEATURES_DIAGNOSTICS = 5;
      DATABASE_CREATE = 6;
      DATABASE_PROPERTIES = 7;
      DATABASE_ACTIVITY = 8;
      DATABASE_VALIDATION = 9;
      DATABASE_BACKUP = 10;
      DATABASE_RESTORE = 11;
      GENERAL_OVERVIEW = 12;
      GENERAL_PRINT = 13;
      GENERAL_PRINTER_SETUP = 14;
      GENERAL_EXIT = 15;
      EDITING_UNDO = 16;
      GENERAL_EDITING = 17;
      EDITING_FIND = 18;
      SERVER_REGISTER = 19;
      SERVER_UNREGISTER = 20;
      SERVER_LOGOUT = 21;
      SERVER_SERVER_LOG = 22;
      SERVER_ADMINISTRATION_LOG = 23;
      BACKUP_CONFIGURATION_REMOVE = 24;
      SERVER_PROPERTIES = 25;
      FAILPDF = 26;
      DATABASE_DROP = 27;
      DATABASE_UNREGISTER = 28;
      DATABASE_CONNECT = 29;
      DATABASE_DISCONNECT = 30;
      SCRIPTS_LOAD = 31;
      SCRIPTS_SAVE = 32;
      SCRIPTS_HISTORY = 33;
      SCRIPTS_SAVE_RESULTS = 34;
      TRANSACTIONS_ABOUT_COMMITTING = 35;
      GENERAL_SHORTCUTS = 36;
      DATABASE_SHUTDOWN = 37;
      DATABASE_RESTART = 38;
      DATABASE_SWEEP = 39;
      DATABASE_STATISTICS = 40;
      TRANSACTIONS_RECOVERY = 41;
      GENERAL_VIEW = 42;
      VIEW_FONT = 43;
      VIEW_REFRESH = 44;
      SCRIPTS_EXECUTE = 45;
      TRANSACTIONS_RECOVERY_DIALOG_BOX = 46;
      TRANSACTIONS_RECOVERY_ADVICE = 47;
      FEATURES_TREE = 48;
      FEATURES_INTERNAL_TEXT_VIEWER = 49;
      TOOLBARS_STANDARD = 50;
      TABS_SQL_SCRIPT = 51;
      TABS_SUMMARY = 52;
      TABS_DEFINITION = 53;
      TABS_DATA = 54;
      TABS_ISQL = 55;
      FEATURES_MAIN_STATUS_BAR = 56;
      TOOLBARS_ISQL = 57;
      BACKUP_CONFIGURATION_ABOUT = 58;
      TABS_ACTIONS = 59;
      GENERAL_PREFERENCES = 60;
      BACKUP_CONFIGURATION_PROPERTIES = 61;
      TOOLBARS_SERVER = 62;
      TOOLBARS_DATABASE = 63;
      GENERAL_ABSOLUTE_PATHS = 64;
      TOOLBARS_EDIT = 65;
      HOW_TO_ACCESS_DATA = 66;
      FEATURES_TOOLBARS = 67;
      TOOLBARS_GRAB_BAR = 68;
  Implementation
end.
