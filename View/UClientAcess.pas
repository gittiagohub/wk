unit UClientAcess;

interface

uses
  Vcl.StdCtrls, URetorno, FireDAC.Comp.Client, UIPedido, System.Classes;
   type
       TClientAcess = class
       private
        { private declarations }
       protected
        { protected declarations }
       public
       function BuscaProduto(ACodProduto : Integer) : TRetornoProduto;

       function BuscaCliente(ACodCliente : Integer) : TRetornoCliente;

       function BuscaPedido(ACodPedido: Integer) : TRetornoPedido;

       function GravaPedido(APedido : IPedido;
                            AApagaItens : TStringList) : TRetorno;

       function ApagarPedido(ACodPedido : Integer) : TRetorno;

        { public declarations }

       published
        { published declarations }
       end;

implementation

uses
  UIProduto, UProdutoController, UIProdutoController, System.SysUtils,
  UIClienteController, UICliente, UClienteController,
  System.Generics.Collections, UIPedidoItem, UPedidoController,
  UIPedidoController, UPedido, UPedidoItem;

{ TClinetAcess }

function TClientAcess.ApagarPedido(ACodPedido : Integer): TRetorno;
var
  LPedidoController: IPedidoController;
begin
     try
        LPedidoController := TPedidoController.Create;

        Result.OK := LPedidoController.ApagarPedido(ACodPedido);

        if not(Result.OK) then
        begin
             Result.Mensagem :='O Pedido '+ACodPedido.ToString+
                               ' Não Foi Encontrado.'
        end;

     except on E: Exception do
        begin
             Result.OK := False;
             Result.Mensagem :='Erro: '+E.Message;
        end;
     end
end;

function TClientAcess.BuscaCliente(ACodCliente: Integer): TRetornoCliente;
var lClienteController : iClienteController;
begin
     with Result do
     begin
          Retorno.OK := False;
          lClienteController := TClienteController.Create;
          try
             Result.Cliente := lClienteController.GetCliente(ACodCliente);

             if not Assigned(Result.Cliente) then
             begin
                  Retorno.OK := False;
                  Retorno.Mensagem := 'Cliente '+ACodCliente.ToString + ' não encontrado.';
                  Exit;
             end;

             Retorno.OK := True;
          except on E: Exception do
             begin
                  Retorno.OK := False;
                  Retorno.Mensagem :='Erro ao Buscar Cliente: '+E.Message;
             end;
          end;
     end;
end;

function TClientAcess.BuscaPedido(ACodPedido: Integer): TRetornoPedido;
var
  LPedidoController : IPedidoController;
  LPedido : IPedido;
begin
     with Result do
     begin
          try
             Retorno.OK := False;
             Retorno.Mensagem :='Falha Ao Buscar Pedido. ';

             LPedidoController := TPedidoController.Create;
             LPedido           := LPedidoController.GetPedido(ACodPedido);

             if not Assigned(LPedido) then
             begin
                  Retorno.Mensagem :='O Pedido '+ACodPedido.toString+' não foi encontrado.';
                  Exit;
             end;

             Result.Pedido := LPedido;
             Retorno.Ok := True;

             except on E: Exception do
             begin
                  Retorno.OK := False;
                  Retorno.Mensagem :='Erro Ao Buscar Pedido: '+E.Message;
             end;
          end;
     end;
end;

function TClientAcess.BuscaProduto(ACodProduto : integer): TRetornoProduto;
var lProdutoController : iProdutoController;
    lProduto : iProduto;
begin
     with Result do
     begin
          Retorno.OK := True;
          lProdutoController := TProdutoController.Create;
          try
             lProduto := lProdutoController.GetProduto(ACodProduto);

             if not Assigned(lProduto) then
             begin
                  Retorno.OK := False;
                  Retorno.Mensagem := 'Cliente '+ACodProduto.ToString + ' não encontrado.';
                  Exit;
             end;

             Retorno.OK := True;

             Produto :=  lProduto;


          except on E: Exception do
             begin
                  Retorno.OK := False;
                  Retorno.Mensagem :='Erro: '+E.Message;
             end;
          end;
     end;
end;

function TClientAcess.GravaPedido(APedido : IPedido;
                                  AApagaItens : TStringList): TRetorno;
var LPedidoController  : IPedidoController;
    lNumeroPedido      : Integer;
    I                  : Integer;
    LPedidoItensApagar : TList<IPedidoItem>;
begin
     if APedido.GetCodCliente <= 0 then
     begin
          Result.OK := False;
          Result.Mensagem :='Insira o Cliente Para Gravar o Pedido.';
          Exit;
     end;

     if APedido.GetListaItens.Count = 0 then
     begin
          Result.OK := False;
          Result.Mensagem :='Insira Pelo Menos um Item Para Salva o Pedido.';
          Exit;
     end;

     try
        LPedidoItensApagar := TList<IPedidoItem>.Create;

        if AApagaItens.Count > 0 then
        begin
             for I := 0 to AApagaItens.Count - 1 do
             begin
                  LPedidoItensApagar.Add(TPedidoItem.Create(APedido.NumeroPedido,
                                                            AApagaItens[i].ToInteger()));
             end;

             AApagaItens.Clear;
        end;

        LPedidoController := TPedidoController.Create;
        lNumeroPedido     := LPedidoController.SalvarPedido(APedido,
                                                            LPedidoItensApagar);

        if lNumeroPedido = 0 then
        begin
             Result.OK := False;
             Result.Mensagem :='Erro ao Salvar o Pedido ';
             Exit;
        end;

        Result.OK       := True;
        Result.Codigo   := lNumeroPedido;

     except on E: Exception do
          begin
               Result.OK := False;
               Result.Mensagem :=E.Message;
          end;
     end;
end;

end.
