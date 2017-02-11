unit UMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TfmMainForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    NewLeft,NewTop,NewWidth,NewHeight: Integer;
    NewWindowState: TWindowState;
    FEnabledAdjust: Boolean;
    procedure SetNewPosition;
    procedure WMSizing(var Message: TMessage); message WM_SIZING;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    function GetDefaultTabOrders: string;
  protected
    procedure ShowingChanged; dynamic;
    procedure LoadFromIniBySection(const Section: string); dynamic;
    procedure SaveToIniBySection(const Section: string); dynamic;
    procedure LoadFromIni; dynamic;
    procedure SaveToIni; dynamic;
    function ClassName: string; reintroduce; dynamic;
    function GetTabOrdersName: string; dynamic;
    function SetTabOrders: Boolean; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  public
    property EnabledAdjust: Boolean read FEnabledAdjust write FEnabledAdjust; 
  end;

var
  fmMainForm: TfmMainForm;

implementation

{$R *.DFM}

uses UMainUnited, tsvTabOrder;

procedure TfmMainForm.WMSizing(var Message: TMessage);
var
  NewHeight, NewWidth: Integer;
  R: PRect;
begin
    R := PRect(Message.LParam);
    NewHeight:=R.Bottom-R.Top;
    NewWidth:=R.Right-R.Left;

    if Constraints.MinHeight>0 then
     if NewHeight<=Constraints.MinHeight then
        NewHeight:=Constraints.MinHeight;

    if Constraints.MinWidth>0 then
     if NewWidth<=Constraints.MinWidth then
        NewWidth:=Constraints.MinWidth;

    if Constraints.MaxHeight>0 then
      if NewHeight>=Constraints.MaxHeight then
        NewHeight:=Constraints.MaxHeight;

    if Constraints.MaxWidth>0 then
      if NewWidth>=Constraints.MaxWidth then
        NewWidth:=Constraints.MaxWidth;

    if Message.WParam in [WMSZ_BOTTOM,WMSZ_BOTTOMRIGHT,WMSZ_BOTTOMLEFT] then begin
     R.Bottom := R.Top + NewHeight;
    end else begin
     R.Top := R.Bottom - NewHeight;
    end;

    if Message.WParam in [WMSZ_RIGHT,WMSZ_TOPRIGHT,WMSZ_BOTTOMRIGHT] then begin
     R.Right := R.Left + NewWidth;
    end else begin
     R.Left := R.Right - NewWidth;
    end;

end;

procedure TfmMainForm.CMShowingChanged(var Message: TMessage);
const
  ShowFlags: array[Boolean] of Word = (
    SWP_NOSIZE + SWP_NOMOVE + SWP_NOZORDER + SWP_NOACTIVATE + SWP_HIDEWINDOW,
    SWP_NOSIZE + SWP_NOMOVE + SWP_NOZORDER + SWP_NOACTIVATE + SWP_SHOWWINDOW);
const
  ShowCommands: array[TWindowState] of Integer =
    (SW_SHOWNORMAL, SW_SHOWMINNOACTIVE, SW_SHOWMAXIMIZED);
begin
  if FormState=[fsCreatedMDIChild] then begin
   if WindowState = wsMaximized then begin
      SendMessage(Application.MainForm.ClientHandle, WM_MDIRESTORE, Handle, 0);
      ShowWindow(Handle, SW_SHOWMAXIMIZED);
   end else begin
      ShowWindow(Handle, ShowCommands[WindowState]);
      CallWindowProc(@DefMDIChildProc,Handle,WM_SIZE,SIZE_RESTORED,Width or (Height shl 16));
      BringToFront;
   end;
   SetWindowPos(Handle, 0, Left,Top,Width,Height, ShowFlags[true]);
   ShowingChanged;
   SendMessage(Application.MainForm.ClientHandle,WM_MDIREFRESHMENU, 0, 0);
  end else
   inherited;
end;

procedure TfmMainForm.SetNewPosition;
begin
  Left:=NewLeft;
  Top:=NewTop;
  Width:=NewWidth;
  Height:=NewHeight;
  WindowState:=NewWindowState;
end;

procedure TfmMainForm.ShowingChanged;
begin
end;

procedure TfmMainForm.FormCreate(Sender: TObject);
begin
  AssignFont(_GetOptions.FormFont,Font);
  Left:=0;
  Top:=0;
  NewLeft:=Left;
  NewTop:=Top;
  NewWidth:=Width;
  NewHeight:=Height;
  NewWindowState:=WindowState;
  FEnabledAdjust:=false;
end;

procedure TfmMainForm.LoadFromIniBySection(const Section: string);

  procedure LoadTabOrders;
  var
    tmps: string;
    ms: TMemoryStream;
    rd: TReader;
    NCount,i: Integer;
    sname: string;
    ct: TComponent;
    staborder: Integer;
    stabstop: Boolean;
  begin
    ms:=TMemoryStream.Create;
    try
      tmps:=HexStrToStr(ReadParam(Section,GetTabOrdersName,GetDefaultTabOrders));
      ms.SetSize(Length(tmps));
      Move(Pointer(tmps)^,ms.Memory^,ms.Size);
      rd:=TReader.Create(ms,4096);
      try
        NCount:=rd.ReadInteger;
        for i:=0 to NCount-1 do begin
          sname:=rd.ReadString;
          staborder:=rd.ReadInteger;
          stabstop:=rd.ReadBoolean;
          ct:=FindComponent(sname);
          if ct<>nil then
            if ct is TWinControl then begin
              TWinControl(ct).TabOrder:=staborder;
              TWinControl(ct).TabStop:=stabstop;
            end; 
        end;
      finally
        rd.Free;
      end;
    finally
      ms.Free;
    end;
  end;
  
begin
  NewWindowState:=TWindowState(ReadParam(Section,'WindowState',Integer(WindowState)));
  if NewWindowState<>wsMaximized then begin
   NewLeft:=ReadParam(Section,'Left',Left);
   NewTop:=ReadParam(Section,'Top',Top);
   NewWidth:=ReadParam(Section,'Width',Width);
   NewHeight:=ReadParam(Section,'Height',Height);
  end;
  SetNewPosition;
  if FEnabledAdjust then LoadTabOrders;
end;

procedure TfmMainForm.SaveToIniBySection(const Section: string);

  procedure SaveTabOrders;
  begin
     WriteParam(Section,GetTabOrdersName,GetDefaultTabOrders);
  end;

begin
  if FormState=[fsCreatedMDIChild] then begin
   WriteParam(Section,'Left',Left);
   if WindowState<>wsMinimized then
    WriteParam(Section,'Top',Top);
   WriteParam(Section,'WindowState',Integer(WindowState));
  end;
  WriteParam(Section,'Width',Width);
  WriteParam(Section,'Height',Height);
  if FEnabledAdjust then SaveTabOrders;
end;

procedure TfmMainForm.LoadFromIni;
begin
  LoadFromIniBySection(ClassName);
end;

procedure TfmMainForm.SaveToIni;
begin
  SaveToIniBySection(ClassName);
end;

procedure TfmMainForm.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F8: SetTabOrders;
  end;
  _MainFormKeyDown(Key,Shift);
  inherited;
end;

procedure TfmMainForm.KeyUp(var Key: Word; Shift: TShiftState);
begin
  _MainFormKeyUp(Key,Shift);
  inherited;
end;

procedure TfmMainForm.KeyPress(var Key: Char);
begin
  _MainFormKeyPress(Key);
  inherited;
end;

procedure TfmMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ///
end;

procedure TfmMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 //
end;

procedure TfmMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //
end;

procedure TfmMainForm.FormDestroy(Sender: TObject);
begin
  SaveToIni;
end;

procedure TfmMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  Application.Hint:='';
end;

function TfmMainForm.ClassName: string;
begin
  Result:=Inherited ClassName;
end;

function TfmMainForm.GetTabOrdersName: string;
begin
  Result:='TabOrders';
end;

function TfmMainForm.GetDefaultTabOrders: string;
var
  tmps: string;
  ms: TMemoryStream;
  wr: TWriter;
  i: Integer;
  List: TList;
begin
  ms:=TMemoryStream.Create;
  List:=TList.Create;
  try
    wr:=TWriter.Create(ms,4096);
    try
      Self.GetTabOrderList(List);
      wr.WriteInteger(List.Count);
      for i:=0 to List.Count-1 do begin
        wr.WriteString(TControl(List.Items[i]).Name);
        wr.WriteInteger(TWinControl(TControl(List.Items[i])).TabOrder);
        wr.WriteBoolean(TWinControl(TControl(List.Items[i])).TabStop);
      end;
    finally
      wr.Free;
    end;
    SetLength(tmps,ms.Size);
    Move(ms.Memory^,Pointer(tmps)^,ms.Size);
    Result:=StrToHexStr(tmps);
  finally
    List.Free;
    ms.Free;
  end;
end;

function TfmMainForm.SetTabOrders: Boolean;
var
  fm: TfmTabOrder;
begin
  Result:=false;
  if not FEnabledAdjust then exit;
  fm:=TfmTabOrder.Create(nil);
  try
    fm.InitTabOrder(Self);
    if fm.ShowModal=mrOk then begin
      fm.BackUpTabOrder;
      Result:=true;
    end;
  finally
    fm.free;
  end;
end;


end.
