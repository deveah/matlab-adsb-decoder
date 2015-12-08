
%   cpr_to_position.m
%   cpr_to_position() is a function that converts an even/odd pair of
%   latitude/longitude coordinates into a human-readable and human-usable
%   pair of latitude/longitude coordinates; code is partially translated
%   from python (original author Junzi Sun -- http://github.com/junzis).
%   (https://github.com/junzis/py-adsb-decoder/blob/master/decoder.py)

function [position] = cpr_to_position(cpr_lon0, cpr_lat0, cpr_lon1, cpr_lat1, t0, t1)
    j = floor((59 * cpr_lat0) - (60 * cpr_lat1) + 0.5);
    
    DLat_EVEN = 360.0 / 60;
    DLat_ODD = 360.0 / 59;
    
    lat_e = DLat_EVEN * (mod(j, 60) + cpr_lat0);
    if lat_e >= 270
        lat_e = lat_e - 360;
    end
    
    lat_o = DLat_ODD * (mod(j, 59) + cpr_lat1);
    if lat_o >= 270
        lat_o = lat_o - 360;
    end
    
    position.lat_zone = NL(lat_e);
    if NL(lat_e) ~= NL(lat_o)
        disp('Even- and odd- frame latitudes are in different zones.');
    end
    
    if t0 > t1
        lat = lat_e;
        ni = N(lat_e, 0);
        m = floor(cpr_lon0 * (NL(lat_e) - 1) - cpr_lon1 * NL(lat_e) + 0.5);
        lon = (360 / ni) * (mod(m, ni) + cpr_lon0);
    else
        lat = lat_o;
        ni = N(lat_o, 1);
        m = floor(cpr_lon0 * (NL(lat_o) - 1) - cpr_lon1 * NL(lat_o) + 0.5);
        lon = (360 / ni) * (mod(m, ni) + cpr_lon1);
    end
    
    if lon >= 180
        lon = lon - 360;
    end
    
    position.lat = lat;
    position.lon = lon;
end

%   TODO: precompute this --
%   http://www.eurocontrol.int/eec/gallery/content/public/document/eec/report/1995/002_Aircraft_Position_Report_using_DGPS_Mode-S.pdf
%   (page 8)
function [index] = NL(lat)
    nz = 60;
    a = 1 - cos(pi * 2 / nz);
    b = cos(pi / 180 * abs(lat)) ^ 2;
    nl = 2 * pi / acos(1 - a / b);
    index = floor(nl);
end

function [index] = N(lat, is_odd)
    nl = NL(lat) - is_odd;
    if nl > 1
        index = nl;
    else
        index = 1;
    end
end
