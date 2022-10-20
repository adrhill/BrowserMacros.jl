function google(query::AbstractString; open_browser=true)
    url = URI("https://www.google.com/search?q=$(escapeuri(query))")
    open_browser && DefaultApplication.open(url)
    return url
end
macro google(query, kwargs...)
    return :(google($query; $(map(esc, kwargs)...)))
end

function ddg(query::AbstractString; open_browser=true)
    url = URI("https://duckduckgo.com/?q=$(escapeuri(query))")
    open_browser && DefaultApplication.open(url)
    return url
end
macro ddg(query, kwargs...)
    return :(ddg($query; $(map(esc, kwargs)...)))
end

"""
    google(query::String)

Open a tab with the specified Google search query in the default browser.
Also usable as the macro [`@google`](@ref).

## Example
```julia-repl
julia> google("Why is julialang called Julia?")
```
```julia-repl
julia> url = google("Why is julialang called Julia?"; open_browser=false)
```

See also: [`ddg`](@ref).
"""
google

"""
    @google query

Open a tab with the specified Google search query in the default browser.
Also usable as the function [`google`](@ref).

## Examples
```julia-repl
julia> @google "Why is julialang called Julia?"
```
```julia-repl
julia> url = @google "Why is julialang called Julia?" open_browser=false
```

See also: [`@ddg`](@ref).
"""
:@google

"""
    ddg(query::String)

Open a tab with the specified DuckDuckGo search query in the default browser.
Also usable as the macro [`@ddg`](@ref).

## Examples
```julia-repl
julia> ddg("Why is julialang called Julia?")
```
```julia-repl
julia> ddg("!gi Julia Logo")
```
```julia-repl
julia> url = ddg("!gi Julia Logo"; open_browser=false)
```

See also: [`google`](@ref).
"""
ddg

"""
    @ddg query

Open a tab with the specified Google search query in the default browser.
Also usable as the function [`ddg`](@ref).

## Examples
```julia-repl
julia> @ddg "Why is julialang called Julia?"
```
```julia-repl
julia> @ddg "!gi Julia Logo"
```
```julia-repl
julia> url = @ddg "!gi Julia Logo" open_browser=false
```

See also: [`@google`](@ref).
"""
:@ddg
