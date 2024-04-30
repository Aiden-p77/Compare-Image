object FMain: TFMain
  Left = 0
  Top = 0
  AutoSize = True
  Caption = 'FMain'
  ClientHeight = 541
  ClientWidth = 787
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 390
    Height = 217
    IncrementalDisplay = True
    Proportional = True
    Stretch = True
  end
  object Image2: TImage
    Left = 397
    Top = 0
    Width = 390
    Height = 217
    IncrementalDisplay = True
    Proportional = True
    Stretch = True
  end
  object DifImg: TImage
    Left = 279
    Top = 298
    Width = 243
    Height = 243
    Stretch = True
  end
  object LResult: TLabel
    Left = 381
    Top = 279
    Width = 35
    Height = 13
    Alignment = taCenter
    Caption = 'LResult'
  end
  object Label1: TLabel
    Left = 200
    Top = 298
    Width = 73
    Height = 13
    Caption = 'Difficult Image:'
  end
  object Button1: TButton
    Left = 64
    Top = 223
    Width = 209
    Height = 42
    Caption = 'Open Image'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 528
    Top = 223
    Width = 179
    Height = 42
    Caption = 'Open Image'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button7: TButton
    Left = 279
    Top = 223
    Width = 243
    Height = 25
    Caption = 'Compare By Memery Stream'
    TabOrder = 2
    OnClick = Button7Click
  end
  object Button3: TButton
    Left = 279
    Top = 248
    Width = 243
    Height = 25
    Caption = 'Compare By ScanLine'
    TabOrder = 3
    OnClick = Button3Click
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 32
    Top = 224
  end
end
