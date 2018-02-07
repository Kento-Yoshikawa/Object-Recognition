%{
元画像に似ている画像と似ていない画像による2クラス分類を
カラーヒストグラムによる分類を適用して結果を分類したmファイル
%}
load('filelist.mat','list');
filelist=transpose(list);%転置して利用

n=200;
curry_list=filelist(1:n,:);
sushi_list=filelist(n+1:2*n,:);
hayashi_list=filelist(2*n+1:3*n,:);


%各画像のヒストグラムを格納する配列
h1=[];
h2=[];
h3=[];



for i=1:n
curry_img=imread(curry_list{i});
sushi_img=imread(sushi_list{i});
hayashi_img=imread(hayashi_list{i});

%各画像のRGBを取得
R_curry=curry_img(:,:,1);
G_curry=curry_img(:,:,2);
B_curry=curry_img(:,:,3);

R_sushi=sushi_img(:,:,1);
G_sushi=sushi_img(:,:,2);
B_sushi=sushi_img(:,:,3);

R_hayashi=hayashi_img(:,:,1);
G_hayashi=hayashi_img(:,:,2);
B_hayashi=hayashi_img(:,:,3);

X64_curry=floor(double(R_curry)/64) *4*4 + floor(double(G_curry)/64) *4 + floor(double(B_curry)/64);
X64_sushi=floor(double(R_sushi)/64) *4*4 + floor(double(G_sushi)/64) *4 + floor(double(B_sushi)/64);
X64_hayashi=floor(double(R_hayashi)/64) *4*4 + floor(double(G_hayashi)/64) *4 + floor(double(B_hayashi)/64);

X64_curry_reshape=reshape(X64_curry,1,numel(X64_curry));
X64_sushi_reshape=reshape(X64_sushi,1,numel(X64_sushi));
X64_hayashi_reshape=reshape(X64_hayashi,1,numel(X64_hayashi));

%ヒストグラムの作成
h_curry=histc(X64_curry_reshape, [0:63]);
h_sushi=histc(X64_sushi_reshape, [0:63]);
h_hayashi=histc(X64_hayashi_reshape, [0:63]);


%正規化
h1=[h1 h_curry/sum(h_curry)];
h2=[h2 h_sushi/sum(h_sushi)];
h3=[h3 h_hayashi/sum(h_hayashi)];
end



