function Fl=joint2FocalLength(Tfk)

% TCP
t=setTransformation(Tfk, 7);
Ptcp=t(1:3,4);

% moving mirror
t=setTransformation(Tfk, 5);
Pmov=t(1:3,4);

Fl=norm(Ptcp-Pmov);