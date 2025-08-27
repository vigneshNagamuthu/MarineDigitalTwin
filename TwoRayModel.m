function rx_power = TwoRayModel(h_t, h_r, d, frequency, power)
    % Constants
    c = 3e8;  % Speed of light in m/s

    % Calculate wavelength
    lambda = c / frequency;  % Wavelength in meters

    % Check for zero distance to avoid division by zero
    if d == 0
        rx_power = power;  % Return transmitter power if distance is zero
        return;
    end
    
    % Calculate the path loss using the two-ray model
    term1 = (lambda / (4 * pi * d))^2;  % Free space path loss term
    term2 = (2 * sin((2 * pi / lambda) * (h_t * h_r / d)))^2;  % Two-ray model term
    
    % Calculate path loss in dB
    path_loss = -10 * log10(term1 * term2);

    % Received power in dBm
    rx_power = power - path_loss;  % Subtract path loss from transmitter power
end
