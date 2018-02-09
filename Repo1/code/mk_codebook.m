%{
コードブックの生成を行うmファイル
課題の解答のものを今回使う画像用に少しだけ改変.
%}
function [desc codebook]=mk_codebook()
 
  k=1000;
  addpath('/usr/local/class/object/MATLAB/sift');
  run('/usr/local/class/object/MATLAB/vlfeat/vl_setup');
 
  list=filelist();
  pos_idx=[1:200];
  neg_idx=[201:600]; 

  list=list([pos_idx neg_idx]);
 
  desc=[];
  for i=1:length(list)
    I=im2double(rgb2gray(imread(list{i})));
    fprintf('reading [%d] %s\n',i,list{i});
    [f d]=sift_rand(I,'randn',3000);
    desc=[desc d];
  end
 
  size(desc)
  [codebook, idx]=vl_kmeans(desc,k);
  save('codebook.mat','codebook');
  save('flist.mat','list');