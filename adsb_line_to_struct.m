
%   adsb_line_to_struct.m
%   adsb_line_to_struct() is a function which converts a vector of ADS-B
%   data bytes into a structure holding human-readable data.

%   [done] Aircraft Identification Message (DF = 17; TC = 4)
%   [todo] Aircraft Positions (DF = 17; TC = 9 .. 18)

function [struct] = adsb_line_to_struct(line)
    %   Downlink Format (DF) is contained in bits 1-5 (byte 1)
    downlink_format = uint8(bitshift(line(1), -3));
    struct.downlink_format = downlink_format;
    
    %   Message Subtype (CA) is contained in bits 6-8 (byte 1)
    message_subtype = bitand(uint8(line(1)), 7);
    struct.message_subtype = message_subtype;
    
    %   ICAO Aircraft Address (ICAO24) is contained in bits 9-32
    %   (bytes 2-4)
    icao_aircraft_address = bitor( ...
        bitshift(uint32(line(2)), 16), ...
        bitor( ...
            bitshift(uint32(line(3)), 8), ...
            uint32(line(4))));
    struct.icao_aircraft_address = sprintf('0x%06x', ...
        icao_aircraft_address);
    
    %   Data Frame (DATA) is contained in bits 33-88 (bytes 4-8)
    %   TODO: bits 6-8 in TC unused?
    type_code = bitshift(line(5), -3);
    struct.type_code = type_code;
    
    % Aircraft Identification Message
    if type_code == 4
        struct.callsign = parse_aircraft_identification_message(line(6:11));
    end
    
    % Aircraft Position Message
    if type_code >= 9 && type_code <= 18
        struct.position = parse_aircraft_position_message(line(6:11));
    end
end
