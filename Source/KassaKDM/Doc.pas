unit Doc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinTab, Db, IBDatabase, IBCustomDataSet, IBQuery, Grids, DBGrids,
  ExtCtrls, DBCtrls, StdCtrls, Data;

type
  TFDoc = class(TFTable)
  procedure FormCreate(Sender: TObject);
  procedure DBGridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDoc: TFDoc;

implementation

procedure TFDoc.FormCreate(Sender: TObject);
var
   sqls: string;
   cl: TColumn;
   List: TStrings;
begin
 inherited;
  try
    List := TStringList.Create;
    Caption := 'Документы, удостоверяющие личность';
{    IBTable.Database := IBDatabase;
    IBTable.Transaction := IBTransaction;}
    sqls := 'select * from EMPPERSONDOC';
    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    IBTable.Active := True;

    SourceQuery := sqls;


    DBGrid.Columns.Clear;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFDoc.DBGridDblClick(Sender: TObject);
begin
  if ModeView then begin
    TempList.Clear;
    TempList.Add(Trim(IBTable.FieldByName('PERSONDOCTYPE_ID').AsString));
    TempList.Add(Trim(IBTable.FieldByName('SERIAL').AsString));
    TempList.Add(Trim(IBTable.FieldByName('DATEWHERE').AsString));
    ModalResult := mrOk;
  end;
end;



end.
