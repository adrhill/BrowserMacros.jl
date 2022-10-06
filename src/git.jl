const JULIA_REPO = "https://github.com/JuliaLang/julia"
const PKG_REPO = "https://github.com/JuliaLang/Pkg.jl"

function wwwhich(@nospecialize(f), @nospecialize(types))
    method = which(f, types)
    info = MethodInfo(method)
    url = method_url(info)

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

# Step 1: parse Method obtained from `which` into MethodInfo:
struct MethodInfo
    root_module::Module
    module_name::String
    path::String
    version::String
    line::Int
    type::Symbol
end

function MethodInfo(method::Method)
    file_path = String(method.file)
    root_module = rootmodule(method.module)
    line = method.line

    if !ismatching(r"src", file_path) # part of Julia Base
        module_name = "$(method.module)"
        path = String(method.file)
        version = ""
        type = :base
    elseif ismatching(r"stdlib", file_path) # part of Julia stdlib
        m = match(r"/julia/stdlib/v(.*?)/(.*?)/src/(.*)", file_path)
        version, module_name, path = m.captures
        type = :stdlib
    else # external repo
        m = match(r"packages/(.*?)/.*?/src/(.*)", file_path)
        module_name, path = m.captures
        version = ""
        type = :external
    end
    return MethodInfo(root_module, module_name, path, version, line, type)
end

# Step 2: Convert MethodInfo to URL:
method_url(m::MethodInfo) = method_url(m, Val(m.type))

function method_url(m::MethodInfo, ::Val{:base})
    return "$JULIA_REPO/blob/v$VERSION/base/$(m.path)#L$(m.line)"
end

function method_url(m::MethodInfo, ::Val{:stdlib})
    if m.module_name == "Pkg"
        return "$PKG_REPO/blob/release-$(m.version)/src/$(m.path)#L$(m.line)"
    end
    return "$JULIA_REPO/blob/v$VERSION/stdlib/$(m.module_name)/src/$(m.path)#L$(m.line)"
end

function method_url(m::MethodInfo, ::Val{:external})
    uuid, version = module_uuid(m.root_module)
    url = uuid2url(uuid)
    if ismatching(r"gitlab", url)
        return "$url/~/blob/v$version/src/$(m.path)#L$(m.line)"
    end
    return "$url/blob/v$version/src/$(m.path)#L$(m.line)" # attempt GitHub-like URL
end

# The following functions find the URL of a module's repository
# by looking up its UUID in the available package registries:
function module_uuid(m::Module)::Tuple{UUID,VersionNumber}
    return only((uuid, p.version) for (uuid, p) in dependencies() if p.name == "$m")
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
