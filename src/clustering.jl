"""
    AbstractClustering

Supertype for clusterings.
"""
abstract type AbstractClustering end

"""
    PartitionalClustering{Tx<:Real,Ti<:Integer,Tj<:Integer,Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real} <: AbstractClustering

Partitional clustering.
"""
struct PartitionalClustering{Tx<:Real,Ti<:Integer,Tj<:Integer,Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real} <: AbstractClustering
    X::Matrix{Tx}
    i::IdDict{Ti}
    j::IdDict{Tj}
    C::Matrix{Tc}
    W::Matrix{Tw}
    Y::Matrix{Ty}
    M::Matrix{Tm}

    function PartitionalClustering{Tx,Ti,Tj,Tc,Tw,Ty,Tm}(X::Matrix{Tx},
                                                        i::IdDict{Ti},
                                                        j::IdDict{Tj},
                                                        C::Matrix{Tc},
                                                        W::Matrix{Tw},
                                                        Y::Matrix{Ty},
                                                        M::Matrix{Tm}) where {Tx<:Real,Ti<:Integer,Tj<:Integer,
                                                                            Tc<:Integer,Tw<:Real,Ty<:Real,
                                                                            Tm<:Real}
        mx, nx = size(X)
        nc = size(C, 2)
        nw = size(W, 2)
        ky, ny = size(Y)
        mm, km = size(M)
        if nx > 0
            nx == ny || throw(DimensionMismatch("number of data instances must match"))
        end
        if mx > 0
            mx == mm || throw(DimensionMismatch("number of data features must match"))
        end
        if nc > 0 && nx > 0
            nc == nx || throw(DimensionMismatch("number of data instances and maximum number of constraints must match"))
        end
        nc == nw || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        ky == km || throw(DimensionMismatch("number of clusters must match"))
        return new(X, i, j, C, W, Y, M)
    end
end
PartitionalClustering(X::Matrix{Tx}, i::IdDict{Ti}, j::IdDict{Tj},
                    C::Matrix{Tc}, W::Matrix{Tw}, Y::Matrix{Ty}, M::Matrix{Tm}) where {Tx,Ti,Tj,Tc,Tw,Ty,Tm} =
    PartitionalClustering{Tx,Ti,Tj,Tc,Tw,Ty,Tm}(X, i, j, C, W, Y, M)

function PartitionalClustering(X::Matrix{Tx}, C::Matrix{Tc}, W::Matrix{Tw},
                            Y::Matrix{Ty}, M::Matrix{Tm}) where {Tx,Tc,Tw,Ty,Tm}
    szi, szj = size(X)
    i = IdDict(i => i for i = 1:szi)
    j = IdDict(j => j for j = 1:szj)
    return PartitionalClustering(X, i, j, C, W, Y, M)
end

# Partitional clustering equality operator
==(a::PartitionalClustering, b::PartitionalClustering) =
    (a.X == b.X && a.i == b.i && a.j == b.j && a.C == b.C && a.W == b.W
            && a.Y == b.Y && a.M == b.M)

# Compute hash code
hash(a::PartitionalClustering, h::UInt) =
    hash(a.X, hash(a.i, hash(a.j, hash(a.C, hash(a.W, hash(a.Y, hash(a.M,
        hash(:PartitionalClustering, h))))))))

"""
    HierarchicalClustering{Tx<:Real,Ti<:Integer,Tj<:Integer,Tc<:Integer,Tw<:Real} <: AbstractClustering

Hierarchical clustering.
"""
struct HierarchicalClustering{Tx<:Real,Ti<:Integer,Tj<:Integer,Tc<:Integer,Tw<:Real} <: AbstractClustering
    X::Matrix{Tx}
    i::IdDict{Ti}
    j::IdDict{Tj}
    C::Array{Tc,3}
    W::Array{Tw,3}

    function HierarchicalClustering{Tx,Ti,Tj,Tc,Tw}(X::Matrix{Tx},
                                                    i::IdDict{Ti},
                                                    j::IdDict{Tj},
                                                    C::Array{Tc,3},
                                                    W::Array{Tw,3}) where {Tx<:Real,Ti<:Integer,Tj<:Integer,Tc<:Integer,
                                                                        Tw<:Real}
        mx, nx = size(X)
        nc = size(C, 2)
        nw = size(W, 2)
        nc == nw || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        if nc > 0 && nx > 0
            nc == nx || throw(DimensionMismatch("number of data instances and maximum number of constraints must match"))
        end
        return new(X, i, j, C, W)
    end
end
HierarchicalClustering(X::Matrix{Tx}, i::IdDict{Ti}, j::IdDict{Tj},
                    C::Array{Tc,3}, W::Array{Tw,3}) where {Tx,Ti,Tj,Tc,Tw} =
    HierarchicalClustering{Tx,Ti,Tj,Tc,Tw}(X, i, j, C, W)

function HierarchicalClustering(X::Matrix{Tx}, C::Array{Tc,3}, W::Array{Tw,3}) where {Tx,Tc,Tw}
    szi, szj = size(X)
    i = IdDict(i => i for i = 1:szi)
    j = IdDict(j => j for j = 1:szj)
    return HierarchicalClustering(X, i, j, C, W)
end

"""
    data(a::AbstractClustering)

Access the data.
"""
data(a::AbstractClustering) = a.X

"""
    instances(a::AbstractClustering)

Access the instance indices.
"""
instances(a::AbstractClustering) = a.j

"""
    features(a::AbstractClustering)

Access the feature indices.
"""
features(a::AbstractClustering) = a.i

"""
    constraints(a::AbstractClustering)

Access the contraints.
"""
constraints(a::AbstractClustering) = a.C

"""
    weights(a::AbstractClustering)

Access the weights.
"""
weights(a::AbstractClustering) = a.W

"""
    assignments(a::PartitionalClustering)

Access the assignments of the data instances to the clusters.
"""
assignments(a::PartitionalClustering) = a.Y

"""
    centers(a::PartitionalClustering)

Access the centers.
"""
centers(a::PartitionalClustering) = a.M

"""
    θ(c::PartitionalClustering)

Access the parameters.
"""
θ(a::PartitionalClustering) = (a.M)
