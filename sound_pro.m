function sound_pro(action)

persistent time f F Y P y1 yn hl scaletime wv1 wv2 tv fnt
persistent Fs NT filename folder Xmin Xmax Ymin Ymax % lf lh hf hh hlc
persistent T_son I_son Y_move X_move T_res SubT_res NT_draw Color_Map
persistent X_from X_to Y_from Y_to handlDel OL_draw Sillabl_res N_pionts...
    Lx_piont Ly_piont %Li_piont Load_scal

scaletime=100;

if nargin<1
    action='initialize';
end

switch lower(action)
    
case 'initialize' %========create windows and button===========
   figure('Name','sound_pro', ...
       'UserData',[],...
       'WindowButtonDownFcn','sound_pro(''addpoint'')',...
       'NumberTitle','off');
  
   axes(...%'ButtonDownFcn','sound_pro(''addpoint'')',...
       'Units','normalized', ...
       'XTick',[],'YTick',[], ...
       'Box','on', ...
       'Position',[0.05 0.1 0.75 0.8]);
   set(gca,'UserData',[]);
   
    uicontrol( ...
        'Style','frame', ... 
        'Units','normalized', ...
        'Position',[0.83 0 0.17 1], ...
        'BackgroundColor',[0.5 0.5 0.5]);
    
   % ---------- general button -------------------
   
    uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.84 0.94 0.15 0.05], ...
        'String','Open', ...
        'Callback','sound_pro(''openfile'')');
    
    uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.84 0.72 0.075 0.05], ...
        'String','save', ...
        'Callback','sound_pro(''save'')');
    
    uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.915 0.72 0.075 0.05], ...
        'String','return', ...
        'Callback','sound_pro(''return'')');
    
    N_pionts=uicontrol('Style','text', ...
        'Units','normalized', ...
        'Position',[0.95 0.775 0.04 0.03],...
        'String','0');
        
    %Load_scal=uicontrol('Style','text', ...
    %    'Units','normalized', ...
    %    'Position',[0.85 0.775 0.04 0.03],...
    %    'String',' ');
    
	uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.84 0.67 0.1 0.05], ...
        'String','del', ...
        'Callback','sound_pro(''del'')');
   
    handlDel=uicontrol('Style','checkbox', ...
        'Units','normalized', ...
        'Position',[0.95 0.67 0.03 0.05]);
    
    uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.84 0.6 0.075 0.05], ...
        'String','play', ...
        'Callback','sound_pro(''play'')');
    
    uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.915 0.6 0.075 0.05], ...
        'String','pulse', ...
        'Callback','sound_pro(''pulse'')');
    
    uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.84 0.01 0.15 0.05], ...
        'String','generalisation', ...
        'Callback','sound_pro(''general'')');
    
    uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.84 0.06 0.15 0.05], ...
        'String','save contur', ...
        'Callback','sound_pro(''contur'')'); 

    Li_piont=uicontrol('Style','text', ...
        'Units','normalized', ...
        'Position',[0.835 0.35 0.075 0.03],...
        'String',' ');
    Lx_piont=uicontrol('Style','text', ...
        'Units','normalized', ...
        'Position',[0.835 0.3 0.075 0.03],...
        'String',' ');
    Ly_piont=uicontrol('Style','text', ...
        'Units','normalized', ...
        'Position',[0.92 0.3 0.075 0.03],...
        'String',' ');
    
    uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.915 0.25 0.075 0.05], ...
        'String','plot', ...
        'Callback','sound_pro(''plotxy'')');
    uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.835 0.25 0.075 0.05], ...
        'String','find max', ...
        'Callback','sound_pro(''nextmax'')');

   % --------------- change NT, OL & colormap------------------------
    NT_draw = uicontrol('Style', 'popup',...
       'String', '128|256|512|1024|2048',...
       'Units','normalized', ...
       'Position', [0.84 0.9 0.08 0.04],...
       'Value',3,...
       'Callback','sound_pro(''changefft'')'); 
    OL_draw = uicontrol('Style', 'popup',...
       'String', '25%|50%|75%',...
       'Units','normalized', ...
       'Position', [0.92 0.9 0.07 0.04],...
       'Value',2,...
       'Callback','sound_pro(''changefft'')'); 
   
    Color_Map = uicontrol('Style', 'popup',...
       'String', 'grayi|jet|hot|gray',...
       'Units','normalized', ...
       'Position', [0.84 0.85 0.08 0.04],...
       'Value',1,...
       'Callback','sound_pro(''changecolormap'')'); 
   %{
        Denoise_y = uicontrol('Style', 'popup',...
       'String', 'nan|wavelet|gauss',...
       'Units','normalized', ...
       'Position', [0.92 0.85 0.07 0.04],...
       'Value',1,...
       'Callback','sound_pro(''changefft'')'); 
   %}
       
   % ---------- Moving slider setup ----------------
    
    X_move=uicontrol('Style','slider',...
        'Units','normalized', ...
        'Position',[0.07 0.01 0.7 0.03], ...
        'Callback','sound_pro(''xmoves'')');
    X_from=uicontrol('Style','edit',...
        'Units','normalized', ...
        'String',Xmin,...
        'Position',[0.02 0.01 0.05 0.03], ...
        'Callback','sound_pro(''xy_input'')');
    X_to=uicontrol('Style','edit',...
        'Units','normalized', ...
        'String',Xmax,...
        'Position',[0.77 0.01 0.05 0.03], ...
        'Callback','sound_pro(''xy_input'')');
    Y_move=uicontrol('Style','slider',...
        'Units','normalized', ...
        'Position',[0.805 0.1 0.025 0.8], ...
        'Callback','sound_pro(''ymoves'')');
    Y_from=uicontrol('Style','edit',...
        'Units','normalized', ...
        'String',Ymin,...
        'Position',[0.78 0.05 0.05 0.03], ...
        'Callback','sound_pro(''xy_input'')');
    Y_to=uicontrol('Style','edit',...
        'Units','normalized', ...
        'String',Ymax,...
        'Position',[0.78 0.92 0.05 0.03], ...
        'Callback','sound_pro(''xy_input'')');   
    
    % -------- Zoom button setup -----------------
    
    uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.84 0.55 0.05 0.05], ...
        'String','-', ...
        'Callback','sound_pro(''set-'')');
    uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.89 0.55 0.05 0.05], ...
        'String','+', ...
        'Callback','sound_pro(''set+'')');
    uicontrol('Style','push', ...
        'Units','normalized', ...
        'Position',[0.94 0.55 0.05 0.05], ...
        'String','F', ...
        'Callback','sound_pro(''setf'')');
    
    % -------- Type of sonogram value ----------
    
    T_son = uicontrol('Style', 'popup',...
       'String', 'spectrogram|linear|logarithmic|c_morlet(1-1)|c_morlet(1-3)',...
       'Units','normalized', ...
       'Position', [0.84 0.5 0.10 0.05],...
       'Callback', 'sound_pro(''redraw'')');
    I_son=uicontrol('Style','edit',...
        'Units','normalized', ...
        'String',20,...
        'Position',[0.94 0.5 0.05 0.05], ...
        'Callback','sound_pro(''redraw'')');
   % -------------- change type of result ------------- 
    T_res = uicontrol('Style', 'popup',...
       'String', 'lf|hf|hlc|sqp',...
       'Units','normalized', ...
       'Position', [0.83 0.4 0.065 0.05],...
       'Callback','sound_pro(''redraw'')');
    SubT_res = uicontrol('Style', 'popup',...
       'String', ' ',...
       'Units','normalized', ...
       'Position', [0.89 0.4 0.06 0.05]);
    Sillabl_res = uicontrol('Style', 'popup',...
       'String', '1|2|3|4|5|6|7|8|9|all',...
       'Units','normalized', ...
       'Position', [0.945 0.4 0.05 0.05]);   
    sound_pro('changecolormap')
%==========================================================================
%                   operation with mouse
%==========================================================================
case 'addpoint'  
  if get(handlDel,'Value')==0 %if case del_poin is't select
    points=get(gca,'UserData');
    
    if strcmp(get(gcf,'SelectionType'),'normal')
        Pt=get(gca,'CurrentPoint');                  
        Pt=Pt(1,1:2);                             
        points=[points; Pt];
        set(gca,'UserData',points);
        
        line(Pt(1),Pt(2), ...
           'LineStyle','none', ...
           'Marker','.', ...
           'Color','r', ...
           'MarkerSize',5, ...
           'EraseMode','none');
       
       %---------- action by right button click of mouse----------
       
    elseif strcmp(get(gcf,'SelectionType'),'alt')
        pm1 = get(gca,'CurrentPoint');    % button down detected
        rbbox;                            % return figure units
        pm2 = get(gca,'CurrentPoint');    % button up detected
        pm1 = pm1(1,1:2);                 % extract x and y
        pm2 = pm2(1,1:2);
        Xmin = min(pm1(1),pm2(1));
        Xmax = max(pm1(1),pm2(1));
        Ymin = min(pm1(2),pm2(2));
        Ymax = max(pm1(2),pm2(2));
            if Xmin<0
                Xmin=0; end
            if Ymin<0
                Ymin=0; end
            if Xmax>max(time)
                Xmax=max(time); end
            if Ymax>max(f)
                Ymax=max(f); end
        set(gca,'XLim',[Xmin Xmax],'YLim',[Ymin Ymax]);
        
        set(X_move,'Value',Xmin);
        set(Y_move,'Value',Ymin);
        sound_pro('ymoves')
        sound_pro('xmoves')
        set(X_from,'string',Xmin*scaletime);
        set(X_to,'string',Xmax*scaletime);
        set(Y_from,'string',Ymin);
        set(Y_to,'string',Ymax);
    end %if a click is normal
    
  %---------case 'del_point' = delete point in chose area ----------------- 
  elseif get(handlDel,'Value')==1
   points=get(gca,'UserData');  
    if strcmp(get(gcf,'SelectionType'),'normal')
        dPt=get(gca,'CurrentPoint');                  
        dPt=dPt(1,1:2);
        rx=(Xmax-Xmin)/100;
        ry=(Ymax-Ymin)/100;
        area= [dPt(1)-rx dPt(2)+ry
               dPt(1)+rx dPt(2)-ry];
       
        points=del_point_2D(points,area(1,:),area(2,:));

        set(gca,'UserData',points);
        sound_pro('redraw')
        %line([area(1,1) area(2,1) area(2,1) area(1,1) area(1,1)],...
        %    [area(1,2) area(1,2) area(2,2) area(2,2) area(1,2)],'Color','b')
        
    elseif strcmp(get(gcf,'SelectionType'),'alt')
        p_d1 = get(gca,'CurrentPoint');    % button down detected
        rbbox;                            % return figure units
        p_d2 = get(gca,'CurrentPoint');    % button up detected
        p_d1 = p_d1(1,1:2);                 % extract x and y
        p_d2 = p_d2(1,1:2);
             
        points=del_point_2D(points,p_d1,p_d2);

        set(gca,'UserData',points);
        sound_pro('redraw')
        %line([dX_from dX_to dX_to dX_from dX_from],...
        %    [dY_from dY_from dY_to dY_to dY_from],'Color','b')
    end  
  end
  set(N_pionts,'string',size(points,1));
  if ~isempty(points)
    set(Lx_piont,'string',points(size(points,1),1));
    set(Ly_piont,'string',points(size(points,1),2));
  end

%==========================================================================
%=========================draw image of sonogramm==========================
case 'redraw'
    type= get(T_son,'Value');
    Il=str2double(get(I_son,'string'));
    if type==1
        
        int0=min(min(180+10*log10(P)))+Il;
        int=256/(max(max(180+10*log10(P)))-int0);
        hl=image(time,F/1000,int*((180+10*log10(P))-int0));
        newplot(hl);
        
    elseif type==2
       
         g=2*abs(Y);
         hl=image(time,f,g*Il);
         newplot(hl);
         
    elseif type==3
        
        g=2*abs(Y);
        g0=10/Il;
        glog=10*log10(g/g0);
        int=256/max(max(glog));      % max log level equated to top color
        hl=image(time,f,glog*int);
        newplot(hl);
        
    elseif type==4
        if ~isempty(wv1)
            int=(256+(Il-20)*4)/max(max(abs(wv1)));
            tv=linspace(0,size(yn,1)/Fs,size(wv1,2));
            hl=image(tv,fnt/1000,wv1*int);
            newplot(hl);
        else
            hl=image(time,f,zeros(size(f,1),size(time,1)));
            newplot(hl);
        end
        
    elseif type==5
        if ~isempty(wv2)
            int=(256+(Il-20)*4)/max(max(abs(wv2)));
            tv=linspace(0,size(yn,1)/Fs,size(wv2,2));
            hl=image(tv,fnt/1000,wv2*int);
            newplot(hl);
        else
            hl=image(time,f,zeros(size(f,1),size(time,1)));
            newplot(hl);
        end
    end
          
    points=get(gca,'UserData');
    if ~isempty(points)
        for ip=1:size(points,1)
            line(points(ip,1),points(ip,2), ...
                'LineStyle','none', ...
                'Marker','.', ...
                'Color','r', ...
                'MarkerSize',5, ...
                'EraseMode','none');
        end
    end
                            % correct popup for subtype of results
    if get(T_res,'Value')==4
        set(SubT_res,'String',' ')
    elseif get(T_res,'Value')==1 || get(T_res,'Value')==2 || get(T_res,'Value')==2
        set(SubT_res,'String','1|2|3|4|5|6|7|8|9|10|11|12')
    elseif get(T_res,'Value')==3
        set(SubT_res,'String','-1|+1|-2|+2|-3|+3|-4|+4|-5|+5')
    end
%==========================button callback=================================

case 'openfile' %=========open .wav file================

    [filename, folder]=uigetfile('*.wav','open WAV file',folder);
    if folder==0
        folder=[];
        return
    end
    
    [yn, Fs, nbits]=wavread([folder,filename]);
    y1=yn(:,1);          % first channel
    if size(yn,2)>1
        y2=yn(:,2);
    end
    
    wv1=[];
    wv2=[];
    
    Xmin=0;
    Xmax=size(y1,1)/Fs;
    Ymin=0;
    Ymax=Fs/2000;    
    
    set(X_move,'Value',Xmin);
    set(Y_move,'Value',Ymin);
    set(X_from,'string',Xmin*scaletime);
    set(X_to,'string',Xmax*scaletime);
    set(Y_from,'string',Ymin);
    set(Y_to,'string',Ymax);
    
    sound_pro('changefft')  
      
    set(gca,'XTick',0:0.2:Xmax,'YTick',0:2:Ymax,...
        'Layer','top',...
        'UserData',[],...
        'Box','on', ...
        'XLim',[Xmin Xmax],'YLim',[Ymin Ymax],...
        'NextPlot','add')
    title(filename)
    
    sound_pro('redraw')
    
case 'changefft'    %NT=512;
    
    if     get(NT_draw,'Value')==1
        NT=128;
    elseif get(NT_draw,'Value')==2
        NT=256;
    elseif get(NT_draw,'Value')==3
        NT=512;
    elseif get(NT_draw,'Value')==4
        NT=1024;
    elseif get(NT_draw,'Value')==5
        NT=2048;
    end

    if     get(OL_draw,'Value')==1
        OL=0.25;
    elseif get(OL_draw,'Value')==2
        OL=0.5;
    elseif get(OL_draw,'Value')==3
        OL=0.75;
    end
   
    [Y,F,time,P] = spectrogram(y1,NT,NT*OL,NT,Fs,'yaxis');    
    f=F/1000;
    
    fnt=linspace(20,Fs/2,512);

    if get(T_son,'Value')==4;
        fscal=(fnt/(centfrq('cmor1-1')*Fs)).^(-1);
        for nextscal=2:512
            wv1(nextscal,:)=decimate(abs(cwt(y1,fscal(nextscal),'cmor1-1')),10);
            %set(Load_scal,'string',nextscal);
        end
    end
    
    if get(T_son,'Value')==5;
        fscal=(fnt/(centfrq('cmor1-3')*Fs)).^(-1);
        for nextscal=2:512
            wv2(nextscal,:)=decimate(abs(cwt(y1,fscal(nextscal),'cmor1-3')),10);
            %set(Load_scal,'string',nextscal);
        end
    end
    sound_pro('redraw')
    
case 'changecolormap'
    if     get(Color_Map,'Value')==1
        for k=1:256
            imc=double(k)/256;
            C(k,:)=[imc imc imc];
        end
        colormap (flipdim(C,1))
    elseif get(Color_Map,'Value')==2
        colormap jet      
    elseif get(Color_Map,'Value')==3
        colormap hot
    elseif get(Color_Map,'Value')==4
        colormap gray
    end


case 'save' %====save input points to .mat file and clear points===========
    
    if exist('Sound_data','dir')==0
        mkdir('Sound_data')
    end
    
    points=get(gca,'UserData');
    save_file=['Sound_data/',filename,'.mat'];
    
    if exist(save_file,'file')==0
        file_inf.creating_date=date;
        file_inf.path=folder;
        file_inf.filename=filename;
        save(save_file, 'file_inf')
    else load (save_file)
        file_inf.change_date=date;
        save(save_file,'-append','file_inf')
    end
    
    nsample=get(Sillabl_res,'value');
    namesample=['sam' int2str(nsample)];
    nvar=get(SubT_res,'value');
    namevar=['var' int2str(nvar)];
    
    if  get(T_res,'value')==1
        lf.name='low frequency and its harmonics';
        lf.number_s(nsample)=nsample;
        lf.(genvarname(namesample)).number(nvar)=nvar;
        lf.(genvarname(namesample)).(genvarname(namevar))=sortrows(points);
        save(save_file,'-append','lf')
    elseif get(T_res,'value')==2
        hf.name='high frequency and its harmonics';
        hf.number_s(nsample)=nsample;
        hf.(genvarname(namesample)).number(nvar)=nvar;
        hf.(genvarname(namesample)).(genvarname(namevar))=sortrows(points);
        save(save_file,'-append','hf')
    elseif get(T_res,'value')==3
        hlc.name='combinatorial component of low and high frequency';
        hlc.number_s(nsample)=nsample;
        hlc.(genvarname(namesample)).number(nvar)=nvar;
        hlc.(genvarname(namesample)).(genvarname(namevar))=sortrows(points);
        save(save_file,'-append','hlc')
    elseif get(T_res,'value')==4
        sqp.name='pulse sequence as low frequency';
        sqp.number_s((get(Sillabl_res,'value')))=get(Sillabl_res,'value');
        sqp.(genvarname(namesample))=sortrows(points);
        save(save_file,'-append','sqp')

    end
    set(gca,'UserData',[])
    
    sound_pro('redraw')
    if ~isempty(points)
        points_sort=sortrows(points);
        plot(points_sort(:,1),points_sort(:,2))
    end
    
case 'return' %====save input points to .mat file and clear points===========
    if exist(['Sound_data/',filename,'.mat'],'file')==0
        points = [];
    else load (['Sound_data/',filename,'.mat'])
        nsample=get(Sillabl_res,'value');
        namesample=['sam' int2str(nsample)];
        nvar=get(SubT_res,'value');
        namevar=['var' int2str(nvar)];
    
        if  get(T_res,'value')==1 &&...
            exist('lf','var')==1 && isfield(lf,namesample)==1 && ...
            isfield(lf.(genvarname(namesample)),namevar)==1
            points=lf.(genvarname(namesample)).(genvarname(namevar));
        elseif get(T_res,'value')==2 &&...
            exist('hf','var')==1 && isfield(hf,namesample)==1 && ...
            isfield(hf.(genvarname(namesample)),namevar)==1
            points=hf.(genvarname(namesample)).(genvarname(namevar));
        elseif get(T_res,'value')==3 &&...
            exist('hlc','var')==1 && isfield(hlc,namesample)==1 && ...
            isfield(hlc.(genvarname(namesample)),namevar)==1
            points=hlc.(genvarname(namesample)).(genvarname(namevar));
        elseif get(T_res,'value')==4 &&...
            exist('sqp','var')==1 && isfield(sqp,namesample)==1
            points=sqp.(genvarname(namesample));
        else points=[];
        end
    end
    set(gca,'UserData',points);
    set(N_pionts,'string',size(points,1));
    if ~isempty(points)
        set(Lx_piont,'string',points(size(points,1),1));
        set(Ly_piont,'string',points(size(points,1),2));
    end

    sound_pro('redraw')
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
case 'contur'%====save glf as contur===========
    save_file=['Sound_data/',filename,'.mat'];

    if exist(save_file,'file')==0
        input('Don''t find .mat file.')
        return
    else load (save_file)
    end
    st=0.01;
    nsample=get(Sillabl_res,'value');
    sam_n=['sam' int2str(nsample)];
    
    if exist('Sound_conture','dir')==0
        mkdir('Sound_conture')
    end

    if  get(T_res,'value')==1 && exist('glf','var')==1 &&...
            isfield(glf,sam_n)==1 && nsample~=10

        [glf1(:,1) Irl]=unique(glf.(genvarname(sam_n))(:,1));
        glf1(:,2)=glf.(genvarname(sam_n))(Irl,2);  % excepting repeated time points
        
        first_point=glf.(genvarname(sam_n))(1,1);
        last_point=glf.(genvarname(sam_n))(size(glf.(genvarname(sam_n)),1),1);
        fconture=interp1(glf1(:,1),glf1(:,2),first_point:st:last_point);
        plot((0:st:(last_point-first_point))+first_point,fconture,'or','LineWidth',1)
        
        save_conture=['Sound_conture/','glf.',sam_n,'_',filename,'.crt'];
        save(save_conture,'fconture')
    elseif  get(T_res,'value')==2 && exist('glf','var')==1 &&...
            isfield(glf,sam_n)==1 && nsample~=10

        [ghf1(:,1) Irl]=unique(ghf.(genvarname(sam_n))(:,1));
        ghf1(:,2)=ghf.(genvarname(sam_n))(Irl,2);  % excepting repeated time points
        
        first_point=ghf.(genvarname(sam_n))(1,1);
        last_point=ghf.(genvarname(sam_n))(size(ghf.(genvarname(sam_n)),1),1);
        fconture=interp1(ghf1(:,1),ghf1(:,2),first_point:st:last_point);
        plot((0:st:(last_point-first_point))+first_point,fconture,'or','LineWidth',1)
        
        save_conture=['Sound_conture/','ghf.',sam_n,'_',filename,'.crt'];
        save(save_conture,'fconture')
        
    elseif  get(T_res,'value')==1 && exist('glf','var')==1 && nsample==10
        glf_all=[];
        for i_sam=1:glf.Nsam
            glf_all=[glf_all; glf.(genvarname(['sam' int2str(i_sam)]))];
        end
        glf_all=sortrows(glf_all);
        %glf_all(:,2)=smooth(glf_all(:,1),glf_all(:,2),0.15,'rloess');
       
        for break_i=1:(size(glf_all,1)-1)
            if glf_all(break_i+1,1)-glf_all(break_i,1)>4*st
                break_point(1,1)=glf_all(break_i,1)+st*0.01;
                break_point(1,2)=0;
                break_point(2,1)=glf_all(break_i+1,1)-st*0.01;
                break_point(2,2)=0;
                glf_all=[glf_all; break_point];
            end
        end
        glf_all=sortrows(glf_all);
        
        [glf1(:,1) Irl]=unique(glf_all(:,1));
        glf1(:,2)=glf_all(Irl,2);  % excepting repeated time points

        first_point=glf_all(1,1);
        last_point=glf_all(size(glf_all,1),1);

        fconture=interp1(glf1(:,1),glf1(:,2),first_point:st:last_point);
        plot((0:st:(last_point-first_point))+first_point,fconture,'or','LineWidth',1)
        
        save_conture=['Sound_conture/','glf','_',filename,'.crt'];
        save(save_conture,'fconture')
    elseif  get(T_res,'value')==2 && exist('ghf','var')==1 && nsample==10
        ghf_all=[];
        for i_sam=1:ghf.Nsam
            ghf_all=[ghf_all; ghf.(genvarname(['sam' int2str(i_sam)]))];
        end
        ghf_all=sortrows(ghf_all);
        %ghf_all(:,2)=smooth(ghf_all(:,1),ghf_all(:,2),0.15,'rloess');
       
        for break_i=1:(size(ghf_all,1)-1)
            if ghf_all(break_i+1,1)-ghf_all(break_i,1)>4*st
                break_point(1,1)=ghf_all(break_i,1)+st*0.01;
                break_point(1,2)=0;
                break_point(2,1)=ghf_all(break_i+1,1)-st*0.01;
                break_point(2,2)=0;
                ghf_all=[ghf_all; break_point];
            end
        end
        ghf_all=sortrows(ghf_all);
        
        [ghf1(:,1) Irl]=unique(ghf_all(:,1));
        ghf1(:,2)=ghf_all(Irl,2);  % excepting repeated time points

        first_point=ghf_all(1,1);
        last_point=ghf_all(size(ghf_all,1),1);

        fconture=interp1(ghf1(:,1),ghf1(:,2),first_point:st:last_point);
        plot((0:st:(last_point-first_point))+first_point,fconture,'or','LineWidth',1)
        
        save_conture=['Sound_conture/','ghf','_',filename,'.crt'];
        save(save_conture,'fconture')
    end
%=========================================================================
%========================== Secondary action==============================

case 'del' %=======delete recent point=========
    
    points=get(gca,'UserData');
    delp=size(points,1)-1;
    set(gca,'UserData',points(1:delp,:));
    set(N_pionts,'string',size(points,1)-1);
    if size(points,1)-1>0
        set(Lx_piont,'string',points(size(points,1)-1,1));
        set(Ly_piont,'string',points(size(points,1)-1,2));
    else
        set(Lx_piont,'string',' ');
        set(Ly_piont,'string',' ');
    end

    sound_pro('redraw') 

case 'play' %======play sound=========
    
    %Fs=max(f)*2000;
    Ts = 1/Fs;                              % Sample time
    y1_time=(0:(size(y1,1)-1))*Ts;          % time from start
    y1_start= find(y1_time>Xmin, 1, 'first');
    y1_stop= find(y1_time<Xmax, 1, 'last');
    
    sound(y1(y1_start:y1_stop),Fs);
    
case 'plotxy'
  
        [xmin1 xmin1i]=min(abs(time-Xmin));
        [xmax1 xmax1i]=min(abs(time-Xmax));
        [ymin1 ymin1i]=min(abs(f-Ymin));
        [ymax1 ymax1i]=min(abs(f-Ymax));
        figure
        powerprof=sqrt(smooth(mean(abs(Y(ymin1i:ymax1i,xmin1i:xmax1i)),2),...[],
            0.04,'rloess'));
        plot(f(ymin1i:ymax1i),powerprof)
        %{
        figure
        plot(f(ymin1i:ymax1i),mean(abs(Y(ymin1i:ymax1i,xmin1i:xmax1i)),2))
        figure
        for k=xmin1i:xmax1i
            hold on
            plot(f(ymin1i:ymax1i),abs(Y(ymin1i:ymax1i,k)))
            hold off
        end
        %}
        save_power=['Sound_power/','pp','_',filename(1:size(filename,2)-4)];%,'.crt'
        xlswrite(save_power,powerprof)

    %{
    x=str2double(get(Lx_piont,'string'));
    y=str2double(get(Ly_piont,'string'));
    if get(T_son,'Value')==1 || get(T_son,'Value')==2 || get(T_son,'Value')==3
        [px pxi]=min(abs(time-x));
        %time(pxi)
        [py pyi]=min(abs(f-y));
        %f(pyi)
        %py=abs(Y).^2;
        figure
        subplot(2,1,1)
        plot(time,abs(Y(pyi,:)).^2)
        line([x x],[0 max(abs(Y(pyi,:)).^2)],'Color','g')
        subplot(2,1,2)
        plot(f,abs(Y(:,pxi)).^2)
        line([y y],[0 max(abs(Y(:,pxi)).^2)],'Color','g')

    elseif get(T_son,'Value')==4
        [px pxi]=min(abs(tv-x));
        %tv(pxi)
        [py pyi]=min(abs(fnt/1000-y));
        %fnt(pyi)
        %py=abs(wv1).^2;
        figure
        subplot(2,1,1)
        plot(tv,abs(wv1(pyi,:)).^2)
        line([x x],[0 max(abs(wv1(pyi,:)).^2)],'Color','g')
        subplot(2,1,2)
        plot(fnt/1000,abs(wv1(:,pxi)).^2)
        line([y y],[0 max(abs(wv1(:,pxi)).^2)],'Color','g')
    elseif get(T_son,'Value')==5
        [px pxi]=min(abs(tv-x));
        %tv(pxi)
        [py pyi]=min(abs(fnt/1000-y));
        %fnt(pyi)
        %py=abs(wv2).^2;
        figure
        subplot(2,1,1)
        plot(tv,abs(wv2(pyi,:)).^2)
        line([x x],[0 max(abs(wv2(pyi,:)).^2)],'Color','g')
        subplot(2,1,2)
        plot(fnt/1000,abs(wv2(:,pxi)).^2)
        line([y y],[0 max(abs(wv2(:,pxi)).^2)],'Color','g')
    end        
    %}
case 'nextmax'
        x=str2double(get(Lx_piont,'string'));
        y=str2double(get(Ly_piont,'string'));
    if get(T_son,'Value')==1 || get(T_son,'Value')==2 || get(T_son,'Value')==3
        [px pxi]=min(abs(time-x));
        [py pyi]=min(abs(f-y));
        [nextp nextpi]=max([abs(Y(pyi+1,pxi+1)),abs(Y(pyi+1,pxi)),abs(Y(pyi+1,pxi-1)),...
            abs(Y(pyi,pxi+1)),abs(Y(pyi,pxi-1)),...
            abs(Y(pyi-1,pxi+1)),abs(Y(pyi-1,pxi)),abs(Y(pyi-1,pxi-1))]);
        
        %abs(Y(pyi,pxi))
        while abs(Y(pyi,pxi))<nextp
            if nextpi==1 %abs(Y(pyi+1,pxi+1))==nextp && abs(Y(pyi+1,pxi+1))>abs(Y(pyi,pxi))
                pyi=pyi+1;
                pxi=pxi+1;
            elseif nextpi==2 %abs(Y(pyi+1,pxi))==nextp && abs(Y(pyi+1,pxi))>abs(Y(pyi,pxi))
                pyi=pyi+1;
            elseif nextpi==3 %abs(Y(pyi+1,pxi-1))==nextp && abs(Y(pyi+1,pxi-1))>abs(Y(pyi,pxi))
                pyi=pyi+1;
                pxi=pxi-1;
            elseif nextpi==4 %abs(Y(pyi,pxi+1))==nextp && abs(Y(pyi,pxi+1))>abs(Y(pyi,pxi))
                pxi=pxi+1;
            elseif nextpi==5 %abs(Y(pyi,pxi-1))==nextp && abs(Y(pyi,pxi-1))>abs(Y(pyi,pxi))
                pxi=pxi-1;
            elseif nextpi==6 %abs(Y(pyi-1,pxi+1))==nextp && abs(Y(pyi-1,pxi+1))>abs(Y(pyi,pxi))
                pyi=pyi-1;
                pxi=pxi+1;
            elseif nextpi==7 %abs(Y(pyi-1,pxi))==nextp && abs(Y(pyi-1,pxi))>abs(Y(pyi,pxi))
                pyi=pyi-1;
            elseif nextpi==8 %abs(Y(pyi-1,pxi-1))==nextp && abs(Y(pyi-1,pxi-1))>abs(Y(pyi,pxi))
                pyi=pyi-1;
                pxi=pxi-1;
            end
        [nextp nextpi]=max([abs(Y(pyi+1,pxi+1)),abs(Y(pyi+1,pxi)),abs(Y(pyi+1,pxi-1)),...
            abs(Y(pyi,pxi+1)),abs(Y(pyi,pxi-1)),...
            abs(Y(pyi-1,pxi+1)),abs(Y(pyi-1,pxi)),abs(Y(pyi-1,pxi-1))]);
        end
        %}
        
    elseif get(T_son,'Value')==4
        [px pxi]=min(abs(tv-x));
        [py pyi]=min(abs(fnt/1000-y));
        %py=abs(wv1).^2;
        
    elseif get(T_son,'Value')==5
        [px pxi]=min(abs(tv-x));
        [py pyi]=min(abs(fnt/1000-y));
        %py=abs(wv2).^2;
    end
    points=get(gca,'UserData');
    points(size(points,1),1)=time(pxi);
    points(size(points,1),2)=f(pyi);
    set(gca,'UserData',points);
    set(Lx_piont,'string',points(size(points,1),1));
    set(Ly_piont,'string',points(size(points,1),2));
    sound_pro('redraw') 

case 'pulse'
    from=int32(Xmin*Fs)+1;
    to=int32(Xmax*Fs)-1;
    %to-from
    envelope(:,1)=abs(y1(from:to));
    envelope(:,2)=double(1:(to-from+1))/Fs;
    j=1001;
    while j>1000
    j=0;
    %
    
    for i=3:size(envelope,1)-1
        if envelope(i,1)<envelope(i-1,1) && envelope(i,1)<envelope(i+1,1)
            j=j+1;
            envelopeA(j,1)=envelope(i,1);
            envelopeA(j,2)=envelope(i,2);
        end
    end
    %j
    envelope=[];
    anvelope(:,1)=envelopeA(:,1);
    anvelope(:,2)=envelopeA(:,2);
    end
    %}
    %envelope(:,1)=wden(envelope(:,1),'heursure','s','one',5,'sym8');
    figure
    plot(envelope(:,2),envelope(:,1))
    
case 'general'
    set(gca,'UserData',[]);
    set(N_pionts,'string',0);
    set(Lx_piont,'string',' ');
    set(Ly_piont,'string',' ');

    sound_pro('redraw')
    generalisation(filename);

%=========================================================================
%============================Zoom action==================================
case 'xmoves'
    step=Xmax-Xmin;
    set(X_move,'Min',0,'Max',(size(y1,1)/Fs),...
           'SliderStep',[0.1*(step/(size(y1,1)/Fs)) step/(size(y1,1)/Fs)]);
    Xmin=get(X_move,'value');
    Xmax=Xmin+step;
    set(gca,'XLim',[Xmin Xmax]);
    
    set(X_from,'string',Xmin*scaletime);
    set(X_to,'string',Xmax*scaletime);
    
case 'ymoves'
    step=Ymax-Ymin;
    set(Y_move,'Min',0,'Max',(Fs/2000),...
        'SliderStep',[0.1*(step/(Fs/2000)) step/(Fs/2000)]);
    Ymin=get(Y_move,'value');
    Ymax=Ymin+step;
    set(gca,'YLim',[Ymin Ymax]);
    
    set(Y_from,'string',Ymin);
    set(Y_to,'string',Ymax);

case 'xy_input'
    Xmin=str2double(get(X_from,'string'))/scaletime;
    Xmax=str2double(get(X_to,'string'))/scaletime;
    Ymin=str2double(get(Y_from,'string'));
    Ymax=str2double(get(Y_to,'string'));

    if Xmin<Xmax
        set(gca,'XLim',[Xmin Xmax]);
        set(X_move,'Value',Xmin);
        sound_pro('xmoves')        
    else
        Xmax=size(y1,1)/Fs;
        Xmin=0;
    end
    if Ymin<Ymax
        set(gca,'YLim',[Ymin Ymax]);
        set(Y_move,'Value',Ymin);
        sound_pro('ymoves')
    else
        Ymin=0;
        Ymax=Fs/2000;
    end
    
case 'set-'
    Xmin=Xmin-0.1*(Xmax-Xmin);
    Xmax=Xmax+0.1*(Xmax-Xmin);
    Ymin=Ymin-0.1*(Ymax-Ymin);
    Ymax=Ymax+0.1*(Ymax-Ymin);
    if Xmin<0
        Xmin=0; end
    if Ymin<0
        Ymin=0; end
    if Xmax>max(time)
        Xmax=max(time); end
    if Ymax>max(f)
        Ymax=max(f); end
    set(gca,'XLim',[Xmin Xmax],'YLim',[Ymin Ymax]);
        set(X_move,'Value',Xmin);
        set(Y_move,'Value',Ymin);
        sound_pro('ymoves')
        sound_pro('xmoves')
        set(X_from,'string',Xmin*scaletime);
        set(X_to,'string',Xmax*scaletime);
        set(Y_from,'string',Ymin);
        set(Y_to,'string',Ymax);
case 'set+'
    Xmin=Xmin+0.1*(Xmax-Xmin);
    Xmax=Xmax-0.1*(Xmax-Xmin);
    Ymin=Ymin+0.1*(Ymax-Ymin);
    Ymax=Ymax-0.1*(Ymax-Ymin);
    if Xmin<0
        Xmin=0; end
    if Ymin<0
        Ymin=0; end
    if Xmax>max(time)
        Xmax=max(time); end
    if Ymax>max(f)
        Ymax=max(f); end
    set(gca,'XLim',[Xmin Xmax],'YLim',[Ymin Ymax]);
        set(X_move,'Value',Xmin);
        set(Y_move,'Value',Ymin);
        sound_pro('ymoves')
        sound_pro('xmoves')
        set(X_from,'string',Xmin*scaletime);
        set(X_to,'string',Xmax*scaletime);
        set(Y_from,'string',Ymin);
        set(Y_to,'string',Ymax);
case 'setf'
    Xmin=0;
    Xmax=size(y1,1)/Fs;
    Ymin=0;
    Ymax=Fs/2000;
    
    set(gca,'XLim',[Xmin Xmax],'YLim',[Ymin Ymax]);
        set(X_move,'Value',Xmin);
        set(Y_move,'Value',Ymin);
        sound_pro('ymoves')
        sound_pro('xmoves')
        set(X_from,'string',Xmin*scaletime);
        set(X_to,'string',Xmax*scaletime);
        set(Y_from,'string',Ymin);
        set(Y_to,'string',Ymax);

end %end switch