unit ChartDatabase.Main.View;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  TypInfo,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  VCL.TMSFNCTypes,
  VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCChart,
  Data.DB,
  Datasnap.DBClient,
  VCL.TMSFNCCustomComponent,
  VCL.TMSFNCChartDatabaseAdapter,
  Vcl.StdCtrls,
  Vcl.Buttons;

type
  TChartDatabaseMainView = class(TForm)
    pnCorpo: TPanel;
    pnBotoes: TPanel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    TMSFNCChartDatabaseAdapter1: TTMSFNCChartDatabaseAdapter;
    TMSFNCChart1: TTMSFNCChart;
    Panel3: TPanel;
    Panel1: TPanel;
    btnAbrir: TBitBtn;
    lbStatusDataBase: TLabel;
    Label1: TLabel;
    cBoxChartType: TComboBox;
    btnAlterarChartType: TBitBtn;
    ckMostrarMarcador: TCheckBox;
    ckMostrarLabels: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnAbrirClick(Sender: TObject);
    procedure btnAlterarChartTypeClick(Sender: TObject);
    procedure TMSFNCChartDatabaseAdapter1FieldsToSeries(Sender: TObject; AFields: TFields; ASeries: TTMSFNCChartSerie);
  private
    procedure PreencherDataset;
    function GetNumeroAleatorio: Double;
    procedure PreenchercBoxChartType;
  public

  end;

var
  ChartDatabaseMainView: TChartDatabaseMainView;

implementation

{$R *.dfm}

procedure TChartDatabaseMainView.FormCreate(Sender: TObject);
begin
  Self.PreenchercBoxChartType;
  Self.PreencherDataset;
end;

procedure TChartDatabaseMainView.PreenchercBoxChartType;
var
  LItem: TTMSFNCChartSerieType;
begin
  cBoxChartType.Items.Clear;

  for LItem := Low(TTMSFNCChartSerieType) to High(TTMSFNCChartSerieType) do
    cBoxChartType.Items.Add(GetEnumName(TypeInfo(TTMSFNCChartSerieType), Integer(LItem)));

  cBoxChartType.ItemIndex := Integer(TTMSFNCChartSerieType.ctLine);
end;

procedure TChartDatabaseMainView.PreencherDataset;
var
  i: Integer;
  LDiasAtras: Integer;
begin
  TMSFNCChartDatabaseAdapter1.Active := False;

  ClientDataSet1.FieldDefs.Add('id', ftInteger);
  ClientDataSet1.FieldDefs.Add('data', ftDate);
  ClientDataSet1.FieldDefs.Add('valor_ano_passado', ftFloat);
  ClientDataSet1.FieldDefs.Add('valor_ano_atual', ftFloat);
  ClientDataSet1.CreateDataSet;

  i := 10;
  for LDiasAtras := 10 downto 1 do
  begin
    ClientDataSet1.Append;
    ClientDataSet1.FieldByName('id').AsInteger := i;
    ClientDataSet1.FieldByName('data').AsDateTime := Date - LDiasAtras;
    ClientDataSet1.FieldByName('valor_ano_passado').AsFloat := Self.GetNumeroAleatorio;
    ClientDataSet1.FieldByName('valor_ano_atual').AsFloat := Self.GetNumeroAleatorio;
    ClientDataSet1.Post;
  end;

  ClientDataSet1.Active := True;
end;

function TChartDatabaseMainView.GetNumeroAleatorio: Double;
begin
  Randomize;
  Result := 1.0 + Random * (5000.0 - 1.0); // Gera de 1.0 até 5000.0
end;

procedure TChartDatabaseMainView.btnAbrirClick(Sender: TObject);
var
  LSeriesItem: TTMSFNCChartDatabaseAdapterSeriesItem;
begin
  if TMSFNCChartDatabaseAdapter1.Active then
  begin
    TMSFNCChartDatabaseAdapter1.Active := False;
    lbStatusDataBase.Caption := 'Desconectado';
    Exit;
  end;

  //SETAMOS PARA FALSE PARA QUE NOS MESMO CRIEMOS AS SERIES
  TMSFNCChartDatabaseAdapter1.AutoCreateSeries := False;

  //LIMPA TODAS AS SERIES DO ChartDatabaseAdapter
  TMSFNCChartDatabaseAdapter1.Source.Series.Clear;

  //ADICIONE AO ChartDatabaseAdapter A SERIE COM VALORES DO ANO PASSADO
  LSeriesItem := TMSFNCChartDatabaseAdapter1.Source.Series.Add;
  LSeriesItem.YValue := 'valor_ano_passado';
  LSeriesItem.XValue := 'data';
  LSeriesItem.XLabel := 'data';

  //ADICIONE AO ChartDatabaseAdapter A SERIE COM VALORES DO ANO ATUAL
  LSeriesItem := TMSFNCChartDatabaseAdapter1.Source.Series.Add;
  LSeriesItem.YValue := 'valor_ano_atual';
  LSeriesItem.XValue := 'data';
  LSeriesItem.XLabel := 'data';

  TMSFNCChartDatabaseAdapter1.Active := True;
  lbStatusDataBase.Caption := 'Conectado';

  //btnAlterarChartType.Click;
end;

procedure TChartDatabaseMainView.TMSFNCChartDatabaseAdapter1FieldsToSeries(Sender: TObject; AFields: TFields;
  ASeries: TTMSFNCChartSerie);
begin
  ASeries.ChartType := TTMSFNCChartSerieType(cBoxChartType.ItemIndex);
  ASeries.Markers.Visible := ckMostrarMarcador.Checked;
  ASeries.Labels.Visible := ckMostrarLabels.Checked;
  ASeries.YValues.Title.Text := 'Total em vendas';
  ASeries.XValues.Title.Text := 'Dias vendidos';
end;

procedure TChartDatabaseMainView.btnAlterarChartTypeClick(Sender: TObject);
var
  LSerieChart: TTMSFNCChartSerie;
begin
  if not TMSFNCChartDatabaseAdapter1.Active then
  begin
    ShowMessage('DatabaseAdapter não esta ativo');
    btnAbrir.SetFocus;
    Exit;
  end;

  //INTERCEPTA A SERIE NO TMSFNCChart1 CASO QUEIRA FAZER ALGUMA ALTERACAO
  //TAMBEM PODE SER CONFIGURADO NO EVENTO OnFieldsToSeries DO TMSFNCChartDatabaseAdapter
  LSerieChart := TMSFNCChart1.Series[0];
  LSerieChart.ChartType := TTMSFNCChartSerieType(cBoxChartType.ItemIndex);
  LSerieChart.LegendText := 'Ano passado';
  LSerieChart.Markers.Visible := ckMostrarMarcador.Checked;
  LSerieChart.Labels.Visible := ckMostrarLabels.Checked;

  LSerieChart := TMSFNCChart1.Series[1];
  LSerieChart.ChartType := TTMSFNCChartSerieType(cBoxChartType.ItemIndex);
  LSerieChart.LegendText := 'Ano Atual';
  LSerieChart.Markers.Visible := ckMostrarMarcador.Checked;
  LSerieChart.Labels.Visible := ckMostrarLabels.Checked;
end;

end.
