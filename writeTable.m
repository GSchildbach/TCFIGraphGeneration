% Georg Schildbach, 13/May/2026
% SOTIF --- Generate TCFI Table
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

function writeTable(folderID,fileID,TCFIlist,TClabel,TCclass,TCnum,TCtext,FIlabel,FItext,FIclass,FInum)

% 1) Header ----------------------------------------------------------------------------------------

fprintf(fileID,'\\centering\n');
fprintf(fileID,'\\renewcommand{\\arraystretch}{1.2}\n');
fprintf(fileID,'\\setlength{\\tabcolsep}{4pt}\n');
fprintf(fileID,'\\begin{longtable}{|p{8cm}|p{8cm}|}\n');
fprintf(fileID,'\\hline\n');
fprintf(fileID,'\\textbf{TC} & \\textbf{Triggered FI}\\\\\n');
fprintf(fileID,'\\hline\\hline\n');

% 2) Table Cells -----------------------------------------------------------------------------------

for k = 1:size(TCFIlist,1)
    for t = 1:size(TCnum,1)
        if and(TCnum(t,1)==TCFIlist(k,1),TCnum(t,2)==TCFIlist(k,2))
            break
        end
    end
    switch TCclass(t,1)
        case 1 
            fprintf(fileID,['\\cellcolor{cRed}(',char(TClabel(1,t)),') ',char(TCtext(1,t))]);
        case 2
            fprintf(fileID,['\\cellcolor{cYellow}(',char(TClabel(1,t)),') ',char(TCtext(1,t))]);
        case 3 
            fprintf(fileID,['\\cellcolor{cGreen}(',char(TClabel(1,t)),') ',char(TCtext(1,t))]);
        case 4
            fprintf(fileID,['\\cellcolor{cViolet}(',char(TClabel(1,t)),') ',char(TCtext(1,t))]);
    end
    for f = 1:size(FInum,1)
        if and(FInum(f,1)==TCFIlist(k,3),FInum(f,2)==TCFIlist(k,4))
            break
        end
    end
    switch FIclass(f,1)
        case 1 
            fprintf(fileID,['& \\cellcolor{cGray}(',char(FIlabel(1,f)),') ',char(FItext(1,f)),'\\\\\\hline\n']);
        case 2
            fprintf(fileID,['& \\cellcolor{cBlue}(',char(FIlabel(1,f)),') ',char(FItext(1,f)),'\\\\\\hline\n']);
    end
end

% 3) Footer ----------------------------------------------------------------------------------------

fprintf(fileID,'\\end{longtable}\n');

return