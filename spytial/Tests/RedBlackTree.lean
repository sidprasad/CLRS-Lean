import Demos.RedBlackTree

/-! Export a rendered regression case and check the imported theorem's trust boundary. -/

open SpytialLean CLRS.Chapter13 CLRS.SpytialExamples

-- Importing the annotation module must register the layout in a downstream module.
#spytial_snapshot "annotated-red-black-tree" sample

-- Opaque subtrees have no visible constructor fields, but must not be hidden as empty.
-- Use the same context-inspection entry point as the `spytial` proof tactic.
run_elab
  Lean.Meta.withLocalDeclD `a (Lean.mkConst ``RBTree) fun a =>
  Lean.Meta.withLocalDeclD `b (Lean.mkConst ``RBTree) fun b =>
  Lean.Meta.withLocalDeclD `c (Lean.mkConst ``RBTree) fun c =>
  Lean.Meta.withLocalDeclD `x (Lean.mkConst ``Nat) fun x =>
  Lean.Meta.withLocalDeclD `y (Lean.mkConst ``Nat) fun y => do
    let red := Lean.mkConst ``Color.red
    let right ← Lean.Meta.mkAppM ``RBTree.node #[red, b, y, c]
    let root ← Lean.Meta.mkAppM ``RBTree.node #[red, a, x, right]
    let (props, status) ← spytialInContextProps root
    if status.inconsistent || status.truncated then
      throwError "expected a complete symbolic tree snapshot"
    let source := System.FilePath.mk (← Lean.getFileName)
    let dir := source.parent.getD "." / "cases" / "symbolic-red-black-tree"
    IO.FS.createDirAll dir
    IO.FS.writeFile (dir / "props.json") (props.pretty ++ "\n")

/--
info: 'CLRS.Chapter13.RBTree.redBlackShape_repaint_rotateLeft_red_red'
depends on axioms: [propext]
-/
#guard_msgs in
#print axioms RBTree.redBlackShape_repaint_rotateLeft_red_red
