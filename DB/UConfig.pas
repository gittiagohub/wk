unit UConfig;

interface

uses
   System.IniFiles,UIConfig;
type
   TConfig = class(TInterfacedObject, IConfig)
   private

     const
     {$IFDEF _CONSOLE_TESTRUNNER}
     constConfig: String = 'ConfigTest.ini';
     {$ELSE}
     constConfig: String = 'Config.ini';

     {$ENDIF }

   const
      constDBSection: String = 'DataBaseConnection';

   const
      constDB: String = 'Database';

   const
      constDBHost: String = 'Server';

   const
      constDBPort: String = 'Port';

   const
      constDBUserName: String = 'Username';

   const
      constDBPassword: String = 'Password';

   const
      constDBDLL: String = 'DLL';

      // Default values to create the file
   const
      constDefaultValueDB: String = 'mysql';

   const
      constDefaultValueDBHost: String = 'localhost';

   const
      constDefaultValueDBPort: integer = 3306;

   const
      constDefaultValueDBUserName: String = 'root';

   const
      constDefaultValueDBPassword: String = 'root';

   const
      constDefaultValueDBDLL: String = 'libmysql.dll';

      var FDB: String;
      var FDBHost: String;
      var FDBPort: integer;
      var FDBUserName: String;
      var FDBPassword: String;
      var FDBDLL: String;

      function LoadFile(aFileDir: String): TIniFile;

      { private declarations }
   protected
      { protected declarations }
   public

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

      procedure CarregaVariaveis();
      constructor Create();
      { public declarations }

   published
      { published declarations }
   end;

implementation

uses
   System.Classes, System.IOUtils, System.SysUtils;

{ TConfig }

constructor TConfig.Create;
begin
     CarregaVariaveis;
end;

function TConfig.GetDB: String;
begin
     Result := FDB;
end;

function TConfig.GetDBDLL: String;
begin
     Result := FDBDLL;
end;

function TConfig.GetDBHost: String;
begin
     Result:= FDBHost;
end;

function TConfig.GetDBPassword: String;
begin
     Result:= FDBPassword;
end;

function TConfig.GetDBPort: integer;
begin
     Result:= FDBPort;
end;

function TConfig.GetDBUserName: String;
begin
     Result:= FDBUserName;
end;

function TConfig.LoadFile(aFileDir: string): TIniFile;
begin
     try
        //Quem chamar esse método que vai liberar ele da mémoria
        Result := TIniFile.Create(aFileDir);

        // se não existe a seção no arquivo então será criado
        if not(Result.SectionExists(constDBSection)) then
        begin
             Result.WriteString(constDBSection,
                                constDB,
                                constDefaultValueDB);

             Result.WriteString(constDBSection,
                                constDBHost,
                                constDefaultValueDBHost);

             Result.WriteInteger(constDBSection,
                                 constDBPort,
                                 constDefaultValueDBPort);


             Result.WriteString(constDBSection,
                                constDBUserName,
                                constDefaultValueDBUserName);

             Result.WriteString(constDBSection,
                                constDBPassword,
                                constDefaultValueDBPassword);

             Result.WriteString(constDBSection,
                                constDBDLL,
                                constDefaultValueDBDLL);
        end;
     except on E: Exception do
         begin
              Writeln('Erro ao carregar/criar o arquivo: '+constConfig+
                      Slinebreak+E.Message);
         end;
     end;
end;

procedure TConfig.CarregaVariaveis;
var
   xPathConfigFile: String;
   xConfigFile: TIniFile;
begin
     xPathConfigFile := TPath.Combine(ExtractFilePath(ParamStr(0)), constConfig);
     try
        xConfigFile := LoadFile(xPathConfigFile);
        try
           FDB := xConfigFile.ReadString(constDBSection,
                                         constDB,
                                         '');

           FDBHost := xConfigFile.ReadString(constDBSection,
                                             constDBHost,
                                             '');

           FDBPort := xConfigFile.ReadInteger(constDBSection,
                                              constDBPort,
                                              0);

           FDBUserName := xConfigFile.ReadString(constDBSection,
                                                 constDBUserName,
                                                 '');

           FDBPassword := xConfigFile.ReadString(constDBSection,
                                                 constDBPassword,
                                                 '');

           FDBDLL := xConfigFile.ReadString(constDBSection,
                                            constDBDLL,
                                            '');
        finally
           FreeandNil(xConfigFile);
        end;
     except on E: Exception do
         Writeln('Erro ao ler o arquivo: '+constConfig+
                      Slinebreak+E.Message);
     end;
end;

end.
