object fmMaskEditor: TfmMaskEditor
  Left = 429
  Top = 168
  BorderStyle = bsDialog
  Caption = 'Редактор масок'
  ClientHeight = 236
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbTest: TLabel
    Left = 34
    Top = 15
    Width = 62
    Height = 13
    Caption = 'Тест маски:'
  end
  object lbChar: TLabel
    Left = 145
    Top = 39
    Width = 120
    Height = 13
    Caption = 'Заполняемые символы'
  end
  object bibOk: TButton
    Left = 229
    Top = 205
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'ОК'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object bibCancel: TButton
    Left = 311
    Top = 205
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 7
  end
  object sgValues: TStringGrid
    Left = 8
    Top = 64
    Width = 377
    Height = 129
    ColCount = 3
    DefaultColWidth = 118
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing, goRowSelect]
    TabOrder = 3
    OnKeyDown = sgValuesKeyDown
    OnSelectCell = sgValuesSelectCell
    OnSetEditText = sgValuesSetEditText
  end
  object meTest: TMaskEdit
    Left = 105
    Top = 11
    Width = 192
    Height = 21
    TabOrder = 0
  end
  object edChar: TEdit
    Left = 272
    Top = 35
    Width = 25
    Height = 21
    MaxLength = 1
    TabOrder = 2
    Text = '_'
  end
  object bibClear: TButton
    Left = 8
    Top = 205
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Очистить'
    TabOrder = 4
    OnClick = bibClearClick
  end
  object chbEdit: TCheckBox
    Left = 96
    Top = 209
    Width = 105
    Height = 17
    Caption = 'Редактировать'
    TabOrder = 5
    OnClick = chbEditClick
  end
  object chbSave: TCheckBox
    Left = 9
    Top = 37
    Width = 109
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Сохранять текст'
    TabOrder = 1
  end
end
