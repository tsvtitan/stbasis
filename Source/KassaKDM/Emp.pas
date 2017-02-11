unit Emp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinTab, Db, IBDatabase, IBCustomDataSet, IBQuery, Grids, DBGrids,
  ExtCtrls, DBCtrls, StdCtrls, Data;

type
  TFEmp = class(TFTable)
  procedure FormCreate(Sender: TObject);
  procedure DBGridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FEmp: TFEmp;

implementation

procedure TFEmp.FormCreate(Sender: TObject);
var
   sqls: string;
   cl: TColumn;
   List: TStrings;
begin
 inherited;
  try
    Caption := 'Сотрудники';
{    IBTable.Database := IBDatabase;
    IBTable.Transaction := IBTransaction;}
    sqls := 'select * from Emp';
    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    IBTable.Active := True;

    SourceQuery := sqls;


    DBGrid.Columns.Clear;
    DBGrid.OnDblClick := DBGridDblClick;

  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFEmp.DBGridDblClick(Sender: TObject);
begin
  if ModeView then begin
    TempList.Clear;
    TempList.Add(Trim(IBTable.FieldByName('EMP_ID').AsString));
    TempList.Add(Trim(IBTable.FieldByName('FNAME').AsString));
    TempList.Add(Trim(IBTable.FieldByName('NAME').AsString));
    TempList.Add(Trim(IBTable.FieldByName('SNAME').AsString));
    ModalResult := mrOk;
  end;
end;

end.
