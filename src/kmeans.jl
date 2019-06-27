"""
    kmeans!(X::Matrix, k::Int[, niter::Int=1000])

Cluster the data instances `X` with the ``k``-means algorithm.
"""
function kmeans!(X::Matrix{<:Real}, M::Matrix{<:Real};
                maxiter::Int=256, dist::SemiMetric=SqEuclidean(), ϵ=1.0e-6)
    n, m = size(X)
    k, m2 = size(M)

    m == m2 || throw(DimensionMismatch("number of data features must match"))
    k > 1 || throw(ArgumentError("number of clusters must at least be 2"))
    k < n || throw(ArgumentError("more clusters than data instances are not allowed"))

    C = Matrix{Int}(undef, 0, 0)
    W = Matrix{Real}(undef, 0, 0)
    Y = zeros(Real, n, k)
    M = convert(Matrix{AbstractFloat}, M)

    DIST = pairwise(dist, X, M; dims=1)

    clusterings = Vector{PartitionalClustering}(undef, 0)
    pre_objcosts = 0
    i = 1
    while i <= maxiter
        # Update cluster assignments, objective function costs, and center
        # coordinates per cluster
        objcosts = 0
        fill!(M, zero(eltype(M)))
        @inbounds for j = 1:n
            cost, assignment = findmin(view(DIST, j, :))
            Y[j, assignment] = 1
            objcosts += cost
            M[assignment, :] += X[j, :]
        end

        # Update cluster centers
        for j = 1:k
            count = sum(Y[:, j])
            M[j, :] /= count
        end

        c = PartitionalClustering(X, C, W, Y, M)
        push!(clusterings, c)

        # Check for convergence
        if isapprox(objcosts, pre_objcosts; atol=ϵ)
            break
        end

        pre_objcosts = objcosts
        i += 1
    end

    return clusterings
end
