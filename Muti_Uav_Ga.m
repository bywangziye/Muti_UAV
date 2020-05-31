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
my_chromosome.ETA=[];
my_chromosome.IsFeasible=[];
my_chromosome.AllPos=[];
%��ʼȾɫ�����
chromosome = repmat(my_chromosome,model.NP,1);
%�Ӵ�Ⱦɫ��
next_chromosome = repmat(my_chromosome,model.NP,1);
%����Ⱦɫ��
AllChromosome = repmat(my_chromosome,model.NP*2,1);
%��Ⱥ����Ӧ��ֵ
seeds_fitness=zeros(1,model.NP);
%ȫ������
globel.cost =inf;
%��Ⱥ��ʼ��
tic;
h= waitbar(0,'initial chromosome');
for i=1:model.NP
  flag =0;  
  while flag ~=1
  %��ʼ���ǶȺ�ʱ��
  [chromosome(i).alpha,chromosome(i).T,chromosome(i).beta] = InitialChromosome(model,i);
  %���ݽǶȻ�ö�Ӧ����
  [chromosome(i).pos] = Angel2Pos(chromosome(i),model);
  %�γɿ�ִ��·����,����ʵ�ʵ�·�����ܱ���ʼ��Ŀ���ֱ�߾���Զ,��������ʱ��T
   [chromosome(i).T] =Modify_Chromosom_T(chromosome(i),model);
   %���¼����µ�pos
  [chromosome(i).pos] = Angel2Pos(chromosome(i),model);
  %����������
  [flag,chromosome(i).ETA,chromosome(i).atkalpha,chromosome(i).atkbeta] = IsReasonble(chromosome(i),model);
  
  chromosome(i).IsFeasible = (flag==1);
  end
  %����ÿ������Э�����������Ӧ��ֵ��ÿ����ľ���������
  [chromosome(i).cost,chromosome(i).sol] = FitnessFunction(chromosome(i),model);
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
    [ sons] = CrossoverAndMutation( parents,model );
    
    %����Ҫ���Ժ�����Ӵ�����Ӧ��ֵ
    [sons(1).cost,sons(1).sol,sons(1).AllPos] = FitnessFunction(sons(1),model);
    [sons(2).cost,sons(2).sol,sons(2).AllPos] = FitnessFunction(sons(2),model);
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
        if globel.cost >chromosome(index).cost
            globel = chromosome(index);
        end
    end
   
    best(it) = globel.cost;
    PlotSolution(globel.sol,model);
    pause(0.01);
    disp(['it: ',num2str(it),'   best value:',num2str(globel.cost)]);
    
    
    
end
toc;
figure;
plot(best);
end


