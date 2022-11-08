const DEFAULT_ISSUE_TEXT = "[Please check existing issues in this repository before submitting.]\n"

function issue(
    @nospecialize(f),
    @nospecialize(types);
    text=DEFAULT_ISSUE_TEXT,
    open_browser=true,
    status=true,
    versioninfo=true,
    verbose=false,
    footer=true,
)
    method = which(f, types)
    repository = repo_url(method)
    if url_exists(repository)
        body = _issue_body(text, status, versioninfo, verbose, footer)
        url = URI("$repository/issues/new?body=$body")
        open_browser && DefaultApplication.open(url)
        return url
    end
    @warn """BrowserMacros failed to find a valid repository for the method `$(method.name)`.
    Please open an issue at https://github.com/adrhill/BrowserMacros.jl/issues
    with the following information:"""
    display(method)
    println("Failing repository URL: $repository")
    return nothing
end

macro issue(ex0...)
    return gen_call_with_extracted_types_and_kwargs(__module__, :issue, ex0)
end

macro issue(ex0::Symbol, kwargs...)
    ex0 = QuoteNode(ex0)
    return :(issue($__module__, $ex0; $(map(esc, kwargs)...)))
end

const FOOTER = "*Filed using [BrowserMacros.jl](https://github.com/adrhill/BrowserMacros.jl/)*"
function _issue_body(
    text::AbstractString, _status::Bool, _versioninfo::Bool, verbose::Bool, footer::Bool
)
    io = IOBuffer()
    println(io, text)
    _status && _versioninfo && println(io, "___")
    if _status
        println(io, "<details>")
        println(io, "<summary>Dependencies</summary>")
        println(io, "\n```")
        status(; io=io)
        println(io, "```\n")
        println(io, "</details>\n")
    end
    if _versioninfo
        println(io, "<details>")
        println(io, "<summary>Version Info</summary>")
        println(io, "\n```")
        versioninfo(io; verbose=verbose)
        println(io, "```\n")
        println(io, "</details>\n")
    end
    footer && print(io, FOOTER)
    return escapeuri(String(take!(io)))
end

"""
    @issue f(args...)

Open a draft for a GitHub issue in the repository of function `f` in the default browser.
The issue still needs to be manually submitted.

## Keyword arguments
- `text`: Text for the issue body. Defaults to a reminder to check open issues.
- `status`: Summarize project status using `Pkg.status`. Defaults to `true`.
- `versioninfo`: Summarize Julia version using `versioninfo`. Defaults to `true`.
- `verbose`: Verbosity of `versioninfo`. Defaults to `false`.
- `footer`: Prints BrowserMacros footer. Defaults to `true`.

## Examples
```julia
@issue sqrt(5.0)
```
Pre-fill the issue with your own text:
```julia
@issue text="My text" open_browser=false status=false versioninfo=false footer=false sqrt(5)
```
"""
:issue
