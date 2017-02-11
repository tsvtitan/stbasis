unit UPaymentData;

interface

{$I stbasis.inc}

uses Windows, Forms, Classes, Controls, IBDatabase, UMainUnited, extctrls, Graphics,
     tsvSecurity;

var
  isInitAll: Boolean=false;
  IBDB,IBDBSec: TIBDatabase;
  IBT,IBTSec: TIBTransaction;
  TempStr: String;
  IniStr: String;
  MainTypeLib: TTypeLib=ttleDefault;
  FSecurity: TTsvSecurity;
  
  ListOptionHandles: TList;
  ListToolBarHandles: TList;
  ListInterfaceHandles: TList;
  ListMenuHandles: TList;
  ListInterpreterFunHandles: TList;

  // handles

  hInterfaceRbkPurpose: THandle;
  hInterfaceRbkCard: THandle;
  hInterfaceRbkPayment: THandle;

  hMenuRBooks: THandle;
  hMenuRBooksPurpose: THandle;
  hMenuRBooksCard: THandle;
  hMenuRBooksPayment: THandle;

  hMenuRpts: THandle;

  hMenuOpts: THandle;

const

  SKey='C453A4B8E8D98E82F35B67F433E3B4DA'; // Payment

  LibraryHint='Содержит справочники и отчеты необходимые для платежной системы.';
  LibraryProgrammers='Томилов Сергей';

  // formats

  // Sections

  // Formats

  // Interface Names

  NameRbkPurpose='Справочник назначений платежа';
  NameRbkCard='Справочник карт оплаты';
  NameRbkPayment='Справочник платежей';

  // Db Objects

  tbPurpose='purpose';
  tbCard='card';
  tbPayment='payment';

  // Sqls

  SQLRbkPurpose='Select * from '+tbPurpose+' ';
  SQLRbkCard='Select * from '+tbCard+' ';
  SQLRbkPayment='Select p.*, c.num_card as num_card, pp.name as purpose_name from '+
                tbPayment+' p join '+
                tbCard+' c on c.card_id=p.card_id join '+
                tbPurpose+' pp  on pp.purpose_id=p.purpose_id ';

implementation

initialization
  FSecurity:=TTsvSecurity.Create;
  FSecurity.Key:=SKey;

finalization
  FSecurity.Free;


end.
