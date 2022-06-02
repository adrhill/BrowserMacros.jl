get_google_url(query) = "https://www.google.com/search?q=$(escapeuri(query))"
get_ddg_url(query) = "https://duckduckgo.com/?q=$(escapeuri(query))"

"""
    google(query::String)

Opens a tab with the specified Google search query in the default browser.

## Example
```julia-repl
julia> google("Why is julialang called Julia?")
```
"""
google(query::AbstractString) = open_browser(get_google_url(query))

"""
    @google query

Opens a tab with the specified Google search query in the default browser.

## Example
```julia-repl
julia> @google "Why is julialang called Julia?"
```
"""
macro google(query)
    return :(google($query))
end

"""
    ddg(query::String)

Opens a tab with the specified DuckDuckGo search query in the default browser.

## Example
```julia-repl
julia> ddg("Why is julialang called Julia?")
```
```julia-repl
julia> @ddg "!gi Julia Logo"
```
"""
ddg(query::AbstractString) = open_browser(get_google_url(query))

"""
    @ddg query

Opens a tab with the specified Google search query in the default browser.

## Example
```julia-repl
julia> @ddg "Why is julialang called Julia?"
```
```julia-repl
julia> @ddg "!gi Julia Logo"
```
"""
macro ddg(query)
    return :(ddg($query))
end
