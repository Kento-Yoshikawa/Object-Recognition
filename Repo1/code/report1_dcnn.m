%{
元画像に似ている画像と似ていない画像による2クラス分類を
AlexNet,高速版ネット,高精度版ネット(VGG-16)によるDCNN特徴をそれぞれ抽出して
それぞれのネットに対して線形SVM,非線形SVMを用いて結果を分類したmファイル
%}

addpath('/usr/local/class/object/matconvnet');
addpath('/usr/local/class/object/matconvnet/matlab');
vl_setupnn;

load('filelist.mat','list');

net_lst = {load('imagenet-caffe-alex.mat'),load('imagenet-vgg-f.mat'),load('imagenet-vgg-verydeep-16.mat')};

%AlexNet,高速版ネット,高精度版ネットによるDCNN特徴の格納をする配列の初期化
caffe_alex_lst=[];
vgg_lst=[];
vgg_verydeep_lst=[];

%AlexNet
for i=1:length(list)
im = imread(list{i});
im_ = single(im); 
im_ = imresize(im_, net_lst{1}.meta.normalization.imageSize(1:2));
im_ = im_ - net_lst{1}.meta.normalization.averageImage;

res = vl_simplenn(net_lst{1}, im_);

dcnnf=squeeze(res(end-3).x);
dcnnf=dcnnf/norm(dcnnf);
caffe_alex_lst=[caffe_alex_lst dcnnf];
end

%高速版ネット
for i=1:length(list)
im = imread(list{i});
im_ = single(im); 
im_ = imresize(im_, net_lst{2}.meta.normalization.imageSize(1:2));
im_ = im_ - net_lst{2}.meta.normalization.averageImage;

res = vl_simplenn(net_lst{2}, im_);

dcnnf=squeeze(res(end-3).x);
dcnnf=dcnnf/norm(dcnnf);
vgg_lst=[vgg_lst dcnnf];
end

%高精度版ネット
for i=1:length(list)
im = imread(list{i});
im_ = single(im); 
im_ = imresize(im_, net_lst{3}.meta.normalization.imageSize(1:2));
im_ = im_ - repmat(net_lst{3}.meta.normalization.averageImage,net_lst{3}.meta.normalization.imageSize(1:2));

res = vl_simplenn(net_lst{3}, im_);

dcnnf=squeeze(res(end-3).x);
dcnnf=dcnnf/norm(dcnnf);
vgg_verydeep_lst=[vgg_verydeep_lst dcnnf];
end

caffe_alex_layer=transpose(caffe_alex_lst);
vgg_layer=transpose(vgg_lst);
vgg_verydeep_layer=transpose(vgg_verydeep_lst);

%順にカレー(ポジティブ画像),寿司(ポジティブ画像と似ていない画像),ハヤシライス(ポジティブ画像に似ている画像)としている
alex_pos=caffe_alex_layer(1:200,:);
alex_neg=caffe_alex_layer(201:400,:);
alex_neg2=caffe_alex_layer(401:600,:);

vgg_pos=vgg_layer(1:200,:);
vgg_neg=vgg_layer(201:400,:);
vgg_neg2=vgg_layer(401:600,:);

vdeep_pos=vgg_verydeep_layer(1:200,:);
vdeep_neg=vgg_verydeep_layer(201:400,:);
vdeep_neg2=vgg_verydeep_layer(401:600,:);

cv=5;
n=200;
idx=[1:n];

%順にカレーと寿司の線形SVM,非線形SVM, カレーとハヤシライスの線形SVM,非線形SVM用の
%結果を格納するリストの初期化
accuracy_alex=[];
accuracy_alex_nlinear=[];
accuracy_alex2=[];
accuracy_alex2_nlinear=[];

accuracy_vgg=[];
accuracy_vgg_nlinear=[];
accuracy_vgg2=[];
accuracy_vgg2_nlinear=[];

accuracy_vdeep=[];
accuracy_vdeep_nlinear=[];
accuracy_vdeep2=[];
accuracy_vdeep2_nlinear=[];

%処理が分かりにくくなるため似ているもの同士,似ていないもの同士で処理を分けることにする.

%まずAlexNetの似ていない画像による5-fold cross validationでの分類
for i=1:cv  
  
  eval_pos =alex_pos(find(mod(idx,cv)==(i-1)),:);
  train_pos=alex_pos(find(mod(idx,cv)~=(i-1)),:);
  eval_neg =alex_neg(find(mod(idx,cv)==(i-1)),:);
  train_neg=alex_neg(find(mod(idx,cv)~=(i-1)),:);

  eval=[eval_pos; eval_neg];
  train=[train_pos; train_neg];
  
  eval_label =[ones(size(eval_pos,1),1); ones(size(eval_neg,1),1)*(-1)];
  train_label=[ones(size(train_pos,1),1); ones(size(train_neg,1),1)*(-1)];
  
  model=fitcsvm(train,train_label,'KernelFunction','linear');
  [predicted_label,scores]=predict(model,eval);
   
  model_nlinear=fitcsvm(train,train_label,'KernelFunction','rbf','KernelScale','auto');
  [predicted_label_nlinear,scores_nlinear]=predict(model_nlinear,eval);
  
  correct=numel(find((predicted_label .* eval_label)==1));
  incorrect=numel(find((predicted_label .* eval_label)==-1));
  
  correct_nlinear=numel(find((predicted_label_nlinear .* eval_label)==1));
  incorrect_nlinear=numel(find((predicted_label_nlinear .* eval_label)==-1));

  correct_rate=correct/(incorrect+correct);
  correct_rate_nlinear=correct_nlinear/(incorrect_nlinear+correct_nlinear);
  
  accuracy_alex=[accuracy_alex correct_rate];
  accuracy_alex_nlinear=[accuracy_alex_nlinear correct_rate_nlinear];
end

%AlexNetの似ている画像による5-fold cross validationでの分類
for i=1:cv  
  
  eval_pos =alex_pos(find(mod(idx,cv)==(i-1)),:);
  train_pos=alex_pos(find(mod(idx,cv)~=(i-1)),:);
  eval_neg =alex_neg2(find(mod(idx,cv)==(i-1)),:);
  train_neg=alex_neg2(find(mod(idx,cv)~=(i-1)),:);

  eval=[eval_pos; eval_neg];
  train=[train_pos; train_neg];
  
  eval_label =[ones(size(eval_pos,1),1); ones(size(eval_neg,1),1)*(-1)];
  train_label=[ones(size(train_pos,1),1); ones(size(train_neg,1),1)*(-1)];
  
  model=fitcsvm(train,train_label,'KernelFunction','linear');
  [predicted_label,scores]=predict(model,eval);
   
  model_nlinear=fitcsvm(train,train_label,'KernelFunction','rbf','KernelScale','auto');
  [predicted_label_nlinear,scores_nlinear]=predict(model_nlinear,eval);
  
  correct=numel(find((predicted_label .* eval_label)==1));
  incorrect=numel(find((predicted_label .* eval_label)==-1));
  
  correct_nlinear=numel(find((predicted_label_nlinear .* eval_label)==1));
  incorrect_nlinear=numel(find((predicted_label_nlinear .* eval_label)==-1));

  correct_rate=correct/(incorrect+correct);
  correct_rate_nlinear=correct_nlinear/(incorrect_nlinear+correct_nlinear);
  
  accuracy_alex2=[accuracy_alex2 correct_rate];
  accuracy_alex2_nlinear=[accuracy_alex2_nlinear correct_rate_nlinear];
end

%高速版ネットの似ていない画像による5-fold cross validationでの分類
for i=1:cv
  eval_pos =vgg_pos(find(mod(idx,cv)==(i-1)),:);
  train_pos=vgg_pos(find(mod(idx,cv)~=(i-1)),:);
  eval_neg =vgg_neg(find(mod(idx,cv)==(i-1)),:);
  train_neg=vgg_neg(find(mod(idx,cv)~=(i-1)),:);

  eval=[eval_pos; eval_neg];
  train=[train_pos; train_neg];

  eval_label =[ones(size(eval_pos,1),1); ones(size(eval_neg,1),1)*(-1)];
  train_label=[ones(size(train_pos,1),1); ones(size(train_neg,1),1)*(-1)];
  
  model=fitcsvm(train,train_label,'KernelFunction','linear');
  [predicted_label,scores]=predict(model,eval);
  
  model_nlinear=fitcsvm(train,train_label,'KernelFunction','rbf','KernelScale','auto');
  [predicted_label_nlinear,scores_nlinear]=predict(model_nlinear,eval);
  
  correct=numel(find((predicted_label .* eval_label)==1));
  incorrect=numel(find((predicted_label .* eval_label)==-1));
  
  correct_nlinear=numel(find((predicted_label_nlinear .* eval_label)==1));
  incorrect_nlinear=numel(find((predicted_label_nlinear .* eval_label)==-1));
 
  correct_rate=correct/(incorrect+correct);
  correct_rate_nlinear=correct_nlinear/(incorrect_nlinear+correct_nlinear);
  
  accuracy_vgg=[accuracy_vgg correct_rate];
  accuracy_vgg_nlinear=[accuracy_vgg_nlinear correct_rate_nlinear];
end

%高速版ネットの似ている画像による5-fold cross validationでの分類
for i=1:cv
  eval_pos =vgg_pos(find(mod(idx,cv)==(i-1)),:);
  train_pos=vgg_pos(find(mod(idx,cv)~=(i-1)),:);
  eval_neg =vgg_neg2(find(mod(idx,cv)==(i-1)),:);
  train_neg=vgg_neg2(find(mod(idx,cv)~=(i-1)),:);

  eval=[eval_pos; eval_neg];
  train=[train_pos; train_neg];

  eval_label =[ones(size(eval_pos,1),1); ones(size(eval_neg,1),1)*(-1)];
  train_label=[ones(size(train_pos,1),1); ones(size(train_neg,1),1)*(-1)];
  
  model=fitcsvm(train,train_label,'KernelFunction','linear');
  [predicted_label,scores]=predict(model,eval);
  
  model_nlinear=fitcsvm(train,train_label,'KernelFunction','rbf','KernelScale','auto');
  [predicted_label_nlinear,scores_nlinear]=predict(model_nlinear,eval);
  
  correct=numel(find((predicted_label .* eval_label)==1));
  incorrect=numel(find((predicted_label .* eval_label)==-1));
  
  correct_nlinear=numel(find((predicted_label_nlinear .* eval_label)==1));
  incorrect_nlinear=numel(find((predicted_label_nlinear .* eval_label)==-1));
 
  correct_rate=correct/(incorrect+correct);
  correct_rate_nlinear=correct_nlinear/(incorrect_nlinear+correct_nlinear);
  
  accuracy_vgg2=[accuracy_vgg2 correct_rate];
  accuracy_vgg2_nlinear=[accuracy_vgg2_nlinear correct_rate_nlinear];
end

%高精度版ネットの似ていない画像による5-fold cross validationでの分類
for i=1:cv
  eval_pos =vdeep_pos(find(mod(idx,cv)==(i-1)),:);
  train_pos=vdeep_pos(find(mod(idx,cv)~=(i-1)),:);
  eval_neg =vdeep_neg(find(mod(idx,cv)==(i-1)),:);
  train_neg=vdeep_neg(find(mod(idx,cv)~=(i-1)),:);

  eval=[eval_pos; eval_neg];
  train=[train_pos; train_neg];

  eval_label =[ones(size(eval_pos,1),1); ones(size(eval_neg,1),1)*(-1)];
  train_label=[ones(size(train_pos,1),1); ones(size(train_neg,1),1)*(-1)];
  
  model=fitcsvm(train,train_label,'KernelFunction','linear');
  [predicted_label,scores]=predict(model,eval);
  
  model_nlinear=fitcsvm(train,train_label,'KernelFunction','rbf','KernelScale','auto');
  [predicted_label_nlinear,scores_nlinear]=predict(model_nlinear,eval);
  
  correct=numel(find((predicted_label .* eval_label)==1));
  incorrect=numel(find((predicted_label .* eval_label)==-1));
  
  correct_nlinear=numel(find((predicted_label_nlinear .* eval_label)==1));
  incorrect_nlinear=numel(find((predicted_label_nlinear .* eval_label)==-1));

  correct_rate=correct/(incorrect+correct);
  correct_rate_nlinear=correct_nlinear/(incorrect_nlinear+correct_nlinear);
  
  accuracy_vdeep=[accuracy_vdeep correct_rate];
  accuracy_vdeep_nlinear=[accuracy_vdeep_nlinear correct_rate_nlinear];
end

%高精度版ネットの似ている画像による5-fold cross validationでの分類
for i=1:cv
  eval_pos =vdeep_pos(find(mod(idx,cv)==(i-1)),:);
  train_pos=vdeep_pos(find(mod(idx,cv)~=(i-1)),:);
  eval_neg =vdeep_neg2(find(mod(idx,cv)==(i-1)),:);
  train_neg=vdeep_neg2(find(mod(idx,cv)~=(i-1)),:);

  eval=[eval_pos; eval_neg];
  train=[train_pos; train_neg];

  eval_label =[ones(size(eval_pos,1),1); ones(size(eval_neg,1),1)*(-1)];
  train_label=[ones(size(train_pos,1),1); ones(size(train_neg,1),1)*(-1)];
  
  model=fitcsvm(train,train_label,'KernelFunction','linear');
  [predicted_label,scores]=predict(model,eval);
  
  model_nlinear=fitcsvm(train,train_label,'KernelFunction','rbf','KernelScale','auto');
  [predicted_label_nlinear,scores_nlinear]=predict(model_nlinear,eval);
  
  correct=numel(find((predicted_label .* eval_label)==1));
  incorrect=numel(find((predicted_label .* eval_label)==-1));
  
  correct_nlinear=numel(find((predicted_label_nlinear .* eval_label)==1));
  incorrect_nlinear=numel(find((predicted_label_nlinear .* eval_label)==-1));

  correct_rate=correct/(incorrect+correct);
  correct_rate_nlinear=correct_nlinear/(incorrect_nlinear+correct_nlinear);
  
  accuracy_vdeep2=[accuracy_vdeep2 correct_rate];
  accuracy_vdeep2_nlinear=[accuracy_vdeep2_nlinear correct_rate_nlinear];
end


fprintf('accuracy alex linear SVM between less similar images: %f\n',mean(accuracy_alex));
fprintf('accuracy alex non-linear SVM between less similar images: %f\n',mean(accuracy_alex_nlinear));
fprintf('accuracy alex linear SVM  between similar images: %f\n',mean(accuracy_alex2));
fprintf('accuracy alex non-linear SVM between  similar images: %f\n',mean(accuracy_alex2_nlinear));


fprintf('accuracy vgg linear SVM between less similar images: %f\n',mean(accuracy_vgg));
fprintf('accuracy vgg non-linear SVM between less similar images: %f\n',mean(accuracy_vgg_nlinear));
fprintf('accuracy vgg linear SVM  between similar images: %f\n',mean(accuracy_vgg2));
fprintf('accuracy vgg non-linear SVM between  similar images: %f\n',mean(accuracy_vgg2_nlinear));


fprintf('accuracy vgg-verydeep linear SVM between less similar images: %f\n',mean(accuracy_vdeep));
fprintf('accuracy vgg-verydeep non-linear SVM between less similar images: %f\n',mean(accuracy_vdeep_nlinear));
fprintf('accuracy vgg-verydeep linear SVM  between similar images: %f\n',mean(accuracy_vdeep2));
fprintf('accuracy vgg-verydeep non-linear SVM between  similar images: %f\n',mean(accuracy_vdeep2_nlinear));


%{
実行例
accuracy alex linear SVM between less similar images: 0.995000
accuracy alex non-linear SVM between less similar images: 0.990000

accuracy alex linear SVM  between similar images: 0.900000
accuracy alex non-linear SVM between  similar images: 0.917500

accuracy vgg linear SVM between less similar images: 0.997500
accuracy vgg non-linear SVM between less similar images: 0.997500

accuracy vgg linear SVM  between similar images: 0.910000
accuracy vgg non-linear SVM between  similar images: 0.930000

accuracy vgg-verydeep linear SVM between less similar images: 0.997500
accuracy vgg-verydeep non-linear SVM between less similar images: 0.997500

accuracy vgg-verydeep linear SVM  between similar images: 0.917500
accuracy vgg-verydeep non-linear SVM between  similar images: 0.932500

%}
