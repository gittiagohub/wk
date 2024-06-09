unit UIPedido;

interface

uses
  UIPedidoItem, System.Generics.Collections;
type
  IPedido = interface
    ['{5ABD7B17-AE4D-4E01-AF79-2FAB826D7CEA}']
    function GetNumeroPedido: Integer;
    function GetDataEmissao: TDate;
    function GetValorTotal: Currency;
    function GetCliente: String;
    function GetCodCliente: Integer;
    function GetListaItens: TList<IPedidoItem>;

    procedure AdicionarItem(APedidoItem: IPedidoItem); overload ;
    procedure AdicionarItem(APedidoItem: Tlist<IPedidoItem>); overload;

    property NumeroPedido: Integer read GetNumeroPedido;
    property DataEmissao: TDate read GetDataEmissao;
    property ValorTotal: Currency read GetValorTotal;
  end;

implementation

end.

