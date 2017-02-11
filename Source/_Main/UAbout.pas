unit UAbout;

interface

{$I stbasis.inc}


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, jpeg, Marquee, shEllapi;

type
  TfmAbout = class(TForm)
    pnBottom: TPanel;
    btOk: TButton;
    pnRule: TPanel;
    lbTel: TLabel;
    lbCorp: TLabel;
    lbVer: TLabel;
    lbMain: TLabel;
    Bevel1: TBevel;
    lbMemAll: TLabel;
    lbMemUse: TLabel;
    Bevel2: TBevel;
    imEXE: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbMainDblClick(Sender: TObject);
    procedure imEXEClick(Sender: TObject);
  private
    StrScroll: TStringList;
    ScrllText: TddgMarquee;
    procedure FillAboutMarquee;
  public
    function GetUseLibsAndProgrammes: String;
    procedure ActiveScrollText(Text: String);
  end;

var
  fmAbout: TfmAbout;

implementation

uses UMain, UMainData, UMainUnited, UMainCode, USplash;

{$R *.DFM}

procedure TfmAbout.FormCreate(Sender: TObject);
var
  T: TmemoryStatus;
  dMem: LongWord;
  Percent: Extended;
  lpIcon: Word;
  TCAM: TCreateAboutMarquee;
begin
 try
  StrScroll:=TStringList.Create;

  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;

  ScrllText:=TddgMarquee.Create(nil);
  ScrllText.Justify:=tjLeft;
  ScrllText.Circle:=true;
  ScrllText.parent:=pnRule;
  ScrllText.Align:=alClient;
  ScrllText.Font.Assign(pnRule.Font);
  ScrllText.TimerInterval:=100;
  ScrllText.ParentColor:=true;
  ScrllText.ParentFont:=true;

  GlobalMemoryStatus(T);
  lbMemAll.Caption:=lbMemAll.Caption+' '+inttostr(round(T.dwTotalPhys/(1024)))+' KB';
  dMem:=T.dwTotalPhys-T.dwAvailPhys;
  Percent:=(dMem/T.dwTotalPhys)*100;
  lbMemUse.Caption:=lbMemUse.Caption+' '+FormatFloat('0',Percent)+' %';

  lbVer.Caption:=GetApplicationExeVersion;
  lbCorp.Caption:=CompanyName;
  lbTel.Caption:=CompanyTel;

  lbMain.Caption:=MainCaption;
  pnRule.Visible:=false;
  ImExe.Picture.Icon.Handle:=ExtractAssociatedIcon(Hinstance,Pchar(Application.ExeName),lpIcon);

  TCAM.Text:=PChar(GetUseLibsAndProgrammes);
  TCAM.TypeCreate:=tcLast;
  hAboutUseLibsAndProgrammers:=CreateAboutMarquee_(@TCAM);

  FillAboutMarquee;

  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmAbout.FormDestroy(Sender: TObject);
begin
  ScrllText.Free;
  StrScroll.Free;
  FreeAboutMarquee_(hAboutUseLibsAndProgrammers);
end;

procedure TfmAbout.ActiveScrollText(Text: String);
begin
  ScrllText.Active:=false;
  ScrllText.Items.Clear;
  ScrllText.Items.text:=Text;
  ScrllText.Active:=true;
  pnRule.Visible:=true;
end;

function TfmAbout.GetUseLibsAndProgrammes: String;
var
  i,j,val: Integer;
  P: PinfoLib;
  s: string;
  str: TStringList;
  str1: TStringList;
begin
  Result:='';
  if ListLibs.Count>0 then begin
   str:=TStringList.Create;
   str1:=TStringList.Create;
   try
     str.Duplicates:=dupIgnore;
     str.Sorted:=true;
     s:='������������:';
     for i:=0 to ListLibs.Count-1 do begin
      P:=ListLibs.Items[i];
      if Trim(P.Programmers)<>'' then begin
        str1.Text:=P.Programmers;
        for j:=0 to str1.Count-1 do begin
          val:=str.IndexOf(str1.Strings[j]);
          if val=-1 then
            str.Add(str1.Strings[j]);
        end;
      end;
     end;
     s:=s+#13+str.Text;
     s:=s+#13+'������������ ����������:';
     for i:=0 to ListLibs.Count-1 do begin
      P:=ListLibs.Items[i];
      if P.Active then
       s:=s+#13+P.ExeName;
     end;
     Result:=s;
   finally
     str1.Free;
     str.free;
   end;  
  end;
end;

procedure TfmAbout.FormShow(Sender: TObject);
begin
   ActiveScrollText(StrScroll.Text);
end;

procedure TfmAbout.lbMainDblClick(Sender: TObject);
begin
  TestSplash_;
end;

procedure fmAboutGetAboutMarqueeProc(Owner: Pointer; PGAM: PGetAboutMarquee); stdcall;
begin
  if not IsValidPointer(Owner) then exit;
  if not IsValidPointer(PGAM) then exit;
  TfmAbout(Owner).StrScroll.Add('');
  TfmAbout(Owner).StrScroll.Add(PGAM.Text);
end;

procedure TfmAbout.FillAboutMarquee;
begin
  StrScroll.BeginUpdate;
  try
    StrScroll.Clear;
    GetAboutMarquees_(Self,fmAboutGetAboutMarqueeProc);
  finally
    StrScroll.EndUpdate;
  end;  
end;

procedure TfmAbout.imEXEClick(Sender: TObject);
begin
  TestSplash_;
end;

end.