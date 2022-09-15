% Class param, for all simulation parameters.

classdef param

    properties
        
        simLength = 500 % Length of simulation in ms.
        dt = 1 % Delta t for numerical integration in ms.

        num_units = 5
        tau = 20 % time constant in ms for firing rate diff eq.
        r_max = 100 % Max allowed unit firing rate (Hz).
        I_th = 50
        I_sigma = 5

    end

end
