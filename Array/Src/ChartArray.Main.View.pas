unit ChartArray.Main.View;

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
  VCL.TMSFNCTypes,
  VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCChart,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TChartArrayMainView = class(TForm)
    Chart1: TTMSFNCBarChart;
    Panel1: TPanel;
    btnSetarConfigPadroes: TBitBtn;
    btnCarregarArrayVendasDaSemana: TBitBtn;
    btnAdicionarSerieVendasAVista: TBitBtn;
    btnAdicionarSerieVendasAPrazo: TBitBtn;
    Panel2: TPanel;
    btnConfigurarGrafico: TBitBtn;
    Panel3: TPanel;
    cBoxChartEditorType: TComboBox;
    procedure btnSetarConfigPadroesClick(Sender: TObject);
    procedure btnCarregarArrayVendasDaSemanaClick(Sender: TObject);
    procedure btnAdicionarSerieVendasAVistaClick(Sender: TObject);
    procedure btnAdicionarSerieVendasAPrazoClick(Sender: TObject);
    procedure btnConfigurarGraficoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure PreenchercBoxChartEditorType;
  public

  end;

var
  ChartArrayMainView: TChartArrayMainView;

implementation

{$R *.dfm}

procedure TChartArrayMainView.FormCreate(Sender: TObject);
begin
  Self.PreenchercBoxChartEditorType;
end;

procedure TChartArrayMainView.PreenchercBoxChartEditorType;
var
  LItem: TTMSFNCChartEditorType;
begin
  cBoxChartEditorType.Items.Clear;

  for LItem := Low(TTMSFNCChartEditorType) to High(TTMSFNCChartEditorType) do
    cBoxChartEditorType.Items.Add(GetEnumName(TypeInfo(TTMSFNCChartEditorType), Integer(LItem)));

  cBoxChartEditorType.ItemIndex := Integer(TTMSFNCChartEditorType.etGeneral);
end;

procedure TChartArrayMainView.btnSetarConfigPadroesClick(Sender: TObject);
begin
  //AS OPCOES PRESENTES EM Chart1.DefaultLoadOptions PERMITE PERSONALIZAR A FORMA COMO
  //OS DADOS SAO PROCESSADOS QUANDO CARREGADOS NO GRAFICO
  //SEJA PARA CARREGAMENTEO DE UM ARRAY, CSV, JSON, DATASET, GRID, ETC.

  //IRA SEMPRE LIMPAR O GRAFICO ANTES DE CARREGAR INFORMACOES NOVAS
  Chart1.DefaultLoadOptions.ClearSeries := True;
  Chart1.DefaultLoadOptions.YValuesFormatType := vftFloat;
end;

procedure TChartArrayMainView.btnCarregarArrayVendasDaSemanaClick(Sender: TObject);
begin
  Chart1.LoadFromDataArray(0, [30, 50, 20, 65, 85, 90.5, 95], nil,
    ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo']
    ).LegendText := 'Vendas da semana';
end;

procedure TChartArrayMainView.btnAdicionarSerieVendasAVistaClick(Sender: TObject);
var
  LSerieAVista: TTMSFNCChartSerie;
begin
  LSerieAVista := Chart1.AddSeriesFromDataArray([20, 25, 14, 15, 55, 68, 89]);
  LSerieAVista.YValues.Positions := [ypCenter];
  LSerieAVista.LegendText := 'Vendas à vista';
end;

procedure TChartArrayMainView.btnAdicionarSerieVendasAPrazoClick(Sender: TObject);
var
  LSerieAPrazo: TTMSFNCChartSerie;
begin
  LSerieAPrazo := Chart1.AddSeriesFromDataArray([10, 25, 6, 40, 15, 22.5, 6]);
  LSerieAPrazo.YValues.Positions := [ypCenter];
  LSerieAPrazo.LegendText := 'Vendas a prazo';
end;

procedure TChartArrayMainView.btnConfigurarGraficoClick(Sender: TObject);
begin
  Chart1.ShowEditor(TTMSFNCChartEditorType(cBoxChartEditorType.ItemIndex));
end;

end.
