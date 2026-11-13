import Lake
open Lake DSL

package «clrs-lean» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`doc.verso, true⟩
  ]
  moreLeanArgs := #[
    "-Dwarn.sorry=false"
  ]

meta if get_config? env = some "dev" then
require «doc-gen4» from git
  "https://github.com/leanprover/doc-gen4" @ "v4.33.0"

require verso from git
  "https://github.com/leanprover/verso" @ "v4.33.0"

require spytialLean from git "https://github.com/sidprasad/spytial-lean" @
  "fc1e90ef8a96cf20e5059f9d1851a57a8776817e"

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
