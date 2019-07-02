"""
    sub(A::AbstractMatrix{Ta}, B::AbstractMatrix{Tb}) where {Ta<:Real, Tb<:Real}
    ⊟(A::AbstractMatrix{Ta}, B::AbstractMatrix{Tb}) where {Ta<:Real, Tb<:Real}

Subtract matrices of different dimensions.
"""
function sub(A::AbstractMatrix{Ta}, B::AbstractMatrix{Tb}) where {Ta<:Real, Tb<:Real}
    sza = size(A)
    szb = size(B)
    x, y = max.(sza, szb)

    A2 = Matrix{Union{Ta, Nothing}}(nothing, x, y)
    B2 = Matrix{Union{Tb, Nothing}}(nothing, x, y)
    A2[1:sza[1], 1:sza[2]] = A
    B2[1:szb[1], 1:szb[2]] = B

    return map((a, b) -> begin
        isnothing(a) && return b
        isnothing(b) && return a
        return a - b
    end, A2, B2)
end
const ⊟ = sub
