unit Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCChart, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TMainView = class(TForm)
    Chart1: TTMSFNCBarChart;
    Panel1: TPanel;
    btnSetarConfigPadroes: TBitBtn;
    btnCarregarArrayVendasDaSemana: TBitBtn;
    btnAdicionarSerieVendasAVista: TBitBtn;
    btnAdicionarSerieVendasAPrazo: TBitBtn;
    procedure btnSetarConfigPadroesClick(Sender: TObject);
    procedure btnCarregarArrayVendasDaSemanaClick(Sender: TObject);
    procedure btnAdicionarSerieVendasAVistaClick(Sender: TObject);
    procedure btnAdicionarSerieVendasAPrazoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.btnSetarConfigPadroesClick(Sender: TObject);
begin
  //AS OPCOES PRESENTES EM Chart1.DefaultLoadOptions PERMITE PERSONALIZAR A FORMA COMO
  //OS DADOS SAO PROCESSADOS QUANDO CARREGADOS NO GRAFICO
  //SEJA PARA CARREGAMENTEO DE UM ARRAY, CSV, JSON, DATASET, GRID, ETC.

  //IRA SEMPRE LIMPAR O GRAFICO ANTES DE CARREGAR INFORMACOES NOVAS
  Chart1.DefaultLoadOptions.ClearSeries := True;
end;

procedure TMainView.btnCarregarArrayVendasDaSemanaClick(Sender: TObject);
begin
//  Chart1.DefaultLoadOptions.XValuesFormatType: vftDateTime;
//  Chart1. LoadFromDataArray (0,
//  (18.6, 19.2, 14.6, 16.7, 18, 23.4, 21.1],
//  [Today 6, Today 5, Today 4, Today 3,
//  Today 2, Today 1,
//  Today]).LegendTex:

//  'Max Temp';
//  Chart1. LoadFromDataArray(1,
//  [12.3, 8.5, 11.4, 10.6, 12.4, 14.2, 13.1],
//  [Today 6, Today 5, Today 4, Today 3, Today 2, Today 1, Today]). LegendText

  Chart1.LoadFromDataArray(0, [30, 50, 20, 65, 85, 90, 95], nil,
    ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo']
    ).LegendText := 'Vendas da semana';
end;

procedure TMainView.btnAdicionarSerieVendasAVistaClick(Sender: TObject);
var
  LSerieAVista: TTMSFNCChartSerie;
begin
  LSerieAVista := Chart1.AddSeriesFromDataArray([20, 25, 14, 15, 55, 68, 89]);
  LSerieAVista.YValues.Positions := [ypCenter];
  LSerieAVista.LegendText := 'Vendas à vista';
end;

procedure TMainView.btnAdicionarSerieVendasAPrazoClick(Sender: TObject);
var
  LSerieAPrazo: TTMSFNCChartSerie;
begin
  LSerieAPrazo := Chart1.AddSeriesFromDataArray([10, 25, 6, 40, 15, 22, 6]);
  LSerieAPrazo.YValues.Positions := [ypCenter];
  LSerieAPrazo.LegendText := 'Vendas a prazo';
end;

end.
