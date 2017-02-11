unit UEditRBTreeHeading;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls, tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBTreeheading = class(TfmEditRB)
    lbNameHeading: TLabel;
    edNameHeading: TEdit;
    lbParent: TLabel;
    edParent: TEdit;
    bibParent: TButton;
    lbSortNumber: TLabel;
    edSortNumber: TEdit;
    udSortNumber: TUpDown;
    fd: TFontDialog;
    GrbFont: TGroupBox;
    meFont: TMemo;
    bibFont: TButton;
    procedure edNameHeadingChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibParentClick(Sender: TObject);
    procedure edParentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibFontClick(Sender: TObject);
  private
    function GetFontHexString: string;  
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldtreeheading_id: Integer;
    ParentTreeHeadingId: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;

    procedure SetFontFromStringHex(HexStr: string);
  end;

var
  fmEditRBTreeheading: TfmEditRBTreeheading;

implementation

uses UAncementCode, UAncementData, UMainUnited, tsvComponentFont;//, URBTreeHeading;

{$R *.DFM}


{ TfmEditRBTreeheading }

procedure TfmEditRBTreeheading.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBTreeheading.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
  parent_id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbTreeHeading,1));
    if ParentTreeHeadingId=0 then
      parent_id:='null'
    else
      parent_id:=inttostr(ParentTreeHeadingId);
    sqls:='Insert into '+tbTreeHeading+
          ' (treeheading_id,nameheading,parent_id,sortnumber,font) values '+
          ' ('+id+','+QuotedStr(Trim(edNameHeading.Text))+','+parent_id+
          ','+inttostr(udSortNumber.Position)+','+QuotedStr(GetFontHexString)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldtreeheading_id:=strtoint(id);

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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBTreeheading.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBTreeheading.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id,parent_id: String;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(oldtreeheading_id);
    if ParentTreeHeadingId=0 then
      parent_id:='null'
    else
      parent_id:=inttostr(ParentTreeHeadingId);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbTreeHeading+
          ' set nameheading='+QuotedStr(Trim(edNameHeading.Text))+
          ', parent_id='+parent_id+
          ', sortnumber='+inttostr(udSortNumber.Position)+
          ', font='+QuotedStr(GetFontHexString)+
          ' where treeheading_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBTreeheading.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBTreeheading.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edNameHeading.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNameHeading.Caption]));
    edNameHeading.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBTreeheading.edNameHeadingChange(Sender: TObject);
begin
   ChangeFlag:=true;
end;

procedure TfmEditRBTreeheading.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edNameHeading.MaxLength:=DomainNameLength;
  edParent.MaxLength:=DomainNameLength;
  meFont.Lines.Text:=meFont.Font.Name;
end;

procedure TfmEditRBTreeheading.bibParentClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='treeheading_id';
  TPRBI.Locate.KeyValues:=ParentTreeHeadingId;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTreeHeading,@TPRBI) then begin
   ChangeFlag:=true;
   ParentTreeHeadingId:=GetFirstValueFromParamRBookInterface(@TPRBI,'treeheading_id');
   edParent.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'nameheading');
  end;
end;

procedure TfmEditRBTreeheading.edParentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  procedure ClearParent;
  begin
    if Length(edParent.Text)=Length(edParent.SelText) then begin
      edParent.Text:='';
      ParentTreeHeadingId:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearParent;
  end;
end;

procedure TfmEditRBTreeheading.SetFontFromStringHex(HexStr: string);
var
  cf: TComponentFont;
begin
  cf:=TComponentFont.Create(nil);
  try
   cf.SetFontFromHexStr(HexStr);
   meFont.Font.Assign(cf.Font);
   meFont.Lines.Text:=meFont.Font.Name;
  finally
   cf.Free;
  end; 
end;

function TfmEditRBTreeheading.GetFontHexString: string;
var
  cf: TComponentFont;
begin
  cf:=TComponentFont.Create(nil);
  try
    cf.Font.Assign(meFont.Font);
    Result:=cf.GetFontAsHexStr;
  finally
    cf.Free;
  end;
end;

procedure TfmEditRBTreeheading.bibFontClick(Sender: TObject);
begin
  fd.Font:=meFont.Font;
  if not fd.Execute then exit;
  ChangeFlag:=true;
  meFont.Font:=fd.Font;
  meFont.Lines.Text:=meFont.Font.Name;
end;

end.
