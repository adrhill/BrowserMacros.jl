using BrowserMacros
using Test

@testset "BrowserMacros.jl" begin
    @testset "Test URLs" begin
        include("test_urls.jl")
    end
end
