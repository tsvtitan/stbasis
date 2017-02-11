unit Main;

interface

uses
  {$IFDEF Linux}
  QGraphics, QControls, QForms, QStdCtrls, QExtCtrls,
  {$ELSE}
  Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  {$ENDIF}
  Classes,
  IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  SysUtils;

type
  TformMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    memoInput: TMemo;
    lboxResults: TListBox;
    Panel3: TPanel;
    butnLookup: TButton;
    butnClear: TButton;
    Label1: TLabel;
    Client: TIdTCPClient;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure butnClearClick(Sender: TObject);
    procedure butnLookupClick(Sender: TObject);
  private
  public
  end;

var
  formMain: TformMain;

implementation
{$R *.dfm}

procedure TformMain.butnClearClick(Sender: TObject);
begin
  memoInput.Clear;
  lboxResults.Clear;
end;

procedure TformMain.butnLookupClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  butnLookup.Enabled := true; try
    lboxResults.Clear;
    with Client do begin
      Connect; try
        // Read the welcome message
        lboxResults.Items.Add(ReadLn);
        // Submit each zip code and read the result
        for i := 0 to memoInput.Lines.Count - 1 do begin
          WriteLn('ZipCode ' + memoInput.Lines[i]);
          lboxResults.Items.Add(memoInput.Lines[i]);

          s := ReadLn;
          if Length(s) = 0 then begin
            s := '-- No entry found for this zip code.';
          end;
          lboxResults.Items.Add(s);
          lboxResults.Items.Add('');
        end;
        WriteLn('Quit');
      finally Disconnect; end;
    end;
  finally butnLookup.Enabled := True; end;
end;

end.
