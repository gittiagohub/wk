object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 'Lan'#231'amento e Consula de Pedidos'
  ClientHeight = 474
  ClientWidth = 674
  Color = clBtnFace
  Constraints.MaxHeight = 570
  Constraints.MaxWidth = 700
  Constraints.MinHeight = 500
  Constraints.MinWidth = 650
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PanelPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 674
    Height = 474
    Align = alClient
    BorderWidth = 5
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 0
    object GroupBoxPrincipal: TGroupBox
      Left = 6
      Top = 6
      Width = 662
      Height = 462
      Align = alClient
      Caption = 'Lan'#231'amento e Consulta de Pedidos'
      Color = clSkyBlue
      ParentBackground = False
      ParentColor = False
      TabOrder = 0
      DesignSize = (
        662
        462)
      object GroupBoxCliente: TGroupBox
        Left = 18
        Top = 76
        Width = 624
        Height = 61
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Cliente'
        TabOrder = 1
        DesignSize = (
          624
          61)
        object LabelCodCliente: TLabel
          Left = 24
          Top = 15
          Width = 33
          Height = 13
          Caption = 'C'#243'digo'
        end
        object LabelCliente: TLabel
          Left = 181
          Top = 13
          Width = 33
          Height = 13
          Caption = 'Cliente'
        end
        object ButtonConsultarCliente: TButton
          Left = 464
          Top = 13
          Width = 149
          Height = 36
          Anchors = [akTop, akRight]
          Caption = 'ConsultarCliente'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = ButtonConsultarClienteClick
        end
        object DBEditCodCliente: TEdit
          Left = 20
          Top = 32
          Width = 133
          Height = 21
          NumbersOnly = True
          TabOrder = 0
          OnChange = DBEditCodClienteChange
        end
        object DBEditCliente: TEdit
          Left = 180
          Top = 32
          Width = 133
          Height = 21
          ReadOnly = True
          TabOrder = 1
        end
      end
      object GroupBoxProduto: TGroupBox
        Left = 18
        Top = 136
        Width = 625
        Height = 65
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Produto'
        TabOrder = 2
        object LabelCodigoProduto: TLabel
          Left = 24
          Top = 16
          Width = 33
          Height = 13
          Caption = 'C'#243'digo'
        end
        object LabelDescricao: TLabel
          Left = 100
          Top = 16
          Width = 46
          Height = 13
          Caption = 'Descri'#231#227'o'
        end
        object LabelQtde: TLabel
          Left = 255
          Top = 16
          Width = 56
          Height = 13
          Caption = 'Quantidade'
        end
        object LabelValorUnitario: TLabel
          Left = 407
          Top = 16
          Width = 64
          Height = 13
          Caption = 'Valor Unit'#225'rio'
        end
        object DBEditCodigo: TEdit
          Left = 24
          Top = 35
          Width = 49
          Height = 21
          TabOrder = 0
          OnExit = DBEditCodigoExit
        end
        object DBEditDescricao: TEdit
          Left = 100
          Top = 35
          Width = 133
          Height = 21
          ReadOnly = True
          TabOrder = 1
        end
        object DBEditValorUnitario: TEdit
          Left = 407
          Top = 35
          Width = 67
          Height = 21
          TabOrder = 3
        end
        object DBEditQuantidade: TEdit
          Left = 255
          Top = 35
          Width = 133
          Height = 21
          TabOrder = 2
        end
        object ButtonConfirmar: TButton
          Left = 480
          Top = 31
          Width = 94
          Height = 25
          Caption = 'Confirmar'
          TabOrder = 4
          OnClick = ButtonConfirmarClick
        end
      end
      object GroupBoxItens: TGroupBox
        Left = 2
        Top = 218
        Width = 658
        Height = 177
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Itens'
        TabOrder = 3
        object DBGridItens: TDBGrid
          Left = 2
          Top = 15
          Width = 654
          Height = 160
          Align = alClient
          DataSource = DataSourcePedidoItem
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnKeyDown = DBGridItensKeyDown
          Columns = <
            item
              Expanded = False
              FieldName = 'codigo_produto'
              Title.Caption = 'C'#243'digo'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'descricao'
              Title.Caption = 'Descri'#231#227'o'
              Width = 240
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'quantidade'
              Title.Caption = 'Quantidade'
              Width = 81
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'vl_unitario'
              Title.Caption = 'Vlr. Unit'#225'rio'
              Width = 93
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'vl_total'
              Title.Caption = 'Vlr. Total'
              Width = 105
              Visible = True
            end>
        end
      end
      object GroupBoxTotalPedido: TGroupBox
        Left = 2
        Top = 395
        Width = 658
        Height = 65
        Align = alBottom
        TabOrder = 4
        object LabelVlTotalPedido: TLabel
          Left = 142
          Top = 25
          Width = 105
          Height = 13
          Caption = 'Valor Total do Pedido:'
        end
        object LabelVLTotal: TLabel
          Left = 253
          Top = 25
          Width = 38
          Height = 13
          Caption = 'R$ 0,00'
        end
        object ButtonGravarPedido: TButton
          Left = 521
          Top = 21
          Width = 80
          Height = 25
          Caption = 'Gravar Pedido'
          TabOrder = 0
          OnClick = ButtonGravarPedidoClick
        end
      end
      object GroupBoxPedido: TGroupBox
        Left = 19
        Top = 15
        Width = 624
        Height = 59
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Pedido'
        TabOrder = 0
        DesignSize = (
          624
          59)
        object LabelNumeroPedido: TLabel
          Left = 23
          Top = 14
          Width = 37
          Height = 13
          Caption = 'N'#250'mero'
        end
        object LabelDataEmissao: TLabel
          Left = 180
          Top = 11
          Width = 64
          Height = 13
          Caption = 'Data Emiss'#227'o'
        end
        object ButtonConsultarPedido: TButton
          Left = 464
          Top = 13
          Width = 149
          Height = 36
          Anchors = [akTop, akRight]
          Caption = 'Consultar Pedido'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = ButtonConsultarPedidoClick
        end
        object EditNumeroPedido: TEdit
          Left = 20
          Top = 30
          Width = 133
          Height = 21
          NumbersOnly = True
          TabOrder = 0
          OnChange = EditNumeroPedidoChange
        end
        object EditDataEmissao: TEdit
          Left = 180
          Top = 30
          Width = 133
          Height = 21
          ReadOnly = True
          TabOrder = 1
        end
        object ButtonApagarPedido: TButton
          Left = 362
          Top = 13
          Width = 96
          Height = 36
          Anchors = [akTop, akRight]
          Caption = 'Apagar Pedido'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = ButtonApagarPedidoClick
        end
      end
    end
  end
  object FDMemTablePedidoItem: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'codigo_produto'
        DataType = ftInteger
      end
      item
        Name = 'descricao'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'quantidade'
        DataType = ftFloat
      end
      item
        Name = 'vl_unitario'
        DataType = ftCurrency
        Precision = 19
      end
      item
        Name = 'vl_total'
        DataType = ftCurrency
        Precision = 19
      end
      item
        Name = 'auto_incremento'
        DataType = ftInteger
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 482
    Top = 276
    object FDMemTablePedidoItemcodigo_produto: TIntegerField
      FieldName = 'codigo_produto'
    end
    object FDMemTablePedidoItemdescricao: TStringField
      FieldName = 'descricao'
      Size = 200
    end
    object FDMemTablePedidoItemquantidade: TFloatField
      FieldName = 'quantidade'
    end
    object FDMemTablePedidoItemvl_unitario: TCurrencyField
      FieldName = 'vl_unitario'
    end
    object FDMemTablePedidoItemvl_total: TCurrencyField
      FieldName = 'vl_total'
    end
    object FDMemTablePedidoItemauto_incremento: TIntegerField
      FieldName = 'auto_incremento'
    end
  end
  object DataSourcePedidoItem: TDataSource
    DataSet = FDMemTablePedidoItem
    Left = 418
    Top = 276
  end
end
