<img align="left" src="https://github.com/adrhill/BrowserMacros.jl/blob/gh-pages/assets/logo.svg" height="130">

# BrowserMacros.jl

[![][ci-im]][ci] [![][cov-im]][cov]

Julia macros to access your browser from the comfort of your REPL.  

## Installation 
This package hasn't been registered yet. 
To install it, open the Julia REPL and run 
```julia-repl
julia> ]add https://github.com/adrhill/BrowserMacros.jl
```

⚠️ BrowserMacros currently requires Julia **≥1.7** and is in early development, 
so there will be a lot of edge-cases to iron out. ⚠️

## Functionality
### GitHub
The highlight of this package is the macro `@wwwhich` ("world-wide-which"). 
It is almost identical to `@which`, but will open a new GitHub tab in your browser, 
showing the the exact line of code that is run:
```julia
@wwwhich sqrt(2.0) 
```

![](https://github.com/adrhill/BrowserMacros.jl/blob/gh-pages/assets/wwwhich.png)

This also works with code from external packages!
Since `@wwwhich` opens a permalink, it is perfectly suited for sharing code.

### Search engines
Google search and DuckDuckGo can be queried from your REPL:
```julia
@google "How to write macros in Julia"  
```

Since these are regular queries, [DuckDuckGo's bangs](https://duckduckgo.com/bang) are supported, 
e.g. to search for papers on Google Scholar: 
```julia
@dgg "!scholar Julia - A Fresh Approach to Numerical Computing"                     
```

## How does it work?
BrowserMacros constructs URLs and opens them using [DefaultApplication.jl](https://github.com/tpapp/DefaultApplication.jl). 
`@wwwhich` works by 
1. finding the corresponding method using InteractiveUtils' `which`
2. determining the UUID and the version of the module containing the method 
3. looking up the UUID in the reachable registries to find the matching GitHub repository
4. constructing a permalink to the relevant line of code

## To-Do
Support for packages hosted on GitLab, SourceHut & Co.

Contributions are more than welcome!

[ci-im]: https://github.com/adrhill/BrowserMacros.jl/actions/workflows/CI.yml/badge.svg?branch=main
[ci]: https://github.com/adrhill/BrowserMacros.jl/actions/workflows/CI.yml?query=branch%3Amain

[cov-im]: https://codecov.io/gh/adrhill/BrowserMacros.jl/branch/main/graph/badge.svg
[cov]: https://codecov.io/gh/adrhill/BrowserMacros.jl