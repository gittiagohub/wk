unit UIProduto;

interface

type
  IProduto = interface
    ['{A7473243-7573-40C9-AE17-5B1EA2BE8249}']
    function GetCodigo: Integer;
    function GetDescricao: string;
    function GetPrecoVenda: Currency;

    property Codigo: Integer read GetCodigo;
    property Descricao: string read GetDescricao;
    property PrecoVenda: Currency read GetPrecoVenda;
  end;

implementation

end.

