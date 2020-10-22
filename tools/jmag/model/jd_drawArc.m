function [ arc ] = jd_drawArc( sketch, centerxy, startxy, endxy )
%DRAWARC Summary of this function goes here
%   Detailed explanation goes here


    sketch.CreateVertex(startxy(1), startxy(2));
    sketch.CreateVertex(endxy(1), endxy(2));
    sketch.CreateVertex(centerxy(1), centerxy(2));
    arc = sketch.CreateArc(centerxy(1), centerxy(2), ...
                                startxy(1), startxy(2), ...
                                endxy(1), endxy(2));
end

