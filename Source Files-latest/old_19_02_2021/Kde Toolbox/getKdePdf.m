function data=getKdePdf(data)

data.Kde=[];
data.Kdexi=[];
data.Kdeyi=[];

% since T2 and Q are orthogonal take it independintly
[pdfT2 xi]= ksdensity(data.T2);
[pdfQ yi]= ksdensity(data.Q);

% Create 2-d grid of coordinates and function values, suitable for 3-d plotting
[data.Kdexi,data.Kdeyi] = meshgrid(xi,yi);
[pdfT2,pdfQ] = meshgrid(pdfT2,pdfQ);

% Calculate combined pdf
data.Kde = pdfT2.*pdfQ; 