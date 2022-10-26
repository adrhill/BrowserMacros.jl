const SEARCH_ENGINES = Dict(
    :google => "https://www.google.com/search?q=", :ddg => "https://duckduckgo.com/?q="
)
for (fname, url) in SEARCH_ENGINES
    @eval begin
        function ($fname)(query::AbstractString; open_browser=true)
            url = URI(($url) * escapeuri(query))
            open_browser && DefaultApplication.open(url)
            return url
        end
    end
end

for fname in keys(SEARCH_ENGINES)
    @eval begin
        macro ($fname)(ex0...)
            # kwarg parsing adapted from InteractiveUtils' gen_call_with_extracted_types_and_kwargs
            kwargs = Expr[]
            query = ex0[end] # Mandatory argument
            for i in 1:(length(ex0) - 1)
                x = ex0[i]
                if x isa Expr && x.head === :(=) # Keyword given of the form "foo=bar"
                    if length(x.args) != 2
                        return Expr(:call, :error, "Invalid keyword argument: $x")
                    end
                    push!(kwargs, Expr(:kw, esc(x.args[1]), esc(x.args[2])))
                else
                    return Expr(:call, :error, "More than one non-keyword argument passed.")
                end
            end
            return :($(Expr(:quote, $(fname)))($query; $(kwargs...)))
        end
    end
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
julia> url = @google open_browser=false "Why is julialang called Julia?"
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
julia> url = @ddg open_browser=false "!gi Julia Logo"
```

See also: [`@google`](@ref).
"""
:@ddg
