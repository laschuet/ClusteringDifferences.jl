abstract type Clustering end

"""
    PartitionalClustering{Tx<:Real,Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real} <: Clustering

Partitional clustering model.
"""
struct PartitionalClustering{Tx<:Real,Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real} <: Clustering
    X::Matrix{Tx}
    C::Matrix{Tc}
    W::Matrix{Tw}
    Y::Matrix{Ty}
    M::Matrix{Tm}

    function PartitionalClustering{Tx,Tc,Tw,Ty,Tm}(X::Matrix{Tx}, C::Matrix{Tc},
                                                W::Matrix{Tw}, Y::Matrix{Ty},
                                                M::Matrix{Tm}) where {Tx<:Real, Tc<:Integer, Tw<:Real, Ty<:Real, Tm<:Real}
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
        nc == nw || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        if nc > 0 && nx > 0
            nc == nx || throw(DimensionMismatch("number of data instances and maximum number of constraints must match"))
        end
        ky == km || throw(DimensionMismatch("number of clusters must match"))
        return new(X, C, W, Y, M)
    end
end
PartitionalClustering(X::Matrix{Tx}, C::Matrix{Tc}, W::Matrix{Tw},
                    Y::Matrix{Ty}, M::Matrix{Tm}) where {Tx,Tc,Tw,Ty,Tm} =
    PartitionalClustering{Tx,Tc,Tw,Ty,Tm}(X, C, W, Y, M)

# Partitional clustering model equality operator
Base.:(==)(a::PartitionalClustering, b::PartitionalClustering) =
    a.X == b.X && a.C == b.C && a.W == b.W && a.Y == b.Y && a.M == b.M

# Compute hash code
Base.hash(a::PartitionalClustering, h::UInt) =
    hash(a.X, hash(a.C, hash(a.W, hash(a.Y, hash(a.M,
        hash(:PartitionalClustering, h))))))

"""
    HierarchicalClustering{Tx<:Real,Tc<:Integer,Tw<:Real} <: Clustering

Hierarchical clustering model.
"""
struct HierarchicalClustering{Tx<:Real,Tc<:Integer,Tw<:Real} <: Clustering
    X::Matrix{Tx}
    C::Array{Tc,3}
    W::Array{Tw,3}

    function HierarchicalClustering{Tx,Tc,Tw}(X::Matrix{Tx}, C::Array{Tc,3},
                                        W::Array{Tw,3}) where {Tx<:Real,Tc<:Integer,Tw<:Real}
        mx, nx = size(X)
        nc = size(C, 2)
        nw = size(W, 2)
        nc == nw || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        if nc > 0 && nx > 0
            nc == nx || throw(DimensionMismatch("number of data instances and maximum number of constraints must match"))
        end
        return new(X, C, W)
    end
end
HierarchicalClustering(X::Matrix{Tx}, C::Array{Tc,3}, W::Array{Tw,3}) where {Tx,Tc,Tw} =
    HierarchicalClustering{Tx,Tc,Tw}(X, C, W)

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
"""
centers(c::PartitionalClustering) = c.M

"""
    θ(c::PartitionalClustering)

Access the parameters.
"""
θ(c::PartitionalClustering) = (c.M)
