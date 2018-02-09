%{
今回,リランキング実験を行うMain部分になる
mファイル
%}
addpath('/usr/local/class/object/matconvnet');
addpath('/usr/local/class/object/matconvnet/matlab');
vl_setupnn;


net = load('imagenet-caffe-alex.mat') ;

%flist.mの内容を参照
load('filelist.mat','list');
%flist2.mの内容を参照
load('filelist2.mat','list2');

%ポジティブ学習画像の枚数 
n1=25;
n2=50;

%リストを転置して利用
imglist=transpose(list);
imglist2=transpose(list2);

%ポジティブ学習画像とネガティブ学習画像
train_pos=imglist(1:n2,:);%ここをn1やn2と状況に応じて変えて結果を実行した,以下も同様
train_neg=imglist(301:1300,:);

train_pos2=imglist2(1:n2,:);%ここをn1やn2と状況に応じて変えて結果を実行した,以下も同様
train_neg2=imglist2(301:1300,:);

%残りの未使用のテスト画像
%test_list=imglist((n2+1):300,:);
test_list2=imglist2((n2+1):300,:);

train_list=[train_pos;train_neg];
train_list2=[train_pos2;train_neg2];

dcnn_list=[];%学習用のDCNN特徴量を格納するリスト
test_dcnn_list=[];%テスト用のDCNN特徴を格納するリスト

dcnn_list2=[];%学習用のDCNN特徴量を格納するリスト
test_dcnn_list2=[];%テスト用のDCNN特徴を格納するリスト


%各学習画像のDCNN特徴の抽出開始
for i=1:length(train_list)
im = imread(train_list{i});
im_ = single(im); 
im_ = imresize(im_, net.meta.normalization.imageSize(1:2));
im_ = im_ - net.meta.normalization.averageImage;

res = vl_simplenn(net, im_);

dcnnf=squeeze(res(end-3).x);
dcnnf=dcnnf/norm(dcnnf);
dcnn_list=[dcnn_list dcnnf];
end

%各テスト画像のDCNN特徴の抽出開始
for i=1:length(test_list)
im = imread(test_list{i});
im_ = single(im); 
im_ = imresize(im_, net.meta.normalization.imageSize(1:2));
im_ = im_ - net.meta.normalization.averageImage;

res = vl_simplenn(net, im_);

dcnnf=squeeze(res(end-3).x);
dcnnf=dcnnf/norm(dcnnf);
test_dcnn_list=[test_dcnn_list dcnnf];
end

train_dcnn_list=transpose(dcnn_list);
test_dcnn_list=transpose(test_dcnn_list);


for i=1:length(train_list2)
	im = imread(train_list2{i});
im_ = single(im);
im_ = imresize(im_, net.meta.normalization.imageSize(1:2));
im_ = im_ - net.meta.normalization.averageImage;

res = vl_simplenn(net, im_);

dcnnf=squeeze(res(end-3).x);
dcnnf=dcnnf/norm(dcnnf);
dcnn_list2=[dcnn_list2 dcnnf];
end



%各テスト画像のDCNN特徴の抽出開始
for i=1:length(test_list2)
	im = imread(test_list2{i});
im_ = single(im);
im_ = imresize(im_, net.meta.normalization.imageSize(1:2));
im_ = im_ - net.meta.normalization.averageImage;

res = vl_simplenn(net, im_);

dcnnf=squeeze(res(end-3).x);
dcnnf=dcnnf/norm(dcnnf);
test_dcnn_list2=[test_dcnn_list2 dcnnf];
end

train_dcnn_list2=transpose(dcnn_list2);
test_dcnn_list2=transpose(test_dcnn_list2);


%学習用ラベルの作成
train_label=[ones(size(dcnn_list(1:n2,:),1),1); ones(size(dcnn_list(n2+1:1050,:),1),1)*(-1)];
train_label2=[ones(size(dcnn_list2(1:n2,:),1),1); ones(size(dcnn_list2(n2+1:1050,:),1),1)*(-1)];

%線形SVMにより学習
train_model=fitcsvm(train_dcnn_list,train_label,'KernelFunction','linear');
train_model2=fitcsvm(train_dcnn_list2,train_label2,'KernelFunction','linear');

%分類
[predicted_label,score]=predict(train_model,test_dcnn_list);
[predicted_label2,score2]=predict(train_model2,test_dcnn_list2);


% 降順 ('descent') でソートして，ソートした値とソートインデックスを取得
[sorted_score,sorted_idx]=sort(score(:,2),'descend');
[sorted_score2,sorted_idx2]=sort(score2(:,2),'descend');

% sorted_idxを使って画像ファイル名，さらに
% sorted_score(i)(=score(sorted_idx(i),2))の値を出力

for i=1:numel(sorted_idx)
  fprintf('%s %f\n',list{sorted_idx(i)},sorted_score(i));
end


for j=1:numel(sorted_idx2)
	fprintf('%s %f\n',list2{sorted_idx2(j)},sorted_score2(j));
end









