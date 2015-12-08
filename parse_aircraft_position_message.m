
%   parse_aircraft_position_message.m
%   parse_aircraft_position_message() is a function which converts the
%   binary DATA field into human-readable representations of the altitude,
%   F bit, longitude and latitude.

function [position] = parse_aircraft_position_message(line)
    %   Altitude is contained in bits 1-12 of the DATA field
    %   TODO: the Q ("decodable") bit is ignored for now.
    altitude2 = bitor( ...
        bitshift(uint16(bitshift(line(1), -1)), 4), ...
        bitshift(uint16(line(2)), -4));
    position.altitude = altitude2 * 25 - 1000;
    
    %   Bit F is the 14th bit of the DATA field
    position.F = bitand(line(2), 4) > 0;
    
    %   CPR Longitude is represented in the next 17 bits
    cpr_lat_bin = strcat( ...
        dec2bin(bitand(line(2), 3), 2), ...
        dec2bin(line(3), 8), ...
        dec2bin(bitshift(line(4), -1), 7));
    cpr_lat = bin2dec(cpr_lat_bin) / 131072;
    position.cpr_lat = cpr_lat;
    
    %   CPR Latitude is represented in the next 17 bits
    cpr_lon_bin = strcat( ...
        dec2bin(bitand(line(4), 1), 1), ...
        dec2bin(line(5), 8), ...
        dec2bin(line(6), 8));
    cpr_lon = bin2dec(cpr_lon_bin) / 131072;
    position.cpr_lon = cpr_lon;
end
