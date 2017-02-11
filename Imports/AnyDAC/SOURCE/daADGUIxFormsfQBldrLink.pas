{ --------------------------------------------------------------------------- }
{ AnyDAC Query Builder setup link dialog                                      }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{ Portions copyright:                                                         }
{ - Sergey Orlik, 1996-99. The source is based on Open Query Builder.         }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfQBldrLink;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, daADGUIxFormsfOptsBase;

type
  TfrmADGUIxFormsQBldrLink = class(TfrmADGUIxFormsOptsBase)
    Label1: TLabel;
    Label3: TLabel;
    txtTable1: TEdit;
    txtCol1: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    txtTable2: TEdit;
    txtCol2: TEdit;
    RadioOpt: TRadioGroup;
    RadioType: TRadioGroup;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmADGUIxFormsQBldrLink: TfrmADGUIxFormsQBldrLink;

implementation

{$R *.dfm}

end.
