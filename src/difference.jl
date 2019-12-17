"""
    AbstractClusteringDifference

Supertype for clustering differences.
"""
abstract type AbstractClusteringDifference end

"""
    PartitionalClusteringDifference{Tx<:Real,Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real} <: AbstractClusteringDifference

Difference between two partitional clusterings.
"""
struct PartitionalClusteringDifference{Tx<:Real,Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real} <: AbstractClusteringDifference
    X::MatrixDifference{Tx}
    i::SetDifference{Int}
    j::SetDifference{Int}
    C::MatrixDifference{Tc}
    W::MatrixDifference{Tw}
    Y::MatrixDifference{Ty}
    M::MatrixDifference{Tm}
    m::Int
    n::Int
    k::Int

    function PartitionalClusteringDifference{Tx,Tc,Tw,Ty,Tm}(X::MatrixDifference{Tx},
                                                            i::SetDifference{Int},
                                                            j::SetDifference{Int},
                                                            C::MatrixDifference{Tc},
                                                            W::MatrixDifference{Tw},
                                                            Y::MatrixDifference{Ty},
                                                            M::MatrixDifference{Tm},
                                                            m::Integer,
                                                            n::Integer,
                                                            k::Integer) where {Tx<:Real,Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real}
        return new(X, i, j, C, W, Y, M, m, n, k)
    end
end
PartitionalClusteringDifference(X::MatrixDifference{Tx}, i::SetDifference{Int},
                                j::SetDifference{Int}, C::MatrixDifference{Tc},
                                W::MatrixDifference{Tw},
                                Y::MatrixDifference{Ty},
                                M::MatrixDifference{Tm}, m::Integer, n::Integer,
                                k::Integer) where {Tx,Tc,Tw,Ty,Tm} =
    PartitionalClusteringDifference{Tx,Tc,Tw,Ty,Tm}(X, i, j, C, W, Y, M, m, n, k)

function PartitionalClusteringDifference(X::MatrixDifference{Tx},
                                        C::MatrixDifference{Tc},
                                        W::MatrixDifference{Tw},
                                        Y::MatrixDifference{Ty},
                                        M::MatrixDifference{Tm},
                                        m::Integer, n::Integer, k::Integer) where {Tx,Tc,Tw,Ty,Tm}
    i = SetDifference(Int[], Int[], Int[])
    j = SetDifference(Int[], Int[], Int[])
    return PartitionalClusteringDifference(X, i, j, C, W, Y, M, m, n, k)
end

# Partitional clustering difference equality operator
==(a::PartitionalClusteringDifference, b::PartitionalClusteringDifference) =
    (a.X == b.X && a.i == b.i && a.j == b.j && a.C == b.C && a.W == b.W
            && a.Y == b.Y && a.M == b.M && a.m == b.m && a.n == b.n
            && a.k == b.k)

# Compute hash code
hash(a::PartitionalClusteringDifference, h::UInt) =
    hash(a.X, hash(a.i, hash(a.j, hash(a.C, hash(a.W, hash(a.Y, hash(a.M,
        hash(a.m, hash(a.n, hash(a.k,
            hash(:PartitionalClusteringDifference, h)))))))))))

# Partitional clustering subtraction operator
function -(a::PartitionalClustering, b::PartitionalClustering)
    X = MatrixDifference(diff(a.X, b.X, a.i, a.j, b.i, b.j)...)
    i = SetDifference(diff(collect(keys(a.i)), collect(keys(b.i)))...)
    j = SetDifference(diff(collect(keys(a.j)), collect(keys(b.j)))...)
    C = MatrixDifference(diff(a.C, b.C, a.j, a.j, b.j, b.j)...)
    W = MatrixDifference(diff(a.W, b.W, a.j, a.j, b.j, b.j)...)
    Y = MatrixDifference(diff(a.Y, b.Y, OrderedDict{Int,Int}(k => k for k = 1:size(a.Y, 1)), a.j, OrderedDict{Int,Int}(k => k for k = 1:size(b.Y, 1)), b.j)...)
    M = MatrixDifference(diff(a.M, b.M, a.i, OrderedDict{Int,Int}(k => k for k = 1:size(a.M, 2)), b.i, OrderedDict{Int,Int}(k => k for k = 1:size(b.M, 2)))...)
    m, n = size(a.X) .- size(b.X)
    k = size(a.M, 2) - size(b.M, 2)
    return PartitionalClusteringDifference(X, i, j, C, W, Y, M, m, n, k)
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
