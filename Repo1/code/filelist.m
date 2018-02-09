%読み込んだweb画像を一つのリストにまとめる関数を記述したmファイル
function list=filelist()
 
  list={};
  % 今回は カレーと寿司 , カレーとハヤシライスの2クラス分類を行う.
  LIST={'curry' 'sushi' 'hayashi'};
  DIR0='./img/';
  %今回自分が行った場合はカレントディレクトリは 
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
