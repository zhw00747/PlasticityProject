import numpy as np
from matplotlib import pyplot as plt
import pandas as pd

p = np.linspace(0, 1, 1000)

s0 = 290.7
Q = [129.2, 209.8, 455.3]
C = [168.6, 10.68, 0.805]


R = np.zeros_like(p)
for i in range(3):
    R += Q[i] * (1 - np.exp(-C[i] * p))

print("p\n", p)
print("R\n", R)

sy = s0 + R


data = np.column_stack((sy, p))
pd.DataFrame(data).to_excel("hardening.xlsx", header=False, index=False)

plt.plot(p, sy)
plt.show()
