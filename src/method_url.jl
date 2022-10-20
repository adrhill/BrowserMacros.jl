const JULIA_REPO = "https://github.com/JuliaLang/julia"
const PKG_REPO = "https://github.com/JuliaLang/Pkg.jl"

# Step 1: determine type of repository
method_url(m::Method) = method_url(m, Val(repotype(m)))

function repotype(m::Method)
    path = String(m.file)
    !ismatching(r"src", path) && return :Base
    ismatching(r"stdlib", path) && return :stdlib
    return :external
end

# Step 2: assemble URL using heuristics
method_url(m::Method, ::Val{:Base}) = URI(Base.url(m))

function method_url(m::Method, ::Val{:stdlib})
    ver, package_name, path = captures(r"/stdlib/v(.*?)/(.*?)/src/(.*)", String(m.file))
    if package_name == "Pkg"
        return URI("$PKG_REPO/blob/release-$ver/src/$path#L$(m.line)")
    end
    return URI("$JULIA_REPO/blob/v$VERSION/stdlib/$package_name/src/$path#L$(m.line)")
end

function method_url(m::Method, ::Val{:external})
    path = onlycapture(r"/src/(.*)", String(m.file))
    id = PkgId(m.module)
    url = _url(id)
    ver = _version(id)
    if ismatching(r"gitlab", url)
        return URI("$url/~/blob/v$ver/src/$path#L$(m.line)")
    end
    return URI("$url/blob/v$ver/src/$path#L$(m.line)") # attempt GitHub-like URL
end

# Step 3: use Pkg internals to find repository URL
_manifest(loadpath) = read_manifest(manifestfile_path(dirname(loadpath)))

function _version(id::PkgId)
    for path in load_path()
        ismatching(r"julia/stdlib", path) && continue
        manifest = _manifest(path)
        pkg_entry = get(manifest, id.uuid, nothing)
        ver = hasproperty(pkg_entry, :version) ? pkg_entry.version : nothing
        !isnothing(ver) && return ver # else look up next environment in LOAD_PATH
    end
    return error("Could not find module $id in project dependencies.")
end

function _url(id::PkgId)
    urls = find_urls(reachable_registries(), id.uuid)
    isempty(urls) && error("Could not find module $id in reachable registries.")
    return first(splitext(first(urls))) # strip ".git" ending
end

# To avoid code duplication, repo_url trims method_url until the fifth "/", e.g.:
#  https://github.com/foo/Bar.jl/blob/v0.1.0/src/qux.jl#L7 turns to
#  https://github.com/foo/Bar.jl
repo_url(m::Method) = _repo_url(method_url(m))
_repo_url(url::URI) = URI(onlycapture(r"((?:.*?\/){4}(?:.*?))\/", url.uri))
