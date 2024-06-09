unit UICliente;

interface

type
  ICliente = interface
    ['{0C448162-0DE2-4B9C-9923-780C26CCBAF7}']
    function GetCodigo: Integer;
    function GetNome: string;
    function GetCidade: string;
    function GetUF: string;

    property Codigo: Integer read GetCodigo;
    property Nome: string read GetNome;
    property Cidade: string read GetCidade;
    property UF: string read GetUF;
  end;

implementation

end.

