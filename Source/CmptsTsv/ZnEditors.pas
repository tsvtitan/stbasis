{*************************************************************************}
{                                                                         }
{         Property Editors Project                                        }
{                                                                         }
{         Copyright (c) 2000 Michael Skachkov a.k.a. Master Yoda          }
{                                                                         }
{*************************************************************************}
unit ZnEditors;

interface

uses
  DsgnIntf, ZnClasses;

const
  {TAlign}
  ALIGN_IMG_WIDTH  = 40;
  ALIGN_IMG_HEIGHT = 32;

  {TAlignment}
  ALIGNMENT_IMG_WIDTH  = 40;
  ALIGNMENT_IMG_HEIGHT = 16;

  {TBevelCut}
  BEVEL_CUT_IMG_WIDTH  = 30;
  BEVEL_CUT_IMG_HEIGHT = 30;

  {TBevelShape}
  BEVEL_SHAPE_IMG_WIDTH  = 31;
  BEVEL_SHAPE_IMG_HEIGHT = 31;

  {TBevelStyle}
  BEVEL_STYLE_IMG_WIDTH  = 31;
  BEVEL_STYLE_IMG_HEIGHT = 31;

  {TBitBtnKind}
  BIT_BTN_KIND_IMG_WIDTH  = 18;
  BIT_BTN_KIND_IMG_HEIGHT = 18;

  {TBorderStyle}
  BORDER_STYLE_IMG_WIDTH  = 30;
  BORDER_STYLE_IMG_HEIGHT = 30;

  {TButtonLayout}
  BUTTON_LAYOUT_IMG_WIDTH  = 49;
  BUTTON_LAYOUT_IMG_HEIGHT = 30;

  {TCheckBoxState}
  CHECKBOX_STATE_IMG_WIDTH  = 21;
  CHECKBOX_STATE_IMG_HEIGHT = 21;

  {TComboBoxStyle}
  COMBO_BOX_STYLE_IMG_WIDTH  = 31;
  COMBO_BOX_STYLE_IMG_HEIGHT = 30;

  {TDefaultMonitor}
  DEFAULT_MONITOR_IMG_WIDTH  = 47;
  DEFAULT_MONITOR_IMG_HEIGHT = 42;

  {TEdgeStyle}
  EDGE_STYLE_IMG_WIDTH  = 30;
  EDGE_STYLE_IMG_HEIGHT = 30;

  {TEditCharCase}
  EDIT_CHAR_CASE_IMG_WIDTH  = 40;
  EDIT_CHAR_CASE_IMG_HEIGHT = 16;

  {TFormBorderStyle}
  FORM_BORDER_STYLE_IMG_WIDTH  = 38;
  FORM_BORDER_STYLE_IMG_HEIGHT = 31;

  {TFormStyle}
  FORM_STYLE_IMG_WIDTH  = 36;
  FORM_STYLE_IMG_HEIGHT = 29;

  {TLeftRight - ComboBox}
  LEFT_RIGHT_CHECK_BOX_IMG_WIDTH  = 49;
  LEFT_RIGHT_CHECK_BOX_IMG_HEIGHT = 21;

  {TLeftRight - RadioButton}
  LEFT_RIGHT_RADIO_BUTTON_IMG_WIDTH  = 49;
  LEFT_RIGHT_RADIO_BUTTON_IMG_HEIGHT = 21;

  {TListBoxStyle}
  LIST_BOX_STYLE_IMG_WIDTH  = 30;
  LIST_BOX_STYLE_IMG_HEIGHT = 30;

  {TPopupAlignment}
  POPUP_ALIGNMENT_IMG_WIDTH  = 36;
  POPUP_ALIGNMENT_IMG_HEIGHT = 32;

  {TPosition}
  POSITION_IMG_WIDTH  = 41;
  POSITION_IMG_HEIGHT = 32;

  {TScrollBarKind}
  SCROLL_BAR_KIND_IMG_WIDTH  = 24;
  SCROLL_BAR_KIND_IMG_HEIGHT = 24;

  {TScrollStyle}
  SCROLL_STYLE_IMG_WIDTH  = 24;
  SCROLL_STYLE_IMG_HEIGHT = 24;

  {TShapeType}
  SHAPE_TYPE_IMG_WIDTH  = 47;
  SHAPE_TYPE_IMG_HEIGHT = 30;

  {TStatusPanelBevel}
  STATUS_PANEL_BEVEL_IMG_WIDTH  = 30;
  STATUS_PANEL_BEVEL_IMG_HEIGHT = 30;

  {TTabPosition}
  TAB_POSITION_IMG_WIDTH  = 31;
  TAB_POSITION_IMG_HEIGHT = 23;

  {TTextLayout}
  TEXT_LAYOUT_IMG_WIDTH  = 22;
  TEXT_LAYOUT_IMG_HEIGHT = 28;

  {TViewStyle}
  VIEW_STYLE_IMG_WIDTH  = 18;
  VIEW_STYLE_IMG_HEIGHT = 16;

  {TWindowState}
  WINDOW_STATE_IMG_WIDTH  = 38;
  WINDOW_STATE_IMG_HEIGHT = 31;

type
  TAlignProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TAlignmentProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TBevelCutProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TBevelShapeProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TBevelStyleProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TBitBtnKindProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TBorderStyleProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TButtonLayoutProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TCheckBoxStateProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TComboBoxStyleProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TDefaultMonitorProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TEdgeStyleProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TEditCharCaseProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TFormBorderStyleProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TFormStyleProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TLeftRightCheckBoxProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TLeftRightRadioButtonProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TListBoxStyleProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TPopupAlignmentProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TPositionProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TScrollBarKindProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TScrollStyleProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TShapeTypeProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TStatusPanelBevelProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TTabPositionProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TTextLayoutProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TViewStyleProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

  TWindowStateProperty = class(TZnEnumProperty)
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
  end;

implementation

{ TAlignProperty }

constructor TAlignProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TALIGN_';
  FImgWidth:= ALIGN_IMG_WIDTH;
  FImgHeight:= ALIGN_IMG_HEIGHT;
  FLongestValue:= 'alBottom';
end;

{ TAlignmentProperty }

constructor TAlignmentProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TALIGNMENT_';
  FImgWidth:= ALIGNMENT_IMG_WIDTH;
  FImgHeight:= ALIGNMENT_IMG_HEIGHT;
  FLongestValue:= 'taRightJustify';
end;

{ TBevelCutProperty }

constructor TBevelCutProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TBEVELCUT_';
  FImgWidth:= BEVEL_CUT_IMG_WIDTH;
  FImgHeight:= BEVEL_CUT_IMG_HEIGHT;
  FLongestValue:= 'bvLowered';
end;

{ TBevelShapeProperty }

constructor TBevelShapeProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TBEVELSHAPE_';
  FImgWidth:= BEVEL_SHAPE_IMG_WIDTH;
  FImgHeight:= BEVEL_SHAPE_IMG_HEIGHT;
  FLongestValue:= 'bsBottomLine';
end;

{ TBevelStyleProperty }

constructor TBevelStyleProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TBEVELSTYLE_';
  FImgWidth:= BEVEL_STYLE_IMG_WIDTH;
  FImgHeight:= BEVEL_STYLE_IMG_HEIGHT;
  FLongestValue:= 'bsLowered';
end;

{ TBitBtnKindProperty }

constructor TBitBtnKindProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TBITBTNKIND_';
  FImgWidth:= BIT_BTN_KIND_IMG_WIDTH;
  FImgHeight:= BIT_BTN_KIND_IMG_HEIGHT;
  FLongestValue:= 'bkCustom';
end;

{ TBorderStyleProperty }

constructor TBorderStyleProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TBORDERSTYLE_';
  FImgWidth:= BORDER_STYLE_IMG_WIDTH;
  FImgHeight:= BORDER_STYLE_IMG_HEIGHT;
  FLongestValue:= 'bsSingle';
end;

{ TButtonLayoutProperty }

constructor TButtonLayoutProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TBUTTONLAYOUT_';
  FImgWidth:= BUTTON_LAYOUT_IMG_WIDTH;
  FImgHeight:= BUTTON_LAYOUT_IMG_HEIGHT;
  FLongestValue:= 'blGlyphBottom';
end;

{ TCheckBoxStateProperty }

constructor TCheckBoxStateProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TCHECKBOXSTATE_';
  FImgWidth:= CHECKBOX_STATE_IMG_WIDTH;
  FImgHeight:= CHECKBOX_STATE_IMG_HEIGHT;
  FLongestValue:= 'cbUnchecked';
end;

{ TListBoxStyleProperty }

constructor TComboBoxStyleProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TCOMBOBOXSTYLE_';
  FImgWidth:= COMBO_BOX_STYLE_IMG_WIDTH;
  FImgHeight:= COMBO_BOX_STYLE_IMG_HEIGHT;
  FLongestValue:= 'csOwnerDrawVariable';
end;

{ TDefaultMonitorProperty }

constructor TDefaultMonitorProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TDEFAULTMONITOR_';
  FImgWidth:= DEFAULT_MONITOR_IMG_WIDTH;
  FImgHeight:= DEFAULT_MONITOR_IMG_HEIGHT;
  FLongestValue:= 'dmActiveForm';
end;

{ TEdgeStyleProperty }

constructor TEdgeStyleProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TEDGESTYLE_';
  FImgWidth:= EDGE_STYLE_IMG_WIDTH;
  FImgHeight:= EDGE_STYLE_IMG_HEIGHT;
  FLongestValue:= 'esLowered';
end;

{ TEditCharCaseProperty }

constructor TEditCharCaseProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TEDITCHARCASE_';
  FImgWidth:= EDIT_CHAR_CASE_IMG_WIDTH;
  FImgHeight:= EDIT_CHAR_CASE_IMG_HEIGHT;
  FLongestValue:= 'ecLowerCase';
end;

{ TFormBorderStyleProperty }

constructor TFormBorderStyleProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TFORMBORDERSTYLE_';
  FImgWidth:= FORM_BORDER_STYLE_IMG_WIDTH;
  FImgHeight:= FORM_BORDER_STYLE_IMG_HEIGHT;
  FLongestValue:= 'bsSizeToolWin';
end;

{ TFormStyleProperty }

constructor TFormStyleProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TFORMSTYLE_';
  FImgWidth:= FORM_STYLE_IMG_WIDTH;
  FImgHeight:= FORM_STYLE_IMG_HEIGHT;
  FLongestValue:= 'fsStayOnTop';
end;

{ TLeftRightCheckBoxProperty }

constructor TLeftRightCheckBoxProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TLEFTRIGHTCHECKBOX_';
  FImgWidth:= LEFT_RIGHT_CHECK_BOX_IMG_WIDTH;
  FImgHeight:= LEFT_RIGHT_CHECK_BOX_IMG_HEIGHT;
  FLongestValue:= 'taRightJustify';
end;

{ TLeftRightRadioButtonProperty }

constructor TLeftRightRadioButtonProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TLEFTRIGHTRADIOBUTTON_';
  FImgWidth:= LEFT_RIGHT_RADIO_BUTTON_IMG_WIDTH;
  FImgHeight:= LEFT_RIGHT_RADIO_BUTTON_IMG_HEIGHT;
  FLongestValue:= 'taRightJustify';
end;

{ TListBoxStyleProperty }

constructor TListBoxStyleProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TLISTBOXSTYLE_';
  FImgWidth:= LIST_BOX_STYLE_IMG_WIDTH;
  FImgHeight:= LIST_BOX_STYLE_IMG_HEIGHT;
  FLongestValue:= 'lbOwnerDrawVariable';
end;

{ TPopupAlignmentProperty }

constructor TPopupAlignmentProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TPOPUPALIGNMENT_';
  FImgWidth:= POPUP_ALIGNMENT_IMG_WIDTH;
  FImgHeight:= POPUP_ALIGNMENT_IMG_HEIGHT;
  FLongestValue:= 'paCenter';
end;

{ TPositionProperty }

constructor TPositionProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TPOSITION_';
  FImgWidth:= POSITION_IMG_WIDTH;
  FImgHeight:= POSITION_IMG_HEIGHT;
  FLongestValue:= 'poOwnerFormCenter';
end;

{ TScrollBarKindProperty }

constructor TScrollBarKindProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TSCROLLBARKIND_';
  FImgWidth:= SCROLL_BAR_KIND_IMG_WIDTH;
  FImgHeight:= SCROLL_BAR_KIND_IMG_HEIGHT;
  FLongestValue:= 'sbHorizontal';
end;

{ TScrollStyleProperty }

constructor TScrollStyleProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TSCROLLSTYLE_';
  FImgWidth:= SCROLL_STYLE_IMG_WIDTH;
  FImgHeight:= SCROLL_STYLE_IMG_HEIGHT;
  FLongestValue:= 'ssHorizontal';
end;

{ TShapeTypeProperty }

constructor TShapeTypeProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TSHAPETYPE_';
  FImgWidth:= SHAPE_TYPE_IMG_WIDTH;
  FImgHeight:= SHAPE_TYPE_IMG_HEIGHT;
  FLongestValue:= 'stRoundSquare';
end;

{ TStatusPanelBevelProperty }

constructor TStatusPanelBevelProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TSTATUSPANELBEVEL_';
  FImgWidth:= STATUS_PANEL_BEVEL_IMG_WIDTH;
  FImgHeight:= STATUS_PANEL_BEVEL_IMG_HEIGHT;
  FLongestValue:= 'pbLowered';
end;


{ TTabPositionProperty }

constructor TTabPositionProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TTABPOSITION_';
  FImgWidth:= TAB_POSITION_IMG_WIDTH;
  FImgHeight:= TAB_POSITION_IMG_HEIGHT;
  FLongestValue:= 'tpBottom';
end;

{ TTextLayoutProperty }

constructor TTextLayoutProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TTEXTLAYOUT_';
  FImgWidth:= TEXT_LAYOUT_IMG_WIDTH;
  FImgHeight:= TEXT_LAYOUT_IMG_HEIGHT;
  FLongestValue:= 'tlBottom';
end;

{ TViewStyleProperty }

constructor TViewStyleProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TVIEWSTYLE_';
  FImgWidth:= VIEW_STYLE_IMG_WIDTH;
  FImgHeight:= VIEW_STYLE_IMG_HEIGHT;
  FLongestValue:= 'vsSmallIcon';
end;

{ TWindowStateProperty }

constructor TWindowStateProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);
  FImgPrefix:= 'TWINDOWSTATE_';
  FImgWidth:= WINDOW_STATE_IMG_WIDTH;
  FImgHeight:= WINDOW_STATE_IMG_HEIGHT;  
  FLongestValue:= 'wsMaximized';
end;

end.
