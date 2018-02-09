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

