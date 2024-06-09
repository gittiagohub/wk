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
       function BuscaProduto(ACodProduto : Integer;
                             var AEditDescricao,AEditValorUnitario: TEdit) : TRetorno;

       function BuscaCliente(ACodCliente : Integer;
                            AEditCodCliente, AEditNome: TEdit) : TRetorno;

       function BuscaPedido(ACodPedido: Integer;
                            AEditNumeroPedido,
                            AEditDataEmissao,AEditCodCliente,AEditCliente : TEdit;
                            ALabelTotal: TLabel;
                            AMemTablePedidoItens :TFDMemTable) : TRetorno;

       function GravaPedido(ACodPedido,ACodCliente: Integer;
                            aMemTablePedidoItens :TFDMemTable;
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
     except on E: Exception do
        begin
             Result.OK := False;
             Result.Mensagem :='Erro: '+E.Message;
        end;
     end
end;

function TClientAcess.BuscaCliente(ACodCliente: Integer;
                                   AEditCodCliente, AEditNome: TEdit): TRetorno;
var lClienteController : iClienteController;
    lCliente : iCliente;
begin
     Result.OK := False;
     lClienteController := TClienteController.Create;
     try
        lCliente := lClienteController.GetCliente(ACodCliente);

        if not Assigned(lCliente) then
        begin
             Result.OK := False;
             Result.Mensagem := 'Cliente '+ACodCliente.ToString + ' não encontrado.';
             Exit;
        end;

        AEditCodCliente.Text := ACodCliente.ToString;
        AEditNome.Text := lCliente.Nome;

        Result.OK      := True;
     except on E: Exception do
        begin
             Result.OK := False;
             Result.Mensagem :='Erro ao Buscar Cliente: '+E.Message;
        end;
     end;
end;

function TClientAcess.BuscaPedido(ACodPedido: Integer;
                                  AEditNumeroPedido,
                                  AEditDataEmissao,AEditCodCliente,AEditCliente : TEdit;
                                  ALabelTotal: TLabel;
                                  AMemTablePedidoItens :TFDMemTable): TRetorno;
var
  LListPedidoitem : TList<IPedidoItem>;
  LPedidoitem : IPedidoItem;
  LPedidoController : IPedidoController;
  LPedido : IPedido;
begin
     LPedidoController := TPedidoController.Create;
     LPedido           := LPedidoController.GetPedido(ACodPedido);

     if not Assigned(LPedido) then
     begin
          Result.Ok := False;
          Result.Mensagem :='O Pedido '+ACodPedido.toString+' não foi encontrado.';
          Exit;
     end;

     AEditNumeroPedido.Text := ACodPedido.toString;
     AEditCodCliente.Text   := LPedido.GetCodCliente.ToString;
     AEditCliente.Text      := LPedido.GetCliente;
     AEditDataEmissao.Text  := DateToStr(LPedido.DataEmissao);
     ALabelTotal.Caption    := FloatToStr(LPedido.GetValorTotal);

     LListPedidoitem := LPedido.GetListaItens();
     aMemTablePedidoItens.EmptyDataSet;

     for LPedidoitem in LListPedidoitem do
     begin
          with aMemTablePedidoItens do
          begin
               Append;
               FieldByName('codigo_produto').AsInteger  := LPedidoitem.CodigoProduto;
               FieldByName('descricao').AsString        := LPedidoitem.Descricao;
               FieldByName('quantidade').AsFloat        := LPedidoitem.Quantidade;
               FieldByName('vl_unitario').AsCurrency    := LPedidoitem.VlUnitario;
               FieldByName('vl_total').AsCurrency       := LPedidoitem.VlTotal;
               FieldByName('auto_incremento').AsInteger := LPedidoitem.AutoIncrem;
               Post
          end;
     end;

     Result.Ok := True;
end;

function TClientAcess.BuscaProduto(ACodProduto : integer;
                                   var AEditDescricao,AEditValorUnitario: TEdit): TRetorno;
var lProdutoController : iProdutoController;
    lProduto : iProduto;
begin
     Result.OK := True;
     lProdutoController := TProdutoController.Create;
     try
        lProduto := lProdutoController.GetProduto(ACodProduto);

        if not Assigned(lProduto) then
        begin
             Result.OK := False;
             Result.Mensagem := 'Cliente '+ACodProduto.ToString + ' não encontrado.';
             Exit;
        end;

        AEditDescricao.Text := lProduto.Descricao;
        AEditValorUnitario.Text := FloatToStr(lProduto.PrecoVenda);

     except on E: Exception do
        begin
             Result.OK := False;
             Result.Mensagem :='Erro: '+E.Message;
        end;
     end;
end;

function TClientAcess.GravaPedido(ACodPedido,ACodCliente: Integer;
                                  AMemTablePedidoItens :TFDMemTable;
                                  AApagaItens : TStringList): TRetorno;
var LPedidoController  : IPedidoController;
    LPedido            : IPedido;
    LPedidoItem        : IPedidoItem;
    lNumeroPedido      : Integer;
    I                  : Integer;
    LPedidoItensApagar : TList<IPedidoItem>;
begin
     if ACodCliente <= 0 then
     begin
          Result.OK := False;
          Result.Mensagem :='Insira o Cliente Para Gravar o Pedido.';
          Exit;
     end;

     if aMemTablePedidoItens.isEmpty then
     begin
          Result.OK := False;
          Result.Mensagem :='Insira Pelo Menos um Item Para Salva o Pedido.';
          Exit;
     end;

     try
        LPedido := TPedido.Create(ACodPedido,Date,ACodCliente);

        aMemTablePedidoItens.First;

        while not(aMemTablePedidoItens.Eof) do
        begin
             LPedidoItem := TPedidoItem.Create(ACodPedido,
                                               aMemTablePedidoItens.FieldByName('codigo_produto').AsInteger,
                                               aMemTablePedidoItens.FieldByName('quantidade').AsFloat,
                                               aMemTablePedidoItens.FieldByName('descricao').AsString,
                                               aMemTablePedidoItens.FieldByName('VL_unitario').AsCurrency,
                                               aMemTablePedidoItens.FieldByName('auto_incremento').AsInteger);

             LPedido.AdicionarItem(LPedidoItem);
             aMemTablePedidoItens.Next;
        end;

        LPedidoController := TPedidoController.Create;
        lNumeroPedido     := LPedidoController.SalvarPedido(LPedido);

        if lNumeroPedido = 0 then
        begin
             Result.OK := False;
             Result.Mensagem :='Erro ao Salvar o Pedido ';
             Exit;
        end;

        if AApagaItens.Count > 0 then
        begin
             LPedidoItensApagar := TList<IPedidoItem>.Create;
             for I := 0 to AApagaItens.Count - 1 do
             begin
                   LPedidoItensApagar.Add(TPedidoItem.Create(ACodPedido,
                                                             AApagaItens[i].ToInteger()));
             end;

             LPedidoController.ApagarPedidoItens(LPedidoItensApagar);

             AApagaItens.Clear;
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
