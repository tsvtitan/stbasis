unit URptExport;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, OleCtnrs, StdCtrls, Buttons, ExtCtrls, Excel97, ComCtrls, IBQuery,
  IBDatabase, Db, IBCustomDataSet, rxRichEd;

type
  TfmRptExport = class(TfmRptMain)
    pnRelease: TPanel;
    pnResult: TPanel;
    grbResult: TGroupBox;
    pnBackRichEdit: TPanel;
    bibSave: TButton;
    sd: TSaveDialog;
    grbCase: TGroupBox;
    edRelease: TEdit;
    bibRelease: TButton;
    rbExportByNumrelease: TRadioButton;
    rbExportByPeriod: TRadioButton;
    dtpDateFrom: TDateTimePicker;
    lbPeriodTo: TLabel;
    dtpDateTo: TDateTimePicker;
    bibPeriod: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibBreakClick(Sender: TObject);
    procedure bibReleaseClick(Sender: TObject);
    procedure bibGenClick(Sender: TObject);
    procedure bibSaveClick(Sender: TObject);
    procedure bibPeriodClick(Sender: TObject);
    procedure rbExportByNumreleaseClick(Sender: TObject);
  private
    procedure OnRptTerminate(Sender: TObject);
    procedure SetReleaseNumRelease;
    function CheckFieldsFill: Boolean;
  public
    release_id: Integer;
    NumRelease: string;
    NoteRelease: string;
    reResult: TRXRichEdit;
    procedure LoadFromIni;override;
    procedure SaveToIni;override;
    procedure GenerateReport;override;
    procedure ThreadCreate;
    procedure ThreadDestroy;
  end;

var
  fmRptExport: TfmRptExport;

implementation

uses UAncementCode,URptThread,comobj,UMainUnited,ActiveX, UAncementData, tsvRTFStream,
     UAncementOptions, tsvComponentFont;

type

  TInfoAnnouncement=packed record
    Word: string;
    Text: string;
    ContactPhone: string;
    HomePhone: string;
    WorkPhone: string
  end;

  TRptThreadExport=class(TRptThread)
  private
    FRtfStream: TTsvRTFMemoryStream;
    ListProgressBars: TList;
    ListTreeHeading: TList;
    procedure ClearAndFreeListTreeHeading(List: TList);
  public
    fmParent: TfmRptExport;
    procedure Execute;override;
    constructor Create; override;
    destructor Destroy;override;
  end;

var
  Rpt: TRptThreadExport;

{$R *.DFM}

procedure TfmRptExport.FormCreate(Sender: TObject);
var
  dt: TDateTime;
begin
 inherited;
 try
  Caption:=NameRptExport;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  reResult:=TRXRichEdit.Create(nil);
  reResult.Parent:=pnBackRichEdit;
  reResult.Align:=alClient;
  reResult.ScrollBars:=ssBoth;
  reResult.WordWrap:=false;
  reResult.AutoURLDetect:=false;
  reResult.SelectionBar:=false;
  reResult.ReadOnly:=true;

  edRelease.MaxLength:=15;

  dt:=_GetDateTimeFromServer;
  dtpDateFrom.DateTime:=dt;
  dtpDateTo.DateTime:=dt;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptExport.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(Rpt);
  reResult.Free;
  if FormState=[fsCreatedMDIChild] then
   fmRptExport:=nil;
end;

procedure TfmRptExport.SetReleaseNumRelease;
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' release_id='+inttostr(release_id)+' ');
  if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
   if ifExistsDataInParamRBookInterface(@TPRBI) then begin
    NumRelease:=Inttostr(GetFirstValueFromParamRBookInterface(@TPRBI,'numrelease'));
    NoteRelease:=GetFirstValueFromParamRBookInterface(@TPRBI,'about');
    edRelease.Text:=Trim(NoteRelease)+' ('+NumRelease+') от '+DateToStr(GetFirstValueFromParamRBookInterface(@TPRBI,'daterelease'));
   end;
  end;
end;

procedure TfmRptExport.LoadFromIni;
begin
 inherited;
 try
    rbExportByNumrelease.Checked:=ReadParam(ClassName,rbExportByNumrelease.Name,rbExportByNumrelease.Checked);
    rbExportByPeriod.Checked:=ReadParam(ClassName,rbExportByPeriod.Name,rbExportByPeriod.Checked);
    rbExportByNumreleaseClick(nil);
    dtpDateFrom.Date:=ReadParam(ClassName,dtpDateFrom.Name,dtpDateFrom.Date);
    dtpDateTo.Date:=ReadParam(ClassName,dtpDateTo.Name,dtpDateTo.Date);
    release_id:=ReadParam(ClassName,'release_id',release_id);
    SetReleaseNumRelease;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptExport.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,rbExportByNumrelease.Name,rbExportByNumrelease.Checked);
    WriteParam(ClassName,rbExportByPeriod.Name,rbExportByPeriod.Checked);
    WriteParam(ClassName,dtpDateFrom.Name,dtpDateFrom.Date);
    WriteParam(ClassName,dtpDateTo.Name,dtpDateTo.Date);
    WriteParam(ClassName,'release_id',release_id);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptExport.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(Rpt);
  bibBreakClick(nil);
end;

procedure TfmRptExport.GenerateReport;
begin
  if Rpt<>nil then exit;
  Rpt:=TRptThreadExport.Create;
  Rpt.fmParent:=Self;
  Rpt.OnTerminate:=OnRptTerminate;
  Rpt.Resume;
end;

procedure TfmRptExport.bibBreakClick(Sender: TObject);
begin
  if Rpt<>nil then
    Rpt.Terminate;
  inherited;  
end;

procedure TfmRptExport.bibReleaseClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='release_id';
  TPRBI.Locate.KeyValues:=release_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
   release_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'release_id');
   NumRelease:=inttostr(GetFirstValueFromParamRBookInterface(@TPRBI,'numrelease'));
   NoteRelease:=GetFirstValueFromParamRBookInterface(@TPRBI,'about');
   edRelease.Text:=Trim(NoteRelease)+' ('+NumRelease+') от '+DateToStr(GetFirstValueFromParamRBookInterface(@TPRBI,'daterelease'));
  end;
end;

function TfmRptExport.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if rbExportByNumrelease.Checked then begin
    if trim(edRelease.Text)='' then begin
      ShowErrorEx(Format(ConstFieldNoEmpty,[rbExportByNumrelease.Caption]));
      bibRelease.SetFocus;
      Result:=false;
      exit;
    end;
  end;
  if rbExportByPeriod.Checked then begin

  end;
end;

type
   THackRichEdit=class(TRichEdit)
   public
   end;

procedure TfmRptExport.bibGenClick(Sender: TObject);
begin
  if CheckFieldsFill then begin
   ThreadCreate;
   inherited;
  end;
end;

procedure TfmRptExport.ThreadCreate;
begin
  reResult.Lines.BeginUpdate;
  reResult.Lines.Clear;
  reResult.Enabled:=false;
  rbExportByNumreleaseClick(nil);
  rbExportByNumrelease.Enabled:=false;
  bibSave.Enabled:=false;
  edRelease.Enabled:=false;
  bibRelease.Enabled:=false;
  rbExportByPeriod.Enabled:=false;
  dtpDateFrom.Enabled:=false;
  lbPeriodTo.Enabled:=false;
  dtpDateTo.Enabled:=false;
  bibPeriod.Enabled:=false;
end;

procedure TfmRptExport.ThreadDestroy;
begin
  rbExportByNumrelease.Enabled:=true;
  bibSave.Enabled:=true;
  edRelease.Enabled:=true;
  bibRelease.Enabled:=true;
  rbExportByPeriod.Enabled:=true;
  dtpDateFrom.Enabled:=true;
  lbPeriodTo.Enabled:=true;
  dtpDateTo.Enabled:=true;
  bibPeriod.Enabled:=true;
  rbExportByNumreleaseClick(nil);
  reResult.Enabled:=true;
  reResult.Lines.EndUpdate;
end;

{ TRptThreadExport }

type
  PInfoTreeHeading=^TInfoTreeHeading;
  TInfoTreeHeading=packed record
    treeheading_id: Integer;
    name: string;
    font: TFont;
    ListChild: TList;
  end;

constructor TRptThreadExport.Create;
begin
  inherited Create;
  Priority:=tpHighest;
  ListProgressBars:=TList.Create;
  ListTreeHeading:=TList.Create;
  FRTFStream:=TTsvRTFMemoryStream.Create;
end;

procedure TRptThreadExport.ClearAndFreeListTreeHeading(List: TList);
var
  i: Integer;
  P: PInfoTreeHeading;
begin
  for i:=0 to List.Count-1 do begin
    P:=List.Items[i];
    P.font.Free;
    ClearAndFreeListTreeHeading(P.ListChild);
  end;
  LIst.Free;
end;

destructor TRptThreadExport.Destroy;
var
  i: Integer;
begin
  for i:=0 to ListProgressBars.Count-1 do begin
    _FreeProgressBar(THandle(ListProgressBars.Items[i]));
  end;
  ListProgressBars.Free;
  ClearAndFreeListTreeHeading(ListTreeHeading);
  if not FRTFStream.closed then FRTFStream.CloseRtf;
  FRTFStream.Position:=0;
  _SetSplashStatus(ConstLoadExportToResult);
  fmParent.reResult.Lines.LoadFromStream(FRTFStream);
  fmParent.ThreadDestroy;
  FRTFStream.Free;
  inherited;
end;

type
  PAutoReplace=^TAutoReplace;
  TAutoReplace=packed record
    What: String;
    OnWhat: String;
  end;

procedure TRptThreadExport.Execute;
var
  IncAnn: Integer;
  ListAutoReplace: TList;

  procedure CreateAutoReplace;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
    P: PAutoReplace;
  begin
    ListAutoReplace:=TList.Create;
    qr:=TIBQuery.Create(nil);
    tran:=TIBTransaction.Create(nil);
    try
      tran.AddDatabase(IBDB);
      IBDB.AddTransaction(tran);
      tran.Params.Text:=DefaultTransactionParamsTwo;

      qr.Database:=IBDB;
      qr.Transaction:=tran;
      qr.Transaction.Active:=true;
      sqls:='Select * from '+tbAutoReplace;
      qr.SQL.Add(sqls);
      qr.Active:=true;
      qr.FetchAll;
      qr.First;
      while not qr.Eof do begin
        New(P);
        FillChar(P^,SizeOf(TAutoReplace),0);
        P.What:=HexStrToStr(qr.FieldByName('what').AsString);
        P.OnWhat:=HexStrToStr(qr.FieldByName('On_what').AsString);
        ListAutoReplace.Add(P);
        qr.Next;
      end;
    finally
      tran.Free;
      qr.Free;
    end;
  end;

  procedure FreeAutoReplace;
  var
    P: PAutoReplace;
    i: Integer;
  begin
    for i:=ListAutoReplace.Count-1 downto 0 do begin
      P:=PAutoReplace(ListAutoReplace.Items[i]);
      Dispose(P);
    end;
    ListAutoReplace.Clear;
  end;

  function ConvertByAutoReplace(S: String): String;
  var
    i: Integer;
    P: PAutoReplace;
  begin
    Result:=S;
    for i:=0 to ListAutoReplace.Count-1 do begin
      P:=PAutoReplace(ListAutoReplace.Items[i]);
      Result:=ChangeString(Result,P.What,P.OnWhat);
    end;
  end;

  function PrepearePhone(Phone: string): String;
  const
    DefPref=',';

    procedure GetPhones(str: TStringList);
    var
      APos: Integer;
      tmps,S: string;
    begin
      Apos:=-1;
      tmps:=Phone;
      while Apos<>0 do begin
        APos:=AnsiPos(DefPref,tmps);
        if Apos>0 then begin
          S:=Copy(tmps,1,APos-1);
          tmps:=Copy(tmps,APos+Length(DefPref),Length(tmps)-APos-Length(DefPref)+1);
          str.Add(S);
        end else begin
          str.Add(tmps);
        end;
      end;
    end;

  var
    tmps,S,curr,last: string;
    i,j: Integer;
    incr: Integer;
    isPref: Boolean;
    str: TStringList;
    varPos: Integer;
  begin
    str:=TStringList.Create;
    try
     S:='';
     GetPhones(str);
     for i:=0 to str.Count-1 do begin
       tmps:=Trim(str.Strings[i]);
       tmps:=GetFirstWord(tmps,[' '],varPos);
       curr:=tmps;
       last:=Copy(Trim(str.Strings[i]),varPos+Length(' '),Length(str.Strings[i])-varPos-Length(' ')+1);
       if Length(tmps)=fmOptions.udAnnouncementNN.Position then begin
        incr:=0;
        isPref:=false;
        curr:='';
        for j:=1 to Length(tmps) do begin
         if isPref then begin
          curr:=curr+'-'+tmps[j];
          isPref:=false;
          incr:=0;
         end else
          curr:=curr+tmps[j];
          inc(incr);
          if incr=2 then isPref:=true;
        end;
       end;
       if i=0 then
        S:=curr+iff(Trim(Last)<>'',''+last,'')
       else S:=S+DefPref+' '+curr+iff(Trim(Last)<>'',''+last,'');

     end;
     Result:=S;
    finally
     str.Free;
    end;
  end;

  procedure ExportForEditing;
  var
    qrTree: TIBQuery;
    tranTree: TIBTransaction;
    ListIds: TList;

    procedure CreateCurrentTreeHeading(CurrId: Integer; B,A: string; fnt: TFont);
    var
      cf: TComponentFont;
      FontHexStr: string;
      NameHeading: string;
      val: Integer;
    begin
      cf:=TComponentFont.Create(nil);
      try
        qrTree.First;
        if qrTree.Locate('treeheading_id',CurrId,[loPartialKey]) then begin
          FontHexStr:=qrTree.FieldByName('font').AsString;
          NameHeading:=qrTree.FieldByName('nameheading').AsString;
          CreateCurrentTreeHeading(qrTree.FieldByName('parent_id').AsInteger,B,A,fnt);
          val:=ListIds.IndexOf(Pointer(CurrId));
          if val=-1 then begin
            cf.SetFontFromHexStr(FontHexStr);
            fnt.Assign(cf.Font);
            FRtfStream.CreateString(Trim(B+NameHeading+A),fnt,true);
            ListIds.Add(Pointer(CurrId));
          end;  
        end else begin

        end;
      finally
        cf.Free;
      end;
    end;

  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
    TCPB: TCreateProgressBar;
    TSPBS: TSetProgressBarStatus;
    ph: THandle;
    TIA: TInfoAnnouncement;
    fnt: TFont;
    RealStr,RealText: string;
    PosRealStr: Integer;
    s: string;
    TCLI: TCreateLogItem;
    LastTreeHeadingId: Integer;
    FullPath: string;
  begin
    try
      Screen.Cursor:=crHourGlass;
      qr:=TIBQuery.Create(nil);
      qrTree:=TIBQuery.Create(nil);
      tran:=TIBTransaction.Create(nil);
      tranTree:=TIBTransaction.Create(nil);
      fnt:=TFont.Create;
      ListIds:=TList.Create;
      try
        tranTree.AddDatabase(IBDB);
        IBDB.AddTransaction(tranTree);
        tranTree.Params.Text:=DefaultTransactionParamsTwo;

        if fmOptions.chbExportWithImport.Checked then FullPath:='1'
        else FullPath:='0';

        _SetSplashStatus(ConstCreateTreeHeading);
        qrTree.Database:=IBDB;
        qrTree.Transaction:=tranTree;
        qrTree.Transaction.Active:=true;
        sqls:='Select c.inc, (select nameheading from '+prGetTreeHeadingName+'('''+fmOptions.edPointerTree.Text+''',c.treeheading_id,'+FullPath+')) as nameheading,'+
              'c.treeheading_id,'+
              't.parent_id,t.font '+
              'from '+prCreateTreeHeading+'(null,null) c '+
              'left join '+tbTreeHeading+' t on c.treeheading_id=t.treeheading_id '+
              'order by 1';
        qrTree.SQL.Add(sqls);
        qrTree.Active:=true;
        qrTree.FetchAll;

        tran.AddDatabase(IBDB);
        IBDB.AddTransaction(tran);
        tran.Params.Text:=DefaultTransactionParamsTwo;

        _SetSplashStatus(ConstCreateAnnouncement);
        qr.Database:=IBDB;
        qr.Transaction:=tran;
        qr.Transaction.Active:=true;

        if fmParent.rbExportByNumrelease.Checked then begin
          sqls:='Select c.inc,'+
                'addstr(Upper(k.word),SubstrEx(Upper(a.textannouncement),1,80),''''),'+
                'a.textannouncement,'+
                'a.contactphone,'+
                'a.homephone,'+
                'a.workphone,'+
                'k.word as keywordsword,'+
                'c.treeheading_id '+
                'from '+prCreateTreeHeading+'(null,null) c '+
                'left join '+tbAnnouncement+' a on c.treeheading_id=a.treeheading_id '+
                'join '+tbRelease+' r on a.release_id=r.release_id '+
                'left join '+tbKeyWords+' k on a.word_id=k.word_id '+
                'where '+tbRelease+'.release_id='+inttostr(fmParent.release_id)+' '+
                'union all '+
                'Select c.inc,'+
                'addstr(Upper(k.word),SubstrEx(Upper(a.textannouncement),1,80),''''),'+
                'a.textannouncement,'+
                'a.contactphone,'+
                'a.homephone,'+
                'a.workphone,'+
                'k.word as keywordsword,'+
                'c.treeheading_id '+
                'from '+prCreateTreeHeading+'(null,null) c '+
                'left join '+tbAnnouncement+' a on c.treeheading_id=a.treeheading_id '+
                'join '+tbRelease+' r on a.release_id=r.release_id '+
                'left join '+tbKeyWords+' k on a.word_id=k.word_id '+
                'where '+tbRelease+'.numrelease<(select numrelease from '+tbRelease+' where release_id='+inttostr(fmParent.release_id)+') '+
                'and ('+tbRelease+'.numrelease+'+tbAnnouncement+'.copyprint)>(select numrelease from '+tbRelease+' where release_id='+inttostr(fmParent.release_id)+') '+
                'order by 1,2';
        end;
        if fmParent.rbExportByPeriod.Checked then begin

          fmParent.dtpDateFrom.Time:=StrToTime('0:00:00');
          fmParent.dtpDateTo.Time:=StrToTime('23:59:59');
          sqls:='Select c.inc,'+
                'addstr(Upper(k.word),SubstrEx(Upper(a.textannouncement),1,80),''''),'+
                'a.textannouncement,'+
                'a.contactphone,'+
                'a.homephone,'+
                'a.workphone,'+
                'k.word as keywordsword,'+
                'c.treeheading_id '+
                'from '+prCreateTreeHeading+'(null,null) c '+
                'left join '+tbAnnouncement+' a on c.treeheading_id=a.treeheading_id '+
                'join '+tbRelease+' r on a.release_id=r.release_id '+
                'left join '+tbKeyWords+' k on a.word_id=k.word_id '+
                'where a.indate>='+QuotedStr(DateTimeToStr(fmParent.dtpDateFrom.DateTime))+' and '+
                'a.indate<='+QuotedStr(DateTimeToStr(fmParent.dtpDateTo.DateTime))+' '+
                'order by 1,2';
        end;
        qr.sql.Add(sqls);
        qr.Active:=true;
        qr.FetchAll;

        TCPB.Min:=1;
        TCPB.Max:=qr.RecordCount;
        TCPB.Hint:=ConstCreateAnnouncement;
        TCPB.Color:=clNavy;
        ph:=_CreateProgressBar(@TCPB);
        ListProgressBars.Add(Pointer(ph));

          LastTreeHeadingId:=-1;
          qr.First;
          while not qr.Eof do begin

            if Terminated then exit;

            if LastTreeHeadingId<>qr.FieldByName('treeheading_id').AsInteger then begin
              if fmOptions.chbExportWithImport.Checked then begin
                 CreateCurrentTreeHeading(qr.FieldByName('treeheading_id').AsInteger,
                                          fmOptions.edBeforeTree.Text,
                                          fmOptions.edAfterTree.Text,
                                          fnt);
              end else begin
                 CreateCurrentTreeHeading(qr.FieldByName('treeheading_id').AsInteger,
                                          '',
                                          '',
                                          fnt);
              end;
            end;

            if not fmOptions.chbExportNoText.Checked then begin

              FillChar(TIA,SizeOf(TInfoAnnouncement),0);
              TIA.Word:=Trim(qr.FieldByName('keywordsword').AsString);
              TIA.Text:=Trim(qr.FieldByName('textannouncement').AsString);
              TIA.Text:=ChangeString(TIA.Text,#13#10,'');
              if fmOptions.chbExportWithAutoReplace.Checked then
                TIA.Text:=ConvertByAutoReplace(TIA.Text);
              
              TIA.ContactPhone:=Trim(qr.FieldByName('contactphone').AsString);
              TIA.ContactPhone:=PrepearePhone(TIA.ContactPhone);
              TIA.HomePhone:=Trim(qr.FieldByName('homephone').AsString);
              TIA.HomePhone:=PrepearePhone(TIA.HomePhone);
              TIA.WorkPhone:=Trim(qr.FieldByName('workphone').AsString);
              TIA.WorkPhone:=PrepearePhone(TIA.WorkPhone);

              fnt.Assign(fmOptions.edFontExportKeyWords.Font);
              if Trim(TIA.Word)<>'' then begin
                if fmOptions.chbExportWordKeyWithDelim.Checked then
                  RealStr:=TIA.Word+fmOptions.edExportWordKeyWithDelim.Text
                else RealStr:=TIA.Word+' ';
                RealText:=TIA.Text;
              end else begin
                if fmOptions.chbAndText.Checked then
                  RealStr:=GetFirstWord(TIA.Text,[' '],PosRealStr)+fmOptions.edExportWordKeyWithDelim.Text
                else RealStr:=GetFirstWord(TIA.Text,[' '],PosRealStr)+' ';
                RealText:=Copy(TIA.Text,PosRealStr+Length(' ')+1,Length(TIA.Text)-PosRealStr-Length(' '));
              end;
              if fmOptions.chbExportUpperKeyWords.Checked then
                RealStr:=AnsiUpperCase(RealStr);

              if Trim(RealStr)<>'' then begin
                FRtfStream.CreateString(RealStr,fnt,false);

               s:=Iff(Trim(RealText)<>'',RealText,'')+
                  Iff((Trim(TIA.ContactPhone)<>'')or(Trim(TIA.HomePhone)<>'')or(Trim(TIA.WorkPhone)<>''),fmOptions.edBeforePhones.Text,'')+
                  Iff(Trim(TIA.ContactPhone)<>'',fmOptions.edBeforeCP.Text+TIA.ContactPhone+fmOptions.edAfterCP.Text,'')+
                  Iff(Trim(TIA.HomePhone)<>'',Iff(Trim(TIA.ContactPhone)<>'',',','')+fmOptions.edBeforeHP.Text+TIA.HomePhone+fmOptions.edAfterHP.Text,'')+
                  Iff(Trim(TIA.WorkPhone)<>'',Iff((Trim(TIA.ContactPhone)<>'')or(Trim(TIA.HomePhone)<>''),',','')+fmOptions.edBeforeWP.Text+TIA.WorkPhone+fmOptions.edAfterWP.Text,'')+
                  Iff((Trim(TIA.ContactPhone)<>'')or(Trim(TIA.HomePhone)<>'')or(Trim(TIA.WorkPhone)<>''),fmOptions.edAfterPhones.Text,'');

               fnt.Assign(fmOptions.edFontExportText.Font);
               FRtfStream.CreateString(Trim(Iff(Trim(RealStr)<>'',S,S)),fnt,true);
              end;

            end;  

            inc(IncAnn);
            TSPBS.Progress:=IncAnn;
            TSPBS.Hint:='';
            _SetProgressBarStatus(ph,@TSPBS);

            LastTreeHeadingId:=qr.FieldByName('treeheading_id').AsInteger;
            qr.Next;
          end;
      finally
        ListIds.Free;
        fnt.Free;
        tranTree.Free;
        tran.Free;
        qrTree.Free;
        qr.Free;
        Screen.Cursor:=crDefault;
      end;
    except
    {$IFDEF DEBUG}
      on E: Exception do begin
       try
         TCLI.ViewLogItemProc:=nil;
         TCLI.TypeLogItem:=tliError;
         TCLI.Text:=PChar(E.message);
         _CreateLogItem(@TCLI);
         Assert(false,E.message);
       except
        Application.HandleException(nil);
       end;
      end;
    {$ENDIF}
    end;
  end;

  procedure ExportForSite;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    fnt: TFont;
    sqls: string;
    TCPB: TCreateProgressBar;
    TSPBS: TSetProgressBarStatus;
    ph: THandle;
    TCLI: TCreateLogItem;
    s,contact,wp,hp,cp,anno: string;
  begin
    try
      Screen.Cursor:=crHourGlass;
      qr:=TIBQuery.Create(nil);
      tran:=TIBTransaction.Create(nil);
      fnt:=TFont.Create;
      try
        tran.AddDatabase(IBDB);
        IBDB.AddTransaction(tran);
        tran.Params.Text:=DefaultTransactionParamsTwo;

        _SetSplashStatus(ConstCreateAnnouncement);
        qr.Database:=IBDB;
        qr.Transaction:=tran;
        qr.Transaction.Active:=true;

        if fmParent.rbExportByNumrelease.Checked then begin
          sqls:='Select '+
                'a.announcement_id,'+
                'a.release_id,'+
                'a.treeheading_id,'+
                'k.word as keywordsword,'+
                'a.textannouncement,'+
                'a.contactphone,'+
                'a.homephone,'+
                'a.workphone,'+
                'a.indate '+
                'from '+tbAnnouncement+' a  '+
                'join '+tbRelease+' r on a.release_id=r.release_id '+
                'left join '+tbKeyWords+' k on a.word_id=k.word_id '+
                'where '+tbRelease+'.release_id='+inttostr(fmParent.release_id)+'  ';
{                'union all '+
                'Select '+
                'a.announcement_id,'+
                'a.release_id,'+
                'a.treeheading_id,'+
                'k.word as keywordsword,'+
                'a.textannouncement,'+
                'a.contactphone,'+
                'a.homephone,'+
                'a.workphone,'+
                'a.indate '+
                'from '+tbAnnouncement+' a '+
                'join '+tbRelease+' r on a.release_id=r.release_id '+
                'left join '+tbKeyWords+' k on a.word_id=k.word_id '+
                'where '+tbRelease+'.numrelease<(select numrelease from '+tbRelease+' where release_id='+inttostr(fmParent.release_id)+') '+
                'and ('+tbRelease+'.numrelease+'+tbAnnouncement+'.copyprint)>(select numrelease from '+tbRelease+' where release_id='+inttostr(fmParent.release_id)+') ';
                }
        end;
        if fmParent.rbExportByPeriod.Checked then begin

          fmParent.dtpDateFrom.Time:=StrToTime('0:00:00');
          fmParent.dtpDateTo.Time:=StrToTime('23:59:59');
          sqls:='Select '+
                'a.announcement_id,'+
                'a.release_id,'+
                'a.treeheading_id,'+
                'k.word as keywordsword,'+
                'a.textannouncement,'+
                'a.contactphone,'+
                'a.homephone,'+
                'a.workphone,'+
                'a.indate '+
                'from '+tbAnnouncement+' a '+
                'left join '+tbKeyWords+' k on a.word_id=k.word_id '+
                'where a.indate>='+QuotedStr(DateTimeToStr(fmParent.dtpDateFrom.DateTime))+' and '+
                'a.indate<='+QuotedStr(DateTimeToStr(fmParent.dtpDateTo.DateTime))+' ';
        end;
        qr.sql.Add(sqls);
        qr.Active:=true;
        qr.FetchAll;

        TCPB.Min:=1;
        TCPB.Max:=qr.RecordCount;
        TCPB.Hint:=ConstCreateAnnouncement;
        TCPB.Color:=clNavy;
        ph:=_CreateProgressBar(@TCPB);
        ListProgressBars.Add(Pointer(ph));

        qr.First;
        while not qr.Eof do begin
          if Terminated then exit;
          wp:=qr.FieldByName('workphone').AsString;
          hp:=qr.FieldByName('homephone').AsString;
          cp:=qr.FieldByName('contactphone').AsString;
          contact:=Iff((Trim(cp)<>'')or(Trim(hp)<>'')or(Trim(wp)<>''),fmOptions.edBeforePhones.Text,'')+
                   Iff(Trim(cp)<>'',fmOptions.edBeforeCP.Text+cp+fmOptions.edAfterCP.Text,'')+
                   Iff(Trim(hp)<>'',Iff(Trim(cp)<>'',',','')+fmOptions.edBeforeHP.Text+hp+fmOptions.edAfterHP.Text,'')+
                   Iff(Trim(wp)<>'',Iff((Trim(cp)<>'')or(Trim(hp)<>''),',','')+fmOptions.edBeforeWP.Text+wp+fmOptions.edAfterWP.Text,'')+
                   Iff((Trim(cp)<>'')or(Trim(hp)<>'')or(Trim(wp)<>''),fmOptions.edAfterPhones.Text,'');
          anno:=qr.FieldByName('keywordsword').AsString+' '+qr.FieldByName('textannouncement').AsString;

          s:=Format(fmtAnnouncementInsertSql,[qr.FieldByName('announcement_id').AsString,
                                              qr.FieldByName('release_id').AsString,
                                              qr.FieldByName('treeheading_id').AsString,
                                              iff(Trim(anno)<>'',QuotedStr(Trim(anno)),'null'),
                                              iff(Trim(contact)<>'',QuotedStr(Trim(contact)),'null'),
                                              QuotedStr(FormatDateTime(fmtDateTimeExportForSite,qr.FieldByName('indate').AsDateTime))]);
          FRtfStream.CreateString(s,fnt,true);
          inc(IncAnn);
          TSPBS.Progress:=IncAnn;
          TSPBS.Hint:='';
          _SetProgressBarStatus(ph,@TSPBS);
          qr.Next;
        end;

      finally
        fnt.Free;
        tran.Free;
        qr.Free;
        Screen.Cursor:=crDefault;
      end;
    except
    {$IFDEF DEBUG}
      on E: Exception do begin
       try
         TCLI.ViewLogItemProc:=nil;
         TCLI.TypeLogItem:=tliError;
         TCLI.Text:=PChar(E.message);
         _CreateLogItem(@TCLI);
         Assert(false,E.message);
       except
        Application.HandleException(nil);
       end;
      end;
    {$ENDIF}
    end;
  end;

var
  TCLI: TCreateLogItem;
  t1: TDateTime;
begin
 try
   t1:=Now;
   try
    IncAnn:=0;

    FRtfStream.OpenRtf;
    FRtfStream.CreateHeader;
    FRtfStream.OpenBody;

    CreateAutoReplace;

    if fmOptions.rbForEditing.Checked then
      ExportForEditing;
    if fmOptions.rbForSite.Checked then
      ExportForSite;
    FRtfStream.CloseBody;
    FRtfStream.CloseRtf;

   finally
     FreeAutoReplace;
     TCLI.ViewLogItemProc:=nil;
     TCLI.TypeLogItem:=tliInformation;
     TCLI.Text:=PChar(Format(fmtExportCountPlusTime,[IncAnn,TimeToStr(Now-t1)]));
     _CreateLogItem(@TCLI);
     DoTerminate;
   end;
 except
  {$IFDEF DEBUG}
    on E: Exception do begin
     try
       TCLI.ViewLogItemProc:=nil;
       TCLI.TypeLogItem:=tliError;
       TCLI.Text:=PChar(E.message);
       _CreateLogItem(@TCLI);
       Assert(false,E.message);
     except
       Application.HandleException(nil);
     end;
    end;
  {$ENDIF}
 end;
end;


procedure TfmRptExport.bibSaveClick(Sender: TObject);
var
  Dir: string;
  sFile: string;
const
  fmtFile='dd.mm.yyyy hh.nn.ss';
begin
  Dir:=ExpandFileName(_GetOptions.DirTemp);
//  Dir:=_GetOptions.DirTemp;
  sFile:=Dir+'\'+Trim(NoteRelease)+' ('+NumRelease+') от '+FormatDateTime(fmtFile,Now);
  sd.InitialDir:=Dir;
  if fmOptions.rbForEditing.Checked then begin
    sd.DefaultExt:='.rtf';
    sd.FileName:=sFile+sd.DefaultExt;
    sd.FilterIndex:=1;
  end;
  if fmOptions.rbForSite.Checked then begin
    sd.DefaultExt:='.txt';
    sd.FileName:=sFile+sd.DefaultExt;
    sd.FilterIndex:=2;
  end;
  if sd.Execute then begin
    try
     Screen.Cursor:=crHourGlass;
     try
      reResult.Lines.SaveToFile(sd.FileName);
     finally
      Screen.Cursor:=crDefault;
     end; 
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
  end;
end;

procedure TfmRptExport.bibPeriodClick(Sender: TObject);
var
  T: TInfoEnterPeriod;
begin
  FillChar(T,SizeOf(T),0);
  T.TypePeriod:=tepInterval;
  T.TypePeriod:=ReadParam(ClassName,'period',T.TypePeriod);
  T.LoadAndSave:=false;
  T.DateBegin:=dtpDateFrom.DateTime;
  T.DateEnd:=dtpDateTo.DateTime;
  if _ViewEnterPeriod(@T) then begin
    dtpDateFrom.DateTime:=T.DateBegin;
    dtpDateTo.DateTime:=T.DateEnd;
    WriteParam(ClassName,'period',T.TypePeriod);
  end;
end;

procedure TfmRptExport.rbExportByNumreleaseClick(Sender: TObject);
begin
  edRelease.Enabled:=iff(rbExportByNumrelease.Checked,true,false);
  bibRelease.Enabled:=Iff(rbExportByNumrelease.Checked,true,false);
  dtpDateFrom.Color:=iff(rbExportByPeriod.Checked,clWindow,clBtnFace);
  dtpDateFrom.Enabled:=Iff(rbExportByPeriod.Checked,true,false);
  lbPeriodTo.Enabled:=Iff(rbExportByPeriod.Checked,true,false);
  dtpDateTo.Color:=iff(rbExportByPeriod.Checked,clWindow,clBtnFace);
  dtpDateTo.Enabled:=Iff(rbExportByPeriod.Checked,true,false);
  bibPeriod.Enabled:=Iff(rbExportByPeriod.Checked,true,false);
end;

end.
