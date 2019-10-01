function generalisation(filename)

%filename='sonar+K5.wav';

save_file=['Sound_data/',filename,'.mat'];

if exist(save_file,'file')==0
    input('Don''t find .mat file.')
    return
else load (save_file)
end

hold on
plot_style=cellstr(['-m'; '-c'; '-g'; '-y'; '-r';'-b';'-k';'-w';'-m']);

if exist('lf','var')==1 && exist('sqp','var')==1
    sam_N_glf=max(size(lf.number_s,2),size(sqp.number_s,2));
elseif exist('lf','var')==1 && exist('sqp','var')==0
    sam_N_glf=size(lf.number_s,2);
elseif exist('lf','var')==0 && exist('sqp','var')==1
    sam_N_glf=size(sqp.number_s,2);
else sam_N_glf=0;
end

%==================creating glf for all samples===========================
if sam_N_glf~=0
    for sam_i=1:sam_N_glf
        sam_n=['sam' int2str(sam_i)];
        glf.(genvarname(sam_n))=[];
        
        if exist('lf','var')==1 && isfield(lf,sam_n)==1
        for var_i=1:size(lf.(genvarname(sam_n)).number,2)
            var_n=['var' int2str(var_i)];
            if  isfield(lf.(genvarname(sam_n)),var_n)==1 && ...
                    ~isempty(lf.(genvarname(sam_n)).(genvarname(var_n)))
                next_var=lf.(genvarname(sam_n)).(genvarname(var_n));
                next_var(:,2)=next_var(:,2)/var_i;
            glf.(genvarname(sam_n))=[glf.(genvarname(sam_n)); next_var];
            next_var=[];
            end
        end
        end
        %--------------calculation sequence of pulse-----------------------
        if exist('sqp','var')==1 && isfield(sqp,sam_n)==1 &&...
                size(sqp.(genvarname(sam_n)),1)>1
           for n=1:(size(sqp.(genvarname(sam_n)))-1)
                next_sqp(n,1)=sqp.(genvarname(sam_n))(n,1);
                next_sqp(n,2)=0.001/(sqp.(genvarname(sam_n))(n+1,1)-sqp. ...
                    (genvarname(sam_n))(n,1));
            end
            glf.(genvarname(sam_n))=[glf.(genvarname(sam_n)); next_sqp];
            next_sqp(:,:)=[];
        end
        %--------------plot and glf for sample N---------------------------
        if ~isempty(glf.(genvarname(sam_n)))
            glf.(genvarname(sam_n))=sortrows(glf.(genvarname(sam_n)));
            glf.(genvarname(sam_n))(:,2)=...
                smooth(glf.(genvarname(sam_n))(:,1),...
                glf.(genvarname(sam_n))(:,2),0.15,'rloess');
            plot(glf.(genvarname(sam_n))(:,1),glf.(genvarname(sam_n))(:,2),...
                char(plot_style(sam_i)),'LineWidth',2)
            glf.Nsam=sam_i;
            save(save_file,'-append','glf')
        end
    end
end
%=====================creating ghf for all samples=========================
%}
if exist('hf','var')==1
    for sam_i=1:size(hf.number_s,2);
        sam_n=['sam' int2str(sam_i)];
        ghf.(genvarname(sam_n))=[];
        
        for var_i=1:size(hf.(genvarname(sam_n)).number,2)
            var_n=['var' int2str(var_i)];
            if  isfield(hf.(genvarname(sam_n)),var_n)==1 && ...
                    ~isempty(hf.(genvarname(sam_n)).(genvarname(var_n)))
                next_var=hf.(genvarname(sam_n)).(genvarname(var_n));
                next_var(:,2)=next_var(:,2)/var_i;
            ghf.(genvarname(sam_n))=[ghf.(genvarname(sam_n)); next_var];
            next_var=[];
            end
        end
        %------------calculation combinatorial frequencies-----------------
        if exist('hlc','var')==1 && isfield(hlc,sam_n)==1
            for i=1:size(hlc.(genvarname(sam_n)).number,2)
                var_n=['var' int2str(i)];
                if hlc.(genvarname(sam_n)).number(i)>0
                    next_hlc=hlc.(genvarname(sam_n)).(genvarname(var_n));
                
                for st=1:size(next_hlc,1)
                    proto_lf(st,1)=next_hlc(st,1);
                    if next_hlc(st,1)>glf.(genvarname(sam_n))(1,1) && ...
                           next_hlc(st,1)<glf.(genvarname(sam_n))...
                           (size(glf.(genvarname(sam_n)),1),1)
                        x=find(glf.(genvarname(sam_n))(:,1)<proto_lf(st,1),1,'last');
                        proto_lf(st,2)=interp1(glf.(genvarname(sam_n))(x:x+1,1),...
                            glf.(genvarname(sam_n))(x:x+1,2),proto_lf(st,1));
                    elseif next_hlc(st,1)<glf.(genvarname(sam_n))(1,1)
                        proto_lf(st,2)=glf.(genvarname(sam_n))(1,2);
                    elseif next_hlc(st,1)>glf.(genvarname(sam_n))(size(glf.(genvarname(sam_n)),1),1)
                        proto_lf(st,2)=glf.(genvarname(sam_n))(size(glf.(genvarname(sam_n)),1),2);
                    end
                end
                
                if any(i==[1 3 5 7 9])        % combinatorial component "hf-lf"
                    next_hlc(:,2)=next_hlc(:,2)+proto_lf(:,2)*(i+1)/2;
                elseif any(i==[2 4 6 8 10])   % combinatorial component "hf+lf"
                    next_hlc(:,2)=next_hlc(:,2)-proto_lf(:,2)*(i)/2;
                end
                ghf.(genvarname(sam_n))=[ghf.(genvarname(sam_n)); next_hlc];
                next_hlc=[];
                proto_lf=[];
                end
            end
        end
       
        %--------------plot and ghf for sample N--------------------------
        if ~isempty(ghf.(genvarname(sam_n)))
            ghf.(genvarname(sam_n))=sortrows(ghf.(genvarname(sam_n)));
            ghf.(genvarname(sam_n))(:,2)=...
                smooth(ghf.(genvarname(sam_n))(:,1),...
                ghf.(genvarname(sam_n))(:,2),0.15,'rloess');
            plot(ghf.(genvarname(sam_n))(:,1),ghf.(genvarname(sam_n))(:,2),...
               char(plot_style(sam_i)),'LineWidth',2)
            ghf.Nsam=sam_i;
            save(save_file,'-append','ghf')
        end
    end
end
