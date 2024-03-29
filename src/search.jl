const SEARCH_FUNCTIONS = (
    :arxiv         => "https://arxiv.org/search/?query=",
    :baidu         => "https://www.baidu.com/s?wd=",
    :bing          => "https://www.bing.com/search?q=",
    :brave         => "https://search.brave.com/search?q=",
    :chatgpt       => "https://chat.openai.com/chat?q=",
    :ddg           => "https://duckduckgo.com/?q=",
    :discourse     => "https://discourse.julialang.org/search?q=",
    :ecosia        => "https://www.ecosia.org/search?q=",
    :github        => "https://github.com/search?q=",
    :goodreads     => "https://www.goodreads.com/search?q=",
    :google        => "https://www.google.com/search?q=",
    :juliahub      => "https://juliahub.com/ui/Search?q=",
    :qwant         => "https://www.qwant.com/?q=",
    :scholar       => "https://scholar.google.com/scholar?q=",
    :stackoverflow => "https://stackoverflow.com/search?q=",
    :webarchive    => "https://web.archive.org/web/*/",
    :wikipedia     => "https://en.wikipedia.org/wiki/Special:Search?search=",
    :wolframalpha  => "https://www.wolframalpha.com/input/?i=",
    :yahoo         => "https://search.yahoo.com/search?p=",
    :yandex        => "https://yandex.ru/yandsearch?text=",
    :youtube       => "https://www.youtube.com/results?search_query=",
    :zulip         => "https://julialang.zulipchat.com/#narrow/search/",
)

for (fname, url) in SEARCH_FUNCTIONS
    name = string(fname)

    @eval begin
        """
            $($name)(query::String)

        Open a tab with the specified search query in the default browser.
        Also usable as the macro [`@$($name)`](@ref).

        ## Examples
        ```julia
        $($name)("My search query") # opens default browser

        url = $($name)("My search query"; open_browser=false)
        ```
        """
        function ($fname)(query::AbstractString; open_browser=true)
            url = URI(($url) * escapeuri(query))
            open_browser && DefaultApplication.open(url)
            return url
        end

        """
            @$($name) query
        Open a tab with the specified search query in the default browser.
        Also usable as the function [`$($name)`](@ref).

        ## Examples
        ```julia
        @$($name) "My search query" # opens default browser

        url = @$($name) open_browser=false "My search query"
        ```
        """
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
