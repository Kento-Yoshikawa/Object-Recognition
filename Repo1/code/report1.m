
%{
下準備(web画像の収集)を行うmファイル
今回,カレーをポジティブ画像,寿司をカレーと似ていないネガティブ画像
ハヤシライスをカレーと似ているネガティブ画像とした.
%}

curry_list=textread('curry.txt','%s');
sushi_list=textread('sushi.txt','%s');
hayashi_list=textread('hayashi.txt','%s');


OUTDIR1='img/curry';
mkdir(OUTDIR1);
for i=1:size(curry_list,1)
  fname=strcat(OUTDIR1,'/',num2str(i,'%04d'),'.jpg');
  websave(fname,curry_list{i});
end

OUTDIR2='img/sushi';
mkdir(OUTDIR2);
for i=1:size(sushi_list,1)
  fname=strcat(OUTDIR2,'/',num2str(i,'%04d'),'.jpg');
  websave(fname,sushi_list{i});
end

OUTDIR3='img/hayashi';
mkdir(OUTDIR3);
for i=1:size(hayashi_list,1)
  fname=strcat(OUTDIR3,'/',num2str(i,'%04d'),'.jpg');
  websave(fname,hayashi_list{i});
end

