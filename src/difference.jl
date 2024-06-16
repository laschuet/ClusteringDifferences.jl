"""
    AbstractClusteringDifference

Supertype for clustering differences.
"""
abstract type AbstractClusteringDifference end

"""
    ClusteringDifference <: AbstractClusteringDifference

Difference between two clusterings.
"""
struct ClusteringDifference <: AbstractClusteringDifference
    r::SetDifference{Int}
    c::SetDifference{Int}
    C::MatrixDifference
    W::MatrixDifference
    Y::MatrixDifference
    p::NamedTupleDifference

    function ClusteringDifference(
        r::SetDifference{Int},
        c::SetDifference{Int},
        C::MatrixDifference,
        W::MatrixDifference,
        Y::MatrixDifference,
        p::NamedTupleDifference,
    )
        return new(r, c, C, W, Y, p)
    end
end

# Clustering difference equality operator
function Base.:(==)(a::ClusteringDifference, b::ClusteringDifference)
    (a.r == b.r && a.c == b.c && a.C == b.C && a.W == b.W && a.Y == b.Y && a.p == b.p)
end

# Compute hash code
function Base.hash(a::ClusteringDifference, h::UInt)
    hash(
        a.r, hash(a.c, hash(a.C, hash(a.W, hash(a.Y, hash(a.p, hash(:ClusteringDifference, h))))))
    )
end

"""
    axes(a::AbstractClusteringDifference[, d])

Access the feature and instance identifiers differences. Optionally, specify
dimension `d` to get the identifier difference of that dimension only.
"""
Base.axes(a::AbstractClusteringDifference) = a.r, a.c
Base.axes(a::AbstractClusteringDifference, d) = d::Integer <= 2 ? axes(a)[d] : Int[]

"""
    features(a::AbstractClusteringDifference)

Access the feature identifiers difference.
"""
features(a::AbstractClusteringDifference) = axes(a, 1)

"""
    instances(a::AbstractClusteringDifference)

Access the instance identifiers difference.
"""
Base.instances(a::AbstractClusteringDifference) = axes(a, 2)

"""
    constraints(a::AbstractClusteringDifference)

Access the contraints difference.
"""
constraints(a::AbstractClusteringDifference) = a.C

"""
    weights(a::AbstractClusteringDifference)

Access the weights difference.
"""
weights(a::AbstractClusteringDifference) = a.W

"""
    parameters(c::AbstractClusteringDifference)

Access the parameters difference.
"""
parameters(a::AbstractClusteringDifference) = a.p

"""
    assignments(a::ClusteringDifference)

Access the assignments difference.
"""
assignments(a::ClusteringDifference) = a.Y

# Clustering subtraction operator
function Base.:-(a::Clustering, b::Clustering)
    r = diff(Set(a.r), Set(b.r))
    c = diff(Set(a.c), Set(b.c))
    C = diff(a.C, b.C, a.c, a.c, b.c, b.c)
    W = diff(a.W, b.W, a.c, a.c, b.c, b.c)
    ayr = collect(1:size(a.Y, 1))
    byr = collect(1:size(b.Y, 1))
    Y = diff(a.Y, b.Y, ayr, a.c, byr, b.c)
    p = diff(a.p, b.p)
    return ClusteringDifference(r, c, C, W, Y, p)
end

"""
    forwarddiff(a::AbstractVector{<:AbstractClustering}, i::Int[, h::Int=1])

Compute the forward difference of the clustering at index `i` with step
size `h`.
"""
forwarddiff(a::AbstractVector{<:AbstractClustering}, i::Int, h::Int=1) = a[i + h] - a[i]

"""
    backwarddiff(a::AbstractVector{<:AbstractClustering}, i::Int[, h::Int=1])

Compute the backward difference of the clustering at index `i` with step
size `h`.
"""
backwarddiff(a::AbstractVector{<:AbstractClustering}, i::Int, h::Int=1) = a[i] - a[i - h]
