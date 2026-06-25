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
    procedure TMSFNCChartDatabaseAdapter1FieldsToPoint(Sender: TObject; AFields: TFields; ASeries: TTMSFNCChartSerie;
      APoint: TTMSFNCChartPoint);
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
    procedure ConfigChartLinhaPorGrupo;
    procedure PrepararAdapter;
    function ChartTypeSelecionado: TTMSFNCChartSerieType;
    function CorSerie(const AIndex: Integer): TTMSFNCGraphicsColor;
    function ChartTypeLinhaSelecionado: Boolean;
  public

  end;

var
  ChartDatabaseVendasView: TChartDatabaseVendasView;

implementation

{$R *.dfm}

procedure TChartDatabaseVendasView.FormCreate(Sender: TObject);
begin
  FDConnection1.Params.Values['Database'] := TPath.Combine(ExtractFilePath(ParamStr(0)), '..\Data\vendas.db');

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

  FDConnection1.Connected := True;
  FDQuery1.Open;
end;

procedure TChartDatabaseVendasView.btnAbrirClick(Sender: TObject);
begin
  if TMSFNCChartDatabaseAdapter1.Active or (TMSFNCChart1.Series.Count > 0) then
  begin
    TMSFNCChartDatabaseAdapter1.Active := False;
    TMSFNCChart1.Series.Clear;
    lbStatusDataBase.Caption := 'Desconectado';
    Exit;
  end;

  if Self.ChartTypeLinhaSelecionado then
    Self.ConfigChartLinhaPorGrupo
  else
  begin
    Self.PrepararAdapter;
    TMSFNCChartDatabaseAdapter1.Active := True;
    Self.ConfigChart;
  end;

  lbStatusDataBase.Caption := 'Conectado';
end;

procedure TChartDatabaseVendasView.TMSFNCChartDatabaseAdapter1FieldsToSeries(Sender: TObject; AFields: TFields; ASeries: TTMSFNCChartSerie);
begin
  ASeries.ChartType := Self.ChartTypeSelecionado;
  ASeries.LegendText := 'Vendas por grupo';
  ASeries.ShowInLegend := False;
  ASeries.Legend.Visible := True;
  ASeries.Legend.Position := TTMSFNCChartLegendPosition.lpTopLeft;
  ASeries.Markers.Visible := ckMostrarMarcador.Checked;
  ASeries.Labels.Visible := ckMostrarLabels.Checked;
  ASeries.YValues.Title.Text := 'Total em vendas';
  ASeries.XValues.Title.Text := 'Grupos';
end;

procedure TChartDatabaseVendasView.TMSFNCChartDatabaseAdapter1FieldsToPoint(Sender: TObject; AFields: TFields;
  ASeries: TTMSFNCChartSerie; APoint: TTMSFNCChartPoint);
begin
  APoint.LegendText := APoint.XValueText;
end;

procedure TChartDatabaseVendasView.btnAplicarAlteracoesClick(Sender: TObject);
begin
  Self.ConfigChart;
end;

procedure TChartDatabaseVendasView.ConfigChart;
var
  LSerieChart: TTMSFNCChartSerie;
begin
  if Self.ChartTypeLinhaSelecionado then
  begin
    Self.ConfigChartLinhaPorGrupo;
    Exit;
  end;

  if not TMSFNCChartDatabaseAdapter1.Active then
  begin
    if TMSFNCChart1.Series.Count = 0 then
    begin
      ShowMessage('DatabaseAdapter não esta ativo');
      btnAbrir.SetFocus;
      Exit;
    end;

    Self.PrepararAdapter;
    TMSFNCChartDatabaseAdapter1.Active := True;
  end;

  for var i := 0 to Pred(TMSFNCChart1.Series.Count) do
  begin
    LSerieChart := TMSFNCChart1.Series[i];
    LSerieChart.ChartType := Self.ChartTypeSelecionado;
    LSerieChart.LegendText := 'Vendas por grupo';
    LSerieChart.ShowInLegend := False;
    LSerieChart.Legend.Visible := True;
    LSerieChart.Legend.Position := TTMSFNCChartLegendPosition.lpTopLeft;
    LSerieChart.Markers.Visible := ckMostrarMarcador.Checked;
    LSerieChart.Labels.Visible := ckMostrarLabels.Checked;
  end;

  TMSFNCChart1.Appearance.ColorScheme := TTMSFNCChartColorScheme(cBoxEsquemaCores.ItemIndex);
end;

procedure TChartDatabaseVendasView.PrepararAdapter;
begin
  TMSFNCChartDatabaseAdapter1.Active := False;
  TMSFNCChartDatabaseAdapter1.AutoCreateSeries := False;
  TMSFNCChartDatabaseAdapter1.Source.Series.Clear;

  var LSeriesItem := TMSFNCChartDatabaseAdapter1.Source.Series.Add;
  LSeriesItem.YValue := FDQuery1TotalVendas.FieldName;
  LSeriesItem.XValue := FDQuery1id_grupo.FieldName;
  LSeriesItem.XLabel := FDQuery1nome_grupo.FieldName;
end;

procedure TChartDatabaseVendasView.ConfigChartLinhaPorGrupo;
var
  LSeries: array[1..5] of TTMSFNCChartSerie;
begin
  TMSFNCChartDatabaseAdapter1.Active := False;
  TMSFNCChart1.BeginUpdate;
  try
    TMSFNCChart1.Series.Clear;
    TMSFNCChart1.Appearance.ColorScheme := TTMSFNCChartColorScheme(cBoxEsquemaCores.ItemIndex);
    TMSFNCChart1.Legend.Visible := True;

    for var i := Low(LSeries) to High(LSeries) do
      LSeries[i] := nil;

    var LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := FDConnection1;
      LQuery.SQL.Add('select');
      LQuery.SQL.Add('  strftime("%m/%Y", data_venda) as mes_venda,');
      LQuery.SQL.Add('  id_grupo,');
      LQuery.SQL.Add('  nome_grupo,');
      LQuery.SQL.Add('  sum(valor_total) as TotalVendas');
      LQuery.SQL.Add('from vendas');
      LQuery.SQL.Add('group by strftime("%Y-%m", data_venda), mes_venda, id_grupo, nome_grupo');
      LQuery.SQL.Add('order by id_grupo, strftime("%Y-%m", data_venda)');
      LQuery.Open;

      while not LQuery.Eof do
      begin
        var LIdGrupo := LQuery.FieldByName('id_grupo').AsInteger;

        if (LIdGrupo >= Low(LSeries)) and (LIdGrupo <= High(LSeries)) then
        begin
          if not Assigned(LSeries[LIdGrupo]) then
          begin
            var LCor := Self.CorSerie(Pred(LIdGrupo));
            LSeries[LIdGrupo] := TMSFNCChart1.Series.Add;
            LSeries[LIdGrupo].ChartType := TTMSFNCChartSerieType.ctLine;
            LSeries[LIdGrupo].LegendText := LQuery.FieldByName('nome_grupo').AsString;
            LSeries[LIdGrupo].ShowInLegend := True;
            LSeries[LIdGrupo].Legend.Visible := False;
            LSeries[LIdGrupo].Markers.Visible := ckMostrarMarcador.Checked;
            LSeries[LIdGrupo].Labels.Visible := ckMostrarLabels.Checked;
            LSeries[LIdGrupo].AutoXRange := arCommon;
            LSeries[LIdGrupo].AutoYRange := arCommonZeroBased;
            LSeries[LIdGrupo].Stroke.Color := LCor;
            LSeries[LIdGrupo].Fill.Color := LCor;
            LSeries[LIdGrupo].Markers.Fill.Color := LCor;
            LSeries[LIdGrupo].Markers.Stroke.Color := LCor;

            if LIdGrupo = Low(LSeries) then
            begin
              LSeries[LIdGrupo].YValues.Positions := [TTMSFNCChartYAxisPosition.ypLeft];
              LSeries[LIdGrupo].XValues.Positions := [TTMSFNCChartXAxisPosition.xpBottom];
              LSeries[LIdGrupo].YGrid.Visible := True;
              LSeries[LIdGrupo].XGrid.Visible := True;
              LSeries[LIdGrupo].YValues.Title.Text := 'Total em vendas';
              LSeries[LIdGrupo].XValues.Title.Text := 'Mes';
            end
            else
            begin
              LSeries[LIdGrupo].YValues.Positions := [];
              LSeries[LIdGrupo].XValues.Positions := [];
              LSeries[LIdGrupo].YGrid.Visible := False;
              LSeries[LIdGrupo].XGrid.Visible := False;
            end;
          end;

          LSeries[LIdGrupo].AddPoint(LQuery.FieldByName('TotalVendas').AsFloat,
            LQuery.FieldByName('mes_venda').AsString, gcNull, LQuery.FieldByName('nome_grupo').AsString);
        end;

        LQuery.Next;
      end;
    finally
      LQuery.Free;
    end;
  finally
    TMSFNCChart1.EndUpdate;
  end;
end;

function TChartDatabaseVendasView.CorSerie(const AIndex: Integer): TTMSFNCGraphicsColor;
begin
  if TMSFNCChart1.Appearance.ColorList.Count > 0 then
    Exit(TMSFNCChart1.Appearance.ColorList[AIndex mod TMSFNCChart1.Appearance.ColorList.Count].Color);

  Result := gcNull;
end;

function TChartDatabaseVendasView.ChartTypeLinhaSelecionado: Boolean;
begin
  Result := Self.ChartTypeSelecionado = TTMSFNCChartSerieType.ctLine;
end;
function TChartDatabaseVendasView.ChartTypeSelecionado: TTMSFNCChartSerieType;
begin
  var LValue := GetEnumValue(TypeInfo(TTMSFNCChartSerieType), cBoxChartType.Text);

  if LValue < 0 then
    Exit(TTMSFNCChartSerieType.ctPie);

  Result := TTMSFNCChartSerieType(LValue);
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
