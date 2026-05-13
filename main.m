% Georg Schildbach, 13/May/2026
% SOTIF --- TCFI Graph Presentation and Optimization
% --------------------------------------------------------------------------------------------------
% Main file, uses: readTCFIgraph.m, writeTable.m, writeGraph.m, bipartiteBarycenter.m
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

clc
clear all
close all

% 1) Inputs ----------------------------------------------------------------------------------------

folderID = pwd;
maxlinesize = 37;  % maximum characters per line in the graph

% 2) Read Initial TCFI Table -----------------------------------------------------------------------

fileID = fopen([folderID,'/TCFIgraph_spec.txt'],'r');
[TCnum,TClabel,TCtext,TCclass,FInum,FIlabel,FItext,FIclass,TCFIlist] = readTCFIgraph(folderID,fileID);
fclose(fileID);

% 3) Generate Latex Table --------------------------------------------------------------------------

fileID = fopen([folderID,'/LatexTable.tex'],'w');
writeTable(folderID,fileID,TCFIlist,TClabel,TCclass,TCnum,TCtext,FIlabel,FItext,FIclass,FInum);
fclose(fileID);

% 4) Generate Original Graph -----------------------------------------------------------------------

% 4.1) Sort TCs according to sub-numbering

sortTC = 0 * TCnum(:,1);
k = 1;
count = 0;
while k <= size(TCnum,1)
    % Check if TC has already been listed
    ind = 0;
    for i = 1:k-1
        if TCnum(i,1) == TCnum(k,1)
            ind = 1;
        end
    end
    % Find all TCs with same number
    if ind == 0
        count = count + 1;
        sortTC(count,1) = k;
        c = 0;
        for i = k+1:size(TCnum,1)
            if TCnum(i,1) == TCnum(k,1)
                count = count + 1;
                sortTC(count,1) = i;
                c = c + 1;
            end
        end
        [~,partSortTC] = sort(TCnum(count-c:count,2));
        sortTC(count-c:count,1) = sortTC(count-c-1+partSortTC,1);
    end
    k = k + 1;
end

clear count c ind partSortTC

% 4.2) Sort FIs according to sub-numbering

sortFI = 0 * FInum(:,1);
k = 1;
count = 0;
while k <= size(FInum,1)
    % Check if FI has already been listed
    ind = 0;
    for i = 1:k-1
        if FInum(i,1) == FInum(k,1)
            ind = 1;
        end
    end
    % Find all FIs with same number
    if ind == 0
        count = count + 1;
        sortFI(count,1) = k;
        c = 0;
        for i = k+1:size(FInum,1)
            if FInum(i,1) == FInum(k,1)
                count = count + 1;
                sortFI(count,1) = i;
                c = c + 1;
            end
        end
        [~,partSortFI] = sort(FInum(count-c:count,2));
        sortFI(count-c:count,1) = sortFI(count-c-1+partSortFI,1);
    end
    k = k + 1;
end

clear count c ind partSortFI

% 4.3) Generate Graph

fileID = fopen([folderID,'/OriginalGraph.tex'],'w');
writeGraph(folderID,fileID,TCFIlist,TClabel,TCclass,TCnum,TCtext,sortTC,FIlabel,FItext,FIclass,FInum,sortFI,maxlinesize);
fclose(fileID);

% 5) Generate Modified Graph -----------------------------------------------------------------------

switch 2

    case 1
    
    % 5.1) Order TCs and FIs according to labels

        TCmax = max(TCnum(:,2));
        [~,sortTC] = sort(TCnum(:,1)+1/2/TCmax*TCnum(:,2));
        FImax = max(FInum(:,2));
        [~,sortFI] = sort(FInum(:,1)+1/2/FImax*FInum(:,2));

        clear TCmax FImax

        fileID = fopen([folderID,'/NumOrderedGraph.tex'],'w');
        writeGraph(folderID,fileID,TCFIlist,TClabel,TCclass,TCnum,TCtext,sortTC,FIlabel,FItext,FIclass,FInum,sortFI,maxlinesize);
        fclose(fileID);

    case 2

    % 5.2) Order TCs and FIs according to graph optimization
        
        TCs = unique(TCnum(:,1));
        FIs = unique(FInum(:,1));
        adjMatrix = zeros(size(TCs,1),size(FIs,1));
        for k = 1:size(TCFIlist,1)
            for i = 1:size(TCs,1)
                if TCs(i,1) == TCFIlist(k,1)
                    for j = 1:size(FIs,1)
                        if FIs(j,1) == TCFIlist(k,3)
                            adjMatrix(i,j) = 1;
                        end
                    end
                end
            end
        end
        [sortTCs,sortFIs] = bipartiteBarycenter(adjMatrix,1000);

        % Compose full TC and FI lists
        
        sortTC = 0 * TCnum(:,1);
        k = 0;
        for s = TCs(sortTCs,1)'
            I = [];
            TCsubnum = [];
            for i = 1:size(TCnum,1)
                if TCnum(i,1) == s
                    I = [I ; i];
                    TCsubnum = [TCsubnum ; [TCnum(i,2)]];
                end
            end
            [~,S] = sort(TCsubnum);
            for i = 1:size(S,1)
                k = k + 1;
                sortTC(k,1) = I(S(i,1),1);
            end
        end
        
        sortFI = 0*FInum(:,1);
        k = 0;
        for s = FIs(sortFIs,1)'
            I = [];
            FIsubnum = [];
            for i = 1:size(FInum,1)
                if FInum(i,1) == s
                    I = [I ; i];
                    FIsubnum = [FIsubnum ; [FInum(i,2)]];
                end
            end
            [~,S] = sort(FIsubnum);
            for i = 1:size(S,1)
                k = k + 1;
                sortFI(k,1) = I(S(i,1),1);
            end
        end
        
        clear TCs sortTCs TCsubnum FIs sortFIs FIsubnum s S i I

        fileID = fopen([folderID,'/OptimizedGraph.tex'],'w');
        writeGraph(folderID,fileID,TCFIlist,TClabel,TCclass,TCnum,TCtext,sortTC,FIlabel,FItext,FIclass,FInum,sortFI,maxlinesize);
        fclose(fileID);

end
