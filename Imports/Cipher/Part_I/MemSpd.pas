{ Copyright (c) 1999 by Hagen Reddmann
  mailto:HaReddmann@AOL.COM
  
  This Unit performs various Speed Test for TCipher and THash Descends.
  Speed was testet for Memory Operation and File Operation} 

unit MemSpd;

interface

{$I VER.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, DECUtil, Cipher, Hash, ComCtrls;

const
  cm_Summary = wm_User + 1;

type
  TSpeedForm = class(TForm)
    P: TPanel;
    MainMenu: TMainMenu;
    MItemExit: TMenuItem;
    Box: TScrollBox;
    SaveDialog: TSaveDialog;
    Status: TPanel;
    MItemSave: TMenuItem;
    StatusFile: TPanel;
    procedure MItemExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MItemSaveClick(Sender: TObject);
  private
    FThread: TThread;
    FLabel: array[-1..63, 0..4] of TLabel;
    FChecked: array[0..63] of Boolean;
    FMode: TCipherMode;
    FIsHash: Boolean;
    FInMemory: Boolean;
    procedure CMSummay(var Msg: TMessage); message cm_Summary;
    procedure CheckClick(Sender: TObject);
  public
    procedure Execute(InMemory, IsHash: Boolean; Mode: TCipherMode);
  end;

var
  SpeedForm: TSpeedForm;

implementation

uses HCMngr, Consts, RNG;

{$R *.DFM}
const
  MaxComp =  9223372036854775807.0;

type
  PSummary = ^TSummary;
  TSummary = packed record
               Time1: array[0..63] of Comp;
               Time2: array[0..63] of Comp;
               Sizes: Comp;
               FullTime: Double;
               Counts: Integer;
               Index: Integer;
               Freq: Comp;
               Info: String;
             end;


  TSpeedThread = class(TThread)
  private
    FOwner: TSpeedForm;
  public
    constructor Create(AOwner: TSpeedForm);
  end;

  THashMemThread = class(TSpeedThread)
  protected
    procedure Execute; override;
  end;

  TCipherMemThread = class(TSpeedThread)
  private
    FMode: TCipherMode;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TSpeedForm; AMode: TCipherMode);
  end;

  THashFileThread = class(TSpeedThread)
  private
  protected
    procedure Execute; override;
  end;

  TCipherFileThread = class(TCipherMemThread)
  protected
    procedure Execute; override;
  end;

constructor TSpeedThread.Create(AOwner: TSpeedForm);
begin
  inherited Create(True);
  FOwner := AOwner;
  Priority := tpNormal;
  FreeOnTerminate := True;
  Resume;
end;

procedure THashMemThread.Execute;
const
  MemSize = 1024 * 32;
var
  Memory: Pointer;
  Start, Stop, First: Comp;
  Sum: TSummary;
  Wnd: hWnd;
  List: TStringList;
begin
  Wnd := FOwner.Handle;
  FillChar(Sum, SizeOf(Sum), 0);
  Sum.Freq := PerfFreq;
  First := PerfCounter;
  Sum.Sizes := MemSize;
  Sum.Counts := 1;
  Memory := AllocMem(MemSize);
  RND.Buffer(Memory^, MemSize);
  List := TStringList.Create;
  List.Assign(HashList);
  try
    while not Terminated do
    try
      if (FOwner <> nil) and FOwner.FChecked[Sum.Index] then
      begin
        Start := PerfCounter;
        THashClass(List.Objects[Sum.Index]).CalcBuffer(Memory^, MemSize, nil, fmtNONE);
        Stop := PerfCounter;
        Sum.Time1[Sum.Index] := Sum.Time1[Sum.Index] + Stop - Start;
        Sum.FullTime := (Stop - First) / Sum.Freq;
        SendMessage(Wnd, cm_Summary, 0, Integer(@Sum));
      end else
      begin
//calculate hypothetic
        Sum.Time1[Sum.Index] := Round(Sum.Time1[Sum.Index] + Sum.Time1[Sum.Index] / Sum.Counts);
      end;
      Inc(Sum.Index);
      if Sum.Index >= List.Count then
      begin
        if (Sum.Sizes > MaxComp - MemSize) or
           (Sum.Counts = Maxint) then Break;
        Inc(Sum.Counts);
        Sum.Sizes := Sum.Sizes + MemSize;
        Sum.Index := 0;
        Sleep(1);
      end;
    except
      Break;
    end;
  finally
    ReallocMem(Memory, 0);
    if FOwner <> nil then FOwner.FThread := nil;
    List.Free;
  end;
end;

constructor TCipherMemThread.Create(AOwner: TSpeedForm; AMode: TCipherMode);
begin
  FMode := AMode;
  inherited Create(AOwner);
end;

procedure TCipherMemThread.Execute;
const
  MemSize = 1024;
var
  Memory: Pointer;
  Start, Stop, First: Comp;
  Sum: TSummary;
  Wnd: hWnd;
  Cipher: TCipher;
  List: TStringList;
begin
  Wnd := FOwner.Handle;
  FillChar(Sum, SizeOf(Sum), 0);
  Sum.Freq := PerfFreq;
  First := PerfCounter;
  Sum.Counts := 1;
  Sum.Sizes := MemSize * Sum.Counts;
  Memory := AllocMem(MemSize);
  RND.Buffer(Memory^, MemSize);
  List := TStringList.Create;
  List.Assign(CipherList);
  try
    while not Terminated do
    try
      if (FOwner <> nil) and FOwner.FChecked[Sum.Index] then
      begin
        Cipher := TCipherClass(List.Objects[Sum.Index]).Create('', nil);
        try
          Cipher.Mode := FMode;
          Cipher.Init('Test', 4, nil);

          Start := PerfCounter;
          Cipher.EncodeBuffer(Memory^, Memory^, MemSize);
          Stop := PerfCounter;

          Sum.Time1[Sum.Index] := Sum.Time1[Sum.Index] + (Stop - Start);

          Cipher.Init('Test', 4, nil);

          Start := PerfCounter;
          Cipher.DecodeBuffer(Memory^, Memory^, MemSize);
          Stop := PerfCounter;

          Sum.Time2[Sum.Index] := Sum.Time2[Sum.Index] + (Stop - Start);

        finally
          Cipher.Free;
        end;
        Sum.FullTime := (Stop - First) / Sum.Freq;
        SendMessage(Wnd, cm_Summary, 0, Integer(@Sum));
      end else
      begin
//calculate hypothetic
        Sum.Time1[Sum.Index] := Round(Sum.Time1[Sum.Index] + Sum.Time1[Sum.Index] / Sum.Counts);
        Sum.Time2[Sum.Index] := Round(Sum.Time2[Sum.Index] + Sum.Time2[Sum.Index] / Sum.Counts);
      end;
      Inc(Sum.Index);
      if Sum.Index >= List.Count then
      begin
        if (Sum.Sizes > MaxComp - MemSize) or
           (Sum.Counts = Maxint) then Break;
        Inc(Sum.Counts);
        Sum.Sizes := Sum.Sizes + MemSize;
        Sum.Index := 0;
        Sleep(1);
      end;
    except
      Break;
    end;
  finally
    ReallocMem(Memory, 0);
    if FOwner <> nil then FOwner.FThread := nil;
    List.Free;
  end;
end;

procedure THashFileThread.Execute;
var
  List: TStringList;
  First: Comp;
  Sum: TSummary;
  Wnd: hWnd;

  procedure TestFile(const Path: String; SR: TSearchRec);
  var
    Start, Stop: Comp;
    M: TStream;
    B: Byte;
    H: THashClass;
  begin
    Sum.Index := 0;
    if (Sum.Sizes < MaxComp - SR.Size) and
       (Sum.Counts < MaxInt) then
    begin
{this checks File Read and load's in Cache}
      try
        M := TFileStream.Create(Path + SR.Name, fmOpenRead or fmShareDenyNone);
        try
          while (M.Position < M.Size) and not Terminated do
          begin
            M.Read(B, 1);
            M.Position := M.Position + 1024;
          end;
        finally
          M.Free;
        end;
      except
        Exit;
      end;
      Inc(Sum.Counts);
      Sum.Sizes := Sum.Sizes + SR.Size;
      Sum.Info := Path + SR.Name;
    end else Terminate;
    while not Terminated and (Sum.Index < List.Count) do
    try
      if (FOwner <> nil) and FOwner.FChecked[Sum.Index] then
      begin
        H := THashClass(List.Objects[Sum.Index]);
        Start := PerfCounter;
        H.CalcFile(Path + SR.Name, nil, fmtNONE);
        Stop := PerfCounter;
        Sum.Time1[Sum.Index] := Sum.Time1[Sum.Index] + Stop - Start;
        Sum.FullTime := (Stop - First) / Sum.Freq;
        SendMessage(Wnd, cm_Summary, 0, Integer(@Sum));
      end else
      begin
//calculate hypothetic
        Sum.Time1[Sum.Index] := Round(Sum.Time1[Sum.Index] + Sum.Time1[Sum.Index] / Sum.Sizes * SR.Size);
      end;
      Inc(Sum.Index);
    except
      Dec(Sum.Counts);
      Sum.Sizes := Sum.Sizes - SR.Size;
      Break;
    end;
  end;

  procedure Scan(const Path: String);
  var
    SR: TSearchRec;
  begin
    if not Terminated and (FindFirst(Path + '*.*', faAnyFile, SR) = 0) then
    repeat
      if (SR.Name <> '') and (SR.Name <> '.') and (SR.Name <> '..') then
        if SR.Attr and faDirectory <> 0 then Scan(Path + SR.Name + '\') else
          if SR.Attr and (faDirectory or faVolumeID) = 0 then TestFile(Path, SR);
      Sleep(1);
    until Terminated or (FindNext(SR) <> 0);
    FindClose(SR);
  end;

var
  Drive: String;
begin
  Wnd := FOwner.Handle;
  FillChar(Sum, SizeOf(Sum), 0);
  Sum.Freq := PerfFreq;
  First := PerfCounter;
  Drive := 'A:\';
  List := TStringList.Create;
  List.Assign(HashList);
  try
    while not Terminated and (Drive[1] <= 'Z') do
    try
      if GetDriveType(PChar(Drive)) = DRIVE_FIXED then Scan(Drive);
      Inc(Drive[1]);
    except
      Break;
    end;
  finally
    List.Free;
  end;
end;

procedure TCipherFileThread.Execute;
var
  List: TStringList;
  First: Comp;
  Sum: TSummary;
  Wnd: hWnd;

  procedure TestFile(const Path: String; SR: TSearchRec);
  const
    Key: array[0..15] of Byte = ($00,$11,$22,$33,$44,$55,$66,$77,
                                 $88,$99,$AA,$BB,$CC,$DD,$EE,$FF);
  var
    Start, Stop: Comp;
    M: TStream;
    B: Byte;
    Cipher: TCipher;
    S: String;
  begin
    Sum.Index := 0;
    if (Sum.Sizes < MaxComp - SR.Size) and
       (Sum.Counts < MaxInt) then
    begin
{this checks File Read and load's in Cache}
      try
        M := TFileStream.Create(Path + SR.Name, fmOpenRead or fmShareDenyNone);
        try
          while (M.Position < M.Size) and not Terminated do
          begin
            M.Read(B, 1);
            M.Position := M.Position + 1024;
          end;
        finally
          M.Free;
        end;
      except
        Exit;
      end;
      Inc(Sum.Counts);
      Sum.Sizes := Sum.Sizes + SR.Size;
      Sum.Info := Path + SR.Name;
      S := ChangeFileExt(ParamStr(0), '.TST');
    end else Terminate;
    while not Terminated and (Sum.Index < List.Count) do
    try
      if (FOwner <> nil) and FOwner.FChecked[Sum.Index] then
      begin
        Cipher := TCipherClass(List.Objects[Sum.Index]).Create('', nil);
        try
          Cipher.Mode := FMode;
          Start := PerfCounter;
          Cipher.Init(Key, SizeOf(Key), nil);
          Cipher.EncodeFile(Path + SR.Name, S);
          Stop := PerfCounter;
          Sum.Time1[Sum.Index] := Sum.Time1[Sum.Index] + Stop - Start;
          Start := PerfCounter;
          Cipher.Init(Key, SizeOf(Key), nil);
          Cipher.DecodeFile(S, S);
          Stop := PerfCounter;
          Sum.Time2[Sum.Index] := Sum.Time2[Sum.Index] + Stop - Start;
        finally
          Cipher.Free;
        end;
        Sum.FullTime := (Stop - First) / Sum.Freq;
        SendMessage(Wnd, cm_Summary, 0, Integer(@Sum));
      end else
      begin
//calculate hypothetic
        Sum.Time1[Sum.Index] := Round(Sum.Time1[Sum.Index] + Sum.Time1[Sum.Index] / Sum.Sizes * SR.Size);
        Sum.Time2[Sum.Index] := Round(Sum.Time2[Sum.Index] + Sum.Time2[Sum.Index] / Sum.Sizes * SR.Size);
      end;
      Inc(Sum.Index);
    except
      Dec(Sum.Counts);
      Sum.Sizes := Sum.Sizes - SR.Size;
      Break;
    end;
  end;

  procedure Scan(const Path: String);
  var
    SR: TSearchRec;
  begin
    if not Terminated and (FindFirst(Path + '*.*', faAnyFile, SR) = 0) then
    repeat
      if (SR.Name <> '') and (SR.Name <> '.') and (SR.Name <> '..') then
        if SR.Attr and faDirectory <> 0 then Scan(Path + SR.Name + '\') else
          if SR.Attr and (faDirectory or faVolumeID) = 0 then TestFile(Path, SR);
      Sleep(1);
    until Terminated or (FindNext(SR) <> 0);
    FindClose(SR);
  end;

var
  Drive: String;
begin
  Wnd := FOwner.Handle;
  FillChar(Sum, SizeOf(Sum), 0);
  Sum.Freq := PerfFreq;
  First := PerfCounter;
  Drive := 'A:\';
  List := TStringList.Create;
  List.Assign(CipherList);
  try
    while not Terminated and (Drive[1] <= 'Z') do
    try
      if GetDriveType(PChar(Drive)) = DRIVE_FIXED then Scan(Drive);
      Inc(Drive[1]);
    except
      Break;
    end;
  finally
    List.Free;
  end;
end;

procedure TSpeedForm.MItemExitClick(Sender: TObject);
begin
  Close;
end;

procedure TSpeedForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if FThread <> nil then
  begin
    TSpeedThread(FThread).FOwner := nil;
    FThread.Terminate;
  end;
end;

procedure TSpeedForm.CheckClick(Sender: TObject);
begin
  with TCheckBox(Sender) do
  begin
    FChecked[Tag] := Checked;
    FLabel[Tag, 1].Caption := '';
    FLabel[Tag, 2].Caption := '';
    FLabel[Tag, 3].Caption := '';
    FLabel[Tag, 4].Caption := '';
  end;
end;

procedure TSpeedForm.Execute(InMemory, IsHash: Boolean; Mode: TCipherMode);
const
  sWho: array[Boolean] of String = ('File', 'Memory');
  sWhat: array[Boolean] of String = ('Cipher', 'Hash');
  sMode: array[TCipherMode] of String = ('cmCTS', 'cmCBC', 'cmCFB', 'cmOFB', 'cmECB', 'cmCTSMAC', 'cmCBCMAC', 'cmCFBMAC');
  LabelHeight = 13;

var                    
  I,T: Integer;
  L: TStringList;
begin
  L := nil;
  if not Visible then
  try
    FMode := Mode;
    FIsHash := IsHash;
    FInMemory := InMemory;
    Caption := sWho[InMemory] + Caption + sWhat[IsHash];
    if not IsHash then
      Caption := Caption + ' in Mode: ' + sMode[FMode];
    L := TStringList.Create;
    if IsHash then L.Assign(HashList)
      else L.Assign(CipherList);
    T := 0;
    for I := -1 to L.Count-1 do
    begin
      if I >= 0 then
      begin
        FLabel[I, 0] := TLabel(TCheckBox.Create(Self));
        with TCheckBox(FLabel[I, 0]) do
        begin
          Checked := True;
          Parent := Box;
          Height := LabelHeight;
          Top := T;
          Left := 0;
          Width := 150;
          Caption := L.Names[I];
          Tag := I;
          FChecked[I] := True;
          OnClick := CheckClick;
        end;
      end else
      begin
        FLabel[I, 0] := TLabel.Create(Self);
        with FLabel[I, 0] do
        begin
          Parent := Box;
          AutoSize := False;
          Height := LabelHeight;
          Top := T;
          Left := 0;
          Width := 150;
          Caption := 'Algorithm';
          Font.Color := clMaroon;
        end;
      end;
      FLabel[I, 1] := TLabel.Create(Self);
      with FLabel[I, 1] do
      begin
        Parent := Box;
        AutoSize := False;
        Alignment := taRightJustify;
        Height := LabelHeight;
        Top := T;
        Left  := 150;
        Width :=  80;
        if I = -1 then
        begin
          Caption := 'Consum in sec';
          Font.Color := clMaroon;
        end;
      end;
      FLabel[I, 2] := TLabel.Create(Self);
      with FLabel[I, 2] do
      begin
        Parent := Box;
        AutoSize := False;
        Alignment := taRightJustify;
        Height := LabelHeight;
        Top := T;
        Left  := 230;
        Width :=  80;
        if I = -1 then
        begin
          if IsHash then Caption := 'Mb/sec'
            else Caption := 'Encode Mb/sec';
          Font.Color := clMaroon;
        end;
      end;
      FLabel[I, 3] := TLabel.Create(Self);
      with FLabel[I, 3] do
      begin
        Parent := Box;
        AutoSize := False;
        Alignment := taRightJustify;
        Height := LabelHeight;
        Top := T;
        Left  := 310;
        Width :=  80;
        if I = -1 then
        begin
          if IsHash then Caption := 'Duplicates'
            else Caption := 'Decode Mb/sec';
          Font.Color := clMaroon;
        end;
      end;
      FLabel[I, 4] := TLabel.Create(Self);
      with FLabel[I, 4] do
      begin
        Parent := Box;
        AutoSize := False;
        Alignment := taRightJustify;
        Height := LabelHeight;
        Top := T;
        Left  := 390;
        Width :=  80;
        if I = -1 then
        begin
          Caption := 'Ø Mb/sec';
          Font.Color := clMaroon;
        end;
      end;
      Inc(T, LabelHeight);
    end;
    Inc(T, Status.Height + 14);
    if not InMemory then Inc(T, StatusFile.Height);
    ClientHeight := T;
    if IsHash then ClientWidth := 310 + 14
      else ClientWidth := 470 + 14;
    Show;
  finally
    L.Free;
  end;
  if FThread <> nil then
  begin
    FThread.Terminate;
    FThread.WaitFor;
  end;
  StatusFile.Visible := not InMemory;
  if InMemory then
    if IsHash then FThread := THashMemThread.Create(Self)
      else FThread := TCipherMemThread.Create(Self, FMode)
  else
    if IsHash then FThread := THashFileThread.Create(Self)
      else FThread := TCipherFileThread.Create(Self, FMode);
end;

procedure TSpeedForm.CMSummay(var Msg: TMessage);
var
  T1,T2,S: Double;
begin
  with PSummary(Msg.lParam)^ do
  try
    if not FChecked[Index] then
    begin
      FLabel[Index, 1].Caption := '';
      FLabel[Index, 2].Caption := '';
      FLabel[Index, 3].Caption := '';
      FLabel[Index, 4].Caption := '';
      Exit;
    end;
    T1 := Time1[Index] / Freq;
    if not FIsHash then T2 := Time2[Index] / Freq else T2 := 0;
    S  := (Sizes / Counts) / (1024 * 1024);
    FLabel[Index, 1].Caption := FormatFloat('#,###0.000', T1 + T2);

    T1 := 1 / (T1 / Counts);
    FLabel[Index, 2].Caption := FormatFloat('#,##0.00', T1 * S);

    if not FIsHash then
    begin
      T2 := 1 / (T2 / Counts);
      FLabel[Index, 3].Caption := FormatFloat('#,##0.00', T2 * S);
      FLabel[Index, 4].Caption := FormatFloat('#,###0.000', (T1 + T2) * S / 2);
    end else
      if not FInMemory then
        FLabel[Index, 3].Caption := FormatFloat('#0', Time2[Index]);

    Status.Caption := Format('Iterations: %d, ', [Counts]) +
                      FormatFloat('Elapsed Time: #0 sec  ', FullTime);
    StatusFile.Caption := Info;
  except
  end;
end;

procedure TSpeedForm.MItemSaveClick(Sender: TObject);

  function FixLen(const S: String; Len: Integer): String;
  begin
    Result := S;
    if Len < 0 then
    begin
      Len := -Len;
      while Length(Result) < Len do Result := Result + ' ';
    end else
      while Length(Result) < Len do Result := ' ' + Result;
  end;
  
var
  S: String;
  I: Integer;
begin
  SaveDialog.InitialDir := ExtractFilePath(SaveDialog.Filename);
  if SaveDialog.InitialDir = '' then
    SaveDialog.InitialDir := ExtractFilePath(ParamStr(0));
  if SaveDialog.Execute then
    with TFileStream.Create(SaveDialog.FileName, fmCreate) do
    try
      S := Caption + #13#10#13#10;
      Write(PChar(S)^, Length(S));
      for I := -1 to 63 do
        if FLabel[I, 0].Caption <> '' then
        begin
          S := FixLen(TCheckBox(FLabel[I, 0]).Caption, -30) +
                      FixLen(FLabel[I, 2].Caption, 14);
          if not FIsHash then
            S := S + FixLen(FLabel[I, 3].Caption, 14) +
                     FixLen(FLabel[I, 4].Caption, 14);
          S := S + #13#10;
          Write(PChar(S)^, Length(S));
          if I < 0 then Write(#13#10, 2);
        end else Break;
    finally
      Free;
    end;
end;

end.
