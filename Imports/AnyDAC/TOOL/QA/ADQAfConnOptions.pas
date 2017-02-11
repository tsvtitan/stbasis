{-------------------------------------------------------------------------------}
{ AnyDAC QA connection options form                                             }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAfConnOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, daADGUIxFormsfOptsBase;

type
  TfrmConnOptions = class(TfrmADGUIxFormsOptsBase)
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    cbOracle: TComboBox;
    cbMSAccess: TComboBox;
    cbMySQL: TComboBox;
    cbMSSQL: TComboBox;
    cbDB2: TComboBox;
    cbASA: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConnOptions: TfrmConnOptions;

implementation

uses
  IniFiles,
  ADQAConst,
  daADStanUtil;

{$R *.dfm}

{-------------------------------------------------------------------------------}
{ TfrmConnOptions                                                               }
{-------------------------------------------------------------------------------}
procedure TfrmConnOptions.FormCreate(Sender: TObject);
var
  oIni:     TIniFile;
  oStrList: TStringList;
  i:        Integer;
begin
  oIni     := TIniFile.Create(ADExpandStr(CONN_DEF_STORAGE));
  oStrList := TStringList.Create;
  try
    oIni.ReadSections(oStrList);
    for i := 0 to oStrList.Count - 1 do begin
      if Pos('Orac', oStrList[i]) > 0 then begin
        cbOracle.Items.Add(oStrList[i]);
        if AnsiCompareText(oStrList[i], ORACLE_CONN) = 0 then
          cbOracle.ItemIndex := cbOracle.Items.Count -1;
      end;
      if Pos('MSSQL', oStrList[i]) > 0 then begin
        cbMSSQL.Items.Add(oStrList[i]);
        if AnsiCompareText(oStrList[i], MSSQL_CONN) = 0 then
          cbMSSQL.ItemIndex := cbMSSQL.Items.Count -1;
      end;
      if (Pos('MSAcc', oStrList[i]) > 0) or (Pos('Acc', oStrList[i]) > 0) then begin
        cbMSAccess.Items.Add(oStrList[i]);
        if AnsiCompareText(oStrList[i], MSACCESS_CONN) = 0 then
          cbMSAccess.ItemIndex := cbMSAccess.Items.Count -1;
      end;
      if Pos('MySQL', oStrList[i]) > 0 then begin
        cbMySQL.Items.Add(oStrList[i]);
        if AnsiCompareText(oStrList[i], MYSQL_CONN) = 0 then
          cbMySQL.ItemIndex := cbMySQL.Items.Count -1;
      end;
      if Pos('DB2', oStrList[i]) > 0 then begin
        cbDB2.Items.Add(oStrList[i]);
        if AnsiCompareText(oStrList[i], DB2_CONN) = 0 then
          cbDB2.ItemIndex := cbDB2.Items.Count -1;
      end;
      if Pos('ASA', oStrList[i]) > 0 then begin
        cbASA.Items.Add(oStrList[i]);
        if AnsiCompareText(oStrList[i], ASA_CONN) = 0 then
          cbASA.ItemIndex := cbDB2.Items.Count -1;
      end;
    end;
  finally
    oIni.Free;
    oStrList.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmConnOptions.btnOKClick(Sender: TObject);
begin
  ORACLE_CONN := cbOracle.Text;
  MSSQL_CONN := cbMSSQL.Text;
  MSACCESS_CONN := cbMSAccess.Text;
  MYSQL_CONN := cbMySQL.Text;
  DB2_CONN := cbDB2.Text;
  Close;
end;

procedure TfrmConnOptions.btnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
