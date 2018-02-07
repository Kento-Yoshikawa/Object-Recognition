%画像の収集とダウンロードを行うmファイル

%web画像の読み込み Flickerにcomputerと検索したときの画像300枚
textlist=textread('urllist.txt','%s');

%画像のダウンロード
{
OUTDIR='img';
mkdir(OUTDIR);
for i=1:size(textlist,1)
  fname=strcat(OUTDIR,'/',num2str(i,'%04d'),'.jpg');
  websave(fname,list{i});
end
}