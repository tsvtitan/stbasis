{
  Библиотека дополнительных компонентов

  Регистрация компонент в Delphi IDE

  Роман М. Мочалов
  E-mail: roman@sar.nnov.ru
}

unit Ex_Reg;

interface

uses
  Windows, SysUtils, Classes, Forms, Dialogs, DsgnIntf;

type

{ TGridEditor }

  TGridEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

{ TGridColumnsProperty }

  TGridColumnsProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

{ TGridHeaderProperty }

  TGridHeaderProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure Register;

implementation

uses
  Ex_Grid, Ex_GridC, Ex_GridH, Ex_Inspector;

{ TGridEditor }

procedure TGridEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: if EditGridColumns(TCustomGridView(Component)) then Designer.Modified;
    1: if EditGridHeader(TCustomGridView(Component)) then Designer.Modified;
  end;
end;

function TGridEditor.GetVerb(Index: Integer): AnsiString;
begin
  case Index of
    0: Result := 'Columns Editor...';
    1: Result := 'Header Editor...';
  end;
end;

function TGridEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

{ TGridColumnsProperty }

procedure TGridColumnsProperty.Edit;
begin
  if EditGridColumns(TGridColumns(GetOrdValue).Grid) then Modified;
end;

function TGridColumnsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

{ TGridHeaderProperty }

procedure TGridHeaderProperty.Edit;
begin
  if EditGridHeader(TGridHeaderSections(GetOrdValue).Header.Grid) then Modified;
end;

function TGridHeaderProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

procedure Register;
begin
  RegisterComponents('Extended', [TGridView]);
  RegisterComponents('Extended', [TInspector]);

  RegisterComponentEditor(TGridView, TGridEditor);

  RegisterPropertyEditor(TypeInfo(TGridColumns), TGridView, 'Columns', TGridColumnsProperty);
  RegisterPropertyEditor(TypeInfo(TGridHeaderSections), TGridHeader, 'Sections', TGridHeaderProperty);
end;

end.
