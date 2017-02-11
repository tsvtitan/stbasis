inherited frmDbDesc: TfrmDbDesc
  Width = 420
  Height = 386
  Hint = 'Database object properties'
  Color = clBtnFace
  Font.Name = 'Tahoma'
  ParentFont = False
  object pnlMainBG: TADGUIxFormsPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 386
    Align = alClient
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 0
    object pcMain: TADGUIxFormsPageControl
      Left = 0
      Top = 0
      Width = 420
      Height = 386
      ActivePage = tsSQL
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 0
      OnChange = pcMainChange
      object tsSQL: TTabSheet
        Caption = 'Enter SQL'
        object Splitter1: TSplitter
          Left = 0
          Top = 132
          Width = 412
          Height = 4
          Cursor = crVSplit
          Align = alTop
        end
        object Panel1: TADGUIxFormsPanel
          Left = 0
          Top = 3
          Width = 412
          Height = 129
          Align = alTop
          BevelOuter = bvNone
          BorderWidth = 1
          Caption = 'Panel1'
          Color = clGray
          TabOrder = 0
          object Bevel1: TBevel
            Left = 375
            Top = 1
            Width = 2
            Height = 127
            Align = alRight
          end
          object Panel2: TADGUIxFormsPanel
            Left = 377
            Top = 1
            Width = 34
            Height = 127
            Align = alRight
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 1
            object btnRun: TSpeedButton
              Left = 5
              Top = 6
              Width = 23
              Height = 22
              Hint = 'Execute SQL text (F9)'
              Flat = True
              Glyph.Data = {
                36080000424D3608000000000000360400002800000040000000100000000100
                08000000000000040000000000000000000000010000000100004A7BB500296B
                C600527BC600186BD600528CD6003194D600397BE7005284E700107BEF00317B
                EF001084EF0029ADEF0039ADEF0010B5EF0008BDEF000073F7001873F7002973
                F7000884F7000894F70018A5F70000CEF70018DEF70063DEF700FF00FF000073
                FF00007BFF000084FF00008CFF000094FF00009CFF0000A5FF0010A5FF0039A5
                FF0052A5FF005AA5FF0000ADFF0029ADFF0031ADFF0000B5FF006BB5FF0084B5
                FF0000BDFF0008BDFF0010BDFF0000C6FF0008C6FF006BC6FF0000CEFF0018CE
                FF0000D6FF0008D6FF0010D6FF0021D6FF0031D6FF0000DEFF0018DEFF0029DE
                FF0042DEFF0000E7FF0010E7FF0018E7FF0039E7FF0000EFFF0018EFFF0039EF
                FF004AEFFF0000F7FF0008F7FF0029F7FF0031F7FF0042F7FF004AF7FF005AF7
                FF0000FFFF0008FFFF0018FFFF0021FFFF0031FFFF0039FFFF00FFFFFF00C5C5
                C50095959500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00181818181818
                1818181818181818181818181818181818181818181818181818181818181818
                1818181818181818181818181818181818181818181818181818181818021818
                1818181818181818181818181851181818181818181818181818181818021818
                1818181818181818181818181801181818181818181818181818181818090201
                1818181818181818181818181851515218181818181818181818181818090201
                1818181818181818181818181803010118181818181818181818181818061A0F
                0218181818181818181818181851525251181818181818181818181818061A0F
                0218181818181818181818181803190F01181818181818181818181818181E1C
                1C02181818181818181818181818525252511818181818181818181818181E1C
                1C021818181818181818181818181B1919011818181818181818181818181827
                1C1D020218181818181818181818185252525151181818181818181818181827
                1C1D020218181818181818181818181F191A0101181818181818181818181818
                272E1E1E02181818181818181818181852525252511818181818181818181818
                272E1E1E0218181818181818181818181F271B1B011818181818181818181818
                18272B241E021818181818181818181818525252525118181818181818181818
                18272B241E0218181818181818181818181F241D1B0118181818181818180202
                022D4B462C240202181818181818515151525251515251511818181818180202
                022D4B462C240202181818181818010101274A40241D0101181818181818252D
                3F43434A42311F0218181818181851525252525251515251181818181818252D
                3F43434A42311F0218181818181820273B43434A3E2B1C01181818181818212D
                3F433F374A4A412E02181818181851525252525252525152511818181818212D
                3F433F374A4A412E02181818181814273B433B324A4A3D27011818181818182E
                3E42474C4A4A4B4D02181818181818525151515152525251511818181818182E
                3E42474C4A4A4B4D0218181818181827393E454B4A4A4A4C0118181818181818
                1836444A43322702181818181818181818515252525252511818181818181818
                1836444A4332270218181818181818181831434A432D1F011818181818181818
                18181836433F241F021818181818181818181851525252525118181818181818
                18181836433F241F021818181818181818181831433B1D1C0118181818181818
                1818181818363A34230218181818181818181818185151515151181818181818
                1818181818363A342302181818181818181818181831362E2101181818181818
                1818181818181836221818181818181818181818181818515118181818181818
                1818181818181836221818181818181818181818181818312118}
              NumGlyphs = 4
              OnClick = btnRunClick
            end
            object btnPrev: TSpeedButton
              Left = 5
              Top = 28
              Width = 23
              Height = 22
              Hint = 'Previous executed SQL (Alt+Left)'
              Flat = True
              Glyph.Data = {
                36080000424D3608000000000000360400002800000040000000100000000100
                0800000000000004000000000000000000000001000000010000006B00000073
                0000007B000000940000009C0000086B0800087B08000884080008A5080008AD
                080008B5080010731000107B10001084100010A5100010AD100010B510001873
                1800187B180018841800188C1800189C180018A5180018AD180018B51800217B
                2100218C210021942100219C210021AD210021B5210029942900299C29003194
                3100319C3100399C390039A5390039AD3900429C420042A5420042AD42004AA5
                4A004AAD4A0052A5520052AD52005AAD5A0063AD630063B563006BB56B0073BD
                73007BB57B007BBD7B0084B5840084C684008CBD8C008CC68C009CCE9C00A5D6
                A500B5DEB500FF00FF00FFFFFF00A1A1A10093939300C5C5C500FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF003B3B3B3B3B3B
                3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B
                3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B340B111111
                12120C0C06060201323B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B340B111111
                12120C0C06060201323B3B2E0505050505050505000000002E3B3B0D1A1F2121
                1F201C16160E0803003B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B0D1A1F2121
                1F201C16160E0803003B3B050B12121212130D0707030302003B3B141F232323
                243C392929290904023B3B3B3B3B3B3B3B3E3E3B3B3B3B3B3B3B3B141F232323
                243C392929290904023B3B0B121A1A1A1A3C372121210302003B3B1B23272927
                3C3C3C2929290F08063B3B3B3B3B3B3B3E3E3E3B3B3B3B3B3B3B3B1B23272927
                3C3C3C2929290F08063B3B0C1A1F211F3C3C3C2121210303003B3B1F26292B3C
                3C3C292929290F0E073B3B3B3B3B3B3E3E3E3B3B3B3B3B3B3B3B3B1F26292B3C
                3C3C292929290F0E073B3B121A21213C3C3C212121210303003B3B22292B3C3C
                3C292929292917160D3B3B3B3B3B3E3E3E3B3B3B3B3B3B3B3B3B3B22292B3C3C
                3C292929292917160D3B3B1321213C3C3C21212121210807053B3B262B3C3C3C
                3C3C3C3C3C3C3C1C133B3B3B3B3E3E3E3E3E3E3E3E3E3E3B3B3B3B262B3C3C3C
                3C3C3C3C3C3C3C1C133B3B1A213C3C3C3C3C3C3C3C3C3C0D053B3B272D3C3C3C
                3C3C3C3C3C3C3C1C193B3B3B3B3F3E3E3E3F3F3F3F3F3F3B3B3B3B272D3C3C3C
                3C3C3C3C3C3C3C1C193B3B1F263C3C3C3C3C3C3C3C3C3C0D053B3B2B2E2E3C3C
                3C262626261F1F1F193B3B3B3B3B3F3E3D3B3B3B3B3B3B3B3B3B3B2B2E2E3C3C
                3C262626261F1F1F193B3B2126263C3C3C1A1A1A1A121212053B3B2B30302D3C
                3C3C2626261F1F1F193B3B3B3B3B3B3F3E3D3B3B3B3B3B3B3B3B3B2B30302D3C
                3C3C2626261F1F1F193B3B212B2B263C3C3C1A1A1A121212053B3B2D33312E2D
                3C3C3C2622222121193B3B3B3B3B3B3B3F3E3D3B3B3B3B3B3B3B3B2D33312E2D
                3C3C3C2622222121193B3B262E2D26263C3C3C1A13131212053B3B303733302F
                2E3C3A2929272321193B3B3B3B3B3B3B3B3F3E3B3B3B3B3B3B3B3B303733302F
                2E3C3A2929272321193B3B2B312E2B29263C3921211F1A12053B3B3138373331
                302F2E2D2C292721113B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3138373331
                302F2E2D2C292721113B3B2D35312E2D2B29262623211F12053B3B3A312F2D2B
                2B2929272623211A363B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3A312F2D2B
                2B2929272623211A363B3B392D2926212121211F1A1A120B303B3B3B3B3B3B3B
                3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B
                3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B}
              NumGlyphs = 4
              OnClick = btnPrevClick
            end
            object btnNext: TSpeedButton
              Left = 5
              Top = 50
              Width = 23
              Height = 22
              Hint = 'Next executed SQL (Alt+Right)'
              Flat = True
              Glyph.Data = {
                36080000424D3608000000000000360400002800000040000000100000000100
                0800000000000004000000000000000000000001000000010000006B00000073
                0000007B000000940000009C0000086B0800087B08000884080008A5080008AD
                080008B5080010731000107B10001084100010A5100010AD100010B510001873
                1800187B180018841800188C1800189C180018A5180018AD180018B51800217B
                2100218C210021942100219C210021AD210021B5210029942900299C29003194
                3100319C3100399C390039A5390039AD3900429C420042A5420042AD42004AA5
                4A004AAD4A0052A5520052AD52005AAD5A0063AD630063B563006BB56B0073BD
                73007BB57B007BBD7B0084B5840084C684008CBD8C008CC68C009CCE9C00A5D6
                A500B5DEB500FF00FF00FFFFFF0095959500C5C5C500B6B6B600A1A1A100FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF003B3B3B3B3B3B
                3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B
                3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B340B111111
                12120C0C06060201323B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B340B111111
                12120C0C06060201323B3B2E0505050505050505000000002E3B3B0D1A1F2121
                1F201C16160E0803003B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B0D1A1F2121
                1F201C16160E0803003B3B050B12121212130D0707030302003B3B141F232323
                24393C1D17100904023B3B3B3B3B3B3B3B3B3D3B3B3B3B3B3B3B3B141F232323
                24393C1D17100904023B3B0B121A1A1A1A373C1508080302003B3B1B23272927
                273C3C3C1E180F08063B3B3B3B3B3B3B3B3D3D3D3B3B3B3B3B3B3B1B23272927
                273C3C3C1E180F08063B3B0C1A1F211F1F3C3C3C0E080303003B3B1F26292B29
                27283C3C3C180F0E073B3B3B3B3B3B3B3B3B3D3D3D3B3B3B3B3B3B1F26292B29
                27283C3C3C180F0E073B3B121A2121211F1F3C3C3C080303003B3B22292B2B29
                2927253C3C3C17160D3B3B3B3B3B3B3B3B3B3B3D3D3D3B3B3B3B3B22292B2B29
                2927253C3C3C17160D3B3B1321212121211F1B3C3C3C0807053B3B262B3C3C3C
                3C3C3C3C3C3C3C1C133B3B3B3B3D3D3D3D3D3D3D3D3D3D3B3B3B3B262B3C3C3C
                3C3C3C3C3C3C3C1C133B3B1A213C3C3C3C3C3C3C3C3C3C0D053B3B272D3C3C3C
                3C3C3C3C3C3C3C1C193B3B3B3B3E3E3E3E3E3E3D3D3D3E3B3B3B3B272D3C3C3C
                3C3C3C3C3C3C3C1C193B3B1F263C3C3C3C3C3C3C3C3C3C0D053B3B2B2E2E2D2B
                2926233C3C3C201F193B3B3B3B3B3B3B3B3B3B3D3D3E3B3B3B3B3B2B2E2E2D2B
                2926233C3C3C201F193B3B2126262621211A1A3C3C3C1312053B3B2B30302D2B
                29263C3C3C1F1F1F193B3B3B3B3B3B3B3B3B3E3D3E3B3B3B3B3B3B2B30302D2B
                29263C3C3C1F1F1F193B3B212B2B2621211A3C3C3C121212053B3B2D33312E2D
                2B3C3C3C22222121193B3B3B3B3B3B3B3B3E3E3E3B3B3B3B3B3B3B2D33312E2D
                2B3C3C3C22222121193B3B262E2D2626213C3C3C13131212053B3B303733302F
                2E3A3C2929272321193B3B3B3B3B3B3B3B3B3E3B3B3B3B3B3B3B3B303733302F
                2E3A3C2929272321193B3B2B312E2B2926393C21211F1A12053B3B3138373331
                302F2E2D2C292721113B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3138373331
                302F2E2D2C292721113B3B2D35312E2D2B29262623211F12053B3B3A312F2D2B
                2B2929272623211A363B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3A312F2D2B
                2B2929272623211A363B3B392D2926212121211F1A1A120B303B3B3B3B3B3B3B
                3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B
                3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B}
              NumGlyphs = 4
              OnClick = btnNextClick
            end
          end
        end
        object Panel4: TADGUIxFormsPanel
          Left = 0
          Top = 136
          Width = 412
          Height = 178
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 1
          Caption = 'Panel1'
          Color = clGray
          TabOrder = 1
          object dbgSQL: TDBGrid
            Left = 1
            Top = 1
            Width = 410
            Height = 176
            Align = alClient
            BorderStyle = bsNone
            DataSource = dsSQL
            ParentShowHint = False
            PopupMenu = pmGrid
            ShowHint = False
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnColEnter = dbgColEnter
            OnDblClick = dbgDblClick
          end
        end
        object pnlEnterSQLSubTitle: TADGUIxFormsPanel
          Left = 0
          Top = 0
          Width = 412
          Height = 3
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 2
        end
      end
    end
  end
  object qSQL: TADQuery
    FetchOptions.Items = [fiBlobs, fiDetails]
    FormatOptions.StrsTrim = True
    UpdateOptions.UseProviderFlags = False
    Left = 161
    Top = 43
  end
  object dsSQL: TDataSource
    DataSet = qSQL
    Left = 193
    Top = 43
  end
  object pmGrid: TPopupMenu
    OnPopup = pmGridPopup
    Left = 136
    Top = 184
    object miMemo: TMenuItem
      Caption = 'Blob Viewer ...'
      OnClick = miMemoClick
    end
  end
end