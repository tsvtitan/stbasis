unit CashOrder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinTab, Db, IBDatabase, IBCustomDataSet, IBQuery, Grids, DBGrids,
  ExtCtrls, DBCtrls, StdCtrls, ChooseCO, AddCO,EditCO,Data,Kassa,IB, FilterCO1,WTun,
  inifiles;

type
  TFCashOrder = class(TFTable)
  procedure FormCreate(Sender: TObject);
  procedure BAddClick(Sender: TObject);
  procedure BEditClick(Sender: TObject);
  procedure BDelClick(Sender: TObject);
  procedure BAccClick(Sender: TObject);
  procedure BFilterClick(Sender: TObject);
  procedure BTunClick(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
  private
     OldRecId: string;
     FindTDoc,FindNum,FindDateBegin,FindDateFin,FindKorAc,FindKassa,FindCur,FindEmp,
     FindBas,FindApp,FindSum,FindNDS,FindCashier: string;
     function CompareQuery (List: TStrings): string;
     procedure SaveToIni;
     procedure LoadFromIni;
  public
  end;

var
  FCashOrder: TFCashOrder;

implementation

procedure TFCashOrder.FormCreate(Sender: TObject);
var
   sqls: string;
   cl:TColumn;
   List: TStrings;
begin
 inherited;
  try
    List := TStringList.Create;

    Caption := 'Кассовые ордера';
{    IBTable.Database := IBDatabase;
    IBTable.Transaction := IBTransaction;}
    sqls := 'select INC.ICO_ID,INC.DOK_ID,INC.CO_DATE,INC.CO_TIME,D.DOK_NAME,P1.PA_GROUPID,P2.PA_GROUPID,'+
            ' CB_TEXT,CA_TEXT,E1.FNAME,E2.FNAME,CO_DEBIT,CO_KREDIT,CO_KINDKASSA,CO_CURRENCY_ID,CO_IDKORACCOUNT,'+
            'CO_IDINSUBKONTO1,CO_IDINSUBKONTO2,CO_IDINSUBKONTO3,CO_EMP_ID,CO_IDBASIS,CO_IDAPPEND,CO_CASHIER,'+
            'CO_MAINBOOKKEEPER,CO_IDNDS,CO_DIRECTOR,CO_PERSONDOCTYPE_ID'+
            ' from CASHORDERS INC, DOCUMENTS D, PLANACCOUNTS P1, PLANACCOUNTS P2,'+
            ' CASHBASIS, CASHAPPEND, EMP E1, EMP E2'+
            ' where INC.DOK_ID=D.DOK_ID AND INC.CO_KINDKASSA=P1.PA_ID AND INC.CO_IDKORACCOUNT=P2.PA_ID'+
            ' AND CO_IDBASIS=CB_ID AND CO_IDAPPEND=CA_ID AND CO_CASHIER=E1.EMP_ID AND CO_EMP_ID=E2.EMP_ID';
    SourceQuery := sqls;
    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    IBTable.Open;

    DBGrid.Columns.Clear;
    cl:=DBGrid.Columns.Add;
    cl.FieldName:='ICO_ID';
    cl.Title.Caption:='Номер';
    cl.Width:=20;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='CO_DATE';
    cl.Title.Caption:='Дата';
    cl.Width:=60;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='CO_TIME';
    cl.Title.Caption:='Время';
    cl.Width:=60;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='DOK_NAME';
    cl.Title.Caption:='Документ';
    cl.Width:=145;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='PA_GROUPID';
    cl.Title.Caption:='Касса';
    cl.Width:=25;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='PA_GROUPID1';
    cl.Title.Caption:='Корр.счет';
    cl.Width:=25;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='CO_DEBIT';
    cl.Title.Caption:='Дебит';
    cl.Width:=70;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='CO_KREDIT';
    cl.Title.Caption:='Кредит';
    cl.Width:=70;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='CB_TEXT';
    cl.Title.Caption:='Основание';
    cl.Width:=100;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='CA_TEXT';
    cl.Title.Caption:='Приложение';
    cl.Width:=100;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='FNAME';
    cl.Title.Caption:='Кассир';
    cl.Width:=100;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='FNAME1';
    cl.Title.Caption:='Сотрудник';
    cl.Width:=100;

    BFilter.OnClick := BFilterClick;
    BTun.OnClick := BTunClick;
    OnDestroy := FormDestroy;

    LoadFromIni;
    List.Add(FindTDoc);
    List.Add(FindNum);
    List.Add(FindDateBegin);
    List.Add(FindDateFin);
    List.Add(FindKorAc);
    List.Add(FindKassa);
    List.Add(FindCur);
    List.Add(FindEmp);
    List.Add(FindBas);
    List.Add(FindApp);
    List.Add(FindSum);
    List.Add(FindNDS);
    List.Add(FindCashier);
    sqls := CompareQuery(List);
    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    IBTable.Active := True;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFCashOrder.BAddClick(Sender: TObject);
var
 fm: TFChooseDoc;
 fm1: TFAddCO;
 IdRec2: integer;
begin
  try
    if not IBTable.Active then exit;
    fm := TFChooseDoc.Create(nil);
    try
      IdRec := IBTable.FieldByName('ICO_Id').AsInteger;
      IdRec2 := IBTable.FieldByName('DOK_Id').AsInteger;
      if fm.ShowModal = mrok then begin
         fm.free;
         fm1 := TFAddCO.Create(nil);
         fm1.ShowModal;
         fm1.free;
      end;
    finally
//      if FieldAddress('fm')<>nil then
//        fm.free;
//      if FindComponent('fm1')<>nil then
//        fm1.free;
      ActivateQuery;
     IBTable.Locate('ICO_ID;DOK_ID',VarArrayOf([IdRec,IdRec2]),[loCaseInsensitive]);
    end;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCashOrder.BEditClick(Sender: TObject);
var
   fm: TFEditCO;
   Index: integer;
   qr: TIBQuery;
   sqls: string;
   IdRec2, i: integer;
   Sub,SubFId,SubFText,SubTabName: TStrings;
   a,b,c: Double;
begin
  try
    if not IBTable.Active then exit;
      IdRec := IBTable.FieldByName('ICO_Id').AsInteger;
      IdRec2 := IBTable.FieldByName('DOK_Id').AsInteger;
      qr := TIBQuery.Create(nil);
      Sub := TStringList.Create;
      SubFId := TStringList.Create;
      SubFText := TStringList.Create;
      SubTabName := TStringList.Create;
      qr.Database:=Form1.IBDatabase;
      qr.Transaction := Form1.IBTransaction;
      qr.Transaction.Active:=true;
      try
        sqls := 'select * from DOCUMENTS where DOK_ID='+Trim(IBTable.FieldByName('DOK_ID').AsString);
        qr.SQL.Clear;
        qr.SQL.Add(sqls);
        qr.Open;
        if not qr.IsEmpty then
          TempStr := Trim(qr.FieldByName('DOK_NAME').AsString)
        else exit;
        fm := TFEditCO.Create(nil);
        fm.OldId := IntToStr(IdRec);
        fm.OldTDoc := IntToStr(IdRec2);
        fm.ENum.Text := IBTable.FieldByName('ICO_ID').AsString;
        fm.KassaId := Trim(IBTable.FieldByName('CO_KINDKASSA').AsString);
        sqls := 'select * from PLANACCOUNTS where PA_ID='+Trim(IBTable.FieldByName('CO_KINDKASSA').AsString);
        qr.SQL.Clear();
        qr.SQL.Add(sqls);
        qr.Open;
        if not qr.IsEmpty then begin
          fm.Kassa := Trim(qr.FieldByName('PA_GROUPID').AsString);
          if (fm.Kassa='50.1') then
            fm.RGKassa.ItemIndex := 0;
          if (fm.Kassa='50.2') then
            fm.RGKassa.ItemIndex := 1;
        end;
        if (fm.ECur.Visible) then begin
           fm.CurId := Trim(IBTable.FieldByName('CO_CURRENCY_ID').AsString);
           sqls := 'select * from CURRENCY where CURRENCY_ID='+fm.CurId;
           qr.SQL.Clear();
           qr.SQL.Add(sqls);
           qr.Open;
           if not qr.IsEmpty then
             fm.ECur.Text := Trim(qr.FieldByName('SHORTNAME').AsString);
        end;
        fm.KorAc := Trim(IBTable.FieldByName('CO_IDKORACCOUNT').AsString);
        sqls := 'select * from PLANACCOUNTS where PA_ID='+fm.KorAc;
        qr.SQL.Clear();
        qr.SQL.Add(sqls);
        qr.Open;
        if not qr.IsEmpty then begin
          fm.MEKorAc.Text := Trim(qr.FieldByName('PA_GROUPID').AsString);
          Sub.Clear;
          Sub.Add(Trim(qr.FieldByName('PA_SUBKONTO1').AsString));
          Sub.Add(Trim(qr.FieldByName('PA_SUBKONTO2').AsString));
          Sub.Add(Trim(qr.FieldByName('PA_SUBKONTO3').AsString));
          sqls := 'select * from KINDSUBKONTO';
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          SubFId.Clear;
          SubFText.Clear;
          SubTabName.Clear;
          for i:=0 to 3 do begin
            SubFId.Add('');
            SubFText.Add('');
            SubTabName.Add('');
          end;
          if (Sub[0]<>'') AND (Sub[0]<>'0') then begin
            fm.BSub1.Visible := True;
            fm.InSub1 := Trim(IBTable.FieldByName('CO_IDINSUBKONTO1').AsString);
            if fm.InSub1='' then
               fm.InSub1:='NULL';
            fm.Sub1 := Sub[0];
            qr.Locate('SUBKONTO_ID', Sub[0], [loCaseInsensitive]);
            fm.LSub1.Caption := Trim(qr.FieldByName('SUBKONTO_NAME').AsString);
            SubFId[0] := Trim(qr.FieldByName('SUBKONTO_FIELDWITHID').AsString);
            SubFText[0] := Trim(qr.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString);
            SubTabName[0] := Trim(qr.FieldByName('SUBKONTO_TABLENAME').AsString);
          end;
          if (Sub[1]<>'') AND (Sub[1]<>'0') then begin
            fm.BSub2.Visible := True;
            fm.InSub2 := Trim(IBTable.FieldByName('CO_IDINSUBKONTO2').AsString);
            if fm.InSub2='' then
               fm.InSub2:='NULL';
            fm.Sub2 := Sub[1];
            qr.Locate('SUBKONTO_ID', Sub[1], [loCaseInsensitive]);
            fm.LSub2.Caption := Trim(qr.FieldByName('SUBKONTO_NAME').AsString);
            SubFId[1] := Trim(qr.FieldByName('SUBKONTO_FIELDWITHID').AsString);
            SubFText[1] := Trim(qr.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString);
            SubTabName[1] := Trim(qr.FieldByName('SUBKONTO_TABLENAME').AsString);
          end;
          if (Sub[2]<>'') AND (Sub[2]<>'0') then begin
            fm.BSub3.Visible := True;
            fm.InSub2 := Trim(IBTable.FieldByName('CO_IDINSUBKONTO3').AsString);
            if fm.InSub3='' then
               fm.InSub3:='NULL';
            fm.Sub3 := Sub[2];
            qr.Locate('SUBKONTO_ID', Sub[2], [loCaseInsensitive]);
            fm.LSub3.Caption := Trim(qr.FieldByName('SUBKONTO_NAME').AsString);
            SubFId[2] := Trim(qr.FieldByName('SUBKONTO_FIELDWITHID').AsString);
            SubFText[2] := Trim(qr.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString);
            SubTabName[2] := Trim(qr.FieldByName('SUBKONTO_TABLENAME').AsString);
          end;
          if IBTable.FieldByName('CO_IDINSUBKONTO1').AsString<>'' then begin
            sqls := 'select * from '+ SubTabName[0]+' where '+SubFId[0]+'='+
                     Trim(IBTable.FieldByName('CO_IDINSUBKONTO1').AsString);
            qr.SQL.Clear;
            qr.SQL.Add(sqls);
            qr.Open;
            if not qr.IsEmpty then
              fm.ESub1.Text := Trim(qr.FieldByName(SubFText[0]).AsString);
          end;
          if IBTable.FieldByName('CO_IDINSUBKONTO2').AsString<>'' then begin
            sqls := 'select * from '+ SubTabName[1]+' where '+SubFId[1]+'='+
                     Trim(IBTable.FieldByName('CO_IDINSUBKONTO2').AsString);
            qr.SQL.Clear;
            qr.SQL.Add(sqls);
            qr.Open;
            if not qr.IsEmpty then
              fm.ESub2.Text := Trim(qr.FieldByName(SubFText[1]).AsString);
          end;
          if IBTable.FieldByName('CO_IDINSUBKONTO3').AsString<>'' then begin
            sqls := 'select * from '+ SubTabName[2]+' where '+SubFId[2]+'='+
                     Trim(IBTable.FieldByName('CO_IDINSUBKONTO3').AsString);
            qr.SQL.Clear;
            qr.SQL.Add(sqls);
            qr.Open;
            if not qr.IsEmpty then
              fm.ESub3.Text := Trim(qr.FieldByName(SubFText[2]).AsString);
          end;
          fm.EmpId := Trim(IBTable.FieldByName('CO_EMP_ID').AsString);
          fm.BasId := Trim(IBTable.FieldByName('CO_IDBASIS').AsString);
          fm.AppId := Trim(IBTable.FieldByName('CO_IDAPPEND').AsString);
          fm.CashierId := Trim(IBTable.FieldByName('CO_CASHIER').AsString);
          fm.MainBKId := Trim(IBTable.FieldByName('CO_MAINBOOKKEEPER').AsString);
          sqls := 'select * from EMP where EMP_ID='+fm.EmpId;
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          if not qr.IsEmpty then
            fm.EEmp.Text := Trim(qr.FieldByName('FNAME').AsString)+' '+Trim(qr.FieldByName('NAME').AsString)+' '+
                            Trim(qr.FieldByName('SNAME').AsString);
          sqls := 'select * from EMP where EMP_ID='+fm.CashierId;
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          if not qr.IsEmpty then
            fm.ECashier.Text := Trim(qr.FieldByName('FNAME').AsString)+' '+Trim(qr.FieldByName('NAME').AsString)+' '+
                            Trim(qr.FieldByName('SNAME').AsString);
          sqls := 'select * from CASHBASIS where CB_ID='+fm.BasId;
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          if not qr.IsEmpty then
            fm.EBasis.Text := Trim(qr.FieldByName('CB_TEXT').AsString);
          sqls := 'select * from CASHAPPEND where CA_ID='+fm.AppId;
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          if not qr.IsEmpty then
            fm.EAppend.Text := Trim(qr.FieldByName('CA_TEXT').AsString);
          if fm.ESumKredit.Visible then begin
            fm.Director := Trim(IBTable.FieldByName('CO_DIRECTOR').AsString);
            fm.OnDocId := Trim(IBTable.FieldByName('CO_PERSONDOCTYPE_ID').AsString);
            fm.Kredit := Trim(IBTable.FieldByName('CO_KREDIT').AsString);
            fm.ESumKredit.Text := fm.Kredit;
            sqls := 'select * from PERSONDOCTYPE where PERSONDOCTYPE_ID='+fm.OnDocId;
            qr.SQL.Clear;
            qr.SQL.Add(sqls);
            qr.Open;
            if not qr.IsEmpty then
              fm.EOnDoc.Text := Trim(qr.FieldByName('SMALLNAME').AsString);
            sqls := 'select * from EMPPERSONDOC where PERSONDOCTYPE_ID='+fm.OnDocId+
                    ' AND EMP_ID='+fm.EmpId;
            qr.SQL.Clear;
            qr.SQL.Add(sqls);
            qr.Open;
            if not qr.IsEmpty then
              fm.EOnDoc.Text := fm.EOnDoc.Text+' '+Trim(qr.FieldByName('SERIAL').AsString)+' '+
                                Trim(qr.FieldByName('NUM').AsString)+' '+Trim(qr.FieldByName('DATEWHERE').AsString);

          end
          else begin
            fm.Debit := Trim(IBTable.FieldByName('CO_DEBIT').AsString);
            fm.ESum.Text := fm.Debit;
            if Trim(IBTable.FieldByName('CO_IDNDS').AsString)<>'' then begin
              fm.NDSId := Trim(IBTable.FieldByName('CO_IDNDS').AsString);
              fm.CBNDS.Checked := True;
              sqls := 'select * from TAXES where TAXES_ID='+fm.NDSId;
              qr.SQL.Clear;
              qr.SQL.Add(sqls);
              qr.Open;
              if not qr.IsEmpty then begin
                fm.ENDS.Text := Trim(qr.FieldByName('TAXES_CONTENTS').AsString);
                a := StrToInt(fm.ENDS.Text)/100;
                b := StrToInt(fm.ESum.Text);
                c := a*b;
                fm.ESumNDS.Text := FloatToStr(c);
              end;
            end;
          end;
        end;
        if fm.ShowModal=mrok then begin
        end;
      finally
        fm.free;
        qr.Free;
        Sub.Free;
        SubFId.Free;
        SubFText.Free;
        SubTabName.Free;
        ActivateQuery;
        IBTable.Locate('ICO_ID;DOK_ID',VarArrayOf([IdRec,IdRec2]),[loCaseInsensitive]);
      end;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCashOrder.BDelClick(Sender: TObject);
var
  qr: TIBQuery;
  sqls, sqls1: string;
  IdRec2: integer;
begin
 try
  if not IBTable.Active then Exit;
  if IBTable.IsEmpty then Exit;
  qr:=TIBQuery.Create(nil);
  if(Application.MessageBox(Pchar('Удалить кассовый ордер № <'+Trim(IBTable.FieldByName('ICO_ID').AsString)+' >?'),
     Pchar('Подтверждение'), MB_YESNO + MB_ICONQUESTION) = IDNO) then Abort;
  qr.Database:=Form1.IBDatabase;
  qr.Transaction := Form1.IBTransaction;
  qr.Transaction.Active:=true;
  try
     sqls := 'Delete from CASHORDERS where ICO_ID='+ Trim(IBTable.FieldByName('ICO_ID').AsString)+
             ' AND DOK_ID='+Trim(IBTable.FieldByName('DOK_ID').AsString);
     sqls1 := 'delete  from MAGAZINEPOSTINGS where MP_DOKUMENT='+Trim(IBTable.FieldByName('DOK_ID').AsString)+
              ' AND '+ 'MP_DOCUMENTID='+Trim(IBTable.FieldByName('ICO_ID').AsString);
     IBTable.Next;
     IdRec := IBTable.FieldByName('ICO_Id').AsInteger;
     IdRec2 := IBTable.FieldByName('DOK_Id').AsInteger;
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     qr.Transaction.Active := True;
     qr.SQL.Clear;
     qr.SQL.Add(sqls1);
     qr.ExecSQL;
     qr.Transaction.Commit;
  finally
     qr.Free;
     ActivateQuery;
     IBTable.Locate('ICO_ID;DOK_ID',VarArrayOf([IdRec,IdRec2]),[loCaseInsensitive]);
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

procedure TFCashOrder.BAccClick(Sender: TObject);
var
   fm: TFEditCO;
   Index: integer;
   qr: TIBQuery;
   sqls: string;
   IdRec2, i: integer;
   Sub,SubFId,SubFText,SubTabName: TStrings;
   a,b,c: Double;
begin
  try
    if not IBTable.Active then exit;
      IdRec := IBTable.FieldByName('ICO_Id').AsInteger;
      IdRec2 := IBTable.FieldByName('DOK_Id').AsInteger;
      qr := TIBQuery.Create(nil);
      Sub := TStringList.Create;
      SubFId := TStringList.Create;
      SubFText := TStringList.Create;
      SubTabName := TStringList.Create;
      qr.Database:=Form1.IBDatabase;
      qr.Transaction := Form1.IBTransaction;
      qr.Transaction.Active:=true;
      try
        sqls := 'select * from DOCUMENTS where DOK_ID='+Trim(IBTable.FieldByName('DOK_ID').AsString);
        qr.SQL.Clear;
        qr.SQL.Add(sqls);
        qr.Open;
        if not qr.IsEmpty then
          TempStr := Trim(qr.FieldByName('DOK_NAME').AsString)
        else exit;
        fm := TFEditCO.Create(nil);
        fm.OldId := IntToStr(IdRec);
        fm.OldTDoc := IntToStr(IdRec2);
        fm.ENum.Text := IBTable.FieldByName('ICO_ID').AsString;
        fm.KassaId := Trim(IBTable.FieldByName('CO_KINDKASSA').AsString);
        sqls := 'select * from PLANACCOUNTS where PA_ID='+Trim(IBTable.FieldByName('CO_KINDKASSA').AsString);
        qr.SQL.Clear();
        qr.SQL.Add(sqls);
        qr.Open;
        if not qr.IsEmpty then begin
          fm.Kassa := Trim(qr.FieldByName('PA_GROUPID').AsString);
          if (fm.Kassa='50.1') then
            fm.RGKassa.ItemIndex := 0;
          if (fm.Kassa='50.2') then
            fm.RGKassa.ItemIndex := 1;
        end;
        if (fm.ECur.Visible) then begin
           fm.CurId := Trim(IBTable.FieldByName('CO_CURRENCY_ID').AsString);
           sqls := 'select * from CURRENCY where CURRENCY_ID='+fm.CurId;
           qr.SQL.Clear();
           qr.SQL.Add(sqls);
           qr.Open;
           if not qr.IsEmpty then
             fm.ECur.Text := Trim(qr.FieldByName('SHORTNAME').AsString);
        end;
        fm.KorAc := Trim(IBTable.FieldByName('CO_IDKORACCOUNT').AsString);
        sqls := 'select * from PLANACCOUNTS where PA_ID='+fm.KorAc;
        qr.SQL.Clear();
        qr.SQL.Add(sqls);
        qr.Open;
        if not qr.IsEmpty then begin
          fm.MEKorAc.Text := Trim(qr.FieldByName('PA_GROUPID').AsString);
          Sub.Clear;
          Sub.Add(Trim(qr.FieldByName('PA_SUBKONTO1').AsString));
          Sub.Add(Trim(qr.FieldByName('PA_SUBKONTO2').AsString));
          Sub.Add(Trim(qr.FieldByName('PA_SUBKONTO3').AsString));
          sqls := 'select * from KINDSUBKONTO';
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          SubFId.Clear;
          SubFText.Clear;
          SubTabName.Clear;
          for i:=0 to 3 do begin
            SubFId.Add('');
            SubFText.Add('');
            SubTabName.Add('');
          end;
          if (Sub[0]<>'') AND (Sub[0]<>'0') then begin
            fm.BSub1.Visible := True;
            fm.InSub1 := Trim(IBTable.FieldByName('CO_IDINSUBKONTO1').AsString);
            fm.Sub1 := Sub[0];
            qr.Locate('SUBKONTO_ID', Sub[0], [loCaseInsensitive]);
            fm.LSub1.Caption := Trim(qr.FieldByName('SUBKONTO_NAME').AsString);
            SubFId[0] := Trim(qr.FieldByName('SUBKONTO_FIELDWITHID').AsString);
            SubFText[0] := Trim(qr.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString);
            SubTabName[0] := Trim(qr.FieldByName('SUBKONTO_TABLENAME').AsString);
          end;
          if (Sub[1]<>'') AND (Sub[1]<>'0') then begin
            fm.BSub2.Visible := True;
            fm.InSub2 := Trim(IBTable.FieldByName('CO_IDINSUBKONTO2').AsString);
            fm.Sub2 := Sub[1];
            qr.Locate('SUBKONTO_ID', Sub[1], [loCaseInsensitive]);
            fm.LSub2.Caption := Trim(qr.FieldByName('SUBKONTO_NAME').AsString);
            SubFId[1] := Trim(qr.FieldByName('SUBKONTO_FIELDWITHID').AsString);
            SubFText[1] := Trim(qr.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString);
            SubTabName[1] := Trim(qr.FieldByName('SUBKONTO_TABLENAME').AsString);
          end;
          if (Sub[2]<>'') AND (Sub[2]<>'0') then begin
            fm.BSub3.Visible := True;
            fm.InSub2 := Trim(IBTable.FieldByName('CO_IDINSUBKONTO3').AsString);
            fm.Sub3 := Sub[2];
            qr.Locate('SUBKONTO_ID', Sub[2], [loCaseInsensitive]);
            fm.LSub3.Caption := Trim(qr.FieldByName('SUBKONTO_NAME').AsString);
            SubFId[2] := Trim(qr.FieldByName('SUBKONTO_FIELDWITHID').AsString);
            SubFText[2] := Trim(qr.FieldByName('SUBKONTO_FIELDWITHTEXT').AsString);
            SubTabName[2] := Trim(qr.FieldByName('SUBKONTO_TABLENAME').AsString);
          end;
          if IBTable.FieldByName('CO_IDINSUBKONTO1').AsString<>'' then begin
            sqls := 'select * from '+ SubTabName[0]+' where '+SubFId[0]+'='+
                     Trim(IBTable.FieldByName('CO_IDINSUBKONTO1').AsString);
            qr.SQL.Clear;
            qr.SQL.Add(sqls);
            qr.Open;
            if not qr.IsEmpty then
              fm.ESub1.Text := Trim(qr.FieldByName(SubFText[0]).AsString);
          end;
          if IBTable.FieldByName('CO_IDINSUBKONTO2').AsString<>'' then begin
            sqls := 'select * from '+ SubTabName[1]+' where '+SubFId[1]+'='+
                     Trim(IBTable.FieldByName('CO_IDINSUBKONTO2').AsString);
            qr.SQL.Clear;
            qr.SQL.Add(sqls);
            qr.Open;
            if not qr.IsEmpty then
              fm.ESub2.Text := Trim(qr.FieldByName(SubFText[1]).AsString);
          end;
          if IBTable.FieldByName('CO_IDINSUBKONTO3').AsString<>'' then begin
            sqls := 'select * from '+ SubTabName[2]+' where '+SubFId[2]+'='+
                     Trim(IBTable.FieldByName('CO_IDINSUBKONTO3').AsString);
            qr.SQL.Clear;
            qr.SQL.Add(sqls);
            qr.Open;
            if not qr.IsEmpty then
              fm.ESub3.Text := Trim(qr.FieldByName(SubFText[2]).AsString);
          end;
          fm.EmpId := Trim(IBTable.FieldByName('CO_EMP_ID').AsString);
          fm.BasId := Trim(IBTable.FieldByName('CO_IDBASIS').AsString);
          fm.AppId := Trim(IBTable.FieldByName('CO_IDAPPEND').AsString);
          fm.CashierId := Trim(IBTable.FieldByName('CO_CASHIER').AsString);
          fm.MainBKId := Trim(IBTable.FieldByName('CO_MAINBOOKKEEPER').AsString);
          sqls := 'select * from EMP where EMP_ID='+fm.EmpId;
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          if not qr.IsEmpty then
            fm.EEmp.Text := Trim(qr.FieldByName('FNAME').AsString)+' '+Trim(qr.FieldByName('NAME').AsString)+' '+
                            Trim(qr.FieldByName('SNAME').AsString);
          sqls := 'select * from EMP where EMP_ID='+fm.CashierId;
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          if not qr.IsEmpty then
            fm.ECashier.Text := Trim(qr.FieldByName('FNAME').AsString)+' '+Trim(qr.FieldByName('NAME').AsString)+' '+
                            Trim(qr.FieldByName('SNAME').AsString);
          sqls := 'select * from CASHBASIS where CB_ID='+fm.BasId;
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          if not qr.IsEmpty then
            fm.EBasis.Text := Trim(qr.FieldByName('CB_TEXT').AsString);
          sqls := 'select * from CASHAPPEND where CA_ID='+fm.AppId;
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          if not qr.IsEmpty then
            fm.EAppend.Text := Trim(qr.FieldByName('CA_TEXT').AsString);
          if fm.ESumKredit.Visible then begin
            fm.Director := Trim(IBTable.FieldByName('CO_DIRECTOR').AsString);
            fm.OnDocId := Trim(IBTable.FieldByName('CO_PERSONDOCTYPE_ID').AsString);
            fm.Kredit := Trim(IBTable.FieldByName('CO_KREDIT').AsString);
            fm.ESumKredit.Text := fm.Kredit;
            sqls := 'select * from PERSONDOCTYPE where PERSONDOCTYPE_ID='+fm.OnDocId;
            qr.SQL.Clear;
            qr.SQL.Add(sqls);
            qr.Open;
            if not qr.IsEmpty then
              fm.EOnDoc.Text := Trim(qr.FieldByName('SMALLNAME').AsString);
            sqls := 'select * from EMPPERSONDOC where PERSONDOCTYPE_ID='+fm.OnDocId+
                    ' AND EMP_ID='+fm.EmpId;
            qr.SQL.Clear;
            qr.SQL.Add(sqls);
            qr.Open;
            if not qr.IsEmpty then
              fm.EOnDoc.Text := fm.EOnDoc.Text+' '+Trim(qr.FieldByName('SERIAL').AsString)+' '+
                                Trim(qr.FieldByName('NUM').AsString)+' '+Trim(qr.FieldByName('DATEWHERE').AsString);

          end
          else begin
            fm.Debit := Trim(IBTable.FieldByName('CO_DEBIT').AsString);
            fm.ESum.Text := fm.Debit;
            if Trim(IBTable.FieldByName('CO_IDNDS').AsString)<>'' then begin
              fm.NDSId := Trim(IBTable.FieldByName('CO_IDNDS').AsString);
              fm.CBNDS.Checked := True;
              sqls := 'select * from TAXES where TAXES_ID='+fm.NDSId;
              qr.SQL.Clear;
              qr.SQL.Add(sqls);
              qr.Open;
              if not qr.IsEmpty then begin
                fm.ENDS.Text := Trim(qr.FieldByName('TAXES_CONTENTS').AsString);
                a := StrToInt(fm.ENDS.Text)/100;
                b := StrToInt(fm.ESum.Text);
                c := a*b;
                fm.ESumNDS.Text := FloatToStr(c);
              end;
            end;
          end;
        end;
        fm.BOk.Visible := false;
        fm.ENum.Enabled := false;
        fm.DateTime.Enabled := false;
        fm.RGKassa.Enabled := false;
        fm.BKorAc.Enabled := false;
        fm.BSub1.Enabled := false;
        fm.BSub2.Enabled := false;
        fm.BSub3.Enabled := false;
        fm.BEmp.Enabled := false;
        fm.BBasis.Enabled := false;
        fm.BAppend.Enabled := false;
        fm.BCur.Enabled := false;
        fm.CBNDS.Enabled := false;
        fm.BNDS.Enabled := false;
        fm.ESum.Enabled := false;
        fm.ESumKredit.Enabled := false;
        fm.BOnDoc.Enabled := false;
        fm.BCashier.Enabled := false;
        if fm.ShowModal=mrok then begin
        end;
      finally
        fm.free;
        qr.Free;
        Sub.Free;
        SubFId.Free;
        SubFText.Free;
        SubTabName.Free;
        ActivateQuery;
        IBTable.Locate('ICO_ID;DOK_ID',VarArrayOf([IdRec,IdRec2]),[loCaseInsensitive]);
      end;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCashOrder.BFilterClick(Sender: TObject);
var
   fm: TFCOFilter;
   sqls: string;
   qr: TIBQuery;
   IdRec2: integer;
begin
  try
    if not IBTable.Active then exit;
//      IDRec := IBTable.FieldByName('PA_Id').AsInteger;
      IdRec := IBTable.FieldByName('ICO_Id').AsInteger;
      IdRec2 := IBTable.FieldByName('DOK_Id').AsInteger;
      fm := TFCOFilter.Create(nil);
      qr := TIBQuery.Create(nil);

      qr.Database:=Form1.IBDatabase;
      qr.Transaction := Form1.IBTransaction;
      qr.Transaction.Active:=true;

      try
        if FindTDoc<>'' then begin
          sqls := 'select * from DOCUMENTS where DOK_ID='+FindTDoc;
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          if not qr.IsEmpty then begin
            fm.CBTOrder.Text := qr.FieldByName('DOK_NAME').AsString;
            fm.TDocId := FindTDoc;
          end;
        end;
        fm.ENum.Text := FindNum;
        if FindDateBegin<>''  then
          fm.DateTime1.Date := StrToDate(FindDateBegin);
        if FindDateFin<>''  then
          fm.DateTime2.Date := StrToDate(FindDateFin);
        fm.MEKorAc.Text := FindKorAc;
        fm.MEKassa.Text := FindKassa;
        if FindCur<>'' then begin
          sqls := 'select * from CURRENCY where CURRENCY_ID='+FindCur;
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          if not qr.IsEmpty then begin
            fm.ECur.Text := qr.FieldByName('SHORTNAME').AsString;
            fm.CurId := FindCur;
          end;
        end;
        fm.EEmp.Text := FindEmp;
        fm.EBasis.Text := FindBas;
        fm.EAppend.Text := FindApp;
        fm.ESum.Text := FindSum;
        if FindCashier<>'' then begin
          sqls := 'select * from EMP where EMP_ID='+FindCashier;
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          if not qr.IsEmpty then begin
            fm.ECashier.Text := Trim(qr.FieldByName('FNAME').AsString)+' '+Trim(qr.FieldByName('NAME').AsString)+' '+
                              Trim(qr.FieldByName('SNAME').AsString);
          fm.CashierId := FindCashier;
        end;  
        end;
        if FindNDS<>'' then begin
          sqls := 'select * from TAXES where TAXES_ID='+FindNDS;
          qr.SQL.Clear;
          qr.SQL.Add(sqls);
          qr.Open;
          if not qr.IsEmpty then begin
            fm.ENDS.Text := qr.FieldByName('TAXES_CONTENTS').AsString;
            fm.NDSId := FindNDS;
          end;
        end;
        fm.CheckBox.Checked := FilterInSide;
        //        fm.OnCreate := nil;
        if fm.ShowModal=mrOk then begin
          if TempList.Count=0 then Abort;
          FindTDoc := TempList.Strings[0];
          FindNum := TempList.Strings[1];
          FindDateBegin := TempList.Strings[2];
          FindDateFin := TempList.Strings[3];
          FindKorAc := TempList.Strings[4];
          FindKassa := TempList.Strings[5];
          FindCur := TempList.Strings[6];
          FindEmp := TempList.Strings[7];
          FindBas := TempList.Strings[8];
          FindApp := TempList.Strings[9];
          FindSum := TempList.Strings[10];
          FindNDS := TempList.Strings[11];
          FindCashier := TempList.Strings[12];
          FilterInSide := inside;
          sqls := CompareQuery (TempList);
          IBTable.SQL.Clear;
          IBTable.SQL.Add(sqls);
        end;
      finally
        fm.free;
        ActivateQuery;
        IBTable.Locate('ICO_ID;DOK_ID',VarArrayOf([IdRec,IdRec2]),[loCaseInsensitive]);
      end;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TFCashOrder.CompareQuery (List: TStrings): string;
var
  sqls,sqls1: string;
  qr: TIBQuery;
begin
  qr := TIBQuery.Create(nil);
  qr.Database := Form1.IBDatabase;
  qr.Transaction := Form1.IBTransaction;
  qr.Transaction.Active := True;
  try
    if not FilterInSide then begin
      if List.Strings[0]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(DOK_ID)='+List.Strings[0];
      end;
      if List.Strings[1]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(ICO_ID)='+List.Strings[1];
      end;
      if List.Strings[2]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' CO_DATE BETWEEN '+QuotedStr(List.Strings[2])+' AND '+QuotedStr(List.Strings[3]);
      end;
      if List.Strings[4]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' P2.PA_GROUPID='+''#39''+List.Strings[4]+''#39'';
      end;
      if List.Strings[5]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' P1.PA_GROUPID='+''#39''+List.Strings[5]+''#39'';
      end;
      if List.Strings[6]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' CO_CURRENCY_ID='+List.Strings[6];
      end;
      if List.Strings[7]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(E2.SNAME)='+''#39''+AnsiUpperCase(List.Strings[7])+''#39'';
      end;
      if List.Strings[8]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(CB_TEXT)='+''#39''+AnsiUpperCase(List.Strings[8])+''#39'';
      end;
      if List.Strings[9]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(CA_TEXT)='+''#39''+AnsiUpperCase(List.Strings[9])+''#39'';
      end;
      if List.Strings[10]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' CO_DEBIT='+List.Strings[10]+ ' OR CO_KREDIT='+List.Strings[10];
      end;
      if List.Strings[11]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' CO_IDNDS='+List.Strings[11];
      end;
      if List.Strings[12]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' CO_CASHIER='+List.Strings[12];
      end;
    end;
    if FilterInSide then begin
      if List.Strings[0]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(DOK_ID)='+List.Strings[0];
      end;
      if List.Strings[1]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(ICO_ID)='+List.Strings[1];
      end;
      if List.Strings[2]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' CO_DATE BETWEEN '+QuotedStr(List.Strings[2])+' AND '+QuotedStr(List.Strings[3]);
      end;
      if List.Strings[4]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' UPPER(P2.PA_GROUPID)='+''#39''+AnsiUpperCase(List.Strings[4])+''#39'';
      end;
      if List.Strings[5]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' UPPER(P1.PA_GROUPID)='+''#39''+AnsiUpperCase(List.Strings[5])+''#39'';
      end;
      if List.Strings[6]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' CO_CURRENCY_ID='+List.Strings[6];
      end;
      if List.Strings[7]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(E2.SNAME) Like('+''#39'%'+AnsiUpperCase(List.Strings[7])+'%'#39')';
      end;
      if List.Strings[8]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(CB_TEXT) Like('+''#39'%'+AnsiUpperCase(List.Strings[8])+'%'#39')';
      end;
      if List.Strings[9]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' Upper(CA_TEXT) Like('+''#39'%'+AnsiUpperCase(List.Strings[9])+'%'#39')';
      end;
      if List.Strings[10]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' CO_DEBIT='+List.Strings[10]+ ' OR CO_KREDIT='+List.Strings[10];
      end;
      if List.Strings[11]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' CO_IDNDS='+List.Strings[11];
      end;
      if List.Strings[12]<>'' then begin
         if sqls<>'' then sqls := sqls+' AND ';
         sqls := sqls+' CO_CASHIER='+List.Strings[12];
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

procedure TFCashOrder.BTunClick(Sender: TObject);
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

procedure TFCashOrder.LoadFromIni;
var
  fi: TIniFile;
begin
 inherited;
 try
  fi:=TIniFile.Create('Project1.ini');
  try
    FindTDoc := fi.ReadString(ClassName,'FindTDoc',FindTDoc);
    FindNum := fi.ReadString(ClassName,'FindNum',FindNum);
    FindDateBegin := fi.ReadString(ClassName,'FindDateBegin',FindDateBegin);
    FindDateFin := fi.ReadString(ClassName,'FindDateFin',FindDateFin);
    FindKorAc := fi.ReadString(ClassName,'FindKorAc',FindKorAc);
    FindKassa := fi.ReadString(ClassName,'FindKassa',FindKassa);
    FindCur := fi.ReadString(ClassName,'FindCur',FindCur);
    FindEmp := fi.ReadString(ClassName,'FindEmp',FindEmp);
    FindBas := fi.ReadString(ClassName,'FindBas',FindBas);
    FindApp := fi.ReadString(ClassName,'FindApp',FindApp);
    FindSum := fi.ReadString(ClassName,'FindSum',FindSum);
    FindNDS := fi.ReadString(ClassName,'FindNDS',FindNDS);
    FindCashier := fi.ReadString(ClassName,'FindCashier',FindCashier);
    FilterInside := fi.ReadBool(ClassName,'Inside',FilterInside);
  finally
    fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCashOrder.SaveToIni;
var
  fi: TIniFile;
begin
 inherited;
 try
  fi:=TIniFile.Create('Project1.ini');
  try
    fi.WriteString(ClassName,'FindTDoc',FindTDoc);
    fi.WriteString(ClassName,'FindNum',FindNum);
    fi.WriteString(ClassName,'FindDateBegin',FindDateBegin);
    fi.WriteString(ClassName,'FindDateFin',FindDateFin);
    fi.WriteString(ClassName,'FindKorAc',FindKorAc);
    fi.WriteString(ClassName,'FindKassa',FindKassa);
    fi.WriteString(ClassName,'FindCur',FindCur);
    fi.WriteString(ClassName,'FindEmp',FindEmp);
    fi.WriteString(ClassName,'FindBas',FindBas);
    fi.WriteString(ClassName,'FindApp',FindApp);
    fi.WriteString(ClassName,'FindSum',FindSum);
    fi.WriteString(ClassName,'FindNDS',FindNDS);
    fi.WriteString(ClassName,'FindCashier',FindCashier);
    fi.WriteBool(ClassName,'Inside',FilterInside);
  finally
    fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCashOrder.FormDestroy(Sender: TObject);
begin
  SaveToIni;
end;

end.
