unit tsvPicture;

interface

uses Classes,Controls,Graphics,jpeg,sysutils;

type
   TTsvPicture=class(TPicture)
     public
       function GetGraphicClass(Header: array of byte): TGraphicClass;
       procedure LoadFromStream(Stream: TMemoryStream);
       procedure SaveToStream(Stream: TMemoryStream);
       function isEmpty: Boolean;
       procedure Assign(Source: TPersistent); override;
   end;


implementation

function TTsvPicture.GetGraphicClass(Header: array of byte): TGraphicClass;
begin
  Result:=nil;
  if (Header[0]=66)and(Header[1]=77)then begin
    Result:=TBitmap;
    exit;
  end;
  if (Header[0]=255)and(Header[1]=216)and(Header[2]=255)and(Header[3]=224)then begin
    Result:=TJPEGImage;
    exit;
  end;
  if (Header[0]=255)and(Header[1]=216)and(Header[2]=255)and(Header[3]=225)then begin
    Result:=TJPEGImage;
    exit;
  end;
  if (Header[0]=0)and(Header[1]=0)and(Header[2]=1)and(Header[3]=0)then begin
    Result:=TIcon;
    exit;
  end;
  if (Header[0]=215)and(Header[1]=205)and(Header[2]=198)and(Header[3]=154)then begin
    Result:=TMetafile;
    exit;
  end;
end;

procedure TTsvPicture.LoadFromStream(Stream: TMemoryStream);
var
  GraphicClass: TGraphicClass;
  NewGraphic: TGraphic;
  Header: array[0..3] of byte;
begin
  if Stream.Size=0 then exit;
  Move(Stream.Memory^,Header,4);
  GraphicClass:=GetGraphicClass(Header);
  if GraphicClass=nil then begin
    Graphic:=nil;
    raise Exception.Create('Неверный графический формат.');
  end;

  NewGraphic:= GraphicClass.Create;
  try
    NewGraphic.LoadFromStream(Stream);
    Graphic:=NewGraphic;
    Changed(Self);
  finally
    NewGraphic.Free;
  end;
end;

procedure TTsvPicture.SaveToStream(Stream: TMemoryStream);
begin
 if Graphic<>nil then
   Graphic.SaveToStream(Stream);
end;

function TTsvPicture.isEmpty: Boolean;
begin
  Result:=(Height=0)and(Width=0);
end;

procedure TTsvPicture.Assign(Source: TPersistent);
begin
  inherited;
end;

end.
