function [ p_global ] = Muti_GAPSO( model )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
my_chromosome.pos=[];
my_chromosome.alpha=[];
my_chromosome.beta=[];
my_chromosome.atkalpha=[];
my_chromosome.atkbeta=[];
my_chromosome.sol=[];
my_chromosome.cost=[];
my_chromosome.T=[];
my_chromosome.IsFeasible=[];
my_chromosome.vel=[];
my_chromosome.ETA=[];
my_chromosome.best.pos=[];
my_chromosome.best.alpha=[];
my_chromosome.best.beta=[];
my_chromosome.best.T=[];
my_chromosome.best.sol=[];
my_chromosome.best.cost=[];

%��ʼȾɫ�����
chromosome = repmat(my_chromosome,model.NP,1);
%�Ӵ�Ⱦɫ��
next_chromosome = repmat(my_chromosome,model.NP,1);

%��Ⱥ����Ӧ��ֵ
seeds_fitness=zeros(1,model.NP);
%ȫ������
p_global.cost=inf;
%��Ӧ������ֵ����
best=zeros(model.MaxIt+1,1);
best(1)=model.globel.cost;
%��Ⱥ��ʼ��
for i=1:model.NP
    chromosome(i).pos=model.chromosome(i).pos;
    chromosome(i).alpha=model.chromosome(i).alpha;
    chromosome(i).beta=model.chromosome(i).beta;
    chromosome(i).atkalpha=model.chromosome(i).atkalpha;
    chromosome(i).atkbeta=model.chromosome(i).atkbeta;
    chromosome(i).T=model.chromosome(i).T;
    chromosome(i).sol=model.chromosome(i).sol;
    chromosome(i).cost=model.chromosome(i).cost;
    chromosome(i).IsFeasible=model.chromosome(i).IsFeasible;
    chromosome(i).ETA=model.chromosome(i).ETA;
  for d=1:3
  chromosome(i).vel(d,:,:)= zeros(1,model.dim,model.UAV);
  end
  %������ʷ��������
  chromosome(i).best.pos =chromosome(i).pos;
  chromosome(i).best.alpha =chromosome(i).alpha;
  chromosome(i).best.beta =chromosome(i).beta;
  chromosome(i).best.T =chromosome(i).T;
  chromosome(i).best.sol =chromosome(i).sol;
  chromosome(i).best.cost =chromosome(i).cost;
  %����ȫ����������
  if p_global.cost > chromosome(i).best.cost
    p_global = chromosome(i).best;
  end
  
end
seeds_fitness =zeros(1,model.NP);
for it=1:model.MaxIt
    %�õ�����ƽ����Ӧ��ֵ
   %������Ӧ�ȶ�Ⱦɫ������
    sort_array =zeros(model.NP,2);
    for i=1:model.NP
    sort_array(i,:)= [i,chromosome(i).cost];
    end
    %��cost��С�����������
    sort_array =sortrows(sort_array,2);
    model.p_global =p_global;
    %ֻ����ǰһ���Ⱦɫ��,��һ������
    for i=1:model.NP/2
           next_chromosome(i) =chromosome(sort_array(i,1));
           %���Ӹ����Ƿ����Ҫ��
           flag=zeros(1,model.UAV);
           while sum(flag)~=model.UAV
           index =find(flag==0);
           for j=1:numel(index)
           uav =index(j);
           %����Ⱦɫ����ٶȺ�λ��
           [next_chromosome(i).vel(:,:,uav),next_chromosome(i).alpha(:,uav),next_chromosome(i).beta(:,uav),next_chromosome(i).T(:,uav)]=Update_vel_pos( next_chromosome(i),model,uav );
           %ת��λ������
           [next_chromosome(i).pos(:,:,uav)]=Angel2Pos( next_chromosome(i),model,uav );
           %��麽·�Ƿ����
           [flag(uav),next_chromosome(i).atkalpha(uav),next_chromosome(i).atkbeta(uav)] = IsReasonble(next_chromosome(i),model,uav);
           end           
           end
           [next_chromosome(i).cost,next_chromosome(i).sol] = FitnessFunction(next_chromosome(i),model);
           seeds_fitness(i) =next_chromosome(i).cost;
    end
    %��ʣ���NP/2��Ⱦɫ�����ѡ�񽻲�������
    for i=model.NP/2+1:2:model.NP
        %���ѡ��ĸ
        model.f_max =max(seeds_fitness);
        model.f_avg =mean(seeds_fitness);
        parents =repmat(my_chromosome,2,1);
        for p=1:2
        array =ceil(rand(1,2)*model.NP/2);
        if next_chromosome(array(1)).cost < next_chromosome(array(2)).cost
            parents(p) = next_chromosome(array(1));
        else
            parents(p) = next_chromosome(array(2));
        end
        end
        %����������
        [ sons] = CrossoverAndMutation( parents,model );
        %����Ҫ���Ժ�����Ӵ�����Ӧ��ֵ
        [sons(1).cost,sons(1).sol] = FitnessFunction(sons(1),model);
        [sons(2).cost,sons(2).sol] = FitnessFunction(sons(2),model);
        next_chromosome(i) = sons(1);
        next_chromosome(i+1) =sons(2);
    end
    for i=1:model.NP
       chromosome(i) =next_chromosome(i);
       %���¾ֲ�����
       if chromosome(i).cost < chromosome(i).best.cost
              chromosome(i).best.pos =chromosome(i).pos;
              chromosome(i).best.alpha =chromosome(i).alpha;
              chromosome(i).best.beta =chromosome(i).beta;
              chromosome(i).best.T =chromosome(i).T;
              chromosome(i).best.sol =chromosome(i).sol;
              chromosome(i).best.cost =chromosome(i).cost;
       end
       %����ȫ������
       if chromosome(i).cost < p_global.cost
           p_global = chromosome(i);
       end
       seeds_fitness(i) =chromosome(i).cost;
    end
    best(it+1) = p_global.cost;
    p_global.best_plot =best;
    disp(['it: ',num2str(it),'   best value:',num2str(best(it))]);
    
end


end

