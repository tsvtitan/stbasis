{***********************************************************
                R&A Library
                   RAI2
       Copyright (C) 1998-2001 Andrei Prygounkov

       description : adapter unit - converts RAI2 calls to delphi calls

       author      : Andrei Prygounkov
       e-mail      : a.prygounkov@gmx.de
       www         : http://ralib.hotbox.ru
************************************************************}
{$INCLUDE RA.INC}

unit RAI2_Grids;

interface

uses RAI2;

  procedure RegisterRAI2Adapter(RAI2Adapter: TRAI2Adapter);

implementation

uses Windows, Classes, Grids, RAI2_Windows;


  { EInvalidGridOperation }

  { TInplaceEdit }

{ constructor Create(AOwner: TComponent) }
procedure TInplaceEdit_Create(var Value: Variant; Args: TArgs);
begin
  Value := O2V(TInplaceEdit.Create(V2O(Args.Values[0]) as TComponent));
end;

{  procedure Deselect; }
procedure TInplaceEdit_Deselect(var Value: Variant; Args: TArgs);
begin
  TInplaceEdit(Args.Obj).Deselect;
end;

{  procedure Hide; }
procedure TInplaceEdit_Hide(var Value: Variant; Args: TArgs);
begin
  TInplaceEdit(Args.Obj).Hide;
end;

{  procedure Invalidate; }
procedure TInplaceEdit_Invalidate(var Value: Variant; Args: TArgs);
begin
  TInplaceEdit(Args.Obj).Invalidate;
end;

{  procedure Move(const Loc: TRect); }
procedure TInplaceEdit_Move(var Value: Variant; Args: TArgs);
begin
  TInplaceEdit(Args.Obj).Move(Var2Rect(Args.Values[0]));
end;

{  function PosEqual(const Rect: TRect): Boolean; }
procedure TInplaceEdit_PosEqual(var Value: Variant; Args: TArgs);
begin
  Value := TInplaceEdit(Args.Obj).PosEqual(Var2Rect(Args.Values[0]));
end;

{  procedure SetFocus; }
procedure TInplaceEdit_SetFocus(var Value: Variant; Args: TArgs);
begin
  TInplaceEdit(Args.Obj).SetFocus;
end;

{  procedure UpdateLoc(const Loc: TRect); }
procedure TInplaceEdit_UpdateLoc(var Value: Variant; Args: TArgs);
begin
  TInplaceEdit(Args.Obj).UpdateLoc(Var2Rect(Args.Values[0]));
end;

{  function Visible: Boolean; }
procedure TInplaceEdit_Visible(var Value: Variant; Args: TArgs);
begin
  Value := TInplaceEdit(Args.Obj).Visible;
end;

  { TCustomGrid }

{$IFDEF RA_D3H}
{  function MouseCoord(X, Y: Integer): TGridCoord; }
procedure TCustomGrid_MouseCoord(var Value: Variant; Args: TArgs);
begin
  Value := Point2Var(TPoint(TCustomGrid(Args.Obj).MouseCoord(Args.Values[0], Args.Values[1])));
end;
{$ENDIF}

  { TDrawGrid }

{ constructor Create(AOwner: TComponent) }
procedure TDrawGrid_Create(var Value: Variant; Args: TArgs);
begin
  Value := O2V(TDrawGrid.Create(V2O(Args.Values[0]) as TComponent));
end;

{  function CellRect(ACol, ARow: Longint): TRect; }
procedure TDrawGrid_CellRect(var Value: Variant; Args: TArgs);
begin
  Value := Rect2Var(TDrawGrid(Args.Obj).CellRect(Args.Values[0], Args.Values[1]));
end;

{  procedure MouseToCell(X, Y: Integer; var ACol, ARow: Longint); }
procedure TDrawGrid_MouseToCell(var Value: Variant; Args: TArgs);
begin
  TDrawGrid(Args.Obj).MouseToCell(Args.Values[0], Args.Values[1], Longint(TVarData(Args.Values[2]).vInteger), Longint(TVarData(Args.Values[3]).vInteger));
end;

  { TStringGrid }

{ constructor Create(AOwner: TComponent) }
procedure TStringGrid_Create(var Value: Variant; Args: TArgs);
begin
  Value := O2V(TStringGrid.Create(V2O(Args.Values[0]) as TComponent));
end;

{ property Read Cols[Integer]: TStrings }
procedure TStringGrid_Read_Cols(var Value: Variant; Args: TArgs);
begin
  Value := O2V(TStringGrid(Args.Obj).Cols[Args.Values[0]]);
end;

{ property Write Cols[Integer]: TStrings }
procedure TStringGrid_Write_Cols(const Value: Variant; Args: TArgs);
begin
  TStringGrid(Args.Obj).Cols[Args.Values[0]] := V2O(Value) as TStrings;
end;

{ property Read Rows[Integer]: TStrings }
procedure TStringGrid_Read_Rows(var Value: Variant; Args: TArgs);
begin
  Value := O2V(TStringGrid(Args.Obj).Rows[Args.Values[0]]);
end;

{ property Write Rows[Integer]: TStrings }
procedure TStringGrid_Write_Rows(const Value: Variant; Args: TArgs);
begin
  TStringGrid(Args.Obj).Rows[Args.Values[0]] := V2O(Value) as TStrings;
end;


procedure RegisterRAI2Adapter(RAI2Adapter: TRAI2Adapter);
begin
  with RAI2Adapter do
  begin
   { EInvalidGridOperation }
    AddClass('Grids', EInvalidGridOperation, 'EInvalidGridOperation');
   { TGridState }
    AddConst('Grids', 'gsNormal', gsNormal);
    AddConst('Grids', 'gsSelecting', gsSelecting);
    AddConst('Grids', 'gsRowSizing', gsRowSizing);
    AddConst('Grids', 'gsColSizing', gsColSizing);
    AddConst('Grids', 'gsRowMoving', gsRowMoving);
    AddConst('Grids', 'gsColMoving', gsColMoving);
   { TInplaceEdit }
    AddClass('Grids', TInplaceEdit, 'TInplaceEdit');
    AddGet(TInplaceEdit, 'Create', TInplaceEdit_Create, 1, [varEmpty], varEmpty);
    AddGet(TInplaceEdit, 'Deselect', TInplaceEdit_Deselect, 0, [0], varEmpty);
    AddGet(TInplaceEdit, 'Hide', TInplaceEdit_Hide, 0, [0], varEmpty);
    AddGet(TInplaceEdit, 'Invalidate', TInplaceEdit_Invalidate, 0, [0], varEmpty);
    AddGet(TInplaceEdit, 'Move', TInplaceEdit_Move, 1, [varEmpty], varEmpty);
    AddGet(TInplaceEdit, 'PosEqual', TInplaceEdit_PosEqual, 1, [varEmpty], varEmpty);
    AddGet(TInplaceEdit, 'SetFocus', TInplaceEdit_SetFocus, 0, [0], varEmpty);
    AddGet(TInplaceEdit, 'UpdateLoc', TInplaceEdit_UpdateLoc, 1, [varEmpty], varEmpty);
    AddGet(TInplaceEdit, 'Visible', TInplaceEdit_Visible, 0, [0], varEmpty);
   { TGridOption }
    AddConst('Grids', 'goFixedVertLine', goFixedVertLine);
    AddConst('Grids', 'goFixedHorzLine', goFixedHorzLine);
    AddConst('Grids', 'goVertLine', goVertLine);
    AddConst('Grids', 'goHorzLine', goHorzLine);
    AddConst('Grids', 'goRangeSelect', goRangeSelect);
    AddConst('Grids', 'goDrawFocusSelected', goDrawFocusSelected);
    AddConst('Grids', 'goRowSizing', goRowSizing);
    AddConst('Grids', 'goColSizing', goColSizing);
    AddConst('Grids', 'goRowMoving', goRowMoving);
    AddConst('Grids', 'goColMoving', goColMoving);
    AddConst('Grids', 'goEditing', goEditing);
    AddConst('Grids', 'goTabs', goTabs);
    AddConst('Grids', 'goRowSelect', goRowSelect);
    AddConst('Grids', 'goAlwaysShowEditor', goAlwaysShowEditor);
    AddConst('Grids', 'goThumbTracking', goThumbTracking);
   { TGridDrawState }
    AddConst('Grids', 'gdSelected', gdSelected);
    AddConst('Grids', 'gdFocused', gdFocused);
    AddConst('Grids', 'gdFixed', gdFixed);
   { TGridScrollDirection }
    AddConst('Grids', 'sdLeft', sdLeft);
    AddConst('Grids', 'sdRight', sdRight);
    AddConst('Grids', 'sdUp', sdUp);
    AddConst('Grids', 'sdDown', sdDown);
   { TCustomGrid }
    AddClass('Grids', TCustomGrid, 'TCustomGrid');
   {$IFDEF RA_D3H}
    AddGet(TCustomGrid, 'MouseCoord', TCustomGrid_MouseCoord, 2, [varEmpty, varEmpty], varEmpty);
   {$ENDIF RA_B1}
   { TDrawGrid }
    AddClass('Grids', TDrawGrid, 'TDrawGrid');
    AddGet(TDrawGrid, 'Create', TDrawGrid_Create, 1, [varEmpty], varEmpty);
    AddGet(TDrawGrid, 'CellRect', TDrawGrid_CellRect, 2, [varEmpty, varEmpty], varEmpty);
    AddGet(TDrawGrid, 'MouseToCell', TDrawGrid_MouseToCell, 4, [varEmpty, varEmpty, varByRef, varByRef], varEmpty);
   { TStringGrid }
    AddClass('Grids', TStringGrid, 'TStringGrid');
    AddGet(TStringGrid, 'Create', TStringGrid_Create, 1, [varEmpty], varEmpty);
    AddGet(TStringGrid, 'Cols', TStringGrid_Read_Cols, 1, [0], varEmpty);
    AddSet(TStringGrid, 'Cols', TStringGrid_Write_Cols, 1, [1]);
    AddGet(TStringGrid, 'Rows', TStringGrid_Read_Rows, 1, [0], varEmpty);
    AddSet(TStringGrid, 'Rows', TStringGrid_Write_Rows, 1, [1]);
  end;    { with }
end;    { RegisterRAI2Adapter }

end.
