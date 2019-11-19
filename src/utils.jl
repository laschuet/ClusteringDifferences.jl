"""
    sub(A::AbstractMatrix{Ta}, B::AbstractMatrix{Tb}) where {Ta<:Real,Tb<:Real}

Subtract matrices of possibly different dimensions.
"""
function sub(A::AbstractMatrix{Ta}, B::AbstractMatrix{Tb}) where {Ta<:Real,Tb<:Real}
    sza = size(A)
    szb = size(B)
    sza == szb && return A - B
    m, n = max.(sza, szb)
    A2 = Matrix{Union{Nothing,Ta}}(nothing, m, n)
    B2 = Matrix{Union{Nothing,Tb}}(nothing, m, n)
    A2[1:sza[1], 1:sza[2]] = A
    B2[1:szb[1], 1:szb[2]] = B
    T = promote_type(eltype(Ta), eltype(Tb))
    R = Matrix{Union{Nothing,T}}(undef, m, n)
    map!((a, b) -> begin
        isnothing(a) && return b
        isnothing(b) && return a
        return a - b
    end, R, A2, B2)
    return R
end

"""
    diff(a::AbstractVector, b::AbstractVector)

Compute the difference between the vectors `a` and `b`.
"""
function diff(a::AbstractVector, b::AbstractVector)
    ab = union(a, b)
    removed = -1 * setdiff(ab, a)
    added = setdiff(ab, b)
    r = [removed; added]
    sort!(r, by=abs)
    return r
end

"""
    diff(A::AbstractMatrix, B::AbstractMatrix, ia::AbstractVector, ja::AbstractVector, ib::AbstractVector, jb::AbstractVector)

Compute the difference between the matrices `A` and `B`.
"""
function diff(A::AbstractMatrix, B::AbstractMatrix, ia::AbstractVector,
                ja::AbstractVector, ib::AbstractVector, jb::AbstractVector)
    sza = size(A)
    szb = size(B)
    i = union(ia, ib)
    j = union(ja, jb)
    m = maximum(i)
    n = maximum(j)
    A2 = Matrix{Union{Nothing,eltype(A)}}(nothing, m, n)
    B2 = Matrix{Union{Nothing,eltype(B)}}(nothing, m, n)
    A2[CartesianIndex.(Iterators.product(ia, ja))] = A
    B2[CartesianIndex.(Iterators.product(ib, jb))] = B
    T = promote_type(eltype(A), eltype(B))
    R = Matrix{Union{Nothing,T}}(undef, m, n)
    map!((a, b) -> begin
        isnothing(a) && return b
        isnothing(b) && return a
        return a - b
    end, R, A2, B2)
    return R
end
#diff(A::AbstractMatrix, B::AbstractMatrix) = diff(A, B, [], [], [], [])
