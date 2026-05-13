% Georg Schildbach, 31/May/2026
% SOTIF --- Generate TCFI Graph according to specified ordering
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

function writeGraph(folderID,fileID,TCFIlist,TClabel,TCclass,TCnum,TCtext,sortTC,FIlabel,FItext,FIclass,FInum,sortFI,maxlinesize);

% 1) Inputs ----------------------------------------------------------------------------------------

total_vertical_space = 260;     % total vertical space
page_width = 150;               % page width
vertical_space_per_line = 2.0;  % vertical spaces needed by one line of text
paragraph_skip = 0.5;           % vertical spaces skipped between paragraphs of same TC/FI
paragraph_skip_new = 0.7;       % vertical spaces skipped between paragraphs of new TC/FI

% 2) Header ----------------------------------------------------------------------------------------

fprintf(fileID,'\\setlength{\\tabcolsep}{0.1pt}\n');
fprintf(fileID,'\\renewcommand{\\baselinestretch}{0.9}\n');
fprintf(fileID,'\\renewcommand{\\arraystretch}{1.4}\n');
fprintf(fileID,['\\begin{pspicture}(0,0)(',num2str(page_width,'%.2f'),',',num2str(total_vertical_space,'%.2f'),')\n']);
fprintf(fileID,'\\tiny\n');

% 3) Determine Spacings ----------------------------------------------------------------------------

% 3.1) Determine TC spacings

t = 1;
lines = ceil(size(char(TCtext(1,t)),2)/maxlinesize);
TCspace = [TCnum(t,1) , paragraph_skip_new + vertical_space_per_line*lines];
while t < size(TCnum,1)
    t = t + 1;
    newTC = true;
    for k = 1:size(TCspace,1)
        if TCnum(t,1) == TCspace(k,1)
            newTC = false;
            T = k;
        end
    end
    if newTC
        lines = ceil(size(char(TCtext(1,t)),2)/maxlinesize);
        TCspace = [TCspace ; [TCnum(t,1) , paragraph_skip_new + vertical_space_per_line*lines]];
    else
        lines = ceil(size(char(TCtext(1,t)),2)/maxlinesize);
        TCspace(T,2) = TCspace(T,2) + paragraph_skip + vertical_space_per_line*lines;
    end
end
freeSpace = total_vertical_space - sum(TCspace(:,2));       % total vertical space
TCskip = freeSpace / (size(TCspace,1)-1);  % vertical space between two TCs
if TCskip < 0
    error('Too little vertical space available for TCs in the graph.')
end

% 3.2) Determine FI spacings

f = 1;
lines = ceil(size(char(FItext(1,f)),2)/maxlinesize);
FIspace = [FInum(f,1) , paragraph_skip_new + vertical_space_per_line*lines];
while f < size(FInum,1)
    f = f + 1;
    newFI = true;
    for k = 1:size(FIspace,1)
        if FInum(f,1) == FIspace(k,1)
            newFI = false;
            F = k;
        end
    end
    if newFI
        lines = ceil(size(char(FItext(1,f)),2)/maxlinesize);
        FIspace = [FIspace ; [FInum(f,1) , paragraph_skip_new + vertical_space_per_line*lines]];
    else
        lines = ceil(size(char(FItext(1,f)),2)/maxlinesize);
        FIspace(F,2) = FIspace(F,2) + paragraph_skip + vertical_space_per_line*lines;
    end
end
freeSpace = total_vertical_space - sum(FIspace(:,2));       % total vertical space
FIskip = freeSpace / (size(FIspace,1)-1);  % vertical space between two TCs
if FIskip < 0
    error('Too little vertical space available for TCs in the graph.')
end

% 4) Generate TC Nodes -----------------------------------------------------------------------------

s = total_vertical_space;
k = 1;
while k <= size(TCnum,1)
    t = TCnum(sortTC(k),1);
    switch TCclass(sortTC(k),1)
        case 1 
            fprintf(fileID,['\\rput[tl](0,',num2str(s,'%.2f'),'){\\psframebox[fillstyle=solid,fillcolor=cRed,framesep=2pt,cornersize=absolute,linearc=2pt]{\\begin{tabular}{R{4cm}R{1.1cm}}']);
        case 2
            fprintf(fileID,['\\rput[tl](0,',num2str(s,'%.2f'),'){\\psframebox[fillstyle=solid,fillcolor=cYellow,framesep=2pt,cornersize=absolute,linearc=2pt]{\\begin{tabular}{R{4cm}R{1.1cm}}']);
        case 3 
            fprintf(fileID,['\\rput[tl](0,',num2str(s,'%.2f'),'){\\psframebox[fillstyle=solid,fillcolor=cGreen,framesep=2pt,cornersize=absolute,linearc=2pt]{\\begin{tabular}{R{4cm}R{1.1cm}}']);
        case 4
            fprintf(fileID,['\\rput[tl](0,',num2str(s,'%.2f'),'){\\psframebox[fillstyle=solid,fillcolor=cViolet,framesep=2pt,cornersize=absolute,linearc=2pt]{\\begin{tabular}{R{4cm}R{1.1cm}}']);
    end
    c = char(TCtext(1,sortTC(k)));
    for i = 1:ceil(size(c,2)/maxlinesize)
        p1 = (i-1)*maxlinesize + 1;
        p2 = min(i*maxlinesize,size(c,2));
        if i < ceil(size(c,2)/maxlinesize)
            fprintf(fileID,[c(1,p1:p2),'\\linebreak ']);
        else
            fprintf(fileID,[c(1,p1:p2)]);
        end
    end
    fprintf(fileID,[' & (',char(TClabel(1,sortTC(k),1)),')\\Rnode{',char(TClabel(1,sortTC(k),1)),'}{\\hspace*{0.01mm}}']);     
    s = s - paragraph_skip_new - vertical_space_per_line*ceil(size(c,2)/maxlinesize);
    k = k + 1;
    while k <= size(TCnum,1)
        if t == TCnum(sortTC(k),1)
            fprintf(fileID,'\\\\\n');
            c = char(TCtext(1,sortTC(k)));
            for i = 1:ceil(size(c,2)/maxlinesize)
                p1 = (i-1)*maxlinesize + 1;
                p2 = min(i*maxlinesize,size(c,2));
                if i < ceil(size(c,2)/maxlinesize)
                    fprintf(fileID,[c(1,p1:p2),'\\linebreak ']);
                else
                    fprintf(fileID,[c(1,p1:p2)]);
                end
            end
            fprintf(fileID,[' & (',char(TClabel(1,sortTC(k),1)),')\\Rnode{',char(TClabel(1,sortTC(k),1)),'}{\\hspace*{0.01mm}}']);   
            s = s - paragraph_skip - vertical_space_per_line*ceil(size(c,2)/maxlinesize);
            k = k + 1;
        else
            break
        end
    end
    fprintf(fileID,'\\end{tabular}}}\n');
    s = s - TCskip;
end

% 5) Generate FI Nodes -----------------------------------------------------------------------------

s = total_vertical_space;
k = 1;
while k <= size(FInum,1)
    f = FInum(sortFI(k),1);
    switch FIclass(sortFI(k),1)
        case 1 
            fprintf(fileID,['\\rput[tl](100,',num2str(s,'%.2f'),'){\\psframebox[fillstyle=solid,fillcolor=cGray,framesep=2pt,cornersize=absolute,linearc=2pt]{\\begin{tabular}{L{1.1cm}L{4cm}} \\Rnode{',char(FIlabel(1,sortFI(k),1)),'}{\\hspace*{0.01mm}}(',char(FIlabel(1,sortFI(k),1)),') & ']);
        case 2
            fprintf(fileID,['\\rput[tl](100,',num2str(s,'%.2f'),'){\\psframebox[fillstyle=solid,fillcolor=cBlue,framesep=2pt,cornersize=absolute,linearc=2pt]{\\begin{tabular}{L{1.1cm}L{4cm}} \\Rnode{',char(FIlabel(1,sortFI(k),1)),'}{\\hspace*{0.01mm}}(',char(FIlabel(1,sortFI(k),1)),') & ']);
    end
    c = char(FItext(1,sortFI(k)));
    for i = 1:ceil(size(c,2)/maxlinesize)
        p1 = (i-1)*maxlinesize + 1;
        p2 = min(i*maxlinesize,size(c,2));
        if i < ceil(size(c,2)/maxlinesize)
            fprintf(fileID,[c(1,p1:p2),'\\linebreak ']);
        else
            fprintf(fileID,[c(1,p1:p2)]);
        end
    end    
    s = s - paragraph_skip_new - vertical_space_per_line*ceil(size(c,2)/maxlinesize);
    k = k + 1;
    while k <= size(FInum,1)
        if f == FInum(sortFI(k),1);
            fprintf(fileID,'\\\\\n');
            fprintf(fileID,['\\Rnode{',char(FIlabel(1,sortFI(k),1)),'}{\\hspace*{0.01mm}}(',char(FIlabel(1,sortFI(k),1)),') & ']);
            c = char(FItext(1,sortFI(k)));
            for i = 1:ceil(size(c,2)/maxlinesize)
                p1 = (i-1)*maxlinesize + 1;
                p2 = min(i*maxlinesize,size(c,2));
                if i < ceil(size(c,2)/maxlinesize)
                    fprintf(fileID,[c(1,p1:p2),'\\linebreak ']);
                else
                    fprintf(fileID,[c(1,p1:p2)]);
                end
            end 
            s = s - paragraph_skip - vertical_space_per_line*ceil(size(c,2)/maxlinesize);
            k = k + 1;
        else
            break
        end
    end
    fprintf(fileID,'\\end{tabular}}}\n');
    s = s - FIskip;
end

% 6) Generate Edges --------------------------------------------------------------------------------

for k = 1:size(TCFIlist,1)

    % 6.1) Find TC

    indTC = 0;
    for i = 1:size(TCnum,1)
        if and(TCnum(i,1)==TCFIlist(k,1),TCnum(i,2)==TCFIlist(k,2))
            t = i;
            indTC = 1;
        end
    end

    % 6.2) Find FI
    
    indFI = 0;
    for i = 1:size(FInum,1)
        if and(FInum(i,1)==TCFIlist(k,3),FInum(i,2)==TCFIlist(k,4))
            f = i;
            indFI = 1;
        end
    end

    % 6.3) Genereate edge

    if and(indTC==1,indFI==1)
        fprintf(fileID,['\\ncline[nodesep=1pt]{*-*}{',char(TClabel(1,t)),'}{',char(FIlabel(1,f)),'}\n']);
    end

end

% 7) Footer ----------------------------------------------------------------------------------------

fprintf(fileID,'\\end{pspicture}');
return