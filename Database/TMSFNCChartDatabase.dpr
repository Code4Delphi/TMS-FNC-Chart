program TMSFNCChartDatabase;

uses
  Vcl.Forms,
  ChartDatabase.Main.View in 'Src\ChartDatabase.Main.View.pas' {ChartDatabaseMainView};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TChartDatabaseMainView, ChartDatabaseMainView);
  Application.Run;
end.
