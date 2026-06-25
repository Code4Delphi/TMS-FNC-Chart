program TMSFNCChartDatabaseVendas;

uses
  Vcl.Forms,
  ChartDatabase.Vendas.View in 'Src\ChartDatabase.Vendas.View.pas' {ChartDatabaseVendasView};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TChartDatabaseVendasView, ChartDatabaseVendasView);
  Application.Run;
end.
