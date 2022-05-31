function google(query)
    q = URIs.escapeuri(query)
    DefaultApplication.open("https://www.google.com/search?q=$q")
    return nothing
end
macro google(query)
    return :(google($query))
end

function duckduckgo(query)
    q = URIs.escapeuri(query)
    DefaultApplication.open("https://duckduckgo.com/?q=$q")
    return nothing
end

macro duckduckgo(query)
    return :(duckduckgo($query))
end
macro ddg(query)
    return :(duckduckgo($query))
end
