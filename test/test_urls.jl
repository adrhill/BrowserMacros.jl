using BrowserMacros: MethodInfo, method_url, google_url, ddg_url
using URIs: URI

# Load some modules to test wwwhich's URLs:
using InteractiveUtils: @which
using DefaultApplication

@test @inferred google_url("123!@#\$%^&*()_+QWERT{}|") == URI(
    "https://www.google.com/search?q=123%21%40%23%24%25%5E%26%2A%28%29_%2BQWERT%7B%7D%7C"
)
@test @inferred ddg_url("줄리아, جوليا") == URI(
    "https://duckduckgo.com/?q=%EC%A4%84%EB%A6%AC%EC%95%84%2C%20%D8%AC%D9%88%D9%84%D9%8A%D8%A7",
)

# Base
m = @which sqrt(1.0)
info = @inferred MethodInfo(m)
url = @inferred method_url(info)
@test !isnothing(url)

# stdlib
m = @which @which sqrt(1.0)
info = @inferred MethodInfo(m)
url = @inferred method_url(info)
@test !isnothing(url)

# External packages
m = Base.which(DefaultApplication.open, (String,))
info = @inferred MethodInfo(m)
url = @inferred method_url(info)
@test url == URI(
    "https://github.com/tpapp/DefaultApplication.jl/blob/v1.1.0/src/DefaultApplication.jl#L18",
)
