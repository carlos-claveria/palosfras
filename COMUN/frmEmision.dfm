object fEmision: TfEmision
  Left = 0
  Top = 0
  Width = 418
  Height = 43
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  ParentFont = False
  TabOrder = 0
  object cEmis: TcxTextEdit
    Left = 1
    Top = 17
    ParentFont = False
    Style.Font.Charset = ANSI_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -12
    Style.Font.Name = 'Courier New'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 0
    OnExit = cEmisExit
    OnKeyDown = cEmisKeyDown
    Width = 105
  end
  object t01: TcxLabel
    Left = 1
    Top = 1
    AutoSize = False
    Caption = ' Emisi'#243'n :'
    ParentFont = False
    Style.BorderStyle = ebsUltraFlat
    Style.Font.Charset = ANSI_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -11
    Style.Font.Name = 'Arial'
    Style.Font.Style = []
    Style.LookAndFeel.Kind = lfUltraFlat
    Style.IsFontAssigned = True
    StyleDisabled.LookAndFeel.Kind = lfUltraFlat
    StyleFocused.LookAndFeel.Kind = lfUltraFlat
    StyleHot.LookAndFeel.Kind = lfUltraFlat
    Height = 17
    Width = 105
  end
  object NomEmis: TcxTextEdit
    Left = 128
    Top = 17
    Enabled = False
    ParentFont = False
    Style.Font.Charset = ANSI_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -12
    Style.Font.Name = 'Courier New'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    StyleDisabled.TextColor = clBlack
    TabOrder = 2
    Text = '...'
    OnExit = NomEmisExit
    Width = 287
  end
  object btnC: TcxButton
    Left = 107
    Top = 18
    Width = 20
    Height = 20
    Caption = 'C'
    Colors.Default = 16773847
    Colors.Hot = 16764778
    TabOrder = 3
    OnClick = btnCClick
  end
end
