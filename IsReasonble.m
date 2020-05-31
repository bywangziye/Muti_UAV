function [ flag,AttackAlpha,AttackBeta] = IsReasonble( chromosome,model,uav )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%��麽·�Ƿ����
%λ������Խ����ú�·������Ҫ����������
sum_alpha =zeros(1,model.UAV);
sum_beta =zeros(1,model.UAV);
flag=0;
   for i=1:model.dim
      if  chromosome.pos(i,1,uav) <model.Xmin || chromosome.pos(i,1,uav)<0 || ...
          chromosome.pos(i,2,uav)<model.Ymin || chromosome.pos(i,2,uav)>model.Ymax||...
          chromosome.pos(i,3,uav)<model.Zmin || chromosome.pos(i,3,uav) > model.Zmax
          AttackAlpha=0;
          AttackBeta =0;
          flag =0;
          return
      end
   end

   
  %�������ƫ���ܷ����Ҫ��
     %��·���һ����
   lastpoint=[chromosome.pos(model.dim,1,uav),chromosome.pos(model.dim,2,uav),chromosome.pos(model.dim,3,uav)];
   endpoint =[model.ex,model.ey,model.ez];
   last2end = endpoint -lastpoint;
   
  %��������ƫ�Ƿ�������һ���㵽�յ�ķ���ļн�
   %�ֱ���㺽ƫ�Ǻ͸����� 
   for i=1:model.dim
      sum_alpha(uav) =sum_alpha(uav) + chromosome.alpha(i,uav);
      sum_beta(uav)  = sum_beta(uav) + chromosome.beta(i,uav);
   end
   
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
   %�Ƕ�ת������
    sum_alpha(uav) = sum_alpha(uav) + st_alpha;
    sum_beta(uav) = sum_beta(uav) +st_beta;
    sum_alpha(uav) = deg2rad(sum_alpha(uav));
    sum_beta(uav) = deg2rad(sum_beta(uav));
    %�ܵĺ�ƫ�ǵķ�������
    lastdeg =[cos(sum_alpha(uav)),sin(sum_alpha(uav))];
    %ͶӰ��XOY���㺽ƫ�ǵ����仯ֵ
    theta = rad2deg(acos(dot(last2end(1:2),lastdeg)/norm(last2end(1:2))/norm(lastdeg)));
    %����last2end�ĸ�����
    ag1 = rad2deg(asin(last2end(3)/norm(last2end)));
    %��last2end�ĸ����� - �ܵĸ����� = �����һ���㵽�յ�ĸ����Ǳ仯 
    ag2 =abs( ag1 - sum_beta(uav));
    %�������Ĺ�����
    AttackAlpha(uav) = rad2deg(acos(last2end(1)/norm(last2end(1:2))));
    AttackBeta(uav) = ag1;
    %����ָ�������Ǽ���ÿ����ƫ��ƽ�����ӵĽǶ�ֵ
%     average_value(uav) = (model.attack_alpha(uav) -  AttackAlpha(uav))/(model.dim+1);
  
    if theta >0 && theta < model.alpha_max &&...
       ag2 >0 && ag2 <model.beta_max
        flag=1;
    else
        flag= 0;
    end

%    %����ܷ�ﵽʱ���ϵ�Эͬ 
%   [flag_time ,ETA_r] =EstimateTime( chromosome,model ); 
%   %���߶�����˵���ý����Ҫ��
%   flag_r = flag_time ;
%   ETA =ETA_r;
%   index =flag;
end

