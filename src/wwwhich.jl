function wwwhich(@nospecialize(f), @nospecialize(types); open_browser=true)
    return wwwhich(f, types, open_browser)
end
function wwwhich(@nospecialize(f), @nospecialize(types), open_browser)
    method = which(f, types)
    url = method_url(method)
    if url_exists(url)
        open_browser && DefaultApplication.open(url)
        return url
    end
    @warn """BrowserMacros failed to find a valid URL for the method `$(method.name)`.
    Please open an issue at https://github.com/adrhill/BrowserMacros.jl/issues
    with the following information:"""
    display(method)
    println("Failing URL: $url")
    return nothing
end

macro wwwhich(ex0, kwargs...)
    return gen_call_with_extracted_types(__module__, :wwwhich, ex0, map(esc, kwargs))
end

macro wwwhich(ex0::Symbol, kwargs...)
    ex0 = QuoteNode(ex0)
    return :(wwwhich($__module__, $ex0; $(map(esc, kwargs)...)))
end

"""
    wwwhich(f, (types,))

`@which` using the power of the world-wide-web. Opens a GitHub tab in the default browser
that points to the line of code returned by `which`.

## Examples
```julia-repl
julia> wwwhich(sqrt, (Float32,))
```
```julia-repl
julia> url = wwwhich(sqrt, (Float32,); open_browser=false)
```

See also: [`which`](@ref).
"""
wwwhich

"""
    @wwwhich f(args...)

`@which` using the power of the world-wide-web. Opens a GitHub tab in the default browser
that points to the line of code returned by `@which`.

## Examples
```julia-repl
julia> @wwwhich sqrt(5.0)
```
```julia-repl
julia> url = @wwwhich sqrt(5.0) open_browser=false
```

See also: [`@which`](@ref).
"""
:@wwwhich
