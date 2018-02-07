%{
今回のポジティブ画像とネガティブ画像を一つのリストとしてまとめるmファイル
%}
function list=flist()
  list={};
  LIST={'img','bgimg'};%順にポジティブ画像リストのディレクトリとネガティブ画像リストのディレクトリ
  DIR0='./';
  for i=1:length(LIST)
    DIR=strcat(DIR0,LIST(i),'/')
    W=dir(DIR{:});
    for j=1:size(W)
      if (strfind(W(j).name,'.jpg'))
        fn=strcat(DIR{:},W(j).name);
	    list={list{:} fn};
      end
    end
  end
    save('filelist.mat','list');
end
