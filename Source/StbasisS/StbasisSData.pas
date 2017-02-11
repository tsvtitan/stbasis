unit StbasisSData;

interface

const
  TCPServerDefaultPort=55555;
  
const
  SRegisterMidas='"%s" /s';
  SUnRegisterMidas='"%s" /u /s';
  SRegSvr32='regsvr32.exe';
  SMidas='midas.dll';
  SRegisterAction='open';

  SParamConfig='config';
  SParamLog='log';
  SParamInstall='install';
  SParamUnInstall='uninstall';
  SParamIsService='IsService';

  SIniExtension='.ini';
  SLogExtension='.log';

  SSectionMain='Main';
  SSectionDependencies='Dependencies';
  SSectionPosition='Position';
  SSectionPrimaryDb='Primary Db';
  SSectionTCPServer='TCP Server';

  SParamName='Name';
  SParamDisplayName='DisplayName';
  SParamDescription='Discription';
  SParamClearLog='ClearLog';
  SParamDatabaseName='DatabaseName';
  SParamUserName='UserName';
  SParamPassword='Password';
  SParamRoleName='RoleName';
  SParamCodePage='lc_ctype=WIN1251';
  SParamTransaction='read_committed'+#13+
                    'rec_version'+#13+
                    'nowait';
  SParamBindings='Bindings';

                      

implementation

end.
