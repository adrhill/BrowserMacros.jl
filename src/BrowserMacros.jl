module BrowserMacros

using Base: UUID
using Pkg.Types: EnvCache
using Pkg.Registry: PkgInfo, RegistryInstance, reachable_registries
using DefaultApplication: open
using URIs: escapeuri

include("search.jl")
include("github.jl")

export @google, @duckduckgo, @ddg
end # module
