function model = CreateModel()
%��ʼ������
sx =[300,300];
sy =[350,700];
sz =[285,280];
%�յ�����
ex =830;
ey =515;
ez =240;
%��ƫ�Ƿ�Χ
alpha_min= -30;
alpha_max = 30;
%�����Ƿ�Χ
beta_min = -30;
beta_max = 30;
%GA��Ⱥ��
NP=30;
%GA����������
MaxIt=30;
%ÿ��Ⱦɫ���ά��
dim =15;
%num�������ʼ����ʽ
num=NP*0.1;
%�������
cross_prob =0.9;
%�������
mutation_prob=0.1;
%�״�λ��
xobs =[500,675,830];
yobs =[475,750,515];
zobs = [238, 275, 240];
robs =[150,163,150];
%����λ��
weapon_x=[700,530];
weapon_y=[680,520];
weapon_z=[275,263];
weapon_r=[93,93];

model.weapon_x=weapon_x;
model.weapon_y=weapon_y;
model.weapon_z=weapon_z;
model.weapon_r=weapon_r;
%�����
mission_seq=[2 3 1];
mission_x=[800,410,555];
mission_y=[580,545,675];
mission_z=[278,280,280];
mission_r=[15,15,15];
model.mission_seq =mission_seq;
model.mission_x=mission_x;
model.mission_y=mission_y;
model.mission_z=mission_z;
model.mission_r=mission_r;
%��ͼ��С
%x,y,z����Χ
Xmin=300;Xmax=1000;Ymin=300;Ymax=900;Zmin=0;Zmax=500;
model.Xmin =Xmin;
model.Xmax =Xmax;
model.Ymin =Ymin;
model.Ymax =Ymax;
model.Zmin =Zmin;
model.Zmax =Zmax;
mapmin=[0 0 0];
mapmax=[700e3 600e3 500e3];
%ָ��������alpha
attack_alpha =[60 -60];
model.attack_alpha = attack_alpha;
model.beta_max =beta_max;
model.beta_min = beta_min;
model.sz =sz;
model.ez =ez;
model.zobs =zobs;
model.mapmin =mapmin;
model.mapmax =mapmax;
model.xobs=xobs;
model.yobs=yobs;
model.robs=robs;
model.mutation_prob=mutation_prob;
model.cross_prob=cross_prob;
model.num=num;
model.dim=dim;
model.NP=NP;
model.MaxIt=MaxIt;
model.sx =sx;
model.sy =sy;
model.ex =ex;
model.ey=ey;
model.alpha_min =alpha_min;
model.alpha_max =alpha_max;


%%�������˻�
UAV = numel(sx);
vel =200;
vrange=[180 200];
%Эͬʱ���Ϊintervel��ʱ����֮��
intervel=20;
%���˻���ȫ����
security_dist =5;
model.security_dist =security_dist;
model.intervel=intervel;
%������㵽Ŀ��ľ����������ٶ�
Tmax = norm([sx(1)-ex,sy(1)-ey,ez(1)-ez(1)])/vrange(1);
Tmin =0;
model.Tmin =Tmin;
model.Tmax =Tmax;
model.vrange =vrange;
model.vel = vel;
model.UAV=UAV;

%matlab����
debug =1;
model.debug =debug;
std_ga=1;
model.std_ga =std_ga;

end