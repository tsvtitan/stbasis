unit tsvDbGrid;

interface

{$I stbasis.inc}

uses Windows, SysUtils, Messages, Classes, Controls, Forms, StdCtrls,
  Graphics, Grids, DBCtrls,DbGrids, Db, Menus, ImgList;

type

  TNewDBgrid=class;
  TRowSelected=class(TPersistent)
    private
      FFont: TFont;
      FBrush: TBrush;
      FPen: TPen;
      FGrid: TNewDBgrid;
      FVisible: Boolean;
      procedure SetFont(Value: TFont);
      procedure SetBrush(Value: TBrush);
      procedure SetPen(Value: TPen);
      procedure SetVisible(Value: Boolean);
    public
      constructor Create(AOwner: TNewDBgrid);
      destructor Destroy;override;
    published
      property Font: TFont read FFont write SetFont;
      property Brush: TBrush read FBrush write SetBrush;
      property Pen: Tpen read Fpen write SetPen;
      property Visible: Boolean read FVisible write SetVisible;
  end;


  TSelectedCell=class(TCollectionItem)
   private
    FFont: TFont;
    FBrush: TBrush;
    FPen: TPen;
    FFieldValues: TStringList;
    FFieldNames:TStringList;
    FVisible: Boolean;
    procedure SetFont(Value: TFont);
    procedure SetBrush(Value: TBrush);
    procedure SetPen(Value: TPen);
    procedure SetFieldValues(Value: TStringList);
    procedure SetFieldNames(Value: TStringList);
    procedure SetVisible(Value: Boolean);
   public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
   published
    property Font: TFont read FFont write SetFont;
    property Brush: TBrush read FBrush write SetBrush;
    property Pen: Tpen read FPen write SetPen;
    property FieldValues: TStringList read FFieldValues write SetFieldValues;
    property FieldNames: TStringList read FFieldNames write SetFieldNames;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  TSelCellClass=class of TSelectedCell;

  TSelectedCells=class(TCollection)
  private
    FGrid: TNewDBgrid;
    function GetSelCell(Index: Integer): TSelectedCell;
    procedure SetSelCell(Index: Integer; Value: TSelectedCell);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(Grid: TNewDBgrid; SelCellClass: TSelCellClass);
    function  Add: TSelectedCell;
    property Grid: TNewDBgrid read FGrid;
    property Items[Index: Integer]: TSelectedCell read GetSelCell write SetSelCell; default;
  end;
  
  TNewGridDataLink = class(TGridDataLink)
  end;


  TTypeColumnSort=(tcsNone,tcsAsc,tcsDesc);
  TOnTitleClickWithSort=procedure(Column: TColumn; TypeSort: TTypeColumnSort)of object;
  TOnGetBrushColor=function(Sender: TObject; Column: TColumn): TColor of object;
  TOnGetFontColor=TOnGetBrushColor;


  TNewDBgrid=class(TCustomDBGrid)
  private
    FColumnSortEnabled: Boolean;
    NotSetLocalWidth: Boolean;
    FMultiSelect: Boolean;
    FOldGridState: TGridState;
    OldCell: TGridCoord;
    FTitleX,FTitleY: Integer;
    FTitleMouseDown: Boolean;
    FRowSelected: TRowSelected;
    FTitleCellMouseDown: TRowSelected;
    FCellSelected: TRowSelected;
    FSelectedCells: TSelectedCells;
    FRowSizing: Boolean;
    FRowHeight: Integer;
    FColumnSort: TColumn;
    FListColumnSort: TList;
    FOnTitleClickWithSort: TOnTitleClickWithSort;
    FImageList: TImageList;
    FTitleClickInUse: Boolean;
    FVisibleRowNumber: Boolean;
    FNewDefaultRowHeight : Integer;
    FWords: TStringList;
    FWordColor: TColor;
    FOnGetBrushColor: TOnGetBrushColor;
    FOnGetFontColor: TOnGetFontColor;  
    
//    FRealTopRow: Integer;
    procedure ClearListColumnSort;
    procedure SetColumnSort(Column: TColumn);
    procedure SetRowSelected(Value: TRowSelected);
    procedure SetCellSelected(Value: TRowSelected);
    procedure SetSelectedCells(Value: TSelectedCells);
    procedure SetTitleCellMouseDown(Value: TRowSelected);
    procedure SetRowSizing(Value: Boolean);
    procedure SetRowHeight(Value: Integer);
    procedure SetMultiSelect(Value: Boolean);
    procedure SetColumnSortEnabled(Value: Boolean);
    procedure SetVisibleRowNumber(Value: Boolean);
    procedure SetWidthRowNumber(NewRow: Integer);
    function GetRealTopRow(NewRow: Integer): Integer;
    procedure SetDefaultRowHeight(Value: Integer);
    function GetMinRowHeight: Integer;
    function GetDefaultRowHeight: Integer;
    
//    procedure MouseToCell(X,Y:Integer; var ACol,ARow:Integer);
  protected
    function GetFontColor(Column: TColumn): TColor;
    function GetBrushColor(Column: TColumn): TColor;

  public
    DrawRow,CurrentRow: Integer;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure DrawDataCell(const Rect: TRect; Field: TField;
      State: TGridDrawState); override;
    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    property Canvas;
    property SelectedRows;
    procedure WMMouseWheel(var Message: TWMMouseWheel);message WM_MOUSEWHEEL;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    function GetShortString(w: integer; str,text: string): string;
    procedure WriteTextEx(ARow,ACol: Integer; rt: Trect; Alignment: TAlignment; Text: String ; DX,DY: Integer;
                          var TextW: Integer; TextWidthMinus: Integer=0);
    procedure TitleClick(Column: TColumn); override;
    procedure DblClick;override;
    procedure CalcSizingState(X, Y: Integer;
                              var State: TGridState; var Index, SizingPos, SizingOfs: Integer;
                               var FixedInfo: TGridDrawInfo);override;
    function GetTypeColumnSort(Column: TColumn): TTypeColumnSort;
    procedure SetTypeColumnSort(Column: TColumn; TypeSort: TTypeColumnSort);
    procedure DrawSort(Canvas: TCanvas; ARect: TRect; TypeSort: TTypeColumnSort);
    procedure ClearColumnSort;
    procedure SetColumnAttributes; override;
    procedure Scroll(Distance: Integer); override;
    procedure TopLeftChanged; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure SetEditText(ACol, ARow: Longint; const Value: string);override;
    function GetEditText(ACol, ARow: Longint): string;override;
    function SelectCell(ACol, ARow: Longint): Boolean;override;
    procedure TimedScroll(Direction: TGridScrollDirection);override;
    procedure RowHeightsChanged; override;
    procedure LayoutChanged; override;
    procedure DefaultDrawRowCellSelected(const Rect: TRect; DataCol: Integer;
                                               Column: TColumn; State: TGridDrawState);
    procedure DoTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); virtual;
    function FindColumnByTitle(const Title: String): TColumn;
    function FindColumnByField(const FieldName: String): TColumn;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Columns; //StoreColumns;
    property ColumnSort: TColumn read FColumnSort write SetColumnSort;
    property ColumnSortEnabled: Boolean read FColumnSortEnabled write SetColumnSortEnabled;
    property Constraints;
    property Ctl3D;
    property DataSource;
    property DefaultDrawing;
    property DefaultRowHeight: Integer read GetDefaultRowHeight write SetDefaultRowHeight;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedColor;
    property FixedCols;
    property Font;
    property ImeMode;
    property ImeName;
    property Options;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RowSelected: TRowSelected read FRowSelected write SetRowSelected;
    property CellSelected: TRowSelected read FCellSelected write SetCellSelected;
    property Words: TStringList read FWords;
    property WordColor: TColor read FWordColor write FWordColor;  
    property TitleCellMouseDown: TRowSelected read FTitleCellMouseDown write SetTitleCellMouseDown;
    property TitleMouseDown: Boolean read FTitleMouseDown;
    property RowSizing: Boolean read FRowSizing write SetRowSizing;
    property RowHeight: Integer read FRowHeight write SetRowHeight;
    property ShowHint;
    property SelectedCells: TSelectedCells read FSelectedCells write SetSelectedCells;
    property TabOrder;
    property TabStop;
    property TitleFont;
    property Visible;
    property VisibleRowNumber: Boolean read FVisibleRowNumber write SetVisibleRowNumber;
    property OnCellClick;
    property OnColEnter;
    property OnColExit;
    property OnColumnMoved;
    property OnDrawDataCell;  { obsolete }
    property OnDrawColumnCell;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditButtonClick;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnTitleClick;
    property OnTitleClickWithSort: TOnTitleClickWithSort read FOnTitleClickWithSort write FOnTitleClickWithSort;
    property OnGetBrushColor: TOnGetBrushColor read FOnGetBrushColor write FOnGetBrushColor;
    property OnGetFontColor: TOnGetFontColor read FOnGetFontColor write FOnGetFontColor;
  end;

{$R TSVDBGrid.res}

implementation

const
   DefaultVisibleRowNumber=60;
   DefaultVisibleRowNumberCaption='¹';

type
  TTempGrid=class(TCustomGrid)
    public
      property Options;
  end;



  PInfoColumnSort=^TInfoColumnSort;
  TInfoColumnSort=packed record
    Column: TColumn;
    TypeColumnSort: TTypeColumnSort; 
  end;

{ TRowSelected }

constructor TRowSelected.Create(AOwner: TNewDBgrid);
begin
  FGrid:=AOwner;
  FFont:=TFont.Create;
  FBrush:=TBrush.Create;
  FPen:=Tpen.Create;
  FVisible:=false;
end;

destructor TRowSelected.Destroy;
begin
  FFont.Free;
  FBrush.Free;
  FPen.Free;
end;

procedure TRowSelected.SetFont(Value: TFont);
begin
  if Value<>FFont then begin
    FFont:=Value;
    FGrid.DefaultDrawing:=true;
    FGrid.InvalidateRow(FGrid.row);
  end;
end;

procedure TRowSelected.SetBrush(Value: TBrush);
begin
  if Value<>FBrush then begin
    FBrush:=Value;
    FGrid.DefaultDrawing:=true;
    FGrid.InvalidateRow(FGrid.row);
  end;
end;

procedure TRowSelected.SetPen(Value: TPen);
begin
  if Value<>Fpen then begin
    FPen:=Value;
    FGrid.DefaultDrawing:=true;
    FGrid.InvalidateRow(FGrid.row);
  end;
end;

procedure TRowSelected.SetVisible(Value: Boolean);
begin
  if Value<>FVisible then begin
    FVisible:=Value;
    FGrid.DefaultDrawing:=true;
    FGrid.InvalidateRow(FGrid.row);
  end;
end;

{ TSelectedCell }


constructor TSelectedCell.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFont := TFont.Create;
  FBrush:= TBrush.Create;
  Fpen:=TPen.Create;
  FFieldValues:=TStringList.Create;
  FFieldNames:=TStringList.Create;
  FVisible:=true;
end;

destructor TSelectedCell.Destroy;
begin
  FFont.Free;
  FBrush.Free;
  FPen.Free;
  FFieldValues.Free;
  FFieldNames.Free;
  inherited Destroy;
end;

procedure TSelectedCell.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TSelectedCell.SetPen(Value: TPen);
begin
  Fpen.Assign(value);
end;

procedure TSelectedCell.SetFont(Value: TFont);
begin
  if Value<>FFont then
   FFont:=Value;
end;

procedure TSelectedCell.SetFieldValues(Value: TStringList);
begin
   FFieldValues.Assign(Value);
end;

procedure TSelectedCell.SetFieldNames(Value: TStringList);
begin
   FFieldNames.Assign(Value);
end;

procedure TSelectedCell.SetVisible(Value: Boolean);
begin
  if Value<>FVisible then
   FVisible:=Value;
end;


{ TSelectedCells }

constructor TSelectedCells.Create(Grid: TNewDBgrid; SelCellClass: TSelCellClass);
begin
  inherited Create(SelCellClass);
  FGrid := Grid;
end;

function TSelectedCells.GetSelCell(Index: Integer): TSelectedCell;
begin
  Result := TSelectedCell(inherited Items[Index]);
end;

procedure TSelectedCells.SetSelCell(Index: Integer; Value: TSelectedCell);
begin
  Items[Index].Assign(Value);
end;

function TSelectedCells.GetOwner: TPersistent;
begin
  Result := FGrid;
end;

procedure TSelectedCells.Update(Item: TCollectionItem);
begin
  if (FGrid = nil) or (csLoading in FGrid.ComponentState) then Exit;
end;

function TSelectedCells.Add: TSelectedCell;
begin
  Result := TSelectedCell(inherited Add);
end;

{ TNewDBgrid }
constructor TNewDBgrid.Create(AOwner: TComponent);
var
  bmp,AndMask: TBitmap;
begin
  FColumnSortEnabled:=true;

  FWords:=TStringList.Create;

  FRowSelected:=TRowSelected.Create(Self);
  FCellSelected:=TRowSelected.Create(Self);
  FSelectedCells:=TSelectedCells.Create(self,TSelectedCell);
  FTitleCellMouseDown:=TRowSelected.Create(Self);

  FTitleCellMouseDown.Visible:=true;
  FTitleCellMouseDown.Brush.Color:=clBtnface;
  FRowSelected.Visible:=true;
  FRowSelected.Brush.Style:=bsSolid;
  FRowSelected.Brush.Color:=clBlack;
  FRowSelected.Font.Color:=clWindow;
  FRowSelected.Pen.Style:=psClear;
  FCellSelected.Visible:=true;
  FCellSelected.Brush.Color:=clHighlight;
  FCellSelected.Font.Color:=clHighlightText;
  FCellSelected.Pen.Style:=psClear;


  FColumnSort:=nil;
  FListColumnSort:=TList.Create;
  FImageList:=TImageList.Create(nil);

  bmp:=TBitmap.Create;
  AndMask:=TBitmap.Create;
  try
    bmp.LoadFromResourceName(HINSTANCE,'SORTASC');
    AndMask.Assign(bmp);
    AndMask.Mask(clWhite);
    FImageList.Width:=bmp.Width;
    FImageList.Height:=bmp.Height;
    FImageList.Add(bmp,AndMask);
    bmp.LoadFromResourceName(HINSTANCE,'SORTDESC');
    AndMask.Assign(bmp);
    AndMask.Mask(clWhite);
    FImageList.Add(bmp,AndMask);
  finally
    AndMask.Free;
    bmp.free;
  end;


  Options:=Options-[dgEditing]-[dgTabs];
  ReadOnly:=true;

  inherited Create(AOwner);

  colwidths[0]:=IndicatorWidth;

end;

destructor TNewDBgrid.Destroy;
begin
  ClearListColumnSort;
  FListColumnSort.Free;
  FSelectedCells.Free;
  FCellSelected.Free;
  FRowSelected.Free;
  FTitleCellMouseDown.Free;
  FImageList.Free;
  FWords.Free;
  inherited;
end;

procedure TNewDBgrid.SetRowSelected(Value: TRowSelected);
begin
  FRowSelected.Assign(Value);
end;

procedure TNewDBgrid.SetCellSelected(Value: TRowSelected);
begin
  FCellSelected.Assign(Value);
end;

procedure TNewDBgrid.SetSelectedCells(Value: TSelectedCells);
begin
  FSelectedCells.Assign(Value);
end;

procedure TNewDBgrid.SetTitleCellMouseDown(Value: TRowSelected);
begin
  FTitleCellMouseDown.Assign(Value);
end;

function TNewDBgrid.GetShortString(w: integer; str,text: string): string;
   var
     i: Integer;
     tmps: string;
     neww: Integer;
   begin
    result:=text;
    for i:=1 to Length(text) do begin
      tmps:=tmps+text[i];
      neww:=Canvas.TextWidth(tmps+str);
      if neww>=(w-Canvas.TextWidth(str)) then begin
       result:=tmps+str;
       exit;
      end;
    end;
end;

procedure TNewDBgrid.WriteTextEx(ARow,ACol: Integer; rt: Trect; Alignment: TAlignment; Text: String ; DX,DY: Integer;
                                 var TextW: Integer; TextWidthMinus: Integer=0);
var
     Left_: INteger;
     newstr: string;
     strx: integer;
   begin
     with Canvas do begin
        Brush.Style:=bsClear;
        case Alignment of
          taLeftJustify:
            Left_ := rt.Left + DX;
           taRightJustify:
            Left_ := rt.Right - TextWidth(Text) -3;
           else
            Left_ := rt.Left + (rt.Right - rt.Left) shr 1 - (TextWidth(Text) shr 1);
         end;
         newstr:=Text;
       //  if ARow<>Row then begin
          strx:=TextWidth(text);
          if strx>=ColWidths[ACol]-TextWidthMinus-1 then begin
            newstr:=GetShortString(ColWidths[ACol]-TextWidthMinus,'...',text);
          end;
       //  end;

         TextRect(rt, Left_, rt.Top + DY, newstr);
         TextW:=TextWidth(newstr);
     end;
end;

procedure TNewDBgrid.DrawSort(Canvas: TCanvas; ARect: TRect; TypeSort: TTypeColumnSort);
var
//  w,h: Integer;
  x,y: Integer;
begin
  with Canvas do begin
{    w:=(Arect.Right-Arect.Left) div 2;
    h:=(Arect.Bottom-Arect.Top) div 3;}
    x:=Arect.Left;
    y:=Arect.Top;
    Brush.Style:=bsSolid;
    Pen.Style:=psSolid;
    Pen.Color:=clBlack;
    case TypeSort of
      tcsNone:;
      tcsAsc: begin
{        MoveTo(x+w div 2,y+h);
        LineTo(x+w+w div 2,y+h);
        LineTo(x+w,y+2*h);
        LineTo(x+w div 2,y+h);}
        FImageList.Draw(Canvas,x,y,0);
      end;
      tcsDesc: begin
{        MoveTo(x+w,y+h);
        LineTo(x+w+w div 2,y+2*h);
        LineTo(x+w div 2,y+2*h);
        LineTo(x+w,y+h);}
        FImageList.Draw(Canvas,x,y,1);
      end;
    end;
  end;
end;

procedure TNewDBgrid.DefaultDrawRowCellSelected(const Rect: TRect; DataCol: Integer;
                                               Column: TColumn; State: TGridDrawState);
{var
  Rect: TRect;}


   procedure DrawRowCellSelected;
   var
    OldBrush: TBrush;
    OldFont: TFont;
    OldPen: Tpen;
//    cl: TColumn;
//    fl: TField;
    i: Integer;
    ACol: Integer;
    Rect1: TRect;
   begin
     OldBrush:=TBrush.Create;
     OldFont:=TFont.Create;
     OldPen:=Tpen.Create;
     try
      OldBrush.Assign(Canvas.Brush);
      OldFont.Assign(Canvas.Font);
      OldPen.Assign(Canvas.Pen);
       with Canvas do begin
        if FRowSelected.Visible then begin
          Font.Assign(FRowSelected.Font);
          Brush.Assign(FRowSelected.Brush);
          Pen.Assign(FRowSelected.Pen);
          for i:=IndicatorOffset to ColCount-1 do begin
            ACol:=i;
            Rect1:=CellRect(ACol,Row);
            Brush.Color:=clBlack;
            Fillrect(Rect1);
{            if (Columns.Count>=ACol)and(ACol>=IndicatorOffset) then begin
            cl:=Columns.Items[ACol-IndicatorOffset];
             if cl<>nil then begin
              Font.Name:=cl.Font.Name;
              fl:=cl.Field;
              if fl<>nil then
                WriteTextEx(Row,ACol,Rect1,cl.Alignment,fl.DisplayText,2,2);
             end;
            end;}
          end;
{          Pen.Assign(FRowSelected.Pen);
          Rectangle(rect);
          DefaultDrawing:=False;}
        end; // end of FRowSelected.Visible
{        if FCellSelected.Visible then begin
         for i:=0 to ColCount-1 do begin
           ACol:=i;
           if ACol=Col then begin
            Font.Assign(FCellSelected.Font);
            Brush.Assign(FCellSelected.Brush);
            Pen.Assign(FCellSelected.Pen);
            Fillrect(Rect);
            if (Columns.Count>=Col)and(Col>=IndicatorOffset) then begin
             cl:=Columns.Items[Col-IndicatorOffset];
             if cl<>nil then begin
              Font.Name:=cl.Font.Name;
              fl:=cl.Field;
              if fl<>nil then
               WriteTextEx(Row,Col,Rect,cl.Alignment,fl.DisplayText,2,2);
             end;
            end;
            Pen.Assign(FCellSelected.Pen);
            Rectangle(rect);
            if Focused then  Windows.DrawFocusRect(Handle, Rect);
            DefaultDrawing:=False;
            exit;
           end;
         end;
        end;// end of FCellSelected.Visible}
       end; // end of with canvas
      finally
       Canvas.Brush.Assign(OldBrush);
       OldBrush.Free;
       Canvas.Font.Assign(OldFont);
       OldFont.Free;
       Canvas.Pen.Assign(OldPen);
       OldPen.Free;
      end;
   end;

begin
//  Rect:=BoxRect(IndicatorOffset,Row,ColCount,Row);
 // DrawRowCellSelected;
end;

procedure TNewDBgrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);

   procedure DrawRowCellSelected;
   var
    OldBrush: TBrush;
    OldFont: TFont;
    OldPen: Tpen;
    cl: TColumn;
    fl: TField;
    APos: Integer;
    i: Integer;
    OldBrushColor: tColor;
    S: String;
    W,TW: Integer;
    NewRect: TRect;
     ADef: Boolean;
     OldActive: Integer;
     ABrushColor: Tcolor;
     AFontColor: TColor;
     TextW: Integer;
   begin
     OldBrush:=TBrush.Create;
     OldFont:=TFont.Create;
     OldPen:=Tpen.Create;
     try
      OldBrush.Assign(Canvas.Brush);
      OldFont.Assign(Canvas.Font);
      OldPen.Assign(Canvas.Pen);
      if (Arow=Row) then begin
       with Canvas do begin
        if FRowSelected.Visible then begin
         Font.Assign(FRowSelected.Font);
         Brush.Assign(FRowSelected.Brush);
         Pen.Assign(FRowSelected.Pen);
         Fillrect(ARect);
         if (Columns.Count>=ACol)and(ACol>=IndicatorOffset) then begin
          cl:=Columns.Items[ACol-IndicatorOffset];
          if cl<>nil then begin
           Font.Name:=cl.Font.Name;
           Font.Style:=cl.Font.Style;
           fl:=cl.Field;
            if (FWords.Count>0) and
               Assigned(fl) then begin
              OldBrushColor:=Brush.Color;
              try
                Brush.Color:=FWordColor;
                for i:=1 to Length(fl.DisplayText) do begin
                  APos:=AnsiPos(fl.DisplayText[i],FWords.Text);
                  if APos=0 then begin
                    s:=Copy(fl.DisplayText,1,i);
                    TW:=Canvas.TextWidth(S);
                    w:=Canvas.TextWidth(fl.DisplayText[i]);
                    if w>0 then begin
                      NewRect:=ARect;
                      NewRect.Left:=NewRect.Left+TW-w+1;
                      NewRect.Right:=NewRect.Left+w+2;
                      FillRect(NewRect);
                    end;
                  end;
                end;
              finally
                Brush.Color:=OldBrushColor;
              end;
            end;
           if fl<>nil then
            WriteTextEx(ARow,ACol,ARect,cl.Alignment,fl.DisplayText,2,2,TextW);
          end;
         end;
         Pen.Assign(FRowSelected.Pen);
         Rectangle(Arect);
         DefaultDrawing:=False;
        end; // end of FRowSelected.Visible
        if FCellSelected.Visible then begin
         if ACol=Col then begin
          Font.Assign(FCellSelected.Font);
          Brush.Assign(FCellSelected.Brush);
          Pen.Assign(FCellSelected.Pen);
          Fillrect(ARect);
          if (Columns.Count>=ACol)and(ACol>=IndicatorOffset) then begin
           cl:=Columns.Items[ACol-IndicatorOffset];
           if cl<>nil then begin
            Font.Name:=cl.Font.Name;
            Font.Style:=cl.Font.Style;
            fl:=cl.Field;
            if (FWords.Count>0) and
               Assigned(fl) then begin
              OldBrushColor:=Brush.Color;
              try
                Brush.Color:=FWordColor;
                for i:=1 to Length(fl.DisplayText) do begin
                  APos:=AnsiPos(fl.DisplayText[i],FWords.Text);
                  if APos=0 then begin
                    s:=Copy(fl.DisplayText,1,i);
                    TW:=Canvas.TextWidth(S);
                    w:=Canvas.TextWidth(fl.DisplayText[i]);
                    if w>0 then begin
                      NewRect:=ARect;
                      NewRect.Left:=NewRect.Left+TW-w+1;
                      NewRect.Right:=NewRect.Left+w+2;
                      FillRect(NewRect);
                    end;
                  end;
                end;
              finally
                Brush.Color:=OldBrushColor;
              end;
            end;
            if fl<>nil then
             WriteTextEx(ARow,ACol,ARect,cl.Alignment,fl.DisplayText,2,2,TextW);
           end;
          end;
          Pen.Assign(FCellSelected.Pen);
          Rectangle(Arect);
          if Focused then  Windows.DrawFocusRect(Handle, ARect);
          DefaultDrawing:=False;
          exit;
         end;
        end;// end of FCellSelected.Visible
       end; // end of with canvas
      end else begin
        ADef:=true;
        OldActive := DataLink.ActiveRecord;
        try
          if not (gdFixed in AState) and
                 (Columns.Count>=ACol) and
                 (Acol>=IndicatorOffset) and
                 (ARow>0) then begin
            DataLink.ActiveRecord := ARow-1;
            cl:=Columns.Items[ACol-IndicatorOffset];
            if Assigned(cl) then begin
              if not cl.Showing then Exit;
              fl:=cl.Field;
              if Assigned(Fl) then begin
                ABrushColor:=GetBrushColor(cl);
                AFontColor:=GetFontColor(cl);
                Canvas.Font:=Cl.Font;
                Canvas.Brush.Color:=Cl.Color;
                Canvas.FillRect(ARect);
                Canvas.Brush.Color:=ABrushColor;
                Canvas.FillRect(ARect);
                Canvas.Font.Color:=AFontColor;
                WriteTextEx(ARow,ACol,ARect,cl.Alignment,fl.DisplayText,2,2,TextW);
                ADef:=false;
              end;
            end;
          end;
        finally
          DataLink.ActiveRecord := OldActive;
        end;
        DefaultDrawing:=ADef;
      end;
      finally
       Canvas.Brush.Assign(OldBrush);
       OldBrush.Free;
       Canvas.Font.Assign(OldFont);
       OldFont.Free;
       Canvas.Pen.Assign(OldPen);
       OldPen.Free;
      end;
   end;

   procedure DrawRowCellSelectedNoRecord;
   var
    OldBrush: TBrush;
    OldFont: TFont;
    OldPen: Tpen;
   begin
     OldBrush:=TBrush.Create;
     OldFont:=TFont.Create;
     OldPen:=Tpen.Create;
     try
      OldBrush.Assign(Canvas.Brush);
      OldFont.Assign(Canvas.Font);
      OldPen.Assign(Canvas.Pen);
      if (Arow=Row) then begin
       with Canvas do begin
        if FRowSelected.Visible then begin
{         Font.Assign(FRowSelected.Font);
         Brush.Assign(FRowSelected.Brush);
         Pen.Assign(FRowSelected.Pen);}
         Fillrect(ARect);
{         Pen.Assign(FRowSelected.Pen);
         Rectangle(Arect);}
         DefaultDrawing:=False;
        end; // end of FRowSelected.Visible}
        if FCellSelected.Visible then begin
         if ACol=Col then begin
          Font.Assign(FCellSelected.Font);
          Brush.Assign(FCellSelected.Brush);
          Pen.Assign(FCellSelected.Pen);
          Fillrect(ARect);
          Pen.Assign(FCellSelected.Pen);
          Rectangle(Arect);
          if Focused then  Windows.DrawFocusRect(Handle, ARect);
          DefaultDrawing:=False;
          exit;
         end;
        end;// end of FCellSelected.Visible
       end; // end of with canvas
      end else begin
       DefaultDrawing:=true;
      end;
      finally
       Canvas.Brush.Assign(OldBrush);
       OldBrush.Free;
       Canvas.Font.Assign(OldFont);
       OldFont.Free;
       Canvas.Pen.Assign(OldPen);
       OldPen.Free;
      end;
   end;

   procedure DrawMouseDown;
   var
     TitleRect: TRect;
     OldBrush: TBrush;
     OldFont: TFont;
     OldPen: Tpen;
     cl: TColumn;
     rt: Trect;
     dx: Integer;
     x,y: Integer;
   begin
    if FTitleCellMouseDown.Visible then begin
     OldBrush:=TBrush.Create;
     OldFont:=TFont.Create;
     OldPen:=Tpen.Create;
     try
      if FTitleMouseDown then begin
       OldBrush.Assign(Canvas.Brush);
       OldFont.Assign(Canvas.Font);
       OldPen.Assign(Canvas.Pen);
       if (ACol>=IndicatorOffset) and(ARow<1) then begin
        with Canvas do begin
         Font.Assign(FTitleCellMouseDown.Font);
         Brush.Assign(FTitleCellMouseDown.Brush);
         Pen.Assign(FTitleCellMouseDown.Pen);
         TitleRect := CellRect(FTitleX, FTitleY);
         TitleRect.Right:=TitleRect.Right+1;
         TitleRect.Bottom:=TitleRect.Bottom+1;
         FillRect(TitleRect);
         cl:=Columns.Items[ACol-IndicatorOffset];
         if cl<>nil then begin
           CopyMemory(@rt,@TitleRect,Sizeof(TRect));
           dx:=0;
           x:=ARect.Left+2+1;
           y:=Arect.Top+(Arect.Bottom-Arect.Top)div 2-FImageList.Height div 2+1;
           case GetTypeColumnSort(cl) of
             tcsNone: dx:=0;
             tcsAsc: begin
               dx:=FImageList.Width+3;
               FImageList.draw(Canvas,x,y,0);
             end;
             tcsDesc: begin
               dx:=FImageList.Width+3;
               FImageList.draw(Canvas,x,y,1);
             end;
           end;
           rt.Left:=rt.Left+dx+1;
           rt.Top:=rt.Top+1;
           WriteTextEx(ARow,ACol,rt,cl.Title.Alignment,cl.Title.Caption,2,2,dx);
         end;
         DrawEdge(Canvas.Handle,TitleRect,BDR_SUNKENOUTER,BF_TOPLEFT);
         DrawEdge(Canvas.Handle,TitleRect,BDR_RAISEDINNER,BF_BOTTOMRIGHT);
         Pen.Assign(FTitleCellMouseDown.Pen);
         Rectangle(TitleRect);
        end;
        DefaultDrawing:=false;
       end;
      end;
     finally
       Canvas.Brush.Assign(OldBrush);
       OldBrush.Free;
       Canvas.Font.Assign(OldFont);
       OldFont.Free;
       Canvas.Pen.Assign(OldPen);
       OldPen.Free;
     end;
    end;
   end;

   procedure DrawColumns;
   var
     OldBrush: TBrush;
     OldFont: TFont;
     OldPen: Tpen;
     cl: TColumn;
     rt: Trect;
     dx: Integer;
     dy: Integer;
     x,y: Integer;
     Curr: Integer;
   begin
     OldBrush:=TBrush.Create;
     OldFont:=TFont.Create;
     OldPen:=Tpen.Create;
     try
      if not FTitleMouseDown then begin
       OldBrush.Assign(Canvas.Brush);
       OldFont.Assign(Canvas.Font);
       OldPen.Assign(Canvas.Pen);
       Canvas.Font.Assign(Font);
       if (ACol>=IndicatorOffset)and(Arow=0)then begin
        with Canvas do begin
         brush.Color:=FixedColor;
         Pen.Style:=psClear;
         FillRect(ARect);
         cl:=Columns.Items[ACol-IndicatorOffset];
         if cl<>nil then begin
           CopyMemory(@rt,@ARect,Sizeof(TRect));
           dx:=0;
           x:=ARect.Left+2;
           y:=Arect.Top+(Arect.Bottom-Arect.Top)div 2-FImageList.Height div 2;
           case GetTypeColumnSort(cl) of
             tcsNone: dx:=0;
             tcsAsc: begin
               dx:=FImageList.Width+3;
               FImageList.draw(Canvas,x,y,0);
             end;
             tcsDesc: begin
               dx:=FImageList.Width+3;
               FImageList.draw(Canvas,x,y,1);
             end;
           end;
           rt.Left:=rt.Left+1+dx;
           rt.Top:=rt.Top+1;
           WriteTextEx(ARow,ACol,rt,cl.Title.Alignment,cl.Title.Caption,1,1,dx);
         end;
         DrawEdge(Canvas.Handle,ARect,BDR_RAISEDINNER, BF_BOTTOMRIGHT);
         DrawEdge(Canvas.Handle,ARect,BDR_RAISEDINNER, BF_TOPLEFT);
        end;
        DefaultDrawing:=false;
       end;
       if FVisibleRowNumber then begin
        if (ACol<IndicatorOffset)then begin
         Canvas.Brush.Color:=FixedColor;
         Canvas.Pen.Style:=psClear;
         dx:=0;
         CopyMemory(@rt,@ARect,Sizeof(TRect));
         rt.Left:=rt.Left+1+dx;
         rt.Top:=rt.Top+1;
         if (Arow=0) then begin
          WriteTextEx(ARow,ACol,rt,taLeftJustify,DefaultVisibleRowNumberCaption,1,1,dx);
         end else begin
          Curr:=0;
          dy:=rt.Bottom-rt.Top-2;
          dy:=dy div 2 - Canvas.TextHeight('W') div 2;
          if (DataLink.DataSet<>nil) then
           if (DataLink.DataSet.active)and
              (DataLink.DataSet.RecordCount>0)and
              (DataLink.DataSet.State=dsBrowse) then
            Curr:=GetRealTopRow(Row)+ARow
           else Curr:=0;
          if Curr<>0 then
           WriteTextEx(ARow,ACol,rt,taLeftJustify,inttostr(Curr),1,dy,dx);
         end;
         DefaultDrawing:=false;
        end;
       end;

      end;
     finally
       Canvas.Brush.Assign(OldBrush);
       OldBrush.Free;
       Canvas.Font.Assign(OldFont);
       OldFont.Free;
       Canvas.Pen.Assign(OldPen);
       OldPen.Free;
     end;
   end;

begin
  DrawRow:=ARow;
  CurrentRow:=Row;
  if Assigned(DataLink) and DataLink.Active  then begin
     if DataLink.RecordCount>0 then
       DrawRowCellSelected
     else DrawRowCellSelectedNoRecord;
  end else DrawRowCellSelectedNoRecord;

  inherited;

  DrawColumns;

  DrawMouseDown;


{  if Assigned(DataLink) and DataLink.Active  then begin
     if DataLink.RecordCount<>0 then
       DrawMouseDown
     else DefaultDrawing:=true;
  end;}

end;


procedure TNewDBgrid.DrawDataCell(const Rect: TRect; Field: TField; State: TGridDrawState);
begin
  inherited;
end;

procedure TNewDBgrid.DrawColumnCell(const Rect: TRect; DataCol: Integer;
                        Column: TColumn; State: TGridDrawState);

{  procedure DrawColumnOnMouseDown;
   var
     TitleRect: TRect;
     OldBrush: TBrush;
     OldFont: TFont;
     OldPen: Tpen;
   begin
    if FTitleCellMouseDown.Visible then begin
     OldBrush:=TBrush.Create;
     OldFont:=TFont.Create;
     OldPen:=Tpen.Create;
     try
      if FTitleMouseDow then begin
        with Canvas do begin
         Font.Assign(FTitleCellMouseDown.Font);
         Brush.Assign(FTitleCellMouseDown.Brush);
         Pen.Assign(FTitleCellMouseDown.Pen);
         TitleRect := CellRect(FTitleX, FTitleY);
         FillRect(TitleRect);
         Pen.Assign(FTitleCellMouseDown.Pen);
         Rectangle(TitleRect);
         DefaultDrawing:=false;
        end;
       end else DefaultDrawing:=true;
     finally
       Canvas.Brush.Assign(OldBrush);
       OldBrush.Free;
       Canvas.Font.Assign(OldFont);
       OldFont.Free;
       Canvas.Pen.Assign(OldPen);
       OldPen.Free;
     end;
    end;
  end;
 }
begin
 // DrawColumnOnMouseDown;
  inherited;
end;

procedure TNewDBgrid.WMSetFocus(var Msg: TWMSetFocus);
{var
  Rect: TRect;}
begin
  inherited;
{  Rect:=GetClientRect;
  InvalidateRect(Handle,@Rect,true);}
end;

procedure TNewDBgrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
var
  Cell: TGridCoord;
  fm: TCustomForm;
begin
  if not (csDesigning in ComponentState) and CanFocus then begin
    fm:=Screen.ActiveCustomForm;
    if fm<>nil then
      Windows.SetFocus(fm.Handle);
  end;     
  inherited MouseDown(Button,Shift,X,Y);

  if (FOldGridState<>gsColSizing) then
    NotSetLocalWidth:=true;
  
  FOldGridState:=FGridState;
  Cell := MouseCoord(X, Y);
  OldCell:=MouseCoord(X, Y);
  if (FGridState<>gsNormal)and
     (FGridState<>gsColSizing)and
     (Cell.X >= IndicatorOffset) and
     (Cell.Y < 1) then
  begin
   FTitleClickInUse:=true;
   if (Button=mbLeft)then begin
    FTitleMouseDown:=true;
    FTitleX:=Cell.X;
    FTitleY:=Cell.Y;
    InvalidateCell(Cell.X,Cell.Y);
   end;
  end else begin
   FTitleClickInUse:=false;
   FTitleMouseDown:=false;
   InvalidateCell(Cell.X,Cell.Y);
  end;
end;

procedure TNewDBgrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  inherited;
  FTitleMouseDown:=false;
  InvalidateCell(FTitleX,FTitleY);
end;

{procedure TNewDBgrid.MouseToCell(X,Y:Integer; var ACol,ARow:Integer);
var
  Coord:TGridCoord;
begin
  Coord:=MouseCoord(X, Y);
  ACol:=Coord.X;
  ARow:=Coord.Y;
end;}

procedure TNewDBgrid.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
end;

procedure TNewDBgrid.WMMouseWheel(var Message: TWMMouseWheel);
const
  CountWheel=1;
begin
  FTitleMouseDown:=false;
  if Assigned(DataLink) and DataLink.Active  then begin
   if DataLink.DataSet=nil then exit;
   if Datalink.Active then
    with Message, DataLink.DataSet do begin
       if WheelDelta<0 then
        DataLink.DataSet.MoveBy(CountWheel)
       else DataLink.DataSet.MoveBy(-CountWheel);
       Result:=1;
    end;
  end;
end;

procedure TNewDBgrid.SetRowSizing(Value: Boolean);
begin
  if FRowSizing<>Value then begin
    FRowSizing:=Value;
    if FRowSizing then begin
     TTempGrid(self).Options:=TTempGrid(self).Options+[goRowSizing];
    end else begin
     TTempGrid(self).Options:=TTempGrid(self).Options-[goRowSizing];
    end;
  end;
end;

procedure TNewDBgrid.CalcSizingState(X, Y: Integer;
  var State: TGridState; var Index, SizingPos, SizingOfs: Integer;
  var FixedInfo: TGridDrawInfo);
begin
  inherited CalcSizingState(X, Y, State, Index, SizingPos, SizingOfs, FixedInfo);
end;

procedure TNewDBgrid.SetRowHeight(Value: Integer);
var
  i: Integer;
begin
  if FRowHeight<>Value then begin
    FRowHeight:=Value;
    for i:=0 to TTempGrid(self).RowCount-1 do
     TTempGrid(self).RowHeights[i]:=FRowHeight;
  end;
end;

procedure TNewDBgrid.TitleClick(Column: TColumn);
begin
  if (FOldGridState<>gsColSizing)and(NotSetLocalWidth)then begin
   if FColumnSortEnabled then begin
     SetColumnSort(Column);
   end;  
   if Assigned(FOnTitleClickWithSort) then begin
     FOnTitleClickWithSort(Column,GetTypeColumnSort(Column));
     InvalidateTitles;
   end;  
   inherited;
  end; 
end;

procedure TNewDBgrid.DblClick;

  procedure SetLocalWidth;
  var
    w: Integer;
    cl: TColumn;
    i: Integer;
    l: Integer;
    fl: TField;
    bm: TBookmark;
    tmpcol: Integer;
    OldAfterScroll: TDataSetNotifyEvent;
    tmps: string;
  begin
   if DataSource=nil then exit;
   if DataSource.DataSet=nil then exit;
   if not DataSource.DataSet.active then exit;
   try
    DataSource.DataSet.DisableControls;
    OldAfterScroll:=DataSource.DataSet.AfterScroll;
    DataSource.DataSet.AfterScroll:=nil;
    bm:=DataSource.DataSet.GetBookmark;
    try
     tmpcol:=RawToDataColumn(OldCell.X);
     if ((tmpcol)<0)or
        ((tmpcol)>(Columns.Count-1)) then exit;
     cl:=Columns[tmpcol];
     if cl=nil then exit;
     w:=cl.Width;
     DataSource.DataSet.First;
     fl:=cl.Field;
     if fl=nil then exit;
     for i:=0 to DataSource.DataSet.RecordCount-1 do begin
       tmps:='';
       try
        tmps:=fl.DisplayText;
       except
       end;
        
       case fl.DataType of
        ftSmallint,ftInteger,ftWord,ftBytes,ftLargeint: begin
          tmps:=inttostr(fl.AsInteger);
        end;
        ftString,ftWideString,ftFixedChar: begin
          tmps:=fl.DisplayText;
        end;
       end;
       l:=Canvas.TextWidth(tmps)+Canvas.TextWidth('W');
       if l>w then w:=l;
       DataSource.DataSet.Next;
     end;
     cl.Width:=w;

    finally
     DataSource.DataSet.GotoBookmark(bm);
     DataSource.DataSet.AfterScroll:=OldAfterScroll;
     DataSource.DataSet.EnableControls;
    end;
   except
   end;
  end;


begin
  if (FOldGridState=gsColSizing)then begin
    NotSetLocalWidth:=false;
    SetLocalWidth;
  end else begin
   if not FTitleClickInUse then
    inherited;
   NotSetLocalWidth:=true;
  end; 
end;

procedure TNewDBgrid.SetMultiSelect(Value: Boolean);
begin
  if Value<>FMultiSelect then begin
    if Value then Options:=Options+[dgMultiSelect]
    else Options:=Options-[dgMultiSelect];
    FMultiSelect:=Value;
  end;
end;


procedure TNewDBgrid.ClearListColumnSort;
var
  P: PInfoColumnSort;
  i: Integer;
begin
  for i:=0 to FListColumnSort.Count-1 do begin
    P:=FListColumnSort.Items[i];
    Dispose(P);
  end;
  FListColumnSort.Clear;
end;

function TNewDBgrid.GetTypeColumnSort(Column: TColumn): TTypeColumnSort;
var
  i: Integer;
  P: PInfoColumnSort;
begin
  Result:=tcsNone;
  for i:=0 to FListColumnSort.Count-1 do begin
    P:=FListColumnSort.Items[i];
    if P.Column=Column then begin
      Result:=P.TypeColumnSort;
      exit;
    end;
  end;
end;

procedure TNewDBgrid.SetColumnSort(Column: TColumn);
var
  i: Integer;
  P: PInfoColumnSort;
  cur,next: TTypeColumnSort;
begin
  for i:=FListColumnSort.Count-1 downto 0 do begin
    P:=FListColumnSort.Items[i];
    if P.Column=Column then begin
      FColumnSort:=Column;
      cur:=P.TypeColumnSort;
      next:=cur;
      case cur of
        tcsNone: next:=tcsAsc;
        tcsAsc: next:=tcsDesc;
        tcsDesc: next:=tcsNone;
      end;
      P.TypeColumnSort:=next;
      exit;
    end else begin
      FListColumnSort.Remove(P);
      Dispose(P);
    end;
  end;
  New(P);
  P.Column:=Column;
  FColumnSort:=Column;
  P.TypeColumnSort:=tcsAsc;
  FListColumnSort.Add(P);
  InvalidateTitles;
end;

procedure TNewDBgrid.SetTypeColumnSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  i: Integer;
  P: PInfoColumnSort;
begin
  for i:=0 to FListColumnSort.Count-1 do begin
    P:=FListColumnSort.Items[i];
    if P.Column=Column then begin
      P.TypeColumnSort:=TypeSort;
      exit;
    end;
  end;
end;

procedure TNewDBgrid.ClearColumnSort;
begin
  ClearListColumnSort;
end;

procedure TNewDBgrid.SetColumnSortEnabled(Value: Boolean);
begin
 if Value<>FColumnSortEnabled then begin
   FColumnSortEnabled:=Value;
   if not FColumnSortEnabled then
     ClearColumnSort;
 end;
end;

procedure TNewDBgrid.SetVisibleRowNumber(Value: Boolean);
begin
  if Value<>FVisibleRowNumber then begin
    FVisibleRowNumber:=Value;
    SetWidthRowNumber(Row);
  end;
end;

function ReadOnlyField(Field: TField): Boolean;
var
  MasterField: TField;
begin
  Result := Field.ReadOnly;
  if not Result and (Field.FieldKind = fkLookup) then
  begin
    Result := True;
    if Field.DataSet = nil then Exit;
    MasterField := Field.Dataset.FindField(Field.KeyFields);
    if MasterField = nil then Exit;
    Result := MasterField.ReadOnly;
  end;
end;

procedure TNewDBgrid.SetColumnAttributes;
var
  I: Integer;
begin
  for I := 0 to Columns.Count-1 do
  with Columns[I] do
  begin
    TabStops[I + IndicatorOffset] := Showing and not ReadOnly and DataLink.Active and
      Assigned(Field) and not (Field.FieldKind = fkCalculated) and not ReadOnlyField(Field);
    ColWidths[I + IndicatorOffset] := Width;
  end;
  SetWidthRowNumber(Row);
end;

procedure TNewDBgrid.Scroll(Distance: Integer);
begin
  inherited Scroll(Distance);
  SetWidthRowNumber(Row);
end;

procedure TNewDBgrid.TopLeftChanged;
begin
  inherited TopLeftChanged;
end;

procedure TNewDBgrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  SetWidthRowNumber(Row);
end;

procedure TNewDBgrid.SetWidthRowNumber(NewRow: Integer);
var
  ARow: Integer;
  w,wmin: Integer;
  Plus: Integer;
begin
  if FVisibleRowNumber then begin
   if DataLink.DataSet<>nil then begin
    ARow:=GetRealTopRow(NewRow)+NewRow;
    Plus:=0;
    if dgIndicator in Options then Plus:=IndicatorWidth;
    wmin:=Canvas.TextWidth(inttostr(9))+3+Plus;
    w:=Canvas.TextWidth(inttostr(ARow))+3+Plus;
    if w<wmin then w:=wmin;
    colwidths[0]:=w;
   end else colwidths[0]:=IndicatorWidth;
  end else begin
    colwidths[0]:=IndicatorWidth;
  end;
end;

procedure TNewDBgrid.SetEditText(ACol, ARow: Longint; const Value: string);
begin
  inherited;
end;

function TNewDBgrid.GetEditText(ACol, ARow: Longint): string;
begin
  Result:=inherited GetEditText(ACol, ARow);
end;

function TNewDBgrid.SelectCell(ACol, ARow: Longint): Boolean;
begin
  SetWidthRowNumber(ARow);
  Result:=inherited SelectCell(ACol,ARow);
end;

procedure TNewDBgrid.TimedScroll(Direction: TGridScrollDirection);
begin
  inherited;
end;

function TNewDBgrid.GetRealTopRow(NewRow: Integer): Integer;
begin
  Result:=0;
  if DataLink.DataSet<>nil then begin
    if not DataLink.DataSet.IsEmpty then
      if DataLink.DataSet.State=dsBrowse then
        Result:=DataLink.DataSet.RecNo-NewRow
      else Result:=0;  
  end;
end;

procedure TNewDBgrid.LayoutChanged;
begin
  Inherited;
  SetDefaultRowHeight(FNewDefaultRowHeight);
end;

procedure TNewDBgrid.RowHeightsChanged;
var
  i,ThisHasChanged,Def : Integer;
begin
  ThisHasChanged:=-1;
  Def:=DefaultRowHeight;
  For i:=Ord(dgTitles In Options) to RowCount Do begin
    If RowHeights[i]<>Def Then Begin
      ThisHasChanged:=i;
      Break;
    End;
  End;
  If ThisHasChanged<>-1 Then Begin
    SetDefaultRowHeight(RowHeights[ThisHasChanged]);
    RecreateWnd;
  End;
  inherited;
end;

procedure TNewDBgrid.SetDefaultRowHeight(Value: Integer);
begin
  if Value<=GetMinRowHeight then begin
    Value:=GetMinRowHeight;
  end;
  inherited DefaultRowHeight:=Value;
  FNewDefaultRowHeight:=Value;
  if dgTitles in Options then begin
    Canvas.Font:=TitleFont;
    RowHeights[0]:=GetMinRowHeight;
  end;
end;

function TNewDBgrid.GetDefaultRowHeight: Integer;
begin
  Result:=inherited DefaultRowHeight;
end;

function TNewDBgrid.GetMinRowHeight: Integer;
begin
  Result:=Canvas.TextHeight('W')+4;
end;

procedure TNewDBgrid.DoTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); 
begin
end;

function TNewDBgrid.FindColumnByTitle(const Title: String): TColumn;
var
  i: Integer;
  AColumn: TColumn;
begin
  Result:=nil;
  for i:=0 to Columns.Count-1 do begin
    AColumn:=Columns.Items[i];
    if AnsiSameText(AColumn.Title.Caption,Title) then begin
      Result:=AColumn;
      exit;
    end;
  end;
end;

function TNewDBgrid.FindColumnByField(const FieldName: String): TColumn;
var
  i: Integer;
  AColumn: TColumn;
begin
  Result:=nil;
  for i:=0 to Columns.Count-1 do begin
    AColumn:=Columns.Items[i];
    if AnsiSameText(AColumn.FieldName,FieldName) then begin
      Result:=AColumn;
      exit;
    end;
  end;
end;

function TNewDBgrid.GetFontColor(Column: TColumn): TColor;
begin
  Result:=Font.Color;
  if Assigned(FOnGetFontColor) then
    Result:=FOnGetFontColor(Self,Column);
end;

function TNewDBgrid.GetBrushColor(Column: TColumn): TColor;
begin
  Result:=Brush.Color;
  if Assigned(FOnGetBrushColor) then
    Result:=FOnGetBrushColor(Self,Column);
end;


end.
