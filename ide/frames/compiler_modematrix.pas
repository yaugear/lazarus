{
 ***************************************************************************
 *                                                                         *
 *   This source is free software; you can redistribute it and/or modify   *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This code is distributed in the hope that it will be useful, but      *
 *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *
 *   General Public License for more details.                              *
 *                                                                         *
 *   A copy of the GNU General Public License is available on the World    *
 *   Wide Web at <http://www.gnu.org/copyleft/gpl.html>. You can also      *
 *   obtain it by writing to the Free Software Foundation,                 *
 *   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.        *
 *                                                                         *
 ***************************************************************************

}
unit Compiler_ModeMatrix;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazFileUtils, LResources, Forms, Controls, Graphics,
  ComCtrls, ModeMatrixCtrl;

type

  { TFrame1 }

  TFrame1 = class(TFrame)
    BMMatrixToolBar: TToolBar;
    BMMMoveUpToolButton: TToolButton;
    BMMMoveDownToolButton: TToolButton;
    BMMUndoToolButton: TToolButton;
    BMMRedoToolButton: TToolButton;
    BMMNewTargetToolButton: TToolButton;
    BMMNewOptionToolButton: TToolButton;
    BMMDeleteToolButton: TToolButton;
    procedure GridSelection(Sender: TObject; {%H-}aCol, {%H-}aRow: Integer);
  private
    FGrid: TGroupedMatrixControl;
    procedure UpdateButtons;
  public
    constructor Create(TheOwner: TComponent); override;
    property Grid: TGroupedMatrixControl read FGrid;
  end;

implementation

{$R *.lfm}

{ TFrame1 }

procedure TFrame1.GridSelection(Sender: TObject; aCol, aRow: Integer);
begin
  UpdateButtons;
end;

procedure TFrame1.UpdateButtons;
var
  aRow: Integer;
  MatRow: TGroupedMatrixRow;
begin
  aRow:=Grid.Row;
  if (aRow>0) and (aRow<=Grid.Matrix.RowCount) then begin
    MatRow:=Grid.Matrix[aRow-1];
  end else
    MatRow:=nil;

  // allow to delete targets and value rows
  BMMDeleteToolButton.Enabled:=(MatRow<>nil) and (MatRow.Group<>nil);
  //
  BMMUndoToolButton.Enabled:=false;
  BMMRedoToolButton.Enabled:=false;
  // move up/down
  BMMMoveUpToolButton.Enabled:=(MatRow<>nil) and (MatRow.Group<>nil)
                        and ((MatRow.GetPreviousSibling<>nil)
                           or (MatRow.GetTopLvlItem.GetPreviousSibling<>nil));
  BMMMoveDownToolButton.Enabled:=(MatRow<>nil) and (MatRow.Group<>nil)
                        and  (MatRow.GetNextSkipChildren<>nil);
end;

constructor TFrame1.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);

  FGrid:=TGroupedMatrixControl.Create(Self);
  with Grid do begin
    Name:='TModeMatrixControl';
    Align:=alClient;
    Parent:=Self;
    OnSelection:=@GridSelection;
  end;

  UpdateButtons;
end;

end.
