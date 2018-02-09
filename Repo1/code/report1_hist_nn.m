%{
元画像に似ている画像と似ていない画像による2クラス分類を
ヒストグラムとNearest Neighbor法を用いて結果を分類したmファイル
%}
load('filelist.mat','list');

Data=transpose(list);

data_pos=Data(1:200,:);
data_neg=Data(201:400,:);%元画像と似ていない画像
data_neg2=Data(401:600,:);%元画像と似ている画像

cv=5;
n=200;
idx=[1:n];
accuracy=[];
accuracy2=[];

%元画像と似ていない画像での5-fold cross validationによる分類
for i=1:cv

eval_pos =data_pos(find(mod(idx,cv)==(i-1)),:);
train_pos=data_pos(find(mod(idx,cv)~=(i-1)),:);
eval_neg =data_neg(find(mod(idx,cv)==(i-1)),:);
train_neg=data_neg(find(mod(idx,cv)~=(i-1)),:);

train=[train_pos; train_neg];
eval=[eval_pos; eval_neg];

database_train=[];
database_eval=[];

%学習データのヒストグラムを作成しそれをデータベースと命名
for j=1:size(train,1)
	train_hist=make_hist(train{j});
    database_train=[database_train; train_hist];
end

for k=1:size(eval,1)
	eval_hist=make_hist(eval{k});%評価データ用のカラーヒストグラムの作成
    database_eval=[database_eval; eval_hist];
    
    result=[];
    %認識結果表示用 学習用データと評価用データのヒストグラムインターセクションを求める
    for l=1:length(train_hist)
        result=[result sum(min(train_hist(:,l),eval_hist))];
    end
end

   %インターセクション値の大きいものから順にソートする
   [sorted, index]=sort(result,'descend');


   %Nearest Neighbor法の適用 評価用,学習用を合わせたヒストグラム
   database=[database_train;database_eval];

   dist=squareform(pdist(database(1:400,:)));
   correct=0;
   incorrect=0;

  dist=dist + 10000*eye(size(dist));


  for m=1:200
	[v idx1]=min(dist(m,:));
    if idx1<=200 
      correct=correct+1;
    else
      incorrect=incorrect+1;
    end
  end

  for n=201:400
	  [v idx2]=min(dist(n,:));
    if idx2<=200 
      incorrect=incorrect+1;
     else
      correct=correct+1;
    end
  end
correct_rate=correct/(correct+incorrect);      
accuracy=[accuracy correct_rate];
end



%元画像と似ている画像での5-fold cross validationによる分類

for i=1:cv
     eval_pos =data_pos(find(mod(idx,cv)==(i-1)),:);
     train_pos=data_pos(find(mod(idx,cv)~=(i-1)),:);
     eval_neg =data_neg2(find(mod(idx,cv)==(i-1)),:);
     train_neg=data_neg2(find(mod(idx,cv)~=(i-1)),:);

     train=[train_pos; train_neg];
     eval=[eval_pos; eval_neg];

     database_train=[];
     database_eval=[];

    %学習データのヒストグラムを作成しそれをデータベースと命名
     for j=1:size(train,1)
          train_hist=make_hist(train{j});
          database_train=[database_train; train_hist];
     end

       for k=1:size(eval,1)
         eval_hist=make_hist(eval{k});%評価データ用のカラーヒストグラムの作成
         database_eval=[database_eval; eval_hist];
          result=[];
        %認識結果表示用 学習用データと評価用データのヒストグラムインターセクションを求める
         for l=1:length(train_hist)
          result=[result sum(min(train_hist(:,l),eval_hist))];
         end
       end
       
       %インターセクション値の大きいものから順にソートする
       [sorted, index2]=sort(result,'descend');

     %Nearest Neighbor法の適用 評価用,学習用を合わせたヒストグラム
      database=[database_train;database_eval];

      dist=squareform(pdist(database(1:400,:)));
      correct=0;     
      incorrect=0;

      dist=dist + 10000*eye(size(dist));


    for m=1:200
         [v idx1]=min(dist(m,:));
       if idx1<=200
          correct=correct+1;
       else
          incorrect=incorrect+1;
       end
  end

      for n=201:400
 	    [v idx2]=min(dist(n,:));
         if idx2<=200
            incorrect=incorrect+1;
         else
           correct=correct+1;
         end
      end
  
  correct_rate=correct/(correct+incorrect);
  accuracy2=[accuracy2 correct_rate];
end

fprintf('classification rate between less similar images by histgram and Nearest Neighbor: %.5f\n',mean(accuracy));
fprintf('classification rate between similar images by histgram and Nearest Neighbor: %.5f\n',mean(accuracy2));

%似ていない同士の画像の認識結果を上位5つを出してみる
for i=1:5
 subplot(1,5,i),imshow(imread(list{index(i)}));
end

figure;
%似ていない同士の画像の認識結果を上位5つを出してみる
for j=1:5
 subplot(1,5,j),imshow(imread(list{index2(j)}));
end

%{
classification rate between less similar images by histgram and Nearest Neighbor: 0.77300
classification rate between similar images by histgram and Nearest Neighbor: 0.82800
%}
