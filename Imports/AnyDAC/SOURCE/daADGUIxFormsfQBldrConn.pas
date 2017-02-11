{ --------------------------------------------------------------------------- }
{ AnyDAC Query Builder choose alias dialog                                    }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{ Portions copyright:                                                         }
{ - Sergey Orlik, 1996-99. The source is based on Open Query Builder.         }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfQBldrConn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, daADGUIxFormsfOptsBase;

type
  TfrmADGUIxFormsQBldrConn = class(TfrmADGUIxFormsOptsBase)
    ComboDB: TComboBox;
    cbSystem: TCheckBox;
    Label1: TLabel;
    Image1: TImage;
    cbOther: TCheckBox;
    cbMy: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmADGUIxFormsQBldrConn: TfrmADGUIxFormsQBldrConn;

implementation

{$R *.dfm}

end.
