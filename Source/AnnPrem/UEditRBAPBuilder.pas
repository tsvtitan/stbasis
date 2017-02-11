unit UEditRBAPBuilder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRBAP, IBDatabase, ComCtrls, StdCtrls, ExtCtrls, DB, tsvStdCtrls;

type
  TfmEditRBAPBuilder = class(TfmEditRBAP)
    lbPhones: TLabel;
    edPhones: TEdit;
    lbAddress: TLabel;
    edAddress: TEdit;
    lbSite: TLabel;
    edSite: TEdit;
    lbEmail: TLabel;
    edEmail: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    procedure InitUpdateAndView;
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
  fmEditRBAPBuilder: TfmEditRBAPBuilder;

implementation

uses UMainUnited, URBAP, URBAPAgency, UAnnPremData;

{$R *.DFM}

procedure TfmEditRBAPBuilder.InitUpdateAndView;
begin
  with TfmRBAP(ParentForm) do begin
    edPhones.Text:=Mainqr.FieldByName('PHONES').AsString;
    edAddress.Text:=Mainqr.FieldByName('ADDRESS').AsString;
    edSite.Text:=Mainqr.FieldByName('SITE').AsString;
    edEmail.Text:=Mainqr.FieldByName('EMAIL').AsString;
  end;
end;

procedure TfmEditRBAPBuilder.InitUpdate;
begin
  inherited InitUpdate;
  InitUpdateAndView;
end;

procedure TfmEditRBAPBuilder.InitView;
begin
  inherited InitView;
  InitUpdateAndView;
end;

procedure TfmEditRBAPBuilder.InitFilter;
begin
  inherited InitFilter;
  with TfmRBAPAgency(ParentForm) do begin
    edPhones.Text:=Filters.Items[IndexFindPhones].Value;
    edAddress.Text:=Filters.Items[IndexFindAddress].Value;
    edSite.Text:=Filters.Items[IndexFindSite].Value;
    edEmail.Text:=Filters.Items[IndexFindEmail].Value;
  end;  
end;

procedure TfmEditRBAPBuilder.DoneFilter;
begin
  inherited DoneFilter;
  with TfmRBAPAgency(ParentForm) do begin
    Filters.Items[IndexFindPhones].Value:=Trim(edPhones.Text);
    Filters.Items[IndexFindPhones].Enabled:=Trim(edPhones.Text)<>'';

    Filters.Items[IndexFindAddress].Value:=Trim(edAddress.Text);
    Filters.Items[IndexFindAddress].Enabled:=Trim(edAddress.Text)<>'';

    Filters.Items[IndexFindSite].Value:=Trim(edSite.Text);
    Filters.Items[IndexFindSite].Enabled:=Trim(edSite.Text)<>'';

    Filters.Items[IndexFindEmail].Value:=Trim(edEmail.Text);
    Filters.Items[IndexFindEmail].Enabled:=Trim(edEmail.Text)<>'';

  end;
end;

function TfmEditRBAPBuilder.GetAddSql: String;
begin
  Result:='INSERT INTO '+TfmRBAP(ParentForm).TableName+
          ' ('+TfmRBAP(ParentForm).FieldKeyName+',NAME,FULLNAME,VARIANT,PRIORITY,PHONES,ADDRESS,SITE,EMAIL) VALUES '+
          ' ('+inttostr(OldFieldKeyValue)+
          ','+QuotedStr(Trim(edName.Text))+
          ','+QuotedStr(Trim(edFullName.Text))+
          ','+QuotedStr(Trim(meVariant.Lines.Text))+
          ','+inttostr(udPriority.Position)+
          ','+QuotedStr(Trim(edPhones.Text))+
          ','+QuotedStr(Trim(edAddress.Text))+
          ','+QuotedStr(Trim(edSite.Text))+
          ','+QuotedStr(Trim(edEmail.Text))+
          ')';
end;

procedure TfmEditRBAPBuilder.CacheUpdate;
begin
  inherited CacheUpdate;
  with TfmRBAP(ParentForm) do begin
    MainQr.FieldByName('PHONES').AsString:=Trim(edPhones.Text);
    MainQr.FieldByName('ADDRESS').AsString:=Trim(edAddress.Text);
    MainQr.FieldByName('SITE').AsString:=Trim(edSite.Text);
    MainQr.FieldByName('EMAIL').AsString:=Trim(edEmail.Text);
  end;
end;

function TfmEditRBAPBuilder.GetUpdateSql: String;
begin
  Result:='UPDATE '+TfmRBAP(ParentForm).TableName+
          ' SET NAME='+QuotedStr(Trim(edName.text))+
          ', FULLNAME='+QuotedStr(Trim(edFullName.text))+
          ', VARIANT='+QuotedStr(Trim(meVariant.Lines.text))+
          ', PRIORITY='+inttostr(udPriority.Position)+
          ', PHONES='+QuotedStr(Trim(edPhones.Text))+
          ', ADDRESS='+QuotedStr(Trim(edAddress.Text))+
          ', SITE='+QuotedStr(Trim(edSite.Text))+
          ', EMAIL='+QuotedStr(Trim(edEmail.Text))+
          ' WHERE '+TfmRBAP(ParentForm).FieldKeyName+'='+IntToStr(OldFieldKeyValue);
end;

procedure TfmEditRBAPBuilder.FormCreate(Sender: TObject);
begin
  inherited;
  edPhones.MaxLength:=DomainNoteLength;
  edAddress.MaxLength:=DomainNoteLength;
  edSite.MaxLength:=DomainNoteLength;
  edEmail.MaxLength:=DomainNoteLength;
end;

function TfmEditRBAPBuilder.CheckFieldsFill: Boolean;
begin
  Result:=inherited CheckFieldsFill;
  if Result then
    if trim(edPhones.Text)='' then begin
      ShowErrorEx(Format(ConstFieldNoEmpty,[lbPhones.Caption]));
      edPhones.SetFocus;
      Result:=false;
      exit;
    end;
end;

end.
