%{
元画像に似ている画像と似ていない画像による2クラス分類を
BoFベクトルと非線形SVMを用いて結果を分類したmファイル
%}

load('code.mat','code');

BoF=transpose(code);

bof_pos=BoF(1:200,:);
bof_neg=BoF(201:400,:);%元画像と似ていない画像
bof_neg2=BoF(401:600,:);%元画像と似ている画像

cv=5;
n=200;
idx=[1:n];
accuracy=[];
accuracy2=[];

%元画像と似ていない画像での5-fold cross validationによる分類
for i=1:cv  
  
  eval_pos =bof_pos(find(mod(idx,cv)==(i-1)),:);
  train_pos=bof_pos(find(mod(idx,cv)~=(i-1)),:);
  eval_neg =bof_neg(find(mod(idx,cv)==(i-1)),:);
  train_neg=bof_neg(find(mod(idx,cv)~=(i-1)),:);

  train=[train_pos; train_neg];
  eval=[eval_pos; eval_neg];
 
  train_label=[ones(size(train_pos,1),1); ones(size(train_neg,1),1)*(-1)];
  eval_label =[ones(size(eval_pos,1),1); ones(size(eval_neg,1),1)*(-1)];
  
  model=fitcsvm(train,train_label,'KernelFunction','rbf','KernelScale','auto');
  [predicted_label,scores]=predict(model,eval);
  
  correct=numel(find((predicted_label .* eval_label)==1));
  incorrect=numel(find((predicted_label .* eval_label)==-1));

  correct_rate=correct/(incorrect+correct);
  accuracy=[accuracy correct_rate];
end

%元画像と似ている画像での5-fold cross validationによる分類
for i=1:cv  
  
  eval_pos =bof_pos(find(mod(idx,cv)==(i-1)),:);
  train_pos=bof_pos(find(mod(idx,cv)~=(i-1)),:);
  eval_neg =bof_neg2(find(mod(idx,cv)==(i-1)),:);
  train_neg=bof_neg2(find(mod(idx,cv)~=(i-1)),:);

  train=[train_pos; train_neg];
  eval=[eval_pos; eval_neg];
 
  train_label=[ones(size(train_pos,1),1); ones(size(train_neg,1),1)*(-1)];
  eval_label =[ones(size(eval_pos,1),1); ones(size(eval_neg,1),1)*(-1)];
  
  model=fitcsvm(train,train_label,'KernelFunction','rbf','KernelScale','auto');
  [predicted_label,scores]=predict(model,eval);
  
  correct=numel(find((predicted_label .* eval_label)==1));
  incorrect=numel(find((predicted_label .* eval_label)==-1));

  correct_rate=correct/(incorrect+correct);
  accuracy2=[accuracy2 correct_rate];
end


fprintf('Classification rate %.5f by non-linear SVM between less similar images \n',mean(accuracy));
fprintf('Classification rate %.5f by non-linear SVM between similar images \n',mean(accuracy2));

%{
実行例
Classification rate 0.89500 by non-linear SVM between less similar images 
Classification rate 0.75500 by non-linear SVM between similar images 
%}