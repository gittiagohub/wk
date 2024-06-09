unit UPedidoItem;

interface

uses
  UIPedidoItem;

type
  TPedidoItem = class(TInterfacedObject, IPedidoItem)
  private
    FAutoIncrem: Integer;
    FNumeroPedido: Integer;
    FCodigoProduto: Integer;
    FDescricao: string;
    FQuantidade: double;
    FVlUnitario: Currency;
    FVlTotal: Currency;
  public
    constructor Create(ANumeroPedido, ACodigoProduto : Integer; AQuantidade: Double;
                       ADescricao : String; AVlUnitario: Currency;
                       AAutoIncrem : Integer = 0); overload;

    constructor Create(ANumeroPedido,AAutoIncrem : Integer); overload;

    function GetAutoIncrem: Integer;
    function GetNumeroPedido: Integer;
    function GetCodigoProduto: Integer;
    function GetQuantidade: double;
    function GetDescricao: String;
    function GetVlUnitario: Currency;
    function GetVlTotal: Currency;
  end;

implementation

{ TPedidoItem }

constructor TPedidoItem.Create(ANumeroPedido, ACodigoProduto : Integer; AQuantidade: Double;
                               ADescricao : String; AVlUnitario: Currency;
                               AAutoIncrem : Integer);
begin
     FNumeroPedido  := ANumeroPedido;
     FCodigoProduto := ACodigoProduto;
     FQuantidade    := AQuantidade;
     FDescricao     := ADescricao;
     FVlUnitario    := AVlUnitario;
     FVlTotal       := AQuantidade * AVlUnitario;
     FAutoIncrem    := AAutoIncrem;
end;

constructor TPedidoItem.Create(ANumeroPedido, AAutoIncrem: Integer);
begin
     FNumeroPedido  := ANumeroPedido;
     FAutoIncrem    := AAutoIncrem;
end;

function TPedidoItem.GetAutoIncrem: Integer;
begin
     Result := FAutoIncrem;
end;

function TPedidoItem.GetCodigoProduto: Integer;
begin
     Result := FCodigoProduto;
end;

function TPedidoItem.GetDescricao: String;
begin
     Result := FDescricao;
end;

function TPedidoItem.GetNumeroPedido: Integer;
begin
     Result := FNumeroPedido;
end;

function TPedidoItem.GetQuantidade: double;
begin
     Result := FQuantidade;
end;

function TPedidoItem.GetVlTotal: Currency;
begin
     Result := FVlTotal;
end;

function TPedidoItem.GetVlUnitario: Currency;
begin
     Result := FVlUnitario;
end;

end.

