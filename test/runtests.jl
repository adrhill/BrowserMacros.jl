using BrowserMacros
using Test

@testset "BrowserMacros.jl" begin
    @testset "Test URLs" include("test_urls.jl")
end
