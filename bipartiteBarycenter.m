% Georg Schildbach, 13/May/2026
% SOTIF --- TCFI Graph Processing
% --------------------------------------------------------------------------------------------------
% Main file, uses: bipartiteBarycenter.m
% --------------------------------------------------------------------------------------------------
% MIT License
%
% Copyright (c) 2026 Georg Schildbach
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
% associated documentation files (the "Software"), to deal in the Software without restriction, 
% including without limitation the rights to use, copy, modify, merge, publish, distribute, 
% sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following condition:
% The above copyright notice and this permission notice shall be included in all copies or 
% substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
% --------------------------------------------------------------------------------------------------

function [orderA,orderB] = bipartiteBarycenter(adjMatrix,maxIter)
    % adjMatrix: Binary matrix where Rows = Set A, Cols = Set B
    % maxIter: Number of iterations to refine the layout
    
    [numA, numB] = size(adjMatrix);
    
    % Initial positions (default 1 to N)
    posA = (1:numA)';
    posB = (1:numB)';
    
    for i = 1:maxIter
        % Phase 1: Update Set B based on Set A's positions
        for j = 1:numB
            neighbors = find(adjMatrix(:, j));
            if ~isempty(neighbors)
                posB(j) = mean(posA(neighbors));
            end
        end
        [~, orderB] = sort(posB);
        posB(orderB) = 1:numB; % Re-assign fixed ranks to prevent drifting
        
        % Phase 2: Update Set A based on Set B's positions
        for k = 1:numA
            neighbors = find(adjMatrix(k, :));
            if ~isempty(neighbors)
                posA(k) = mean(posB(neighbors));
            end
        end
        [~, orderA] = sort(posA);
        posA(orderA) = 1:numA; % Re-assign fixed ranks
    end
end