unit URBPrivilege;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, IBUpdateSQL;

type
  TfmRBPrivelege = class(TfmRBMainGrid)
    procedure FormCreate(Sender: TObject);

  private
    isFindName: Boolean;
    FindName: String;

    { Private declarations }
protected
    procedure GridTitleClick(Column: TColumn); override;
    procedure GridDblClick(Sender: TObject); override;
    function CheckPermission: Boolean; override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string;
  public
    { Public declarations }
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;


var
  fmRBPrivelege: TfmRBPrivelege;

implementation
uses UMainUnited, USalaryVAVCode, USalaryVAVDM, USalaryVAVData,UEditRBCalcPeriod, UTreeBuilding;
{$R *.DFM}


procedure TfmRBPrivelege.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  try
   Mainqr.sql.Clear;
   sqls:=' select cp.name, pr.selfprivelege as selfprivelege, '+
        ' pr.dependentprivelege as dependentprivelege '+
        ' from privelege pr '+
        ' join calcperiod cp on pr.calcperiod_id = cp.calcperiod_id '+
        ' where startdate like ''%2001%'' + bn'
+tbPrivelege+GetFilterString+LastOrderStr;


   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindName);
   ViewCount;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPrivelege.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: string;
begin
 try
  if not MainQr.Active then exit;
  if MainQr.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('calcperiod_id').asString;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   LastOrderStr:=' Order by '+fn;
   MainQr.SQL.Add('Select * from '+tbcalcperiod+GetFilterString+LastOrderStr);
   MainQr.Transaction.Active:=false;
   MainQr.Transaction.Active:=true;
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('calcperiod_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPrivelege.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;


procedure TfmRBPrivelege.LoadFromIni;
begin
 inherited;
  try
    FindName:=ReadParam(ClassName,'name',FindName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
 {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPrivelege.SaveToIni;
begin
 inherited;
  try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;




procedure TfmRBPrivelege.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
  inherited;
  try
   Caption:=NameCalcPeriod;
   Mainqr.Database:=IBDB;
   IBTran.AddDatabase(IBDB);
   IBDB.AddTransaction(IBTran);
   cl:=Grid.Columns.Add;
   cl.FieldName:='CalcPeriod';
   cl.Title.Caption:='Рассчетный период';
   cl.Width:=60;
   cl:=Grid.Columns.Add;
{   cl.FieldName:='empplant';
   cl.Title.Caption:='Рассчетный период';
   cl.Width:=200;}
   cl:=Grid.Columns.Add;
   cl.FieldName:='SelfPrivelege';
   cl.Title.Caption:='Льгота на себя';
   cl.Width:=60;
   cl:=Grid.Columns.Add;
   cl.FieldName:='DependenPrivelege';
   cl.Title.Caption:='Льгота на иждевенца';
   cl.Width:=60;


   LoadFromIni;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

function TfmRBPrivelege.CheckPermission: Boolean;
begin
  isPerm:=_isPermission(tbcalcperiod,SelConst);
  bibOk.Enabled:=isPerm;
  if not ViewSelect then begin
   bibAdd.Enabled:=isPerm and _isPermission(tbcalcperiod,InsConst);
   bibChange.Enabled:=isPerm and _isPermission(tbcalcperiod,UpdConst);
   bibDel.Enabled:=isPerm and _isPermission(tbcalcperiod,DelConst);
   bibView.Enabled:=isPerm;
   bibFilter.Enabled:=isPerm;
   bibAdjust.Enabled:=isPerm;
  end else begin
   pnSQL.Visible:=false;
  end;
  Result:=isPerm;
end;

function TfmRBPrivelege.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:='';

    isFindName:=Trim(FindName)<>'';

    if isFindName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


end.
