%{
Naive Bayes法を用いるためのBoFベクトルを作成するためのmファイル
mk_code_vecに対して正規化の処理を行わないようにしたものである.
%}
function code_nnormal=mk_code_vec_nnormal()
 
  load('codebook.mat','codebook');
  load('flist.mat','list');
  dim=size(codebook,1);
  k=size(codebook,2);
 
  addpath('/usr/local/class/object/MATLAB/sift');
 
  code_nnormal=[];
 
  for i=1:length(list)
    I=im2double(rgb2gray(imread(list{i})));
    fprintf('reading [%d] %s\n',i,list{i});
    [f d]=sift_rand(I,'randn',2000);
    nd=size(d,2);
    d1=repmat(d',k,1);
    c1=reshape((ones(nd,1)*reshape(codebook',1,dim*k)),k*nd,dim);
    dist=sum(((d1-c1).^2)');
    dist=reshape(dist,nd,k);
    [m idx]=min(dist');
    c=histcounts(idx,k);
    code_nnormal=[code_nnormal c'];
  end
  
  save('code_nnormal.mat','code_nnormal');
  