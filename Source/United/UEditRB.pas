unit UEditRB;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, IBQuery, db, IBServices, IBDatabase, UMainUnited,
  tsvDbGrid, DBCtrls;

type
  TfmEditRB = class(TForm,IAdditionalRBEditForm)
    pnBut: TPanel;
    Panel2: TPanel;
    bibOk: TButton;
    bibCancel: TButton;
    cbInString: TCheckBox;
    IBTran: TIBTransaction;
    bibClear: TButton;
    bibPrev: TButton;
    bibNext: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
  private
    FChangeFlag: Boolean;
    FEnabledAdjust: Boolean;
    FTypeEditRBook: TTypeEditRBook;
    NewLeft,NewTop,NewWidth,NewHeight: Integer;
    NewWindowState: TWindowState;
    procedure SetTypeEditRBook(Value: TTypeEditRBook);
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    function GetDefaultTabOrders: string;
  protected
    FInsertSQL: string;
    procedure LoadFromIni; dynamic;
    procedure SaveToIni;dynamic;
    procedure SetNewPosition;
    function AddToRBooks: Boolean; virtual;
    function UpdateRBooks: Boolean; virtual;
    function CheckFieldsFill: Boolean; virtual;
    function SetTabOrders: Boolean; virtual;
    function ClassName: string; reintroduce; dynamic;
    function GetTabOrdersName: string; dynamic;
  public

    procedure AddClick(Sender: TObject); virtual;
    procedure ChangeClick(Sender: TObject); virtual;
    procedure FilterClick(Sender: TObject); virtual;
    procedure PrevClick(Sender: TObject); virtual;
    procedure NextClick(Sender: TObject); virtual;
    property TypeEditRBook: TTypeEditRBook read FTypeEditRBook write SetTypeEditRBook;
    property InsertSQL: String read FInsertSQL;
    property ChangeFlag: Boolean read FChangeFlag write FChangeFlag;
    property EnabledAdjust: Boolean read FEnabledAdjust write FEnabledAdjust; 

  end;

var
  fmEditRB: TfmEditRB;

implementation

{$R *.DFM}

uses tsvTabOrder;

procedure TfmEditRB.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F2: bibPrev.Click;
    VK_F3: bibNext.Click;
    VK_F6: bibClear.Click;
    VK_F8: SetTabOrders;
  end;
  _MainFormKeyDown(Key,Shift);
end;

procedure TfmEditRB.FormKeyPress(Sender: TObject; var Key: Char);
begin
  _MainFormKeyPress(Key);
end;

procedure TfmEditRB.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyUp(Key,Shift);
end;


procedure TfmEditRB.FormCreate(Sender: TObject);
begin
  Caption:='';
  FTypeEditRBook:=terbNone;
  FEnabledAdjust:=false;
  AssignFont(_GetOptions.FormFont,Font);

  Left:=Screen.width div 2-Width div 2;
  Top:=Screen.Height div 2-Height div 2;
  NewLeft:=Left;
  NewTop:=Top;
  NewWidth:=Width;
  NewHeight:=Height;
  NewWindowState:=WindowState;

  bibPrev.Visible:=false;
  bibNext.Visible:=false;
end;

function TfmEditRB.AddToRBooks: Boolean;
begin
  Result:=false;
end;

function TfmEditRB.UpdateRBooks: Boolean;
begin
 Result:=false;
end;

function TfmEditRB.CheckFieldsFill: Boolean;
begin
 Result:=false;
end;

procedure TfmEditRB.AddClick(Sender: TObject);
begin
end;

procedure TfmEditRB.ChangeClick(Sender: TObject);
begin
end;

procedure TfmEditRB.FilterClick(Sender: TObject);
begin
end;

procedure TfmEditRB.bibClearClick(Sender: TObject);
begin
  ClearFields(Self);
end;

procedure TfmEditRB.PrevClick(Sender: TObject);
begin
end;

procedure TfmEditRB.NextClick(Sender: TObject);
begin
end;

procedure TfmEditRB.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.hint:='';
end;

procedure TfmEditRB.SetTypeEditRBook(Value: TTypeEditRBook);
begin
  If Value<>FTypeEditRBook then begin
    FTypeEditRBook:=Value;
    case FTypeEditRBook of
      terbNone: begin
        bibPrev.Visible:=false;
        bibNext.Visible:=false;
        bibClear.Visible:=false;
      end;
      terbAdd: begin
        bibOk.OnClick:=AddClick;
        Caption:=CaptionAdd;
        bibPrev.Visible:=false;
        bibNext.Visible:=false;
        bibClear.Visible:=false;
      end;
      terbChange: begin
        bibOk.OnClick:=ChangeClick;
        Caption:=CaptionChange;
        bibPrev.Visible:=true;
        bibNext.Visible:=true;
        bibClear.Visible:=false;
      end;
      terbView: begin
        bibOk.OnClick:=nil;
        bibOk.Visible:=false;
        bibCancel.Caption:=CaptionClose;
        Caption:=CaptionView;
        bibPrev.Visible:=true;
        bibNext.Visible:=true;
        bibClear.Visible:=false;
      end;
      terbFilter: begin
        bibOK.OnClick:=FilterClick;
        Caption:=CaptionFilter;
        cbInString.Visible:=true;
        bibClear.Visible:=true;
        bibPrev.Visible:=false;
        bibNext.Visible:=false;
      end;
    end;
  end;

  // Remove next
  bibPrev.Visible:=false;
  bibNext.Visible:=false;
end;

procedure TfmEditRB.LoadFromIni;

  procedure LoadFormProp;
  begin
    NewWindowState:=TWindowState(ReadParam(ClassName,'WindowState',Integer(WindowState)));
    if NewWindowState<>wsMaximized then begin
     NewLeft:=ReadParam(ClassName,'Left',Left);
     NewTop:=ReadParam(ClassName,'Top',Top);
     NewWidth:=ReadParam(ClassName,'Width',Width);
     NewHeight:=ReadParam(ClassName,'Height',Height);
    end;
  end;

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
      tmps:=HexStrToStr(ReadParam(ClassName,GetTabOrdersName,GetDefaultTabOrders));
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
  try
    LoadFormProp;
    if FEnabledAdjust then LoadTabOrders;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

function TfmEditRB.GetDefaultTabOrders: string;
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

procedure TfmEditRB.SaveToIni;

  procedure SaveFormProp;
  begin
    if FormState=[fsCreatedMDIChild] then begin
     WriteParam(ClassName,'Left',Left);
     WriteParam(ClassName,'Top',Top);
     WriteParam(ClassName,'Width',Width);
     WriteParam(ClassName,'Height',Height);
     WriteParam(ClassName,'WindowState',Integer(WindowState));
    end;
  end;

  procedure SaveTabOrders;
  begin
     WriteParam(ClassName,GetTabOrdersName,GetDefaultTabOrders);
  end;

begin
  try
    SaveFormProp;
    if FEnabledAdjust then SaveTabOrders;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmEditRB.SetNewPosition;
begin
  Left:=NewLeft;
  Top:=NewTop;
  Width:=NewWidth;
  Height:=NewHeight;
  WindowState:=NewWindowState;
end;

procedure TfmEditRB.CMShowingChanged(var Message: TMessage);
begin
  inherited;
{  if FormState=[fsCreatedMDIChild] then
   SetNewPosition;}
end;

procedure TfmEditRB.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  but: Integer;
begin
  if ModalResult=mrOk then exit;
  if ChangeFlag and (ModalResult=mrCancel) then begin
   case FTypeEditRBook of
     terbAdd: begin
       but:=ShowQuestionEx(ConstEditRbAddCloseQuery);
       CanClose:=(but=mrYes);
     end;
     terbChange: begin
       but:=ShowQuestionEx(ConstEditRbChangeCloseQuery);
       CanClose:=(but=mrYes);
     end;
   end;
  end;
end;

function TfmEditRB.SetTabOrders: Boolean;
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

function TfmEditRB.ClassName: string;
begin
  Result:=Inherited ClassName;
end;

function TfmEditRB.GetTabOrdersName: string;
begin
  Result:='TabOrders';
end;

procedure TfmEditRB.FormShow(Sender: TObject);
begin
  FChangeFlag:=false;
end;

end.
