{ --------------------------------------------------------------------------- }
{ AnyDAC monitor view trace form                                              }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fTraceFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls,
  daADGUIxFormsControls;

type
  TADMoniTraceFrm = class(TForm)
    pnlMain: TADGUIxFormsPanel;
    pnlMainFrame: TADGUIxFormsPanel;
    splDetailSpliter: TSplitter;
    Panel4: TADGUIxFormsPanel;
    Panel10: TADGUIxFormsPanel;
    TreeView1: TTreeView;
    pnlTraceTitle: TADGUIxFormsPanel;
    lblTraceTitle: TLabel;
    pnlTraceTitleBottomLine: TADGUIxFormsPanel;
    HeaderControl1: THeaderControl;
    lbTrace: TListBox;
    pnlDetails: TADGUIxFormsPanel;
    pnlDetailsWhite: TADGUIxFormsPanel;
    pnlDetailTitle: TADGUIxFormsPanel;
    lblDetailTitle: TLabel;
    mmDetails: TMemo;
    Panel1: TADGUIxFormsPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ADMoniTraceFrm: TADMoniTraceFrm;

implementation

uses fMainFrm;

{$R *.dfm}

end.
