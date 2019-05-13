abstract type ClusteringDifference end

"""
    PartitionalClusteringDifference

Difference between two partitional clustering models.
"""
struct PartitionalClusteringDifference <: ClusteringDifference
    size::Tuple{Int64, Int64}
    X::Array{Any, 2}
    #C::Array{Int, 2}
    #W::Array{Float64, 2}
    Y::Array{Int, 1}
    μ::Array{Any, 1}
end

function Base.:-(a::PartitionalClustering, b::PartitionalClustering)
    # TODO: Avoid assumption that sizes are equal
    sz = size(a.X) .- size(b.X)
    X = a.X - b.X
    #C = a.C - b.C
    #W = a.W - b.W
    Y = a.Y - b.Y
    μ = a.μ - b.μ
    return PartitionalClusteringDifference(sz, X, Y, μ)
end

function Base.show(io::IO, pcd::PartitionalClusteringDifference)
    print(io, "")
end
