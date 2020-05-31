function [ sons ] = CrossoverAndMutation( parents,model )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    %����Ⱥ�����ѡ��������ĸ����֤��ĸ����ͬһȾɫ��
    %һ������NP/2��ѡ��
%     %���ÿյĻ���׼���洢�����Ļ���
     gene_alpha = zeros(model.dim,model.UAV,2);
     gene_beta = zeros(model.dim,model.UAV,2);
     gene_t = zeros(model.dim,model.UAV,2);
     
     flag =zeros(2,1);   
     %������������,��ӵĻ�����ڸ�ĸ�Ļ���
     sons(1) = parents(1);
     sons(2) = parents(2);
%      %���ѡȡ����ϵ�λ��
%      BreakPos = floor(unifrnd(1,model.dim-1,1));
     %ͬʱ��ȡ�����鸸ĸ�Ļ���,��Ϊ������м����
     for j=1:2
     gene_alpha(:,:,j) = parents(j).alpha;
     gene_beta(:,:,j) = parents(j).beta;
     gene_t(:,:,j) =parents(j).T;
     end
     %����������
      if model.cross_prob > rand
         %�����������������a(0,1);
         %x1(t+1) = a*x1(t)+(1-a)x2(t)
         %x2(t+1) = a*x2(t)+(1-a)x1(t)
           %��������ֱ𽻲�
           cross_prob = 0.8;
           sons(1).alpha =  cross_prob*gene_alpha(:,:,1)+(1-cross_prob)*gene_alpha(:,:,2);
           sons(2).alpha =  cross_prob*gene_alpha(:,:,2)+(1-cross_prob)*gene_alpha(:,:,1);
           sons(1).beta =  cross_prob*gene_beta(:,:,1)+(1-cross_prob)*gene_beta(:,:,2);
           sons(2).beta =  cross_prob*gene_beta(:,:,2)+(1-cross_prob)*gene_beta(:,:,1);
           sons(1).T     =  cross_prob*gene_t(:,:,1)+(1-cross_prob)*gene_t(:,:,2);
           sons(2).T     =  cross_prob*gene_t(:,:,2)+(1-cross_prob)*gene_t(:,:,1);
           %��������Լ����Χ
           [sons(1).alpha,sons(1).beta,sons(1).T] = Constrain(sons(1).alpha,sons(1).beta,sons(1).T,model);
           [sons(2).alpha,sons(2).beta,sons(2).T] = Constrain(sons(2).alpha,sons(2).beta,sons(2).T,model);
      end
     %%���µĻ�����б������
     for j=1:2
     [sons(j).alpha,sons(j).beta,sons(j).T] = Mutation(sons(j),model);
     [sons(j).alpha,sons(j).beta,sons(j).T] = Constrain(sons(j).alpha,sons(j).beta,sons(j).T,model);
     end
     %�ж������Ӵ����»����Ƿ����,������������ѡ��ĸ�����ӽ�
     
    for j=1:2
    for uav=1:model.UAV
    [sons(j).pos(:,:,uav)] = Angel2Pos(sons(j),model,uav);
    [flag(j),sons(j).atkalpha,sons(j).atkbeta] = IsReasonble(sons(j),model,uav);
    %�γɿ�ִ��·����,����ʵ�ʵ�·�����ܱ���ʼ��Ŀ���ֱ�߾���Զ,��������ʱ��T
   [sons(j).T(:,uav),sons(j).Paths(uav)] =Modify_Chromosom_T(sons(j),model,uav);
    end
    sons(j).IsFeasible = (sum(flag)==model.UAV);
    max_length = max(sons(j).Paths);
    sons(j).ETA=max_length/model.vel;
    end
    %����������е��Ӵ�������Լ����ֱ�ӷ��ظ�ĸ(Ϊ�˱��������),����0
    for i=1:2
       if sons(i).IsFeasible~=1 
           sons(i) = parents(i);
       end      
    end
    
end

