unit ChartDatabase.Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes, VCL.TMSFNCChart, Data.DB, Datasnap.DBClient, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCChartDatabaseAdapter;

type
  TChartDatabaseMainView = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    TMSFNCPieChart1: TTMSFNCPieChart;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    TMSFNCChartDatabaseAdapter1: TTMSFNCChartDatabaseAdapter;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChartDatabaseMainView: TChartDatabaseMainView;

implementation

{$R *.dfm}

end.
