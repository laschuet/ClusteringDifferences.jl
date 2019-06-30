"""
    sub(A::AbstractMatrix{Ta}, B::AbstractMatrix{Tb}) where {Ta<:Real, Tb<:Real}
    ⊟(A::AbstractMatrix{Ta}, B::AbstractMatrix{Tb}) where {Ta<:Real, Tb<:Real}

Subtract matrices of different dimensions.
"""
function sub(A::AbstractMatrix{Ta}, B::AbstractMatrix{Tb}) where {Ta<:Real, Tb<:Real}
    ax, ay = size(A)
    bx, by = size(B)
    x, y = max.(sza, szb)
    A2 = Matrix{Union{Ta, Nothing}}(nothing, x, y)
    B2 = Matrix{Union{Tb, Nothing}}(nothing, x, y)
    A2[1:ax, 1:ay] = A
    B2[1:bx, 1:by] = B

    return map((a, b) -> begin
        isnothing(a) && return b
        isnothing(b) && return a
        return a - b
    end, A2, B2)
end
const ⊟ = sub
