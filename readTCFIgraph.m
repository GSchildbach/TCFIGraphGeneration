% Georg Schildbach, 13/May/2026
% SOTIF --- Read TCFI Graph
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

function [TCnum,TClabel,TCtext,TCclass,FInum,FIlabel,FItext,FIclass,TCFIlist] = readTCFIgraph(folderID,fileID)

% 1) Inputs ----------------------------------------------------------------------------------------

% Alphabet for sub-enumeration of TCs and FIs (also defining the order)

Alphabet = 'aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ';

% 2) Initialize ------------------------------------------------------------------------------------

foundTC = 0; % number of TCs found
foundFI = 0; % number of FIs found
edges = 0; % number of egdes
TClabel = [];
FIlabel = [];
TCtext = [];
FItext = [];

eof = false;

while ~eof

    currentLine = fgetl(fileID);  % returns string or "-1" if end of file is reached
    sizeLine = size(currentLine,2);
    if isnumeric(currentLine)
        if currentLine == -1
            eof = true;
        end
    else

% 3) Detect TCs ------------------------------------------------------------------------------------

    pos1 = strfind(currentLine,'#TC');

    if ~isempty(pos1)
        foundTC = foundTC + 1;

        % 3.1) Read TC Number

        pos1 = pos1 + 3;
        pos2 = pos1;
        str = currentLine(pos2);
        if isempty(str2num(currentLine(pos2)))  % TC is unnumbered
            % do something
        else                                    % TC is numbered
            while ~isempty(str2num(currentLine(pos2)))
                pos2 = pos2 + 1;
                if pos2 > size(currentLine,2)
                    break
                else
                    str = currentLine(pos2);
                end
            end
            TCnum(foundTC,1) = str2num(currentLine(pos1:pos2-1));
            if pos2 <= size(currentLine,2)
                [c,n] = ismember(currentLine(pos2),Alphabet);
                if c
                    TCnum(foundTC,2) = n;
                    TClabel = [TClabel,string(currentLine(pos1-2:pos2))];
                else
                    TCnum(foundTC,2) = 0;
                    TClabel = [TClabel,string(currentLine(pos1-2:pos2-1))];
                end
            else
                TCnum(foundTC,2) = 0;
                TClabel = [TClabel,string(currentLine(pos1-2:pos2-1))];
            end
                

            pos1 = pos2;
        end

        % 3.2) Read TC Name

        while double(currentLine(pos2)) ~= char(34)
            pos2 = pos2 + 1;
            if pos2 > sizeLine
                if TCnum(foundTC,2) == 0
                    error(['Name of TC ',num2str(foundTC,'%i'),' could not be identified.'])
                else
                    error(['Name of TC ',num2str(foundTC,'%i'),currentLine(pos1),' could not be identified.'])
                end
                break
            end
        end
        pos2 = pos2 + 1;
        pos1 = pos2;
        while double(currentLine(pos2)) ~= char(34)
            pos2 = pos2 + 1;
            if pos2 > sizeLine
                if TCnum(foundTC,2) == 0
                    error(['Name of TC ',num2str(foundTC,'%i'),' could not be identified.'])
                else
                    error(['Name of TC ',num2str(foundTC,'%i'),currentLine(pos1),' could not be identified.'])
                end
                break
            end
        end
        if pos2 > pos1 - 1
            TCtext = [TCtext,string(currentLine(pos1:pos2-1))];
        else
            error(['Name of TC ',num2str(foundTC,'%i'),currentLine(pos1),' could not be identified.'])
        end

        % 3.3) Read TC Class

        pos1 = strfind(currentLine,'TCclass');
        
        if isempty(pos1)
            if TCnum(foundTC,2) == 0
                error(['Class of TC ',num2str(foundTC,'%i'),' could not be identified.'])
            else
                error(['Class of TC ',num2str(foundTC,'%i'),currentLine(pos1),' could not be identified.'])
            end
        else
            pos1 = pos1 + 7;
            pos2 = pos1;
            str = currentLine(pos2);
            if isempty(str2num(currentLine(pos2)))  % no TC class is given
                TCclass(foundTC,1) = 0;
            else                                    % TC class is given
                while ~isempty(str2num(currentLine(pos2)))
                    pos2 = pos2 + 1;
                    if pos2 > size(currentLine,2)
                        break
                    else
                        str = currentLine(pos2);
                    end
                end
                TCclass(foundTC,1) = str2num(string(currentLine(pos1:pos2-1)));
            end
        end
    
    end

% 4) Detect FIs ------------------------------------------------------------------------------------

    pos1 = strfind(currentLine,'#FI');

    if ~isempty(pos1)
        foundFI = foundFI + 1;

        % 4.1) Read FI Number

        pos1 = pos1 + 3;
        pos2 = pos1;
        str = currentLine(pos2);
        if isempty(str2num(currentLine(pos2)))  % FI is unnumbered
            % do something
        else                                    % FI is numbered
            while ~isempty(str2num(currentLine(pos2)))
                pos2 = pos2 + 1;
                if pos2 > size(currentLine,2)
                    break
                else
                    str = currentLine(pos2);
                end
            end
            FInum(foundFI,1) = str2num(currentLine(pos1:pos2-1));
            if pos2 <= size(currentLine,2)
                [c,n] = ismember(currentLine(pos2),Alphabet);
                if c
                    FInum(foundFI,2) = n;
                    FIlabel = [FIlabel,string(currentLine(pos1-2:pos2))];
                else
                    FInum(foundFI,2) = 0;
                    FIlabel = [FIlabel,string(currentLine(pos1-2:pos2-1))];
                end
            else
                FInum(foundFI,2) = 0;
                FIlabel = [FIlabel,string(currentLine(pos1-2:pos2-1))];
            end    
            pos1 = pos2;
        end

        % 4.2) Read FI Name

        while double(currentLine(pos2)) ~= char(34)
            pos2 = pos2 + 1;
            if pos2 > sizeLine
                if FInum(foundFI,2) == 0
                    error(['Name of FI ',num2str(foundFI,'%i'),' could not be identified.'])
                else
                    error(['Name of FI ',num2str(foundFI,'%i'),currentLine(pos1),' could not be identified.'])
                end
                break
            end
        end
        pos2 = pos2 + 1;
        pos1 = pos2;
        while double(currentLine(pos2)) ~= char(34)
            pos2 = pos2 + 1;
            if pos2 > sizeLine
                if FInum(foundFI,2) == 0
                    error(['Name of FI ',num2str(foundFI,'%i'),' could not be identified.'])
                else
                    error(['Name of FI ',num2str(foundFI,'%i'),currentLine(pos1),' could not be identified.'])
                end
                break
            end
        end
        if pos2 > pos1 - 1
            FItext = [FItext,string(currentLine(pos1:pos2-1))];
        else
            error(['Name of FI ',num2str(foundFI,'%i'),currentLine(pos1),' could not be identified.'])
        end

        % 4.3) Read FI Class

        pos1 = strfind(currentLine,'FIclass');
        
        if isempty(pos1)
            if FInum(foundFI,2) == 0
                error(['Class of FI ',num2str(foundFI,'%i'),' could not be identified.'])
            else
                error(['Class of FI ',num2str(foundFI,'%i'),currentLine(pos1),' could not be identified.'])
            end
        else
            pos1 = pos1 + 7;
            pos2 = pos1;
            str = currentLine(pos2);
            if isempty(str2num(currentLine(pos2)))  % no FI class is given
                FIclass(foundFI,1) = 0;
            else                                    % FI class is given
                while ~isempty(str2num(currentLine(pos2)))
                    pos2 = pos2 + 1;
                    if pos2 > size(currentLine,2)
                        break
                    else
                        str = currentLine(pos2);
                    end
                end
                FIclass(foundFI,1) = str2num(currentLine(pos1:pos2-1));
            end
        end
    
    end

% 5) Detect Edges ----------------------------------------------------------------------------------
    
    pos1 = strfind(currentLine,'-->');

    if ~isempty(pos1)
        edges = edges + 1;

        % 5.1) Identify Related TC

        pos2 = strfind(currentLine,'TC');
        if or(size(pos2,2)>1,isempty(pos2))
            pos2 = strfind(currentLine,'*');
            if pos2 < pos1
                TCFIlist(edges,1:2) = [0, 0];
            else
                error('No (unique) TC could be identified one of the edges!')
            end
        else
            pos2 = pos2 + 2;
            pos3 = pos2;
            str = currentLine(pos2);
            if isempty(str2num(currentLine(pos2)))  % TC is unnumbered
                error('TC number is missing for one of the edges!')
            else                                    % TC is numbered
                while ~isempty(str2num(currentLine(pos3)))
                    pos3 = pos3 + 1;
                    if pos3 > size(currentLine,2)
                        break
                    else
                        str = currentLine(pos3);
                    end
                end
                TCFIlist(edges,1) = str2num(currentLine(pos2:pos3-1));
                if pos3 <= size(currentLine,2)
                    [c,n] = ismember(currentLine(pos3),Alphabet);
                    if c
                        TCFIlist(edges,2) = n;
                    else
                        TCFIlist(edges,2) = 0;
                    end
                else
                    TCFIlist(edges,2) = 0;
                end 
            end
        end

        % 5.2) Identify Related FI
        
        pos2 = strfind(currentLine,'FI');
        if or(size(pos2,2)>1,isempty(pos2))
            pos2 = strfind(currentLine,'*');
            if pos2 > pos1
                TCFIlist(edges,3:4) = [0, 0];
            else
                error('No (unique) FI could be identified one of the edges!')
            end
        else
            pos2 = pos2 + 2;
            pos3 = pos2;
            str = currentLine(pos2);
            if isempty(str2num(currentLine(pos2)))  % FI is unnumbered
                error('FI number is missing for one of the edges!')
            else                                    % FI is numbered
                while ~isempty(str2num(currentLine(pos3)))
                    pos3 = pos3 + 1;
                    if pos3 > size(currentLine,2)
                        break
                    else
                        str = currentLine(pos3);
                    end
                end
                TCFIlist(edges,3) = str2num(currentLine(pos2:pos3-1));
                if pos3 <= size(currentLine,2)
                    [c,n] = ismember(currentLine(pos3),Alphabet);
                    if c
                        TCFIlist(edges,4) = n;
                    else
                        TCFIlist(edges,4) = 0;
                    end
                else
                    TCFIlist(edges,4) = 0;
                end

            end
        end

    end

% 6) Finalize --------------------------------------------------------------------------------------


    end
end

return