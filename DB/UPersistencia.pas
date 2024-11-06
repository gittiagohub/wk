unit UPersistencia;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB,UIConfig,UConfig,
  UIConnection,UConnection,UPedido,UIPedido,UPedidoItem, UIPedidoItem,
  UProduto, UIProduto, UCliente, UICliente,FireDAC.Comp.Client, Winapi.Windows,
  System.Generics.Collections;

type
  TPersistencia = class
  private
    FConexao: iConnection;
    FQuery: TFDQuery;
    function ConsultarPedidoItens(NumeroPedido: Integer): TList<IPedidoItem>;
    function SalvarPedidoItem(APedido : Integer ; APedidoItem: IPedidoItem) : Boolean;
  public
    constructor Create();
    destructor Destroy; override;

    function SalvarPedido(APedido: IPedido;
                          AItensApagar: TList<IPedidoItem>): Integer;

    function ConsultarPedido(NumeroPedido: Integer): IPedido;
    function ConsultarProduto(ACodigo: Integer): IProduto;
    function ConsultarCliente(ACodigo: Integer): ICliente;

    function ApagarPedidoItens(APedidoItens: TList<IPedidoItem>): Boolean;
    function ApagarPedido(ACodigo: Integer): Boolean;
  end;

implementation

uses
  Vcl.Dialogs;

{ TPersistencia }

function TPersistencia.ConsultarProduto(ACodigo: Integer): IProduto;
var LSQl : String;
begin
     try
        LSQl := 'SELECT codigo, descricao, preco_venda '+
                ' FROM produto WHERE codigo = :Codigo';

        FQuery.SQL.Text := LSQl;
        FQuery.ParamByName('Codigo').Value := ACodigo;
        FQuery.Open;

        if not FQuery.Eof then
        begin
             Result := TProduto.Create(FQuery.FieldByName('codigo').AsInteger,
                                       FQuery.FieldByName('descricao').AsString,
                                       FQuery.FieldByName('preco_venda').AsCurrency);
        end
        else
        begin
             Result := nil;
        end;
     except on E: Exception do
           raise Exception.Create('Erro ao Consultar o Produto ');
     end
end;

function TPersistencia.ConsultarPedido(NumeroPedido: Integer): IPedido;
var LSQl : String;
begin
     try
        LSQl := 'SELECT numero_pedido, data_emissao, valor_total, '+
                ' cliente.codigo as cod_cliente, cliente.nome FROM pedido '+
                ' left join cliente on cliente.codigo  = pedido.cod_cliente  '+
                ' WHERE pedido.numero_pedido = :NumeroPedido';

        FQuery.Close;
        FQuery.SQL.Clear;
        FQuery.SQL.Text := LSQl;
        FQuery.ParamByName('NumeroPedido').Value := NumeroPedido;
        FQuery.Open;

        if not FQuery.Eof then
        begin
             Result := TPedido.Create(FQuery.FieldByName('numero_pedido').AsInteger,
                                      FQuery.FieldByName('data_emissao').AsDateTime,
                                      FQuery.FieldByName('cod_cliente').AsInteger,
                                      FQuery.FieldByName('nome').AsString);

             Result.AdicionarItem(ConsultarPedidoItens(NumeroPedido));
        end
        else
        begin
             Result := nil;
        end;
     except on E: Exception do
        raise Exception.Create('Erro ao Consultar Pedido ');
     end;
end;

function TPersistencia.ConsultarPedidoItens(NumeroPedido: Integer): TList<IPedidoItem>;
var
  LSQL: string;
  PedidoItem: IPedidoItem;
begin
     Result := TList<IPedidoItem>.Create;

     try
        lSQL := 'SELECT autoIncrem, numero_pedido, codigo_produto, quantidade,'+
                ' vl_unitario, vl_total, produto.descricao '+
                ' FROM pedido_item '+
                ' inner join produto on pedido_item.codigo_produto = produto.codigo '+
                ' WHERE numero_pedido = :NumeroPedido';

        FQuery.Close;
        FQuery.SQL.Clear;
        FQuery.SQL.Text := lSQL;
        FQuery.ParamByName('NumeroPedido').Value := NumeroPedido;
        FQuery.Open;

       while not FQuery.Eof do
       begin
            PedidoItem := TPedidoItem.Create(FQuery.FieldByName('numero_pedido').AsInteger,
                                             FQuery.FieldByName('codigo_produto').AsInteger,
                                             FQuery.FieldByName('quantidade').AsFloat,
                                             FQuery.FieldByName('descricao').Asstring,
                                             FQuery.FieldByName('vl_unitario').AsCurrency,
                                             FQuery.FieldByName('autoIncrem').AsInteger);

            Result.Add(PedidoItem);
            FQuery.Next;
       end;

     except on E: Exception do
           raise Exception.Create('Erro ao Consultar o Item do Pedido ');
     end;
end;

function TPersistencia.ApagarPedido(ACodigo: Integer): Boolean;
var
  LSQL: string;
begin
     Result := False;
     try
        //Vai apagar os items tbm, tabela com delete em cascate
        LSQL := 'DELETE FROM pedido WHERE numero_pedido = :pCodigo';
        FQuery.Close;
        FQuery.SQL.Clear;

        FQuery.SQL.Text := LSQL;
        FQuery.ParamByName('pCodigo').AsInteger := ACodigo;

        FConexao.StartTransaction;
        FQuery.ExecSQL;
        FConexao.Commit;

        Result := FQuery.RowsAffected > 0;
     except on E: Exception do
         begin
              FConexao.RollBack;
              raise Exception.Create('Erro ao Apagar o Pedido.');
         end;
     end;
end;

function TPersistencia.ApagarPedidoItens(APedidoItens: TList<IPedidoItem>): Boolean;
var
  LPedidoItem: IPedidoItem;
  LCodItensApagar : String;
  LSQL: string;
begin
     Result := False;
     try
        LCodItensApagar := '';
        for LPedidoItem in APedidoItens do
        begin
             if not(LCodItensApagar.IsEmpty) then
             begin
                  LCodItensApagar := LCodItensApagar + ',';
             end;

             LCodItensApagar := LCodItensApagar + LPedidoItem.AutoIncrem.ToString()
        end;

        LSQL := 'DELETE FROM pedido_item WHERE autoincrem in ('+LCodItensApagar+')';
        FQuery.Close;
        FQuery.SQL.Clear;

        FQuery.SQL.Text := LSQL;

        FQuery.ExecSQL;

        Result := True;
     except on E: Exception do
           begin
               raise Exception.Create('Erro ao Apagar Item(s) do Pedido');
           end;
     end
end;

function TPersistencia.ConsultarCliente(ACodigo: Integer): ICliente;
var LSQL: string;
begin
     try
        LSQL := 'SELECT codigo, nome, cidade, uf FROM cliente WHERE codigo = :Codigo';
        FQuery.Close;
        FQuery.SQL.Clear;
        FQuery.SQL.Text := LSQL;
        FQuery.ParamByName('Codigo').Value := ACodigo;
        FQuery.Open;

        if not FQuery.Eof then
        begin
             Result := TCliente.Create(FQuery.FieldByName('codigo').AsInteger,
                                       FQuery.FieldByName('nome').AsString,
                                       FQuery.FieldByName('cidade').AsString,
                                       FQuery.FieldByName('uf').AsString);
        end
        else
        begin
             Result := nil;
        end;
     except on E: Exception do
           raise Exception.Create('Erro ao Consultar o Cliente');
     end
end;

constructor TPersistencia.Create();
var lConfig : iConfig;
begin
     lConfig := TConfig.create();

     FConexao := TConnection.Create(nil,lConfig);

     FQuery := TFDQuery.Create(nil);
     FQuery.Connection := TFDConnection(FConexao);
end;

destructor TPersistencia.Destroy;
begin
     FQuery.Free;
     inherited;
end;

function TPersistencia.SalvarPedido(APedido: IPedido;
                                    AItensApagar: TList<IPedidoItem>): integer;
var
  lSQL : string;
  lListItens : TList<IPedidoItem>;
  lItens : IPedidoItem;
  lNumeroPedido : Integer;
begin
     Result := 0;
     try
        if APedido.NumeroPedido = 0 then
        begin
             lSQL := 'INSERT INTO pedido (cod_cliente,data_emissao, valor_total) '+
                     ' VALUES (:CodCliente, :DataEmissao, :ValorTotal);' +
                     ' SELECT LAST_INSERT_ID() AS LastID';
        end
        else
        begin
             lSQL := 'UPDATE pedido SET data_emissao = :DataEmissao, '+
                     ' valor_total = :ValorTotal, '+
                     ' cod_cliente = :CodCliente '+
                     ' WHERE numero_pedido = :NumeroPedido';
        end;

        FQuery.Close;
        FQuery.SQL.Clear;
        FQuery.SQL.Text := lSQL;
        FQuery.ParamByName('DataEmissao').asDate := APedido.DataEmissao;
        FQuery.ParamByName('ValorTotal').Value := APedido.ValorTotal;
        FQuery.ParamByName('CodCliente').Value := APedido.GetCodCliente;

        if APedido.NumeroPedido > 0 then
        begin
             FQuery.ParamByName('NumeroPedido').Value := APedido.NumeroPedido;
        end;

        FConexao.StartTransaction;

        if APedido.NumeroPedido > 0  then
        begin
             FQuery.ExecSQL();
             lNumeroPedido := APedido.NumeroPedido;
        end
        else
        begin
             FQuery.Open;
             lNumeroPedido := FQuery.FieldByName('LastID').AsInteger;
        end;

        if AItensApagar.Count > 0 then
        begin
             ApagarPedidoItens(AItensApagar);
        end;

        lListItens := APedido.GetListaItens;

        for lItens in lListItens do
        begin
             if not(SalvarPedidoItem(lNumeroPedido,lItens)) then
             begin
                  Result := 0;
                  Exit;
             end;
        end;

        FConexao.Commit;

        Result := lNumeroPedido;
     except on E: Exception do
        begin
             FConexao.Rollback;
             Result := 0;
             raise Exception.Create('Erro ao Salvar o Pedido.'+slinebreak+ e.Message);
        end;
     end;
end;

function TPersistencia.SalvarPedidoItem(APedido: Integer; APedidoItem: IPedidoItem) : Boolean;
var
  lSQL: string;
  lInicioTransaction : Boolean;
begin
     lInicioTransaction := False;
     Result := False;
     try
        if APedidoItem.AutoIncrem = 0 then
        begin
             lSQL := 'INSERT INTO pedido_item '+
                     '(numero_pedido, codigo_produto, quantidade, vl_unitario, vl_total)'+
                     ' VALUES (:NumeroPedido, :CodigoProduto, :Quantidade, :VlUnitario, :VlTotal)';
        end
        else
        begin
             lSQL := 'UPDATE pedido_item SET numero_pedido = :NumeroPedido,'+
                     ' codigo_produto = :CodigoProduto,'+
                     ' quantidade = :Quantidade, '+
                     ' vl_unitario = :VlUnitario, '+
                     ' vl_total = :VlTotal '+
                     ' WHERE autoIncrem = :AutoIncrem';
        end;

        FQuery.Close;
        FQuery.SQL.Clear;
        FQuery.SQL.Text := lSQL;
        FQuery.ParamByName('NumeroPedido').Value  := APedido;
        FQuery.ParamByName('CodigoProduto').Value := APedidoItem.CodigoProduto;
        FQuery.ParamByName('Quantidade').Value    := APedidoItem.Quantidade;
        FQuery.ParamByName('VlUnitario').Value    := APedidoItem.VlUnitario;
        FQuery.ParamByName('VlTotal').Value       := APedidoItem.VlTotal;

        if APedidoItem.AutoIncrem > 0 then
        begin
             FQuery.ParamByName('AutoIncrem').Value := APedidoItem.AutoIncrem;
        end;

        if not(FConexao.ActiveTransaction) then
        begin
             lInicioTransaction := True;
             FConexao.StartTransaction;
        end;

        FQuery.ExecSQL;

        if lInicioTransaction then
        begin
             FConexao.Commit;
        end;

        Result := True;
     except on E: Exception do
          begin
               FConexao.Rollback;
               Result := False;
               raise Exception.Create('Erro ao Salvar o Item do Pedido.');
          end;
     end;
end;

end.

