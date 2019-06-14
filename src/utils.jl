"""
    sub(a::Union{<:Real, Nothing}, b::Union{<:Real, Nothing})

Subtract real numbers allowing `nothing` values.
"""
function sub(a::Union{<:Real, Nothing}, b::Union{<:Real, Nothing})
    isnothing(a) && return b
    isnothing(b) && return a
    return a - b
end

"""
    sub(A::Matrix{Ta}, B::Matrix{Tb}) where {Ta<:Real, Tb<:Real}
    ⊟(A::Matrix{Ta}, B::Matrix{Tb}) where {Ta<:Real, Tb<:Real}

Subtract matrices of different dimensions.
"""
function sub(A::Matrix{Ta}, B::Matrix{Tb}) where {Ta<:Real, Tb<:Real}
    sza = size(A)
    szb = size(B)
    szmax = max.(sza, szb)
    A2 = Array{Union{Ta, Nothing}}(nothing, szmax[1], szmax[2])
    B2 = Array{Union{Tb, Nothing}}(nothing, szmax[1], szmax[2])
    A2[1:sza[1], 1:sza[2]] = A
    B2[1:szb[1], 1:szb[2]] = B

    return map(sub, A2, B2)
end
const ⊟ = sub
