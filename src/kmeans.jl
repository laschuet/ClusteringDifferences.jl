"""
    kmeans(X::AbstractMatrix{<:Real}, M::AbstractMatrix{<:Real}; <keyword arguments>)

Cluster the data instances `X` with the ``k``-means algorithm.

# Keyword arguments
- `maxiter::Int=256`: the number of maximum iterations.
- `dist::SemiMetric=SqEuclidean()`: the distance function.
- `ϵ::AbstractFloat=1.0e-6`: the absolute tolerance for convergence.
"""
function kmeans(X::AbstractMatrix{<:Real}, M::AbstractMatrix{<:Real};
                maxiter::Int=256, dist::SemiMetric=SqEuclidean(),
                ϵ::AbstractFloat=1.0e-6)
    mx, n = size(X)
    mm, k = size(M)

    mx == mm || throw(DimensionMismatch("number of data features must match"))
    k > 1 || throw(ArgumentError("number of clusters must at least be 2"))
    k <= n || throw(ArgumentError("more clusters than data instances are not allowed"))

    C = Matrix{Int}(undef, 0, 0)
    W = Matrix{Float64}(undef, 0, 0)
    Y = zeros(Float64, k, n)
    M = convert(Matrix{Float64}, M)

    cs = Vector{PartitionalClustering}(undef, 0)
    c = PartitionalClustering(copy(X), copy(C), copy(W), copy(Y), copy(M))
    push!(cs, c)

    distances = pairwise(dist, M, X, dims=2)
    pre_objcosts = 0
    i = 1
    while i <= maxiter
        objcosts = 0
        fill!(Y, zero(eltype(Y)))
        fill!(M, zero(eltype(M)))
        # Update cluster assignments, objective function costs, and center
        # coordinates per cluster
        @inbounds for j = 1:n
            cost, y = findmin(view(distances, :, j))
            Y[y, j] = 1
            objcosts += cost
            M[:, y] += X[:, j]
        end

        # Update cluster centers
        @inbounds for j = 1:k
            M[:, j] /= sum(Y[j, :])
        end

        pairwise!(distances, dist, M, X, dims=2)

        c = PartitionalClustering(copy(X), copy(C), copy(W), copy(Y), copy(M))
        push!(cs, c)

        # Check for convergence
        isapprox(objcosts, pre_objcosts, atol=ϵ) && break

        pre_objcosts = objcosts
        i += 1
    end

    return cs
end
