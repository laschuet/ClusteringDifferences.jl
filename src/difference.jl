"""
    AbstractClusteringDifference

Supertype for clustering differences.
"""
abstract type AbstractClusteringDifference end

"""
    PartitionalClusteringDifference <: AbstractClusteringDifference

Difference between two partitional clusterings.
"""
struct PartitionalClusteringDifference <: AbstractClusteringDifference
    r::SetDifference{Int}
    c::SetDifference{Int}
    C::MatrixDifference
    W::MatrixDifference
    Y::MatrixDifference
    p::NamedTupleDifference

    function PartitionalClusteringDifference(r::SetDifference{Int},
                                            c::SetDifference{Int},
                                            C::MatrixDifference,
                                            W::MatrixDifference,
                                            Y::MatrixDifference,
                                            p::NamedTupleDifference)
        return new(r, c, C, W, Y, p)
    end
end

# Partitional clustering difference equality operator
Base.:(==)(a::PartitionalClusteringDifference, b::PartitionalClusteringDifference) =
    (a.r == b.r && a.c == b.c && a.C == b.C && a.W == b.W && a.Y == b.Y
            && a.p == b.p)

# Compute hash code
Base.hash(a::PartitionalClusteringDifference, h::UInt) =
    hash(a.r, hash(a.c, hash(a.C, hash(a.W, hash(a.Y, hash(a.p,
        hash(:PartitionalClusteringDifference, h)))))))

"""
    instances(a::AbstractClusteringDifference)

Access the instance indices.
"""
Base.instances(a::AbstractClusteringDifference) = a.c

"""
    features(a::AbstractClusteringDifference)

Access the feature indices.
"""
features(a::AbstractClusteringDifference) = a.r

"""
    constraints(a::AbstractClusteringDifference)

Access the contraints.
"""
constraints(a::AbstractClusteringDifference) = a.C

"""
    weights(a::AbstractClusteringDifference)

Access the weights.
"""
weights(a::AbstractClusteringDifference) = a.W

"""
    parameters(c::AbstractClusteringDifference)

Access the parameters.
"""
parameters(a::AbstractClusteringDifference) = a.p

"""
    assignments(a::PartitionalClusteringDifference)

Access the assignments of the data instances to the clusters.
"""
assignments(a::PartitionalClusteringDifference) = a.Y

# Partitional clustering subtraction operator
function Base.:-(a::PartitionalClustering, b::PartitionalClustering)
    r = diff(Set(a.r), Set(b.r))
    c = diff(Set(a.c), Set(b.c))
    C = diff(a.C, b.C, a.c, a.c, b.c, b.c)
    W = diff(a.W, b.W, a.c, a.c, b.c, b.c)
    ayr = collect(1:size(a.Y, 1))
    byr = collect(1:size(b.Y, 1))
    Y = diff(a.Y, b.Y, ayr, a.c, byr, b.c)
    p = diff(a.p, b.p)
    return PartitionalClusteringDifference(r, c, C, W, Y, p)
end

"""
    forwarddiff(a::AbstractVector{<:AbstractClustering}, i::Int[, h::Int=1])

Compute the forward difference of the clustering at index `i` with step
size `h`.
"""
forwarddiff(a::AbstractVector{<:AbstractClustering}, i::Int, h::Int=1) =
    a[i + h] - a[i]

"""
    backwarddiff(a::AbstractVector{<:AbstractClustering}, i::Int[, h::Int=1])

Compute the backward difference of the clustering at index `i` with step
size `h`.
"""
backwarddiff(a::AbstractVector{<:AbstractClustering}, i::Int, h::Int=1) =
    a[i] - a[i - h]
