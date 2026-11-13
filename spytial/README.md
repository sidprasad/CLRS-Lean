# Spytial annotations for CLRS-Lean

These modules belong to the **main CLRS-Lean Lake project**. Run all commands
below from the repository root. The project uses Lean and Mathlib 4.33.1,
Verso 4.33.0, and a pinned
[Spytial-Lean revision](https://github.com/sidprasad/spytial-lean/commit/fc1e90ef8a96cf20e5059f9d1851a57a8776817e).
The Lake manifest locks the transitive dependencies.

## Build and open the demo

Install [elan](https://github.com/leanprover/elan), Node.js 24, and pnpm 11.
The Lean editor extension is needed to display the interactive widget.

```sh
lake exe cache get
lake build
lake env lean spytial/Tests/RedBlackTree.lean
```

For a focused build of the annotation library and demo:

```sh
lake build CLRSSpytial SpytialDemos
```

Open `spytial/Demos/RedBlackTree.lean` in the Lean editor and place the cursor
on `#spytial sample`. The file also demonstrates inspection inside a proof of
the existing rotation/repainting theorem.

## Reuse the annotations

```lean
import CLRSSpytial

open CLRS.Chapter13

#spytial (RBTree.node .black (.node .red .empty 2 .empty) 4 .empty)
```

`CLRSSpytial/RedBlackTree.lean` registers a `spytial_spec` on the original
`CLRS.Chapter13.RBTree`; it does not introduce a replacement datatype or change
its proofs. Importing `CLRSSpytial` activates the default layout downstream.

The layout follows the red-black tree example in
[spytial-clrs](https://github.com/sidprasad/spytial-clrs):

- Keys label the nodes; color and natural-number atoms are hidden.
- All left descendants sit left and below their ancestors; right descendants
  sit right and below. Siblings share a horizontal level.
- Empty leaves are hidden and excluded from layout constraints. All empty
  leaves share one Lean value, so constraining that value as a visible child
  would produce contradictory positions.
- Red nodes have red borders and fill. Black nodes use dark borders and a pale
  fill to keep key labels readable.

The constructor has positional fields: `node_0` is color, `node_1` the left
subtree, `node_2` the key, and `node_3` the right subtree. These names are
Spytial's field selectors for the existing constructor.

## Snapshot check

`spytial/Tests/RedBlackTree.lean` imports the compiled annotation module,
exports `spytial/Tests/cases/annotated-red-black-tree/props.json`, and checks
that the existing rotation theorem uses only the standard Lean axioms.
Generated cases are ignored by Git. The seven-node sample should render with
six edges, two red nodes, five black nodes, and no layout error.

The dependency's [rendering instructions](https://github.com/sidprasad/spytial-lean/blob/fc1e90ef8a96cf20e5059f9d1851a57a8776817e/render/README.md)
describe how to render these snapshots with its browser harness.
