function wwwhich(@nospecialize(f), @nospecialize(types); open_browser=true)
    method = which(f, types)
    url = method_url(method)
    open_browser && DefaultApplication.open(url)
    return url
end

macro wwwhich(ex0...)
    return gen_call_with_extracted_types_and_kwargs(__module__, :wwwhich, ex0)
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
julia> url = @wwwhich open_browser=false sqrt(5.0)
```

See also: [`@which`](@ref).
"""
:@wwwhich
