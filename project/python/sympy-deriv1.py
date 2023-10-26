import sympy as sp

# Define symbols


s11, s22, s33, s12, s23, s31 = sp.symbols("s11 s22 s33 s12 s23 s31", real=True)

s = sp.Matrix([[s11, s12, s31], [s12, s22, s23], [s31, s23, s33]])
sH = (s11 + s22 + s33) / 3
sHI = sp.Matrix([[sH, 0, 0], [0, sH, 0], [0, 0, sH]])
sD = s - sHI

J2 = 0
for i in range(3):
    for j in range(3):
        print(sD[i, j])
        J2 += sD[i, j] ** 2
J2 *= sp.Rational(1, 2)
J2 = sp.expand(J2)
J2 = sp.simplify(J2)

print("J2\n", J2, "\n")

J3 = sp.det(sD)
J3 = sp.simplify(J3)

print("J3\n", J3)

dJ3ds11 = sp.diff(J3, s11)
print("\ndJ3ds11\n", dJ3ds11)

dJ3ds22 = sp.diff(J3, s22)
print("\ndJ3ds22\n", dJ3ds22)

dJ3ds33 = sp.diff(J3, s33)
print("\ndJ3ds33\n", dJ3ds33)

dJ3ds12 = sp.diff(J3, s12)
print("\ndJ3ds12\n", dJ3ds12)

dJ3ds23 = sp.diff(J3, s23)
print("\ndJ3ds23\n", dJ3ds23)

dJ3ds31 = sp.diff(J3, s31)
print("\ndJ3ds31\n", dJ3ds31)
