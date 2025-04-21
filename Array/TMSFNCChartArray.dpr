program TMSFNCChartArray;

uses
  Vcl.Forms,
  ChartArray.Main.View in 'Src\ChartArray.Main.View.pas' {ChartArrayMainView};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TChartArrayMainView, ChartArrayMainView);
  Application.Run;
end.
