function [r]=terrain(x,y)


global wi;
global di;
global zcubic;
%�õ�ĳһ��߶�
r=interp2(wi,di,zcubic,x,y);