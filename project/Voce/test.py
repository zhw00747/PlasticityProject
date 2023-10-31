import numpy as np

B = 824
n = 0.643

p = np.linspace(-0.1, 0.5, 100)

Q1 = 10.0
C1 = 0.3

R = Q1 * (1 - np.exp(-C1 * p))

from matplotlib import pyplot as plt

print(p)
print(R)
plt.plot(p, R)
plt.show()
