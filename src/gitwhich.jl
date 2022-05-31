function get_dependency_info(dep::Module)::Tuple{UUID, VersionNumber}
    env = Pkg.Types.EnvCache()
    return only((uuid, v.version) for (uuid, v) in env.manifest.deps if v.name == "$dep")
end

uri2url(u::UUID) = uri2url(first(Pkg.Registry.reachable_registries()), u)
function uri2url(r::RegistryInstance, uuid::UUID)
    return replace(r.pkgs[uuid].info.repo, ".git"=>"")
end

function ghwhich(args...) # pronounced "bewitch!"
    wh = which(args...)
    uuid, version = get_dependency_info(wh.module)
    repo_url = uri2url(uuid)
    repo_path = match(r"src.*", String(wh.file)).match
    DefaultApplication.open("$repo_url/blob/v$version/$repo_path#L$(wh.line)")
    return nothing
end
