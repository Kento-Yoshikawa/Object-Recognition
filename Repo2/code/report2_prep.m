%画像の収集とダウンロードを行うmファイル

%web画像の読み込み Flickerにcomputerと検索したときの画像300枚
textlist=textread('urllist.txt','%s');

%web画像の読み込み Flickerにfried eggと検索したときの画像300枚
textlist_another=textread('friedegglist.txt','%s');

%コンピュータの画像のダウンロード
%{
OUTDIR='img';
mkdir(OUTDIR);
for i=1:size(textlist,1)
  fname=strcat(OUTDIR,'/',num2str(i,'%04d'),'.jpg');
  websave(fname,textlist{i});
end
%}

%目玉焼きの画像のダウンロード

  OUTDIR='fried_egg';
  mkdir(OUTDIR);
  for i=1:size(textlist_another,1)
	  fname=strcat(OUTDIR,'/',num2str(i,'%04d'),'.jpg');
  websave(fname,textlist_another{i});
end
 

