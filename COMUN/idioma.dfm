object lan: Tlan
  Left = 807
  Top = 186
  BorderIcons = []
  BorderStyle = bsToolWindow
  ClientHeight = 238
  ClientWidth = 144
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 2
    Top = 64
    Width = 140
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'Pulse [Esc] para salir.'
  end
  object login: TcxPropertiesStore
    Active = False
    Components = <
      item
        Properties.Strings = (
          'ActiveLanguage')
      end>
    StorageName = 'cnf_idioma'
    Left = 104
    Top = 104
  end
end
