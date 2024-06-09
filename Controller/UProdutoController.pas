unit UProdutoController;

interface

  uses
      UiProdutoController, UIProduto, UPersistencia;
  type
     TProdutoController =  class(TInterfacedObject, IProdutoController)
     private
     FPersistencia: TPersistencia;

     public
      constructor Create();
    function GetProduto(aCodigo: Integer): iProduto;
  end;
implementation

{ ProdutoController }

constructor TProdutoController.Create;
begin
     FPersistencia := TPersistencia.Create();
end;

function TProdutoController.GetProduto(aCodigo: Integer): iProduto;
begin
     Result := FPersistencia.ConsultarProduto(aCodigo);
end;

end.
