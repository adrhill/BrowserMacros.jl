# BrowserMacros.jl
## `v0.2.3`
* ![Maintenance][badge-maintenance] Simplified search engine code ([#14][pr-14])
* ![Feature][badge-feature] Added new search macros ([#14][pr-14])

    | Name           | Macro            | 
    |:---------------|:-----------------|
    | Baidu          | `@baidu`         |
    | Bing           | `@bing`          |
    | Brave          | `@brave`         |
    | Ecosia         | `@ecosia`        |
    | GitHub         | `@github`        |
    | Goodreads      | `@goodreads`     | 
    | Qwant          | `@qwant`         |
    | Stack Overflow | `@stackoverflow` |
    | Web Archive    | `@webarchive`    |
    | Wolfram Alpha  | `@wolframalpha`  |
    | Yahoo          | `@yahoo`         |
    | Yandex         | `@yandex`        |

## `v0.2.2`
* ![Feature][badge-feature] Added new search macros ([#13][pr-13])

    | Name            | Macro        | 
    |:----------------|:-------------|
    | arXiv           | `@arxiv`     |
    | JuliaHub        | `@juliahub`  |
    | Julia Discourse | `@discourse` |
    | Julia Zulip     | `@zulip`     |
    | Google Scholar  | `@scholar`   |
    | Wikipedia       | `@wikipedia` | 
    | YouTube         | `@youtube`   |

## `v0.2.1`
* ![Maintenance][badge-maintenance] Simplified search engine code

## `v0.2.0`
* ![BREAKING][badge-breaking] All keyword arguments now have to precede the expression / search query ([#9][pr-9])
* ![Feature][badge-feature] Added keyword arguments to customize `@issue` ([#10][pr-10])

## `v0.1.2`
* ![Feature][badge-feature] Added `@issue` macro for automatic issue drafting ([#8][pr-8])
* ![Feature][badge-feature] Return URL when calling macros ([#5][pr-5])
* ![Feature][badge-feature] Added option `open_browser=false` to return URL without opening browser ([#7][pr-7])

## `v0.1.1`
* ![Maintenance][badge-maintenance] Simplified code using `PkgId`

## `v0.1.0`
* Initial functionality

[pr-14]: https://github.com/adrhill/BrowserMacros.jl/pull/14
[pr-13]: https://github.com/adrhill/BrowserMacros.jl/pull/13
[pr-10]: https://github.com/adrhill/BrowserMacros.jl/pull/10
[pr-9]: https://github.com/adrhill/BrowserMacros.jl/pull/9
[pr-8]: https://github.com/adrhill/BrowserMacros.jl/pull/8
[pr-7]: https://github.com/adrhill/BrowserMacros.jl/pull/7
[pr-5]: https://github.com/adrhill/BrowserMacros.jl/pull/5

<!--
# Badges
![BREAKING][badge-breaking]
![Deprecation][badge-deprecation]
![Feature][badge-feature]
![Enhancement][badge-enhancement]
![Bugfix][badge-bugfix]
![Security][badge-security]
![Experimental][badge-experimental]
![Maintenance][badge-maintenance]
![Documentation][badge-docs]
-->

[badge-breaking]: https://img.shields.io/badge/BREAKING-red.svg
[badge-deprecation]: https://img.shields.io/badge/deprecation-orange.svg
[badge-feature]: https://img.shields.io/badge/feature-green.svg
[badge-enhancement]: https://img.shields.io/badge/enhancement-blue.svg
[badge-bugfix]: https://img.shields.io/badge/bugfix-purple.svg
[badge-security]: https://img.shields.io/badge/security-black.svg
[badge-experimental]: https://img.shields.io/badge/experimental-lightgrey.svg
[badge-maintenance]: https://img.shields.io/badge/maintenance-gray.svg
[badge-docs]: https://img.shields.io/badge/docs-orange.svg
