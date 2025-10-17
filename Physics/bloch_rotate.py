import numpy as np

def bloch_rotate(Mstart, T, B):
    """
    Compute rotation of net magnetization for a given magnetic field.
    
    Parameters
    ----------
    Mstart : array_like, shape (3,)
        Initial magnetization [Mx, My, Mz]
    T : float
        Duration (ms)
    B : array_like, shape (3,)
        Magnetic field vector [Bx, By, Bz] (mT)
    
    Returns
    -------
    Mend : ndarray, shape (3,)
        Final magnetization.
    """
    GAMMA = 42.58  # kHz/mT
    M = np.asarray(Mstart, dtype=float).reshape(3,)
    B = np.asarray(B, dtype=float).reshape(3,)

    normB = np.linalg.norm(B)
    eps = np.finfo(float).eps

    flip = 2.0 * np.pi * GAMMA * normB * T
    eta = np.arccos(B[2] / (normB + eps))
    theta = np.arctan2(B[1], B[0])

    def Rz(phi):
        c = np.cos(phi); s = np.sin(phi)
        return np.array([[c, -s, 0.0],
                         [s,  c, 0.0],
                         [0.0, 0.0, 1.0]])

    def Ry(phi):
        c = np.cos(phi); s = np.sin(phi)
        return np.array([[ c, 0.0, s],
                         [0.0, 1.0, 0.0],
                         [-s, 0.0, c]])

    R = Rz(-theta) @ Ry(-eta) @ Rz(flip) @ Ry(eta) @ Rz(theta)
    Mend = R @ M
    return Mend