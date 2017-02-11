
{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{       Copyright (c) 1999 Inprise Corporation          }
{                                                       }
{ Руссификация: 1999 Polaris Software                   }
{               http://members.xoom.com/PolarisSoft     }
{*******************************************************}

unit WbmConst;

interface

resourcestring
  sDataSetFieldBlank = 'Поле набора данных (Data set) - пустое';
  sDataSetFieldNotFound = 'Поле набора данных (Data set) не найдено: %s';
  sNotDataSetField = 'Поле %s - не поле набора данных (dataset)';
  ScriptTableName = '%s_Table';
  sNoXMLBroker = '%s: не указан XMLBroker';
  sFieldNotFound = '%0:s: Поле "%1:s" не найдено';
  sXMLBrokerNotDefined = '%s.XMLBroker = nil';
  sSubmitQuery = 'Submit';
  sResetQuery = 'Reset';
  sApplyUpdates = 'Apply Updates';
  sFieldNameBlank = '%s.FieldName = ''''';
  sXMLComponentNotDefined = '%s.XMLComponent = nil';
  ScriptNamesVar = '%s_Names';
  ScriptIDsVar = '%s_IDs';
  ScriptXMLDisplayName = '%s_Disp';
  sInvalidParent = 'Неверный родитель (предок)';
  sDuplicateStatusField = 'Поле %s проигнорировано, допускается только одно статус поле';
  sFirstButton = '|<';
  sLastButton = '>|';
  sPriorButton = '<';
  sNextButton = '>';
  sPriorPageButton = '<<';
  sNextPageButton = '>>';
  sDeleteButton = ' - ';
  sInsertButton = ' + ';
  sUndoButton = 'Undo';
  sPostButton = 'Post';
  sWarningsBody = '<TABLE BORDER=1 CELLPADDING=4>'#13#10 +
                '<TR><TD><P ALIGN=CENTER>Design-time Warnings<P>'#13#10 +
                '%s'#13#10 +
                '</TD></TD>'#13#10 +
                '</TABLE>'#13#10;
  ScriptDocumentVarName = '%s_Doc';
  ScriptXMLVarName = '%s_XML';
  sInvalidWebComponentsRegistration =  'Неверная регистрация Web компонента';
  sInvalidWebComponentsEnumeration =  'Неверная нумерация Web компонента';
  sInvalidWebComponentsCreation =  'Неверное создание Web компонента';
  ScriptRowSetVarName = '%s_RS';
  sApplyUpdatesError = 'Ошибка ApplyUpdates.  Номер ошибки: %d.';
  sDeltaNotFound = 'Не указан Delta Packet';
  sXMLBrokerNotConnected = 'XMLBroker: %s не подключен';
  sDataSetNotActive = 'DataSet: %s не активен';

implementation

end.

