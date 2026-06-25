object ChartDatabaseMainView: TChartDatabaseMainView
  Left = 0
  Top = 0
  Caption = 'TMS FNC Chart - Database'
  ClientHeight = 723
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  TextHeight = 15
  object pnCorpo: TPanel
    Left = 0
    Top = 0
    Width = 581
    Height = 723
    Align = alClient
    TabOrder = 0
    object TMSFNCChart1: TTMSFNCChart
      Left = 1
      Top = 1
      Width = 579
      Height = 624
      Appearance.ColorList = <
        item
          Color = 16105559
        end
        item
          Color = 5644279
        end
        item
          Color = 7936771
        end
        item
          Color = 12275349
        end
        item
          Color = 1296366
        end
        item
          Color = 4350195
        end
        item
          Color = 16544551
        end
        item
          Color = 5820321
        end
        item
          Color = 10922240
        end
        item
          Color = 16376965
        end>
      Appearance.GlobalFont.Color = -1
      Appearance.GlobalFont.Name = 'Segoe UI'
      Appearance.GlobalFont.Scale = 1.000000000000000000
      Appearance.GlobalFont.Style = []
      Appearance.ColorScheme = ccsColorList
      Appearance.MonochromeColor = clSteelblue
      ClickMargin = 10.000000000000000000
      InteractionOptions.ShowEditors = True
      InteractionOptions.ShowEditorTypes = [etLegend, etSeries, etTitle, etXAxis, etYAxis, etGeneral]
      Legend.Fill.Kind = gfkSolid
      Legend.Fill.Color = clWhite
      Legend.Stroke.Kind = gskSolid
      Legend.Font.Charset = DEFAULT_CHARSET
      Legend.Font.Color = -1
      Legend.Font.Height = -12
      Legend.Font.Name = 'Segoe UI'
      Legend.Font.Style = []
      Legend.Left = 10.000000000000000000
      Legend.Top = 10.000000000000000000
      Interaction = False
      SeriesMargins.Left = 0
      SeriesMargins.Top = 0
      SeriesMargins.Right = 0
      SeriesMargins.Bottom = 0
      Series = <>
      Title.Stroke.Kind = gskSolid
      Title.Font.Charset = DEFAULT_CHARSET
      Title.Font.Color = -1
      Title.Font.Height = -12
      Title.Font.Name = 'Segoe UI'
      Title.Font.Style = []
      Title.Height = 35.000000000000000000
      Title.TextMargins.Left = 3
      Title.TextMargins.Top = 3
      Title.TextMargins.Right = 3
      Title.TextMargins.Bottom = 3
      Title.Text = 'Relat'#243'rio de vendas por dia'
      XAxis.Stroke.Kind = gskSolid
      XAxis.Height = 35.000000000000000000
      YAxis.Stroke.Kind = gskSolid
      YAxis.Width = 35.000000000000000000
      Adapter = TMSFNCChartDatabaseAdapter1
      DefaultLoadOptions.XValuesFormatString = '%.0f'
      DefaultLoadOptions.YValuesFormatString = '%.2f'
      DefaultLoadOptions.MaxYOffsetPercentage = 5.000000000000000000
      Align = alClient
      ParentDoubleBuffered = False
      DoubleBuffered = True
      TabStop = False
      ParentColor = True
      TabOrder = 0
    end
    object pnBotoes: TPanel
      Left = 1
      Top = 625
      Width = 579
      Height = 97
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 147
        Height = 97
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object lbStatusDataBase: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 39
          Width = 141
          Height = 15
          Align = alTop
          Alignment = taCenter
          Caption = 'Desconectado'
          ExplicitWidth = 75
        end
        object btnAbrir: TBitBtn
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 141
          Height = 30
          Cursor = crHandPoint
          Align = alTop
          Caption = 'Conectar / desconectatar'
          TabOrder = 0
          OnClick = btnAbrirClick
        end
      end
      object Panel4: TPanel
        Left = 147
        Top = 0
        Width = 185
        Height = 97
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object lbChartType: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 1
          Width = 177
          Height = 15
          Margins.Left = 5
          Margins.Top = 1
          Margins.Bottom = 2
          Align = alTop
          Caption = 'ChartType'
          ExplicitWidth = 54
        end
        object lbEsquemaCores: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 44
          Width = 177
          Height = 15
          Margins.Left = 5
          Margins.Top = 2
          Margins.Bottom = 2
          Align = alTop
          Caption = 'Esquema de cores'
          ExplicitWidth = 95
        end
        object cBoxChartType: TComboBox
          AlignWithMargins = True
          Left = 3
          Top = 18
          Width = 179
          Height = 23
          Margins.Top = 0
          Margins.Bottom = 1
          Align = alTop
          Style = csDropDownList
          DropDownCount = 19
          TabOrder = 0
          OnChange = btnAplicarAlteracoesClick
        end
        object cBoxEsquemaCores: TComboBox
          AlignWithMargins = True
          Left = 3
          Top = 61
          Width = 179
          Height = 23
          Margins.Top = 0
          Margins.Bottom = 1
          Align = alTop
          Style = csDropDownList
          DropDownCount = 19
          TabOrder = 1
          OnChange = btnAplicarAlteracoesClick
        end
      end
      object Panel5: TPanel
        Left = 332
        Top = 0
        Width = 123
        Height = 97
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 2
        object btnAplicarAlteracoes: TBitBtn
          AlignWithMargins = True
          Left = 3
          Top = 47
          Width = 117
          Height = 22
          Cursor = crHandPoint
          Align = alTop
          Caption = 'Aplicar altera'#231#245'es'
          TabOrder = 0
          OnClick = btnAplicarAlteracoesClick
        end
        object ckMostrarMarcador: TCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 117
          Height = 17
          Cursor = crHandPoint
          Margins.Bottom = 1
          Align = alTop
          Caption = 'Mostrar marcador'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object ckMostrarLabels: TCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 117
          Height = 17
          Cursor = crHandPoint
          Align = alTop
          Caption = 'Mostrar label'
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clChartreuse
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 2
        end
      end
      object Panel6: TPanel
        Left = 455
        Top = 0
        Width = 124
        Height = 97
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 3
        object btnConfigurarGrafico: TBitBtn
          AlignWithMargins = True
          Left = 3
          Top = 72
          Width = 118
          Height = 22
          Cursor = crHandPoint
          Margins.Top = 0
          Margins.Bottom = 1
          Align = alTop
          Caption = 'Configurar gr'#225'fico'
          TabOrder = 0
          OnClick = btnConfigurarGraficoClick
        end
        object btnSalvarGrafico: TButton
          AlignWithMargins = True
          Left = 3
          Top = 49
          Width = 118
          Height = 22
          Cursor = crHandPoint
          Margins.Top = 0
          Margins.Bottom = 1
          Align = alTop
          Caption = 'Salvar gr'#225'fico'
          TabOrder = 1
          OnClick = btnSalvarGraficoClick
        end
        object btnModoDark: TButton
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 118
          Height = 22
          Cursor = crHandPoint
          Margins.Top = 0
          Margins.Bottom = 1
          Align = alTop
          Caption = 'Modo Dark'
          TabOrder = 2
          OnClick = btnModoDarkClick
        end
        object btnModoLight: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 118
          Height = 22
          Cursor = crHandPoint
          Margins.Bottom = 1
          Align = alTop
          Caption = 'Modo Light'
          TabOrder = 3
          OnClick = btnModoLightClick
        end
      end
    end
  end
  object TMSFNCChartDatabaseAdapter1: TTMSFNCChartDatabaseAdapter
    Left = 358
    Top = 510
    Width = 26
    Height = 26
    Visible = True
    AutoCreateSeries = False
    Source.DataSource = DataSource1
    Source.Series = <>
    OnFieldsToSeries = TMSFNCChartDatabaseAdapter1FieldsToSeries
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 142
    Top = 506
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 225
    Top = 506
  end
end
