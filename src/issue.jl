function issue(@nospecialize(f), @nospecialize(types))
    method = which(f, types)
    repository = repo_url(method)
    if url_exists(repository)
        body = _issue_body()
        url = URI("$repository/issues/new?body=$body")
        DefaultApplication.open(url)
        return url
    end
    @warn """BrowserMacros failed to find a valid repository for the method `$(method.name)`.
    Please open an issue at https://github.com/adrhill/BrowserMacros.jl/issues
    with the following information:"""
    display(method)
    println("Failing repository URL: $repository")
    return nothing
end

macro issue(ex0)
    return gen_call_with_extracted_types(__module__, :issue, ex0)
end

macro issue(ex0::Symbol)
    ex0 = QuoteNode(ex0)
    return :(issue($__module__, $ex0))
end

function _issue_body()
    io = IOBuffer()
    println(io, "[Please check existing issues in this repository before submitting.]\n")
    println(io, "___")
    println(io, "<details>")
    println(io, "<summary>Dependencies</summary>")
    println(io, "\n```")
    status(; io=io)
    println(io, "```\n")
    println(io, "</details>")

    println(io, "<details>")
    println(io, "<summary>Version Info</summary>")
    println(io, "\n```")
    versioninfo(io; verbose=false)
    println(io, "```\n")
    println(io, "</details>\n")
    print(
        io, "*Filed using [BrowserMacros.jl](https://github.com/adrhill/BrowserMacros.jl/)*"
    )
    return escapeuri(String(take!(io)))
end
