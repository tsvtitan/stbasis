unit PlanAccounts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinTab, Db, IBCustomDataSet, IBQuery, Grids, DBGrids, ExtCtrls, DBCtrls,
  StdCtrls, Data, IB, Kassa, inifiles, AddPlanAc, EditPA,FilterPA, WTun;

type
  TPlanAc = class(TFTable)
  procedure FormCreate(Sender: TObject);
  procedure BAddClick(Sender: TObject);
  procedure BEditClick(Sender: TObject);
  procedure BDelClick(Sender: TObject);
  procedure BAccClick(Sender: TObject);
  procedure BFilterClick(Sender: TObject);
  procedure BTunClick(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
  procedure DBGridDblClick(Sender: TObject);
  private
    IdRec: string;
    FindNum,FindNam,FindNamAc,FindCur,FindAmo,
    FindBal,FindSaldo,FindSub1,FindSub2,FindSub3: string;
    function CompareQuery (List: TStrings): string;
    procedure SaveToIni;
    procedure LoadFromIni;
  public
    { Public declarations }
  end;

var
  PlanAc: TPlanAc;

implementation

procedure TPlanAc.FormCreate(Sender: TObject);
var
   sqls: string;
   cl: TColumn;
   List: TStrings;
begin
inherited;
  try
    List := TStringList.Create;
    ModeView := MView;
    Caption := 'План счетов';
{    IBTable.Database := IBDatabase;
    IBTable.Transaction := IBTransaction;}
    sqls :=  'select PA_ID, PA_GROUPID, (PA_SHORTNAME), PA_CURRENCY, PA_AMOUNT, '+
             'PA_BALANCE, KS_SHORTNAME, K1.SUBKONTO_NAME, K2.SUBKONTO_NAME, K3.SUBKONTO_NAME, '+
             'PA_NAMEACCOUNT '+                                                            
             'from PLANACCOUNTS, KINDSUBKONTO K1,KINDSALDO,KINDSUBKONTO K2, KINDSUBKONTO K3 '+
             'where PA_KS_ID=KS_ID AND (PA_SUBKONTO1=K1.SUBKONTO_ID) AND '+
             '(PA_SUBKONTO2=K2.SUBKONTO_ID) AND (PA_SUBKONTO3=K3.SUBKONTO_ID )';

    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    IBTable.Active := True;

    SourceQuery := sqls;

    DBGrid.Columns.Clear;
    cl:=DBGrid.Columns.Add;
    cl.FieldName:='PA_GROUPID';
    cl.Title.Caption:='№ счета';
    cl.Width:=100;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='PA_SHORTNAME';
    cl.Title.Caption:='Наименование';
    cl.Width:=100;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='PA_CURRENCY';
    cl.Title.Caption:='Валюта';
    cl.Width:=50;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='PA_AMOUNT';
    cl.Title.Caption:='Количественный';
    cl.Width:=50;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='PA_BALANCE';
    cl.Title.Caption:='Баланс';
    cl.Width:=50;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='KS_SHORTNAME';
    cl.Title.Caption:='Сальдо';
    cl.Width:=50;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='SUBKONTO_NAME';
    cl.Title.Caption:='Субконто1';
    cl.Width:=100;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='SUBKONTO_NAME1';
    cl.Title.Caption:='Субконто2';
    cl.Width:=100;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='SUBKONTO_NAME2';
    cl.Title.Caption:='Субконто3';
    cl.Width:=100;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='PA_NAMEACCOUNT';
    cl.Title.Caption:='Наименование счета';
    cl.Width:=100;

    BFilter.OnClick := BFilterClick;
    BTun.OnClick := BTunClick;
    OnDestroy := FormDestroy;
    DBGrid.OnDblClick := DBGridDblClick;

      LoadFromIni;
      List.Add(FindNum);
      List.Add(FindNam);
      List.Add(FindNamAc);
      List.Add(FindCur);
      List.Add(FindAmo);
      List.Add(FindBal);
      List.Add(FindSaldo);
      List.Add(FindSub1);
      List.Add(FindSub2);
      List.Add(FindSub3);
      sqls := CompareQuery(List);

    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    IBTable.Active := True;
    List.free;
    MView := false;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TPlanAc.BAddClick(Sender: TObject);
var
 fm: TFAddAccount;
begin
  try
    if not IBTable.Active then exit;
    fm := TFAddAccount.Create(nil);
    try
      OldRecId :=IBTable.FieldByName('PA_ID').AsString;
      if fm.ShowModal = mrok then begin
      end;
    finally
      fm.free;
      ActivateQuery;
      IBTable.Locate('PA_ID',OldRecId,[loCaseInsensitive]);
    end;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TPlanAc.BEditClick(Sender: TObject);
var
   fm: TFEditAccount;
   Index: integer;
   qr: TIBQuery;
   sqls: string;
begin
  try
    if not IBTable.Active then exit;
      IDRec := IBTable.FieldByName('PA_Id').AsInteger;
      fm := TFEditAccount.Create(nil);
      qr := TIBQuery.Create(nil);
      qr.Database:=Form1.IBDatabase;
      qr.Transaction := Form1.IBTransaction;
      qr.Transaction.Active:=true;
      try
        fm.MENum.Text := Trim(IBTable.FieldByName('PA_GROUPID').AsString);
        fm.ENam.Text := Trim(IBTable.FieldByName('PA_SHORTNAME').AsString);
        fm.ENamAc.Text := Trim(IBTable.FieldByName('PA_NAMEACCOUNT').AsString);
        if Trim(IBTable.FieldByName('PA_CURRENCY').AsString)='*'then
          fm.CBCur.Checked := True;
        if Trim(IBTable.FieldByName('PA_AMOUNT').AsString)='*'then
          fm.CBAmount.Checked := True;
        if Trim(IBTable.FieldByName('PA_BALANCE').AsString)='*'then
          fm.CBBal.Checked := True;
        if Trim(IBTable.FieldByName('KS_SHORTNAME').AsString)='А' then
           fm.RBAct.Checked := true;
        if Trim(IBTable.FieldByName('KS_SHORTNAME').AsString)='П' then
           fm.RBPas.Checked := true;
        if Trim(IBTable.FieldByName('KS_SHORTNAME').AsString)='АП' then
           fm.RBActPas.Checked := true;
        Index := fm.CBSub1.Items.IndexOf(Trim(IBTable.FieldByName('SUBKONTO_NAME').AsString));
        if Index<>-1 then
           fm.CBSub1.Text := fm.CBSub1.Items.Strings[Index];
        Index := fm.CBSub2.Items.IndexOf(Trim(IBTable.FieldByName('SUBKONTO_NAME1').AsString));
        if Index<>-1 then
           fm.CBSub2.Text := fm.CBSub2.Items.Strings[Index];
        Index := fm.CBSub3.Items.IndexOf(Trim(IBTable.FieldByName('SUBKONTO_NAME2').AsString));
        if Index<>-1 then
           fm.CBSub3.Text := fm.CBSub3.Items.Strings[Index];
        fm.BOk.OnClick := nil;
        fm.BOk.OnClick := fm.BOkClick1;
        IdRec := IBTable.FieldByName('PA_ID').AsInteger;
        sqls := 'Select * from PLANACCOUNTS where PA_PARENTID='+Trim(IBTable.FieldByName('PA_ID').AsString)+
             ' and PA_ID<>'+IntToStr(IdRec);
        qr.SQL.Clear;
        qr.SQL.Add(sqls);
        qr.Open;
        if not qr.IsEmpty then
           fm.MENum.Enabled := false;
        if fm.ShowModal=mrok then begin
        end;
      finally
        fm.free;
        qr.Free;
        ActivateQuery;
        IBTable.Locate('PA_ID',IdRec,[loCaseInsensitive]);
      end;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TPlanAc.BDelClick(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
begin
 try
  if not IBTable.Active then Exit;
  if IBTable.IsEmpty then Exit;
  qr:=TIBQuery.Create(nil);
  if(Application.MessageBox(Pchar('Удалить счет <'+Trim(IBTable.FieldByName('PA_GROUPID').AsString)+' >?'),
     Pchar('Подтверждение'), MB_YESNO + MB_ICONQUESTION) = IDNO) then Abort;
  qr.Database:=Form1.IBDatabase;
  qr.Transaction := Form1.IBTransaction;
  qr.Transaction.Active:=true;
  try
     OldRecId := IBTable.FieldByName('PA_ID').AsString;
     sqls := 'Select * from PLANACCOUNTS where PA_PARENTID='+Trim(IBTable.FieldByName('PA_ID').AsString)+
             ' and PA_ID<>'+OldRecId;
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.Open;
     if not qr.IsEmpty then begin
        Application.MessageBox(PChar('Перед удалением счета-папки нужно удалить подсчета'),Pchar('Ошибка'),
        MB_OK+MB_ICONERROR);
        Abort;
     end;
     sqls := 'Delete from PLANACCOUNTS where PA_ID = '+ IBTable.FieldByName('PA_ID').AsString;
     IBTable.Next;
     OldRecId := IBTable.FieldByName('PA_ID').AsString;
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
  finally
     qr.Free;
     ActivateQuery;
     IBTable.Locate('PA_ID',OldRecId,[loCaseInsensitive]);
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

procedure TPlanAc.BAccClick(Sender: TObject);
var
   fm: TFAddAccount;
   Index: integer;
begin
  try
    if not IBTable.Active then exit;
      IDRec := IBTable.FieldByName('PA_Id').AsInteger;
      fm := TFAddAccount.Create(nil);
      try
        fm.Caption := 'Подробнее';
        fm.MENum.Text := Trim(IBTable.FieldByName('PA_GROUPID').AsString);
        fm.ENam.Text := Trim(IBTable.FieldByName('PA_SHORTNAME').AsString);
        fm.ENamAc.Text := Trim(IBTable.FieldByName('PA_NAMEACCOUNT').AsString);
        if Trim(IBTable.FieldByName('PA_CURRENCY').AsString)='*'then
          fm.CBCur.Checked := True;
        if Trim(IBTable.FieldByName('PA_AMOUNT').AsString)='*'then
          fm.CBAmount.Checked := True;
        if Trim(IBTable.FieldByName('PA_BALANCE').AsString)='*'then
          fm.CBBal.Checked := True;
        if Trim(IBTable.FieldByName('KS_SHORTNAME').AsString)='А' then
           fm.RBAct.Checked := true;
        if Trim(IBTable.FieldByName('KS_SHORTNAME').AsString)='П' then
           fm.RBPas.Checked := true;
        if Trim(IBTable.FieldByName('KS_SHORTNAME').AsString)='АП' then
           fm.RBActPas.Checked := true;
        Index := fm.CBSub1.Items.IndexOf(Trim(IBTable.FieldByName('SUBKONTO_NAME').AsString));
        if Index<>-1 then
           fm.CBSub1.Text := fm.CBSub1.Items.Strings[Index];
        Index := fm.CBSub2.Items.IndexOf(Trim(IBTable.FieldByName('SUBKONTO_NAME1').AsString));
        if Index<>-1 then
           fm.CBSub2.Text := fm.CBSub2.Items.Strings[Index];
        Index := fm.CBSub3.Items.IndexOf(Trim(IBTable.FieldByName('SUBKONTO_NAME2').AsString));
        if Index<>-1 then
           fm.CBSub3.Text := fm.CBSub3.Items.Strings[Index];
        IdRec := IBTable.FieldByName('PA_ID').AsInteger;
        fm.MENum.Enabled := false;
        fm.ENam.Enabled := false;
        fm.ENamAc.Enabled := false;
        fm.CBCur.Enabled := false;
        fm.CBAmount.Enabled := false;
        fm.CBBal.Enabled := false;
        fm.RBAct.Enabled := false;
        fm.RBPas.Enabled := false;
        fm.RBActPas.Enabled := false;
        fm.CBSub1.Enabled := false;
        fm.CBSub2.Enabled := false;
        fm.CBSub3.Enabled := false;
        fm.BOk.OnClick := nil;
        fm.BOk.OnClick := fm.BCancel.OnClick;
        fm.BOk.Visible := false;
        if fm.ShowModal=mrok then begin
        end;
      finally
        fm.free;
        ActivateQuery;
        IBTable.Locate('PA_ID',IdRec,[loCaseInsensitive]);
      end;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TPlanAc.BFilterClick(Sender: TObject);
var
   fm: TFPAFilter;
   sqls: string;
begin
  try
    if not IBTable.Active then exit;
      IDRec := IBTable.FieldByName('PA_Id').AsInteger;
      fm := TFPAFilter.Create(nil);
      try
        fm.MENum.Text := FindNum;
        fm.ENam.Text := FindNam;
        fm.ENamAc.Text := FindNamAc;
        if FindCur='*'then
          fm.CBCur.Checked := True;
        if FindAmo='*'then
          fm.CBAmount.Checked := True;
        if FindBal='*'then
          fm.CBBal.Checked := True;
        if FindSaldo='А' then
           fm.RBAct.Checked := true;
        if FindSaldo='П' then
           fm.RBPas.Checked := true;
        if FindSaldo='АП' then
           fm.RBActPas.Checked := true;
        fm.CBSub1.Text := FindSub1;
        fm.CBSub2.Text := FindSub2;
        fm.CBSub3.Text := FindSub3;
        fm.CheckBox.Checked := FilterInSide;
        IdRec := IBTable.FieldByName('PA_ID').AsInteger;
        TempList.Clear;
        if fm.ShowModal=mrOk then begin
          if TempList.Count=0 then Abort;
          FindNum := TempList.Strings[0];
          FindNam := TempList.Strings[1];
          FindNamAc := TempList.Strings[2];
          FindCur := TempList.Strings[3];
          FindAmo := TempList.Strings[4];
          FindBal := TempList.Strings[5];
          FindSaldo := TempList.Strings[6];
          FindSub1 := TempList.Strings[7];
          FindSub2 := TempList.Strings[8];
          FindSub3 := TempList.Strings[9];
          FilterInSide := inside;
          sqls := CompareQuery (TempList);
          IBTable.SQL.Clear;
          IBTable.SQL.Add(sqls);
        end;
      finally
        fm.free;
        ActivateQuery;
        IBTable.Locate('PA_ID',IdRec,[loCaseInsensitive]);
      end;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TPlanAc.CompareQuery (List: TStrings): string;
var
  sqls: string;
begin
  try
    if not FilterInSide then begin
      if List.Strings[0]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(PA_GROUPID)='+''#39''+AnsiUpperCase(List.Strings[0])+''#39'';
      end;
      if List.Strings[1]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(PA_SHORTNAME)='+''#39''+AnsiUpperCase(List.Strings[1])+''#39'';
      end;
      if List.Strings[2]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(PA_NAMEACCOUNT)='+''#39''+AnsiUpperCase(List.Strings[2])+''#39'';
      end;
      if List.Strings[3]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' PA_CURRENCY='+''#39''+List.Strings[3]+''#39'';
      end;
      if List.Strings[4]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' PA_AMOUNT='+''#39''+List.Strings[4]+''#39'';
      end;
      if List.Strings[5]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' PA_BAL='+''#39''+List.Strings[5]+''#39'';
      end;
      if List.Strings[6]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(KS_SHORTNAME)='+''#39''+AnsiUpperCase(List.Strings[6])+''#39'';
      end;
      if List.Strings[7]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(K1.SUBKONTO_NAME)='+''#39''+AnsiUpperCase(List.Strings[7])+''#39'';
      end;
      if List.Strings[8]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(K2.SUBKONTO_NAME)='+''#39''+AnsiUpperCase(List.Strings[8])+''#39'';
      end;
      if List.Strings[9]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(K3.SUBKONTO_NAME)='+''#39''+AnsiUpperCase(List.Strings[9])+''#39'';
      end;
    end;
    if FilterInSide then begin
      if List.Strings[0]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(PA_GROUPID) Like('+''#39'%'+AnsiUpperCase(List.Strings[0])+'%'#39')';
      end;
      if List.Strings[1]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(PA_SHORTNAME) Like('+''#39'%'+AnsiUpperCase(List.Strings[1])+'%'#39')';
      end;
      if List.Strings[2]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(PA_NAMEACCOUNT) Like('+''#39'%'+AnsiUpperCase(List.Strings[2])+'%'#39')';
      end;
      if List.Strings[3]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' PA_CURRENCY='+''#39''+List.Strings[3]+''#39'';
      end;
      if List.Strings[4]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' PA_AMOUNT='+''#39''+List.Strings[4]+''#39'';
      end;
      if List.Strings[5]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' PA_BAL='+''#39''+List.Strings[5]+''#39'';
      end;
      if List.Strings[6]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' KS_SHORTNAME='+''#39''+List.Strings[6]+''#39'';
      end;
      if List.Strings[7]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(K1.SUBKONTO_NAME) Like('+''#39'%'+AnsiUpperCase(List.Strings[7])+'%'#39')';
      end;
      if List.Strings[8]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(K2.SUBKONTO_NAME) Like('+''#39'%'+AnsiUpperCase(List.Strings[8])+'%'#39')';
      end;
      if List.Strings[9]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(K3.SUBKONTO_NAME) Like('+''#39'%'+AnsiUpperCase(List.Strings[9])+'%'#39')';
      end;
    end;
      //      sqls := ' CB_TEXT LIKE' + '('#39'%'+ FindText + '%'#39')';
    if sqls='' then
      sqls := SourceQuery
    else
      if (AnsiPos('where',SourceQuery)=0) then
        sqls := SourceQuery + ' where ' + sqls
      else
        sqls := SourceQuery + ' AND ' + sqls;
    Result := sqls;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TPlanAc.BTunClick(Sender: TObject);
var
  fm: TFTuning;
  i,j,Id,m: integer;
begin
  try
    fm := TFTuning.Create(nil);
    Id := 0;
    try
      fm.CLBFields.Items.Clear;
      for i:=0 to DBGrid.Columns.Count-1 do begin
        fm.CLBFields.Items.Add(DBGrid.Columns.Items[i].Title.Caption);
        fm.CLBFields.Checked[i] := DBGrid.Columns.Items[i].Visible;
      end;
      if fm.ShowModal=mrOk then
      for i:=0 to DBGrid.Columns.Count-1 do begin
        for j:=0 to DBGrid.Columns.Count-1 do begin
          if DBGrid.Columns.Items[j].Title.Caption=TempList[i*2] then
            Id := DBGrid.Columns.Items[j].ID;
        end;
        DBGrid.Columns.FindItemId(Id).Index := i;
        if TempList[i*2+1]='Yes' then
          DBGrid.Columns.Items[i].Visible := true
        else
          DBGrid.Columns.Items[i].Visible := false;
      end;
    finally
      fm.free;
      ActivateQuery;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TPlanAc.LoadFromIni;
var
  fi: TIniFile;
begin
 inherited;
 try
  fi:=TIniFile.Create('Project1.ini');
  try
    FindNum := fi.ReadString(ClassName,'FindNum',FindNum);
    FindNam := fi.ReadString(ClassName,'FindNam',FindNam);
    FindNamAc := fi.ReadString(ClassName,'FindNamAc',FindNamAc);
    FindCur := fi.ReadString(ClassName,'FindCur',FindCur);
    FindAmo := fi.ReadString(ClassName,'FindAmo',FindAmo);
    FindBal := fi.ReadString(ClassName,'FindBal',FindBal);
    FindSaldo := fi.ReadString(ClassName,'FindSaldo',FindSaldo);
    FindSub1 := fi.ReadString(ClassName,'FindSub1',FindSub1);
    FindSub2 := fi.ReadString(ClassName,'FindSub2',FindSub2);
    FindSub3 := fi.ReadString(ClassName,'FindSub3',FindSub3);
    FilterInside := fi.ReadBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TPlanAc.SaveToIni;
var
  fi: TIniFile;
begin
 inherited;
 try
  fi:=TIniFile.Create('Project1.ini');
  try
    fi.WriteString(ClassName,'FindNum',FindNum);
    fi.WriteString(ClassName,'FindNam',FindNam);
    fi.WriteString(ClassName,'FindNamAc',FindNamAc);
    fi.WriteString(ClassName,'FindCur',FindCur);
    fi.WriteString(ClassName,'FindAmo',FindAmo);
    fi.WriteString(ClassName,'FindBal',FindBal);
    fi.WriteString(ClassName,'FindSaldo',FindSaldo);
    fi.WriteString(ClassName,'FindSub1',FindSub1);
    fi.WriteString(ClassName,'FindSub2',FindSub2);
    fi.WriteString(ClassName,'FindSub3',FindSub3);
    fi.WriteBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TPlanAc.FormDestroy(Sender: TObject);
begin
  SaveToIni;
end;

procedure TPlanAc.DBGridDblClick(Sender: TObject);
begin
  if ModeView then begin
    TempList.Clear;
    TempList.Add(Trim(IBTable.FieldByName('PA_ID').AsString));
    TempList.Add(Trim(IBTable.FieldByName('PA_GROUPID').AsString));
    ModalResult := mrOk;
  end;
end;


end.
