unit UEditRBAPFieldView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRBAP, IBDatabase, ComCtrls, StdCtrls, ExtCtrls, tsvStdCtrls;

type
  TfmEditRBAPFieldView = class(TfmEditRBAP)
    meFields: TMemo;
    lbFields: TLabel;
    meCondition: TMemo;
    lbCondition: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    function CheckFieldsFill: Boolean; override;
  public
    procedure InitUpdate; override;
    procedure InitView; override;
    procedure InitFilter; override;
    procedure DoneFilter; override;
    function GetAddSql: String; override;
    function GetUpdateSql: String; override;
    procedure CacheUpdate; override;
    { Public declarations }
  end;

var
  fmEditRBAPFieldView: TfmEditRBAPFieldView;

implementation

uses UMainUnited, URBAP, URBAPFieldView;

{$R *.DFM}

procedure TfmEditRBAPFieldView.InitUpdate;
begin
  inherited InitUpdate;
  with TfmRBAP(ParentForm) do begin
    meFields.Lines.Text:=Mainqr.FieldByName('FIELDS').AsString;
    meCondition.Lines.Text:=Mainqr.FieldByName('CONDITION').AsString;
  end;  
end;

procedure TfmEditRBAPFieldView.InitView;
begin
  inherited InitView;
  with TfmRBAP(ParentForm) do begin
    meFields.Lines.Text:=Mainqr.FieldByName('FIELDS').AsString;
    meCondition.Lines.Text:=Mainqr.FieldByName('CONDITION').AsString;
  end;  
end;

procedure TfmEditRBAPFieldView.InitFilter;
begin
  inherited InitFilter;
  lbCondition.Enabled:=false;
  meCondition.Enabled:=false;
  meCondition.Color:=clBtnFace;
  with TfmRBAPFieldView(ParentForm) do
    meFields.Lines.Text:=Filters.Items[IndexFindFields].Value;
end;

procedure TfmEditRBAPFieldView.DoneFilter;
begin
  inherited DoneFilter;
  lbCondition.Enabled:=true;
  meCondition.Enabled:=true;
  meCondition.Color:=clWindow;
  with TfmRBAPFieldView(ParentForm) do begin
    Filters.Items[IndexFindFields].Value:=Trim(meFields.Lines.Text);
    Filters.Items[IndexFindFields].Enabled:=Trim(meFields.Lines.Text)<>'';
  end;
end;

function TfmEditRBAPFieldView.GetAddSql: String;
begin
  Result:='INSERT INTO '+TfmRBAP(ParentForm).TableName+
          ' ('+TfmRBAP(ParentForm).FieldKeyName+',NAME,FULLNAME,VARIANT,PRIORITY,FIELDS,CONDITION) VALUES '+
          ' ('+inttostr(OldFieldKeyValue)+
          ','+QuotedStr(Trim(edName.Text))+
          ','+QuotedStr(Trim(edFullName.Text))+
          ','+QuotedStr(Trim(meVariant.Lines.Text))+
          ','+inttostr(udPriority.Position)+
          ','+QuotedStr(Trim(meFields.Lines.Text))+
          ','+QuotedStr(Trim(meCondition.Lines.Text))+')';
end;

procedure TfmEditRBAPFieldView.CacheUpdate;
begin
  inherited CacheUpdate;
  with TfmRBAP(ParentForm) do begin
    MainQr.FieldByName('FIELDS').AsString:=Trim(meFields.Lines.Text);
    MainQr.FieldByName('CONDITION').AsString:=Trim(meCondition.Lines.Text);
  end;
end;

function TfmEditRBAPFieldView.GetUpdateSql: String;
begin
  Result:='UPDATE '+TfmRBAP(ParentForm).TableName+
          ' SET NAME='+QuotedStr(Trim(edName.text))+
          ', FULLNAME='+QuotedStr(Trim(edFullName.text))+
          ', VARIANT='+QuotedStr(Trim(meVariant.Lines.text))+
          ', PRIORITY='+inttostr(udPriority.Position)+
          ', FIELDS='+QuotedStr(Trim(meFields.Lines.Text))+
          ', CONDITION='+QuotedStr(Trim(meCondition.Lines.Text))+
          ' WHERE '+TfmRBAP(ParentForm).FieldKeyName+'='+IntToStr(OldFieldKeyValue);
end;

procedure TfmEditRBAPFieldView.FormCreate(Sender: TObject);
begin
  inherited;
  meFields.MaxLength:=5000;
  meCondition.MaxLength:=5000;
end;

function TfmEditRBAPFieldView.CheckFieldsFill: Boolean;
begin
  Result:=inherited CheckFieldsFill;
  if Result then begin
    if trim(meFields.Lines.Text)='' then begin
      ShowErrorEx(Format(ConstFieldNoEmpty,[lbFields.Caption]));
      meFields.SetFocus;
      Result:=false;
      exit;
    end;
  end;
end;

end.
