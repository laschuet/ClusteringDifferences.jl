abstract type Clustering end

"""
    PartitionalClustering{Tx<:Real,Tw<:Real,Ty<:Real,Tm<:Real} <: Clustering

Partitional clustering model.
"""
struct PartitionalClustering{Tx<:Real,Tw<:Real,Ty<:Real,Tm<:Real} <: Clustering
    X::AbstractMatrix{Tx}
    C::AbstractMatrix{Int}
    W::AbstractMatrix{Tw}
    Y::AbstractMatrix{Ty}
    M::AbstractMatrix{Tm}

    function PartitionalClustering{Tx,Tw,Ty,Tm}(X::AbstractMatrix{Tx},
                                                C::AbstractMatrix{Int},
                                                W::AbstractMatrix{Tw},
                                                Y::AbstractMatrix{Ty},
                                                M::AbstractMatrix{Tm}) where {Tx<:Real,Tw<:Real,Ty<:Real,Tm<:Real}
        size(X, 2) == size(Y, 2) ||
            throw(DimensionMismatch("number of data instances and number of data instances assigned must match"))
        size(C) == size(W) ||
            throw(DimensionMismatch("dimensions of constraints and weights matrices must match"))
        size(Y, 1) == size(M, 2) ||
            throw(DimensionMismatch("number of clusters must match"))
        return new(X, C, W, Y, M)
    end
end
PartitionalClustering(X::AbstractMatrix{Tx}, C::AbstractMatrix{Int},
                    W::AbstractMatrix{Tw}, Y::AbstractMatrix{Ty},
                    M::AbstractMatrix{Tm}) where {Tx,Tw,Ty,Tm} =
    PartitionalClustering{Tx,Tw,Ty,Tm}(X, C, W, Y, M)

# Partitional clustering equality operator
Base.:(==)(a::PartitionalClustering, b::PartitionalClustering) =
    a.X == b.X && a.C == b.C && a.W == b.W && a.Y == b.Y && a.M == b.M

# Compute hash code
Base.hash(a::PartitionalClustering, h::UInt) =
    hash(a.X, hash(a.C, hash(a.W, hash(a.Y, hash(a.M, hash(:PartitionalClustering, h))))))

"""
    HierarchicalClustering{Tx<:Real,Tw<:Real} <: Clustering

Hierarchical clustering model.
"""
struct HierarchicalClustering{Tx<:Real,Tw<:Real} <: Clustering
    X::AbstractMatrix{Tx}
    C::AbstractArray{Int, 3}
    W::AbstractArray{Tw, 3}

    function HierarchicalClustering{Tx,Tw}(X::AbstractMatrix{Tx},
                                        C::AbstractArray{Int, 3},
                                        W::AbstractArray{Tw, 3}) where {Tx<:Real,Tw<:Real}
        size(C) == size(W) ||
            throw(DimensionMismatch("dimensions of constraints and weights matrices must match"))
        return new(X, C, W)
    end
end
HierarchicalClustering(X::AbstractMatrix{Tx}, C::AbstractArray{Int, 3},
                    W::AbstractArray{Tw, 3}) where {Tx,Tw} =
    HierarchicalClustering{Tx,Tw}(X, C, W)

"""
    data(c::Clustering)

Access the data.
"""
data(c::Clustering) = c.X

"""
    constraints(c::Clustering)

Access the contraints.
"""
constraints(c::Clustering) = c.C

"""
    weights(c::Clustering)

Access the weights.
"""
weights(c::Clustering) = c.W

"""
    assignments(c::PartitionalClustering)

Access the assignments of the data instances to the clusters.
"""
assignments(c::PartitionalClustering) = c.Y

"""
    centers(c::PartitionalClustering)

Access the centers.
.
"""
centers(c::PartitionalClustering) = c.M

"""
    θ(c::PartitionalClustering)

Access the parameters.
"""
θ(c::PartitionalClustering) = (c.M)
