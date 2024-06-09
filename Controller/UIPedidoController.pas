unit UIPedidoController;

interface

uses
    UIPedido, System.Generics.Collections, UIPedidoItem;
 type
  IPedidoController = interface
    ['{02FF2863-0A1F-4D88-AFB6-D96730412F6C}']
    function GetPedido(ACodigo: Integer): IPedido;
    function SalvarPedido(APedido: IPedido): Integer;
    function ApagarPedidoItens(APedidoItens: TList<IPedidoItem>): Boolean;
    function ApagarPedido(ACodigo: Integer): Boolean;
  end;

implementation

end.

