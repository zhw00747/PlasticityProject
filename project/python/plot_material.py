import numpy as np
from matplotlib import pyplot as plt

p = np.linspace(0, 0.03)

s0 = 370
Q = [236.4, 408.1, 0.0]
C = [39.3, 4.5, 0.0]


R = np.zeros_like(p)
for i in range(3):
    R += Q[i] * (1 - np.exp(-C[i] * p))

print(R)

sy = s0 + R
plt.plot(p, sy)
plt.show()
