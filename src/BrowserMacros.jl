module BrowserMacros

using Base: UUID
using Pkg.Types: EnvCache
using Pkg.Registry: PkgInfo, RegistryInstance, reachable_registries
using DefaultApplication
using URIs: escapeuri

open_browser(url) = DefaultApplication.open(url), return nothing

include("wwwhich.jl")
include("search.jl")

export google, @google, ddg, @ddg
end # module
