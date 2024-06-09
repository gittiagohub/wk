unit UIConfig;

interface
type
   IConfig = interface
    ['{D215BC22-3C7C-485C-BF61-2630C845D9F4}']
   procedure CarregaVariaveis();
    function GetDB: String;
      function GetDBHost: String;
      function GetDBPort: integer;
      function GetDBUserName: String;
      function GetDBPassword: String;
      function GetDBDLL: String;

      property DB: String read  GetDB;
      property DBHost: String read GetDBHost;
      property DBPort: integer read GetDBPort;
      property DBUserName: String read GetDBUserName;
      property DBPassword: String read GetDBPassword;
      property DBDLL: String read GetDBDLL;
  end;
implementation

end.
