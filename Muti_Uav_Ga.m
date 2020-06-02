function [ globel ] = Muti_Uav_Ga(model )
%����Ⱦɫ��
%123
model.endp =[model.ex,model.ey,model.ez];
my_chromosome.pos=[];
my_chromosome.alpha=[];
my_chromosome.beta=[];
my_chromosome.atkalpha=[];
my_chromosome.atkbeta=[];
my_chromosome.T=[];
my_chromosome.sol=[];
my_chromosome.cost=[];
my_chromosome.costs=[];
my_chromosome.ETA=[];
my_chromosome.IsFeasible=[];
my_chromosome.initialized_uav=[];
my_chromosome.Paths=[];
%��ʼȾɫ�����
chromosome = repmat(my_chromosome,model.NP,1);
%�Ӵ�Ⱦɫ��
next_chromosome = repmat(my_chromosome,model.NP,1);
%����Ⱦɫ��
AllChromosome = repmat(my_chromosome,model.NP*2,1);
%��Ⱥ����Ӧ��ֵ
seeds_fitness=zeros(1,model.NP);
%�ֲ�����
local =repmat(my_chromosome,model.UAV,1);
for uav=1:model.UAV
local(uav).cost =inf;
end
globel.cost =inf;
%��Ⱥ��ʼ��
h= waitbar(0,'initial chromosome');
for i=1:model.NP
  chromosome(i).initialized_uav=zeros(model.UAV,1);
  while sum(chromosome(i).initialized_uav) ~=model.UAV
  %��Ҫ��ʼ�������˻����
  index = find(chromosome(i).initialized_uav==0);
  %��ʼ���ǶȺ�ʱ��
  for j =1:numel(index)
  uav =index(j);
  [chromosome(i).alpha(:,uav),chromosome(i).T(:,uav),chromosome(i).beta(:,uav)] = InitialChromosome(model,i,uav);
  %���ݽǶȻ�ö�Ӧ����
  [chromosome(i).pos(:,:,uav)] = Angel2Pos(chromosome(i),model,uav);
  %�γɿ�ִ��·����,����ʵ�ʵ�·�����ܱ���ʼ��Ŀ���ֱ�߾���Զ,��������ʱ��T
   [chromosome(i).T(:,uav),chromosome(i).Paths(uav)] =Modify_Chromosom_T(chromosome(i),model,uav);
   %���¼����µ�pos
  [chromosome(i).pos(:,:,uav)] = Angel2Pos(chromosome(i),model,uav);
  %�������˻���·�Ƿ����
  [flag,chromosome(i).atkalpha(uav),chromosome(i).atkbeta(uav)] = IsReasonble(chromosome(i),model,uav);
  chromosome(i).initialized_uav(uav)=flag;
  end
  %����Эͬ����Ҫ��
  max_length = max(chromosome(i).Paths);
  %�������ĺ�·��ΪЭͬʱ��
  chromosome(i).ETA = max_length / model.vel;
  end
  chromosome(i).IsFeasible =1;
  %����ÿ������Э�����������Ӧ��ֵ��ÿ����ľ���������
  [chromosome(i).cost,chromosome(i).sol,chromosome(i).costs] = FitnessFunction(chromosome(i),model);
  %��¼���н����Ӧ��ֵ����Ϊ���̶ĵļ���
  seeds_fitness(i) = chromosome(i).cost;
  h=waitbar(i/model.NP,h,[num2str(i),':chromosomes finished']);
  
end
close(h)
% for i=1:model.NP
% PlotSolution(chromosome(i).sol,model);
% end
%��ʼ��������
for it=1:model.MaxIt
    %�õ�����ƽ����Ӧ��ֵ
    model.f_max =max(seeds_fitness);
    model.f_avg =mean(seeds_fitness);
    %������Ӧ��ֵԽСԽ��
    seeds_fitness = 1./seeds_fitness;
    total_fitness = sum(seeds_fitness);
    seeds_probability = seeds_fitness/ total_fitness;
    %�����ۼƸ���
    seeds_accumulate_probability = cumsum(seeds_probability, 2);
    %�������̶�ѡ��ĸ,�ܹ�ѡ���NP���Ӵ�
    
    for seed=1:2:model.NP
    flag =0;
    %��֤��ĸ���Ӵ�������Ҫ��
    while flag~=1
    [parents,flag] = SelectChromosome(seeds_accumulate_probability,model,chromosome);
    %�ڸ�ĸȾɫ����л�������ͱ��������
    %����ñ�֤ÿ���Ӵ�������Լ������
    end
    
    papa=randi(model.UAV,1,1);
    if local(papa).cost~=inf && it <5
        parents(2) = local(papa);
    end
    [ sons] = CrossoverAndMutation( parents,model );
    
    %����Ҫ���Ժ�����Ӵ�����Ӧ��ֵ
    [sons(1).cost,sons(1).sol] = FitnessFunction(sons(1),model);
    [sons(2).cost,sons(2).sol] = FitnessFunction(sons(2),model);
    next_chromosome(seed) = (sons(1));
    next_chromosome(seed+1) = (sons(2));
    end
   %���¾ɺϲ�ͬһ��Ⱥ
    AllChromosome(1:model.NP) = chromosome(1:model.NP);
    AllChromosome(model.NP+1:model.NP*2) = next_chromosome(1:model.NP);
    %��Ӣ����,�¾���Ⱥһ��Ƚ�
    
    for i=1:model.NP*2
    eval_array(i,:) = [i,AllChromosome(i).cost];
    end
    %��cost��С�����������
    eval_array =sortrows(eval_array,2);
    last_cost=eval_array(1,2);
    cnt =1;
    chromosome(cnt) = AllChromosome(eval_array(1,1));
    %�´ε�����Ⱦɫ��Ϊ���ظ�cost������Ⱦɫ��
    for i=2:model.NP*2
        current_cost = eval_array(i,2);
        if current_cost ~= last_cost
        cnt = cnt+1;
        chromosome(cnt) = AllChromosome(eval_array(i,1));
        last_cost = current_cost;
        end
    end
    %����´ε�����Ⱦɫ����Ŀ�������͸������̶Ĳ�Ⱦɫ�塣
    cnt_r =cnt;
    while cnt <model.NP
        cnt= cnt+1;
        chromosome(cnt) = AllChromosome(eval_array(cnt - cnt_r,1));
    end
    %ѡ��������Ⱦɫ���ȫ������Ⱦɫ��
    for index =1:model.NP
        seeds_fitness(index) =chromosome(index).cost; 
        for uav=1:model.UAV
            if local(uav).cost >chromosome(index).costs(uav)
                local(uav) = chromosome(index);
                local(uav).cost =chromosome(index).costs(uav);
            end
        end
        %ȫ������
        if globel.cost >chromosome(index).cost
            globel =chromosome(index);
        end
    end

    best(it) = globel.cost;

     disp(['it: ',num2str(it),'   best value:',num2str(globel.cost)]);
    
    
    
end
PlotSolution(globel.sol,model )
figure;
plot(best);
end


