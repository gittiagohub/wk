unit UIPedidoItem;

interface

type
  IPedidoItem = interface
  ['{1DA6C4DC-2C2C-4D5B-8C07-BEEF56FD7CD0}']
    function GetAutoIncrem: Integer;
    function GetNumeroPedido: Integer;
    function GetCodigoProduto: Integer;
    function GetQuantidade: double;
    function GetDescricao: String;
    function GetVlUnitario: Currency;
    function GetVlTotal: Currency;

    property AutoIncrem: Integer read GetAutoIncrem;
    property NumeroPedido: Integer read GetNumeroPedido;
    property CodigoProduto: Integer read GetCodigoProduto;
    property Descricao: String read GetDescricao;
    property Quantidade: double read GetQuantidade;
    property VlUnitario: Currency read GetVlUnitario;
    property VlTotal: Currency read GetVlTotal;

  end;

implementation

end.

