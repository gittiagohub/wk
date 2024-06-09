unit UIClienteController;

interface

uses
  UICliente;
type
  iClienteController = interface
  ['{BE661123-AD02-4B3F-A94E-2A01DF600C82}']
    function GetCliente(Codigo: Integer): iCliente;
  end;

implementation

end.
