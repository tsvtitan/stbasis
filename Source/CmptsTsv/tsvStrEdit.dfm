object StrEditDlg: TStrEditDlg
  Left = 317
  Top = 148
  ActiveControl = Memo
  BorderStyle = bsDialog
  Caption = 'Редактор строк'
  ClientHeight = 278
  ClientWidth = 430
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
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 413
    Height = 229
    Shape = bsFrame
  end
  object LineCount: TLabel
    Left = 12
    Top = 12
    Width = 169
    Height = 17
    AutoSize = False
    Caption = '0 Линий'
  end
  object Memo: TMemo
    Left = 16
    Top = 28
    Width = 397
    Height = 201
    ScrollBars = ssBoth
    TabOrder = 0
    OnChange = UpdateStatus
    OnKeyDown = MemoKeyDown
  end
  object HelpBtn: TButton
    Left = 177
    Top = 245
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 3
    Visible = False
    OnClick = HelpBtnClick
  end
  object LoadBtn: TButton
    Left = 8
    Top = 245
    Width = 75
    Height = 25
    Caption = '&Загрузить...'
    TabOrder = 1
    OnClick = FileOpen
  end
  object SaveBtn: TButton
    Left = 92
    Top = 245
    Width = 75
    Height = 25
    Caption = '&Сохранить..'
    TabOrder = 2
    OnClick = FileSave
  end
  object bibOk: TButton
    Left = 261
    Top = 245
    Width = 75
    Height = 25
    Caption = 'ОК'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object bibCancel: TButton
    Left = 345
    Top = 245
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    TabOrder = 5
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'TXT'
    Filter = 
      'Текстовые файлы (*.TXT)|*.TXT|Файлы настроек (*.SYS;*.INI)|*.SYS' +
      ';*.INI|Файлы запуска (*.BAT)|*.BAT|Все файлы (*.*)|*.*'
    Options = [ofHideReadOnly, ofShowHelp, ofPathMustExist, ofFileMustExist]
    Left = 340
  end
  object SaveDialog: TSaveDialog
    Filter = 
      'Текстовые файлы (*.TXT)|*.TXT|Файлы настроек (*.SYS;*.INI)|*.SYS' +
      ';*.INI|Файлы запуска (*.BAT)|*.BAT|Все файлы (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofShowHelp, ofPathMustExist]
    Left = 376
  end
  object ImageList1: TImageList
    Left = 112
    Top = 88
  end
end
