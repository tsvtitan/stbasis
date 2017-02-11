unit tsvFilterEdit;

interface

uses Windows, Classes,
  Graphics, Forms, Controls, Buttons, Dialogs, StdCtrls, ExtCtrls,
  DsgnIntf, Grids;

type
  TfmFilterEditor = class(TForm)
    bibOk: TButton;
    bibCancel: TButton;
    sgValues: TStringGrid;
    procedure MemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
  public
    procedure SetCaption(AComponent: TComponent);
    procedure SetValuesToSg(Str: string);
    function GetValuesFromSg: string;
  end;

  TFilterProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;


implementation

{$R *.DFM}

uses SysUtils, LibHelp, UCmptsTsvData;

{ TfmFilterEditor }

procedure TfmFilterEditor.SetCaption(AComponent: TComponent);
begin
  if AComponent<>nil then
   Caption:=Format(fmtSetCaption,['Редактор фильтра',AComponent.Name])
  else
   Caption:='Редактор фильтра';
end;

procedure TfmFilterEditor.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then bibCancel.Click;
end;

procedure TfmFilterEditor.SetValuesToSg(Str: string);
var
  tmps: string;
  APos: Integer;
  c,r: Integer;
  flag: Boolean;
const
  Sep='|';
begin
  tmps:=str;
  APos:=-1;
  c:=0;
  r:=1;
  flag:=false;
  while APos<>0 do begin
    APos:=Pos(Sep,tmps);
    if APos>0 then begin
      sgValues.Cells[c,r]:=Copy(tmps,1,APos-1);
      tmps:=Copy(tmps,Apos+1,Length(tmps)-APos);
      if not Flag then begin
        inc(c);
        if c=1 then Flag:=true;
      end else begin
        c:=0;
        inc(r);
        if r>sgValues.RowCount then exit;
        Flag:=false;
      end;
    end else begin
      sgValues.Cells[c,r]:=tmps;
    end;
  end;
end;

function TfmFilterEditor.GetValuesFromSg: string;
var
  i: Integer;
  tmps: string;
const
  Sep='|';  
begin
  Result:='';
  for i:=1 to sgValues.RowCount-1 do begin
    if Trim(sgValues.Cells[0,i])<>'' then
     if i=1 then
      tmps:=sgValues.Cells[0,i]+Sep+sgValues.Cells[1,i]
     else
      tmps:=tmps+Sep+sgValues.Cells[0,i]+Sep+sgValues.Cells[1,i];
  end;
  Result:=tmps;
end;


procedure TfmFilterEditor.FormCreate(Sender: TObject);
begin
  sgValues.DefaultColWidth:=sgValues.Width div 2 - 15;
  sgValues.Cells[0,0]:='Имя фильтра';
  sgValues.Cells[1,0]:='Фильтр';
end;

{ TFilterProperty }

function TFilterProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

procedure TFilterProperty.Edit;
var
  comp: TPersistent;
begin
  with TfmFilterEditor.Create(Application) do
  try
    SetValuesToSg(GetStrValue);
    comp:=GetComponent(0);
    if comp is TComponent then
      SetCaption(TComponent(comp));
    ActiveControl := sgValues;
    case ShowModal of
      mrOk: SetStrValue(GetValuesFromSg);
    end;
  finally
    Free;
  end;
end;


end.
