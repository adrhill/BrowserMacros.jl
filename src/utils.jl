ismatching(r::Regex, s) = !isnothing(match(r, s))
captures(r::Regex, s) = match(r, s).captures
onlycapture(r::Regex, s) = only(match(r, s).captures)

function rootmodule(m)
    pm = parentmodule(m)
    pm == m && return m
    return rootmodule(pm)
end
