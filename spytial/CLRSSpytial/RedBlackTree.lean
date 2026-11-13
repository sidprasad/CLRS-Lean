import SpytialLean
import CLRSLean.FourthEdition.Chapter_13.Section_13_1_Red_Black_Trees

/-!
Type-attached annotations for CLRS-Lean's original red-black tree, following
the key labels, subtree ordering, and red/black styling in spytial-clrs/trees.ipynb.
Importing this module registers the default layout; the upstream datatype is unchanged.
-/

open SpytialLean CLRS.Chapter13

-- The upstream constructor has positional arguments: color, left, key, right.
-- Spytial exposes them as node_0, node_1, node_2, and node_3 respectively.
-- Only nonempty nodes have a color field, so node_0.Color excludes empty leaves.
spytial_spec RBTree [
  orientation node_1.*(node_1 + node_3) &
    (node_0.Color -> node_0.Color) left below,
  orientation node_3.*(node_1 + node_3) &
    (node_0.Color -> node_0.Color) right below,
  align (~(node_1 + node_3).(node_1 + node_3) - iden) &
    (node_0.Color -> node_0.Color) horizontal,
  attribute node_2,
  hideField node_0,
  hideAtom Color + Nat + (RBTree - node_0.Color),
  edgeStyle node_1 noLabels,
  edgeStyle node_3 noLabels,
  size RBTree 56 42,
  atomStyle node_0.lean (fun c : Color => c = .red)
    (borderStyle "#b91c1c" 2) (fillStyle "#fee2e2") (textStyle "#7f1d1d"),
  atomStyle node_0.lean (fun c : Color => c = .black)
    (borderStyle "#111827" 3) (fillStyle "#f3f4f6") (textStyle "#111827")
]
