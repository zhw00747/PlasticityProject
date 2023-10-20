import sympy as sp

# Define symbols
s1, s2, s3, m = sp.symbols("s1 s2 s3 m", real=True)


f = (1 / 2 * (sp.Abs(s1 - s2) ** m + sp.Abs(s2 - s3) ** m + sp.Abs(s3 - s1) ** m)) ** (
    1 / m
)


# Calculate the derivative with respect to x
df = sp.diff(f, s1)
df = sp.simplify(df)


u = (sp.Abs(s1 - s2)) ** m

du = sp.diff(u, s1)
# du = sp.simplify(du)
print(du)

y = sp.Abs(s1) ** m
