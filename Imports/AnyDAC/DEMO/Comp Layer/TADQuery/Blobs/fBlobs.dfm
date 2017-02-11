inherited frmMain: TfrmMain
  Left = 378
  Top = 188
  Caption = 'Blobs'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlSubstrate: TPanel
    inherited pnlBorder: TPanel
      inherited pnlTitle: TPanel
        inherited lblTitle: TLabel
          Width = 57
          Caption = 'Blobs'
        end
      end
      inherited pnlMain: TPanel
        inherited pnlSubPageControl: TPanel
          inherited pcMain: TADGUIxFormsPageControl
            ActivePage = tsData
            inherited tsData: TTabSheet
              object Image1: TImage
                Left = 260
                Top = 228
                Width = 350
                Height = 145
                Align = alClient
              end
              object Splitter1: TSplitter
                Left = 0
                Top = 225
                Width = 610
                Height = 3
                Cursor = crVSplit
                Align = alTop
              end
              object Splitter2: TSplitter
                Left = 257
                Top = 228
                Height = 145
              end
              object DBGrid1: TDBGrid
                Left = 0
                Top = 41
                Width = 610
                Height = 184
                Align = alTop
                BorderStyle = bsNone
                DataSource = dsCategories
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = []
              end
              object DBMemo1: TDBMemo
                Left = 0
                Top = 228
                Width = 257
                Height = 145
                Align = alLeft
                BevelInner = bvSpace
                BevelKind = bkFlat
                BorderStyle = bsNone
                DataField = 'Description'
                DataSource = dsCategories
                TabOrder = 2
              end
              object Panel1: TPanel
                Left = 0
                Top = 0
                Width = 610
                Height = 41
                Align = alTop
                BevelOuter = bvNone
                ParentColor = True
                TabOrder = 1
                object btnClrPic: TSpeedButton
                  Left = 269
                  Top = 9
                  Width = 68
                  Height = 22
                  Caption = 'Clear Picture'
                  Flat = True
                  OnClick = btnClrPicClick
                end
                object btnSavePic: TSpeedButton
                  Left = 357
                  Top = 9
                  Width = 68
                  Height = 22
                  Caption = 'Save Picture'
                  Flat = True
                  OnClick = btnSavePicClick
                end
                object btnLoadPic: TSpeedButton
                  Left = 440
                  Top = 9
                  Width = 73
                  Height = 22
                  Caption = 'Load Picture'
                  Flat = True
                  OnClick = btnLoadPicClick
                end
                object DBNavigator1: TDBNavigator
                  Left = 11
                  Top = 7
                  Width = 240
                  Height = 25
                  DataSource = dsCategories
                  Flat = True
                  TabOrder = 0
                end
              end
            end
          end
        end
      end
    end
  end
  inherited pnlButtons: TPanel
    Top = 568
  end
  inherited StatusBar1: TStatusBar
    Top = 599
  end
  object qCategories: TADQuery
    Connection = dmlMainComp.dbMain
    FetchOptions.Items = [fiBlobs, fiDetails]
    SQL.Strings = (
      'select * from {id Categories}')
    Left = 312
    Top = 256
    object qCategoriesCategoryID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'CategoryID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qCategoriesCategoryName: TStringField
      FieldName = 'CategoryName'
      Required = True
      Size = 15
    end
    object qCategoriesDescription: TMemoField
      FieldName = 'Description'
      BlobType = ftMemo
    end
    object qCategoriesPicture: TBlobField
      FieldName = 'Picture'
    end
  end
  object dsCategories: TDataSource
    DataSet = qCategories
    OnDataChange = dsCategoriesDataChange
    Left = 344
    Top = 256
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmap files (*.bmp)|*.bmp|All files (*.*)|*.*'
    Left = 311
    Top = 296
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmap files (*.bmp)|*.bmp|All files (*.*)|*.*'
    Left = 344
    Top = 296
  end
end
