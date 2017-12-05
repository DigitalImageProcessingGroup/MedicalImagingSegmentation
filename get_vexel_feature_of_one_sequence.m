function [ output_args ] = get_vexel_feature_of_one_sequence( img,i,j,k,box_size )
%GET_FEATURE_OF_ONE_SEQUENCE Summary of this function goes here
%   Detailed explanation goes here
% parpool('local',16)

sizes = size(img);
% liner_box = zeros(1,box_size^3)-1;
% % liner_box(1,1) = img(i,j,k);
% i_liner = 1;
% for m = 0-box_size:box_size
%     if i+m>0 && i+m<=sizes(1)
%         for mm = 0-box_size:box_size
%             if j+mm>0 && j+mm<=sizes(2)
%                 for mmm = 0-box_size:box_size
%                     if k+mmm>0 && k+mmm<=sizes(3)
%                         liner_box(1,i_liner) = img(i+m,j+mm,k+mmm);
%                         i_liner = i_liner+1;
%                     end
%                 end
%             end
%         end
%     end
% end
% liner_box = liner_box(1,1:i_liner-1);
tem = img(int16(max(1,i-box_size)):int16(min(sizes(1),i+box_size)),int16(max(1,j-box_size)):int16(min(sizes(2),j+box_size)),int16(max(1,k-box_size)):int16(min(sizes(3),k+box_size)));
liner_box = reshape(tem,1,numel(tem));
the_mean = mean(liner_box);
i_liner = numel(tem)+1;
% square = 0;
% cube = 0;
% four = 0;
square = sum((liner_box-the_mean).^2);
cube = sum((liner_box-the_mean).^3);
four = sum((liner_box-the_mean).^4);
% for m = 1:i_liner-1
%     square = square + (liner_box(m)-the_mean)^2;
%     cube = cube + (liner_box(m)-the_mean)^3;
%     four = four + (liner_box(m)-the_mean)^4;
% end
n = double(1/(i_liner-1));
if n~=0 && square~=0
    K = (n*four)/((n*square)^2);
    S = (n*cube)/((n*square)^1.5);
    output_args = [the_mean,K,S];
elseif n==0
    output_args = [-1e5,-1e5,-1e5];
else
    output_args = [1e5,1e5,1e5]; % all zeros
% delete(gcp('nocreate'));
end
end
