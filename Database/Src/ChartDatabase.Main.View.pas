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
    procedure FormCreate(Sender: TObject);
    procedure btnAbrirClick(Sender: TObject);
    procedure btnAlterarChartTypeClick(Sender: TObject);
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
  ClientDataSet1.FieldDefs.Add('valor', ftFloat);
  ClientDataSet1.CreateDataSet;

  i := 10;
  for LDiasAtras := 10 downto 1 do
  begin
    ClientDataSet1.Append;
    ClientDataSet1.FieldByName('id').AsInteger := i;
    ClientDataSet1.FieldByName('data').AsDateTime := Date - LDiasAtras;
    ClientDataSet1.FieldByName('valor').AsFloat := Self.GetNumeroAleatorio;
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
  LSerieChart: TTMSFNCChartSerie;
begin
  if TMSFNCChartDatabaseAdapter1.Active then
  begin
    TMSFNCChartDatabaseAdapter1.Active := False;
    lbStatusDataBase.Caption := 'Desconectado';
    Exit;
  end;

  //LIMPA TODAS AS SERIES DO ChartDatabaseAdapter
  TMSFNCChartDatabaseAdapter1.Source.Series.Clear;
  //SETAMOS PARA FALSE PARA QUE NOS MESMO CRIEMOS AS SERIES
  TMSFNCChartDatabaseAdapter1.AutoCreateSeries := False;

  //ADICIONE UMA SERIE AO ChartDatabaseAdapter
  LSeriesItem := TMSFNCChartDatabaseAdapter1.Source.Series.Add;
  LSeriesItem.YValue := 'valor';
  LSeriesItem.XValue := 'data';
  LSeriesItem.XLabel := 'Data';

  TMSFNCChartDatabaseAdapter1.Active := True;
  lbStatusDataBase.Caption := 'Conectado';

  btnAlterarChartType.Click;
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
  LSerieChart := TMSFNCChart1.Series[0];
  LSerieChart.ChartType := TTMSFNCChartSerieType(cBoxChartType.ItemIndex);
  LSerieChart.LegendText := 'Vendas por dia';
  LSerieChart.Markers.Visible := True;
end;

end.
