unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, StdCtrls, Db, DBTables, DBGrids, ComCtrls, Ex_Grid,
  Ex_Inspector;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GridView1: TGridView;
    TabSheet3: TTabSheet;
    Inspector1: TInspector;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure GridView1CellAcceptCursor(Sender: TObject; Cell: TGridCell; var Accept: Boolean);
    procedure GridView1EditButtonPress(Sender: TObject; Cell: TGridCell);
    procedure GridView1EditSelectNext(Sender: TObject; Cell: TGridCell);
    procedure GridView1GetCellColors(Sender: TObject; Cell: TGridCell; Canvas: TCanvas);
    procedure GridView1GetCellImage(Sender: TObject; Cell: TGridCell; var ImageIndex: Integer);
    procedure GridView1GetCellText(Sender: TObject; Cell: TGridCell; var Value: String);
    procedure GridView1GetEditList(Sender: TObject; Cell: TGridCell; Items: TStrings);
    procedure GridView1GetEditStyle(Sender: TObject; Cell: TGridCell; var Style: TGridEditStyle);
    procedure GridView1GetHeaderColors(Sender: TObject; Section: TGridHeaderSection; Canvas: TCanvas);
    procedure GridView1SetEditText(Sender: TObject; Cell: TGridCell; var Value: String);
    procedure Inspector1GetCellText(Sender: TObject; Cell: TGridCell; var Value: String);
    procedure Inspector1GetEditStyle(Sender: TObject; Cell: TGridCell; var Style: TGridEditStyle);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Inspector1.Rows.Count := 20;
end;

procedure TForm1.GridView1CellAcceptCursor(Sender: TObject; Cell: TGridCell; var Accept: Boolean);
begin
  Accept := (Cell.Col in [2..4, 6..8]) and (Cell.Row in [1..4, 6..8]);
end;

procedure TForm1.GridView1EditButtonPress(Sender: TObject; Cell: TGridCell);
begin
  ShowMessage('Button Pressed...');
end;

procedure TForm1.GridView1EditSelectNext(Sender: TObject; Cell: TGridCell);
begin
  ShowMessage('Select Next Value...');
end;

procedure TForm1.GridView1GetCellColors(Sender: TObject; Cell: TGridCell; Canvas: TCanvas);
begin
  if (Cell.Col in [5, 9]) or ((Cell.Col >= GridView1.Fixed.Count) and (Cell.Row in [0, 5, 9])) then Canvas.Brush.Color := clRed;
end;

procedure TForm1.GridView1GetCellImage(Sender: TObject; Cell: TGridCell; var ImageIndex: Integer);
begin
  ImageIndex := Cell.Col - 1;
  if Cell.Col < 2 then ImageIndex := -1;
end;

procedure TForm1.GridView1GetCellText(Sender: TObject; Cell: TGridCell; var Value: String);
begin
  if (Cell.Col in [5, 9]) or ((Cell.Col >= GridView1.Fixed.Count) and (Cell.Row in [0, 5, 9])) then
    Value := 'Cell can''t get focus'
  else
    case Cell.Col of
      3: Value := Format('%d%d'#13#10'1234567890'#13#10'Sender: TObject; Cell: TGridCell;', [Cell.Col, Cell.Row]);
      4: Value := Format('%d', [Cell.Col + Cell.Row]);
      else Value := Format('%d%d - 1234567890', [Cell.Col, Cell.Row])
    end;
end;

procedure TForm1.GridView1GetEditList(Sender: TObject; Cell: TGridCell; Items: TStrings);
begin
  Items.Add(Format('%d - %d', [Cell.Col, Cell.Row]));
  Items.Add(Format('%d - %d', [Cell.Col, Cell.Row + 1]));
  Items.Add(Format('%d - %d', [Cell.Col, Cell.Row + 2]));
  Items.Add(Format('%d - %d', [Cell.Col, Cell.Row + 3]));
end;

procedure TForm1.GridView1GetEditStyle(Sender: TObject; Cell: TGridCell; var Style: TGridEditStyle);
begin
  case (Cell.Col + 1) mod 3 of
    0: Style := geSimple;
    1: Style := geEllipsis;
    2: Style := gePickList;
  end;
end;

procedure TForm1.GridView1GetHeaderColors(Sender: TObject; Section: TGridHeaderSection; Canvas: TCanvas);
begin
  case Section.Column  of
    2: Canvas.Brush.Color := clBlue;
    3: if Section.Level = Section.Header.MaxLevel then
       begin
         Canvas.Font.Style := [];
         Canvas.Font.Color := clFuchsia;
       end;
    4: if Section.Level = 1 then Canvas.Font.Style := [fsBold, fsItalic];
  end;
end;

procedure TForm1.GridView1SetEditText(Sender: TObject; Cell: TGridCell; var Value: String);
begin
 if Cell.Col = 4 then StrToInt(Value);
end;

procedure TForm1.Inspector1GetCellText(Sender: TObject; Cell: TGridCell; var Value: String);
begin
  case Cell.Col of
    0: Value := Format(' %d%d', [Cell.Col, Cell.Row]);
    1: Value := Format('%d - %d - 1234567890987654321', [Cell.Col, Cell.Row]);
  end;
end;

procedure TForm1.Inspector1GetEditStyle(Sender: TObject; Cell: TGridCell; var Style: TGridEditStyle);
begin
  case Cell.Row mod 3 of
    0: Style := geSimple;
    1: Style := geEllipsis;
    2: Style := gePickList;
  end;
end;

end.
