using BrowserMacros
using URIs: URI

# Load some modules to test wwwhich's URLs:
using InteractiveUtils: @which
using DefaultApplication

open_browser = 42 # For macro hygiene test at end of file

url_google = URI(
    "https://www.google.com/search?q=123%21%40%23%24%25%5E%26%2A%28%29_%2BQWERT%7B%7D%7C"
)
url = @google open_browser = false "123!@#\$%^&*()_+QWERT{}|"
@test url == url_google

url_ddg = URI(
    "https://duckduckgo.com/?q=%EC%A4%84%EB%A6%AC%EC%95%84%2C%20%D8%AC%D9%88%D9%84%D9%8A%D8%A7",
)
url = @ddg open_browser = false "줄리아, جوليا"
@test url == url_ddg

# Base
m = @which sqrt(1.0)
url1 = @inferred method_url(m)
@test !isnothing(url1)
url2 = @wwwhich open_browser = false sqrt(1.0)
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

# Test @issue
url = @issue text = "test" open_browser = false status = false versioninfo = false footer =
    false sqrt(5)
@test url == URI("https://github.com/JuliaLang/julia/issues/new?body=test%0A")

@test open_browser == 42 # Test macro hygiene
