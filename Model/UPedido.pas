unit UPedido;

interface

uses
  System.Generics.Collections, UIPedido, UIPedidoItem,UPedidoItem;

type
  TPedido = class(TInterfacedObject, IPedido)
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDate;
    FListaItens: Tlist<IPedidoItem>;
    FValorTotal: Currency;
    FCliente : String;
    FCodCliente : Integer;
  public
    constructor Create(ANumeroPedido: Integer; ADataEmissao: TDate;
                       ACodCliente : Integer; ACliente : String ='');

    destructor Destroy; override;
    procedure AdicionarItem(APedidoItem: IPedidoItem); overload ;
    procedure AdicionarItem(APedidoItem: Tlist<IPedidoItem>); overload;
    function GetNumeroPedido: Integer;
    function GetDataEmissao: TDate;
    function GetValorTotal: Currency;
    function GetCliente: String;
    function GetCodCliente: Integer;
    function GetListaItens: TList<IPedidoItem>;
  end;

implementation

{ TPedido }

procedure TPedido.AdicionarItem(APedidoItem: Tlist<IPedidoItem>);
begin
     FListaItens := APedidoItem;
end;

constructor TPedido.Create(ANumeroPedido: Integer; ADataEmissao: TDate;
                           ACodCliente : Integer; ACliente : String);
begin
     FNumeroPedido := ANumeroPedido;
     FDataEmissao  := ADataEmissao;
     FCliente      := ACliente;
     FCodCliente   := ACodCliente;
     FListaItens   := TList<IPedidoItem>.Create;
end;

destructor TPedido.Destroy;
begin
    FListaItens.Free;
    inherited;
end;

procedure TPedido.AdicionarItem(APedidoItem: IPedidoItem);
begin
     FListaItens.Add(APedidoItem);
     FValorTotal := FValorTotal + APedidoItem.VlTotal;
end;

function TPedido.GetNumeroPedido: Integer;
begin
     Result := FNumeroPedido;
end;

function TPedido.GetCliente: String;
begin
     Result := FCliente;
end;

function TPedido.GetCodCliente: Integer;
begin
     Result := FCodCliente;
end;

function TPedido.GetDataEmissao: TDate;
begin
     Result := FDataEmissao;
end;

function TPedido.GetListaItens: Tlist<IPedidoItem>;
begin
     Result:= FListaItens;
end;

function TPedido.GetValorTotal: Currency;
begin
     Result := FValorTotal;
end;

end.

