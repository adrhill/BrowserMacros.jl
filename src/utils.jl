function open_browser(url)
    DefaultApplication.open(url)
    return url
end

captures(r::Regex, s) = match(r, s).captures
ismatching(r::Regex, s) = !isnothing(match(r, s))

function rootmodule(m)
    pm = parentmodule(m)
    pm == m && return m
    return rootmodule(pm)
end
