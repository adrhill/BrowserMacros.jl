module BrowserMacros

# The package that makes all of this possible:
using DefaultApplication

# Escape special characters in URLs:
using URIs: escapeuri

# Imports used by `@wwwhich` to look up Repository URLs in Registry:
using Base: UUID
using Pkg: dependencies
using Pkg.Registry: RegistryInstance, reachable_registries, init_package_info!
using HTTP: request

# Generate macro `@wwwhich` the same way `@which` is generated:
using InteractiveUtils: gen_call_with_extracted_types

open_browser(url) = DefaultApplication.open(url), return nothing

include("utils.jl")
include("search.jl")
include("git.jl")

export google, @google, ddg, @ddg
export wwwhich, @wwwhich
end # module
