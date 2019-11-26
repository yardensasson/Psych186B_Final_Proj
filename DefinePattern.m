%define patterns
function [s,t] = DefinePattern()
%pattern 1

[~,~,data]=xlsread('training_data.xlsx');
data(1,:)=[];
data(:,1:3)=[];
data=cell2mat(data);
nans=isnan(data);
data(nans)=0;
data=data/norm(data);
for i=1:size(data,1)
    s(i,4:34)=data(i,4:34);
    t(i,1)=data(i,35);
end



% display all the input training patterns
figure(1)
for p = 1:8
   for k = 1:9
      if k<=3
         i=1;
         j=k;
      end
      if k>3 & k <=6
         i=2;
         j=k-3;
      end
      if k > 6 & k <=9
         i=3;
         j=k-6;
      end
      pattern(i,j) = s(p,k);
   end
   subplot(3,3,p), image(255*pattern), text(1,0,strcat('Pattern ', num2str(p))), axis off
end
