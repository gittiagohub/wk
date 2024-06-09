program ProjectWKPedidos;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {FormPrincipal},
  UConnection in 'DB\UConnection.pas',
  UConfig in 'DB\UConfig.pas',
  UIConnection in 'DB\UIConnection.pas',
  UIConfig in 'DB\UIConfig.pas',
  UPedidoItem in 'Model\UPedidoItem.pas',
  UIPedidoItem in 'Model\UIPedidoItem.pas',
  UPedido in 'Model\UPedido.pas',
  UIPedido in 'Model\UIPedido.pas',
  UPersistencia in 'DB\UPersistencia.pas',
  UIProduto in 'Model\UIProduto.pas',
  UProduto in 'Model\UProduto.pas',
  UICliente in 'Model\UICliente.pas',
  UCliente in 'Model\UCliente.pas',
  UIPedidoController in 'Controller\UIPedidoController.pas',
  UPedidoController in 'Controller\UPedidoController.pas',
  URetorno in 'Utils\URetorno.pas',
  UIProdutoController in 'Controller\UIProdutoController.pas',
  UProdutoController in 'Controller\UProdutoController.pas',
  UClienteController in 'Controller\UClienteController.pas',
  UIClienteController in 'Controller\UIClienteController.pas',
  UClientAcess in 'View\UClientAcess.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
