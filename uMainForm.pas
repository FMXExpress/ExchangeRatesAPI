unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  System.Rtti, FMX.Grid.Style, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.StdCtrls,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, REST.Client,
  Data.Bind.ObjectScope, FMX.Edit, FMX.Layouts, FMX.ListBox, FMX.MultiView;

type
  TMainForm = class(TForm)
    CurrencyClient: TRESTClient;
    CurrencyRequest: TRESTRequest;
    CurrencyResponse: TRESTResponse;
    CurrencyAdapter: TRESTResponseDataSetAdapter;
    TmpCurrencyMemTable: TFDMemTable;
    MaterialOxfordBlueSB: TStyleBook;
    ExchangeClient: TRESTClient;
    ExchangeRequest: TRESTRequest;
    ExchangeResponse: TRESTResponse;
    ExchangeAdapter: TRESTResponseDataSetAdapter;
    TmpExchangeMemTable: TFDMemTable;
    StringGrid1: TStringGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    RefreshButton: TButton;
    RunOnce: TTimer;
    CurrencyMemTable: TFDMemTable;
    ListBox1: TListBox;
    BindSourceDB2: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    SymbolEdit: TEdit;
    ExchangeRateMemTable: TFDMemTable;
    BindSourceDB3: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB3: TLinkGridToDataSource;
    Layout1: TLayout;
    MultiView1: TMultiView;
    MenuButton: TButton;
    Layout2: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    LinkPropertyToFieldText: TLinkPropertyToField;
    LinkControlToPropertyText: TLinkControlToProperty;
    procedure RunOnceTimer(Sender: TObject);
    procedure CurrencyMemTableAfterScroll(DataSet: TDataSet);
    procedure RefreshButtonClick(Sender: TObject);
    procedure StringGrid1Resize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.RefreshButtonClick(Sender: TObject);
begin
  ExchangeRequest.Params.ParameterByName('Base').Value := SymbolEdit.Text;
  ExchangeRequest.ExecuteAsync(procedure begin
    ExchangeRateMemTable.EmptyDataSet;
    for var I := 0 to TmpExchangeMemTable.Fields.Count-1 do
    begin
      ExchangeRateMemTable.AppendRecord([TmpExchangeMemTable.Fields.Fields[I].FieldName,TmpExchangeMemTable.Fields.Fields[I].Value])
    end;
    ExchangeRateMemTable.Locate('Symbol',VarArrayOf([SymbolEdit.Text]),[]);
  end);
end;

procedure TMainForm.CurrencyMemTableAfterScroll(DataSet: TDataSet);
begin
  SymbolEdit.Text := CurrencyMemTable.FieldByName('Symbol').AsWideString;
end;

procedure TMainForm.RunOnceTimer(Sender: TObject);
begin
  RunOnce.Enabled := False;
  CurrencyRequest.ExecuteAsync(procedure begin
    CurrencyMemTable.EmptyDataSet;
    for var I := 0 to TmpCurrencyMemTable.Fields.Count-1 do
    begin
      CurrencyMemTable.AppendRecord([TmpCurrencyMemTable.Fields.Fields[I].FieldName,TmpCurrencyMemTable.Fields.Fields[I].Value])
    end;
    CurrencyMemTable.Locate('Symbol',VarArrayOf(['USD']),[]);
    RefreshButtonClick(Self);
  end);
end;

procedure TMainForm.StringGrid1Resize(Sender: TObject);
begin
  LinkGridToDataSourceBindSourceDB3.Columns[0].Width := Trunc(StringGrid1.Width/2)-12;
  LinkGridToDataSourceBindSourceDB3.Columns[1].Width := Trunc(StringGrid1.Width/2)-12;
end;

end.
