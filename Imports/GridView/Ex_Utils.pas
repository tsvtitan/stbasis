{
  Библиотека дополнительных компонентов

  Утилиты

  Роман М. Мочалов
  E-mail: roman@sar.nnov.ru
}

unit Ex_Utils;

interface

uses
  Windows, ShellAPI, ShlObj, SysUtils, Messages, Graphics, Classes, Controls,
  Forms, Registry, Math;

type

  { WndProc hook record }

  TWndHook = record
    Control: TWinControl; { компонент, на который вешается Hook }
    Handle: THandle;      { описатель окна, на который вешается Hook }
    WndProc: TWndMethod;  { новая процедура обработки сообщений }
    Instance: Pointer;    { зарезервировано }
    OldProc: Longint;     { зарезервировано }
  end;

{ Hook WndProc of specified window. }

function CreateWndHook(Control: TWinControl; Handle: THandle; WndProc: TWndMethod): TWndHook;

{ Hook Application WndProc. }

function CreateAppHook(WndProc: TWndMethod): TWndHook;

{ Clear window hook, restore old WndProc. }

procedure FreeWndHook(var Hook: TWndHook);

{ Calling previos WndProc. }

procedure CallWndHook(var Hook: TWndHook; var Message: TMessage);

{ Получение описателя окна, у которого перхватываются сообщения. }

function HookHandle(Hook: TWndHook): THandle;

{ Проверка, установлен ли захват окна. }

function HookAllocated(Hook: TWndHook): Boolean;

{ Инициализация описателя компонента и всехего дочерних компонентов. }

procedure InitControlHandle(Control: TWinControl; Recurse: Boolean);

{ Качественная перерисовка компонента с учетом видимости его владельца. }

function IsControlVisible(Control: TWinControl): Boolean;
function InvalidateControl(Control: TWinControl): Boolean;
function InvalidateControlRect(Control: TWinControl; Rect: TRect; Erase: Boolean): Boolean;

{ Обработка строки с путем иконки вида Диск:\Путь\Файл,номер (подходит для
  задания иконки типа файла в реестре). }

function ExtractIconFile(const IconPath: string): string;
function ExtractIconIndex(const IconPath: string): Integer;
function ExpandIconPath(const IconFile: string; IconIndex: Integer): string;

{ Загрузка иконки из файла по пути вида Диск:\Путь\Файл,номер (например, по
  пути из реестра). }

function LoadIconFromFile(const IconPath: string): HICON;

function LoadLargeIconFromFile(const IconPath: string): HICON;
function LoadSmallIconFromFile(const IconPath: string): HICON;

{ Проверка имени файла и каталога. }

function IsValidFileName(const Name: string): Boolean;

{ Является ли указанный путь каталогом, с'емным устройством. }

function IsFolder(const Name: string): Boolean;
function IsFloppy(const Name: string): Boolean;

{ Пуст ли указанный каталог. }

function IsFolderEmpty(const Name: string; Mask: string): Boolean;

{ Проверка наличия и создание каталога. }

function DirectoryExists(const Name: string): Boolean;
function ForceDirectories(Dir: string): Boolean;

{ Создание резервной копии файла. }

function ExtractBakName(const FileName: string): string;
function CreateBakFile(const FileName: string): Boolean;
function CreateFileCopy(const FileName, CopyName: string): Boolean;

{ Получение красивой короткой строки имени файла из длинной. Удаляет
  названия каталогов до тех пор, пока путь не станет короче указанной
  длины. Возвращаемый результат имеет вид C:\...\Name.exe }

function CompressFilePath(const Path: string; Len: Integer): string;

{ Получение длинного имени файла и пути из сокращения для DOS. Основа взята из
  RXLib, удалены некоторые глюки. }

function GetLongFileName(const ShortName: string): string;
function GetLongPathName(const ShortName: string): string;

{ Генерация имени временного файла для указанного файла. Имя временного
  файла будет начинаться с маски Prefix. ВНИМАНИЕ: генерация временного файла
  выполняется путем вызова соотвествующей функции Windows API, которая в
  для префикса берет только первые 3 символа. }

function GetTemporaryFileName(const BaseFileName, Prefix: string): string;

{ Выделение имени файла из пути с расширением или без. }

function ExtractFileNameEx(const FileName: string; Extension: Boolean): string;

{ Функции поиска подстроки в строке без зависимости от регистра. }

function CasePos(Substr: string; S: string; MatchCase: Boolean): Integer;

{ Функции вставки, удаления и замены символов. }

function ReplaceChar(const S: string; C1, C2: Char): string;
function ReplaceStr(const S: string; S1, S2: string): string;
function RemoveChars(const S: string; C: array of Char): string;
function RemoveLineBreaks(const S: string): string;
function RemoveDoubleSpace(const S: string): string;
function TrimCharLeft(const S: string; C: Char): string;
function TrimCharRight(const S: string; C: Char): string;
function InsertCharLeft(const S: string; C: Char; Len: Integer): string;
function InsertCharRight(const S: string; C: Char; Len: Integer): string;
function TruncLeft(const S: string; MaxLen: Integer): string;
function TruncRight(const S: string; MaxLen: Integer): string;

{ Определение количества строк (если в строке есть переносы). }

function GetLineCount(const S: string): Integer;

{ Наличие параметра командной строки и его значение. }

function ParamExists(const Param: string): Boolean;
function GetParamValue(const Param: string): string;
function GetParamValueDef(const Param: string; const Default: string): string;

{ Удаление раздела и подразделов из реестра с всеми подразделами. }

procedure RegEraseKey(Root: HKEY; const Key: string);
procedure RegEraseKeyEx(Root: HKEY; const Key: string; SubKeys: Boolean);
procedure RegEraseSubKeys(Root: HKEY; const Key: string);

{ Чтение и запись имен и значений раздела в StringList. }

procedure RegReadKey(Root: HKEY; const Key: string; Strings: TStrings);
procedure RegWriteKey(Root: HKEY; const Key: string; Strings: TStrings);

{ Импорт и экспорт ключей реестра. ВНИМАНИЕ: в текущей версии импортитуются
  только строковые значения. }

procedure RegImport(const FileName: string);
procedure RegExport(Root: HKEY; const Key: string; const FileName: string);

{ Перевод строки значения из реестра в строку и наоборот (замена "\\" на "\"). }

function StrToRegStr(const Value: string): string;
function RegStrToStr(const Value: string): string;

{ Перевод: корневой ключ (HKEY_XXX) - строка. }

function RegRootKeyToStr(Root: HKEY): string;
function RegStrToRootKey(const S: string): HKEY;
function RegStrToRootKeyDef(const S: string; Default: HKEY): HKEY;

{ Перевод строки в дату и время. Если строка содержит неверное значение,
  возвращиется значение по умолчанию. }

function StrToTimeDef(const S: string; Default: TDateTime): TDateTime;
function StrToDateDef(const S: string; Default: TDateTime): TDateTime;

{ Перевод времени и даты в строку длинного формата с учетом склонений
  имен месяцев. }

function TimeToLongStr(Time: TDateTime): string;
function DateToLongStr(Date: TDateTime): string;

function DateTimeToLongStr(DateTime: TDateTime): string;

{ Перевод даты и времени в строку короткого формата. }

function TimeToShortStr(Time: TDateTime): string;
function DateToShortStr(Date: TDateTime): string;

{ Перевод времени в строку. Время задается в мсек. }

function MSecToStr(Time: Longint): string;
function MSecToStrFmt(Time: Longint; const Format: string): string;

{ Получение положения окна по умолчанию, как это делается в Windows 
  (эмуляция через внутренний счетчик). Используется для установки 
  положения диалога (Windows игнорирует poDefault для диалогов и 
  ставит их в левый верхний угол). }

function GetDefFormPos: TPoint;
function GetDefFormBounds(Width, Height: Integer): TRect;

{ Устанавливает/снимает положение "всегда сверху" у окна. ВНИМАНИЕ: не 
  меняет при этом свойства FormStyle. }

procedure SetTopMostWindow(Wnd: HWND; TopMost, Activate: Boolean);

{ Вызов функции Application.MessageBox с отображением приложения на
  панели задач. }

function AppMessageBox(const Text, Caption: string; Flags: Longint): Integer;

{ Задержка (аналог Delay из TP). Точность ~5 мсек. Может прервать задержку
  по завершении работы приложения, разрешает приложению обрабатывать
  сообщения (кроме мышки и клавиатуры) во вермя задержки. }

type
  TDelayProc = procedure(var Cancel: Boolean) of object;

procedure AppDelay(TimeOut: DWORD);
procedure AppDelayEx(TimeOut: DWORD; AppTerminate, AppMessages: Boolean; DelayProc: TDelayProc);

{  Получение строки информации о версии файла. Если значение с именем Key
   отсутствует, возвращается значение по умолчанию.

   Наиболее распространенные значения параметра Key:

    CompanyName - производитель
    FileDescription - описание файла
    FileVersion - версия файла
    InternalName - внутреннее имя
    LegalCopyright - копирайт (авторское право)
    LegalTrademarks - товарные знаки
    OriginalFilename - исходное имя файла
    ProductName - название продукта
    ProductVersion - версия продукта
    Comments - комментарии
}

function GetVersionStr(const FileName, Key, Default: string): string;

{$IFDEF VER90 }

{ Returns the smallest and largest value in the data array (MIN/MAX) }

function MinIntValue(const Data: array of Integer): Integer;
function MaxIntValue(const Data: array of Integer): Integer;

{$ENDIF}

implementation

function CreateWndHook(Control: TWinControl; Handle: THandle; WndProc: TWndMethod): TWndHook;
begin
  { запоминаем компонент }
  Result.Control := Control;
  { получаем описатель окна }
  if Assigned(Control) then
  begin
    InitControlHandle(Control, True);
    Result.Handle := Control.Handle;
  end
  else
    Result.Handle := Handle;
  { новая процедура обработки сообщений }
  Result.WndProc := WndProc;
  Result.Instance := MakeObjectInstance(WndProc);
  { устанавливаем ее }
  Result.OldProc := SetWindowLong(Result.Handle, GWL_WNDPROC, Longint(Result.Instance));
end;

function CreateAppHook(WndProc: TWndMethod): TWndHook;
begin
  Result := CreateWndHook(nil, Application.Handle, WndProc);
end;

procedure FreeWndHook(var Hook: TWndHook);
var
  H: THandle;
begin
  with Hook do
  begin
    { получаем описатель }
    H := HookHandle(Hook);
    { проверяем его }
    if H <> INVALID_HANDLE_VALUE then
    begin
      { восстанавливаем процедуру обработки сообщений }
      if OldProc <> 0 then
      begin
        SetWindowLong(H, GWL_WNDPROC, OldProc);
        OldProc := 0;
      end;
      { сбрасываем описатель }
      Handle := INVALID_HANDLE_VALUE;
    end;
    { освобождаем процедуру перехвата }
    if Instance <> nil then
    begin
      FreeObjectInstance(Instance);
      Instance := nil;
    end;
    { сбрасываем остальные параметры }
    WndProc := nil;
    Control := nil;
  end;
end;

type
  TControlHack = class(TWinControl);

procedure CallWndHook(var Hook: TWndHook; var Message: TMessage);
var
  H: THandle;
  P: Pointer;
begin
  with Hook, Message do
  begin
    { получаем описатель }
    H := HookHandle(Hook);
    { проверяем его }
    if H <> INVALID_HANDLE_VALUE then
    begin
      { запоминаем адрес процедуры (может измениться при освобождении захвата) }
      P := Pointer(OldProc);
      { при уничтожении окна освобождаем захват }
      if (Msg = WM_DESTROY) or (Msg = CM_RELEASE) then FreeWndHook(Hook);
      { вызов предыдущей процедуры }
      if Assigned(P) then
        Result := CallWindowProc(P, H, Msg, wParam, lParam)
      else if Control <> nil then
        Result := CallWindowProc(TControlHack(Control).DefWndProc, H, Msg, wParam, lParam)
      else
        DefWindowProc(H, Msg, wParam, lParam);
    end;
  end;
end;

function HookHandle(Hook: TWndHook): THandle;
begin
  with Hook do
    if Control = nil then
      { компонента нет - описатель, переданный пользователем }
      Result := Handle
    else if Control.HandleAllocated then
      { компонент есть и унего есть описатель - возвращаем его }
      Result := Control.Handle
    else
      { описателя нет }
      Result := INVALID_HANDLE_VALUE;
end;

function HookAllocated(Hook: TWndHook): Boolean;
begin
  Result := Hook.Instance <> nil;
end;

procedure InitControlHandle(Control: TWinControl; Recurse: Boolean);
var
  I: Integer;
  ChildControl: TControl;
begin
  { инициализируем описатель компонента }
  Control.HandleNeeded;
  { инициализируем описатели всех дочерних }
  if Recurse then
    for I := 0 to Control.ControlCount - 1 do
    begin
      ChildControl := Control.Controls[I];
      if ChildControl is TWinControl then
        InitControlHandle(TWinControl(ChildControl), True);
    end;
end;

function IsControlVisible(Control: TWinControl): Boolean;
begin
  with Control do
  begin
    { а видим ли сам компонент }
    if (not HandleAllocated) or (not Visible) then
    begin
      Result := False;
      Exit;
    end;
    { в режиме дизайнера владельца не проверяем }
    if csDesigning in ComponentState then
    begin
      Result := True;
      Exit;
    end;
    { компонент видим, если видим владелец }
    Result := (Parent <> nil) and (Parent.Visible);
  end;
end;

function InvalidateControl(Control: TWinControl): Boolean;
var
  Rect: TRect;
begin
  with Control do
  begin
    Rect := ClientRect;
    Result := InvalidateControlRect(Control, Rect, not (csOpaque in ControlStyle));
  end;
end;

function InvalidateControlRect(Control: TWinControl; Rect: TRect; Erase: Boolean): Boolean;
begin
  { видим ли компонент }
  if not IsControlVisible(Control) then
  begin
    Result := False;
    Exit;
  end;
  { обновляем область }
  Result := InvalidateRect(Control.Handle, @Rect, Erase);
end;

function ExtractIconFile(const IconPath: string): string;
var
  I: Integer;
begin
  I := Length(IconPath);
  while (I > 0) and not (IconPath[I] in [',']) do Dec(I);
  if (I > 0) and (IconPath[I] = ',') then
    Result := Trim(Copy(IconPath, 1, I - 1)) else
    Result := Trim(IconPath);
end;

function ExtractIconIndex(const IconPath: string): Integer;
var
  I: Integer;
begin
  I := Length(IconPath);
  while (I > 0) and not (IconPath[I] in [',']) do Dec(I);
  if (I > 0) and (IconPath[I] = ',') then
    Result := StrToIntDef(Trim(Copy(IconPath, I + 1, 255)), 0) else
    Result := StrToIntDef(Trim(IconPath), 0);
end;

function ExpandIconPath(const IconFile: string; IconIndex: Integer): string;
begin
  Result := Format('%s, %d', [IconFile, IconIndex]);
end;

function LoadIconFromFile(const IconPath: string): HICON;
var
  IconFile: string;
  IconIndex: Integer;
begin
  { получаем имя файла и индекс иконки }
  IconFile := ExtractIconFile(IconPath);
  IconIndex := ExtractIconIndex(IconPath);
  { получаем иконку }
  Result := ExtractIcon(HInstance, PChar(IconFile), IconIndex);
end;

function LoadLargeIconFromFile(const IconPath: string): HICON;
var
  IconFile: string;
  IconIndex: Integer;
  LargeIcon, SmallIcon: HICON;
begin
  { получаем имя файла и индекс иконки }
  IconFile := ExtractIconFile(IconPath);
  IconIndex := ExtractIconIndex(IconPath);
  { получаем описатели иконки }
  if ExtractIconEx(PChar(IconFile), IconIndex, LargeIcon, SmallIcon, 1) = 0 then
  begin
    Result := 0;
    Exit;
  end;
  { возвращаем описатель большой иконки }
  Result := LargeIcon;
end;

function LoadSmallIconFromFile(const IconPath: string): HICON;
var
  IconFile: string;
  IconIndex: Integer;
  LargeIcon, SmallIcon: HICON;
begin
  { получаем имя файла и индекс иконки }
  IconFile := ExtractIconFile(IconPath);
  IconIndex := ExtractIconIndex(IconPath);
  { получаем описатели иконки }
  if ExtractIconEx(PChar(IconFile), IconIndex, LargeIcon, SmallIcon, 1) = 0 then
  begin
    Result := 0;
    Exit;
  end;
  { возвращаем описатель маленькой иконки }
  Result := SmallIcon;
end;

function IsValidFileName(const Name: string): Boolean;
const
  C: string = '*?<>|"';
var
  I, P: Integer;
begin
  P := Pos(':', Name);
  if (P <> 0) and (P <> 2) then
  begin
    Result := False;
    Exit;
  end;
  for I := 1 to Length(C) do
  begin
    P := Pos(C[I], Name);
    if P <> 0 then
    begin
      Result := False;
      Exit;
    end;
  end;
  if (Name = '.') or (Name = '..') then { ! only for this release }
  begin
    Result := False;
    Exit;
  end;
  Result := True;
end;

function IsFolder(const Name: string): Boolean;
var
  SR: TSearchRec;
begin
  Result := False;
  if FindFirst(TrimCharRight(Name, '\'), faDirectory, SR) = 0 then
  try
    Result := SR.Attr and faDirectory <> 0;
  finally
    FindClose(SR);
  end;
end;

function IsFloppy(const Name: string): Boolean;
var
  Info: TSHFileInfo;
begin
  SHGetFileInfo(PChar(Name), 0, Info, SizeOf(Info), SHGFI_ATTRIBUTES);
  Result := Info.dwAttributes and SFGAO_REMOVABLE <> 0;
end;

function IsFolderEmpty(const Name: string; Mask: string): Boolean;
var
  Info: TSHFileInfo;
  SR: TSearchRec;
begin
  SHGetFileInfo(PChar(Name), 0, Info, SizeOf(Info), SHGFI_ATTRIBUTES);
  if Info.dwAttributes and SFGAO_HASSUBFOLDER <> 0 then
  begin
    Result := False;
    Exit;
  end;
  if FindFirst(Name + Mask, faAnyFile and not faSysFile, SR) = 0 then
  try
    Result := False;
    Exit;
  finally
    FindClose(SR);
  end;
  Result := True;
end;

function DirectoryExists(const Name: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function ForceDirectories(Dir: string): Boolean;
begin
  { проверяем имя }
  if Length(Dir) = 0 then
  begin
    Result := False;
    Exit;
  end;
  { удаляем "\" в конце строки }
  Dir := TrimCharRight(Dir, '\');
  { а соществует ли родительский каталог }
  if (Length(Dir) < 3) or DirectoryExists(Dir) or (ExtractFilePath(Dir) = Dir) then
  begin
    Result := True;
    Exit;
  end;
  { создаем родительские каталоги }
  if not ForceDirectories(ExtractFilePath(Dir)) then
  begin
    Result := False;
    Exit;
  end;
  { создаем каталог }
  Result := CreateDir(Dir);
end;

function ExtractBakName(const FileName: string): string;
var
  Ext: string;
  I: Integer;
begin
  { получаем расширение файла }
  I := Length(FileName);
  while (I > 0) and not (FileName[I] in ['.', '\', ':']) do Dec(I);
  { меняем его }
  if (I > 0) and (FileName[I] = '.') then
  begin
    Ext := Copy(FileName, I + 1, 255);
    if Length(Ext) > 2 then Ext := Copy(Ext, 1, Length(Ext) - 1);
    Result := Copy(FileName, 1, I - 1) + '.~' + Ext;
  end
  else
    Result := FileName + '.~';
end;

function CreateBakFile(const FileName: string): Boolean;
var
  BakName: string;
begin
  { имя резервной копии }
  BakName := ExtractBakName(FileName);
  { удаляем файл старой копии }
  if FileExists(BakName) and (not DeleteFile(BakName)) then
  begin
    Result := False;
    Exit;
  end;
  { переименовываем файл }
  if FileExists(FileName) and (not RenameFile(FileName, BakName)) then
  begin
    Result := False;
    Exit;
  end;
  { все прошло успешно }
  Result := True;
end;

function CreateFileCopy(const FileName, CopyName: string): Boolean;
begin
  { удаляем файл старой копии }
  if FileExists(CopyName) and (not DeleteFile(CopyName)) then
  begin
    Result := False;
    Exit;
  end;
  { создаем новую копию }
  if FileExists(FileName) and (not CopyFile(PChar(FileName), PChar(CopyName), False)) then
  begin
    Result := False;
    Exit;
  end;
  { все прошло успешно }
  Result := True;
end;

function CompressFilePath(const Path: string; Len: Integer): string;
var
  L, I, P1, P2: Integer;
begin
  { результат }
  Result := Path;
  { получаем длину пути }
  L := Length(Path);
  { проверяем ее }
  if L > Len then
  begin
    { удаляем имена каталогов }
    while Length(Result) > Len - 4 do
    begin
      { получаем первый разделитель каталога }
      P1 := Pos('\', Result);
      { а есть ли он }
      if P1 = 0 then Exit;
      { ищем второй }
      P2 := P1;
      for I := P1 + 1 to Length(Result) do
        if (P2 = P1) and (Result[I] = '\') then
        begin
          P2 := I;
          Break;
        end;
      { а есть ли он }
      if P2 = P1 then Exit;
      { удаляем каталог }
      Delete(Result, P1 + 1, P2 - P1);
    end;
    { вставляем разделитель }
    Insert('...\', Result, 4);
  end;
end;

function GetLongFileName(const ShortName: string): string;
var
  SearchHandle: THandle;
  FindData: TWin32FindData;
begin
  { значение по умолчанию }
  Result := ShortName;
  { ищем файл }
  SearchHandle := FindFirstFile(PChar(ShortName), FindData);
  { если он найден - берем его имя }
  if SearchHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := FindData.cFileName;
    if Result = '' then Result := FindData.cAlternateFileName;
  end;
  { закрываем описатель }
  Windows.FindClose(SearchHandle);
end;

function GetLongPathName(const ShortName: string): string;
var
  LastSlash: PChar;
  PathPtr: PChar;
  PathName: string;
  SearchHandle: THandle;
  FindData: TWin32FindData;
begin
  Result := '';
  PathPtr := PChar(ShortName);
  LastSlash := StrRScan(PathPtr, '\');
  { перебираем путь }
  while LastSlash <> nil do
  begin
    { получаем очередное имя }
    SearchHandle := FindFirstFile(PathPtr, FindData);
    try
      { если оно найдено - берем длинное его имя }
      if SearchHandle <> INVALID_HANDLE_VALUE then
      begin
        { получаем длинное имя }
        PathName := FindData.cFileName;
        if PathName = '' then PathName := FindData.cAlternateFileName;
        { добавляем его к результату }
        Result := '\' + PathName + Result;
      end
      else
        { путь не найден - остаток берем как есть и выход }
        Break;
    finally
      Windows.FindClose(SearchHandle);
    end;
    { ищем следующий разделитель пути }
    if LastSlash <> nil then
    begin
      LastSlash^ := Char(0);
      LastSlash := StrRScan(PathPtr, '\');
    end;
  end;
  { результат }
  Result := PathPtr + Result;
end;

function GetTemporaryFileName(const BaseFileName, Prefix: string): string;
var
  Dir: string;
  Buffer: array[0..MAX_PATH] of Char;
begin
  { выделяем каталог }
  Dir := ExtractFileDir(BaseFileName);
  { генерим имя стандартными средствами }
  if Windows.GetTempFileName(PChar(Dir), PChar(Prefix), 0, @Buffer) <> 0 then
  begin
    Result := Buffer;
    Exit;
  end;
  { генерим имя сами }
  repeat
    Result := Format('%s\%s%d.tmp', [Dir, Prefix, Random(MaxWord)]);
  until not FileExists(Result);
end;

function ExtractFileNameEx(const FileName: string; Extension: Boolean): string;
var
  I: Integer;
begin
  { получаем имя файла }
  Result := ExtractFileName(FileName);
  { удаляем расширение }
  if not Extension then
  begin
    I := Length(Result);
    while (I > 0) and not (Result[I] in ['.', '\', ':']) do Dec(I);
    if (I > 0) and (Result[I] = '.') then Result := Copy(Result, 1, I - 1);
  end;
end;

function CasePos(Substr: string; S: string; MatchCase: Boolean): Integer;
begin
  if not MatchCase then
  begin
    { все в верхний регистр }
    Substr := AnsiUpperCase(Substr);
    S := AnsiUpperCase(S);
  end;
  { ищем }
{$IFDEF VER90 }
  Result := Pos(Substr, S);
{$ELSE}
  Result := AnsiPos(Substr, S);
{$ENDIF}
end;

function ReplaceChar(const S: string; C1, C2: Char): string;
var
  I: Integer;
begin
  { устанавливаем результат в исходную строку }
  Result := S;
  { меняем символ }
  for I := 0 to Length(Result) do
    if Result[I] = C1 then Result[I] := C2;
end;

function ReplaceStr(const S: string; S1, S2: string): string;
var
  P: Integer;
begin
  Result := S;
  P := CasePos(S1, Result, False);
  if P <> 0 then
  begin
    Delete(Result, P, Length(S1));
    Insert(S2, Result, P);
  end;
end;

function RemoveChars(const S: string; C: array of Char): string;
var
  I, J, K, L, N: Integer;
begin
  { длина строки }
  L := Length(S);
  { устанавливаем длину результата в длину строки }
  SetString(Result, nil, L);
  N := 0;
  { перебираем символы строки }
  for I := 1 to L do
  begin
    { есть ли текущий символ среди удаляемых }
    K := 0;
    for J := Low(C) to High(C) do
      if S[I] = C[J] then
      begin
        Inc(K);
        Break;
      end;
    { нет - добавляем его в результат }
    if K = 0 then
    begin
      Inc(N);
      Result[N] := S[I];
    end;
  end;
  { устанавливаем реальную длину строки результата }
  SetLength(Result, N);
end;

function RemoveLineBreaks(const S: string): string;
var
  I, L, N: Integer;
begin
  { длина строки }
  L := Length(S);
  { устанавливаем длину результата в длину строки }
  SetString(Result, nil, L);
  N := 0;
  { перебираем символы строки }
  I := 1;
  while I <= L do
  begin
    Inc(N);
    { является ли текущий символ символом переноса строки }
    if S[I] in [#13, #10] then
    begin
      { да- меняем его на пробел }
      Result[N] := ' ';
      { следующие символы переноса игнорируем }
      while (I < L) and (S[I + 1] in [#13, #10]) do Inc(I);
    end
    else
      { нет - берем его }
      Result[N] := S[I];
    { следующий символ }
    Inc(I);
  end;
  { устанавливаем реальную длину строки результата }
  SetLength(Result, N);
end;

function RemoveDoubleSpace(const S: string): string;
var
  I, L, N: Integer;
begin
  { длина строки }
  L := Length(S);
  { устанавливаем длину результата в длину строки }
  SetString(Result, nil, L);
  N := 0;
  { перебираем символы строки }
  I := 1;
  while I <= L do
  begin
    Inc(N);
    { является ли текущий символ символом переноса строки }
    if S[I] = ' ' then
    begin
      { да- меняем его на пробел }
      Result[N] := ' ';
      { следующие символы переноса игнорируем }
      while (I < L) and (S[I + 1] = ' ') do Inc(I);
    end
    else
      { нет - берем его }
      Result[N] := S[I];
    { следующий символ }
    Inc(I);
  end;
  { устанавливаем реальную длину строки результата }
  SetLength(Result, N);
end;

function TrimCharLeft(const S: string; C: Char): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] = C) do Inc(I);
  Result := Copy(S, I, Maxint);
end;

function TrimCharRight(const S: string; C: Char): string;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] = C) do Dec(I);
  if I <> 0 then Result := Copy(S, 1, I) else Result := '';
end;

function InsertCharLeft(const S: string; C: Char; Len: Integer): string;
var
  L: Integer;
  A: string;
begin
  L := Length(S);
  { прверяем длину }
  if L >= Len then
  begin
    Result := S;
    Exit;
  end;
  { формируем добавок }
  SetString(A, nil, Len - L);
  FillChar(Pointer(A)^, Len - L, Byte(C));
  { результат }
  Result := A + S;
end;

function InsertCharRight(const S: string; C: Char; Len: Integer): string;
var
  L: Integer;
  A: string;
begin
  { получаем длину строки }
  L := Length(S);
  { проверяем длину }
  if L >= Len then
  begin
    Result := S;
    Exit;
  end;
  { формируем добавок }
  SetString(A, nil, Len - L);
  FillChar(Pointer(A)^, Len - L, Byte(C));
  { результат }
  Result := S + A;
end;

function TruncLeft(const S: string; MaxLen: Integer): string;
var
  L: Integer;
begin
  { получаем длину строки }
  L := Length(S);
  { если длина больше - отрезаем сколько нужно }
  if L > MaxLen then
  begin
    Result := Copy(S, MaxIntValue([1, L - MaxLen]), MaxLen);
    Exit;
  end;
  { возвращаем строку без изменения }
  Result := S;
end;

function TruncRight(const S: string; MaxLen: Integer): string;
var
  L: Integer;
begin
  { получаем длину строки }
  L := Length(S);
  { если длина больше - отрезаем сколько нужно }
  if L > MaxLen then
  begin
    Result := Copy(S, 1, MaxLen);
    Exit;
  end;
  { возвращаем строку без изменения }
  Result := S;
end;

function GetLineCount(const S: string): Integer;
var
  P: PChar;
begin
  Result := 0;
  { ищем перенос строки }
  P := Pointer(S);
  while P^ <> #0 do
  begin
    while not (P^ in [#0, #10, #13]) do Inc(P);
    { была строка }
    Inc(Result);
    { учитываем символы переноса }
    if P^ = #13 then Inc(P);
    if P^ = #10 then Inc(P);
  end;
end;

function ParamExists(const Param: string): Boolean;
var
  I, P: Integer;
  S: string;
begin
  { перебираем параметры командной строки }
  for I := 1 to ParamCount do
  begin
    { получаем параметр }
    S := ParamStr(I);
    { ищем в параметре искомый }
    P := CasePos(Param, S, False);
    if P = 1 then
    begin
      { параметр существует - выход }
      Result := True;
      Exit;
    end;
  end;
  { параметра нет }
  Result := False;
end;

function GetParamValue(const Param: string): string;
var
  I, P: Integer;
  S: string;
begin
  { перебираем параметры командной строки }
  for I := 1 to ParamCount do
  begin
    { получаем параметр }
    S := ParamStr(I);
    { ищем в параметре искомый }
    P := CasePos(Param, S, False);
    if P = 1 then
    begin
      { параметр существует - выход }
      Result := Copy(S, P + Length(Param), 255);
      Exit;
    end;
  end;
  { параметра нет }
  Result := '';
end;

function GetParamValueDef(const Param: string; const Default: string): string;
begin
  Result := GetParamValue(Param);
  if Length(Result) = 0 then Result := Default;
end;

type
  TRegistryEx = class(TRegistry);

procedure RegEraseKey(Root: HKEY; const Key: string);
begin
  RegEraseKeyEx(Root, Key, True);
end;

procedure RegEraseKeyEx(Root: HKEY; const Key: string; SubKeys: Boolean);
begin
  { удаляем подразделы }
  if SubKeys then RegEraseSubKeys(Root, Key);
  { удаляем сам раздел }
  with TRegistryEx.Create do
  try
    { открываем ключ реестра }
    RootKey := Root;
    { удаляем раздел }
    DeleteKey(PChar(Key));
  finally
    Free;
  end;
end;

procedure RegEraseSubKeys(Root: HKEY; const Key: string);
var
  Registry: TRegistryEx;

  procedure DoErase(const Key: string; SubIndex: Integer);
  var
    I: Integer;
    OldKey, NewKey: HKEY;
    Strings: TStringList;
  begin
    with Registry do
    begin
      { запоминаем текущий раздел }
      OldKey := CurrentKey;
      { открываем новый раздел }
      NewKey := GetKey(Key);
      if NewKey <> 0 then
      try
        { переходим на удаляемый раздел }
        SetCurrentKey(NewKey);
        { создаем список подразделов }
        Strings := TStringList.Create;
        try
          { считываем список подразделов }
          GetKeyNames(Strings);
          { удаляем подразделы }
          for I := Strings.Count - 1 downto 0 do
            DoErase(Strings[I], SubIndex + 1);
        finally
          Strings.Free;
        end;
      finally
        { возвращаем текущий раздел }
        SetCurrentKey(OldKey);
        { закрываем удаляемый раздел }
        RegCloseKey(NewKey);
      end;
      { удаляем сам раздел }
      if SubIndex > 1 then DeleteKey(PChar(Key));
    end;
  end;

begin
  { получаем доступ к реестру }
  Registry := TRegistryEx.Create;
  { удаляем }
  with Registry do
  try
    { открываем ключ реестра }
    RootKey := Root;
    { удаляем подразделы }
    DoErase(Key, 1);
  finally
    Registry.Free;
  end;
end;

procedure RegReadKey(Root: HKEY; const Key: string; Strings: TStrings);
var
  I: Integer;
  Names: TStringList;
  Info: TRegDataInfo;
  Value: string;
begin
  with TRegistryEx.Create do
  try
    { открываем ключ реестра }
    RootKey := Root;
    { открываем раздел }
    if OpenKey(Key, False) then
    begin
      Strings.Clear;
      { создаем буфер для имен }
      Names := TStringList.Create;
      try
        { считываем имена }
        GetValueNames(Names);
        { считываем значения }
        for I := 0 to Names.Count - 1 do
          { получаем тип значения }
          if GetDataInfo(Names[I], Info) then
          begin
            { получаем значение и формируем строку }
            case Info.RegData of
              rdString, rdExpandString:
                { строка }
                Value := ReadString(Names[I]);
              else
                { остальные типы не поддерживаются }
                Continue;
            end;
            { запоминаем значение }
            Strings.Add(Format('%s=%s', [Names[I], Value]));
          end;
      finally
        Names.Free;
      end;
    end;
  finally
    Free;
  end;
end;

procedure RegWriteKey(Root: HKEY; const Key: string; Strings: TStrings);
var
  I: Integer;
begin
  with TRegistryEx.Create do
  try
    { открываем ключ реестра }
    RootKey := Root;
    { открываем раздел }
    if OpenKey(Key, True) then
      { записываем значения }
      with Strings do
        { перебираем  }
        for I := 0 to Count - 1 do
          { записываем }
          WriteString(Names[I], Values[Names[I]]);
  finally
    Free;
  end;
end;

const
  RegSignature = 'REGEDIT4';

procedure RegImport(const FileName: string);
var
  RegFile: TextFile;
  Registry: TRegistryEx;
  Line: string;

  procedure DoImportValue;
  var
    P: Integer;
    Name, Value: string;
    StrValue: string;
  begin
    with Registry do
    try
      { разбираем значение }
      P := Pos('=', Line);
      if P <> 0 then
      begin
        { получаем имя ключа }
        Name := Copy(Line, 2, P - 3);
        { отсекаем имя }
        Line := Copy(Line, P + 1, Length(Line) - P);
        { если есть значение - разбираем его }
        if Length(Line) > 0 then
        begin
          { разбираем строковое значение }
          P := Pos('"', Line);
          if P = 1 then
          begin
            { получаем значение }
            Value := Copy(Line, P + 1, Length(Line) - P - 1);
            { подправляем строку }
            StrValue := StrToRegStr(Value);
            { записываем в реестр }
            WriteString(Name, StrValue);
          end;
          { разбираем значение DWORD }
          P := Pos('dword:', Line);
          if P = 1 then
          begin
          end;
          { разбираем значение HEX }
          P := Pos('hex:', Line);
          if P = 1 then
          begin
          end;
        end;
      end;
    except
      Exit;
    end;
  end;

  procedure DoImportKey;
  var
    P: Integer;
    Root: HKEY;
    Key: string;
  begin
    with Registry do
    try
      { разбираем раздел }
      P := Pos('[', Line);
      if P = 1 then
      begin
        { получаем имя корневого раздела }
        P := Pos('\', Line);
        if P <> 0 then
        begin
          { переводим строку в значение }
          Root := RegStrToRootKey(Copy(Line, 2, P - 2));
          { получаем имя раздела }
          Key := Copy(Line, P + 1, Length(Line) - P - 1);
          { открываем раздел в реестре }
          RootKey := Root;
          if OpenKey(Key, True) then
          try
            { разбираем значения секции }
            while not EOF(RegFile) do
            begin
              { считываем строку }
              Readln(RegFile, Line);
              { если это разделитель или новый раздел - выход }
              if (Length(Line) = 0) or (Line[1] = '[') then Exit;
              { разбираем строку }
              DoImportValue;
            end;
          finally
            CloseKey;
          end;
        end;
      end;
    except
      Exit;
    end;
  end;

begin
  { Открываем файл }
  AssignFile(RegFile, FileName);
  try
    { инициализируем чтение }
    Reset(RegFile);
    { пуст ли файл }
    if not EOF(RegFile) then
    begin
      { считываем метку }
      Readln(RegFile, Line);
      { проверяем метку }
      if CompareText(Line, RegSignature) = 0 then
      begin
        { получаем доступ к реестру }
        Registry := TRegistryEx.Create;
        try
          { разбираем строки }
          while not EOF(RegFile) do
          begin
            { считываем строку }
            Readln(RegFile, Line);
            { разбираем строку }
            DoImportKey;
          end;
        finally
          Registry.Free;
        end;
      end;
    end;
  finally
    CloseFile(RegFile);
  end;
end;

procedure RegExport(Root: HKEY; const Key: string; const FileName: string);
var
  RegFile: TextFile;
  Registry: TRegistryEx;

  procedure DoSave(const Key, Path: string);
  var
    I: Integer;
    OldKey, NewKey: HKEY;
    Strings: TStringList;
    Line: string;
    Info: TRegDataInfo;
    StrValue: string;
  begin
    with Registry do
    begin
      { запоминаем текущий раздел }
      OldKey := CurrentKey;
      { открываем новый раздел }
      NewKey := GetKey(Key);
      if NewKey <> 0 then
      try
        { переходим на удаляемый раздел }
        SetCurrentKey(NewKey);
        { строка - разделитель }
        Writeln(RegFile);
        { формируем название раздела }
        Line := Format('[%s\%s]', [Path, Key]);
        { записываем название раздела }
        Writeln(RegFile, Line);
        { создаем список значений }
        Strings := TStringList.Create;
        try
          { получаем все значения }
          GetValueNames(strings);
          { записываем значения }
          for I := 0 to Strings.Count - 1 do
            { получаем тип значения }
            if GetDataInfo(Strings[I], Info) then
            begin
              { получаем значение и формируем строку }
              case Info.RegData of
                rdString, rdExpandString:
                  { строка }
                  begin
                    { считываем значение }
                    StrValue := ReadString(Strings[I]);
                    { подправляем строку }
                    StrValue := RegStrToStr(StrValue);
                    { формируем строку }
                    Line := Format('"%s"="%s"', [Strings[I], StrValue]);
                  end;
                rdInteger:
                  { DWORD }
                  begin
                  end;
                rdBinary:
                  { HEX }
                  begin
                  end;
                else
                  { остальные типы не поддерживаются }
                  Continue;
              end;
              { записываем значение }
              Writeln(RegFile, Line);
            end;
        finally
          Strings.Free;
        end;
        { создаем список подразделов }
        Strings := TStringList.Create;
        try
          { считываем подразелы }
          GetKeyNames(Strings);
          { записываем подразделы }
          for I := 0 to Strings.Count - 1 do
            DoSave(Strings[I], Format('%s\%s', [Path, Key]));
        finally
          Strings.Free;
        end;
      finally
        { возвращаем текущий раздел }
        SetCurrentKey(OldKey);
        { закрываем удаляемый раздел }
        RegCloseKey(NewKey);
      end;
    end;
  end;

begin
  { Открываем файл }
  AssignFile(RegFile, FileName);
  try
    { инициализируем запись }
    Rewrite(RegFile);
    { записываем метку файла }
    Writeln(RegFile, RegSignature);
    { получаем доступ к реестру }
    Registry := TRegistryEx.Create;
    { сохраняем }
    with Registry do
    try
      { открываем ключ реестра }
      RootKey := Root;
      { сохраняем раздел }
      DoSave(Key, RegRootKeyToStr(Root));
    finally
      Free;
    end;
  finally
    CloseFile(RegFile);
  end;
end;

function StrToRegStr(const Value: string): string;
var
  I: Integer;
begin
  { результат }
  Result := Value;
  { меняем "\\" на "\" }
  I := Length(Result) - 1;
  while I > 0 do
  begin
    { вставляем второй "\" }
    if (Result[I] = '\') and (Result[I + 1] = '\') then Delete(Result, I, 1);
    { следуюший символ }
    Dec(I);
  end;
end;

function RegStrToStr(const Value: string): string;
var
  I: Integer;
begin
  { результат }
  Result := Value;
  { меняем "\" на "\\" }
  I := Length(Result);
  while I > 0 do
  begin
    { вставляем второй "\" }
    if Result[I] = '\' then Insert('\', Result, I + 1);
    { следуюший символ }
    Dec(I);
  end;
end;

type
  TRootEntry = record
    Value: HKEY;
    Name: string;
  end;

const
  RootList: array[0..6] of TRootEntry = (
    (Value: HKEY_CLASSES_ROOT; Name: 'HKEY_CLASSES_ROOT'),
    (Value: HKEY_CURRENT_USER; Name: 'HKEY_CURRENT_USER'),
    (Value: HKEY_LOCAL_MACHINE; Name: 'HKEY_LOCAL_MACHINE'),
    (Value: HKEY_USERS; Name: 'HKEY_USERS'),
    (Value: HKEY_PERFORMANCE_DATA; Name: 'HKEY_PERFORMANCE_DATA'),
    (Value: HKEY_CURRENT_CONFIG; Name: 'HKEY_CURRENT_CONFIG'),
    (Value: HKEY_DYN_DATA; Name: 'HKEY_DYN_DATA'));

function RegRootKeyToStr(Root: HKEY): string;
var
  I: Integer;
begin
  for I := Low(RootList) to High(RootList) do
    if RootList[I].Value = Root then
    begin
      Result := RootList[I].Name;
      Exit;
    end;
  Result := IntToStr(Root);
end;

function RegStrToRootKey(const S: string): HKEY;
var
  I: Integer;
begin
  for I := Low(RootList) to High(RootList) do
    if CompareText(RootList[I].Name, S) = 0 then
    begin
      Result := RootList[I].Value;
      Exit;
    end;
  Result := StrToInt(S);
end;

function RegStrToRootKeyDef(const S: string; Default: HKEY): HKEY;
begin
  try
    Result := RegStrToRootKey(S);
  except
    Result := Default;
  end;
end;

function StrToTimeDef(const S: string; Default: TDateTime): TDateTime;
begin
  try
    Result := StrToTime(S);
  except
    Result := Default;
  end;
end;

function StrToDateDef(const S: string; Default: TDateTime): TDateTime;
begin
  try
    Result := StrToDate(S);
  except
    Result := Default;
  end;
end;

function TimeToLongStr(Time: TDateTime): string;
begin
  Result := FormatDateTime('hh:mm:ss', Time);
end;

function DateToLongStr(Date: TDateTime): string;
const
  MonthNames: array[1..12] of string = (
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря');
var
  I: Integer;
  M: array[1..12] of string;
begin
  { подменяем длинные имена месяцев на имена со склонением }
  for I := 1 to 12 do M[I] := LongMonthNames[I];
  try
    { устанавливаем свои (со склонением) }
    for I := 1 to 12 do LongMonthNames[I] := MonthNames[I];
    { результат }
    Result := FormatDateTime(LongDateFormat, Date);
  finally
    for I := 1 to 12 do LongMonthNames[I] := M[I];
  end;
end;

function DateTimeToLongStr(DateTime: TDateTime): string;
begin
  Result := DateToLongStr(DateTime) + ' ' + TimeToLongStr(DateTime);
end;

function TimeToShortStr(Time: TDateTime): string;
begin
  Result := FormatDateTime('hh:mm', Time);
end;

function DateToShortStr(Date: TDateTime): string;
begin
  Result := FormatDateTime('dd.mm.yyyy', Date);
end;

function MSecToStr(Time: Longint): string;
var
  Sec, Min, Hour: Integer;
begin
  { получаем количество часов, минут и секунд }
  Hour := Time div 3600000;
  Min := (Time - Hour * 3600000) div 60000;
  Sec := (Time - Hour * 3600000 - Min * 60000) div 1000;
  { формируем результат }
  if Sec > 0 then
    Result := IntToStr(Sec) + 'сек.'
  else
    Result := '';
  if Min > 0 then
    if Length(Result) > 0 then
      Result := IntToStr(Min) + 'мин. ' + Result
    else
      Result := IntToStr(Min) + 'мин.';
  if Hour > 0 then
    if Length(Result) > 0 then
      Result := IntToStr(Hour) + 'ч. ' + Result
    else
      Result := IntToStr(Hour) + 'ч.';
end;

function MSecToStrFmt(Time: Longint; const Format: string): string;
var
  MSec, Sec, Min, Hour: Integer;
begin
  { получаем количество часов, минут и секунд }
  Hour := Time div 3600000;
  Min := (Time - Hour * 3600000) div 60000;
  Sec := (Time - (Hour * 3600000 + Min * 60000)) div 1000;
  MSec := Time - (Hour * 3600000 + Min * 60000 + Sec * 1000);
  { получаем время }
  Result := FormatDateTime(Format, EncodeTime(Hour, Min, Sec, MSec));
end;

var
  FPosCount: Integer = 0;

function GetDefFormPos: TPoint;
var
  X, Y, C: Integer;
begin
  { получаем размеры рамки окна }
  X := GetSystemMetrics(SM_CXFRAME);
  Y := GetSystemMetrics(SM_CYFRAME);
  C := GetSystemMetrics(SM_CYCAPTION);
  { формируем результат }
  Result.X := (X + C) * FPosCount;
  Result.Y := (Y + C) * FPosCount;
  { увеличиваем счетчик положений }
  Inc(FPosCount);
  { проверяем его (допустимо 6 положений) }
  if FPosCount > 5 then FPosCount := 0;
end;

function GetDefFormBounds(Width, Height: Integer): TRect;
var
  P: TPoint;
begin
  { получаем положение окна по умолчанию }
  P := GetDefFormPos;
  { результат }
  Result := Bounds(P.X, P.Y, Width, Height);
end;

procedure SetTopMostWindow(Wnd: HWND; TopMost, Activate: Boolean);
const
  Flags: array[Boolean] of Integer = (
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE,
    SWP_NOMOVE or SWP_NOSIZE);
begin
  if TopMost then
    SetWindowPos(Wnd, HWND_TOPMOST, 0, 0, 0, 0, Flags[Activate])
  else
    SetWindowPos(Wnd, HWND_NOTOPMOST, 0, 0, 0, 0, Flags[Activate]);
end;

function AppMessageBox(const Text, Caption: string; Flags: Longint): Integer;
var
  AppVisible: Boolean;
begin
  with Application do
  begin
    { проверяем, видно ли окно приложения }
    AppVisible := IsWindowVisible(Handle);
    { если приложение не видно - показываем его }
    if not AppVisible then ShowWindow(Handle, SW_SHOW);
    { показываем диалог }
    Result := MessageBox(PChar(Text), PChar(Caption), Flags);
    { если приложение было погашено - гасим его снова }
    if not AppVisible then ShowWindow(Handle, SW_HIDE);
  end;
end;

procedure AppDelay(TimeOut: DWORD);
begin
  AppDelayEx(TimeOut, False, True, nil);
end;

function KeyboardProc(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; far; stdcall;
begin
  Result := 1;
end;

function MouseProc(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; far; stdcall;
begin
  Result := 1;
end;

procedure AppDelayEx(TimeOut: DWORD; AppTerminate, AppMessages: Boolean; DelayProc: TDelayProc);
var
  K, M: HHOOK;
  T: DWORD;
  C: Boolean;
begin
  { разрешается ли обработка сообщений }
  if AppMessages then
  begin
    { перехватываем сообщения клавиатуры и мышки }
    K := SetWindowsHookEx(WH_KEYBOARD, @KeyboardProc, 0, GetCurrentThreadID);
    M := SetWindowsHookEx(WH_MOUSE, @MouseProc, 0, GetCurrentThreadID);
  end
  else
  begin
    K := 0;
    M := 0;
  end;
  { задержка }
  try
    C := False;
    { получаем текущее время }
    T := GetTickCount;
    { цикл задержки }
    while True  do
    begin
      { проверяем время }
      if Abs(GetTickCount - T) > TimeOut then Break;
      { проверяем, а не завершается ли приложение }
      if AppTerminate then if Application.Terminated then Break;
      { отработываем сообщения }
      if AppMessages then Application.ProcessMessages;
      { процедура обратной связи }
      if Assigned(DelayProc) then
      begin
        DelayProc(C);
        if C then Break;
      end;
      { отдаем время другим процессам }
      Sleep(5);
    end;
    { обрабатываем поступившие сообщения }
    if not AppMessages then
    begin
      Application.ProcessMessages;
      Application.HideHint;
    end;
  finally
    if K <> 0 then UnhookWindowsHookEx(K);
    if M <> 0 then UnhookWindowsHookEx(M);
  end;
end;

function GetVersionStr(const FileName, Key, Default: string): string;
const
  SLang = '\\VarFileInfo\\Translation';
  SBlock = '\\StringFileInfo\\%.4x%.4x\\%s';
type
  PLangList = ^TLangList;
  TLangList = array[0..MAXINT div SizeOf(LongRec) - 1] of LongRec;
var
  Handle: DWORD;
  Size: DWORD;
  Data: Pointer;
  Buffer: Pointer;
  Len: UINT;
  LangCount, I: Integer;
  Lang, CharSet: Word;
  Block: string;
begin
  Result := Default;
  Size := GetFileVersionInfoSize(PChar(FileName), Handle);
  if Size > 0 then
  begin
    GetMem(Data, Size);
    if Data <> nil then
    try
      if not GetFileVersionInfo(PChar(FileName), Handle, Size, Data) then Exit;
      if not VerQueryValue(Data, '\\', Buffer, Len) then Exit;
      if not VerQueryValue(Data, SLang, Buffer, Len) then Exit;
      LangCount := Len div SizeOf(LongRec);
      for I := 0 to LangCount - 1 do
      begin
        Lang := LongRec(PLangList(Buffer)^[I]).Lo;
        CharSet := LongRec(PLangList(Buffer)^[I]).Hi;
        Block := Format(SBlock, [Lang, CharSet, Key]);
        if VerQueryValue(Data, PChar(Block), Buffer, Len) then
        begin
          Len := StrLen(PChar(Buffer));
          if Len > 0 then
          begin
            SetString(Result, PChar(Buffer), Len);
            Exit;
          end;
        end;
      end;
    finally
      FreeMem(Data, Size);
    end;
  end;
end;

{$IFDEF VER90 }

function MinIntValue(const Data: array of Integer): Integer;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result > Data[I] then Result := Data[I];
end;

function MaxIntValue(const Data: array of Integer): Integer;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result < Data[I] then Result := Data[I];
end;

{$ENDIF}

end.
