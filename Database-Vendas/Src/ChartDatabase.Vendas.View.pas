unit ChartDatabase.Vendas.View;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  TypInfo,
  System.IOUtils,
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
  Vcl.Buttons,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TChartDatabaseVendasView = class(TForm)
    pnCorpo: TPanel;
    DataSource1: TDataSource;
    TMSFNCChart1: TTMSFNCChart;
    pnBotoes: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    btnAbrir: TBitBtn;
    lbStatusDataBase: TLabel;
    lbChartType: TLabel;
    lbEsquemaCores: TLabel;
    cBoxChartType: TComboBox;
    cBoxEsquemaCores: TComboBox;
    btnAplicarAlteracoes: TBitBtn;
    ckMostrarMarcador: TCheckBox;
    ckMostrarLabels: TCheckBox;
    btnConfigurarGrafico: TBitBtn;
    btnSalvarGrafico: TButton;
    btnModoDark: TButton;
    btnModoLight: TButton;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDQuery1id_grupo: TIntegerField;
    FDQuery1nome_grupo: TStringField;
    FDQuery1TotalVendas: TFloatField;
    TMSFNCChartDatabaseAdapter1: TTMSFNCChartDatabaseAdapter;
    procedure FormCreate(Sender: TObject);
    procedure btnAbrirClick(Sender: TObject);
    procedure btnAplicarAlteracoesClick(Sender: TObject);
    procedure TMSFNCChartDatabaseAdapter1FieldsToSeries(Sender: TObject; AFields: TFields; ASeries: TTMSFNCChartSerie);
    procedure btnConfigurarGraficoClick(Sender: TObject);
    procedure btnSalvarGraficoClick(Sender: TObject);
    procedure btnModoDarkClick(Sender: TObject);
    procedure btnModoLightClick(Sender: TObject);
  private
    procedure BuscarDados;
    procedure PreenchercBoxChartType;
    procedure PreenchercBoxEsquemaCores;
    procedure ConfigTemaLabels(const ATemaDark: Boolean = False);
    procedure ConfigChart;
    procedure ConfigLegendaPizza(const ASerieChart: TTMSFNCChartSerie);
  public

  end;

var
  ChartDatabaseVendasView: TChartDatabaseVendasView;

implementation

{$R *.dfm}

procedure TChartDatabaseVendasView.FormCreate(Sender: TObject);
begin
  Self.PreenchercBoxChartType;
  Self.PreenchercBoxEsquemaCores;
  Self.BuscarDados;
end;

procedure TChartDatabaseVendasView.PreenchercBoxChartType;
var
  LItem: TTMSFNCChartSerieType;
begin
  cBoxChartType.Items.Clear;

  for LItem := Low(TTMSFNCChartSerieType) to High(TTMSFNCChartSerieType) do
    cBoxChartType.Items.Add(GetEnumName(TypeInfo(TTMSFNCChartSerieType), Integer(LItem)));

  cBoxChartType.ItemIndex := Integer(TTMSFNCChartSerieType.ctPie);
end;

procedure TChartDatabaseVendasView.PreenchercBoxEsquemaCores;
var
  LItem: TTMSFNCChartColorScheme;
begin
  cBoxEsquemaCores.Items.Clear;

  for LItem := Low(TTMSFNCChartColorScheme) to High(TTMSFNCChartColorScheme) do
    cBoxEsquemaCores.Items.Add(GetEnumName(TypeInfo(TTMSFNCChartColorScheme), Integer(LItem)));

  cBoxEsquemaCores.ItemIndex := Integer(TTMSFNCChartColorScheme.ccsExcel);
end;

procedure TChartDatabaseVendasView.BuscarDados;
begin
  TMSFNCChartDatabaseAdapter1.Active := False;
  FDQuery1.Close;
  FDConnection1.Connected := False;
  FDConnection1.Params.Values['Database'] := TPath.Combine(ExtractFilePath(ParamStr(0)), '..\Data\vendas.db');
  FDConnection1.Connected := True;
  FDQuery1.Open;
end;

procedure TChartDatabaseVendasView.btnAbrirClick(Sender: TObject);
var
  LSeriesItem: TTMSFNCChartDatabaseAdapterSeriesItem;
begin
  if TMSFNCChartDatabaseAdapter1.Active then
  begin
    TMSFNCChartDatabaseAdapter1.Active := False;
    lbStatusDataBase.Caption := 'Desconectado';
    Exit;
  end;

  TMSFNCChartDatabaseAdapter1.AutoCreateSeries := False;
  TMSFNCChartDatabaseAdapter1.Source.Series.Clear;

  LSeriesItem := TMSFNCChartDatabaseAdapter1.Source.Series.Add;
  LSeriesItem.YValue := FDQuery1TotalVendas.FieldName;
  LSeriesItem.XValue := FDQuery1id_grupo.FieldName;
  LSeriesItem.XLabel := FDQuery1nome_grupo.FieldName;

  TMSFNCChartDatabaseAdapter1.Active := True;
  Self.ConfigChart;
  lbStatusDataBase.Caption := 'Conectado';
end;

procedure TChartDatabaseVendasView.TMSFNCChartDatabaseAdapter1FieldsToSeries(Sender: TObject; AFields: TFields; ASeries: TTMSFNCChartSerie);
begin
  ASeries.ChartType := TTMSFNCChartSerieType(cBoxChartType.ItemIndex);
  ASeries.LegendText := 'Vendas por grupo';
  ASeries.Markers.Visible := ckMostrarMarcador.Checked;
  ASeries.Labels.Visible := ckMostrarLabels.Checked;
  ASeries.YValues.Title.Text := 'Total em vendas';
  ASeries.XValues.Title.Text := 'Grupos';
end;

procedure TChartDatabaseVendasView.btnAplicarAlteracoesClick(Sender: TObject);
begin
  Self.ConfigChart;
end;

procedure TChartDatabaseVendasView.ConfigChart;
var
  LSerieChart: TTMSFNCChartSerie;
begin
  if not TMSFNCChartDatabaseAdapter1.Active then
  begin
    ShowMessage('DatabaseAdapter não esta ativo');
    btnAbrir.SetFocus;
    Exit;
  end;

  for var i := 0 to Pred(TMSFNCChart1.Series.Count) do
  begin
    LSerieChart := TMSFNCChart1.Series[i];
    LSerieChart.ChartType := TTMSFNCChartSerieType(cBoxChartType.ItemIndex);
    LSerieChart.LegendText := 'Vendas por grupo';
    LSerieChart.Markers.Visible := ckMostrarMarcador.Checked;
    LSerieChart.Labels.Visible := ckMostrarLabels.Checked;
    Self.ConfigLegendaPizza(LSerieChart);
  end;

  TMSFNCChart1.Appearance.ColorScheme := TTMSFNCChartColorScheme(cBoxEsquemaCores.ItemIndex);
end;

procedure TChartDatabaseVendasView.ConfigLegendaPizza(const ASerieChart: TTMSFNCChartSerie);
begin
  if not (ASerieChart.ChartType in [TTMSFNCChartSerieType.ctPie, TTMSFNCChartSerieType.ctVariableRadiusPie,
    TTMSFNCChartSerieType.ctSizedPie]) then
  begin
    ASerieChart.ShowInLegend := True;
    ASerieChart.Legend.Visible := False;
    Exit;
  end;

  ASerieChart.ShowInLegend := False;
  ASerieChart.Legend.Visible := True;
  ASerieChart.Legend.Position := TTMSFNCChartLegendPosition.lpTopLeft;

  for var i := 0 to Pred(ASerieChart.Points.Count) do
    ASerieChart.Points[i].LegendText := ASerieChart.Points[i].XValueText;
end;

{$REGION 'Extras'}
procedure TChartDatabaseVendasView.btnConfigurarGraficoClick(Sender: TObject);
begin
  TMSFNCChart1.ShowEditor(TTMSFNCChartEditorType.etGeneral);
end;

procedure TChartDatabaseVendasView.btnSalvarGraficoClick(Sender: TObject);
var
  LSaveDialog: TSaveDialog;
begin
  LSaveDialog := TSaveDialog.Create(nil);
  try
    LSaveDialog.Title := 'Salvar imagem do gráfico';
    LSaveDialog.Filter := 'Imagem PNG (*.png)|*.png';
    LSaveDialog.DefaultExt := 'png';
    LSaveDialog.FileName := 'ImagemSalva.png';

    if LSaveDialog.Execute then
      TMSFNCChart1.SaveToImage(LSaveDialog.FileName);
  finally
    LSaveDialog.Free;
  end;
end;

procedure TChartDatabaseVendasView.btnModoLightClick(Sender: TObject);
var
  LSerieChart: TTMSFNCChartSerie;
begin
  Self.Color := clBtnFace;

  TMSFNCChart1.Appearance.GlobalFont.Color := gcNull;
  TMSFNCChart1.Fill.Color := clWhite;
  TMSFNCChart1.Legend.Fill.Color := clWhite;

  for var i := 0 to pred(TMSFNCChart1.Series.Count) do
  begin
    LSerieChart := TMSFNCChart1.Series[i];
    LSerieChart.Labels.Fill.Color := clWhite;
    LSerieChart.Labels.Font.Color := clWindowText;
  end;

  Self.ConfigTemaLabels;
end;

procedure TChartDatabaseVendasView.btnModoDarkClick(Sender: TObject);
var
  LSerieChart: TTMSFNCChartSerie;
begin
  Self.Color := $00403A34;

  TMSFNCChart1.Appearance.GlobalFont.Color := clWhite;
  TMSFNCChart1.Fill.Color := $00403A34;
  TMSFNCChart1.Legend.Fill.Color := $00292521;
  TMSFNCChart1.Legend.Font.Color := clWindowText;

  for var i := 0 to pred(TMSFNCChart1.Series.Count) do
  begin
    LSerieChart := TMSFNCChart1.Series[i];
    LSerieChart.Labels.Fill.Color := $00bcb7b3;
    LSerieChart.Labels.Font.Color := clWindowText;
    TMSFNCChart1.Legend.Font.Color := clWindow;
  end;

  Self.ConfigTemaLabels(True);
end;

procedure TChartDatabaseVendasView.ConfigTemaLabels(const ATemaDark: Boolean = False);
begin
  lbChartType.Font.Color := clWindowText;
  lbEsquemaCores.Font.Color := clWindowText;
  lbStatusDataBase.Font.Color := clWindowText;

  if ATemaDark then
  begin
    lbChartType.Font.Color := clWindow;
    lbEsquemaCores.Font.Color := clWindow;
     lbStatusDataBase.Font.Color := clWindow;
  end;
end;
{$ENDREGION}

end.
