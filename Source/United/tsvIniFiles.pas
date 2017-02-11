unit tsvIniFiles;

interface

uses Windows, Classes, inifiles;

type
   TTSVIniFile=class(TIniFile)
   public
    function ReadString(const Section, Ident, Default: string): string; override;
   end;


implementation


{ TTSVIniFile }

function TTSVIniFile.ReadString(const Section, Ident, Default: string): string;
var
  Buffer: array[0..65535] of Char;
begin
  SetString(Result, Buffer, GetPrivateProfileString(PChar(Section),
    PChar(Ident), PChar(Default), Buffer, SizeOf(Buffer), PChar(FileName)));
end;



end.
