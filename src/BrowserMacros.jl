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
using InteractiveUtils: gen_call_with_extracted_types_and_kwargs

# For `@issue` body:
using Pkg: status
using InteractiveUtils: versioninfo

include("utils.jl")
include("search.jl")
include("method_url.jl")
include("wwwhich.jl")
include("issue.jl")

export wwwhich, @wwwhich
export issue, @issue
# Low-level functions used to construct URLs:
export method_url, repo_url

# Search engines from search.jl:
export arxiv, @arxiv
export ddg, @ddg
export discourse, @discourse
export google, @google
export juliahub, @juliahub
export scholar, @scholar
export wikipedia, @wikipedia
export youtube, @youtube
export zulip, @zulip
end # module
