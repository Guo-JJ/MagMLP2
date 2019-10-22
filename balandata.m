function [train_para_row,train_mag2_row,train_psi_row,train_alpha_row,train_vel_input]...
    = balandata(train_para,train_mag2,train_psi,train_alpha,train_vel,interval,num)
%% Balance data
% train_para: the parameter which needs to be normalization.
% train_mag2,train_alpha,train_vel: the parameters magnetic field,inclination and fill factor 
% train_para_row: the return value of train_para after normalization.
% train_mag2_row,train_psi_row,train_alpha_row: the related magnetic
% field,inclination and fill factor parameters after normalization.
% num: the number of data in every interval
sta = min(train_para);
endl = max(train_para);
n = (endl-sta)/interval;
index = [];
for i=1:n
    ind1 = find(train_para>=sta+(i-1)*interval & train_para<sta+i*interval);
    randid = randperm(length(ind1));
    ind2 = ind1(randid(1:min(length(ind1),num)));
    index = [index ind2];
end
% >endle reserved
ind1 = find(train_para>endl);
index = [index ind1];
if sta<0
    ind2 = find(train_para<sta);
    index = [index ind2];
end
% output parameters
train_para_row= train_para(index);
train_mag2_row = train_mag2(index);
train_psi_row= train_psi(index);
train_alpha_row = train_alpha(index);
% input parameters
train_vel_input(:,:) = train_vel(:,index);