function [ pos ] = Angel2Pos( chromosome,model,uav )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%%�������˻�λ��


%������ʼ���е�ķ���    
     %������ʼ��Ŀ�������
   st = [model.ex-model.sx(uav),model.ey-model.sy(uav),model.ez-model.sz(uav)];
   %ˮƽ����
   vhorizontal=[1,0];
   %������ʼ��Ŀ��ĺ�ƫ��
    st_alpha = rad2deg( acos(dot(st(1:2),vhorizontal)/norm(st(1:2))/norm(vhorizontal) )  );
    %�������ֵС��0
    if st(2)/norm(st(1:2)) <0
        st_alpha =360 - st_alpha;        
    end
    %������ʼ��Ŀ��ĸ�����
    st_beta = rad2deg(asin(st(3)/norm(st)));
    
%��ʼ�������
last_pos=[model.sx(uav),model.sy(uav),model.sz(uav)];
acum_beta=cumsum(deg2rad( chromosome.beta(:,uav)));
acum_alpha=cumsum(deg2rad( chromosome.alpha(:,uav)));
%������ʼ�㵽Ŀ��ĳ���
acum_alpha =acum_alpha+deg2rad( st_alpha);
acum_beta =acum_beta + deg2rad(st_beta);
for i =1:model.dim

    
    
%�������������ʼλ��
beta =acum_beta(i);
%��ƫ���������ʼλ��
alpha = acum_alpha(i);
% a = chromosome.T(i,uav)*model.vel*cos(theta)*sin(alpha);
% d = chromosome.T(i,uav)*model.vel*sin(theta);
L = chromosome.T(i,uav)*model.vel;
dz = L*sin(beta);
dx = L*cos(beta)*cos(alpha);
dy = L*cos(beta)*sin(alpha);
next_pos =[last_pos(1)+dx,last_pos(2)+dy,last_pos(3)+dz];
%������һ�������
last_pos = next_pos;
%�������˻���λ������
pos(i,1) = last_pos(1);
pos(i,2) = last_pos(2);
pos(i,3) = last_pos(3);
end


end

