function url_exists(url)
    try # attempt HTTP request before opening URL in browser
        r = request("GET", url; retries=5)
    catch e
        return false
    end
    return true
end

captures(r::Regex, s) = match(r, s).captures
ismatching(r::Regex, s) = !isnothing(match(r, s))

function rootmodule(m)
    pm = parentmodule(m)
    pm == m && return m
    return rootmodule(pm)
end
