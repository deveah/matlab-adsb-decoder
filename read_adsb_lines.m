
%   read_asdb_lines.m
%   read_adsb_lines() is a function which, given a filename, iteratively
%   reads the file line-by-line, collecting its data in a vector, and
%   returns the resulted vector.
%
%   TODO: ignore lines that have a different number of elements --
%   the data lines we must consider consist of 14 hexadecimal-written
%   bytes and a square-bracket-delimited integer written in base 10.

function [lines] = read_adsb_lines(filename)
    formatspec = '*%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x; [%03d]\n';
    fid = fopen(filename, 'r');
    lines = [];
    while ~feof(fid)
        lines = [lines, fscanf(fid, formatspec, 15)];
    end
    fclose(fid);
end