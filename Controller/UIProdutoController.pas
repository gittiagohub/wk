unit UIProdutoController;

interface

uses
  UIProduto;
type
  iProdutoController = interface
   ['{949021E9-27C2-4A75-8DC2-6CCDB6B93BDC}']
    function GetProduto(Codigo: Integer): iProduto;
  end;

implementation

end.
