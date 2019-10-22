
lr0 = 0.1;
ss = [0.01,0.05,0.1,0.8,1.2];

for kkkk=1:5
    kkkk
    magpara = [5,floor(1000*ss(kkkk))];
    [train_mag_row,~,train_psi_mag_row,train_alpha_mag_row,train_vel_in]...
        = balandata(train_mag_1,train_mag_1,train_psi_1,train_alpha_1,train_vel_input,...
        magpara(1),magpara(2));
    
    btpara = [5,floor(1000*ss(kkkk))];
    [train_bt_row,train_mag_bt_row,train_psi_bt_row,train_alpha_bt_row,train_vel_in_bt]...
        = balandata(train_bt_1,train_mag_1,train_psi_1,train_alpha_1,train_vel_input,...
        btpara(1),btpara(2));
    
    blpara = [5,floor(500*ss(kkkk))];
    [train_bl_row,train_mag_bl_row,train_psi_bl_row,train_alpha_bl_row,train_vel_in_bl]...
        = balandata(train_bl_1,train_mag_1,train_psi_1,train_alpha_1,train_vel_input,...
        blpara(1),blpara(2));
    
    psipara = [1,floor(1000*ss(kkkk))];
    [train_psi_row,~,~,~,train_vel_in_psi]...
        = balandata(train_psi_1,train_mag_1,train_psi_1,train_alpha_1,train_vel_input,...
        psipara(1),psipara(2));
  
    train_bt_alpha_row = train_mag_bt_row.*train_alpha_bt_row.*sin(train_psi_bt_row*pi/180);
    train_bl_alpha_row = train_mag_bl_row.*train_alpha_bl_row.*cos(train_psi_bl_row*pi/180);
    
    train_input{1} =train_vel_in_bt;
    train_output{1} = train_bt_row;
    train_input{2} =train_vel_in_bl;    
    train_output{2} = train_bl_row;
    train_input{3} = train_vel_in;
    train_output{3} = train_mag_row;
    train_input{4} = train_vel_in_psi;
    train_output{4} = train_psi_row;
    train_input{5} = train_vel_in_bt;
    train_output{5} = train_bt_alpha_row;
    train_input{6} = train_in_bl;
    train_output{6} = train_bl_alpha_row;
    
    layers = [20,20,20,20,20];
    
    for Z=1:6
        Z
        input = train_input{Z}';
        output = train_output{Z};
        dlen = length(output);
        id = randperm(dlen);
        input_train=input(id,:)';
        output_train=output(id);
        [inputn,inputps]=mapminmax(input_train);
        
        try
            net=netw{Z};
        catch
            net = feedforwardnet(layers,'trainbr');
        end
        
        input_test=input_train;
        [m2.n2]=size(input_test)
        [inputn,inputps]=mapminmax(input_train);
        
        net.trainParam.epochs= 1500;
        net.trainParam.lr=0.3^kkkk*lr0;
        net.trainParam.min_grad=0.001;
        net.trainParam.max_fail=20;
        net.trainParam.mu_dec=0.1;
        net.trainParam.mu_inc=10;
        net.trainParam.mu_max=1e10;
        net.divideParam.trainRatio=0.7;
        net.divideParam.valRatio=0.2;
        net.divideParam.testRatio=0.1;
        net.trainParam.show=20;
        net.layers{1}.transferFcn  ='logsig';
        net.layers{2}.transferFcn  ='logsig';
        net.layers{3}.transferFcn  ='logsig';
        net.layers{4}.transferFcn  ='logsig';
        net.layers{5}.transferFcn  ='logsig';
        
        net=train(net,inputn,output_train,'useParallel','yes');

        netw{Z}=net;
        parainput{Z} = inputps;
        BPprealltrain{Z}=sim(net,inputn);
    end
end
save iquvv_net BPprealltrain netw parainput





