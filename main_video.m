%% =====   MINI PROJECT E/16/177   ===== %%
close all
clear all
clc
%% add to path 
cd 'D:\7th sem\EE596-Image and Video Coding\Mini Project\my_project\video';
%% Video to frames
% % video = 'opt.mp4';
% % Folder = 'images_04';
% % video2frames(video,Folder);
%%pause;
%% read images
listing = dir('images_02\*.jpg');
cd 'images_02';
name = {listing.name};
% % ori_im = imread(name{1});
% % figure;
% % imshow(ori_im);
% % title('Original Image');
num_im = 5;
images = cell(num_im  , 1);
for i=1:num_im
    images{i,1} = rgb2gray(imread(name{i}));
end
% cd 'D:\7th sem\EE596-Image and Video Coding\Mini Project\my_project\video';
%%  Split to macro blocks
macro = cell(num_im  , 1);
for i=1:num_im
    macro{i,1} = macroblock(images{i,1} , [8 8]);
end
[ row_mac , col_mac ] = size(macro{1,1});
%% Motion vector and residual
[row_im , col_im] = size(images{1,1});
p=12;
MV_res = motion_vect_video(macro, row_im , col_im , num_im , p);
%% show the residual

for i = 1:num_im
    
    dec_gray_im = inv_macroblock(MV_res{i,2} ,row_im , col_im );
    fig=figure;
    %subplot(1,2,1)
    imshow(images{i,1},[]);
    title('Original Gray Image')
    %saveas(fig,'Grary_'+string(i)+'.jpg');
    %subplot(1,2,2)
    fig=figure;
    imshow(dec_gray_im,[]);
    title('Residual Image')
    %saveas(fig,'Residual_'+string(i)+'.jpg');
end
%% encode frames
encoded_vid_frames = encode_video_frames(MV_res);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% decode frames
decoded_vid_frames_res = decode_video_frames(encoded_vid_frames , row_mac , col_mac );
%%  inverse motion vector and residual
dec_macro = inv_motion_vect_video(decoded_vid_frames_res, row_im , col_im , num_im );
%dec_macro = inv_motion_vect_video(MV_res, row_im , col_im , num_im );

%%

%% from macro blocks to full image
decoded_images=cell(num_im , 1);
for i = 1:num_im
    %fig1=figure;
    dec_gray_im = inv_macroblock(dec_macro{i,1} ,row_im , col_im );
    decoded_images{i,1}= dec_gray_im;
    %imshow(dec_gray_im);
    
    fig=figure;
% % %     subplot(1,2,1)
% % %     imshow(images{i,1},[]);
% % %     title('Original Gray Image')
% % %     subplot(1,2,2)
    imshow(dec_gray_im,[]);
    title('Reconstructed Image')
    %saveas(fig,'Reconstructed_Image_'+string(i)+'.jpg')
    %%saveas(fig1,'Reconstructed_Image_'+string(i)+'.jpg');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

