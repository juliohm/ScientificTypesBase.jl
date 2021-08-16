struct MockMLJ <: Convention end

@testset "convention" begin
    set_convention(ScientificTypesBase.NoConvention())
    c = ""
    @test_logs (:warn, "No convention specified. Did you forget to use the `set_convention` function?") (c = ST.convention())
    @test c isa ST.NoConvention

    set_convention(MockMLJ())
    c = ST.convention()
    @test c isa MockMLJ
end

function ST.trait(X)
    Tables.istable(X) && return :table
    return :other
end

@testset "trait" begin
    X = [1,2,3]
    @test ST.trait(X) == :other
    X = (x = [1,2,3],
         y = [5,5,7])
    @test ST.trait(X) == :table
end

@testset "nonmissing" begin
    U = Union{Missing,Int}
    @test nonmissing(U) == Int
end

@testset "table" begin
    T0 = Table(Continuous)
    @test T0 == Table{K} where K<:AbstractVector{<:Continuous}
    T1 = Table(Continuous, Count)
    @test T1 == Table{K} where K<:Union{AbstractVector{<:Continuous}, AbstractVector{<:Count}}
    T2 = Table(Continuous, Union{Missing,Continuous})
    @test T2 == Table{K} where K<:Union{AbstractVector{<:Union{Missing,Continuous}}}
end
