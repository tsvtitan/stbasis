unit NDS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinTab, Db, IBDatabase, IBCustomDataSet, IBQuery, Grids, DBGrids,
  ExtCtrls, DBCtrls, StdCtrls, Data;

type
  TFNDS = class(TFTable)
  procedure FormCreate(Sender: TObject);
  procedure DBGridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FNDS: TFNDS;

implementation


procedure TFNDS.FormCreate(Sender: TObject);
var
   sqls: string;
   cl: TColumn;
   List: TStrings;
begin
 inherited;
  try
    List := TStringList.Create;
    Caption := 'ÍÄÑ';
{    IBTable.Database := IBDatabase;
    IBTable.Transaction := IBTransaction;}
    sqls := 'select * from TAXES';
    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    IBTable.Active := True;

    SourceQuery := sqls;


    DBGrid.Columns.Clear;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFNDS.DBGridDblClick(Sender: TObject);
begin
  if (ModeView) AND not IBTable.IsEmpty then begin
    TempList.Clear;
    TempList.Add(Trim(IBTable.FieldByName('TAXES_ID').AsString));
    TempList.Add(Trim(IBTable.FieldByName('TAXES_CONTENTS').AsString));
    ModalResult := mrOk;
  end;
end;

end.
