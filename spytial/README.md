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

For the theorem inspection explorer, open
`src/CLRSLean/FourthEdition/Chapter_13/Section_13_1_Red_Black_Trees.lean`
and place the cursor on `redBlackShape_repaint_rotateLeft_red_red`.
The infoview initially shows a collapsed **Spytial inspections (3)** summary.
Expand it to compare `input` with `repaired` by default, choose another pair,
step through one point, or show all three. The middle and last inspections
have authored captions, "After rotation" and "After repaint"; each `spytial`
line also keeps its own widget.

The three terms are actual proof-local bindings:

```lean
let input := node .red a x (node .red b y c)
let rotated := rotateLeft input
let repaired := repaintRoot .black rotated
spytial input observing [blackHeight]
spytial rotated observing [blackHeight] titled "After rotation"
spytial repaired observing [blackHeight] titled "After repaint"
```

The proof retains its tree layout, black-height observations, context and
invariant facts. Proof facts appear in the inspector's context-facts panel;
there are no hand-authored checkmark badges on selected children. Spytial
follows shared Lean identities such as the subtree `b` when they are available
in the same goal; separate proof branches use independent layouts.

The pinned Spytial-Lean v0.2.1 dependency uses Lean 4.33.1. The tree integration is
verified on that version; the [full book build](https://github.com/sidprasad/CLRS-Lean/actions/runs/43472492045)
currently fails in other chapters, so use the focused build above.

## Infoview regression check

After the focused Lean build, prepare the browser harness and check the actual
rotation proof with the installed dependency:

```sh
pnpm -C .lake/packages/spytialLean install --frozen-lockfile
pnpm -C .lake/packages/spytialLean/widget run build
lake build spytialLean/renderHarnessJs
pnpm -C .lake/packages/spytialLean/render exec playwright install chromium
node spytial/Tests/inspection-explorer.mjs
```

The check verifies the collapsed default, theorem and line entry points,
captions, comparison controls, shared-subtree identities, tree constraints,
and the retained proof facts without hand-authored checkmarks. It saves a
preview under `.lake/rotation-explorer.png`.

The manual **Lean Action CI** workflow has a `spytial` scope for these focused
checks. Its default `full` scope retains the existing whole-book checks.
