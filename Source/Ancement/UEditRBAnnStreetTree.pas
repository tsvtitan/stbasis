unit UEditRBAnnStreetTree;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls,tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBAnnStreetTree = class(TfmEditRB)
    lbTreeHeading: TLabel;
    edTreeHeading: TEdit;
    bibTreeHeading: TButton;
    lbStreet: TLabel;
    edStreet: TEdit;
    bibStreet: TButton;
    procedure FormCreate(Sender: TObject);
    procedure bibTreeHeadingClick(Sender: TObject);
    procedure edWordChange(Sender: TObject);
    procedure bibStreetClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldtreeheading_id: Integer;
    oldann_street_id: Integer;
    treeheading_id: Integer;
    ann_street_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBAnnStreetTree: TfmEditRBAnnStreetTree;

implementation

uses UAncementCode, UAncementData, UMainUnited, URBAnnStreetTree;

{$R *.DFM}

procedure TfmEditRBAnnStreetTree.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBAnnStreetTree.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbAnnStreetTree+
          ' (treeheading_id,ann_street_id) values '+
          ' ('+inttostr(treeheading_id)+
          ','+inttostr(ann_street_id)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    oldtreeheading_id:=treeheading_id;
    oldann_street_id:=ann_street_id;

    TfmRBAnnStreetTree(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBAnnStreetTree(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBAnnStreetTree(fmParent).MainQr do begin
      Insert;
      FieldByName('treeheading_id').AsInteger:=treeheading_id;
      FieldByName('ann_street_id').AsInteger:=ann_street_id;
      FieldByName('streetname').AsString:=Trim(edStreet.text);
      FieldByName('treeheadingname').AsString:=Trim(edTreeHeading.Text);
      Post;
    end;

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBAnnStreetTree.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBAnnStreetTree.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbAnnStreetTree+
          ' set treeheading_id='+inttostr(treeheading_id)+
          ', ann_street_id='+inttostr(ann_street_id)+
          ' where treeheading_id='+inttostr(oldtreeheading_id)+
          ' and ann_street_id='+inttostr(oldann_street_id);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    oldtreeheading_id:=treeheading_id;
    oldann_street_id:=ann_street_id;

    TfmRBAnnStreetTree(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBAnnStreetTree(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBAnnStreetTree(fmParent).MainQr do begin
      Edit;
      FieldByName('treeheading_id').AsInteger:=treeheading_id;
      FieldByName('ann_street_id').AsInteger:=ann_street_id;
      FieldByName('streetname').AsString:=Trim(edStreet.text);
      FieldByName('treeheadingname').AsString:=Trim(edTreeHeading.Text);
      Post;
    end;
    
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBAnnStreetTree.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBAnnStreetTree.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edTreeHeading.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTreeHeading.Caption]));
    bibTreeHeading.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edStreet.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbStreet.Caption]));
    edStreet.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBAnnStreetTree.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edStreet.MaxLength:=DomainNameLength;
  edTreeHeading.MaxLength:=DomainNameLength;
end;

procedure TfmEditRBAnnStreetTree.bibTreeHeadingClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='treeheading_id';
  TPRBI.Locate.KeyValues:=treeheading_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTreeHeading,@TPRBI) then begin
   ChangeFlag:=true;
   treeheading_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'treeheading_id');
   edTreeHeading.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'nameheading');
  end;
end;

procedure TfmEditRBAnnStreetTree.edWordChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAnnStreetTree.bibStreetClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='ann_street_id';
  TPRBI.Locate.KeyValues:=ann_street_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkAnnStreet,@TPRBI) then begin
   ChangeFlag:=true;
   ann_street_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'ann_street_id');
   edStreet.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

end.
