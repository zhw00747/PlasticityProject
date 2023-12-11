import hershey
import numpy as np
from matplotlib import pyplot as plt


# fmt: off
factor = 0.7

m_h = [1,2,10,20,100]
a=1
if __name__ == "__main__":
    plt.figure(figsize=(factor*8,factor*6))
    legends = []
    for m_val in m_h:
        hershey.m = m_val
        m = m_val
        
        s1 = np.linspace(-1.40, 1.40, 100)
        s2 = np.linspace(-1.40, 1.40, 100)
        (S1,S2,) = np.meshgrid(s1, s2)
        PHI = np.zeros_like(S1)
        s3 = 0.0
        sY = 1.0

        for i in range(S1.shape[0]):
            for j in range(S1.shape[1]):
                ps = [s1[i], s2[j], s3]

                ps.sort()

                PHI[i, j] = hershey.herhsey(ps[2], ps[1], ps[0])

        dummy_plot, = plt.plot([], [])
        
        leg = "m="+str(m)
        if m==1:
            leg += " (Tresca)"
        elif m == 2:
            leg += " (Mises)"
        legends.append(leg)
        plt.contour(S1, S2, PHI, levels=[sY], colors=dummy_plot.get_color())

        plt.xlabel(r"$\sigma_1 / \sigma_Y$")
        plt.ylabel(r"$\sigma_2 / \sigma_Y$")
        plt.grid(True)

    plt.tight_layout()
    plt.legend(legends, loc='center')
    #plt.legend(loc='upper center', bbox_to_anchor=(0.5, 1.15), ncol=len(m_h))
    plt.savefig("hershey.png")
        


    thetaL = np.linspace(0,np.pi / 3,100)
    p1 = np.zeros_like(thetaL)
    p2 = np.zeros_like(thetaL)
    p3 = np.zeros_like(thetaL)


    for k, tL in enumerate(thetaL):
        p1[k] = np.cos(tL)
        p2[k] = np.cos(2 * np.pi / 3 - tL)
        p3[k] = np.cos(2 * np.pi / 3 + tL)

    plt.figure(figsize=(factor*8,factor*6))
    thetaL *=180/np.pi
    plt.plot(thetaL, p1)
    plt.plot(thetaL, p2)
    plt.plot(thetaL, p3)
    plt.xlim([0,max(thetaL)])
    plt.xlabel(r"$\theta_L \ [\mathrm{deg}]$")
    plt.legend([r"$\cos{\theta_L}$", r"$\cos{(\frac{2\pi}{3} - \theta_L)}$", r"$\cos{(\frac{2\pi}{3} + \theta_L)}$"])
    plt.tight_layout()
    plt.savefig("lode.png")
