%{
元画像に似ている画像と似ていない画像による2クラス分類を
Nearest Neighbor法を適用して結果を分類したmファイル
%}
load('codebook.mat','codebook');
load('code.mat','code');

bovw=transpose(code);

%元のポジティブ画像
bovw_pos=bovw(1:200,:);
%元の画像(カレーと似ている画像,ハヤシライス)
bovw_similar=bovw(401:600,:);
bovw_bet_similar=[bovw_pos;bovw_similar];%元画像と似ている画像をまとめた画像リスト

dist=squareform(pdist(bovw(1:400,:)));
dist2=squareform(pdist(bovw_bet_similar(1:400,:)));

correct=0;
incorrect=0;

correct2=0;
incorrect2=0;

dist=dist + 10000*eye(size(dist));
dist2=dist2 + 10000*eye(size(dist2));


for i=1:200
  [v idx1]=min(dist(i,:));
  [v idx2]=min(dist2(i,:));
  if idx1<=200 
    correct=correct+1;
  else
    incorrect=incorrect+1;
  end

    if idx2<=200
      correct2=correct2+1;
   else
      incorrect2=incorrect2+1;
    end
end

for i=201:400
  [v idx3]=min(dist(i,:));
  [v idx4]=min(dist2(i,:));
  
  if idx3<=200 
    incorrect=incorrect+1;
  else
    correct=correct+1;
  end
  
  if idx4<=200
    incorrect2=incorrect2+1;
  else
    correct2=correct2+1;
  end
end

 
fprintf('classification rate by nearest neighbor betweeen less simlar images: %.5f\n',correct/(correct+incorrect));
fprintf('classification rate by nearest neighbor betweeen simlar images: %.5f\n',correct2/(correct2+incorrect2));

%{
実行例
classification rate by nearest neighbor betweeen less simlar images: 0.80250
classification rate by nearest neighbor betweeen simlar images: 0.66000

%}
