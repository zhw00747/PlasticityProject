import sympy as sp

# Define symbols
# fmt: off




s11, s22, s33, s12,s23,s31, m = sp.symbols("s11 s22 s33 s12 s23 s31 m", real=True)


sH = (s11+s22+s33)/3

S = sp.Matrix([[s11,s12,s31],
               [s12,s22,s23],
               [s31,s23,s33]])

Sdev = S = sp.Matrix([[s11-sH,s12,s31],
                      [s12,s22-sH,s23],
                      [s31,s23,s33-sH]])

J2=0
for i in range(3):
    for j in range(2):
        J2+= sp.Rational(1,2)* Sdev[i,j]**2

J3 = sp.Determinant(S)
J3 = sp.det(S)

thetaL = sp.Rational(1,3)*sp.acos(sp.sqrt(3)*sp.Rational(3,2)*J3/J2**(sp.Rational(3,2)))

s1 = sH + 2/sp.sqrt(3)*sp.sqrt(J2)*sp.cos(thetaL)
s2 = sH + 2/sp.sqrt(3)*sp.sqrt(J2)*sp.cos(sp.Rational(2,3)*sp.pi - thetaL)
s3 = sH + 2/sp.sqrt(3)*sp.sqrt(J2)*sp.cos(sp.Rational(2,3)*sp.pi + thetaL)

A = s1-s2
B = s2-s3
C = s1-s3



f = (1 / 2 * (A ** m + B ** m + C ** m)) ** (1 / m)


# Calculate the derivative with respect to x
print("dfds11 begin")
dfds11 = sp.diff(f, s11)
print("dfds11 end")
#print(dfds11)
# print("dfds11 simplify begin")
# df = sp.simplify(dfds11)

# print("dfds11 simplify end")

# Replace sij and m with specific values
sij_values = {
    s11: 1.0,  # Replace with your desired value for s11
    s22: 1.0,
    s33: 1.0,
    s12: 2.0,  # Replace with your desired value for s12
    s23: 3.0,  # Replace with your desired value for s23
    s31: 4.0,  # Replace with your desired value for s31
    m: 2.0,   # Replace with your desired value for m
}
# print(dfds11)
# # Substitute the values into the expression
# print("evalbegin")
# res = dfds11.subs(sij_values)
# print("subst")
# result = dfds11.evalf(subs=sij_values)
# # Calculate the result
# print("evalend")
# #print("result")
# #print(result)

# from sympy.abc import x 
# from sympy import sin, pi 
# expr=sin(x) 
# expr1=expr.evalf(6,subs={x:3.14})
# #print(expr1)

# #print(J3.evalf(6,subs=sij_values))
# J3num = J3.subs(sij_values).evalf()
# # print(J3num)


from numpy import sqrt, sin, cos,arccos as acos, pi

s11= 1.2  # Replace with your desired value for s11
s22= 1.3
s33= 1.1
s12= 2.4  # Replace with your desired value for s12
s23= 3.01  # Replace with your desired value for s23
s31= 4.01 # Replace with your desired value for s31
m= 2.0 
print("eval")
