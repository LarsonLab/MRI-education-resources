import numpy as np
import matplotlib.pyplot as plt

def loop_coil_field(radius, I, flag_2d=0):
    """
    Uses Biot-Savart law to evaluate the magnetic field of a circular loop coil.
    The coil is placed in the X-Z plane.

    Parameters:
        radius (float or list): Radius of the coil. If a single value is provided, it is used for both X and Z radii.
        I (float): Current in the coil.
        flag_2d (int, optional): If 1, only compute magnetic field in the x-y plane (faster computation). Default is 0.

    Returns:
        BX, BY, BZ (numpy arrays): Components of the magnetic field vector.
        xp, yp, zp (numpy arrays): Locations at which the magnetic field vector was evaluated.
    
    Contributions from https://www.mathworks.com/matlabcentral/fileexchange/42329-magnetic-field-of-a-circular-current-loop-using-biot-savart-s-law and Peder E. Z. Larson
    """
    if isinstance(radius, (int, float)):
        radius = [radius, radius]

    # Coil parameters
    N = 25  # Number of grid points in the coil
    u0 = 1  # Permeability constant (simplified to 1 for this example)
    phi = np.linspace(-np.pi / 2, 3 * np.pi / 2, N)  # For describing a circle (coil)

    Xc = radius[0] * np.cos(phi)  # X-coordinates of the coil
    Yc = np.zeros(N)
    Zc = radius[1] * np.sin(phi)  # Z-coordinates of the coil

    max_plot = max(radius) * 2
    Nplot = 51

    xp = np.linspace(-max_plot, max_plot, Nplot)
    yp = xp

    if flag_2d == 1:
        zp = np.array([0])
    else:
        zp = xp

    X, Y, Z = np.meshgrid(xp, yp, zp, indexing='ij')

    BX = np.zeros_like(X)
    BY = np.zeros_like(Y)
    BZ = np.zeros_like(Z)

    for Ix in range(len(xp)):
        for Iy in range(len(yp)):
            for Iz in range(len(zp)):
                Rx, Ry, Rz, dlx, dly, dlz = [], [], [], [], [], []

                # -------------------------------------------------------------------------
                # calculate R-vector from the coil(X-Y plane)to Y-Z plane where we are
                # interested to find the magnetic field and also the dl-vector along the
                # coil where current is flowing
                # (note that R is the position vector pointing from coil (X-Y plane) to
                # the point where we need the magnetic field (in this case Y-Z plane).)
                # dl is the current element vector which will make up the coil------------
                # -------------------------------------------------------------------------
                for i in range(N - 1):
                    Rx.append(X[Ix, Iy, Iz] - 0.5 * (Xc[i] + Xc[i + 1]))
                    Ry.append(Y[Ix, Iy, Iz] - 0.5 * (Yc[i] + Yc[i + 1]))
                    Rz.append(Z[Ix, Iy, Iz] - 0.5 * (Zc[i] + Zc[i + 1]))
                    dlx.append(Xc[i + 1] - Xc[i])
                    dly.append(Yc[i + 1] - Yc[i])
                    dlz.append(Zc[i + 1] - Zc[i])

                Rx.append(X[Ix, Iy, Iz] - 0.5 * (Xc[-1] + Xc[0]))
                Ry.append(Y[Ix, Iy, Iz] - 0.5 * (Yc[-1] + Yc[0]))
                Rz.append(Z[Ix, Iy, Iz] - 0.5 * (Zc[-1] + Zc[0]))
                dlx.append(-Xc[-1] + Xc[0])
                dly.append(-Yc[-1] + Yc[0])
                dlz.append(-Zc[-1] + Zc[0])

                # --------------------------------------------------------------------------
                # for all the elements along coil, calculate dl cross R -------------------
                # dl cross R is the curl of vector dl and R--------------------------------
                # XCross is X-component of the curl of dl and R, similarly I get Y and Z-
                # --------------------------------------------------------------------------
                
                Rx, Ry, Rz = np.array(Rx), np.array(Ry), np.array(Rz)
                dlx, dly, dlz = np.array(dlx), np.array(dly), np.array(dlz)

                R = np.sqrt(Rx**2 + Ry**2 + Rz**2)
                curl_dl_R = np.cross(np.array([dlx, dly, dlz]).T, np.array([Rx, Ry, Rz]).T)

                #-------------------------------------------------------------------------
                # this will be the biot savarts law equation------------------------------
                #--------------------------------------------------------------------------

                Bx1 = (I * u0 / (4 * np.pi * R**3)) * curl_dl_R[:, 0]
                By1 = (I * u0 / (4 * np.pi * R**3)) * curl_dl_R[:, 1]
                Bz1 = (I * u0 / (4 * np.pi * R**3)) * curl_dl_R[:, 2]

                #--------------------------------------------------------------------------
                # now we have  magnetic field from all current elements in the form of an
                # array named Bx1,By1,Bz1, now its time to add them up to get total
                # magnetic field
                #--------------------------------------------------------------------------
            
                BX[Ix, Iy, Iz] = np.sum(Bx1)
                BY[Ix, Iy, Iz] = np.sum(By1)
                BZ[Ix, Iy, Iz] = np.sum(Bz1)

    Bmag = np.sqrt(BX**2 + BY**2 + BZ**2)

    # Plotting
    _, Iz = min((abs(zp - 0), i) for i, zp in enumerate(zp))
    fig2, axs = plt.subplots(2, 2, figsize=(10, 8), num='Magnetic Field Components')

    axs[0, 0].contour(xp, yp, BX[:, :, Iz], 50)
    axs[0, 0].set_title('$B_X$')
    axs[0, 0].set_xlabel('x')
    axs[0, 0].set_ylabel('y')

    axs[0, 1].contour(xp, yp, BY[:, :, Iz], 50)
    axs[0, 1].set_title('$B_Y$')
    axs[0, 1].set_xlabel('x')
    axs[0, 1].set_ylabel('y')

    axs[1, 0].contour(xp, yp, BZ[:, :, Iz], 50)
    axs[1, 0].set_title('$B_Z$')
    axs[1, 0].set_xlabel('x')
    axs[1, 0].set_ylabel('y')

    axs[1, 1].contour(xp, yp, Bmag[:, :, Iz], 50)
    axs[1, 1].quiver(xp[::4], yp[::4], BX[::4, ::4, Iz], BY[::4, ::4, Iz])
    axs[1, 1].set_title('$|B|$')
    axs[1, 1].set_xlabel('x')
    axs[1, 1].set_ylabel('y')

    plt.tight_layout()
    plt.show()

    return BX, BY, BZ, xp, yp, zp