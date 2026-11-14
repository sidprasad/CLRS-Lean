import Lake
open Lake DSL

package «clrs-lean» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`doc.verso, true⟩,
    -- Keep the existing proof automation matching behavior on Lean 4.33.
    -- Every resulting proof is still checked by the kernel.
    ⟨`backward.isDefEq.respectTransparency, false⟩
  ]
  moreLeanArgs := #[
    "-Dwarn.sorry=false"
  ]

meta if get_config? env = some "dev" then
require «doc-gen4» from git
  "https://github.com/leanprover/doc-gen4" @ "v4.33.0"

require verso from git
  "https://github.com/leanprover/verso" @ "v4.33.0"

require spytialLean from git "https://github.com/sidprasad/spytial-lean" @ "v0.2.1"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.33.1"

@[default_target]
lean_lib «CLRSLean» where
  srcDir := "src"

@[default_target]
lean_lib SpytialDemos where
  srcDir := "spytial"
  roots := #[`Demos]
  globs := #[.submodules `Demos]
