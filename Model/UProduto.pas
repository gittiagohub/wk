unit UProduto;

interface

uses
  UIProduto;

type
  TProduto = class(TInterfacedObject, IProduto)
  private
    FCodigo: Integer;
    FDescricao: string;
    FPrecoVenda: Currency;
  public
    constructor Create(ACodigo: Integer; ADescricao: string; APrecoVenda: Currency);
    function GetCodigo: Integer;
    function GetDescricao: string;
    function GetPrecoVenda: Currency;
  end;

implementation

{ TProduto }

constructor TProduto.Create(ACodigo: Integer; ADescricao: string; APrecoVenda: Currency);
begin
     FCodigo := ACodigo;
     FDescricao := ADescricao;
     FPrecoVenda := APrecoVenda;
end;

function TProduto.GetCodigo: Integer;
begin
     Result := FCodigo;
end;

function TProduto.GetDescricao: string;
begin
     Result := FDescricao;
end;

function TProduto.GetPrecoVenda: Currency;
begin
     Result := FPrecoVenda;
end;

end.

