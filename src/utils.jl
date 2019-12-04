"""
    MatrixDifference{T<:Real}

Matrix difference.
"""
struct MatrixDifference{T<:Real}
    M::SparseMatrixCSC{T}
    A::SparseMatrixCSC{T}
    R::SparseMatrixCSC{T}
end

"""
    modified(a::MatrixDifference)

Access the modified elements.
"""
modified(a::MatrixDifference) = a.M

"""
    added(a::MatrixDifference)

Access the added elements.
"""
added(a::MatrixDifference) = a.A

"""
    removed(a::MatrixDifference)

Access the removed elements.
"""
removed(a::MatrixDifference) = a.R

"""
    setchange(a::AbstractVector, b::AbstractVector)

Compute the difference between the vectors `a` and `b`, and return a tuple
containing the unique elements added and removed.

# Examples
```jldoctest
julia> setchange([1, 2, 3, 3], [4, 2, 1])
([4], [3])
```
"""
setchange(a::AbstractVector, b::AbstractVector) = setdiff(b, a), setdiff(a, b)

"""
    change(A::AbstractMatrix, B::AbstractMatrix, ia::AbstractDict, ja::AbstractDict, ib::AbstractDict, jb::AbstractDict)

Compute the difference between the matrices `A` and `B`.
"""
function change(A::AbstractMatrix, B::AbstractMatrix, ia::AbstractDict,
                ja::AbstractDict, ib::AbstractDict, jb::AbstractDict)
    iakeys = collect(keys(ia))
    jakeys = collect(keys(ja))
    ibkeys = collect(keys(ib))
    jbkeys = collect(keys(jb))
    T = promote_type(eltype(A), eltype(B))

    # Compute modified values
    modified = sparse([], [], T[])
    imod = intersect(iakeys, ibkeys)
    jmod = intersect(jakeys, jbkeys)
    println("imod $imod")
    println("jmod $jmod")
    if length(imod) > 0 && length(jmod) > 0
        ia2 = similar(imod)
        ja2 = similar(jmod)
        ib2 = similar(imod)
        jb2 = similar(jmod)
        @inbounds for k = 1:length(imod)
            ia2[k] = ia[imod[k]]
            ib2[k] = ib[imod[k]]
        end
        @inbounds for k = 1:length(jmod)
            ja2[k] = ja[jmod[k]]
            jb2[k] = jb[jmod[k]]
        end
        println("ia2 $ia2")
        println("ja2 $ja2")
        println("ib2 $ib2")
        println("jb2 $jb2")
        # TODO check if indsa, indsb are correct, or if there is another way
        # to use it in the views
        indsa = CartesianIndex.(Iterators.product(sort!(ia2), sort!(ja2)))
        indsb = CartesianIndex.(Iterators.product(sort!(ib2), sort!(jb2)))
        println("indsa $indsa")
        println("indsb $indsb")
        modified = sparse(view(A, indsa) - view(B, indsb))
    end

    # Compute added values
    added = sparse([], [], T[])
    iadd = setdiff(ibkeys, iakeys)
    jadd = setdiff(jbkeys, jakeys)
    if length(iadd) > 0 && length(jadd) <= 0
        ib2 = similar(iadd)
        @inbounds for k = 1:length(iadd)
            ib2 = ib[iadd[k]]
        end
        added = sparse(view(B, ib2, :))
    end
    if length(iadd) <= 0 && length(jadd) > 0
        jb2 = similar(jadd)
        @inbounds for k = 1:length(jadd)
            jb2 = jb[jadd[k]]
        end
        added = sparse(view(B, :, jb2))
    end
    if length(iadd) > 0 && length(jadd) > 0
        ib2 = similar(iadd)
        @inbounds for k = 1:length(iadd)
            ib2 = ib[iadd[k]]
        end
        jb2 = similar(jadd)
        @inbounds for k = 1:length(jadd)
            jb2 = jb[jadd[k]]
        end
        indsi = CartesianIndex.(Iterators.product(ib2, 1:size(B, 2)))
        indsj = CartesianIndex.(Iterators.product(1:size(B, 1), jb2))
        append!(indsi, indsj)
        unique!(indsi)
        modified = sparse(view(B, indsi))
    end

    # Compute removed values
    removed = sparse([], [], T[])
    irem = setdiff(iakeys, ibkeys)
    jrem = setdiff(jakeys, jbkeys)
    if length(irem) > 0 && length(jrem) <= 0
        ia2 = similar(irem)
        @inbounds for k = 1:length(irem)
            ia2 = ia[irem[k]]
        end
        added = sparse(view(A, ia2, :))
    end
    if length(irem) <= 0 && length(jrem) > 0
        ja2 = similar(jrem)
        @inbounds for k = 1:length(jadd)
            ja2 = ja[jrem[k]]
        end
        added = sparse(view(A, :, ja2))
    end
    if length(irem) > 0 && length(jrem) > 0
        ia2 = similar(irem)
        @inbounds for k = 1:length(irem)
            ia2 = ia[irem[k]]
        end
        ja2 = similar(jrem)
        @inbounds for k = 1:length(jrem)
            ja2 = ja[jrem[k]]
        end
        indsi = CartesianIndex.(Iterators.product(ia2, 1:size(A, 2)))
        indsj = CartesianIndex.(Iterators.product(1:size(A, 1), ja2))
        append!(indsi, indsj)
        unique!(indsi)
        modified = sparse(view(A, indsi))
    end

    return modified, added, removed
end
#diff(A::AbstractMatrix, B::AbstractMatrix) = diff(A, B, [], [], [], [])
