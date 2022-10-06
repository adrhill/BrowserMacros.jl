<img align="left" src="https://github.com/adrhill/BrowserMacros.jl/blob/gh-pages/assets/logo.svg" height="130">

# BrowserMacros.jl

[![][ci-im]][ci] [![][cov-im]][cov]

---
A collection of Julia macros to access your browser from the comfort of your REPL.  

⚠️ This package is in early development, so there will be a lot of edge-cases to iron out. ⚠️

## Installation 
This package hasn't been registered yet.
To install it, open the Julia REPL and run 
```julia-repl
julia> ]add https://github.com/adrhill/BrowserMacros.jl
```

## Functionality
### GitHub tools
The macro `@wwwhich` ("world-wide-which") followed by a method call will open a new GitHub tab in your browser, showing the exact line of code that is run:
```julia
@wwwhich sqrt(2.0) 
```

This also works with code from external packages!

![](https://github.com/adrhill/BrowserMacros.jl/blob/gh-pages/assets/wwwhich.png)

<!-- GitHub's git blame view can be opened in the same fashion:
```julia
@blame exp(5) 
``` 
-->

### Search engines
Google search and DuckDuckGo can be queried from your REPL:
```julia
@google "Why is julialang called Julia?"  
```

Since these are regular queries, [DuckDuckGo's bangs](https://duckduckgo.com/bang) are supported, e.g. to search for papers on Google Scholar: 
```julia
@dgg "!scholar Julia - A Fresh Approach to Numerical Computing"                     
```

## How does it work?
BrowserMacros constructs URLs and opens them using [DefaultApplication.jl](https://github.com/tpapp/DefaultApplication.jl). 
For `@wwwhich`, we make use of InteractiveUtils' `which` and look up modules in the Registry to find matching GitHub repositories.

## To-Do
Support for packages hosted on GitLab, SourceHut & Co.

Contributions are more than welcome!

[ci-im]: https://github.com/adrhill/BrowserMacros.jl/actions/workflows/CI.yml/badge.svg?branch=main
[ci]: https://github.com/adrhill/BrowserMacros.jl/actions/workflows/CI.yml?query=branch%3Amain

[cov-im]: https://codecov.io/gh/adrhill/BrowserMacros.jl/branch/main/graph/badge.svg
[cov]: https://codecov.io/gh/adrhill/BrowserMacros.jl