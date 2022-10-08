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

# Step 2: assemble URL
method_url(m::Method, ::Val{:Base}) = URI(url(m))

function method_url(m::Method, ::Val{:stdlib})
    ver, package_name, path = captures(r"/stdlib/v(.*?)/(.*?)/src/(.*)", String(m.file))
    if package_name == "Pkg"
        return URI("$PKG_REPO/blob/release-$ver/src/$path#L$(m.line)")
    end
    return URI("$JULIA_REPO/blob/v$VERSION/stdlib/$package_name/src/$path#L$(m.line)")
end

function method_url(m::Method, ::Val{:external})
    path = only(captures(r"/src/(.*)", String(m.file)))
    uuid, version = module_uuid(m)
    url = uuid2url(uuid)
    if ismatching(r"gitlab", url)
        return URI("$url/~/blob/v$version/src/$path#L$(m.line)")
    end
    return URI("$url/blob/v$version/src/$path#L$(m.line)") # attempt GitHub-like URL
end

# The following functions find the URL of a module's repository
# by looking up its UUID in the available package registries:
function module_uuid(m::Method)::Tuple{UUID,VersionNumber}
    deps = dependencies()
    root_module = rootmodule(m.module)
    ret = [(uuid, pkg.version) for (uuid, pkg) in deps if pkg.name == "$root_module"]
    isempty(ret) && error(
        "Could not find module $root_module of method `$(m.name)` in project dependencies.",
    )
    return only(ret)
end

function uuid2url(uuid::UUID)
    for reg in reachable_registries()
        r = uuid2url(reg, uuid)
        !isnothing(r) && return r
    end
    throw(ErrorException("Couldn't find module with UUID $uuid in reachable registries."))
end
function uuid2url(r::RegistryInstance, uuid::UUID)
    !haskey(r.pkgs, uuid) && return nothing
    pkg_entry = r.pkgs[uuid]
    init_package_info!(pkg_entry)
    m = match(r"(.*).git", pkg_entry.info.repo)
    return only(m.captures)
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
