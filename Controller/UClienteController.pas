unit UClienteController;

interface

  uses
       UiClienteController, UICliente, UPersistencia;
  type
     TClienteController =  class(TInterfacedObject, IClienteController)
     private
     FPersistencia: TPersistencia;

     public
      constructor Create();
    function GetCliente(aCodigo: Integer): iCliente;
  end;
implementation

{ ProdutoController }

constructor TClienteController.Create;
begin
     FPersistencia := TPersistencia.Create();
end;

function TClienteController.GetCliente(aCodigo: Integer): iCliente;
begin
     Result := FPersistencia.ConsultarCliente(aCodigo);
end;

end.

