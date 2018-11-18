close all;
% ������ ��� �������� 24 �������� �������� ������
% ��� ������ (�������,�������,������) 24 ������� 1 �����������
colorArrayArea=zeros(3,24,1);
% ������������ �������
maxArea = 0;
% C�������� �����������
dir = 'map/';
format = '.jpg';

%% ����
numberOfSegments=input('������� k (�� ������� ������ ������ �����������, ��� 4 ����������� ����� ������������ 16 ��������� A11,A21,...,A44) = ');

%% ������ � ����� Result's ��� �����
disp('������� �������������� ����������...');
try
rmdir('Results Maps/*','s');
mkdir('Results Maps');
catch
delete('Results Maps/*');
end


for i=1:1:24
    %% ��������� �����������
    num = i;
    number = num2str(num);
    rgbImage = imread(strcat(dir,number,format)); 
    % ��� ������ ���� ������� ������ � ������ - ���� � �����
    figure
    set(gcf,'name',['����������� ' strcat(dir,number,format)],'numbertitle','off');
    %% ������� �������� �����������.
    subplot(2, 2, 1);
    imshow(rgbImage);
    title('Original RGB Image');
    % ������ ������ �����������
    [row column color]=size(rgbImage);
    %% ������� �������
    str=sprintf('Row = %d',row);
    disp(str);
    str=sprintf('Column = %d',column);
    disp(str);
    str=sprintf('Color = %d',color);
    disp(str);

    % ����������� ������ �� ��������
    set(gcf, 'Position', get(0, 'ScreenSize'));

    

    %% �������� �� �������� ������.
    redBand = rgbImage(:,:, 1);
    greenBand = rgbImage(:,:, 2);
    blueBand = rgbImage(:,:, 3);
    %% ������� mask's
    %% Red
        redsum = 0;
        % ��� ������� ������ ������������� �����.
        redthreshold = 68;
        greenThreshold = 70;
        blueThreshold = 72;
        redMask = (redBand > redthreshold);
        greenMask = (greenBand < greenThreshold);
        blueMask = (blueBand < blueThreshold);

        % �������� ����� ����� ����� ������� ��� ��� ��� �����������
        redObjectsMask = uint8(redMask & greenMask & blueMask);
        subplot(2, 2, 2);
        % ��������� ������� (���-�� ��������) 
        redsum = bwarea(redObjectsMask);
        % �������� ������ ( ������ � ��������� )
        redObjectsMaskColor = rgbImage;
        for m=1:1:row
            for j=1:1:column
                if ( redObjectsMask(m,j) == 0 )
                    redObjectsMaskColor(m,j,1) = 255;
                    redObjectsMaskColor(m,j,2) = 255;
                    redObjectsMaskColor(m,j,3) = 255;
                end
            end
        end
        % ������� ���������
        imshow(redObjectsMaskColor, []);
        title(['Red Objects Mask sum = ' num2str(redsum)]);
        colorArrayArea(1,i,1)=redsum;
    %% Green
        greensum = 0;
        % ��� ������� ������ ������������� �����.
        redthreshold = 68;
        greenThreshold = 70;
        blueThreshold = 72;
        redMask = (redBand < redthreshold);
        greenMask = (greenBand > greenThreshold);
        blueMask = (blueBand < blueThreshold);

        % �������� ����� ����� ����� ������� ��� ��� ��� �����������
        greenObjectsMask = uint8(redMask & greenMask & blueMask);
        % ��������� ������� (���-�� ��������) 
        greensum = bwarea(greenObjectsMask);
        subplot(2, 2, 3);
        % �������� ������ ( ������ � ��������� )
        greenObjectsMaskColor = rgbImage;
        for m=1:1:row
            for j=1:1:column
                if ( greenObjectsMask(m,j) == 0 )
                    greenObjectsMaskColor(m,j,1) = 255;
                    greenObjectsMaskColor(m,j,2) = 255;
                    greenObjectsMaskColor(m,j,3) = 255;
                end
            end
        end
        % ������� ���������
        imshow(greenObjectsMaskColor, []);
        title(['Green Objects Mask sum = ' num2str(greensum)]);
        colorArrayArea(2,i,1)=greensum;
    %% Yellow
        yellowsum = 0;
        % ��� ������� ������ ������������� �����.
        redthreshold = 68;
        greenThreshold = 70;
        blueThreshold = 72;
        redMask = (redBand > redthreshold);
        greenMask = (greenBand > greenThreshold);
        blueMask = (blueBand < blueThreshold);

        % �������� ����� ����� ����� ������� ��� ��� ��� �����������
        yellowObjectsMask = uint8(redMask & greenMask & blueMask);
        % ��������� ������� (���-�� ��������) 
        yellowsum = bwarea(yellowObjectsMask);
        % �������� ������ ( ������ � ��������� )
        yellowObjectsMaskColor = rgbImage;
        for m=1:1:row
            for j=1:1:column
                if ( yellowObjectsMask(m,j) == 0 )
                    yellowObjectsMaskColor(m,j,1) = 255;
                    yellowObjectsMaskColor(m,j,2) = 255;
                    yellowObjectsMaskColor(m,j,3) = 255;
                end
            end
        end
        % ������� ���������
        subplot(2, 2, 4);
        imshow(yellowObjectsMaskColor, []);
        title(['Yellow Objects Mask sum = ' num2str(yellowsum)]);
        colorArrayArea(3,i,1)=yellowsum;
        % ��������� ������������ ������� ����� �� ���� ������
     if ( (colorArrayArea(1,i,1)+colorArrayArea(2,i,1)+colorArrayArea(3,i,1)) > maxArea )
        maxArea = (colorArrayArea(1,i,1)+colorArrayArea(2,i,1)+colorArrayArea(3,i,1));
     end
     
     %% �������� ����������� ����������
%         � ��� ����:
%             rgbImage - �������� �����������
%             redObjectsMask - �� ����� ����������� � �������� ���������
%             greenObjectsMask - �� ����� ����������� � �������� ���������
%             yellowObjectsMask - �� ����� ����������� � ������� ���������
%             redObjectsMaskColor - RGB ����� ����������� � �������� ���������
%             greenObjectsMaskColor - RGB ����� ����������� � �������� ���������
%             yellowObjectsMaskColor - RGB ����� ����������� � ������� ���������
%    
    %% FullScreen �����������
    source = strcat('Results Maps/Source image #',num2str(number));
    mkdir(source);
    % ����������� �����
    mkdir(strcat(source,'/Full screen image'));
    imwrite(rgbImage, strcat(source,'/Full screen image/rgb.jpg'));
    imwrite(redObjectsMaskColor, strcat(source,'/Full screen image/redObjectsMaskColor.jpg'));
    imwrite(greenObjectsMaskColor, strcat(source,'/Full screen image/greenObjectsMaskColor.jpg'));
    imwrite(yellowObjectsMaskColor, strcat(source,'/Full screen image/yellowObjectsMaskColor.jpg'));
    %% ������ FullScreen ����������� � ����
    fid = fopen(strcat(source,'/Full screen image/','AreaResult.txt'), 'w+'); 
    fprintf(fid, '������� ���������� ������� ������ = %6.2f\n', redsum); 
    fprintf(fid, '������� ���������� ������� ������ = %6.2f\n', greensum); 
    fprintf(fid, '������� ���������� ������ ������ = %6.2f\n', yellowsum); 
    fprintf(fid, '������������ ������� ����� = %6.2f\n', maxArea); 
    fclose(fid);
    %% ������ C����������
    rowPosition = 0;
    columnPostition = 0;
    rowStep = row / numberOfSegments;
    columnStep = column / numberOfSegments;
    cropRowPosition = 0;
    cropColumnPosition = 0;
    %% ������ ������. ��� A[rowPosition,columnPostition] ( A11 ) ����� ��������� A[cropColumnPosition,cropRowPosition]
    % !!! ������� A12 ��� 1 ������ 2 ������� � ������ �������� ����� �21
    % ��� 2 ������� 1 ������
    for rowPosition=1:1:numberOfSegments
            for columnPostition=1:1:numberOfSegments
                % RGB
                mkdir(strcat(source,'/A',num2str(rowPosition),num2str(columnPostition)));
                I2 = imcrop(rgbImage,[cropColumnPosition cropRowPosition columnStep rowStep]);
                imwrite(I2, strcat(source,'/A',num2str(rowPosition),num2str(columnPostition),'/rgb.jpg'));
                % �������
                I2 = imcrop(redObjectsMaskColor,[cropColumnPosition cropRowPosition columnStep rowStep]);
                imwrite(I2, strcat(source,'/A',num2str(rowPosition),num2str(columnPostition),'/redObjectsMaskColor.jpg'));
                I2 = imcrop(redObjectsMask,[cropColumnPosition cropRowPosition columnStep rowStep]);
                redsumcrop = bwarea(I2);
                % �������
                I2 = imcrop(greenObjectsMaskColor,[cropColumnPosition cropRowPosition columnStep rowStep]);
                imwrite(I2, strcat(source,'/A',num2str(rowPosition),num2str(columnPostition),'/greenObjectsMaskColor.jpg'));
                I2 = imcrop(greenObjectsMask,[cropColumnPosition cropRowPosition columnStep rowStep]);
                greensumcrop = bwarea(I2);
                % ������
                I2 = imcrop(yellowObjectsMaskColor,[cropColumnPosition cropRowPosition columnStep rowStep]);
                imwrite(I2, strcat(source,'/A',num2str(rowPosition),num2str(columnPostition),'/yellowObjectsMaskColor.jpg'));
                I2 = imcrop(yellowObjectsMask,[cropColumnPosition cropRowPosition columnStep rowStep]);
                yellowsumcrop = bwarea(I2);
                % ������ � ����
                fid = fopen(strcat(source,'/A',num2str(rowPosition),num2str(columnPostition),'/AreaResult.txt'), 'w+'); 
                fprintf(fid, '������� ���������� ������� ������ = %6.2f\n', redsumcrop); 
                fprintf(fid, '������� ���������� ������� ������ = %6.2f\n', greensumcrop); 
                fprintf(fid, '������� ���������� ������ ������ = %6.2f\n', yellowsumcrop); 
                fprintf(fid, '������������ ������� ����� = %6.2f\n', maxArea); 
                fclose(fid);
                % ��� �� ��������
                cropColumnPosition = cropColumnPosition + columnStep;
            end
            % ��� �� ������� � ����� �������� � ������ 0
            cropColumnPosition = 0;
            cropRowPosition = cropRowPosition + rowStep;
    end
    
end



%% ������
figure
set(gcf,'name','������ ����������� ������������� ����� � ������� ���' ,'numbertitle','off');
x = 1:24;
red = (colorArrayArea(1,x,1)/maxArea)*100;
green = (colorArrayArea(2,x,1)/maxArea)*100;
yellow = (colorArrayArea(3,x,1)/maxArea)*100;
plot(x,red,'r-',x,green,'g-',x,yellow,'y-');
axis( [ 1, 24, 0, 100 ] );
% �����
grid on;
title(['����� ������� ����� = ' num2str(maxArea)]);
xlabel('����� ����� � ������������������'); 
ylabel('% �� ����� ������� ������');
legend('Red Area','Green Area','Yellow Area');






% %%
%      subplot(2, 3, 5);
%      ObjectsMaskColor = rgbImage;
%      for m=1:1:row
%             for j=1:1:column
%      ObjectsMaskColor(m,j,1) = redObjectsMaskColor(m,j);
%      ObjectsMaskColor(m,j,2) = greenObjectsMaskColor(m,j);
%      ObjectsMaskColor(m,j,3) = yellowObjectsMaskColor(m,j);
%             end
%      end
%      imshow(ObjectsMaskColor, []);
% 
