using BrowserMacros: get_google_url, get_ddg_url

# Load some modules to test wwwhich's URLs:
using Base: UUID # Julia Base
using DefaultApplication # GitHub

@test get_google_url("123!@#\$%^&*()_+QWERT{}|") ==
    "https://www.google.com/search?q=123%21%40%23%24%25%5E%26%2A%28%29_%2BQWERT%7B%7D%7C"
@test get_ddg_url("줄리아, جوليا") ==
    "https://duckduckgo.com/?q=%EC%A4%84%EB%A6%AC%EC%95%84%2C%20%D8%AC%D9%88%D9%84%D9%8A%D8%A7"
