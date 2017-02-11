inherited fmJRDocum: TfmJRDocum
  Left = 370
  Top = 170
  Width = 549
  Height = 350
  Caption = 'Журнал документов'
  Constraints.MinHeight = 350
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000FF7FFFFFFFFF0000FF
    7FFFFFFFFF00007777777777770000FF7FFFFFFFFF0000FF7FFFFFFFFF000077
    77777777770000FF7FFFFFFFFF0000FF7FFFFFFFFF00007777777777770000FF
    7FFFFFFFFF0000FF7FFFFFFFFF0000000000000000000000000000000000FFFF
    0000FFFF00008001000080010000800100008001000080010000800100008001
    0000800100008001000080010000800100008001000080010000FFFF0000}
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnMain: TPanel
    Width = 541
    Height = 254
    inherited pnBut: TPanel
      Left = 452
      Height = 254
      inherited pnModal: TPanel
        Top = 127
        Height = 127
        TabOrder = 1
        inherited bibClear: TBitBtn [0]
          Top = 5
          TabOrder = 2
          Visible = False
        end
        inherited bibRefresh: TBitBtn [1]
          Top = 5
          OnClick = bibRefreshClick
        end
        inherited bibFilter: TBitBtn
          Top = 67
          TabOrder = 3
        end
        inherited bibAdjust: TBitBtn
          Top = 98
          TabOrder = 4
        end
        object bibView: TBitBtn
          Left = 8
          Top = 36
          Width = 75
          Height = 25
          Hint = 'Подробнее (F6)'
          Caption = 'Подробнее'
          TabOrder = 1
          OnClick = bibViewClick
          OnKeyDown = FormKeyDown
        end
      end
      object pnSQL: TPanel
        Left = 0
        Top = 0
        Width = 89
        Height = 127
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object bibAdd: TBitBtn
          Left = 8
          Top = 1
          Width = 75
          Height = 25
          Hint = 'Добавить (F2)'
          Caption = 'Добавить'
          TabOrder = 0
          OnClick = bibAddClick
          OnKeyDown = FormKeyDown
        end
        object bibChange: TBitBtn
          Left = 8
          Top = 33
          Width = 75
          Height = 25
          Hint = 'Изменить (F3)'
          Caption = 'Изменить'
          TabOrder = 1
          OnClick = bibChangeClick
          OnKeyDown = FormKeyDown
        end
        object bibDel: TBitBtn
          Left = 8
          Top = 65
          Width = 75
          Height = 25
          Hint = 'Удалить (F4)'
          Caption = 'Удалить'
          TabOrder = 2
          OnClick = bibDelClick
          OnKeyDown = FormKeyDown
        end
        object bibConduct: TBitBtn
          Left = 8
          Top = 96
          Width = 75
          Height = 25
          Hint = 'Провести документ'
          Caption = 'Провести'
          Enabled = False
          TabOrder = 3
          OnKeyDown = FormKeyDown
        end
      end
    end
    inherited pnGrid: TPanel
      Width = 452
      Height = 254
    end
  end
  inherited pnFind: TPanel
    Width = 541
    inherited edSearch: TEdit
      Width = 400
    end
  end
  inherited pnBottom: TPanel
    Top = 287
    Width = 541
    inherited bibOk: TBitBtn
      Left = 378
    end
    inherited bibClose: TBitBtn
      Left = 460
    end
  end
  inherited Mainqr: TIBQuery
    CachedUpdates = True
    UpdateObject = IBUpd
  end
  object pmAdd: TPopupMenu
    Alignment = paRight
    OnPopup = pmAddPopup
    Left = 224
    Top = 161
  end
end
