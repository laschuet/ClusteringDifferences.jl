abstract type Clustering end

"""
    PartitionalClustering{Tx<:Real,Tw<:Real,Tm<:Real} <: Clustering

Partitional clustering model.
"""
struct PartitionalClustering{Tx<:Real,Tw<:Real,Tm<:Real} <: Clustering
    X::Matrix{Tx}
    C::Matrix{Int}
    W::Matrix{Tw}
    Y::Vector{Int}
    M::Matrix{Tm}

    function PartitionalClustering{Tx,Tw,Tm}(X::Matrix{Tx}, C::Matrix{Int},
                                            W::Matrix{Tw}, Y::Vector{Int},
                                            M::Matrix{Tm}) where {Tx<:Real,Tw<:Real,Tm<:Real}
        size(X, 1) == length(Y) ||
            throw(DimensionMismatch("number of data instances and number of assignments must match"))
        size(C) == size(W) ||
            throw(DimensionMismatch("dimensions of constraints and weights matrices must match"))
        return new(X, C, W, Y, M)
    end
end
PartitionalClustering(X::Matrix{Tx}, C::Matrix{Int}, W::Matrix{Tw},
                    Y::Vector{Int}, M::Matrix{Tm}) where {Tx,Tw,Tm} =
    PartitionalClustering{Tx,Tw,Tm}(X, C, W, Y, M)

"""
    HierarchicalClustering{Tx<:Real,Tw<:Real} <: Clustering

Hierarchical clustering model.
"""
struct HierarchicalClustering{Tx<:Real,Tw<:Real} <: Clustering
    X::Matrix{Tx}
    C::Array{Int, 3}
    W::Array{Tw, 3}

    function HierarchicalClustering{Tx,Tw}(X::Matrix{Tx}, C::Array{Int, 3},
                                        W::Array{Tw, 3}) where {Tx<:Real,Tw<:Real}
        size(C) == size(W) ||
            throw(DimensionMismatch("dimensions of constraints and weights matrices must match"))
        return new(X, C, W)
    end
end
HierarchicalClustering(X::Matrix{Tx}, C::Array{Int, 3}, W::Array{Tw, 3}) where {Tx,Tw} =
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
