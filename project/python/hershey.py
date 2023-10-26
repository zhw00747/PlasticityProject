import sympy as sp
import numpy as np
import matplotlib

matplotlib.use("agg")  # Use the 'agg' backend
from matplotlib import pyplot as plt
import random

##################################################
### Verification of Hershey and its gradient
##################################################

m = 2
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
        s11**2 / 3
        - s11 * s22 / 3
        - s11 * s33 / 3
        + s12**2
        + s22**2 / 3
        - s22 * s33 / 3
        + s23**2
        + s31**2
        + s33**2 / 3
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


def Lode(s):
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
    s1 = sp1(s)
    s2 = sp2(s)
    s3 = sp3(s)
    return herhsey(s1, s2, s3)


def finite_diff(s, i):
    assert s.shape == (6,)
    assert i >= 0 and i < 6
    hfrac = 1e-5
    sp = np.zeros_like(s)
    sp[:] = s
    h = sp[i] * hfrac
    import sys

    if h == 0:
        h = 10 * sys.float_info.epsilon
    sp[i] = sp[i] + h
    # print("i", i, "sp", sp, "s", s, "h", h)
    return (hershey_s(sp) - hershey_s(s)) / h


def dphids_numerical(s):
    dphids = np.zeros(6)
    for i in range(6):
        dphids[i] = finite_diff(s, i)
    return dphids


def dinvJ3ds(s):
    assert s.shape == (6,)
    s11 = s[0]
    s22 = s[1]
    s33 = s[2]
    s12 = s[3]
    s23 = s[4]
    s31 = s[5]
    d11 = (
        2 * s11**2 / 9
        - 2 * s11 * s22 / 9
        - 2 * s11 * s33 / 9
        + s12**2 / 3
        - s22**2 / 9
        + 4 * s22 * s33 / 9
        - 2 * s23**2 / 3
        + s31**2 / 3
        - s33**2 / 9
    )
    d22 = (
        -(s11**2) / 9
        - 2 * s11 * s22 / 9
        + 4 * s11 * s33 / 9
        + s12**2 / 3
        + 2 * s22**2 / 9
        - 2 * s22 * s33 / 9
        + s23**2 / 3
        - 2 * s31**2 / 3
        - s33**2 / 9
    )
    d33 = (
        -(s11**2) / 9
        + 4 * s11 * s22 / 9
        - 2 * s11 * s33 / 9
        - 2 * s12**2 / 3
        - s22**2 / 9
        - 2 * s22 * s33 / 9
        + s23**2 / 3
        + s31**2 / 3
        + 2 * s33**2 / 9
    )
    d12 = 2 * s11 * s12 / 3 + 2 * s12 * s22 / 3 - 4 * s12 * s33 / 3 + 2 * s23 * s31
    d23 = -4 * s11 * s23 / 3 + 2 * s12 * s31 + 2 * s22 * s23 / 3 + 2 * s23 * s33 / 3
    d31 = 2 * s11 * s31 / 3 + 2 * s12 * s23 - 4 * s22 * s31 / 3 + 2 * s31 * s33 / 3
    return np.array([d11, d22, d33, d12, d23, d31])


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
    kronecker = np.array([1, 1, 1, 0, 0, 0])

    if thetaL > tol and thetaL < np.pi / 3 - tol:
        u = 0.5 * (A**m + B**m + C**m)
        dphids1 = 0.5 * u ** (1.0 / m - 1) * (A ** (m - 1) + C ** (m - 1))
        dphids2 = 0.5 * u ** (1.0 / m - 1) * (-(A ** (m - 1)) + B ** (m - 1))
        dphids3 = 0.5 * u ** (1.0 / m - 1) * (-(B ** (m - 1)) - C ** (m - 1))

        dthetaLds = (
            np.sqrt(3)
            / (2 * np.sin(3 * thetaL))
            * (3.0 / 2 * J3 * J2 ** (-5.0 / 2) * sdev - dJ3ds * J2 ** (-3.0 / 2))
        )
        ds1ds = (
            kronecker / 3
            + sdev / np.sqrt(3 * J2) * np.cos(thetaL)
            - 2 * np.sqrt(J2) / np.sqrt(3) * np.sin(thetaL) * dthetaLds
        )
        ds2ds = (
            kronecker / 3
            + sdev / np.sqrt(3 * J2) * np.cos(2 * np.pi / 3 - thetaL)
            + 2 * np.sqrt(J2) / np.sqrt(3) * np.sin(2 * np.pi / 3 - thetaL) * dthetaLds
        )
        ds3ds = (
            kronecker / 3
            + sdev / np.sqrt(3 * J2) * np.cos(2 * np.pi / 3 + thetaL)
            - 2 * np.sqrt(J2) / np.sqrt(3) * np.sin(2 * np.pi / 3 + thetaL) * dthetaLds
        )
        print("A", A)
        print("B", B)
        print("C", C)
        print("dphids1", dphids1)
        print("dphids2", dphids2)
        print("dphids3", dphids3)
        return dphids1 * ds1ds + dphids2 * ds2ds + dphids3 * ds3ds

    else:
        # Singularity: Must be handled in a special way
        if thetaL < tol:
            a = 3.0 / 2 * sdev / np.sqrt(3 * J2)
            b = 3.0 / 2 * J3 * J2 ** (-2) * sdev - dJ3ds / J2

            # seems that this expression (b) goes to 0 in this case
            # not sure why
            assert np.linalg.norm(b) < tol
            assert abs(A - C) < tol and abs(B) < tol
            return a - 1.0 / 3 * b
        elif thetaL > np.pi / 3 - tol:
            assert abs(B - C) < tol and abs(A) < tol
            return a - b
        else:
            assert False
