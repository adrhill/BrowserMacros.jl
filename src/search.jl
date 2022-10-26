const SEARCH_ENGINES = (
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

for fname in map(first, SEARCH_ENGINES)
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

# Docstrings
for fname in map(first, SEARCH_ENGINES)
    name = string(fname)
    @eval begin
        @doc """
            $($name)(query::String)

        Open a tab with the specified search query in the default browser.
        Also usable as the macro [`@$($name)`](@ref).

        ## Examples
        ```julia
        $($name)("Why is julialang called Julia?") # opens default browser

        url = $($name)("Why is julialang called Julia?"; open_browser=false)
        ```
        """ $fname
    end

    @eval begin
        @doc """
            @$($name) query

        Open a tab with the specified search query in the default browser.
        Also usable as the function [`$($name)`](@ref).

        ## Examples
        ```julia
        @$($name) "Why is julialang called Julia?" # opens default browser

        url = @$($name) open_browser=false "Why is julialang called Julia?"
        ```
        """ $(Symbol("@$name"))
    end
end
