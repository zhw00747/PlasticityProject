from hershey import *

if __name__ == "__main__":
    ##################################################
    ### Testing thegradient of the yield function
    ##################################################

    ##################################################
    ### Running multiple random cases and comparing
    ### with numerical differentiation
    ##################################################

    N_STRESS_SAMPLES = 10000
    S_RANGE = 200.0
    for i in range(N_STRESS_SAMPLES):
        s11 = random.uniform(-S_RANGE, S_RANGE)
        s22 = random.uniform(-S_RANGE, S_RANGE)
        s33 = random.uniform(-S_RANGE, S_RANGE)
        s12 = random.uniform(-S_RANGE, S_RANGE)
        s23 = random.uniform(-S_RANGE, S_RANGE)
        s31 = random.uniform(-S_RANGE, S_RANGE)

        # s11 = 10
        # s22 = 20
        # s33 = 30
        # s12 = 40
        # s23 = 50
        # s31 = 60
        s = np.array([s11, s22, s33, s12, s23, s31], dtype=float)

        dphids = dherhseyds(s)
        dphids_num = dphids_numerical(s)
        diff = dphids - dphids_num
        error_tol = 1e-8
        tol = 1e-8

        assert m == 2
        sdev = s_dev(s)
        dphids_exact = 3.0 / (2 * np.sqrt(3 * invJ2(s))) * sdev
        diff = dphids - dphids_exact

        error = np.linalg.norm(diff) / (np.linalg.norm(dphids_num))
        if error > error_tol:
            print("Failed for i =", i)
            print("s = ", s)
            print("Lode = ", Lode(s))
            print("dphids =", dphids)
            print("dphids_num =", dphids_num)
            print("diff =", diff)
            print("ratio:", dphids / dphids_num)
            print("error =", error)
            print("tol =", error_tol)

            sdev = s_dev(s)
            print("sdev", sdev)
            print("dphids/sdev", dphids / sdev)
            print("dphids_num/sdev", dphids_num / sdev)

            print("\n")

            J2 = invJ2(s)
            J2alt = 0.5 * (
                sdev[0] ** 2
                + sdev[1] ** 2
                + sdev[2] ** 2
                + 2 * (sdev[3] ** 2 + sdev[4] ** 2 + sdev[5] ** 2)
            )
            assert np.abs(J2 - J2alt) < tol

            s1 = sp1(s)
            s2 = sp2(s)
            s3 = sp3(s)

            print("FAILED")
            exit(1)

        # break
