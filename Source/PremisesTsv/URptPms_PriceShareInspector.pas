unit URptPms_PriceShareInspector;

interface

uses classes, Forms;

procedure RtpShareRunInspector(Thread: TThread; Form, Options: TForm; sFileName, sTypeOperation: string;
                               UseStyle: Boolean; SyncOfficeId: String);

implementation

uses Windows, sysutils, controls, graphics, IBQuery, IBDatabase, Db, IBCustomDataSet, Excel97,
     UMainUnited, URptPms_Price, URptThread, UPremisesTsvData, UPremisesTsvOptions;

procedure RtpShareRunInspector(Thread: TThread; Form, Options: TForm; sFileName, sTypeOperation: string;
                               UseStyle: Boolean; SyncOfficeId: String);
var
 tran: TIBTransaction;
 qrStation: TIBQuery;
 qrPremises: TIbQuery;
 sqls: string;
 Sh,ShMain: OleVariant;
 Wb: OleVariant;
 R: OleVariant;
 oldY,curY: Integer;
 Data: Variant;
 Row: Integer;
 TCPB: TCreateProgressBar;
 TSPBS: TSetProgressBarStatus;
 incCR: Integer;
 pb1: THandle;
 Flag: Boolean;
 ColumnCount: Integer;
 OldFontName: string;
 fmParent: TfmRptPms_Price;
begin
 fmParent:=TfmRptPms_Price(Form);
 ColumnCount:=fmParent.GetColumnCount;
 if ColumnCount=0 then exit;
 Excel.WorkBooks.Open(sFileName);
 wb:=Excel.WorkBooks.Item[1];
 Sh:=Wb.Sheets.Item[1];
 TRptExcelThreadPms_Price(THread).Synchronize(TRptExcelThreadPms_Price(THread).GetPlantName);
 Sh.Range[Sh.Cells[1,1],Sh.Cells[1,1]].Value:=TRptExcelThreadPms_Price(THread).FPlantName;
 R:=Sh.Range[Sh.Cells[1,ColumnCount],Sh.Cells[1,ColumnCount]];
 R.Value:=sTypeOperation+' - '+FormatDateTime(fmtCurDate,fmParent.curdate);
 R.HorizontalAlignment:=xlRight;
 R.Font.Bold:=true;

 if IscnppPhoneName then begin
   OldFontName:=Sh.Range[Sh.Cells[1,IndcnppPhoneName],Sh.Cells[1,IndcnppPhoneName]].Font.Name;
   Sh.Columns[IndcnppPhoneName].Font.Name:=fmOptions.edPhoneColumn.Font.Name;
   Sh.Range[Sh.Cells[2,IndcnppPhoneName],Sh.Cells[2,IndcnppPhoneName]].Font.Name:=Sh.Range[Sh.Cells[2,1],Sh.Cells[2,1]].Font.Name;
   Sh.Range[Sh.Cells[1,IndcnppPhoneName],Sh.Cells[1,IndcnppPhoneName]].Font.Name:=OldFontName;
 end;

 qrStation:=TIBQuery.Create(nil);
 qrPremises:=TIBQuery.Create(nil);
 tran:=TIBTransaction.Create(nil);
 Screen.Cursor:=crHourGlass;
 try
   tran.AddDatabase(IBDB);
   IBDB.AddTransaction(tran);
   qrStation.Transaction:=tran;
   qrStation.Database:=IBDB;
   qrPremises.Transaction:=tran;
   qrPremises.Database:=IBDB;
   tran.Active:=true;

   sqls:='Select sortnumber from '+tbPms_Station+
         ' group by sortnumber '+
         ' order by sortnumber';
   qrStation.SQL.Add(sqls);
   qrStation.Active:=true;
   qrStation.Last;
   qrStation.First;

   ShMain:=Sh;
   Sh.Name:='Вся недвижимость';
   curY:=3;
   FillChar(TCPB,SizeOf(TCPB),0);
   TCPB.Min:=0;
   TCPB.Max:=qrStation.RecordCount;
   TCPB.Color:=clNavy;
   pb1:=_CreateProgressBar(@TCPB);
   incCR:=0;
   Flag:=false;
   try
     qrStation.First;
     while not qrStation.Eof do begin
       if TRptExcelThreadPms_Price(THread).Terminated then exit;
       sqls:=SQLRbkPms_PremisesRpt+
             ' where p.datearrivals>='+QuotedStr(DateToStr(fmParent.dtpDateFrom.DateTime))+
             ' and p.datearrivals<='+QuotedStr(DateToStr(fmParent.dtpDateTo.DateTime))+
             ' and p.pms_station_id in ('+GetPms_Station_IdBySortNumber(qrStation.FieldByName('sortnumber').AsInteger)+')'+
             ' and p.typeoperation='+inttostr(2)+
             fmParent.GetRecyledFilter+
             fmParent.GetStationFilter+
             fmParent.GetOfficeFilter+
             fmParent.GetOrder;
             
       qrPremises.SQL.Clear;
       qrPremises.SQL.Add(sqls);
       qrPremises.Active:=true;
       qrPremises.Last;
       if not qrPremises.IsEmpty then begin
         if Flag then begin
           inc(curY);
           R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
           R.Merge;
           R.HorizontalAlignment:=xlCenter;
           R.VerticalAlignment:=xlCenter;
           R.Font.Size:=8;
           R.Font.Bold:=true;
         end;
         Flag:=true;

         oldY:=curY+1;
         Row:=1;
         Data:=VarArrayCreate([1,qrPremises.RecordCount,1,ColumnCount],varVariant);
         qrPremises.First;
         while not qrPremises.Eof do begin
           if TRptExcelThreadPms_Price(THread).Terminated then exit;
           inc(curY);
           if IscnppDateArrivals then
             Data[Row,IndcnppDateArrivals]:=FormatDateTime(fmtSmallDate,qrPremises.FieldByName('datearrivals').AsDateTime);
           if IscnppCountRoomName then
             Data[Row,IndcnppCountRoomName]:=qrPremises.FieldByName('countroomname').AsString;
           if IscnppTypeRoomName then
             Data[Row,IndcnppTypeRoomName]:=qrPremises.FieldByName('typeroomname').AsString;
           if IscnppPlanningName then
             Data[Row,IndcnppPlanningName]:=qrPremises.FieldByName('planningname').AsString;
           if IscnppRegionName then
             Data[Row,IndcnppRegionName]:=qrPremises.FieldByName('regionname').AsString;
           if IscnppStreetName then
             Data[Row,IndcnppStreetName]:=qrPremises.FieldByName('streetname').AsString;
           if IscnppHouseNumber then
             Data[Row,IndcnppHouseNumber]:=qrPremises.FieldByName('housenumber').AsString;
           if IscnppApartmentNumber then
             Data[Row,IndcnppApartmentNumber]:=qrPremises.FieldByName('apartmentnumber').AsString;
           if IscnppPhoneName then
             Data[Row,IndcnppPhoneName]:=qrPremises.FieldByName('phonename').AsString;
           if IscnppSaleStatusName then
             Data[Row,IndcnppSaleStatusName]:=qrPremises.FieldByName('salestatusname').AsString;
           if IscnppNote then
             Data[Row,IndcnppNote]:=qrPremises.FieldByName('note').AsString;
           if IscnppFloor then
             Data[Row,IndcnppFloor]:=qrPremises.FieldByName('floor').AsString;
           if IscnppCountFloor then
             Data[Row,IndcnppCountFloor]:=qrPremises.FieldByName('countfloor').AsString;
           if IscnppTypeHouseName then
             Data[Row,IndcnppTypeHouseName]:=qrPremises.FieldByName('typehousename').AsString;
           if IscnppGeneralArea then
             Data[Row,IndcnppGeneralArea]:=qrPremises.FieldByName('generalarea').AsString;
           if IscnppDwellingArea then
             Data[Row,IndcnppDwellingArea]:=qrPremises.FieldByName('dwellingarea').AsString;
           if IscnppKitchenArea then
             Data[Row,IndcnppKitchenArea]:=qrPremises.FieldByName('kitchenarea').AsString;
           if IscnppSanitaryNodeName then
             Data[Row,IndcnppSanitaryNodeName]:=qrPremises.FieldByName('sanitarynodename').AsString;
           if IscnppWaterName then
             Data[Row,IndcnppWaterName]:=qrPremises.FieldByName('Watername').AsString;
           if IscnppHeatName then
             Data[Row,IndcnppHeatName]:=qrPremises.FieldByName('Heatname').AsString;
           if IscnppConditionName then
             Data[Row,IndcnppConditionName]:=qrPremises.FieldByName('conditionname').AsString;
           if IscnppBalconyName then
             Data[Row,IndcnppBalconyName]:=qrPremises.FieldByName('balconyname').AsString;
           if IscnppStoveName then
             Data[Row,IndcnppStoveName]:=qrPremises.FieldByName('stovename').AsString;
           if IscnppSelfFormName then
             Data[Row,IndcnppSelfFormName]:=qrPremises.FieldByName('selfformname').AsString;
           if IscnppPriceUnitPrice then
             Data[Row,IndcnppPriceUnitPrice]:=qrPremises.FieldByName('price').AsString+qrPremises.FieldByName('unitpricename').AsString;
           if IscnppAgentName then
             Data[Row,IndcnppAgentName]:=qrPremises.FieldByName('fullagent').AsString;
           if IscnppStationName then
             Data[Row,IndcnppStationName]:=qrPremises.FieldByName('stationname').AsString;
           if IscnppContactClientInfo then
             Data[Row,IndcnppContactClientInfo]:=Trim(TranslateContact(Trim(qrPremises.FieldByName('contact').AsString))+' '+qrPremises.FieldByName('clientinfo').AsString);
           if IscnppDateTimeUpdate then
             Data[Row,IndcnppDateTimeUpdate]:=FormatDateTime(fmtSmallDate,qrPremises.FieldByName('datetimeupdate').AsDateTime);
           if IscnppDelivery then
             Data[Row,IndcnppDelivery]:=qrPremises.FieldByName('delivery').AsString;
           if IscnppBuilderName then
             Data[Row,IndcnppBuilderName]:=qrPremises.FieldByName('buildername').AsString;
           if IscnppPrice2 then
             Data[Row,IndcnppPrice2]:=qrPremises.FieldByName('price2').AsString;
           if IscnppPrice then
             Data[Row,IndcnppPrice]:=qrPremises.FieldByName('price').AsString;
           if IscnppDateTimeInsert then
             Data[Row,IndcnppDateTimeInsert]:=FormatDateTime(fmtSmallDate,qrPremises.FieldByName('datetimeinsert').AsDateTime);

           inc(Row);
           R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
           if UseStyle and (Trim(qrPremises.FieldByName('stylestyle').AsString)<>'') then
             R.Style:=qrPremises.FieldByName('stylestyle').AsString;
           qrPremises.Next;
         end;
         R:=Sh.Range[Sh.Cells[oldY,1],Sh.Cells[curY,ColumnCount]];
         R.Font.Size:=6;
         R.Value:=Data;

         if IscnppPhoneName then begin
           OldFontName:=Sh.Range[Sh.Cells[1,IndcnppPhoneName],Sh.Cells[1,IndcnppPhoneName]].Font.Name;
           Sh.Columns[IndcnppPhoneName].Font.Name:=fmOptions.edPhoneColumn.Font.Name;
           Sh.Range[Sh.Cells[2,IndcnppPhoneName],Sh.Cells[2,IndcnppPhoneName]].Font.Name:=Sh.Range[Sh.Cells[2,1],Sh.Cells[2,1]].Font.Name;
           Sh.Range[Sh.Cells[1,IndcnppPhoneName],Sh.Cells[1,IndcnppPhoneName]].Font.Name:=OldFontName;
         end;

       end;
       inc(incCR);
       FillChar(TSPBS,SizeOf(TSPBS),0);
       TSPBS.Progress:=incCR;
       TSPBS.Max:=qrStation.RecordCount;
       _SetProgressBarStatus(pb1,@TSPBS);
       qrStation.Next;
     end;
   finally
     TRptExcelThreadPms_Price(THread).FCurPB:=pb1;
     TRptExcelThreadPms_Price(THread).Synchronize(TRptExcelThreadPms_Price(THread).FreeCurPB);
   end;

   if IscnppPhoneName then begin
     OldFontName:=Sh.Range[Sh.Cells[1,IndcnppPhoneName],Sh.Cells[1,IndcnppPhoneName]].Font.Name;
     Sh.Columns[IndcnppPhoneName].Font.Name:=fmOptions.edPhoneColumn.Font.Name;
     Sh.Range[Sh.Cells[2,IndcnppPhoneName],Sh.Cells[2,IndcnppPhoneName]].Font.Name:=Sh.Range[Sh.Cells[2,1],Sh.Cells[2,1]].Font.Name;
     Sh.Range[Sh.Cells[1,IndcnppPhoneName],Sh.Cells[1,IndcnppPhoneName]].Font.Name:=OldFontName;
   end;

   ShMain.Activate;
   Wb.Save;

 finally
   tran.free;
   qrPremises.Free;
   qrStation.Free;
   Screen.Cursor:=crDefault;
 end;
end;


end.
