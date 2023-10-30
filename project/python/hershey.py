import sympy as sp
import numpy as np
import matplotlib

matplotlib.use("agg")  # Use the 'agg' backend
from matplotlib import pyplot as plt
import random

##################################################
### Verification of Hershey and its gradient
##################################################

m = 1
TOL = 1e-6


def sHyd(s):
    assert s.shape == (6,)
    return (s[0] + s[1] + s[2]) / 3


def s_dev(s):
    assert s.shape == (6,)
    return s - sHyd(s) * np.array([1.0, 1.0, 1.0, 0.0, 0.0, 0.0])


def invJ2(s):
    assert s.shape == (6,)
    s11 = s[0]
    s22 = s[1]
    s33 = s[2]
    s12 = s[3]
    s23 = s[4]
    s31 = s[5]
    J2 = (
        0.5 * (s11**2 + s22**2 + s33**2 + 2 * (s12**2 + s23**2 + s31**2))
        - 1.0 / 6 * (s11 + s22 + s33) ** 2
    )
    assert J2 >= 0
    return J2


def invJ3(s):
    assert s.shape == (6,)
    s11 = s[0]
    s22 = s[1]
    s33 = s[2]
    s12 = s[3]
    s23 = s[4]
    s31 = s[5]
    return (
        2 * s11**3 / 27
        - s11**2 * s22 / 9
        - s11**2 * s33 / 9
        + s11 * s12**2 / 3
        - s11 * s22**2 / 9
        + 4 * s11 * s22 * s33 / 9
        - 2 * s11 * s23**2 / 3
        + s11 * s31**2 / 3
        - s11 * s33**2 / 9
        + s12**2 * s22 / 3
        - 2 * s12**2 * s33 / 3
        + 2 * s12 * s23 * s31
        + 2 * s22**3 / 27
        - s22**2 * s33 / 9
        + s22 * s23**2 / 3
        - 2 * s22 * s31**2 / 3
        - s22 * s33**2 / 9
        + s23**2 * s33 / 3
        + s31**2 * s33 / 3
        + 2 * s33**3 / 27
    )


def invJ3T(S):
    assert S.shape == (3, 3)
    sH = np.trace(S) / 3
    Sdev = S - sH * np.identity(3)
    J3 = np.linalg.det(Sdev)
    return J3


def Lode(s):
    assert s.shape == (6,)
    # theta_L = 1.0 / 3 * np.arccos(3 * np.sqrt(3) / 2 * invJ3(s) / invJ2(s) ** (3.0 / 2))
    arg = 3 * np.sqrt(3) / 2 * invJ3(s) / invJ2(s) ** (3.0 / 2)
    tol = 1e-6
    assert arg < 1 + tol and arg > -1 - tol
    if arg > 1:
        arg = 1.0
    elif arg < -1:
        arg = -1.0
    theta_L = 1.0 / 3 * np.arccos(arg)

    # print("SS", s, "Lode", theta_L, "arg", arg)
    assert theta_L >= 0 and theta_L <= np.pi / 3
    return theta_L


def LodeT(S):
    assert S.shape == (3, 3)
    sH = np.trace(S) / 3
    Sdev = S - sH * np.identity(3)
    J2 = 0.5 * np.sum(Sdev * Sdev)
    J3 = np.linalg.det(Sdev)
    # Lode
    arg = 3 * np.sqrt(3) / 2 * J3 / J2 ** (3.0 / 2)
    tol = 1e-6
    assert arg < 1 + tol and arg > -1 - tol
    if arg > 1:
        arg = 1.0
    elif arg < -1:
        arg = -1.0
    thetaL = 1.0 / 3 * np.arccos(arg)
    return thetaL


def hersheyT(S):
    ##################################################
    ### Hershey that uses a full 3x3 tensor, not a 6 vector
    ##################################################
    assert S.shape == (3, 3)
    sH = np.trace(S) / 3
    Sdev = S - sH * np.identity(3)
    J2 = 0.5 * np.sum(Sdev * Sdev)
    J3 = np.linalg.det(Sdev)
    # Lode
    arg = 3 * np.sqrt(3) / 2 * J3 / J2 ** (3.0 / 2)
    tol = 1e-6
    assert arg < 1 + tol and arg > -1 - tol
    if arg > 1:
        arg = 1.0
    elif arg < -1:
        arg = -1.0
    thetaL = 1.0 / 3 * np.arccos(arg)
    s1 = sH + 2 / np.sqrt(3) * np.sqrt(J2) * np.cos(thetaL)
    s2 = sH + 2 / np.sqrt(3) * np.sqrt(J2) * np.cos(2 * np.pi / 3 - thetaL)
    s3 = sH + 2 / np.sqrt(3) * np.sqrt(J2) * np.cos(2 * np.pi / 3 + thetaL)
    return herhsey(s1, s2, s3)

    # return Lode(s)


def sp1(s):
    assert s.shape == (6,)
    return sHyd(s) + 2 / np.sqrt(3) * np.sqrt(invJ2(s)) * np.cos(Lode(s))


def sp2(s):
    assert s.shape == (6,)
    return sHyd(s) + 2 / np.sqrt(3) * np.sqrt(invJ2(s)) * np.cos(
        2 * np.pi / 3 - Lode(s)
    )


def sp3(s):
    assert s.shape == (6,)
    return sHyd(s) + 2 / np.sqrt(3) * np.sqrt(invJ2(s)) * np.cos(
        2 * np.pi / 3 + Lode(s)
    )


def herhsey(s1, s2, s3):
    A = s1 - s2
    B = s2 - s3
    C = s1 - s3
    assert np.sign(A) >= 0.0
    assert np.sign(B) >= 0.0
    assert np.sign(C) >= 0.0
    phi = (0.5 * (A**m + B**m + C**m)) ** (1.0 / m)
    assert phi >= 0.0
    return phi


def hershey_s(s):
    assert s.shape == (6,)

    # J2 = invJ2(s)
    # return np.sqrt(3 * J2)

    s1 = sp1(s)
    s2 = sp2(s)
    s3 = sp3(s)
    return herhsey(s1, s2, s3)


def finite_diff(S, i, j, funcT):
    import sys

    hfrac = 1e-6
    h = S[i, i] * hfrac
    if h == 0:
        h = 100 * sys.float_info.epsilon
    sp = np.zeros_like(S)
    sp[:, :] = S[:, :]
    sp[i, j] = S[i, j] + h
    sm = np.zeros_like(S)
    sm[:, :] = S[:, :]
    sm[i, j] = S[i, j] - h
    return (funcT(sp) - funcT(sm)) / (2 * h)
    # return (hersheyT(sp) - hersheyT(sm)) / (2 * h)


def dJ3ds_numerical(s):
    assert s.shape == (6,)
    S = np.zeros((3, 3))
    S[0, 0] = s[0]
    S[1, 1] = s[1]
    S[2, 2] = s[2]
    S[0, 1] = s[3]
    S[1, 2] = s[4]
    S[2, 0] = s[5]
    S[0, 2] = S[2, 0]
    S[2, 1] = S[1, 2]
    S[1, 0] = S[0, 1]
    assert S.all() == S.T.all()
    dJ3 = np.zeros_like(S)
    for i in range(3):
        for j in range(3):
            dJ3[i, j] = finite_diff(S, i, j, invJ3T)
    assert dJ3.all() == dJ3.T.all()
    dJ3ds = np.zeros(6)
    dJ3ds[0] = dJ3[0, 0]
    dJ3ds[1] = dJ3[1, 1]
    dJ3ds[2] = dJ3[2, 2]
    dJ3ds[3] = dJ3[0, 1]
    dJ3ds[4] = dJ3[1, 2]
    dJ3ds[5] = dJ3[2, 0]
    return dJ3ds


def dLodeds_numercial(s):
    assert s.shape == (6,)
    S = np.zeros((3, 3))
    S[0, 0] = s[0]
    S[1, 1] = s[1]
    S[2, 2] = s[2]
    S[0, 1] = s[3]
    S[1, 2] = s[4]
    S[2, 0] = s[5]
    S[0, 2] = S[2, 0]
    S[2, 1] = S[1, 2]
    S[1, 0] = S[0, 1]
    assert S.all() == S.T.all()
    dL = np.zeros_like(S)
    for i in range(3):
        for j in range(3):
            dL[i, j] = finite_diff(S, i, j, LodeT)
    assert dL.all() == dL.T.all()
    dLds = np.zeros(6)
    dLds[0] = dL[0, 0]
    dLds[1] = dL[1, 1]
    dLds[2] = dL[2, 2]
    dLds[3] = dL[0, 1]
    dLds[4] = dL[1, 2]
    dLds[5] = dL[2, 0]
    return dLds


def dphids_numerical(s):
    assert s.shape == (6,)
    S = np.zeros((3, 3))
    S[0, 0] = s[0]
    S[1, 1] = s[1]
    S[2, 2] = s[2]
    S[0, 1] = s[3]
    S[1, 2] = s[4]
    S[2, 0] = s[5]
    S[0, 2] = S[2, 0]
    S[2, 1] = S[1, 2]
    S[1, 0] = S[0, 1]
    assert S.all() == S.T.all()
    df = np.zeros_like(S)
    for i in range(3):
        for j in range(3):
            df[i, j] = finite_diff(S, i, j, hersheyT)
    assert df.all() == df.T.all()
    dfds = np.zeros(6)
    dfds[0] = df[0, 0]
    dfds[1] = df[1, 1]
    dfds[2] = df[2, 2]
    dfds[3] = df[0, 1]
    dfds[4] = df[1, 2]
    dfds[5] = df[2, 0]
    return dfds


def dinvJ3ds(s):
    assert s.shape == (6,)
    s11 = s[0]
    s22 = s[1]
    s33 = s[2]
    s12 = s[3]
    s23 = s[4]
    s31 = s[5]
    # d11 = (
    #     2 * s11**2 / 9
    #     - 2 * s11 * s22 / 9
    #     - 2 * s11 * s33 / 9
    #     + s12**2 / 3
    #     - s22**2 / 9
    #     + 4 * s22 * s33 / 9
    #     - 2 * s23**2 / 3
    #     + s31**2 / 3
    #     - s33**2 / 9
    # )
    # d22 = (
    #     -(s11**2) / 9
    #     - 2 * s11 * s22 / 9
    #     + 4 * s11 * s33 / 9
    #     + s12**2 / 3
    #     + 2 * s22**2 / 9
    #     - 2 * s22 * s33 / 9
    #     + s23**2 / 3
    #     - 2 * s31**2 / 3
    #     - s33**2 / 9
    # )
    # d33 = (
    #     -(s11**2) / 9
    #     + 4 * s11 * s22 / 9
    #     - 2 * s11 * s33 / 9
    #     - 2 * s12**2 / 3
    #     - s22**2 / 9
    #     - 2 * s22 * s33 / 9
    #     + s23**2 / 3
    #     + s31**2 / 3
    #     + 2 * s33**2 / 9
    # )

    d11 = (
        2 * s11**2 / 9
        - 2 * s11 * s22 / 9
        - 2 * s11 * s33 / 9
        + s12 * s12 / 3
        + s31 * s31 / 3
        - s22**2 / 9
        + 4 * s22 * s33 / 9
        - 2 * s23 * s23 / 3
        - s33**2 / 9
    )

    d22 = (
        -(s11**2) / 9
        - 2 * s11 * s22 / 9
        + 4 * s11 * s33 / 9
        + s12 * s12 / 3
        - 2 * s31 * s31 / 3
        + 2 * s22**2 / 9
        - 2 * s22 * s33 / 9
        + s23 * s23 / 3
        - s33**2 / 9
    )

    d33 = (
        -(s11**2) / 9
        + 4 * s11 * s22 / 9
        - 2 * s11 * s33 / 9
        - 2 * s12 * s12 / 3
        + s31 * s31 / 3
        - s22**2 / 9
        - 2 * s22 * s33 / 9
        + s23 * s23 / 3
        + 2 * s33**2 / 9
    )

    d12 = s11 * s12 / 3 + s12 * s22 / 3 - 2 * s12 * s33 / 3 + s23 * s31

    d23 = -2 * s11 * s23 / 3 + s12 * s31 + s22 * s23 / 3 + s23 * s33 / 3

    d31 = s11 * s31 / 3 + s12 * s23 - 2 * s31 * s22 / 3 + s31 * s33 / 3

    return np.array([d11, d22, d33, d12, d23, d31])


# fmt: off
def dherhseyds(s):
    ##################################################
    ### Computes the gradient of the equivalent stress
    ### phi with respect to the stress tensor s
    ##################################################
    assert s.shape == (6,)

    A = sp1(s) - sp2(s)
    B = sp2(s) - sp3(s)
    C = sp1(s) - sp3(s)
    thetaL = Lode(s)
    tol = 1e-5

    J2 = invJ2(s)
    sdev = s_dev(s)
    J3 = invJ3(s)
    dJ3ds = dinvJ3ds(s)
    kronecker = np.array([1, 1, 1, 0, 0, 0], dtype=float)

    if thetaL > tol and thetaL < np.pi / 3 - tol:
        print("ORDINARY CASE")
        u = 0.5 * (A**m + B**m + C**m)
        dphids1 = 0.5 * u ** (1.0 / m - 1) * (A ** (m - 1) + C ** (m - 1))
        dphids2 = 0.5 * u ** (1.0 / m - 1) * (-(A ** (m - 1)) + B ** (m - 1))
        dphids3 = 0.5 * u ** (1.0 / m - 1) * (-(B ** (m - 1)) - C ** (m - 1))

        dthetaLds = (
            np.sqrt(3) / (2 * np.sin(3 * thetaL))
            * (3.0 / 2 * J3 * J2 ** (-5.0 / 2) * sdev - dJ3ds * J2 ** (-3.0 / 2))
        )
        ds1ds = kronecker/3 + sdev/np.sqrt(3*J2)*np.cos(thetaL) - 2*np.sqrt(J2)/np.sqrt(3)*np.sin(thetaL)*dthetaLds
        ds2ds = kronecker/3 + sdev/np.sqrt(3*J2)*np.cos(2*np.pi/3-thetaL) + 2*np.sqrt(J2)/np.sqrt(3)*np.sin(2*np.pi/3-thetaL)*dthetaLds
        ds3ds = kronecker/3 + sdev/np.sqrt(3*J2)*np.cos(2*np.pi/3+thetaL) - 2*np.sqrt(J2)/np.sqrt(3)*np.sin(2*np.pi/3+thetaL)*dthetaLds
        
        sum_angles_cos = (
            np.cos(thetaL)
            + np.cos(2 * np.pi / 3 - thetaL)
            + np.cos(2 * np.pi / 3 + thetaL)
        )
        sum_angles_cos_weighted = (
            np.cos(thetaL) * dphids1
            + np.cos(2 * np.pi / 3 - thetaL) * dphids2
            + np.cos(2 * np.pi / 3 + thetaL) * dphids3
        )
        
        sum_angles_sin = (
            - np.sin(thetaL)
            + np.sin(2 * np.pi / 3 - thetaL)
            - np.sin(2 * np.pi / 3 + thetaL)
        )
        sum_angles_sin_weighted = (
            - np.sin(thetaL)*dphids1
            + np.sin(2 * np.pi / 3 - thetaL)*dphids2
            - np.sin(2 * np.pi / 3 + thetaL)*dphids3
        )

        print("sum angles cos = ", sum_angles_cos)
        print("sum angles cos weighted", sum_angles_cos_weighted)
        
        print("sum angles sin = ", sum_angles_sin)
        print("sum angles sin weighted", sum_angles_sin_weighted)
        
        # print("A", A)
        # print("B", B)
        # print("C", C)
        print("dphids1", dphids1)
        print("dphids2", dphids2)
        print("dphids3", dphids3)
        
        print("dLodeds",dthetaLds)
        print("dJ3ds",dJ3ds)
        
        #calc dLodeds numerically:
        dLodeds_num = dLodeds_numercial(s)
        
        print("dLodeds num",dLodeds_num)
        print("dLodeds",dthetaLds)
        print("difference:",dLodeds_num-dthetaLds)
        
        dJ3ds_num = dJ3ds_numerical(s)
        print("dJ3ds num",dJ3ds_num)
        print("dJ3ds",dJ3ds)
        print("difference:",dJ3ds_num -dJ3ds)
        
        return dphids1 * ds1ds + dphids2 * ds2ds + dphids3 * ds3ds

    else:
        print("SINGULARITY")
        # Singularity: Must be handled in a special way
        a = 3.0 / 2 * sdev / np.sqrt(3 * J2)
        b = 3.0 / 2 * J3 * J2 ** (-2) * sdev - dJ3ds / J2
        if thetaL < tol:
            # seems that this expression (b) goes to 0 in this case
            # not sure why:
            assert np.linalg.norm(b) < tol
            assert abs(A - C) < tol and abs(B) < tol
            return a - 1.0 / 3 * b
        elif thetaL > np.pi / 3 - tol:
            assert abs(B - C) < tol and abs(A) < tol
            return a - b
        else:
            assert False
# fmt: on
