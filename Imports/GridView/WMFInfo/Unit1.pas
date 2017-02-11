unit Unit1;

interface

uses
  Windows, Messages, ShellAPI, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Ex_Grid, ExtCtrls, Menus;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    GridView1: TGridView;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GridView1GetCellText(Sender: TObject; Cell: TGridCell; var Value: String);
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    FEMF: TMetafile;
    FEMFHeader: TEnhMetaHeader;
    procedure OpenFile(const FileName: string);
    procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.OpenFile(const FileName: string);
begin
  FEMF.LoadFromFile(FileName);
  GetEnhMetaFileHeader(FEMF.Handle, Sizeof(FEMFHeader), @FEMFHeader);
  Caption := 'WMF Info - ' + FileName;
  GridView1.Invalidate;
end;

procedure TForm1.WMDropFiles(var Message: TWMDropFiles);
var
  DropCount, DropSize: Word;
  DropName: string;
begin
  with Message do
  begin
    DropCount := DragQueryFile(Drop, $FFFFFFFF, nil, 0);
    if DropCount > 0 then
    begin
      DropSize := DragQueryFile(Drop, 0, nil, 0);
      SetLength(DropName, DropSize);
      DragQueryFile(Drop, 0, PChar(DropName), DropSize + 1);
      OpenFile(DropName);
    end;
    DragFinish(Drop);
  end;
  inherited;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FEMF := TMetafile.Create;
  DragAcceptFiles(Handle, True);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FEMF.Free;
end;

procedure TForm1.GridView1GetCellText(Sender: TObject; Cell: TGridCell;
  var Value: String);
begin
  with FEMFHeader do
    case Cell.Col of
      0:
        { Fields }
        case Cell.Row of
          0: Value := 'iType';
          1: Value := 'nSize';
          2: Value := 'rclBounds';
          3: Value := 'rclFrame';
          4: Value := 'dSignature';
          5: Value := 'nVersion';
          6: Value := 'nBytes';
          7: Value := 'nRecords';
          8: Value := 'nHandles';
          9: Value := 'sReserved';
          10: Value := 'nDescription';
          11: Value := 'offDescription';
          12: Value := 'nPalEntries';
          13: Value := 'szlDevice';
          14: Value := 'szlMillimeters';
          15: Value := 'cbPixelFormat';
          16: Value := 'offPixelFormat';
          17: Value := 'bOpenGL';
        end;
      1:
        { Values }
        case Cell.Row of
          0: Value := IntToStr(iType);
          1: Value := IntToStr(nSize);
          2: Value := Format('%d, %d, %d, %d', [rclBounds.Left, rclBounds.Top, rclBounds.Right, rclBounds.Bottom]);
          3: Value := Format('%d, %d, %d, %d', [rclFrame.Left, rclFrame.Top, rclFrame.Right, rclFrame.Bottom]);
          4: Value := Format('$%8.8x', [dSignature]);
          5: Value := IntToStr(nVersion);
          6: Value := IntToStr(nBytes);
          7: Value := IntToStr(nRecords);
          8: Value := IntToStr(nHandles);
          9: Value := IntToStr(sReserved);
          10: Value := IntToStr(nDescription);
          11: Value := IntToStr(offDescription);
          12: Value := IntToStr(nPalEntries);
          13: Value := Format('%d, %d', [szlDevice.cX, szlDevice.cY]);
          14: Value := Format('%d, %d', [szlMillimeters.cX, szlMillimeters.cY]);
          15: Value := IntToStr(cbPixelFormat);
          16: Value := IntToStr(offPixelFormat);
          17: Value := IntToStr(bOpenGL)
        end;
      2:
        { Descriptions }
        case Cell.Row of
          0: Value := 'Record type (must be 1).';
          1: Value := 'Record size in bytes. This may be greater than the SizeOf(TEnhMetaHeader).';
          2: Value := 'Inclusive-inclusive bounds in device units.';
          3: Value := 'Inclusive-inclusive Picture Frame of metafile in .01 mm units.';
          4: Value := 'Signature (must be $464D4520).';
          5: Value := 'Version number.';
          6: Value := 'Size of the metafile in bytes.';
          7: Value := 'Number of records in the metafile.';
          8: Value := 'Number of handles in the handle table. Handle index zero is reserved.';
          9: Value := 'Reserved. Must be zero.';
          10: Value := 'Number of chars in the unicode description string. This is 0 if there is no description string.';
          11: Value := 'Offset to the metafile description record. This is 0 if there is no description string.';
          12: Value := 'Number of entries in the metafile palette.';
          13: Value := 'Size of the reference device in pels.';
          14: Value := 'Size of the reference device in millimeters.';
          15: Value := 'Size of TPixelFormatDescriptor information. This is 0 if no pixel format is set.';
          16: Value := 'Offset to TPixelFormatDescriptor. This is 0 if no pixel format is set.';
          17: Value := 'TRUE if OpenGL commands are present in the metafile, otherwise FALSE.';
        end;
    end;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then OpenFile(OpenDialog1.FileName);
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.
