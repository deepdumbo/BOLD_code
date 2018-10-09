% function figure_frechet(simdir,bids_dir)

clear;

simdir = '../../Data/vesselsim_data/';

TE=80e-3;
tauASE=[-28:4:64]./1000;

Ds=[6:2:200];
Rs=Ds./2;
relVf=gevpdf(Rs,0.41,5.8,10.1);
relVf=relVf./sum(relVf);

% Rs=[Rs(Rs<=10) 20 30 40 50 60];
% relVf=[relVf(Rs<10), sum(relVf(find((Rs>=10).*(Rs<15)))), ...
%        sum(relVf(find((Rs>=15).*(Rs<25)))), sum(relVf(find((Rs>=25).*(Rs<35)))), ...
%        sum(relVf(find((Rs>=35).*(Rs<45)))), sum(relVf(find((Rs>=45).*(Rs<55)))), ...
%        sum(relVf(find((Rs>=55).*(Rs<65))))];

Ya=1;
E0=0.4;
Yv=Ya.*(1-E0);
k=0.4;
Yc=Ya*k+Yv*(1-k);
Y=Yv;

Vtot=0.05.*0.793;
Vf=relVf.*Vtot;

for k=1:length(Rs)
    load([simdir,'single_vessel_radius_D1-0Vf3pc_dist/simvessim_res',num2str(Rs(k)),'.mat']);
    [sigASE(:,k), tauASE, sigASEev(:,k), sigASEiv(:,k)] = generate_signal(p,spp,...
         'display',false,'Vf',Vf(k),'Y',Yv,'seq','ASE','includeIV',true,...
         'T2EV',0.087,'T2b0',0.0327,'TE',TE,'tau',tauASE);
end

sigASEtot=(1-sum(Vf)).*prod(sigASEev,2)+sum(bsxfun(@times,Vf,sigASEiv),2);
se=find(tauASE==0);
sigASEtotn=sigASEtot./mean(sigASEtot(se-1:se+1));

lc=lines(6);

figure;
% 	if exist([bids_dir '/derivatives/group_results.mat'])
% 		load([bids_dir '/derivatives/group_results.mat'],'tcn')
% 		plot(tauASE.*1000,tcn,'color',[0.5 0.5 0.5])
% 	end
hold on;
plot(tauASE.*1000,sigASEtotn);
xlim([min(tauASE.*1000) max(tauASE.*1000)]);
ylim([0.8 1.02]);
set(gca,'xtick',-28:14:56);
set(gca,'ytick',0.8:0.05:1);
grid on;
axis square;
title('Multiple vessel scale simulations: Frechet');
xlabel('Spin echo displacement time, \tau (ms)');
ylabel('Signal fraction (arb.)');

%	figure;
%	bar(Rs,relVf);
%	axis square;
%	xlim([0 100])
%	title('Multiple vessel relative volume fractions: Frechet');
%	xlabel('Vessel radius (/mum)');
%	ylabel('Relative volume fraction');

% Ds=[0:2:200];
% Rs=Ds./2;
% relVf=gevpdf(Rs,0.41,5.8,10.1);
% relVf(Rs<3)=0;
% relVf=relVf./sum(relVf);
% 
% % Plot vessel radii distribution
% figure;
% stairs(Rs,relVf);
% axis square;
% xlim([0 100])
% title('Multiple vessel relative volume fractions: Frechet');
% xlabel('Vessel radius (\mum)');
% ylabel('Relative volume fraction');
% grid on;
% 	