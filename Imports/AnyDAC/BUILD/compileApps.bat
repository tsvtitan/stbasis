@echo off
cls
if not exist History.txt cd ..

call Build\_compileAppSetup.bat

set apppath=TOOL\Administrator
set appname=ADAdministrator
call Build\_compileApp.bat

set apppath=TOOL\Executor
set appname=ADExecutor
call Build\_compileApp.bat

set apppath=TOOL\Explorer
set appname=ADExplorer
call Build\_compileApp.bat

if exist Build\_noIndy.txt goto :noindy
  set apppath=TOOL\Monitor
  set appname=ADMonitor
  call Build\_compileApp.bat
:noindy

set apppath=TOOL\Pump
set appname=ADPump
call Build\_compileApp.bat

set apppath=TOOL\QA
set appname=ADQA
call Build\_compileApp.bat

call Build\_compileDone.bat
