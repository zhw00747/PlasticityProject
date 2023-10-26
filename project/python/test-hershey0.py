from hershey import *

if __name__ == "__main__":
    N_STRESS_SAMPLES = 100
    S_RANGE = 200.0

    thetaL = np.zeros(N_STRESS_SAMPLES)
    p1 = np.zeros_like(thetaL)
    p2 = np.zeros_like(thetaL)
    p3 = np.zeros_like(thetaL)
    for i in range(N_STRESS_SAMPLES):
        s11 = random.uniform(-S_RANGE, S_RANGE)
        s22 = random.uniform(-S_RANGE, S_RANGE)
        s33 = random.uniform(-S_RANGE, S_RANGE)
        s12 = random.uniform(-S_RANGE, S_RANGE)
        s23 = random.uniform(-S_RANGE, S_RANGE)
        s31 = random.uniform(-S_RANGE, S_RANGE)

        s = np.array([s11, s22, s33, s12, s23, s31])
        # fmt: off
        sT = np.array([[s11, s12, s31],
                    [s12, s22, s23],
                    [s31, s23, s33]])
        ##################################################
        ### Test J3 and J2
        ##################################################
        # fmt: on
        sd = s_dev(s)
        sdT = sT - np.trace(sT) / 3 * np.identity(3)
        err = np.abs(invJ2(s) - 0.5 * np.tensordot(sdT, sdT))
        print("Error J2 =", err)
        assert err < TOL
        err = np.abs(invJ3(s) - np.linalg.det(sdT))
        print("Error J3 =", err)
        assert err < TOL

        ##################################################
        ### Test Hershey function
        ##################################################
        phi = herhsey(sp1(s), sp2(s), sp3(s))
        assert phi >= -TOL

    ##################################################
    ### Plot Hershey yield surface
    ##################################################
    s1 = np.linspace(-150, 150, 100)
    s2 = np.linspace(-150, 150, 100)
    (
        S1,
        S2,
    ) = np.meshgrid(s1, s2)
    PHI = np.zeros_like(S1)
    s3 = 0.0
    sY = 100.0

    for i in range(S1.shape[0]):
        for j in range(S1.shape[1]):
            ps = [s1[i], s2[j], s3]
            # print(ps)
            ps.sort()

            PHI[i, j] = herhsey(ps[2], ps[1], ps[0])

            # print("s1", ps[2], "s2", ps[1], "s3", ps[0], "phi", PHI[i, j])

    plt.figure()
    plt.contour(S1, S2, PHI, levels=[sY])
    plt.xlabel("sigma1")
    plt.ylabel("sigma2")
    plt.grid(True)
    plt.savefig("hershey.png")

    ##################################################
    ### Test Lode and Principal stresses
    ##################################################
    thetaL = np.linspace(-0.1, np.pi / 3 + 0.1, 100)
    sH = 0
    J2 = 3.0
    for k, tL in enumerate(thetaL):
        p1[k] = sH + 2 / np.sqrt(3) * np.sqrt(J2) * np.cos(tL)
        p2[k] = sH + 2 / np.sqrt(3) * np.sqrt(J2) * np.cos(2 * np.pi / 3 - tL)
        p3[k] = sH + 2 / np.sqrt(3) * np.sqrt(J2) * np.cos(2 * np.pi / 3 + tL)

    plt.figure()
    plt.plot(thetaL, p1)
    plt.plot(thetaL, p2)
    plt.plot(thetaL, p3)
    plt.legend(["s1", "s2", "s3"])
    plt.savefig("lode.png")
