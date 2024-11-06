unit URetorno;

interface

uses
  UICliente, UIPedido, UIProduto;

type
   TRetorno = record
      OK       : Boolean;
      Mensagem : String;
      Codigo   : Integer;
   end;

  TRetornoCliente = record
      Retorno : TRetorno;
      Cliente : ICliente;
  end;

  TRetornoPedido = record
      Retorno : TRetorno;
      Pedido : IPedido;
  end;

  TRetornoProduto = record
      Retorno : TRetorno;
      Produto : IProduto;
  end;

implementation

end.
