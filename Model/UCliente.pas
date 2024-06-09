unit UCliente;

interface

uses
  UICliente;

type
  TCliente = class(TInterfacedObject, ICliente)
  private
    FCodigo: Integer;
    FNome: string;
    FCidade: string;
    FUF: string;
  public
    constructor Create(ACodigo: Integer; ANome, ACidade, AUF: string);
    function GetCodigo: Integer;
    function GetNome: string;
    function GetCidade: string;
    function GetUF: string;
  end;

implementation

{ TCliente }

constructor TCliente.Create(ACodigo: Integer; ANome, ACidade, AUF: string);
begin
     FCodigo := ACodigo;
     FNome := ANome;
     FCidade := ACidade;
     FUF := AUF;
end;

function TCliente.GetCodigo: Integer;
begin
     Result := FCodigo;
end;

function TCliente.GetNome: string;
begin
     Result := FNome;
end;

function TCliente.GetCidade: string;
begin
     Result := FCidade;
end;

function TCliente.GetUF: string;
begin
     Result := FUF;
end;

end.

