unit URptPms_PriceShareInspector2;

interface

uses classes, Forms;

procedure RtpShareRunInspector2(Thread: TThread; Form, Options: TForm; sFileName, sTypeOperation: string;
                                UseStyle: Boolean; SyncOfficeId: String);

implementation

uses Windows, sysutils, controls, graphics, IBQuery, IBDatabase, Db, IBCustomDataSet, Excel97,
     UMainUnited, URptPms_Price, URptThread, UPremisesTsvData, UPremisesTsvOptions,
     StbasisSClientDataSet;

procedure RtpShareRunInspector2(Thread: TThread; Form, Options: TForm; sFileName, sTypeOperation: string;
                                UseStyle: Boolean; SyncOfficeId: String);
var
 tran: TIBTransaction;
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
 OldContact: String;
 DataSet: TStbasisSClientDataSet;
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

 qrPremises:=TIBQuery.Create(nil);
 DataSet:=TStbasisSClientDataSet.Create(nil);
 tran:=TIBTransaction.Create(nil);
 Screen.Cursor:=crHourGlass;
 try
   tran.AddDatabase(IBDB);
   IBDB.AddTransaction(tran);
   qrPremises.Transaction:=tran;
   qrPremises.Database:=IBDB;
   tran.Active:=true;

   ShMain:=Sh;
   Sh.Name:='Вся недвижимость';
   curY:=3;
   incCR:=0;
   Flag:=false;
   sqls:=SQLRbkPms_PremisesRpt+
         ' where p.datearrivals>='+QuotedStr(DateToStr(fmParent.dtpDateFrom.DateTime))+
         ' and p.datearrivals<='+QuotedStr(DateToStr(fmParent.dtpDateTo.DateTime))+
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
     FillChar(TCPB,SizeOf(TCPB),0);
     TCPB.Min:=0;
     TCPB.Max:=qrPremises.RecordCount;
     TCPB.Color:=clNavy;
     pb1:=_CreateProgressBar(@TCPB);
     try
       DataSet.Close;
       DataSet.CreateDataSetBySource(qrPremises);
       qrPremises.First;
       OldContact:=qrPremises.FieldByName('contact').AsString;
       while not qrPremises.Eof do begin
         if TRptExcelThreadPms_Price(THread).Terminated then exit;
         if IscnppContact then begin
           if not AnsiSameText(qrPremises.FieldByName('contact').AsString,OldContact) then begin
             if Flag then begin
               inc(curY);
               R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
               R.Merge;
               R.HorizontalAlignment:=xlCenter;
               R.VerticalAlignment:=xlCenter;
               R.Font.Size:=8;
               R.RowHeight:=3;
               R.Borders[xlEdgeBottom].LineStyle:=xlDot;
               inc(curY);
               R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
               R.Merge;
               R.HorizontalAlignment:=xlCenter;
               R.VerticalAlignment:=xlCenter;
               R.Font.Size:=8;
               R.RowHeight:=3;
             end;
             Flag:=true;  

             oldY:=curY+1;
             Row:=1;
             Data:=VarArrayCreate([1,DataSet.RecordCount,1,ColumnCount],varVariant);
             DataSet.First;
             while not DataSet.Eof do begin
               if TRptExcelThreadPms_Price(THread).Terminated then exit;
               inc(curY);

               if IscnppDateArrivals then
                 Data[Row,IndcnppDateArrivals]:=FormatDateTime(fmtSmallDate,DataSet.FieldByName('datearrivals').AsDateTime);
               if IscnppCountRoomName then
                 Data[Row,IndcnppCountRoomName]:=DataSet.FieldByName('countroomname').AsString;
               if IscnppTypeRoomName then
                 Data[Row,IndcnppTypeRoomName]:=DataSet.FieldByName('typeroomname').AsString;
               if IscnppPlanningName then
                 Data[Row,IndcnppPlanningName]:=DataSet.FieldByName('planningname').AsString;
               if IscnppRegionName then
                 Data[Row,IndcnppRegionName]:=DataSet.FieldByName('regionname').AsString;
               if IscnppStreetName then
                 Data[Row,IndcnppStreetName]:=DataSet.FieldByName('streetname').AsString;
               if IscnppHouseNumber then
                 Data[Row,IndcnppHouseNumber]:=DataSet.FieldByName('housenumber').AsString;
               if IscnppApartmentNumber then
                 Data[Row,IndcnppApartmentNumber]:=DataSet.FieldByName('apartmentnumber').AsString;
               if IscnppPhoneName then
                 Data[Row,IndcnppPhoneName]:=DataSet.FieldByName('phonename').AsString;
               if IscnppSaleStatusName then
                 Data[Row,IndcnppSaleStatusName]:=DataSet.FieldByName('salestatusname').AsString;
               if IscnppNote then
                 Data[Row,IndcnppNote]:=DataSet.FieldByName('note').AsString;
               if IscnppFloor then
                 Data[Row,IndcnppFloor]:=DataSet.FieldByName('floor').AsString;
               if IscnppCountFloor then
                 Data[Row,IndcnppCountFloor]:=DataSet.FieldByName('countfloor').AsString;
               if IscnppTypeHouseName then
                 Data[Row,IndcnppTypeHouseName]:=DataSet.FieldByName('typehousename').AsString;
               if IscnppGeneralArea then
                 Data[Row,IndcnppGeneralArea]:=DataSet.FieldByName('generalarea').AsString;
               if IscnppDwellingArea then
                 Data[Row,IndcnppDwellingArea]:=DataSet.FieldByName('dwellingarea').AsString;
               if IscnppKitchenArea then
                 Data[Row,IndcnppKitchenArea]:=DataSet.FieldByName('kitchenarea').AsString;
               if IscnppSanitaryNodeName then
                 Data[Row,IndcnppSanitaryNodeName]:=DataSet.FieldByName('sanitarynodename').AsString;
               if IscnppHeatName then
                 Data[Row,IndcnppHeatName]:=DataSet.FieldByName('Heatname').AsString;
               if IscnppWaterName then
                 Data[Row,IndcnppWaterName]:=DataSet.FieldByName('Watername').AsString;
               if IscnppConditionName then
                 Data[Row,IndcnppConditionName]:=DataSet.FieldByName('conditionname').AsString;
               if IscnppBalconyName then
                 Data[Row,IndcnppBalconyName]:=DataSet.FieldByName('balconyname').AsString;
               if IscnppStoveName then
                 Data[Row,IndcnppStoveName]:=DataSet.FieldByName('stovename').AsString;
               if IscnppSelfFormName then
                 Data[Row,IndcnppSelfFormName]:=DataSet.FieldByName('selfformname').AsString;
               if IscnppPriceUnitPrice then
                 Data[Row,IndcnppPriceUnitPrice]:=DataSet.FieldByName('price').AsString+DataSet.FieldByName('unitpricename').AsString;
               if IscnppAgentName then
                 Data[Row,IndcnppAgentName]:=DataSet.FieldByName('fullagent').AsString;
               if IscnppStationName then
                 Data[Row,IndcnppStationName]:=DataSet.FieldByName('stationname').AsString;
               if IscnppContactClientInfo then
                 Data[Row,IndcnppContactClientInfo]:=Trim(TranslateContact(Trim(DataSet.FieldByName('contact').AsString))+' '+DataSet.FieldByName('clientinfo').AsString);
               if IscnppDateTimeUpdate then
                 Data[Row,IndcnppDateTimeUpdate]:=FormatDateTime(fmtSmallDate,DataSet.FieldByName('datetimeupdate').AsDateTime);
               if IscnppDelivery then
                 Data[Row,IndcnppDelivery]:=DataSet.FieldByName('delivery').AsString;
               if IscnppBuilderName then
                 Data[Row,IndcnppBuilderName]:=DataSet.FieldByName('buildername').AsString;
               if IscnppPrice2 then
                 Data[Row,IndcnppPrice2]:=DataSet.FieldByName('price2').AsString;
               if IscnppDecoration then
                 Data[Row,IndcnppDecoration]:=DataSet.FieldByName('decoration').AsString;
               if IscnppGlassy then
                 Data[Row,IndcnppGlassy]:=DataSet.FieldByName('glassy').AsString;
               if IscnppBlockSection then
                 Data[Row,IndcnppBlockSection]:=DataSet.FieldByName('block_section').AsString;
               if IscnppPrice then
                 Data[Row,IndcnppPrice]:=DataSet.FieldByName('price').AsString;
               if IscnppContact then
                 Data[Row,IndcnppContact]:=DataSet.FieldByName('contact').AsString;
               if IscnppClientInfo then
                 Data[Row,IndcnppClientInfo]:=DataSet.FieldByName('clientinfo').AsString;
               if IscnppDateTimeInsert then
                 Data[Row,IndcnppDateTimeInsert]:=FormatDateTime(fmtSmallDate,qrPremises.FieldByName('datetimeinsert').AsDateTime);

               inc(Row);
               R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
               if UseStyle and (Trim(DataSet.FieldByName('stylestyle').AsString)<>'') then
                 R.Style:=DataSet.FieldByName('stylestyle').AsString;
               DataSet.Next;
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

             DataSet.EmptyDataSet;
           end;
           OldContact:=qrPremises.FieldByName('contact').AsString;
           DataSet.FieldValuesBySource(qrPremises);
         end;

         inc(incCR);
         FillChar(TSPBS,SizeOf(TSPBS),0);
         TSPBS.Progress:=incCR;
         TSPBS.Max:=qrPremises.RecordCount;
         _SetProgressBarStatus(pb1,@TSPBS);

         qrPremises.Next;
       end;
     finally
       TRptExcelThreadPms_Price(THread).FCurPB:=pb1;
       TRptExcelThreadPms_Price(THread).Synchronize(TRptExcelThreadPms_Price(THread).FreeCurPB);
     end;
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
   DataSet.Free;
   qrPremises.Free;
   Screen.Cursor:=crDefault;
 end;
end;


end.
