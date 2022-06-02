using BrowserMacros
using Documenter

DocMeta.setdocmeta!(BrowserMacros, :DocTestSetup, :(using BrowserMacros); recursive=true)

makedocs(;
    modules=[BrowserMacros],
    authors="Adrian Hill <adrian.hill@mailbox.org>",
    repo="https://github.com/adrhill/BrowserMacros.jl/blob/{commit}{path}#{line}",
    sitename="BrowserMacros.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://adrhill.github.io/BrowserMacros.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/adrhill/BrowserMacros.jl", devbranch="main")
