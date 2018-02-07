%{
BoFベクトルを作成するためのmファイル
模範解答のものをそのまま利用した.
%}
function code=mk_code_vec()
 
  load('codebook.mat','codebook');
  load('flist.mat','list');
  dim=size(codebook,1);
  k=size(codebook,2);
 
  addpath('/usr/local/class/object/MATLAB/sift');
 
  code=[];
 
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
    c=c/sum(c);
    code=[code c'];
  end
  
  save('code.mat','code');
