function [ parents,flag ] = SelectChromosome( seeds_accumulate_probability,model,chromosome )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %ÿ��ѡ��2����ͬȾɫ��
    
   
     
       %���ݸ������ѡ��һ��Ϊ��
       select =rand;
       index =1;
       while select > seeds_accumulate_probability(index) && index < model.NP
           index =index+1;
       end
       parents(1) = chromosome(index);
       %���ݸ������ѡ��һ��Ϊĸ
       select =rand;
       index =1;
       while select > seeds_accumulate_probability(index) && index < model.NP
           index =index+1;
       end
       parents(2) = chromosome(index);
       %ѡ���Ƚ�����Ⱦɫ���Ƿ�һ��,Ϊ�˼����֮�Ƚ���Ӧ��ֵ
       if parents(1).cost == parents(2).cost
           flag =0;
       else
           flag =1;
       end
    
     

end

