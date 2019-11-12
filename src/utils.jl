"""
    sub(A::Matrix{Ta}, B::Matrix{Tb}) where {Ta<:Real,Tb<:Real}
    ⊟(A::Matrix{Ta}, B::Matrix{Tb}) where {Ta<:Real,Tb<:Real}

Subtract matrices of possibly different dimensions.
"""
function sub(A::Matrix{Ta}, B::Matrix{Tb}) where {Ta<:Real,Tb<:Real}
    sza = size(A)
    szb = size(B)
    sza == szb && return A - B
    x, y = max.(sza, szb)
    A2 = Matrix{Union{Nothing,Ta}}(nothing, x, y)
    B2 = Matrix{Union{Nothing,Tb}}(nothing, x, y)
    A2[1:sza[1], 1:sza[2]] = A
    B2[1:szb[1], 1:szb[2]] = B
    T = promote_type(eltype(Ta), eltype(Tb))
    S = Matrix{Union{Nothing,T}}(undef, x, y)
    map!((a, b) -> begin
        isnothing(a) && return b
        isnothing(b) && return a
        return a - b
    end, S, A2, B2)
    return S
end

"""
    diff(a::Vector, b::Vector)

Compute the difference between the vectors `a` and `b`.
"""
function Base.diff(a::Vector, b::Vector)
    ab = union(a, b)
    removed = -1 * setdiff(ab, a)
    added = setdiff(ab, b)
    result = [removed; added]
    sort!(result, by=abs)
    return result
end

"""
    diff(A::Matrix, B::Matrix, ia::Vector, ja::Vector, ib::Vector, jb::Vector)

Compute the difference between the matrices `A` and `B`.
"""
function Base.diff(A::Matrix, B::Matrix, ia::Vector, ja::Vector, ib::Vector,
                jb::Vector)
    sza = size(A)
    szb = size(B)
    i = union(ia, ib)
    j = union(ja, jb)
    maxi = maximum(i)
    maxj = maximum(j)
    A2 = Matrix{Union{Missing,eltype(A)}}(missing, maxi, maxj)
    B2 = Matrix{Union{Missing,eltype(B)}}(missing, maxi, maxj)
    A2[CartesianIndex.(Iterators.product(ia, ja))] = A
    B2[CartesianIndex.(Iterators.product(ib, jb))] = B
    return A2 - B2
    #=
    T = promote_type(eltype(A), eltype(B))
    R = Matrix{Union{Missing,T}}(undef, maxi, maxj)
    map!((a, b) -> begin
        ismissing(a) && return b
        ismissing(b) && return a
        return a - b
    end, R, A2, B2)
    return R
    =#
end
#Base.diff(A::Matrix, B::Matrix) = diff(A, B, [], [], [], [])
