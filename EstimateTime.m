function [ flag,ETA ] = EstimateTime( chromosome,model )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %���˻�Эͬʱ����ָÿ����·����ETAʱ���ڿ��Դ���ʼ�㵽Ŀ���
    
    Tmax=zeros(1,model.UAV);
    Tmin=zeros(1,model.UAV);
    for uav=1:model.UAV
       
       %�����uav����·�ĳ���,������ʱ�䷶Χ
       x=model.sx(uav);
       y=model.sy(uav);
       z =model.sz(uav);
       for i=1:model.dim
           x =[x chromosome.pos(i,1,uav)];
           y = [y chromosome.pos(i,2,uav)];
           z = [z chromosome.pos(i,3,uav)];
       end
       x= [x model.ex];
       y= [y model.ey];
       z= [z model.ez];
%         %������ʼ�㵽��һ����������һ�����򵽽��������
%         start2gene =norm( [model.sx(uav)-chromosome.pos(1,uav).x,model.sy(uav)-chromosome.pos(1,uav).y] );
%         
%         end2gene = norm( [model.sx(uav)-chromosome.pos(model.dim,uav).x,model.sy(uav)-chromosome.pos(model.dim,uav).y] );
%         L(uav) = L(uav) + start2gene + end2gene;
        dx = diff(x);
        dy = diff(y);
        dz = diff(z);
        Length = sum(sqrt(dx.^2+dy.^2+dz.^2));
        Tmax(uav) = Length/ model.vrange(1);
        Tmin(uav) = Length/ model.vrange(2);
        
    end
    %ȡʱ��Ľ���
        tmin  =max(Tmin);
        tmax  =min(Tmax);
      if tmin>tmax
          flag=0;
          ETA=0;
      else
          flag = 1;
          ETA  = (tmin+tmax)/2;
      end
end

