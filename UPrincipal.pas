unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Mask, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.DBCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  uiConnection,uiconfig, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, UClientAcess,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.DApt,
  System.Classes;

type
  TFormPrincipal = class(TForm)
    PanelPrincipal: TPanel;
    GroupBoxPrincipal: TGroupBox;
    GroupBoxCliente: TGroupBox;
    ButtonConsultarCliente: TButton;
    DBEditCodCliente: TEdit;
    DBEditCliente: TEdit;
    GroupBoxProduto: TGroupBox;
    DBEditCodigo: TEdit;
    DBEditDescricao: TEdit;
    LabelCodigoProduto: TLabel;
    LabelDescricao: TLabel;
    LabelQtde: TLabel;
    DBEditQuantidade: TEdit;
    LabelValorUnitario: TLabel;
    DBEditValorUnitario: TEdit;
    GroupBoxItens: TGroupBox;
    DBGridItens: TDBGrid;
    ButtonConfirmar: TButton;
    GroupBoxTotalPedido: TGroupBox;
    LabelVlTotalPedido: TLabel;
    LabelVLTotal: TLabel;
    ButtonGravarPedido: TButton;
    FDMemTablePedidoItem: TFDMemTable;
    DataSourcePedidoItem: TDataSource;
    FDMemTablePedidoItemcodigo_produto: TIntegerField;
    FDMemTablePedidoItemdescricao: TStringField;
    FDMemTablePedidoItemquantidade: TFloatField;
    FDMemTablePedidoItemvl_unitario: TCurrencyField;
    FDMemTablePedidoItemvl_total: TCurrencyField;
    GroupBoxPedido: TGroupBox;
    ButtonConsultarPedido: TButton;
    EditNumeroPedido: TEdit;
    EditDataEmissao: TEdit;
    LabelCodCliente: TLabel;
    LabelCliente: TLabel;
    LabelNumeroPedido: TLabel;
    LabelDataEmissao: TLabel;
    FDMemTablePedidoItemauto_incremento: TIntegerField;
    ButtonApagarPedido: TButton;
    ButtonNovoPedido: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBEditCodigoExit(Sender: TObject);
    procedure ButtonConfirmarClick(Sender: TObject);
    procedure ButtonGravarPedidoClick(Sender: TObject);
    procedure DBGridItensKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonConsultarPedidoClick(Sender: TObject);
    procedure ButtonConsultarClienteClick(Sender: TObject);
    procedure ButtonApagarPedidoClick(Sender: TObject);
    procedure DBEditCodClienteExit(Sender: TObject);
    procedure ButtonNovoPedidoClick(Sender: TObject);
  private
    FClientAcess : TClientAcess;
    FAggregate   : TFDAggregate;
    FApagaItens  : TStringList;
    procedure AdicionaItemGrade;
    procedure GravaPedido;
    procedure LimpaComponentesPedido;
    procedure CalculaTotalPedido;
    procedure ConsultarPedido(ANumeroPedido : Integer = 0);
    procedure ConsultarCliente(ACodCliente : String;
                               ALimparClienteNaoEncontrado : Boolean = True);
    procedure ApagarPedido;

    function RecebeNumeroPedido : Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses
  URetorno, UIPedidoItem, System.Generics.Collections, UIPedido, UPedido,
  UPedidoItem;

{$R *.dfm}

procedure TFormPrincipal.AdicionaItemGrade;
var
  LQuantidade: Double;
  LVLUnitario: Extended;
begin
     if (Trim(DBEditCodigo.Text).IsEmpty) then
     begin
          Showmessage('Preencha o Código do Produto Para Inserir.');
          DBEditCodigo.SetFocus;
          Exit;
     end;

     try
        LQuantidade := (StrToFloat(Trim(DBEditQuantidade.Text)));
     except on E: Exception do
          begin
               Showmessage('Valor Inválido Para Quantidade.');
               Exit;
          end;
     end;

     try
        LVLUnitario := (StrToFloat(Trim(DBEditValorUnitario.Text)));
     except on E: Exception do
          begin
               Showmessage('Valor Inválido Para Valor Unitário.');
               Exit;
          end;
     end;

     if LQuantidade <= 0 then
     begin
          Showmessage('A Quantidade do Produto Não Pode ser Menor Ou Igual a Zero.');
          DBEditQuantidade.SetFocus;
          Exit;
     end;

     if LVLUnitario <= 0 then
     begin
          Showmessage('O Valor Unitário do Produto Não Pode ser Menor Ou Igual a Zero.');
          DBEditValorUnitario.SetFocus;
          Exit;
     end;


     with FDMemTablePedidoItem do
     begin
          if ControlsDisabled then
          begin
               Edit;
          end
          else
          begin
               Append;
          end;
          FieldByName('codigo_produto').Value := DBEditCodigo.Text;
          FieldByName('descricao').Value      := DBEditDescricao.Text;
          FieldByName('quantidade').Value     := LQuantidade;
          FieldByName('vl_unitario').Value    := LVLUnitario;
          FieldByName('vl_total').Value       := FieldByName('quantidade').AsFloat *
                                                 FieldByName('vl_unitario').Value;
          Post;

          if ControlsDisabled then
          begin
               DBEditDescricao.ReadOnly := False;
               DBEditCodigo.ReadOnly    := False;
               EnableControls;
          end;

          DBEditCodigo.Text        := '';
          DBEditDescricao.Text     := '';
          DBEditQuantidade.Text    := '';
          DBEditValorUnitario.Text := '';
     end;
     DBEditCodigo.SetFocus;
     CalculaTotalPedido;
end;

procedure TFormPrincipal.ApagarPedido;
var
  lNumeroPedido: Integer;
  lResult : TRetorno;
begin
     lNumeroPedido := RecebeNumeroPedido;

     lResult := FClientAcess.ApagarPedido(lNumeroPedido);

     if not(lResult.OK) then
     begin
          ShowMessage(lResult.Mensagem);
     end
     else
     begin
          ShowMessage('Pedido Apagado com Sucesso.');
          if lNumeroPedido.ToString = EditNumeroPedido.Text then
          begin
               LimpaComponentesPedido;
               CalculaTotalPedido;
          end;
     end;
end;

procedure TFormPrincipal.ButtonApagarPedidoClick(Sender: TObject);
begin
     ApagarPedido;
end;

procedure TFormPrincipal.ButtonConfirmarClick(Sender: TObject);
begin
     AdicionaItemGrade;
end;

procedure TFormPrincipal.ButtonConsultarClienteClick(Sender: TObject);
var
  lCodClienteInput: String;
begin
     lCodClienteInput := InputBox('Entrada do Usuário',
                                  'Digite o Código do Cliente',
                                  '');

     if not (lCodClienteInput.Trim.IsEmpty) then
     begin
          ConsultarCliente(lCodClienteInput,False);
     end;
end;

procedure TFormPrincipal.ButtonConsultarPedidoClick(Sender: TObject);
begin
     ConsultarPedido;
end;

procedure TFormPrincipal.ButtonGravarPedidoClick(Sender: TObject);
begin
     GravaPedido;
end;

procedure TFormPrincipal.ButtonNovoPedidoClick(Sender: TObject);
begin
     LimpaComponentesPedido;
     CalculaTotalPedido;
end;

procedure TFormPrincipal.CalculaTotalPedido;
var LTotal : String;
begin
     if FAggregate.Value = null then
     begin
          LTotal := FormatFloat('R$ #,##0.00', 0);
     end
     else
     begin
          LTotal := FormatFloat('R$ #,##0.00',FAggregate.Value);
     end;

     LabelVLTotal.Caption := LTotal;
end;

procedure TFormPrincipal.ConsultarCliente(ACodCliente : String;
                                          ALimparClienteNaoEncontrado : Boolean);
var lCodCliente : Integer;
    lResult : TRetornoCliente;
begin
     if ACodCliente.Trim.IsEmpty then
     begin
          DBEditCliente.Text    := '';
          DBEditCodCliente.Text := '';
          Exit;
     end;
                                    
     try
        lCodCliente := StrToInt(ACodCliente);
     except on E: Exception do
          begin
               Showmessage('Código do Cliente Inválido.');
               Exit;
          end;
     end;

     lResult := FClientAcess.BuscaCliente(lCodCliente);

      with lResult do
      begin
           if not(Retorno.OK) then
           begin
                ShowMessage(Retorno.Mensagem);

                if ALimparClienteNaoEncontrado then
                begin
                     DBEditCliente.Text    := '';
                     DBEditCodCliente.Text := '';
                end;
           end
           else
           begin
                DBEditCodCliente.Text := Cliente.Codigo.ToString;
                DBEditCliente.Text    := Cliente.Nome;
           end;
      end;
end;

procedure TFormPrincipal.ConsultarPedido(ANumeroPedido : Integer);
var
  lNumeroPedido: Integer;
  lResult : TRetornoPedido;
  lListPedidoItem : TList<IPedidoItem>;
  lPedidoitem : IPedidoItem;
begin
     if ANumeroPedido = 0  then
     begin
          lNumeroPedido := RecebeNumeroPedido;
     end
     else
     begin
          lNumeroPedido := ANumeroPedido;
     end;

     if lNumeroPedido = 0 then
     begin
          Exit
     end;

     lResult := FClientAcess.BuscaPedido(lNumeroPedido);

     with lResult do
     begin
          if not(Retorno.OK) then
          begin
               ShowMessage(Retorno.Mensagem);
          end
          else
          begin
               EditNumeroPedido.Text   := Pedido.NumeroPedido.ToString;
               DBEditCodCliente.Text   := Pedido.GetCodCliente.ToString;
               DBEditCliente.Text      := Pedido.GetCliente;
               EditDataEmissao.Text    := DateToStr(Pedido.DataEmissao);
               LabelVLTotal.Caption    := FloatToStr(Pedido.GetValorTotal);

               lListPedidoItem := Pedido.GetListaItens();
               FDMemTablePedidoItem.EmptyDataSet;

               for LPedidoitem in lListPedidoitem do
               begin
                    with FDMemTablePedidoItem do
                    begin
                         Append;
                         FieldByName('codigo_produto').AsInteger  := LPedidoitem.CodigoProduto;
                         FieldByName('descricao').AsString        := LPedidoitem.Descricao;
                         FieldByName('quantidade').AsFloat        := LPedidoitem.Quantidade;
                         FieldByName('vl_unitario').AsCurrency    := LPedidoitem.VlUnitario;
                         FieldByName('vl_total').AsCurrency       := LPedidoitem.VlTotal;
                         FieldByName('auto_incremento').AsInteger := LPedidoitem.AutoIncrem;
                         Post
                    end;
               end;
          end;
     end;
     CalculaTotalPedido;
end;

procedure TFormPrincipal.DBEditCodClienteExit(Sender: TObject);
begin
     ConsultarCliente(DBEditCodCliente.Text);
end;

procedure TFormPrincipal.DBEditCodigoExit(Sender: TObject);
var lCodProduto : Integer;
    lResult : TRetornoProduto;
begin
     if not(Trim(DBEditCodigo.Text).IsEmpty) then
     begin
          lCodProduto := StrToInt(DBEditCodigo.Text);

          lResult := FClientAcess.BuscaProduto(lCodProduto);

          with lResult do
          begin
               if not(Retorno.OK) then
               begin
                    ShowMessage(Retorno.Mensagem);
                    DBEditDescricao.Text     := '';
                    DBEditValorUnitario.Text := '';
                    DBEditCodigo.Text        := '';
               end
               else
               begin
                    DBEditDescricao.Text     := Produto.Descricao;
                    DBEditValorUnitario.Text := FloatToStr(Produto.PrecoVenda);
               end;
          end;
     end;
end;

procedure TFormPrincipal.DBGridItensKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case Key of

         VK_RETURN :
         begin
              if not(FDMemTablePedidoItem.IsEmpty) then
              begin
                   with  FDMemTablePedidoItem do
                   begin
                        DBEditDescricao.Text     := FieldByName('descricao').asString;
                        DBEditValorUnitario.Text := FieldByName('vl_unitario').asString;
                        DBEditCodigo.Text        := FieldByName('codigo_produto').asString;
                        DBEditQuantidade.Text    := FieldByName('Quantidade').asString;

                        DBEditDescricao.ReadOnly := True;
                        DBEditCodigo.ReadOnly    := True;

                        DisableControls;
                   end;
              end;
         end;

         VK_DELETE :
         begin
              if not(FDMemTablePedidoItem.IsEmpty) then
              begin
                   if MessageDlg('Tem certeza que deseja apagar o item da lista?',
                                 mtConfirmation, [mbYes, mbNo], 0) = mrYes then
                   begin
                        with FDMemTablePedidoItem do
                        begin
                             ShowMessage('Grave o pedido para confirmar a operação.');

                             if not(FieldByName('auto_incremento').AsString.Trim.IsEmpty) then
                             begin
                                  FApagaItens.add(FieldByName('auto_incremento').AsString);
                             end;

                             Delete;

                             CalculaTotalPedido;
                        end;
                   end;
              end;
         end;
     end;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
     FAggregate := FDMemTablePedidoItem.Aggregates.Add;
     FAggregate.Expression := 'SUM(vl_total)';
     FAggregate.Name   := 'total_pedido';
     FAggregate.Active := True;
     FDMemTablePedidoItem.AggregatesActive := True;

     FClientAcess := TClientAcess.Create;
     FApagaItens  := TStringList.Create;
end;

procedure TFormPrincipal.FormDestroy(Sender: TObject);
begin
     FreeAndNil(FClientAcess);
     FreeAndNil(FAggregate);
     FreeAndNil(FApagaItens);
end;

procedure TFormPrincipal.GravaPedido;
var lResult : TRetorno;
    LPedido: IPedido;
    LPedidoItem : IPedidoItem;
begin
     LPedido := TPedido.Create(StrToIntDef(EditNumeroPedido.Text,0),
                               Date,
                               StrToIntDef(DBEditCodCliente.Text,0));

     with FDMemTablePedidoItem do
     begin
          First;

          while not(Eof) do
          begin
               LPedidoItem := TPedidoItem.Create(LPedido.NumeroPedido,
                                                 FieldByName('codigo_produto').AsInteger,
                                                 FieldByName('quantidade').AsFloat,
                                                 FieldByName('descricao').AsString,
                                                 FieldByName('VL_unitario').AsCurrency,
                                                 FieldByName('auto_incremento').AsInteger);

               LPedido.AdicionarItem(LPedidoItem);
               Next;
          end;
     end;

     lResult:= FClientAcess.GravaPedido(LPedido,
                                        FApagaItens);

     if not(lResult.OK) then
     begin
          ShowMessage(lResult.Mensagem);
     end
     else
     begin
          ShowMessage('Pedido Salvo com Sucesso.');
          ConsultarPedido(lResult.Codigo);
     end;
end;

procedure TFormPrincipal.LimpaComponentesPedido;
begin
     EditNumeroPedido.Text := '';
     EditDataEmissao.Text  := '';
     DBEditCodCliente.Text := '';
     DBEditCliente.Text    := '';
     FDMemTablePedidoItem.EmptyDataSet;
end;

function TFormPrincipal.RecebeNumeroPedido: Integer;
var
  lNumeroPedidoInput: string;
  lNumeroPedido: Integer;
begin
     Result := 0;

     lNumeroPedidoInput := InputBox('Entrada do Usuário',
                                    'Digite o Número do Pedido',
                                    '');

     if lNumeroPedidoInput.Trim.IsEmpty then
     begin
          Exit;
     end;

     try
        lNumeroPedido := StrToInt(lNumeroPedidoInput);
     except on E: Exception do
          begin
               Showmessage('Número do Pedido Inválido.');
               Exit;
          end;
     end;

     Result := lNumeroPedido;
end;

end.
