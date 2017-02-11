{ --------------------------------------------------------------------------- }
{ AnyDAC monitor view object form                                             }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fObjFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls,
  daADGUIxFormsControls;

type
  TADMoniObjectsFrm = class(TForm)
    pnlMain: TADGUIxFormsPanel;
    Splitter1: TSplitter;
    pnlMainFrame: TADGUIxFormsPanel;
    pnlDetails: TADGUIxFormsPanel;
    pnlDetailsWhite: TADGUIxFormsPanel;
    Splitter2: TSplitter;
    pnlObjects: TADGUIxFormsPanel;
    pnlObjectsWhite: TADGUIxFormsPanel;
    tvAdapters: TTreeView;
    pnlObjectsTitle: TADGUIxFormsPanel;
    lblObjectsTitle: TLabel;
    pnlObjectsTitleBottomLine: TADGUIxFormsPanel;
    Splitter3: TSplitter;
    Panel12: TADGUIxFormsPanel;
    Panel13: TADGUIxFormsPanel;
    Label1: TLabel;
    Panel14: TADGUIxFormsPanel;
    mmSQL: TMemo;
    Panel6: TADGUIxFormsPanel;
    Panel15: TADGUIxFormsPanel;
    Label2: TLabel;
    Panel16: TADGUIxFormsPanel;
    lvParams: TListView;
    Panel4: TADGUIxFormsPanel;
    Panel7: TADGUIxFormsPanel;
    Label3: TLabel;
    lvStat: TListView;
    Panel1: TADGUIxFormsPanel;
    Panel2: TADGUIxFormsPanel;
    Panel3: TADGUIxFormsPanel;
    Panel5: TADGUIxFormsPanel;
    Panel8: TADGUIxFormsPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ADMoniObjectsFrm: TADMoniObjectsFrm;

implementation

uses fMainFrm;

{$R *.dfm}

end.
