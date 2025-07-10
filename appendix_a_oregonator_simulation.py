import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

def oregonator(t, y, epsilon, q, f):
    x, y_, z = y
    dxdt = (1/epsilon)*(x*(1 - x) - f*z*(x - q)/(x + q))
    dydt = x - y_
    dzdt = f*(z - x)
    return [dxdt, dydt, dzdt]

# Parameters
epsilon = 0.04
q = 0.08
f = 2/3

# Initial conditions
y0 = [0.2, 0.3, 0.4]
t_span = (0, 200)
t_eval = np.linspace(*t_span, 1000)

sol = solve_ivp(oregonator, t_span, y0, t_eval=t_eval, args=(epsilon, q, f))

# Plot
plt.plot(sol.t, sol.y[0], label='x (HBrO2)')
plt.plot(sol.t, sol.y[1], label='y (Br⁻)')
plt.plot(sol.t, sol.y[2], label='z (Fe(III))')
plt.legend()
plt.xlabel('Time')
plt.ylabel('Concentration')
plt.title('Oregonator Oscillations')
plt.show()
