unit StbasisUdfData;

interface

uses SysUtils;

type
  PIBDateTime = ^TIBDateTime;
  TIBDateTime = record
    Days,                           // Date: Days since 17 November 1858
    MSec10 : Integer;               // Time: Millisecond * 10 since midnigth
  end;

const                               // Date translation constants
  MSecsPerDay10 = MSecsPerDay * 10; // Milliseconds per day * 10
  IBDateDelta = 15018;              // Days between Delphi and InterBase dates

var
  RetServerDate: TIBDateTime;
  

implementation

end.
