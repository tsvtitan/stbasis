unit Main;

interface

uses
  {$IFDEF Linux}
  QForms, QControls, QGraphics, QStdCtrls, QExtCtrls, QDialogs,
  {$ELSE}
  Forms, Controls, Graphics, StdCtrls, ExtCtrls, Dialogs,
  {$ENDIF}
  SysUtils, Classes;

type
  TformMain = class(TForm)
    memoMsg: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    editFrom: TEdit;
    Label2: TLabel;
    editTo: TEdit;
    Label3: TLabel;
    editSubject: TEdit;
    Label4: TLabel;
    editSMTPServer: TEdit;
    butnSendMail: TButton;
    procedure butnSendMailClick(Sender: TObject);
  private
    procedure ThreadTerminated(ASender: TObject);
  public
  end;

var
  formMain: TformMain;

implementation
{$R *.dfm}

uses
  IdThread,
  SMTPThread;

procedure TformMain.butnSendMailClick(Sender: TObject);
begin
  butnSendMail.Enabled := False;
  with TSMTPThread.Create do begin
    FreeOnTerminate := True;
    OnTerminate := ThreadTerminated;
    FFrom := Trim(editFrom.Text);
    FMessage := memoMsg.Lines.Text;
    FRecipient := Trim(editTo.Text);
    FSMTPServer := Trim(editSMTPServer.Text);
    FSubject := Trim(editSubject.Text);
    Start;
  end;
end;

procedure TformMain.ThreadTerminated(ASender: TObject);
var
  s: string;
begin
  s := TIdThread(ASender).TerminatingException;
  if Length(s) > 0 then begin
    ShowMessage('An error occurred while sending message. ' + s); 
  end else begin
    ShowMessage('Message sent!');
  end;
  butnSendMail.Enabled := True;
end;

end.
