# Red-black tree visualization

The Spytial annotations live directly beside the datatype in the
[original Section 13.1 source](../src/CLRSLean/FourthEdition/Chapter_13/Section_13_1_Red_Black_Trees.lean).
Importing that module activates the layout:

```lean
import CLRSLean.FourthEdition.Chapter_13.Section_13_1_Red_Black_Trees

open CLRS.Chapter13

#spytial (RBTree.node .black (.node .red .empty 2 .empty) 4 .empty)
```

The annotations label keys, order left/right subtrees, style node colors,
and hide empty leaves while retaining unknown subtrees in proofs.
The existing datatype, operations, and theorem statements are unchanged.

From the repository root, with elan, Node.js 24, and pnpm 11 installed:

```sh
lake exe cache get
lake build SpytialDemos
lake env lean spytial/Tests/RedBlackTree.lean
```

Open `spytial/Demos/RedBlackTree.lean` in the Lean editor and place the cursor
on `#spytial sample`. The example also inspects the tree inside a rotation proof.
The test exports concrete and symbolic snapshots and checks the existing
rotation theorem's axioms.

The pinned Spytial dependency uses Lean 4.33.1. The tree integration is
verified on that version; the [full book build](https://github.com/sidprasad/CLRS-Lean/actions/runs/43472492045)
currently fails in other chapters, so use the focused build above.
