const JULIA_REPO = "https://github.com/JuliaLang/julia"
const PKG_REPO = "https://github.com/JuliaLang/Pkg.jl"

function wwwhich(@nospecialize(f), @nospecialize(types); open_browser=true)
    return wwwhich(f, types, open_browser)
end
function wwwhich(@nospecialize(f), @nospecialize(types), open_browser)
    method = which(f, types)
    url = method_url(method)

    try # attempt HTTP request before opening URL in browser
        r = request("GET", url; retries=5)
    catch e
        @warn """BrowserMacros failed to find a valid URL for the method `$(method.name)`.
            Please open an issue at https://github.com/adrhill/BrowserMacros.jl/issues
            with the following information:"""
        display(method)
        println("Failing URL: $url")
        return nothing
    end
    open_browser && DefaultApplication.open(url)
    return url
end

macro wwwhich(ex0, kwargs...)
    return gen_call_with_extracted_types(__module__, :wwwhich, ex0, map(esc, kwargs))
end

macro wwwhich(ex0::Symbol, kwargs...)
    ex0 = QuoteNode(ex0)
    return :(wwwhich($__module__, $ex0; $(map(esc, kwargs)...)))
end

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
    path = only(captures(r"/src/(.*)", String(m.file)))
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
    return only(captures(r"(.*).git", first(urls)))
end

"""
    wwwhich(f, (types,))

`@which` using the power of the world-wide-web. Opens a GitHub tab in the default browser
that points to the line of code returned by `which`.

See also: [`which`](@ref).
"""
wwwhich

"""
    @wwwhich f(args...)

`@which` using the power of the world-wide-web. Opens a GitHub tab in the default browser
that points to the line of code returned by `@which`.

See also: [`@which`](@ref).
"""
:@wwwhich
