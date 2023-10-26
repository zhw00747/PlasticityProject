from hershey import *

if __name__ == "__main__":
    ##################################################
    ### Testing thegradient of the yield function
    ##################################################

    ##################################################
    ### First testing if the behaviour is correct
    ### at singularities
    ##################################################

    ##################################################
    ### Lode = 0
    ##################################################
    tol = 1e-5
    print("\nuniaxial tension/biaxial compression:")
    s11 = 100.0
    s22 = -10.0
    s33 = -10.0
    s12 = 0.0
    s23 = 0.0
    s31 = 0.0
    s = np.array([s11, s22, s33, s12, s23, s31])
    thetaL = Lode(s)
    print("Lode =", thetaL)
    assert thetaL < tol

    dphids0_numerical = dphids_numerical(s)
    print("dphids0_numerical", dphids0_numerical)
    dphids0 = dherhseyds(s)
    print("dphids0 =", dphids0)

    # creating a small perturbation
    s11 = 100.0
    s22 = -10.001
    s33 = -9.999
    s12 = 0.0
    s23 = 0.0
    s31 = 0.0
    s = np.array([s11, s22, s33, s12, s23, s31])
    thetaL = Lode(s)
    print("Lode =", thetaL)
    assert thetaL > tol
    dphids1 = dherhseyds(s)
    print("dphids1 =", dphids1)
    ddphids = dphids1 - dphids0
    print("difference =", ddphids)

    ##################################################
    ### Lode = 1
    ##################################################

    print("\n\nuniaxial compression/biaxial tension:")
    s11 = 10.0
    s22 = 10.0
    s33 = -100.0
    s12 = 0.0
    s23 = 0.0
    s31 = 0.0
    s = np.array([s11, s22, s33, s12, s23, s31])
    thetaL = Lode(s)
    print("Lode =", thetaL)
    assert thetaL > np.pi / 3 - tol

    dphids0_numerical = dphids_numerical(s)
    print("dphids0_numerical", dphids0_numerical)
    dphids0 = dherhseyds(s)
    print("dphids0 =", dphids0)

    # creating a small perturbation
    s11 = 10.01
    s22 = 9.99
    s33 = -100.0
    s12 = 0.0
    s23 = 0.0
    s31 = 0.0
    s = np.array([s11, s22, s33, s12, s23, s31])
    thetaL = Lode(s)
    print("Lode =", thetaL)
    assert thetaL > tol
    dphids1 = dherhseyds(s)
    print("dphids1 =", dphids1)
    ddphids = dphids1 - dphids0
    print("difference =", ddphids)
