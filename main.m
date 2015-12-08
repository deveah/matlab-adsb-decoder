
%   main.m

%   Resources used:
%   1.  A Guide on Decoding ADS-B Messages
%       http://adsb-decode-guide.readthedocs.org/en/latest/
%   2.  Decoding ADS-B Position
%       http://www.lll.lu/~edward/edward/adsb/DecodingADSBposition.html

A = read_adsb_lines('data.txt');

%   The third line in the file is used as an example in [1], and carries
%   an Aircraft Identification Message.
posA = adsb_line_to_struct(A(:,4));
posB = adsb_line_to_struct(A(:,5));

%   In the tutorial in [1], these are the frames used as an example; also,
%   t0 > t1 is part of the demonstration, so the comparison has been kept.
cpr_to_position( ...
    posA.position.cpr_lon, ...
    posA.position.cpr_lat, ...
    posB.position.cpr_lon, ...
    posB.position.cpr_lat, ...
    1, 0)