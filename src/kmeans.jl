"""
    kmeans(X::AbstractMatrix{<:Real}, r::AbstractVector{Int},
        c::AbstractVector{Int}, μ::AbstractMatrix{<:Real}; <keyword arguments>)

Cluster the data `X` with the ``k``-means algorithm.

# Keyword arguments
- `maxiter::Int=256`: the number of maximum iterations.
- `dist::SemiMetric=SqEuclidean()`: the distance function.
- `ϵ::AbstractFloat=1.0e-6`: the absolute tolerance for convergence.
"""
function kmeans(
    X::AbstractMatrix{<:Real},
    r::AbstractVector{Int},
    c::AbstractVector{Int},
    μ::AbstractMatrix{<:Real};
    maxiter::Int=256,
    dist::SemiMetric=SqEuclidean(),
    ϵ::AbstractFloat=1.0e-6,
)
    mx, n = size(X)
    mμ, k = size(μ)

    mx == mμ || throw(DimensionMismatch("number of data features must match"))
    k > 1 || throw(ArgumentError("number of clusters must at least be 2"))
    k <= n || throw(ArgumentError("more clusters than data instances are not allowed"))

    C = Matrix{Int}(undef, 0, 0)
    W = Matrix{Float64}(undef, 0, 0)
    Y = zeros(Float64, k, n)
    μ2 = convert(Matrix{Float64}, μ)

    cs = Vector{Clustering}(undef, 0)

    distances = pairwise(dist, μ2, X; dims=2)
    pre_objcosts = 0
    objcosts = 0
    for i in 1:maxiter
        # Update cluster assignments, objective function costs, and cluster
        # centers (part 1/2)
        @inbounds for j in 1:n
            cost, y = findmin(view(distances, :, j))
            Y[y, j] = 1
            objcosts += cost
            μ2[:, y] += X[:, j]
        end

        # Update cluster centers (part 2/2)
        @inbounds for j in 1:k
            sz = sum(Y[j, :])
            μ2[:, j] = iszero(sz) ? μ[:, j] : μ2[:, j] / sz
        end

        pairwise!(dist, distances, dist, μ2, X; dims=2)

        c = Clustering(copy(r), copy(c), copy(C), copy(W), copy(Y), (μ=copy(μ2),))
        push!(cs, c)

        # Check for convergence
        isapprox(objcosts, pre_objcosts; atol=ϵ) && break

        fill!(Y, zero(eltype(Y)))
        fill!(μ2, zero(eltype(μ2)))

        pre_objcosts = objcosts
        objcosts = 0
    end

    return cs
end

"""
    kmeans(X::AbstractMatrix{<:Real}, μ::AbstractMatrix{<:Real}; <keyword arguments>)

Like [`kmeans`](@ref), but automatically generate `r` and `c` according to the
size of `X`.
"""
function kmeans(
    X::AbstractMatrix{<:Real},
    μ::AbstractMatrix{<:Real};
    maxiter::Int=256,
    dist::SemiMetric=SqEuclidean(),
    ϵ::AbstractFloat=1.0e-6,
)
    r = collect(1:size(X, 1))
    c = collect(1:size(X, 2))
    return kmeans(X, r, c, μ; maxiter=maxiter, dist=dist, ϵ=ϵ)
end
