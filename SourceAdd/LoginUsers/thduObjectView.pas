{
 * The contents of this file are subject to the InterBase Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License.
 * 
 * You may obtain a copy of the License at http://www.Inprise.com/IPL.html.
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
 * the License for the specific language governing rights and limitations
 * under the License.  The Original Code was created by Inprise
 * Corporation and its predecessors.
 * 
 * Portions created by Inprise Corporation are Copyright (C) Inprise
 * Corporation. All Rights Reserved.
 * 
 * Contributor(s): ______________________________________.
}

unit thduObjectView;

interface

uses
  Classes, frmuObjectWindow;

type
  TObjectViewThread = class(TThread)
  private
    { Private declarations }
    FObjType: integer;
    FObjList,
    FObjName: String;
    FOwner: TComponent;

    procedure ShowObjectList;
  protected

    procedure Execute; override;
  public
    constructor Create (Owner: TComponent; const ObjType: Integer;
                        const ObjList, ObjName: String);
    destructor Destroy; override;
  end;

implementation

{ TThdObjectView }

constructor TObjectViewThread.Create(Owner: TComponent; const ObjType: Integer;
  const ObjList, ObjName: String);
var
  i: integer;

begin
  FObjType := ObjType;
  FObjList := ObjList;
  FobjName := ObjName;
  FOwner := Owner;

  inherited Create(False);
  FreeOnTerminate := true;
end;

destructor TObjectViewThread.Destroy;
begin
  inherited;
end;

procedure TObjectViewThread.Execute;
begin
  Synchronize (ShowObjectList);
end;

procedure TObjectViewThread.ShowObjectList;
var
  ObjectList: TStringList;
  s: String;
  ObjView: TFrmObjectView;
begin

  ObjView := TFrmObjectView.Create(FOwner);
  ObjectList := TStringList.Create;
  with ObjView do
  begin
    ObjectList.Text := FObjList;
    InitDlg (FObjType, ObjectList, FObjName);
    ObjectList.Free;
    Show;
    Free;
  end;
end;

end.
