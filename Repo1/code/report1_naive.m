%{
元画像に似ている画像と似ていない画像による2クラス分類を
ナイーブベイズ法を適用して結果を分類したmファイル
%}
load('code_nnormal.mat','code_nnormal');%正規化していない元画像と元画像に似ている画像,似ていない画像のBoFベクトル
bof=transpose(code_nnormal);

D_pos=bof(1:200,:);
D_neg=bof(201:400,:);%寿司(似ていない画像)のBoFベクトル
D_neg2=bof(401:600,:);%ハヤシライス(似ている画像)のBoFベクトル

pr_pos=sum(D_pos)+1;
pr_pos=pr_pos/sum(pr_pos);
pr_pos=log(pr_pos);

pr_neg=sum(D_neg)+1;
pr_neg=pr_neg/sum(pr_neg);
pr_neg=log(pr_neg);

pr_neg2=sum(D_neg2)+1;
pr_neg2=pr_neg2/sum(pr_neg2);
pr_neg2=log(pr_neg2);

%{
cv=5;
n=200;
idx=[1:n];
accuracy=[];

for i=1:cv

eval_pos =D_pos(find(mod(idx,cv)==(i-1)),:);
train_pos=D_pos(find(mod(idx,cv)~=(i-1)),:);
eval_neg =D_neg(find(mod(idx,cv)==(i-1)),:);
train_neg=D_neg(find(mod(idx,cv)~=(i-1)),:);

train=[train_pos; train_neg];
eval=[eval_pos; eval_neg];


pr_pos=sum(train_pos)+1;
pr_pos=pr_pos/sum(pr_pos);
pr_pos=log(pr_pos);

pr_neg=sum(train_neg)+1;
pr_neg=pr_neg/sum(pr_neg);
pr_neg=log(pr_neg);


pr_pos2=sum(eval_pos)+1;
pr_pos2=pr_pos2/sum(pr_pos2);
pr_pos2=log(pr_pos2);

pr_neg2=sum(eval_neg)+1;
pr_neg2=pr_neg2/sum(pr_neg2);
pr_neg2=log(pr_neg2);


correct=0;
incorrect=0;

%ポジティブ画像に対して分類を行う
for j=1:160
  im_neg_train=train(j,:);%学習画像のうちポジティブ画像のみを抽出
  max0=max(im_neg_train);
  idx=[];
  for l=1:max0
    idx=[idx find(im_neg_train>=l)];
  end
  
  %学習画像のポジティブ画像のbovwベクトルim_pos_trainに対応するpr_pos,pr_negの和
  pr_im_pos_train=sum(pr_pos(idx));
  pr_im_neg_train=sum(pr_neg(idx));
 
  %評価画像のbovwベクトルim_pos_evalに対応するpr_pos2,pr_neg2の和を求め
  %学習画像,pr_im_neg_trainより,pr_im_pos_evalの値が大きければ
  %評価データをポジティブ画像として正しく認識したと判定
  for k=1:40
      im_pos_eval=eval(k,:);
      max1=max(im_pos_eval);
      idx2=[];
      for m=1:max1
        idx2=[idx2 find(im_pos_eval>=m)];
      end
     pr_im_pos_eval=sum(pr_pos2(idx2));
     pr_im_neg_eval=sum(pr_neg2(idx2));
     
      if pr_im_neg_train < pr_im_pos_eval
          correct=correct+1;
      else
          incorrect=incorrect+1;
      end
  end
  
end

%ネガディブ画像に対して分類を行う
for j=160:320
  im_neg_train=train(j,:);%学習画像のうちポジティブ画像のみを抽出
  max0=max(im_neg_train);
  idx=[];
  for l=1:max0
    idx=[idx find(im_neg_train>=l)];
  end
  
  %学習画像のポジティブ画像のbovwベクトルim_pos_trainに対応するpr_pos,pr_negの和
  pr_im_pos_train=sum(pr_pos(idx));
  pr_im_neg_train=sum(pr_neg(idx));
 
  %評価画像のbovwベクトルim_neg_evalに対応するpr_pos2,pr_neg2の和を求め
  %学習画像,pr_im_pos_trainより,pr_im_neg_evalの値が大きければ
  %評価データをネガティブ画像として正しく認識したと判定
  for k=1:40
      im_neg_eval=eval(k,:);
      max1=max(im_neg_eval);
      idx2=[];
      for m=1:max1
        idx2=[idx2 find(im_neg_eval>=m)];
      end
     pr_im_pos_eval=sum(pr_pos2(idx2));
     pr_im_neg_eval=sum(pr_neg2(idx2));
     
      if pr_im_pos_train < pr_im_neg_eval
          correct=correct+1;
      else
          incorrect=incorrect+1;
      end
  end
 
end
correct_rate=correct/(correct+incorrect);
accuracy=[accuracy correct_rate];
end


for i=1:cv

eval_pos =D_pos(find(mod(idx,cv)==(i-1)),:);
train_pos=D_pos(find(mod(idx,cv)~=(i-1)),:);
eval_neg =D_neg2(find(mod(idx,cv)==(i-1)),:);
train_neg=D_neg2(find(mod(idx,cv)~=(i-1)),:);

train=[train_pos; train_neg];
eval=[eval_pos; eval_neg];


pr_pos=sum(train_pos)+1;
pr_pos=pr_pos/sum(pr_pos);
pr_pos=log(pr_pos);

pr_neg=sum(train_neg)+1;
pr_neg=pr_neg/sum(pr_neg);
pr_neg=log(pr_neg);


pr_pos2=sum(eval_pos)+1;
pr_pos2=pr_pos2/sum(pr_pos2);
pr_pos2=log(pr_pos2);

pr_neg2=sum(eval_neg)+1;
pr_neg2=pr_neg2/sum(pr_neg2);
pr_neg2=log(pr_neg2);


correct=0;
incorrect=0;

%ポジティブ画像に対して分類を行う
for j=1:160
  im_neg_train=train(j,:);%学習画像のうちポジティブ画像のみを抽出
  max0=max(im_neg_train);
  idx=[];
  for l=1:max0
    idx=[idx find(im_neg_train>=l)];
  end
  
  %学習画像のポジティブ画像のbovwベクトルim_pos_trainに対応するpr_pos,pr_negの和
  pr_im_pos_train=sum(pr_pos(idx));
  pr_im_neg_train=sum(pr_neg(idx));
 
  %評価画像のbovwベクトルim_pos_evalに対応するpr_pos2,pr_neg2の和を求め
  %学習画像,pr_im_neg_trainより,pr_im_pos_evalの値が大きければ
  %評価データをポジティブ画像として正しく認識したと判定
  for k=1:40
      im_pos_eval=eval(k,:);
      max1=max(im_pos_eval);
      idx2=[];
      for m=1:max1
        idx2=[idx2 find(im_pos_eval>=m)];
      end
     pr_im_pos_eval=sum(pr_pos2(idx2));
     pr_im_neg_eval=sum(pr_neg2(idx2));
     
      if pr_im_neg_train < pr_im_pos_eval
          correct=correct+1;
      else
          incorrect=incorrect+1;
      end
  end
  
end

%ネガディブ画像に対して分類を行う
for j=160:320
  im_neg_train=train(j,:);%学習画像のうちポジティブ画像のみを抽出
  max0=max(im_neg_train);
  idx=[];
  for l=1:max0
    idx=[idx find(im_neg_train>=l)];
  end
  
  %学習画像のポジティブ画像のbovwベクトルim_pos_trainに対応するpr_pos,pr_negの和
  pr_im_pos_train=sum(pr_pos(idx));
  pr_im_neg_train=sum(pr_neg(idx));
 
  %評価画像のbovwベクトルim_neg_evalに対応するpr_pos2,pr_neg2の和を求め
  %学習画像,pr_im_pos_trainより,pr_im_neg_evalの値が大きければ
  %評価データをネガティブ画像として正しく認識したと判定
  for k=1:40
      im_neg_eval=eval(k,:);
      max1=max(im_neg_eval);
      idx2=[];
      for m=1:max1
        idx2=[idx2 find(im_neg_eval>=m)];
      end
     pr_im_pos_eval=sum(pr_pos2(idx2));
     pr_im_neg_eval=sum(pr_neg2(idx2));
     
      if pr_im_pos_train < pr_im_neg_eval
          correct=correct+1;
      else
          incorrect=incorrect+1;
      end
  end
 
end
correct_rate=correct/(correct+incorrect);
accuracy2=[accuracy2 correct_rate];
end

%カレーと寿司の識別結果(似ていない画像)
fprintf('Classification rate %.5f by naive bayes between less similar images \n',mean(accuracy));
%カレーとハヤシライスの識別結果(似ている画像)
fprintf('Classification rate %.5f by naive bayes between similar images \n',mean(accuracy2));
%}

%正答数と不正答数
correct=0;
incorrect=0;

correct2=0;
incorrect2=0;

%ポジティブ画像に対する分類
for j=1:200
 im=D_pos(j,:);
 max0=max(im);
 idx=[];
 for i=1:max0
   idx=[idx find(im>=i)];
 end
 
 pr_im_pos=sum(pr_pos(idx));
 pr_im_neg=sum(pr_neg(idx));
 
 if pr_im_neg < pr_im_pos
    correct=correct+1;
    correct2=correct2+1;
 else
     incorrect=incorrect+1;
     incorrect2=incorrect2+1;
 end
 
end

%ネガティブ画像に対する分類
for k=1:200
 im=D_neg(k,:);
 im2=D_neg2(k,:);
 max0=max(im);
 max1=max(im2);
 idx=[ ];
 idx2=[];
 
 for l=1:max0
   idx=[idx find(im>=l)];
 end
 
 for t=1:max1
   idx2=[idx2 find(im2>=t)];
 end
 
 pr_im_pos=sum(pr_pos(idx));
 pr_im_neg=sum(pr_neg(idx));
 
 pr_im_pos2=sum(pr_pos(idx2));
 pr_im_neg2=sum(pr_neg(idx2));
 
 %元画像と似ていない画像に対する処理
 if pr_im_pos < pr_im_neg
    correct=correct+1;
 else
     incorrect=incorrect+1;
 end
 
 %元画像と似ている画像に対する処理
 if pr_im_pos2 < pr_im_neg2
    correct2=correct2+1;
 else
     incorrect2=incorrect2+1;
 end
 
end

%元画像と似ている画像と似ていない画像それぞれの分類率を計算
correct_rate=correct/(correct+incorrect);
correct_rate2=correct2/(correct2+incorrect2);

%カレーと寿司の識別結果(似ていない画像)
fprintf('Classification rate %.5f by naive bayes between less similar images \n',correct_rate);
%カレーとハヤシライスの識別結果(似ている画像)
fprintf('Classification rate %.5f by naive bayes between similar images \n',correct_rate2);
%{
実行例
Classification rate 0.91500 by naive bayes between less similar images 
Classification rate 0.61500 by naive bayes between similar images 

%}

