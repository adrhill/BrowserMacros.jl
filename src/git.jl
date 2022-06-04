
function wwwhich(@nospecialize(f), @nospecialize(types))
    method = which(f, types)
    url = get_method_url(method)
    try
        r = HTTP.request("GET", url)
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

macro wwwhich(expr)
    return :(wwwhich(expr))
end

function get_method_url(method::Method)
    m1 = match(r"src/(.*)", String(method.file))
    m2 = match(r"/julia/stdlib/(.*?)/(.*)", String(method.file))
    return if isnothing(m1) # part of Julia Base
        get_base_url(method.file, method.line)
    elseif !isnothing(m2) # Julia stdlib
        get_stdlib_url(last(m2.captures), method.line)
    else # external repo
        get_external_url(only(m1.captures), method.line, method.module)
    end
end

get_base_url(path, ln, type="blob") = "https://github.com/JuliaLang/julia/$type/v$VERSION/base/$path#L$ln"
get_stdlib_url(path, ln, type="blob") = "https://github.com/JuliaLang/julia/$type/v$VERSION/stdlib/$path#L$ln"
function get_external_url(path, ln, mod::Module, type="blob")
    uuid, version = get_dependency_info(rootmodule(mod))
    repo_url = uuid2url(uuid)
    return "$repo_url/$type/v$version/src/$path#L$ln"
end

function rootmodule(m)
    pm = parentmodule(m)
    pm == m && return m
    return rootmodule(pm)
end

function get_dependency_info(dep::Module)::Tuple{UUID, VersionNumber}
    env = EnvCache()
    return only((uuid, v.version) for (uuid, v) in env.manifest.deps if v.name == "$dep")
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
    pkg = r.pkgs[uuid]
    m = match(r"(.*).git", pkg.info.repo)
    return only(m.captures)
end

"""
    wwwhich(f, (types,))

`@which` using the power of the world-wide-web. Opens a GitHub or GitLab tab in the
default browser that points to the line of code returned by [`which`](@ref).
For more information, refer to the

See also: `@less`, `@edit`.
"""
:@wwwhich

"""
    @wwwhich f(args...)

`@which` using the power of the world-wide-web. Opens a GitHub or GitLab tab in the
default browser that points to the line of code returned by [`which`](@ref).
For more information, refer to the

See also: `@less`, `@edit`.
"""
:@wwwhich
