inherited frmImportAliases: TfrmImportAliases
  Left = 403
  Top = 239
  Caption = 'AnyDAC BDE Aliases Importer'
  ClientHeight = 374
  ClientWidth = 380
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlButtons: TADGUIxFormsPanel
    Top = 340
    Width = 380
    inherited btnOk: TButton
      Left = 218
    end
    inherited btnCancel: TButton
      Left = 301
    end
  end
  inherited pnlMain: TADGUIxFormsPanel
    Width = 380
    Height = 340
    inherited pnlGray: TADGUIxFormsPanel
      Width = 372
      Height = 332
      inherited pnlOptions: TADGUIxFormsPanel
        Width = 370
        Height = 307
        object lvAliases: TListView
          Left = 8
          Top = 8
          Width = 354
          Height = 225
          Anchors = [akLeft, akTop, akRight, akBottom]
          BorderStyle = bsNone
          Checkboxes = True
          Columns = <
            item
              Caption = 'Alias'
              Width = 150
            end
            item
              Caption = 'Driver'
              Width = 150
            end>
          TabOrder = 0
          ViewStyle = vsReport
          OnColumnClick = lvAliasesColumnClick
          OnCompare = lvAliasesCompare
        end
        object cbOverwrite: TCheckBox
          Left = 8
          Top = 246
          Width = 329
          Height = 17
          Anchors = [akLeft, akBottom]
          Caption = '&Overwrite existing connection definitions with the same name'
          TabOrder = 1
        end
        object btnSelectAll: TButton
          Left = 8
          Top = 273
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = '&Select All'
          TabOrder = 2
          OnClick = btnSelectAllClick
        end
        object btnUnselectAll: TButton
          Left = 91
          Top = 272
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = '&Unselect All'
          TabOrder = 3
          OnClick = btnUnselectAllClick
        end
      end
      inherited pnlTitle: TADGUIxFormsPanel
        Width = 370
        inherited lblTitle: TLabel
          Width = 230
          Caption = 'Select BDE aliases to import into AnyDAC'
        end
        inherited pnlTitleBottomLine: TADGUIxFormsPanel
          Width = 370
        end
      end
    end
  end
end
