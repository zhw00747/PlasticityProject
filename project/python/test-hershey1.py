from hershey import *

if __name__ == "__main__":
    ##################################################
    ### Testing thegradient of the yield function
    ##################################################

    ##################################################
    ### First testing if the behaviour is correct
    ### at singularities
    ##################################################

    tol = 1e-5
    print("uniaxial tension/biaxial compression")
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
