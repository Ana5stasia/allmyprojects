struct Residue{T,M}
    value::T
end

Residue{T,M}(val) where{T,M} = new(mod(val, M))
+(x::Residue, y::Residue) = Residue(x.value + y.value)
-(x::Residue, y::Residue) = Residue(x.value - y.value)
*(x::Residue, y::Residue) = Residue(x.value * y.value)
^(x::Residue, y::Integer) = Residue(x.value^y)
coefficients(p::Polynomial) = p.coeffs
struct ResiduePolynomial{T,M} <: AbstractPolynomial{T}
    coeffs::Vector{Residue{T,M}}
end

ResiduePolynomial{T,M}(p::Polynomial{T}) where{T,M} =
    ResiduePolynomial(Residue{T,M}.(p.coeffs))
Polynomial(p::ResiduePolynomial) = Polynomial(p.coeffs)
function gcdx(a, b)
    if b == 0
        return a, 1, 0
    end
    d, x1, y1 = gcdx(b, a % b)
    return d, y1, x1 - y1 * (a % b)
end
function invmod(a::Residue)
    d, x, y = gcdx(a.value, a.M)
    if d == 1
        return Residue(x)
    else
        return nothing
    end
end
function diaphant_solve(a::T, b::T, c::T) where T <: Integer
    d, x, y = gcdx(a, b)
    if c % d != 0
        return nothing
    end
    x = x * (c % d)
    y = y * (c % d)
    k = (c - a*x - b*y) % d
    return x + k*(b/d), y - k*(a/d)
end
function isprime(n::T) where T <: Integer
    if n < 2
        return false
    end
    if n % 2 == 0
        return n == 2
    end
    if n % 3 == 0
        return n == 3
    end
    d = 5
    while d*d <= n
        if n % d == 0
            return false
        end
        d = d + 2
        if n % d == 0
            return false
        end
        d = d + 4
    end
    return true
end
function primes(n::T) where T <: Integer
    if n < 2
        return []
    end
    sieve = BitArray(n+1)
    sieve[1] = true
    for p in 2:n
        if !sieve[p]
            for i in p:p:n
                sieve[i] = true
            end
        end
    end
    return filter(!, 2:n)
end
function factorize(n::T) where T <: Integer
    factors = []
    while n % 2 == 0
        push!(factors, (div=2, deg=1))
        n = n % 2
    end
    while n % 3 == 0
        push!(factors, (div=3, deg=1))
        n = n % 3
    end
    d = 5
    while d*d <= n
        if n % d == 0
            push!(factors, (div=d, deg=1))
            n = n % d
        end
        d = d + 2
        if n % d == 0
            push!(factors, (div=d, deg=1))
            n = n % d
        end
        d = d + 4
    end
    if n > 1
        push!(factors, (div=n, deg=1))
    end
    for i in 1:length(factors)-1
        if factors[i].div == factors[i+1].div
            factors[i].deg += 1
            deleteat!(factors, i+1)
            i -= 1
        end
    end
    return factors
end
