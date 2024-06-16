#=
"""
    transitive_closure!(A::AbstractMatrix{Int})

Compute the transitive closure of the matrix `A`.
"""
function transitive_closure!(A::AbstractMatrix{Int})
    mustlinkto = findall(val -> val == 1, C)
    for instance in mustlinkto
        first = instance[1]
        second = instance[2]
        C[C[first, second] == && C[second, :]] == 1
    end
    return A
end

"""
"""
function pckmeans(X::AbstractMatrix{<:Real}, C::AbstractMatrix{Int},
                W::AbstractMatrix{<:Real}, k::Int;
                maxiter::Int=256, dist::SemiMetric=SqEuclidean(),
                ϵ::AbstractFloat=1.0e-6)
    pckmeans(X, C, W, M, maxiter=maxiter, dist=dist, ϵ=ϵ)
end

"""
    pckmeans(X::AbstractMatrix{<:Real}, C::AbstractMatrix{Int}, W::AbstractMatrix{<:Real}, M::AbstractMatrix{<:Real}; <keyword arguments>)

Cluster the data `X` with the pairwise constrained ``k``-means algorithm.

# Keyword arguments
- `maxiter::Int=256`: the number of maximum iterations.
- `dist::SemiMetric=SqEuclidean()`: the distance function.
- `ϵ::AbstractFloat=1.0e-6`: the absolute tolerance for convergence.
"""
function pckmeans(X::AbstractMatrix{<:Real}, C::AbstractMatrix{Int},
                W::AbstractMatrix{<:Real}, M::AbstractMatrix{<:Real};
                maxiter::Int=256, dist::SemiMetric=SqEuclidean(),
                ϵ::AbstractFloat=1.0e-6)
    mx, nx = size(X)
    nc = size(C, 2)
    nw = size(W, 2)
    mm, k = size(M)

    mx == mm || throw(DimensionMismatch("number of data features must match"))
    nc == nx || throw(DimensionMismatch("number of data instances and maximum number of constraints must match"))
    nc == nw || throw(DimensionMismatch("dimensions of constraints and weights must match"))
    k > 1 || throw(ArgumentError("number of clusters must at least be 2"))
    k <= nx || throw(ArgumentError("more clusters than data instances are not allowed"))

    n = nx
    Y = zeros(Float64, k, n)
    M = convert(Matrix{Float64}, M)

    cs = Vector{Clustering}(undef, 0)
    pc = Clustering(copy(X), copy(C), copy(W), copy(Y), copy(M))
    push!(pcs, pc)

    # Derive neighborhood sets, and initialize the cluster centers
    transitive_closure!(C)

    distances = pairwise(dist, M, X, dims=2)
    pre_objcosts = 0
    i = 1
    while i <= maxiter
        costs = distances
        objcosts = 0
        fill!(Y, zero(eltype(Y)))
        fill!(M, zero(eltype(M)))
        # Update cluster assignments, objective function costs, and center
        # coordinates per cluster
        @inbounds for j = 1:n
            cj = view(C, :, j)
            mustlinkto = findall(val -> val == 1, cj)
            for instance in mustlinkto
                y = argmax(view(Y, :, instance))
                costs[, j] += W[, ] * 1
            end
            cannotlink = findall(val -> val == -1, cj)

            cost, y = findmin(view(costs, :, j))
            Y[y, j] = 1
            objcosts += cost
            M[:, y] += X[:, j]
        end

        # Update cluster centers
        @inbounds for j = 1:k
            M[:, j] /= sum(Y[j, :])
        end

        pairwise!(distances, dist, M, X, dims=2)

        c = Clustering(X, C, W, Y, M)
        push!(cs, c)

        # Check for convergence
        isapprox(objcosts, pre_objcosts, atol=ϵ) && break

        pre_objcosts = objcosts
        i += 1
    end

    return cs
end
=#
