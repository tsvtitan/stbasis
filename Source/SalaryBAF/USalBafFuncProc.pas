unit USalBafFuncProc;

interface
Uses Windows, Forms, Classes, IBDatabase, UMainUnited, USalBafconst, SysUtils,
     Controls, graphics, UNewDbGrids, DBTree, comctrls;

//процедура вызова информации об библиотеке
procedure GetInfoLibrary_(P:PinfoLibrary); StdCall;
// вызов структуры меню из DLL
function GetListEntryRoot_: TList;stdcall;
//вызов форм из библиотеки
function ViewEntry_(TypeEntry: TTypeEntry; Params: Pointer;
                    isModal: Boolean; OnlyData: Boolean=false):Boolean;stdcall;
procedure RefreshEntryes_;stdcall;
// подключение DLL к приложению
procedure SetAppAndScreen_(A: TApplication; S: TScreen);stdcall;
// установление связи с базой данных
procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
procedure AfterSetOptions_(isOK: Boolean);stdcall;

//imports

function _ViewEntryFromMain(TypeEntry: TTypeEntry; Params: Pointer;
                     isModal: Boolean; OnlyData: Boolean=false):Boolean;stdcall;
                     external MainExe name ConstViewEntryFromMain;
procedure _FreeProgressBar(Handle: DWord);stdcall;
                         external MainExe name ConstFreeProgressBar;

procedure _SetSplashStatus(Status: Pchar);stdcall;
                         external MainExe name ConstSetSplashStatus;
procedure _SetProgressStatus(Handle: DWord; Progress: Integer);stdcall;
                         external MainExe name ConstSetProgressStatus;
function _CreateProgressBar(Min,Max: Integer;
                            Hint: PChar;
                            Color: TColor=clNavy;
                            List: TList=nil): DWord; stdcall;
                         external MainExe name ConstCreateProgressBar;


procedure InitAll;
procedure FreeCreatures;
procedure AddToListEntryRoot;
//procedure CheckPermissionInListEntryRoot(List: TList);
procedure ClearListEntryRoot(List: TList);
procedure ClearAndFreeLERoot(List: TList);
function GetIniFileName: String;

function CreateAndViewrptMemOrder5(Params: Pointer; isModal:Boolean):Boolean;

implementation
uses URptMemOrder5;

procedure InitAll;
begin
  AppOld:=Application;
  ScrOld:=screen;
  LERoot:=TList.create;
  AddToListEntryRoot;
//  CheckPermissionInListEntryRoot(LERoot);
end;

procedure FreeCreatures;
begin
  ClearAndFreeLERoot(LERoot);
  FreeAndNil(fmRptMemOrder5);
  Application:=AppOld;
  Screen:=ScrOld;
end;

procedure SetAppAndScreen_(A: TApplication; S: TScreen);stdcall;
begin
  Application:=A;
  Screen:=S;
end;


procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
               IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
begin
  IBDB:=IBDbase;
  IBT:=IBTran;
  IBDBSec:=IBDBSecurity;
  IBTSec:=IBTSecurity;
end;

function ViewEntry_(TypeEntry: TTypeEntry; Params: Pointer;
                    isModal: Boolean; OnlyData: Boolean=false):Boolean;stdcall;
begin
  Result:=false;
  case TypeEntry of
    tte_None:;
    tte_rptMemOrder5: CreateAndViewrptMemOrder5(Params,isModal);
  end;

end;

procedure AddToListEntryRoot;
var
  fi: TIniFile;

  procedure AddToList(ListConsist: TList; Name,Hint: Pchar;
                      tte: TTypeEntry; List: TList;
                      ImageIndex: Integer;
                      setttl: TSetTypeLib;
                      ShortCut: TShortCut);
  var
    P: PInfoMenu;
    bmp: TBitmap;
  begin
    new(P);
    FillChar(P^,SizeOf(TInfoMenu),0);
    P.Name:=Name;
    P.Hint:=Hint;
    P.TypeEntry:=tte;
    P.List:=List;
    P.Bitmap:=nil;
    P.Proc:=nil;
    P.ShortCut:=fi.ReadInteger(ConstSectionShortCut,ConstTypeEntry+
      Inttostr(Integer(tte)),ShortCut);
    if ImageIndex>-1 then begin
     {bmp:=TBitmap.Create;
     bmp.Assign(nil);
     bmp.Width:=dm.Il.Width;
     bmp.Height:=dm.Il.Height;
     dm.Il.draw(bmp.Canvas,0,0,ImageIndex,true);
     P.Bitmap:=bmp;}
    end;
    P.TypeLib:=setttl;
    ListConsist.Add(P);
  end;

var
  L1: TList;
begin
  try
    fi:=nil;
    L1:=TList.Create;
    try
      fi:=TIniFile.Create(_GetIniFileName);
      AddToList(LERoot,ConstsMenuRptSalary,'',tte_None,L1,-1,[ttlReports],0);
      AddToList(L1,'Мемориальный ордер 5',NameMemOrder5,tte_rptMemOrder5,nil,-1,
        [ttlReports],0);
    finally
      fi.free;
    end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure ClearListEntryRoot(List: TList);
var
  i: Integer;
  P: PInfoMenu;
  fi: TIniFile;
begin
 try
  fi:=nil;
  try
   fi:=TIniFile.Create(GetIniFileName);
   if List=nil then exit;
   for i:=0 to List.Count-1 do begin
    P:=List.Items[i];
    fi.WriteInteger(ConstSectionShortCut,ConstTypeEntry+
      inttostr(Integer(P.TypeEntry)),P.ShortCut);
    if P.Bitmap<>nil then P.Bitmap.free;
    ClearListEntryRoot(P.List);
    P.List.Free;
    dispose(P);
   end;
   List.Clear;
  finally
    fi.Free;
  end;
 except
 end;
end;

procedure GetInfoLibrary_(P:PinfoLibrary); StdCall;
begin
  if P=nil then exit;
  P.Hint:=LibraryHint;
  P.TypeLib:=MainTypeLib;
end;

function GetListEntryRoot_: TList;stdcall;
begin
  Result:=LERoot;
end;

procedure RefreshEntryes_;stdcall;
begin
  Screen.Cursor:=crHourGlass;
  try
    ClearListEntryRoot(LERoot);
    AddToListEntryRoot;
//    CheckPermissionInListEntryRoot(LERoot);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure AfterSetOptions_(isOK: Boolean);stdcall;

{  procedure AfterSetOptions(List: TList);
  var
    i: Integer;
    P: PInfoOption;
  begin
    if list=nil then exit;
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      if P<>nil then begin
       case TTypeStaffBAFOptions(P.Index) of
         tstoRBEmp: begin
           if isOk then
            fmOptions.SetRBEmpOptions;
           Windows.SetParent(fmOptions.pnRBEmp.Handle,fmOptions.tsRBEmp.Handle);
         end;
       end;
       if P.List<>nil then
        AfterSetOptions(P.List);
      end;
    end;
  end;}

   procedure SetNewDbGirdProp(Grid: TNewDBgrid);
   begin
     AssignFont(_GetOptions.RBTableFont,Grid.Font);
     Grid.TitleFont.Assign(Grid.Font);
     Grid.RowSelected.Font.Assign(Grid.Font);
     Grid.RowSelected.Brush.Style:=bsClear;
     Grid.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
     Grid.RowSelected.Font.Color:=clWhite;
     Grid.RowSelected.Pen.Style:=psClear;
     Grid.CellSelected.Visible:=true;
     Grid.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
     Grid.CellSelected.Font.Assign(Grid.Font);
     Grid.CellSelected.Font.Color:=clHighlightText;
     Grid.TitleCellMouseDown.Font.Assign(Grid.Font);
     Grid.Invalidate;
  end;

  procedure SetTreeViewProp(TV: TDBTreeView);
  begin
    AssignFont(_GetOptions.RBTableFont,TV.Font);
  end;
    
  procedure SetProperties(wt: TWinControl);
  var
    i: Integer;
    ct: TControl;
  begin
    for i:=0 to wt.ControlCount-1 do begin
      ct:=wt.Controls[i];
      if ct is TNewDbGrid then
         SetNewDbGirdProp(TNewDbGrid(ct));
      if ct is TCustomTreeView then
         SetTreeViewProp(TDBTreeView(ct));
      if ct is TWinControl then
         SetProperties(TWinControl(ct));
    end;
  end;

begin
 try
//  AfterSetOptions(ListOptionsRoot);
//  fmOptions.CloseIni;
//  fmOptions.Visible:=false;
  if isOk then begin
    if fmRptMemOrder5<>nil then SetProperties(fmRptMemOrder5);
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure ClearAndFreeLERoot(List: TList);
begin
  if List=nil then exit;
  ClearListEntryRoot(list);
  List.Free;
end;


function CreateAndViewrptMemOrder5(Params: Pointer; isModal:Boolean):Boolean;
  function CreateAndViewAsMDIChild: Boolean;
  begin
    Result:=false;
    try
      if fmRptMemOrder5=nil then fmRptMemOrder5:=TfmRptMemOrder5.Create(nil);
      fmRptMemOrder5.InitParams(tte_RptMemOrder5);
      fmRptMemOrder5.FormStyle:=fsMDIChild;
      Result:=true;
    except
      {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
    end;
  end;

begin
  if not isModal then Result:=CreateAndViewAsMDIChild  else
  begin
    Result:=false;
    try
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
    end;
 end;
end;

function GetIniFileName: String;
begin
  IniStr:=StrPas(_GetIniFileName);
  Result:=IniStr;
end;


end.
