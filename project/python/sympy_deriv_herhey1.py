import sympy as sp

# Define symbols
s1, s2, s3, m, u = sp.symbols("s1 s2 s3 m u", real=True)

uu = (s1 - s2) ** m + (s2 - s3) ** m + (s3 - s1) ** m

f = (sp.Rational(1, 2) * u) ** (1 / m)

dfdu = sp.diff(f, u)
print("dfdu\n", dfdu)

# Calculate the derivative with respect to x
duds1 = sp.diff(uu, s1)
print("duds1\n", duds1)
