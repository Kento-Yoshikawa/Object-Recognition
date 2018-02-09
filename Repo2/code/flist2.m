%{
  今回のポジティブ画像とネガティブ画像を一つのリストとしてまとめるmファイル
    (リランキングを行った別の画像用)
%}
function list2=flist2()
  list2={};
  LIST={'fried_egg','bgimg'};%順にポジティブ画像リストのディレクトリとネガティブ画像リストのディレクトリ
  DIR0='./';%今回自分はカレントディレクトリとして
  for i=1:length(LIST)
    DIR=strcat(DIR0,LIST(i),'/')
    W=dir(DIR{:});
    for j=1:size(W)
      if (strfind(W(j).name,'.jpg'))
        fn=strcat(DIR{:},W(j).name);
	    list2={list2{:} fn};
      end
    end
  end
    save('filelist2.mat','list2');
end
