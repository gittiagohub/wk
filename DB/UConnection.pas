unit UConnection;

interface
uses FireDAC.Comp.Client,FireDAC.Phys.MySQL,System.Classes,uConfig,
     FireDAC.Stan.def,FireDAC.Phys.MySQLWrapper,UIConnection, UIConfig,
     FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;


type
   TConnection = class(TFDConnection, IConnection)
   private
      FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
      FDGUIxWaitCursor: TFDGUIxWaitCursor;

      procedure Setup(aConfiguracao : IConfig);
      { private declarations }
   protected
      { protected declarations }
   public
      { public declarations }
      constructor Create(AOwner: TComponent; aConfiguracao : IConfig); reintroduce;
      function ActiveTransaction : Boolean;

   published
      { published declarations }
   end;


implementation

uses
  System.SysUtils, Vcl.Dialogs;

{ TConnection }
constructor TConnection.Create(AOwner: TComponent; aConfiguracao: IConfig);
begin
     inherited Create(AOwner);
     try
        Setup(aConfiguracao);
     except on E: Exception do
         ShowMessage(E.ClassName+ ': '+ E.Message);
     end;
end;


function TConnection.ActiveTransaction: Boolean;
begin
     Result := Self.InTransaction;
end;

procedure TConnection.Setup(aConfiguracao : IConfig);
var
  xDirDLL: string;
begin
     try
        xDirDLL := ExtractFilePath(ParamStr(0))+aConfiguracao.DBDLL;

        Self.Params.DriverID := 'mysql';
        Self.Params.add('Server=' +aConfiguracao.DBHost);
        Self.Params.add('Port=' +IntToStr(aConfiguracao.DBPort));
        Self.Params.Database := aConfiguracao.DB;
        Self.Params.UserName := aConfiguracao.DBUserName;
        Self.Params.Password := aConfiguracao.DBPassword;

        Self.ResourceOptions.Persistent := True;
        Self.UpdateOptions.AutoCommitUpdates :=True;

        FDPhysMySQLDriverLink := TFDPhysMySQLDriverLink.Create(Self);
        FDPhysMySQLDriverLink.VendorLib := xDirDLL;

        try
           Self.Connected := True;
        except
            on E : EMySQLNativeException do
            begin
                 ShowMessage('Falha ao conectar no banco: '+E.ClassName+ ': '+ E.Message);
            end;
        end;
     except
        on E: Exception do
         begin
              raise Exception.Create('Erro fazer conexão com o banco de dados ' +
                                     aConfiguracao.DB +Slinebreak+E.Message);
         end;
     end;
end;

end.
