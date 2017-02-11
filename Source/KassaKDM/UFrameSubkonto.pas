unit UFrameSubkonto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB;

type
  TFrameSubkonto = class(TFrame)
    LSub1: TLabel;
    ESub1: TEdit;
    BSub1: TButton;
    LSub2: TLabel;
    ESub2: TEdit;
    BSub2: TButton;
    LSub3: TLabel;
    ESub3: TEdit;
    BSub3: TButton;
    LSub4: TLabel;
    ESub4: TEdit;
    BSub4: TButton;
    LSub5: TLabel;
    ESub5: TEdit;
    BSub5: TButton;
    LSub6: TLabel;
    ESub6: TEdit;
    BSub6: TButton;
    LSub7: TLabel;
    ESub7: TEdit;
    BSub7: TButton;
    LSub8: TLabel;
    ESub8: TEdit;
    BSub8: TButton;
    LSub9: TLabel;
    ESub9: TEdit;
    BSub9: TButton;
    LSub10: TLabel;
    ESub10: TEdit;
    BSub10: TButton;
    procedure BSub1Click(Sender: TObject);
    procedure BSub2Click(Sender: TObject);
    procedure BSub3Click(Sender: TObject);
    procedure BSub4Click(Sender: TObject);
    procedure BSub5Click(Sender: TObject);
    procedure BSub6Click(Sender: TObject);
    procedure BSub7Click(Sender: TObject);
    procedure BSub8Click(Sender: TObject);
    procedure BSub9Click(Sender: TObject);
    procedure BSub10Click(Sender: TObject);
    procedure OnChange(Sender: TObject);
  private
    Count,Button,IdAc: integer;
    isForPA: Boolean;
    procedure BSubClickPA(Sender: TObject);
    procedure BSubClick(Sender: TObject);
  public
    idSub,idInSub,idLevelSub: array [1..10] of integer;
    NameSubkonto,TableNameSubkonto,InterfaceNameSubkonto,FieldID,FieldText,DataSubkonto: TStrings;
    ChangeFlag: Boolean;
    function InitData(idAccount:Integer; InSub: string; isPA:Boolean=false): Boolean;
    function CheckFieldsFill :Boolean;
    function GetIdSub: Boolean;
    function GetIdInSub(str: string): Boolean;
    function GetStringForInsert: String;
    function DeInitData: Boolean;
    function ClearAll: Boolean;
  end;

implementation

uses UKassaKDMData, UMainUnited, UKassaKDMCode;

{$R *.DFM}

function TFrameSubkonto.InitData(idAccount:Integer; InSub: string; isPA:Boolean=false): Boolean;
var
 qr: TIBQuery;
 sqls: string;
 i,k: integer;
begin
 Result:=false;
 try
  k:=1;
  ChangeFlag := false;
  FieldId := TStringList.Create;
  FieldText := TStringList.Create;
  NameSubkonto := TStringList.Create;
  TableNameSubkonto := TStringList.Create;
  InterfaceNameSubkonto := TStringList.Create;
  DataSubkonto := TStringList.Create;
  FillChar(idSub,SizeOf(integer)*10,0);
  FillChar(idLevelSub,SizeOf(integer)*10,0);
  FillChar(idInSub,SizeOf(integer)*10,0);
  ClearAll;
  IdAc := idAccount;
  isForPA := isPA;

  if isForPA then
    Count := 10;

  GetIdSub;
  if not IsForPA then
    GetIdInSub(InSub);

  try
  for i:=1 to Count do begin
    with TLabel(FindComponent('LSub'+IntToStr(k))) do begin
      Visible := true;
      if isForPA then
        Caption := 'Субконто'+IntToStr(k)+':';
    end;
    with TEdit(FindComponent('ESub'+IntToStr(k))) do begin
      Visible := true;
    end;
    with TButton(FindComponent('BSub'+IntToStr(k))) do begin
      Visible := true;
    end;
    k:=k+1;
  end;
  finally
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFrameSubkonto.BSub1Click(Sender: TObject);
begin
  Button := 1;
  if IsForPA then
    BSubClickPA(Sender)
  else
    BSubClick(Sender);
end;

procedure TFrameSubkonto.BSub2Click(Sender: TObject);
begin
  Button := 2;
  if IsForPA then
    BSubClickPA(Sender)
  else
    BSubClick(Sender);
end;

procedure TFrameSubkonto.BSub3Click(Sender: TObject);
begin
  Button := 3;
  if IsForPA then
    BSubClickPA(Sender)
  else
    BSubClick(Sender);
end;

procedure TFrameSubkonto.BSub4Click(Sender: TObject);
begin
  Button := 4;
  if IsForPA then
    BSubClickPA(Sender)
  else
    BSubClick(Sender);
end;

procedure TFrameSubkonto.BSub5Click(Sender: TObject);
begin
  Button := 5;
  if IsForPA then
    BSubClickPA(Sender)
  else
    BSubClick(Sender);
end;

procedure TFrameSubkonto.BSub6Click(Sender: TObject);
begin
  Button := 6;
  if IsForPA then
    BSubClickPA(Sender)
  else
    BSubClick(Sender);
end;

procedure TFrameSubkonto.BSub7Click(Sender: TObject);
begin
  Button := 7;
  if IsForPA then
    BSubClickPA(Sender)
  else
    BSubClick(Sender);
end;

procedure TFrameSubkonto.BSub8Click(Sender: TObject);
begin
  Button := 8;
  if IsForPA then
    BSubClickPA(Sender)
  else
    BSubClick(Sender);
end;

procedure TFrameSubkonto.BSub9Click(Sender: TObject);
begin
  Button := 9;
  if IsForPA then
    BSubClickPA(Sender)
  else
    BSubClick(Sender);
end;

procedure TFrameSubkonto.BSub10Click(Sender: TObject);
begin
  Button := 10;
  if IsForPA then
    BSubClickPA(Sender)
  else
    BSubClick(Sender);
end;

procedure TFrameSubkonto.BSubClickPA(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='subkonto_id';
  TPRBI.Locate.KeyValues:=idSub[Button];
  TPRBI.Locate.Options:=[loCaseInsensitive];
  TPRBI.Condition.Wherestr := PChar(' subkonto_level='+IntToStr(Button));
  if _ViewInterfaceFromName(NameRbkKindSubkonto,@TPRBI) then begin
   ChangeFlag:=true;
    with TEdit(FindComponent('ESub'+IntToStr(Button))) do begin
      Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'subkonto_name');
    end;
   idSub[Button]:=GetFirstValueFromParamRBookInterface(@TPRBI,'subkonto_id');
  end;
end;

procedure TFrameSubkonto.BSubClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  qr: TIBQuery;
  sqls,cond: String;
begin
 try
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBT;
   try
     if Button <> 1 then begin
       sqls := 'select ss.*,ks1.subkonto_tablename,ks2.subkonto_tablename from '+tbSubkontoSubkonto+' ss,'+tbKindSubkonto+' ks1,'+tbKindSubkonto+' ks2 '+
                           'where ss_subkonto1=ks1.subkonto_id and ss_subkonto2=ks2.subkonto_id and ss_subkonto1='+IntToStr(idSub[Button-1])+
                           ' and ss_subkonto2='+IntToStr(idSub[Button]);
       qr.SQL.Clear;
       qr.SQL.Add(sqls);
       qr.Open;
       if (not qr.IsEmpty) and (idInSub[Button-1]<>0) then begin
         cond := Trim(qr.FieldByName('subkonto_tablename1').AsString)+'.'+Trim(qr.FieldByName('ss_relfield').AsString)+'='+IntToStr(idInSub[Button-1])+' ';
       end;
     end;  
     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tvibvModal;
     TPRBI.Locate.KeyFields:=PChar(FieldId[Button-1]);
     TPRBI.Locate.KeyValues:=idInSub[Button];
     TPRBI.Locate.Options:=[loCaseInsensitive];
     TPRBI.Condition.Wherestr := PChar(cond);
     if _ViewInterfaceFromName(PChar(InterfaceNameSubkonto[Button-1]),@TPRBI) then begin
       ChangeFlag:=true;
       with TEdit(FindComponent('ESub'+IntToStr(Button))) do begin
         Text:=GetFirstValueFromParamRBookInterface(@TPRBI,FieldText[Button-1]);
       end;
      idinSub[Button]:=GetFirstValueFromParamRBookInterface(@TPRBI,FieldId[Button-1]);
     end;
   finally
     qr.Free;
   end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TFrameSubkonto.CheckFieldsFill :Boolean;
var
  i,k: integer;
  Flag: Boolean;
begin
  Result:=false;
  k:=Count;
  Flag := false;
  if isForPA then
  for i:=1 to Count do begin
    if TEdit(FindComponent('ESub'+IntToStr(k))).Text='' then
      idSub[k] := 0;
    if (Flag) and (idSub[k]=0) then begin
      with TLabel(FindComponent('LSub'+IntToStr(k))) do
        ShowError(Handle,Format(ConstFieldNoEmpty,[Caption]));
      with TEdit(FindComponent('ESub'+IntToStr(k))) do
        SetFocus;
      Result:=false;
      exit;
    end;
    if idSub[k]<>0 then Flag := true;
    k:=k-1;
  end;
  if not isForPA then
  for i:=1 to Count do begin
    if TEdit(FindComponent('ESub'+IntToStr(k))).Text='' then
      idInSub[k] := 0;
    if (Flag) and (idInSub[k]=0) then begin
      with TLabel(FindComponent('LSub'+IntToStr(k))) do
        ShowError(Handle,Format(ConstFieldNoEmpty,[Caption]));
      with TEdit(FindComponent('ESub'+IntToStr(k))) do
        SetFocus;
      Result:=false;
      exit;
    end;
    if idInSub[k]<>0 then Flag := true;
    k:=k-1;
  end;
  Result:=true;
end;

function TFrameSubkonto.GetIdInSub(str: string): Boolean;
var
  qr: TIBQuery;
  sqls,str1: string;
  strIdSub,Buf: string;
  i,k,n,c,s: integer;
  Flag: Boolean;
begin
 Result:=false;
 try
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBT;
  try
   Flag := false;
   n:=1;
   c:=1;
   k:=1;
   if str='' then
     exit;
   while str[k]<>#0 do begin
     if (str[k]=';') then Flag := true;
     if Flag=true then begin
       str1 := Copy(str,n,k-n);
       idinSub[c]:=StrToInt(str1);
       Flag:=false;
       n:=k+1;
       c:=c+1;
     end;
     k := k+1;
   end;
   k:=1;
   while idinSub[k]<>0 do begin
     if (k>TableNameSubkonto.Count) then exit;
     sqls:='select * from '+TableNameSubkonto[k-1]+
           ' where '+FieldId[k-1]+'='+IntToStr(idinSub[k]);
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.Open;
     if not qr.IsEmpty then begin
       DataSubkonto.Add(Trim(qr.FieldByName(FieldText[k-1]).AsString));
       TEdit(FindComponent('ESub'+IntToStr(k))).Text := Trim(qr.FieldByName(FieldText[k-1]).AsString);
     end;
     k:=k+1;
   end;
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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TFrameSubkonto.GetStringForInsert: String;
var
 i,k: Integer;
 str: string;
begin
 str := '';
 if idInSub[1]<>0 then
   str := IntToStr(idInSub[1]);
 k:=2;
 while idInSub[k]<>0 do begin
   str := str+';'+IntToStr(idInSub[k]);
   k:=k+1;
 end;
 Result := str+';';
end;

function TFrameSubkonto.GetIdSub: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  strIdSub,Buf: string;
  i,k,n,c: integer;
  Flag: Boolean;
begin
 Result:=false;
 try
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBT;
  try
    sqls := 'select count(*) as ctn from '+tbPlanAccounts_KindSubkonto+' pk,'+tbKindSubkonto+' ks '+
            ' where pk.PAKS_SUBKONTO_ID=ks.SUBKONTO_ID and pk.PAKS_PA_ID='+IntToStr(IdAc);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    c := qr.FieldByName('ctn').asInteger;
    if not isForPA then
      Count := c;
    sqls := 'select pk.*,ks.*  from '+tbPlanAccounts_KindSubkonto+' pk,'+tbKindSubkonto+' ks '+
            ' where pk.PAKS_SUBKONTO_ID=ks.SUBKONTO_ID and pk.PAKS_PA_ID='+IntToStr(IdAc)+
            ' order by SUBKONTO_LEVEL asc';
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    k:=1;
    if c<>0 then begin
      qr.First;
      for i:=1 to c do begin
        idSub[k]:=qr.FieldByName('PAKS_SUBKONTO_ID').AsInteger;
        idLevelSub[k]:=qr.FieldByName('SUBKONTO_LEVEL').AsInteger;
        NameSubkonto.Add(Trim(qr.FieldByName('SUBKONTO_NAME').AsString));
        TableNameSubkonto.Add(Trim(qr.FieldByName('SUBKONTO_TABLENAME').AsString));
        InterfaceNameSubkonto.Add(Trim(qr.FieldByName('SUBKONTO_NAMEINTERFACE').AsString));
        FieldId.Add(Trim(qr.FieldByName('SUBKONTO_FIELDWITHID').AsString));
        FieldText.Add(Trim(qr.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString));
        if isForPA then
          TEdit(FindComponent('ESub'+IntToStr(k))).Text := NameSubkonto[k-1]
        else
          TLabel(FindComponent('LSub'+IntToStr(k))).Caption := NameSubkonto[k-1];
        k:=k+1;
        qr.Next;
      end;
    end;
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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TFrameSubkonto.DeInitData: Boolean;
begin
  Result := false;
  NameSubkonto.Free;
  TableNameSubkonto.Free;
  InterfaceNameSubkonto.Free;
  FieldId.Free;
  FieldText.Free;
  DataSubkonto.Free;
  Result := true;
end;

procedure TFrameSubkonto.OnChange(Sender: TObject);
begin
 ChangeFlag := true;
end;

function TFrameSubkonto.ClearAll: Boolean;
var
  i,k: Integer;
begin
 Result:=false;
 ChangeFlag := false;
 FillChar(idSub,SizeOf(integer)*10,0);
 FillChar(idLevelSub,SizeOf(integer)*10,0);
 FillChar(idInSub,SizeOf(integer)*10,0);
 Count:=0;
 IdAc:=-1;
 IsForPA := false;
 if NameSubkonto<>nil then
   NameSubkonto.Clear;
 if TableNameSubkonto<>nil then
   TableNameSubkonto.Clear;
 if InterfaceNameSubkonto<>nil then
   InterfaceNameSubkonto.Clear;
 if FieldId<>nil then
   FieldId.Clear;
 if FieldText<>nil then
   FieldText.Clear;
 if DataSubkonto<>nil then
   DataSubkonto.Clear;
 k:=1;
 for i:=1 to 10 do begin
    with TLabel(FindComponent('LSub'+IntToStr(k))) do begin
      Visible := false;
      Caption := '';
    end;
    with TEdit(FindComponent('ESub'+IntToStr(k))) do begin
      Visible := false;
      Text := '';
    end;
    with TButton(FindComponent('BSub'+IntToStr(k))) do begin
      Visible := false;
    end;
   k:=k+1;
 end;
 Result:=true;
end;

end.
