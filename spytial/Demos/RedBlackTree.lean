import CLRSSpytial

/-! Inspect an original CLRS red-black tree using its registered default layout. -/

open SpytialLean CLRS.Chapter13

namespace CLRS.SpytialExamples

/-- A balanced seven-node tree with red children and black leaves. -/
def sample : RBTree :=
  .node .black
    (.node .red (.node .black .empty 2 .empty) 4 (.node .black .empty 6 .empty))
    8
    (.node .red (.node .black .empty 10 .empty) 12 (.node .black .empty 14 .empty))

#spytial sample

-- Inspection also works inside a proof without changing the proof obligations.
set_option linter.unusedTactic false in
example (a b c : RBTree) (x y : Nat)
    (ha : RBTree.RedBlackShape a) (hb : RBTree.RedBlackShape b)
    (hc : RBTree.RedBlackShape c)
    (hab : RBTree.blackHeight a = RBTree.blackHeight b)
    (hbc : RBTree.blackHeight b = RBTree.blackHeight c) :
    RBTree.RedBlackShape
      (RBTree.repaintRoot .black (RBTree.rotateLeft (.node .red a x (.node .red b y c)))) := by
  spytial (RBTree.node .red a x (.node .red b y c)) observing [RBTree.blackHeight]
  exact RBTree.redBlackShape_repaint_rotateLeft_red_red ha hb hc hab hbc

end CLRS.SpytialExamples
