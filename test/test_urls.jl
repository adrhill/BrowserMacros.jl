using BrowserMacros
using URIs: URI

# Load some modules to test wwwhich's URLs:
using InteractiveUtils: @which
using DefaultApplication

url_google = URI(
    "https://www.google.com/search?q=123%21%40%23%24%25%5E%26%2A%28%29_%2BQWERT%7B%7D%7C"
)
url = @google "123!@#\$%^&*()_+QWERT{}|" open_browser = false
@test url == url_google

url_ddg = URI(
    "https://duckduckgo.com/?q=%EC%A4%84%EB%A6%AC%EC%95%84%2C%20%D8%AC%D9%88%D9%84%D9%8A%D8%A7",
)
url = @ddg "줄리아, جوليا" open_browser = false
@test url == url_ddg

# Base
m = @which sqrt(1.0)
url1 = @inferred method_url(m)
@test !isnothing(url1)
url2 = @wwwhich sqrt(1.0) open_browser = false
@test url1 == url2

# stdlib
m = @which @which sqrt(1.0)
url = @inferred method_url(m)
@test !isnothing(url)

# External packages
url = wwwhich(DefaultApplication.open, (String,); open_browser=false)
@test url == URI(
    "https://github.com/tpapp/DefaultApplication.jl/blob/v1.1.0/src/DefaultApplication.jl#L18",
)
