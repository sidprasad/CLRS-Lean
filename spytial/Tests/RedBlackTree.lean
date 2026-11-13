import Demos.RedBlackTree

/-! Export a rendered regression case and check the imported theorem's trust boundary. -/

open SpytialLean CLRS.Chapter13 CLRS.SpytialExamples

-- Importing the annotation module must register the layout in a downstream module.
#spytial_snapshot "annotated-red-black-tree" sample

/-- info: 'CLRS.Chapter13.RBTree.redBlackShape_repaint_rotateLeft_red_red' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RBTree.redBlackShape_repaint_rotateLeft_red_red
