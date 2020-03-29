"""
    kmeans(X::AbstractMatrix{<:Real}, r::AbstractVector{Int},
        c::AbstractVector{Int}, M::AbstractMatrix{<:Real}; <keyword arguments>)

Cluster the data `X` with the ``k``-means algorithm.

# Keyword arguments
- `maxiter::Int=256`: the number of maximum iterations.
- `dist::SemiMetric=SqEuclidean()`: the distance function.
- `ϵ::AbstractFloat=1.0e-6`: the absolute tolerance for convergence.
"""
function kmeans(X::AbstractMatrix{<:Real}, r::AbstractVector{Int},
                c::AbstractVector{Int}, M::AbstractMatrix{<:Real};
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
    M2 = convert(Matrix{Float64}, M)

    pcs = Vector{PartitionalClustering}(undef, 0)
    pc = PartitionalClustering(copy(X), copy(r), copy(c), copy(C), copy(W),
            copy(Y), copy(M2))
    push!(pcs, pc)

    distances = pairwise(dist, M2, X, dims=2)
    pre_objcosts = 0
    i = 1
    while i <= maxiter
        objcosts = 0
        fill!(Y, zero(eltype(Y)))
        fill!(M2, zero(eltype(M2)))

        # Update cluster assignments, objective function costs, and cluster
        # centers (part 1/2)
        @inbounds for j = 1:n
            cost, y = findmin(view(distances, :, j))
            Y[y, j] = 1
            objcosts += cost
            M2[:, y] += X[:, j]
        end

        # Update cluster centers (part 2/2)
        @inbounds for j = 1:k
            sz = sum(Y[j, :])
            M2[:, j] = iszero(sz) ? M[:, j] : M2[:, j] / sz
        end

        pairwise!(distances, dist, M2, X, dims=2)

        pc = PartitionalClustering(copy(X), copy(r), copy(c), copy(C), copy(W),
                copy(Y), copy(M2))
        push!(pcs, pc)

        # Check for convergence
        isapprox(objcosts, pre_objcosts, atol=ϵ) && break

        pre_objcosts = objcosts
        i += 1
    end

    return pcs
end

"""
    kmeans(X::AbstractMatrix{<:Real}, M::AbstractMatrix{<:Real}; <keyword arguments>)

Like [`kmeans`](@ref), but automatically generate `r` and `c` according to the
size of `X`.
"""
function kmeans(X::AbstractMatrix{<:Real}, M::AbstractMatrix{<:Real};
                maxiter::Int=256, dist::SemiMetric=SqEuclidean(),
                ϵ::AbstractFloat=1.0e-6)
    r = collect(1:size(X, 1))
    c = collect(1:size(X, 2))
    return kmeans(X, r, c, M, maxiter=maxiter, dist=dist, ϵ=ϵ)
end
