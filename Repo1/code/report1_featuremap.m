%{
元画像に似ている画像と似ていない画像による2クラス分類を
BoFベクトルと線形SVMとfeature maps法をを用いて結果を分類したmファイル
%}
load('code.mat','code');

BoF=transpose(code);

bof_pos=BoF(1:200,:);
bof_neg=BoF(201:400,:);%似ていない画像のBoFベクトル
bof_neg2=BoF(401:600,:);%似ている画像のBoFベクトル

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
  
  training_data=repmat(sqrt(abs(train)).*sign(train),[1 3]).*[0.8*ones(size(train)) 0.6*cos(0.6*log(abs(train)+eps)) 0.6*sin(0.6*log(abs(train)+eps))];
  evalating_data=repmat(sqrt(abs(eval)).*sign(eval),[1 3]).*[0.8*ones(size(eval)) 0.6*cos(0.6*log(abs(eval)+eps)) 0.6*sin(0.6*log(abs(eval)+eps))];

  train_label=[ones(size(train_pos,1),1); ones(size(train_neg,1),1)*(-1)];
  eval_label =[ones(size(eval_pos,1),1); ones(size(eval_neg,1),1)*(-1)];
  
  model=fitcsvm(training_data,train_label,'KernelFunction','linear');
  [predicted_label,scores]=predict(model,evalating_data);
  
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
  
  training_data=repmat(sqrt(abs(train)).*sign(train),[1 3]).*[0.8*ones(size(train)) 0.6*cos(0.6*log(abs(train)+eps)) 0.6*sin(0.6*log(abs(train)+eps))];
  evalating_data=repmat(sqrt(abs(eval)).*sign(eval),[1 3]).*[0.8*ones(size(eval)) 0.6*cos(0.6*log(abs(eval)+eps)) 0.6*sin(0.6*log(abs(eval)+eps))];

  train_label=[ones(size(train_pos,1),1); ones(size(train_neg,1),1)*(-1)];
  eval_label =[ones(size(eval_pos,1),1); ones(size(eval_neg,1),1)*(-1)];
  
  model=fitcsvm(training_data,train_label,'KernelFunction','linear');
  [predicted_label,scores]=predict(model,evalating_data);
  
  correct=numel(find((predicted_label .* eval_label)==1));
  incorrect=numel(find((predicted_label .* eval_label)==-1));

  correct_rate=correct/(incorrect+correct);
  accuracy2=[accuracy2 correct_rate];
end

%似ていない画像の識別結果
fprintf('Classification rate %f by linear SVM in featuremaps between less similar images\n',mean(accuracy));
%似ている画像の識別結果
fprintf('Classification rate %f by linear SVM in featuremaps between similar images\n',mean(accuracy2));

%{
実行例
Classification rate 0.912500 by linear SVM in featuremaps between less similar images
Classification rate 0.792500 by linear SVM in featuremaps between similar images
%}