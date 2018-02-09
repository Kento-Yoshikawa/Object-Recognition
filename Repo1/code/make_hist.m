function [hist]=make_hist(image)
   I=imread(image);
   
   R_Img=I(:,:,1);
   G_Img=I(:,:,2); 
   B_Img=I(:,:,3);

   X64_Img=floor(double(R_Img)/64) *4*4 + floor(double(G_Img)/64) *4 + floor(double(B_Img)/64);

   X64_Img_reshape=reshape(X64_Img,1,numel(X64_Img));

   h_Img=histc(X64_Img_reshape, [0:63]);

   hist=[h_Img h_Img/sum(h_Img)];
end