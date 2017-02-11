unit URptThread;

interface

{$I stbasis.inc}

uses Classes;

type
  TRptThread=class(TThread)
  protected
    function CreateReport(const CheckPrior: Boolean=true): Boolean;virtual;
  public
    constructor Create;dynamic;
    destructor Destroy;override;
  end;

  TRptExcelThread=class(TRptThread)
  public
    
    function CreateReport(const CheckPrior: Boolean=true): Boolean;override;
  end;

  TRptWordThread=class(TRptThread)
  public
    Word: OleVariant;
    function CreateReport(const CheckPrior: Boolean=true): Boolean;override;
  end;

threadvar
  Excel: OleVariant;
    
implementation

uses Windows, Forms, Controls, SysUtils, UMainUnited, comobj;

{ TRptThread }


function TRptWordThread.CreateReport(const CheckPrior: Boolean=true): Boolean;

  function CreateAndPrepairReport: Boolean;
  begin
   Screen.Cursor:=crHourGlass;
   try
    result:=false;
    try
     VarClear(Word);
     Word:=CreateOleObject(ConstWordOle);
     result:=not VarIsEmpty(Word);
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

  function PrepairReport: Boolean;
  begin
   Screen.Cursor:=crHourGlass;
   try
    try
     Word:=GetActiveOleObject(ConstWordOle);
     result:=not VarIsEmpty(Word);
    except
     on E: Exception do begin
       if E.Message=ConstMesOperationInaccessible then
        result:=CreateAndPrepairReport
       else if E.Message=ConstMesCallingWasDeclined then
        result:=CreateAndPrepairReport
       else begin
         Result:=False;
         {$IFDEF DEBUG} Assert(false,E.message); {$ENDIF}
       end;
     end;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

begin
 Result:=false;
 try
   if CheckPrior then
     Result:=PrepairReport
   else Result:=CreateAndPrepairReport;
   if Result then  Word:=Word.Application;
 except
  ShowErrorEx(ConstWordNotFound);
 end;
end;

constructor TRptThread.Create;
begin
  Priority:=tpNormal;
  inherited Create(true);
end;

destructor TRptThread.Destroy;
begin
  TerminateThread(Handle,0);
  inherited Destroy;
end;

function TRptThread.CreateReport(const CheckPrior: Boolean=true): Boolean;
begin
  Result:=false;
end;

{ TRptExcelThread }

function TRptExcelThread.CreateReport(const CheckPrior: Boolean=true): Boolean;

  function CreateAndPrepairReport: Boolean;
  begin
   Screen.Cursor:=crHourGlass;
   try
    result:=false;
    try
     VarClear(Excel);
     Excel:=CreateOleObject(ConstExcelOle);
     result:=not VarIsEmpty(Excel);
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

  function PrepairReport: Boolean;
  begin
   Screen.Cursor:=crHourGlass;
   try
    try
     Excel:=GetActiveOleObject(ConstExcelOle);
     result:=not VarIsEmpty(Excel);
    except
     on E: Exception do begin
       if E.Message=ConstMesOperationInaccessible then
        result:=CreateAndPrepairReport
       else if E.Message=ConstMesCallingWasDeclined then
        result:=CreateAndPrepairReport
       else begin
         Result:=False;
         {$IFDEF DEBUG} Assert(false,E.message); {$ENDIF}
       end;
     end;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

begin
 Result:=false;
 try
   if CheckPrior then
     Result:=PrepairReport
   else Result:=CreateAndPrepairReport;
   if Result then
     Excel:=Excel.Application;
 except
  ShowErrorEx(ConstExcelNotFound);
 end;
//   Excel:=Excel;
end;


end.
