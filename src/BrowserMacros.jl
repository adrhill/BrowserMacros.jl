module BrowserMacros

# The package that makes all of this possible:
using DefaultApplication

# Escape special characters in URLs:
using URIs: escapeuri

# Imports used by `@wwwhich` to look up Repository URLs in Registry:
using Base: UUID
using Pkg.Types: EnvCache
using Pkg.Registry: PkgInfo, RegistryInstance, reachable_registries

# Generate macro `@wwwhich` from function `wwwhich` the same way `@which` is generated:
using InteractiveUtils: gen_call_with_extracted_types

open_browser(url) = DefaultApplication.open(url), return nothing

include("search.jl")
include("wwwhich.jl")

export google, @google, ddg, @ddg
end # module
