clc;
clear;
% poolobj = gcp('nocreate'); 
% if isempty(poolobj)
%     poolsize = 0;
% else
%     poolsize = poolobj.NumWorkers;
% end
parpool('local',10)
sum = 0;
fileFolder = fullfile('/home/bbyng/Desktop/test/MICCAI_BraTS17_Data_Training');
dirOutput = dir(fullfile(fileFolder,''));
tem = size(dirOutput);
isize = tem(1);
startpos = 4;
for i = startpos:isize
    if dirOutput(i).isdir
        secondFolder = fullfile( [fileFolder,'/',dirOutput(i).name]);
        secondDir = dir(fullfile(secondFolder,''));
        tem = size(secondDir);
        jsize = tem(1);
        for j = startpos:jsize
            if secondDir(j).isdir
                thirdFolder = fullfile( [secondFolder,'/',secondDir(j).name]);
                fileDir = dir(thirdFolder);
                tem = size(fileDir);
                sum = sum + 1;
                for k = 3:tem(1)
%                       fprintf([thirdFolder,'/',fileDir(k).name]);
%                       fprintf('\n');
                      tem_char = regexp(fileDir(k).name, '_', 'split');
                      tem_char = tem_char(end);
                      tem_char = regexp(char(tem_char(1)),'.n','split');
                      tem_char = tem_char(1);
                      switch char(tem_char)
                          case 't1'
                              t1 = load_nii([thirdFolder,'/',fileDir(k).name]);
                          case 't2'
                              t2 = load_nii([thirdFolder,'/',fileDir(k).name]);
                          case 't1ce'
                              t1ce = load_nii([thirdFolder,'/',fileDir(k).name]);
                          case 'flair'
                              flair = load_nii([thirdFolder,'/',fileDir(k).name]);
                      end
                end       
                maxv = double(max(max(max(t1.img))));
                minv = double(min(min(min(t1.img))));
                t1_norm = double(t1.img);
                t1_norm = (t1_norm-minv)/(maxv-minv);
                maxv = double(max(max(max(t1ce.img))));
                minv = double(min(min(min(t1ce.img))));
                t1ce_norm = double(t1ce.img);
                t1ce_norm = (t1ce_norm-minv)/(maxv-minv);
                maxv = double(max(max(max(t2.img))));
                minv = double(min(min(min(t2.img))));
                t2_norm = double(t2.img);
                t2_norm = (t2_norm-minv)/(maxv-minv);
                maxv = double(max(max(max(flair.img))));
                minv = double(min(min(min(flair.img))));
                flair_norm = double(flair.img);
                flair_norm = (flair_norm-minv)/(maxv-minv);
%                 return;
%                 
                box_size = 3;
                sizes = size(t1_norm);
                sizes(4) = 12;
                new_features = zeros(sizes);
                for ii = 1:sizes(1)
                    for jj = 1:sizes(2)
                        for kk = 1:sizes(3)
                            new_features(ii,jj,kk,1:3) = get_vexel_feature_of_one_sequence(t1_norm,ii,jj,kk,box_size);
%                             fprintf('t1\n');
                            new_features(ii,jj,kk,4:6) = get_vexel_feature_of_one_sequence(t1ce_norm,ii,jj,kk,box_size);
%                             fprintf('t1ce\n');
                            new_features(ii,jj,kk,7:9) = get_vexel_feature_of_one_sequence(t2_norm,ii,jj,kk,box_size);
%                             fprintf('t2\n');
                            new_features(ii,jj,kk,10:12) = get_vexel_feature_of_one_sequence(flair_norm,ii,jj,kk,box_size);
%                             fprintf('ok\n');
                        end
                    end
                end
                fprintf([thirdFolder,'/','means_K_S_3.mat\n']);
                save([thirdFolder,'/','means_K_S_3.mat'],'new_features');
                
            end
        end
    end
end
delete(gcp('nocreate'));