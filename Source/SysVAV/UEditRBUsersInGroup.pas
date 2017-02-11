unit UEditRBUsersInGroup;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  tsvDbGrid, ComCtrls, DualList, IBCustomDataSet, Grids, DBGrids, RxMemDS;

type
  TfmEditRBUsersInGroup = class(TfmEditRB)
    Panel1: TPanel;
    pnSrc: TPanel;
    pnMan: TPanel;
    pnDst: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    MainQr: TIBQuery;
    DataSource1: TDataSource;
    MemDSrc: TRxMemoryData;
    MemDDst: TRxMemoryData;
    DSSrc: TDataSource;
    DSDst: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edNameNumeratorChange(Sender: TObject);
    procedure bNameTypeNumeratorClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    UsersInGroup_id,oldUsersInGroup_id: Integer;
    UserGroup_id,OldUserGroup_id: Integer;
    fmParent:TForm;
    GridSrc,GridDst: TNewdbGrid;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
    function FillGridSrc(UserGroup:Integer): Boolean;
    function FillGridDst(UserGroup:Integer): Boolean;
    
  end;

var
  fmEditRBUsersInGroup: TfmEditRBUsersInGroup;

implementation

uses USysVAVCode, USysVAVData, UMainUnited, URBUsersGroup, STVAVKit;

{$R *.DFM}

procedure TfmEditRBUsersInGroup.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBUsersInGroup.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbTypeNumerator,1));
    try
      qr.sql.Clear;
    finally
      sqls:='Insert into '+ tbUsersInGroup +
            ' (UsersInGroup_id,NameUsersInGroup,Prefix,Suffix,StartDate,TypeNumerator_id,NameGenerator,About) values '+
            ' ('+id;
{            ','+QuotedStr(Trim(edNameNumerator.text))+
            ','+QuotedStr(Trim(edPrefix.text))+
            ','+QuotedStr(Trim(edSuffix.text))+
            ','+QuotedStr(DateToStr(DTPStartDate.Date))+
            ','+IntToStr(TypeNumerator_id)+
            ','+QuotedStr(Trim(NameGenerator))+
            ','+QuotedStr(Trim(meAbout.text))+'';
     qr.SQL.Add(sqls);                           }
      qr.ExecSQL;

    //Если запись падает куда и планировали
    if (oldUserGroup_id=UserGroup_id) then
    begin

//      TfmRBTypeNumerator(fmParent).updDetail.InsertSQL.Clear;
//      TfmRBTypeNumerator(fmParent).updDetail.InsertSQL.Add(sqls);

{      with TfmRBTypeNumerator(fmParent).qrDetail do begin
        Insert;
{        FieldByName('UsersInGroup_id').AsInteger:=StrToInt(id);
        FieldByName('NameUsersInGroup').AsString:=Trim(edNameNumerator.text);
        FieldByName('Prefix').AsString:=Trim(edPrefix.text);
        FieldByName('Suffix').AsString:=Trim(edSuffix.text);
        FieldByName('StartDate').AsString:=DateToStr(DTPStartDate.Date);
        FieldByName('TypeNumerator_id').AsInteger:=TypeNumerator_id;
        FieldByName('NAMEGenerator').AsString:=Trim(NameGenerator);
        FieldByName('About').AsString:=Trim(meAbout.text);
        FieldByName('NameTypeNumerator').AsString:=Trim(edNameTypeNumerator.text);
       Post;
      end;}
    end;
     oldUsersInGroup_id:=strtoint(id);
     qr.Transaction.Commit;
    end;
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
 {$IFDEF DEBUG}
     on E: Exception do Assert(false,E.message);
    {$ENDIF}
 end;
end;

procedure TfmEditRBUsersInGroup.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBUsersInGroup.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(UsersInGroup_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbUsersInGroup+
{            ' set NameUsersInGroup='+QuotedStr(Trim(edNameNumerator.text))+
            ', Prefix='+QuotedStr(Trim(edPrefix.text))+
            ', Suffix='+QuotedStr(Trim(edSuffix.text))+
            ', StartDate='+QuotedStr(DateToStr(DTPStartDate.Date))+
            ', TypeNumerator_id='+IntToStr(TypeNumerator_id)+
            ', about='+QuotedStr(Trim(meAbout.text))+}
            ' where UsersInGroup_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    //Если запись падает куда и планировали
    if (oldUserGroup_id=UserGroup_id) then
    begin

//            TfmRBTypeNumerator(fmParent).updDetail.ModifySQL.Clear;
//          TfmRBTypeNumerator(fmParent).updDetail.ModifySQL.Add(sqls);

{           with TfmRBTypeNumerator(fmParent).qrDetail do begin
              Edit;
{              FieldByName('UsersInGroup_id').AsInteger:=StrToInt(id);
              FieldByName('NameUsersInGroup').AsString:=Trim(edNameNumerator.text);
              FieldByName('Prefix').AsString:=Trim(edPrefix.text);
              FieldByName('Suffix').AsString:=Trim(edSuffix.text);
              FieldByName('StartDate').AsString:=DateToStr(DTPStartDate.Date);
              FieldByName('TypeNumerator_id').AsInteger:=TypeNumerator_id;
              FieldByName('About').AsString:=Trim(meAbout.text);;
              Post;
            end;}
    end
            else
    begin
      sqls:='Delete from '+tbUsersInGroup+' where UsersInGroup_id='+inttostr(oldUsersInGroup_id);
//    TfmRBTypeNumerator(fmParent).updDetail.DeleteSQL.Clear;
//    TfmRBTypeNumerator(fmParent).updDetail.DeleteSQL.Add(sqls);
//    TfmRBTypeNumerator(fmParent).qrDetail.Delete;
    end;
    qr.Transaction.Commit;
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBUsersInGroup.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBUsersInGroup.CheckFieldsFill: Boolean;
begin
{  Result:=false;
  if trim(edNameNumerator.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbNameNumerator.Caption]));
    edNameNumerator.SetFocus;
    exit;
  end;
  if trim(edNameTypeNumerator.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbNameTypeNumerator.Caption]));
    edNameTypeNumerator.SetFocus;
    exit;
  end;}
  result:=true;
end;

procedure TfmEditRBUsersInGroup.FormCreate(Sender: TObject);
var
  cl: TColumn;

begin
  inherited;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);


  GridSrc:=TNewdbGrid.Create(self);
  GridSrc.Parent:=pnSrc;
  GridSrc.Align:=alClient;
  GridSrc.DataSource:=DSSrc;
  GridSrc.Name:='GridSrc';


  GridDst:=TNewdbGrid.Create(self);
  GridDst.Parent:=pnDst;
  GridDst.Align:=alClient;
  GridDst.DataSource:=DSDst;
  GridDst.Name:='GridDst';

  MemDSrc.FieldDefs.Add('USER_ID',ftInteger,0,false);

  MemDDst.FieldDefs.Add('USER_ID',ftInteger,0,false);

  cl:=GridSrc.Columns.Add;
  cl.FieldName:='NAME';
  cl.Title.Caption:='Пользователи';
  cl.Width:=200;
  MemDSrc.FieldDefs.Add('NAME',ftString,30,false);

  cl:=GridDst.Columns.Add;
  cl.FieldName:='NAME';
  cl.Title.Caption:='Пользователи';
  cl.Width:=200;
  MemDDst.FieldDefs.Add('NAME',ftString,30,false);

  GridSrc.TabOrder:=1;
  GridDst.TabOrder:=2;
//  ShowingChanged;
//  FillGridSrc(UserGroup_id);
//  FillGridDst(UserGroup_id);
//  LoadFromIni;

//  SetCurrentReleaseId;





end;

procedure TfmEditRBUsersInGroup.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBUsersInGroup.edNameNumeratorChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBUsersInGroup.bNameTypeNumeratorClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
{  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='TypeNumerator_id';
  TPRBI.Locate.KeyValues:=TypeNumerator_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeNumerator,@TPRBI) then begin
   ChangeFlag:=true;
   TypeNumerator_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TypeNumerator_id');
//   edNameTypeNumerator.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NameTypeNumerator');
  end;}
end;

function TfmEditRBUsersInGroup.FillGridSrc(UserGroup:Integer): Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    qr.sql.Clear;
    sqls:='select u.user_id, u.name from '+ tbUsers + ' u ' +
            ' where u.user_id  not in'+
            ' (select u.user_id from users u'+
            ' join usersingroup uig on uig.user_id=u.user_id'+
            ' where uig.usergroup_id='+IntToStr(UserGroup)+')';
    qr.SQL.Add(sqls);
    qr.Open;
    MemDSrc.EmptyTable;
    while (not qr.Eof) do
         begin
            MemDSrc.Active:=true;
            MemDSrc.Append;
              MemDSrc.FieldByName('NAME').AsString := qr.FieldByName('NAme').AsString;
              MemDSrc.FieldByName('user_id').AsInteger := qr.FieldByName('user_id').AsInteger;
            MemDSrc.Post;
            qr.Next;
        end;
    qr.Transaction.CommitRetaining;
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
 {$IFDEF DEBUG}
     on E: Exception do Assert(false,E.message);
    {$ENDIF}
 end;
end;

function TfmEditRBUsersInGroup.FillGridDst(UserGroup:Integer): Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    qr.sql.Clear;
    sqls:='select u.user_id, u.name from '+ tbUsers + ' u ' +
            ' where u.user_id  in'+
            ' (select u.user_id from users u'+
            ' join usersingroup uig on uig.user_id=u.user_id'+
            ' where uig.usergroup_id='+IntToStr(UserGroup)+')';
    qr.SQL.Add(sqls);
    qr.Open;
    MemDDst.EmptyTable;
    while (not qr.Eof) do
         begin
            MemDDst.Active:=true;
            MemDDst.Append;
              MemDDst.FieldByName('NAME').AsString := qr.FieldByName('NAme').AsString;
              MemDDst.FieldByName('user_id').AsInteger := qr.FieldByName('user_id').AsInteger;
            MemDDst.Post;
            qr.Next;
        end;
    qr.Transaction.CommitRetaining;
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
 {$IFDEF DEBUG}
     on E: Exception do Assert(false,E.message);
    {$ENDIF}
 end;
end;

end.


{

select u.name from users u
where u.user_id  not in
(select u.user_id from users u
join usersingroup uig on uig.user_id=u.user_id
where uig.usergroup_id=1)

}
