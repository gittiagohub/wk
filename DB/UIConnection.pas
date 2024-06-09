unit UIConnection;

interface

uses UIConfig;
type
  IConnection = interface
   ['{2697139D-4A0C-46BC-A933-AB9FEA7D6C4D}']
    procedure Setup(aConfiguracao: IConfig);
    procedure StartTransaction;
    procedure Rollback;
    procedure Commit;
    function ActiveTransaction: Boolean;
  end;

implementation

end.
