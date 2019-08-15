"""
    pckmeans(X::AbstractMatrix{<:Real}, C::AbstractMatrix{Int}, W::AbstractMatrix{<:Real}, M::AbstractMatrix{<:Real}; <keyword arguments>)

Cluster the data `X` with the pairwise constrained ``k``-means algorithm.

# Keyword arguments
- `maxiter::Int=256`: the number of maximum iterations.
- `dist::SemiMetric=SqEuclidean()`: the distance function.
- `ϵ::AbstractFloat=1.0e-6`: the absolute tolerance for convergence.
"""
#=
function pckmeans(X::AbstractMatrix{<:Real}, C::AbstractMatrix{Int},
                W::AbstractMatrix{<:Real}, M::AbstractMatrix{<:Real};
                maxiter::Int=256, dist::SemiMetric=SqEuclidean(),
                ϵ::AbstractFloat=1.0e-6)
    m, n = size(X)
    m2, k = size(M)

    m == m2 || throw(DimensionMismatch("number of data features must match"))
    k > 1 || throw(ArgumentError("number of clusters must at least be 2"))
    k < n || throw(ArgumentError("more clusters than data instances are not allowed"))

    Y = zeros(Real, k, n)
    M = convert(Matrix{AbstractFloat}, M)

    # TODO derive neighborhood sets, and finish the initialization

    DIST = pairwise(dist, M, X, dims=2)

    cs = Vector{PartitionalClustering}(undef, 0)
    pre_objcosts = 0
    i = 1
    while i <= maxiter
        # Update cluster assignments, objective function costs, and center
        # coordinates per cluster
        objcosts = 0
        fill!(M, zero(eltype(M)))
        @inbounds for j = 1:n
            # Distance-based costs
            cost = minimum(view(DIST, :, j))
            # TODO add costs for violating must-link constraints
            # TODO add costs for violating cannot-link constraints
            # TODO finish assignment
        end

        # Update cluster centers
        @inbounds for j = 1:k
            M[:, j] /= sum(Y[j, :])
        end

        pairwise!(DIST, dist, M, X, dims=2)

        c = PartitionalClustering(X, C, W, Y, M)
        push!(cs, c)

        # Check for convergence
        if isapprox(objcosts, pre_objcosts, atol=ϵ)
            break
        end

        pre_objcosts = objcosts
        i += 1
    end

    return cs
end
=#
