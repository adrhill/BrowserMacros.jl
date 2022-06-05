get_google_url(query) = "https://www.google.com/search?q=$(escapeuri(query))"
google(query::AbstractString) = open_browser(get_google_url(query))
macro google(query)
    return :(google($query))
end

get_ddg_url(query) = "https://duckduckgo.com/?q=$(escapeuri(query))"
ddg(query::AbstractString) = open_browser(get_ddg_url(query))
macro ddg(query)
    return :(ddg($query))
end

"""
    google(query::String)

Open a tab with the specified Google search query in the default browser.
Also usable as the macro [`@google`](@ref).

## Example
```julia-repl
julia> google("Why is julialang called Julia?")
```

See also: [`ddg`](@ref).
"""
google

"""
    @google query

Open a tab with the specified Google search query in the default browser.
Also usable as the function [`google`](@ref).

## Example
```julia-repl
julia> @google "Why is julialang called Julia?"
```

See also: [`@ddg`](@ref).
"""
:@google

"""
    ddg(query::String)

Open a tab with the specified DuckDuckGo search query in the default browser.
Also usable as the macro [`@ddg`](@ref).

## Example
```julia-repl
julia> ddg("Why is julialang called Julia?")
```
```julia-repl
julia> @ddg "!gi Julia Logo"
```

See also: [`google`](@ref).
"""
ddg

"""
    @ddg query

Open a tab with the specified Google search query in the default browser.
Also usable as the function [`ddg`](@ref).

## Example
```julia-repl
julia> @ddg "Why is julialang called Julia?"
```
```julia-repl
julia> @ddg "!gi Julia Logo"
```

See also: [`@google`](@ref).
"""
:@ddg
