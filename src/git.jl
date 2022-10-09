const JULIA_REPO = "https://github.com/JuliaLang/julia"
const PKG_REPO = "https://github.com/JuliaLang/Pkg.jl"

function wwwhich(@nospecialize(f), @nospecialize(types))
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
    return open_browser(url)
end

macro wwwhich(ex0)
    return gen_call_with_extracted_types(__module__, :wwwhich, ex0)
end

macro wwwhich(ex0::Symbol)
    ex0 = QuoteNode(ex0)
    return :(wwwhich($__module__, $ex0))
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
    uuid, version = uuid_and_version(m)
    url = repo_url(uuid)
    if ismatching(r"gitlab", url)
        return URI("$url/~/blob/v$version/src/$path#L$(m.line)")
    end
    return URI("$url/blob/v$version/src/$path#L$(m.line)") # attempt GitHub-like URL
end

# Step 3: use Pkg internals to find repository URL
function uuid_and_version(m::Method)
    dep_name = "$(rootmodule(m.module))"
    for path in load_path()
        ismatching(r"julia/stdlib", path) && continue
        env = EnvCache(path)
        uuid = get(env.project.deps, dep_name, nothing)
        isnothing(uuid) && continue # look up next environment in LOAD_PATH

        entry = manifest_info(env.manifest, uuid)
        version = hasproperty(entry, :version) ? entry.version : nothing
        return uuid, version
    end
    throw(
        ErrorException(
            "Could not find module $dep_name of method `$(m.name)` in project dependencies."
        ),
    )
end

function repo_url(uuid::UUID)
    urls = find_urls(reachable_registries(), uuid)
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
