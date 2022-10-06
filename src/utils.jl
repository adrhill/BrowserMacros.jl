open_browser(url) = DefaultApplication.open(url), return nothing

ismatching(r::Regex, s) = !isnothing(match(r, s))

function rootmodule(m)
    pm = parentmodule(m)
    pm == m && return m
    return rootmodule(pm)
end
