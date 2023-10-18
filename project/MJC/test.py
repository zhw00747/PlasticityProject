import numpy as np

B = 824
n = 0.643

p = np.linspace(0, 0.5, 500)

hR = B * p ** (n - 1)
# print("hR", hR)

from matplotlib import pyplot as plt

plt.plot(p, hR)
plt.show()
