unit UPedidoController;

interface

uses
  UIPedidoController, FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
   FireDAC.DApt, UPersistencia, System.SysUtils, System.Classes, URetorno,
  UIPedido, UIPedidoItem, System.Generics.Collections;

type

  TPedidoController = class(TInterfacedObject, IPedidoController)
  private
    FPersistencia: TPersistencia;
  public
    constructor Create();

    destructor Destroy; override;

    function GetPedido(ACodigo: Integer): IPedido;
    function SalvarPedido(APedido: IPedido): Integer;
    function ApagarPedidoItens(APedidoItens: TList<IPedidoItem>): Boolean;
    function ApagarPedido(ACodigo: Integer): Boolean;
  end;

implementation

{ TPedidoController }

function TPedidoController.ApagarPedido(ACodigo: Integer): Boolean;
begin
     if ACodigo <= 0 then
     begin
          Result := False;
          Exit;
     end;

     Result := FPersistencia.ApagarPedido(ACodigo);
end;

function TPedidoController.ApagarPedidoItens(APedidoItens: TList<IPedidoItem>): Boolean;
var APedidoIten : IPedidoItem;
    I : Integer;
begin
     for APedidoIten in APedidoItens do
     begin
          if APedidoIten.AutoIncrem <= 0 then
          begin
               Result := False;
               Exit;
          end;
     end;

     Result := FPersistencia.ApagarPedidoItens(APedidoItens);
end;

constructor TPedidoController.Create();
begin
     FPersistencia := TPersistencia.Create();
end;

destructor TPedidoController.Destroy;
begin
     FPersistencia.Free;
     inherited;
end;

function TPedidoController.GetPedido(ACodigo: Integer): IPedido;
begin
     if ACodigo <= 0 then
     begin
          Result := Nil;
          Exit;
     end;
     Result :=  FPersistencia.ConsultarPedido(ACodigo);
end;

function TPedidoController.SalvarPedido(APedido: IPedido): Integer;
begin
     if ((APedido.DataEmissao = 0) or 
         (APedido.GetCodCliente <= 0)) then
     begin    
          Result := -1;
     end;
     Result :=  FPersistencia.SalvarPedido(APedido);
end;

end.

