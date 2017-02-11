unit UTreeHeading;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees, VirtualDBTree, Db, DBClient, StdCtrls, Buttons, ExtCtrls,
  ImgList;

type
  TfmTreeHeading = class(TForm)
    cdsTree: TClientDataSet;
    pnBottom: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    pnTree: TPanel;
    IL: TImageList;
    ds: TDataSource;
    procedure bibOkClick(Sender: TObject);
    procedure bibCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure TreeViewOnDblClick(Sender: TObject);
    procedure TreeViewOnGetImageIndex(Sender: TBaseVirtualTree;  Node: PVirtualNode; Kind: TVTImageKind; Column: Integer;
                                      var Ghosted: Boolean; var ImageIndex: Integer);
    Function FindNode(Start: PVirtualNode; ID: Integer): PVirtualNode;                                  
  public
    TreeView: TVirtualDBTree;
    function GetTreeViewPath(treeheading_id: Integer; b,a,d: string): string;
  end;

var
  fmTreeHeading: TfmTreeHeading;

implementation

uses UMain;

{$R *.DFM}

procedure TfmTreeHeading.bibOkClick(Sender: TObject);
begin
  if TreeView.SelectedCount=0 then begin
    ShowErrorEx('Выберите рубрику');
    exit;
  end;
  ModalResult:=mrOk;
end;

procedure TfmTreeHeading.bibCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfmTreeHeading.FormCreate(Sender: TObject);
begin
  TreeView:=TVirtualDBTree.Create(Self);
  TreeView.Parent:=pnTree;
  TreeView.Align:=alClient;
  TreeView.Images:=IL;
  TreeView.DataSource:=ds;
  TreeView.Margin:=2;
  TreeView.DefaultNodeHeight:=16;
  TreeView.OnGetImageIndex:=TreeViewOnGetImageIndex;
  TreeView.OnDblClick:=TreeViewOnDblClick;

  TreeView.KeyFieldName:='treeheading_id';
  TreeView.ParentFieldName:='parent_id';
  TreeView.ViewFieldName:='nameheading';

  ActiveControl:=TreeView;
end;

procedure TfmTreeHeading.TreeViewOnGetImageIndex(Sender: TBaseVirtualTree;
    Node: PVirtualNode; Kind: TVTImageKind; Column: Integer;  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  case Kind of
    ikNormal,ikSelected: begin
       if Node.ChildCount=0 then begin
         ImageIndex:=2;
       end else begin
         if Kind=ikNormal then
          ImageIndex:=0
         else ImageIndex:=1;
       end;
    end;
  end;
end;

procedure TfmTreeHeading.FormDestroy(Sender: TObject);
begin
  TreeView.Parent:=nil;
  TreeView.Free;
end;

procedure TfmTreeHeading.TreeViewOnDblClick(Sender: TObject);
begin
  bibOk.Click;
end;

Function TfmTreeHeading.FindNode(Start: PVirtualNode; ID: Integer): PVirtualNode;
Var
  Data: PDBVTData;
Begin
  If Assigned(Start) Then Result := Start
  Else Result := TreeView.GetFirst;
  While Assigned(Result) Do Begin
    Data := TreeView.GetNodeData(Result);
    If Data.ID = ID Then break;
    Result := TreeView.GetNext(Result);
  End;
End;

function TfmTreeHeading.GetTreeViewPath(treeheading_id: Integer; b,a,d: string): string;
var
  Node: PVirtualNode;
  isFirst: Boolean;
begin
  Result:='';
  Node:=FindNode(nil,treeheading_id);
  if Assigned(Node) then begin
    isFirst:=true;
    while Node<>TreeView.RootNode do begin
      if isFirst then begin
        Result:=TreeView.NodeText[Node];
        isFirst:=false;
      end else begin
        Result:=TreeView.NodeText[Node]+d+Result;
      end;
      Node:=Node.Parent;
    end;
    Result:=b+Result+a;
  end;

end;

end.
