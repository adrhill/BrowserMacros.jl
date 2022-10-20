module BrowserMacros

# The package that makes all of this possible:
using DefaultApplication

# Escape special characters in URLs:
using URIs: URI, escapeuri

# Imports used by `@wwwhich` to look up Repository URLs in Registry:
using Base: UUID, PkgId, load_path, url
using Pkg.Types: manifestfile_path, read_manifest
using Pkg.Registry: reachable_registries
using Pkg.Operations: find_urls
using HTTP: request

# Generate macro `@wwwhich` the same way `@which` is generated:
using InteractiveUtils: gen_call_with_extracted_types

include("utils.jl")
include("search.jl")
include("method_url.jl")
include("wwwhich.jl")
# include("issue.jl")

export google, @google, ddg, @ddg
export wwwhich, @wwwhich
export method_url, google_url, ddg_url # low-level functions used to construct URLs
end # module
