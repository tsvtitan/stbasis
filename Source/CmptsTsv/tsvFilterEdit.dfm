object fmFilterEditor: TfmFilterEditor
  Left = 501
  Top = 236
  BorderStyle = bsDialog
  Caption = 'Редактор фильтра'
  ClientHeight = 202
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object bibOk: TButton
    Left = 141
    Top = 171
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'ОК'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object bibCancel: TButton
    Left = 223
    Top = 171
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 2
  end
  object sgValues: TStringGrid
    Left = 6
    Top = 8
    Width = 291
    Height = 153
    ColCount = 2
    DefaultColWidth = 133
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 25
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goAlwaysShowEditor]
    TabOrder = 0
  end
end
