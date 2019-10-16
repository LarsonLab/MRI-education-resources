function s = ktos(k,dt)

s = diff(diff(k)/(dt*4.257))/dt;
