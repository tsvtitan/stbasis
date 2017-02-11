unit URptPms_PriceSaleClient;

interface

uses classes, Forms;

procedure RtpSaleRunClient(Thread: TThread; Form, Options: TForm; sFileName, sTypeOperation: string;
                           UseStyle: Boolean; SyncOfficeId: String);

implementation

uses Windows, sysutils, controls, graphics, IBQuery, IBDatabase, Db, IBCustomDataSet, Excel97,
     UMainUnited, URptPms_Price, URptThread, UPremisesTsvData, UPremisesTsvOptions;

procedure RtpSaleRunClient(Thread: TThread; Form, Options: TForm; sFileName, sTypeOperation: string;
                           UseStyle: Boolean; SyncOfficeId: String);
var
 tran: TIBTransaction;
 qrCountRoom,qrRegion: TIBQuery;
 qrPremises,qrTypePremises: TIbQuery;
 sqls: string;
 Sh,ShMain: OleVariant;
 Wb: OleVariant;
 R: OleVariant;
 oldY,curY: Integer;
 Data: Variant;
 Row: Integer;
 TCPB: TCreateProgressBar;
 TSPBS: TSetProgressBarStatus;
 incCR,incR,incTP: Integer;
 pb1,pb2: THandle;
 oldCountRoomId: Integer;
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

 qrCountRoom:=TIBQuery.Create(nil);
 qrRegion:=TIBQuery.Create(nil);
 qrPremises:=TIBQuery.Create(nil);
 qrTypePremises:=TIBQuery.Create(nil);
 tran:=TIBTransaction.Create(nil);
 Screen.Cursor:=crHourGlass;
 try
   tran.AddDatabase(IBDB);
   IBDB.AddTransaction(tran);
   qrCountRoom.Transaction:=tran;
   qrCountRoom.Database:=IBDB;
   qrRegion.Transaction:=tran;
   qrRegion.Database:=IBDB;
   qrPremises.Transaction:=tran;
   qrPremises.Database:=IBDB;
   qrTypePremises.Transaction:=tran;
   qrTypePremises.Database:=IBDB;
   tran.Active:=true;

   sqls:=SQLRbkPms_CountRoom+
         ' where pms_countroom_id in (select p.pms_countroom_id from pms_premises p '+
         ' where p.datearrivals>='+QuotedStr(DateToStr(fmParent.dtpDateFrom.DateTime))+
         ' and p.datearrivals<='+QuotedStr(DateToStr(fmParent.dtpDateTo.DateTime))+
         ' and p.typeoperation='+inttostr(0)+fmParent.GetRecyledFilter+fmParent.GetStationFilter+')'+
         ' order by sortnumber';
   qrCountRoom.SQL.Add(sqls);
   qrCountRoom.Active:=true;
   qrCountRoom.Last;
   qrCountRoom.First;

   sqls:=SQLRbkPms_Region+
         ' where pms_region_id in (select p.pms_region_id from pms_premises p '+
         ' where p.datearrivals>='+QuotedStr(DateToStr(fmParent.dtpDateFrom.DateTime))+
         ' and p.datearrivals<='+QuotedStr(DateToStr(fmParent.dtpDateTo.DateTime))+
         ' and p.typeoperation='+inttostr(0)+fmParent.GetRecyledFilter+fmParent.GetStationFilter+')'+
         ' order by sortnumber';
   qrRegion.SQL.Add(sqls);
   qrRegion.Active:=true;
   qrRegion.Last;
   qrRegion.First;

   sqls:=SQLRbkPms_TypePremises+
         ' where pms_typepremises_id in (select p.pms_typepremises_id from pms_premises p '+
         ' where p.datearrivals>='+QuotedStr(DateToStr(fmParent.dtpDateFrom.DateTime))+
         ' and p.datearrivals<='+QuotedStr(DateToStr(fmParent.dtpDateTo.DateTime))+
         ' and p.typeoperation='+inttostr(0)+fmParent.GetRecyledFilter+fmParent.GetStationFilter+')'+
         ' and use_in_report=1'+
         ' order by sortnumber';
   qrTypePremises.SQL.Add(sqls);
   qrTypePremises.Active:=true;
   qrTypePremises.Last;
   qrTypePremises.First;

   ShMain:=Sh;
   incTP:=1;

   while not qrTypePremises.Eof do begin
     oldCountRoomId:=-1;
     ShMain.Select;
     ShMain.Copy(After:=Sh);
     Sh:=Wb.Sheets.Item[incTP+1];
     Sh.Name:=qrTypePremises.FieldByName('note').AsString;
     curY:=3;
     FillChar(TCPB,SizeOf(TCPB),0);
     TCPB.Min:=0;
     TCPB.Max:=qrCountRoom.RecordCount;
     TCPB.Color:=clNavy;
     pb1:=_CreateProgressBar(@TCPB);
     incCR:=0;
     FillChar(TCPB,SizeOf(TCPB),0);
     TCPB.Min:=0;
     TCPB.Max:=qrRegion.RecordCount;
     TCPB.Color:=clBlue;
     pb2:=_CreateProgressBar(@TCPB);
     try
       qrCountRoom.First;
       while not qrCountRoom.Eof do begin
         if TRptExcelThreadPms_Price(THread).Terminated then exit;
         incR:=0;
         qrRegion.First;
         while not qrRegion.Eof do begin
           if TRptExcelThreadPms_Price(THread).Terminated then exit;
           sqls:=SQLRbkPms_PremisesRpt+
                 ' where p.datearrivals>='+QuotedStr(DateToStr(fmParent.dtpDateFrom.DateTime))+
                 ' and p.datearrivals<='+QuotedStr(DateToStr(fmParent.dtpDateTo.DateTime))+
                 ' and p.pms_countroom_id='+qrCountRoom.FieldByname('pms_countroom_id').AsString+
                 ' and p.pms_region_id='+qrRegion.FieldByname('pms_region_id').AsString+
                 ' and p.pms_typepremises_id='+qrTypePremises.FieldByname('pms_typepremises_id').AsString+
                 ' and p.typeoperation='+inttostr(0)+
                 fmParent.GetRecyledFilter+
                 fmParent.GetStationFilter+
                 fmParent.GetOfficeFilter+
                 fmParent.GetOrder;

           qrPremises.SQL.Clear;
           qrPremises.SQL.Add(sqls);
           qrPremises.Active:=true;
           qrPremises.Last;
           if not qrPremises.IsEmpty then begin
             if oldCountRoomId<>qrCountRoom.FieldByname('pms_countroom_id').AsInteger then begin
               inc(curY);
               R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
               R.Merge;
               R.HorizontalAlignment:=xlCenter;
               R.VerticalAlignment:=xlCenter;
               R.Font.Size:=16;
               R.Font.Bold:=true;
               R.Value:=qrCountRoom.FieldByname('note').AsString;
               R.Rows.AutoFit;
             end;
             oldCountRoomId:=qrCountRoom.FieldByname('pms_countroom_id').AsInteger;

             inc(curY);
             R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
             R.Merge;
             R.HorizontalAlignment:=xlCenter;
             R.VerticalAlignment:=xlCenter;
             R.Font.Size:=10;
             R.Font.Bold:=true;
             R.Font.Underline:=xlUnderlineStyleSingle;
             R.Value:=qrRegion.FieldByname('name').AsString;

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
               inc(Row);
               R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
               if UseStyle and (Trim(qrPremises.FieldByName('stylestyle').AsString)<>'') then begin
                 R.Style:=qrPremises.FieldByName('stylestyle').AsString;
               end;
               qrPremises.Next;
             end;
             R:=Sh.Range[Sh.Cells[oldY,1],Sh.Cells[curY,ColumnCount]];
             R.Font.Size:=8;
             R.Value:=Data;

             if IscnppPhoneName then begin
               OldFontName:=Sh.Range[Sh.Cells[1,IndcnppPhoneName],Sh.Cells[1,IndcnppPhoneName]].Font.Name;
               Sh.Columns[IndcnppPhoneName].Font.Name:=fmOptions.edPhoneColumn.Font.Name;
               Sh.Range[Sh.Cells[2,IndcnppPhoneName],Sh.Cells[2,IndcnppPhoneName]].Font.Name:=Sh.Range[Sh.Cells[2,1],Sh.Cells[2,1]].Font.Name;
               Sh.Range[Sh.Cells[1,IndcnppPhoneName],Sh.Cells[1,IndcnppPhoneName]].Font.Name:=OldFontName;
             end;

             inc(curY);
             R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
             R.Merge;
           end;
           inc(incR);
           FillChar(TSPBS,SizeOf(TSPBS),0);
           TSPBS.Progress:=incR;
           TSPBS.Max:=qrRegion.RecordCount;
           _SetProgressBarStatus(pb2,@TSPBS);
           qrRegion.Next;
         end;
         inc(incCR);
         FillChar(TSPBS,SizeOf(TSPBS),0);
         TSPBS.Progress:=incCR;
         TSPBS.Max:=qrCountRoom.RecordCount;
         _SetProgressBarStatus(pb1,@TSPBS);
         qrCountRoom.Next;
       end;
     finally
       TRptExcelThreadPms_Price(THread).FCurPB:=pb2;
       TRptExcelThreadPms_Price(THread).Synchronize(TRptExcelThreadPms_Price(THread).FreeCurPB);
       TRptExcelThreadPms_Price(THread).FCurPB:=pb1;
       TRptExcelThreadPms_Price(THread).Synchronize(TRptExcelThreadPms_Price(THread).FreeCurPB);
     end;
     inc(incTP);
     qrTypePremises.Next;
   end;

   curY:=3;
   Sh:=ShMain;
   Sh.Name:='Вся недвижимость';
   oldCountRoomId:=-1;

   FillChar(TCPB,SizeOf(TCPB),0);
   TCPB.Min:=0;
   TCPB.Max:=qrCountRoom.RecordCount;
   TCPB.Color:=clNavy;
   pb1:=_CreateProgressBar(@TCPB);
   incCR:=0;
   FillChar(TCPB,SizeOf(TCPB),0);
   TCPB.Min:=0;
   TCPB.Max:=qrRegion.RecordCount;
   TCPB.Color:=clBlue;
   pb2:=_CreateProgressBar(@TCPB);
   try
     qrCountRoom.First;
     while not qrCountRoom.Eof do begin
       if TRptExcelThreadPms_Price(THread).Terminated then exit;
       incR:=0;
       qrRegion.First;
       while not qrRegion.Eof do begin
         if TRptExcelThreadPms_Price(THread).Terminated then exit;
         sqls:=SQLRbkPms_PremisesRpt+
               ' where p.datearrivals>='+QuotedStr(DateToStr(fmParent.dtpDateFrom.DateTime))+
               ' and p.datearrivals<='+QuotedStr(DateToStr(fmParent.dtpDateTo.DateTime))+
               ' and p.pms_countroom_id='+qrCountRoom.FieldByname('pms_countroom_id').AsString+
               ' and p.pms_region_id='+qrRegion.FieldByname('pms_region_id').AsString+
               ' and p.typeoperation='+inttostr(0)+
               fmParent.GetRecyledFilter+
               fmParent.GetStationFilter+
               fmParent.GetOfficeFilter+
               fmParent.GetOrder;
                 
         qrPremises.SQL.Clear;
         qrPremises.SQL.Add(sqls);
         qrPremises.Active:=true;
         qrPremises.Last;
         if not qrPremises.IsEmpty then begin
           if oldCountRoomId<>qrCountRoom.FieldByname('pms_countroom_id').AsInteger then begin
             inc(curY);
             R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
             R.Merge;
             R.HorizontalAlignment:=xlCenter;
             R.VerticalAlignment:=xlCenter;
             R.Font.Size:=16;
             R.Font.Bold:=true;
             R.Value:=qrCountRoom.FieldByname('note').AsString;
             R.Rows.AutoFit;
           end;
           oldCountRoomId:=qrCountRoom.FieldByname('pms_countroom_id').AsInteger;

           inc(curY);
           R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
           R.Merge;
           R.HorizontalAlignment:=xlCenter;
           R.VerticalAlignment:=xlCenter;
           R.Font.Size:=10;
           R.Font.Bold:=true;
           R.Font.Underline:=xlUnderlineStyleSingle;
           R.Value:=qrRegion.FieldByname('name').AsString;

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
             inc(Row);
             R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
             if UseStyle and (Trim(qrPremises.FieldByName('stylestyle').AsString)<>'') then
               R.Style:=qrPremises.FieldByName('stylestyle').AsString;
             qrPremises.Next;
           end;
           R:=Sh.Range[Sh.Cells[oldY,1],Sh.Cells[curY,ColumnCount]];
           R.Font.Size:=8;
           R.Value:=Data;

           if IscnppPhoneName then begin
             OldFontName:=Sh.Range[Sh.Cells[1,IndcnppPhoneName],Sh.Cells[1,IndcnppPhoneName]].Font.Name;
             Sh.Columns[IndcnppPhoneName].Font.Name:=fmOptions.edPhoneColumn.Font.Name;
             Sh.Range[Sh.Cells[2,IndcnppPhoneName],Sh.Cells[2,IndcnppPhoneName]].Font.Name:=Sh.Range[Sh.Cells[2,1],Sh.Cells[2,1]].Font.Name;
             Sh.Range[Sh.Cells[1,IndcnppPhoneName],Sh.Cells[1,IndcnppPhoneName]].Font.Name:=OldFontName;
           end;

           inc(curY);
           R:=Sh.Range[Sh.Cells[curY,1],Sh.Cells[curY,ColumnCount]];
           R.Merge;
         end;
         inc(incR);
         FillChar(TSPBS,SizeOf(TSPBS),0);
         TSPBS.Progress:=incR;
         TSPBS.Max:=qrRegion.RecordCount;
         _SetProgressBarStatus(pb2,@TSPBS);
         qrRegion.Next;
       end;
       inc(incCR);
       FillChar(TSPBS,SizeOf(TSPBS),0);
       TSPBS.Progress:=incCR;
       TSPBS.Max:=qrCountRoom.RecordCount;
       _SetProgressBarStatus(pb1,@TSPBS);
       qrCountRoom.Next;
     end;
   finally
     TRptExcelThreadPms_Price(THread).FCurPB:=pb2;
     TRptExcelThreadPms_Price(THread).Synchronize(TRptExcelThreadPms_Price(THread).FreeCurPB);
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
   VarClear(ShMain);
   VarClear(Sh);
   VarClear(R);
   VarClear(Wb);

 finally
   tran.free;
   qrTypePremises.Free;
   qrPremises.Free;
   qrRegion.Free;
   qrCountRoom.Free;
   Screen.Cursor:=crDefault;
 end;
end;

end.
