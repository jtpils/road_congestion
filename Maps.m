close all;
% Массив для хранения 24 значений площадей цветов
% Три строки (красный,зеленый,желтый) 24 столбца 1 размерность
colorArrayArea=zeros(3,24,1);
% Максимальная площадь
maxArea = 0;
% Cчитываем изображение
dir = 'map/';
format = '.jpg';

%% Ввод
numberOfSegments=input('Введите k (на сколько секций делить изображение, при 4 изображение будет представлять 16 сегментов A11,A21,...,A44) = ');

%% Удалим в папке Result's все файлы
disp('Очистка результирующей директории...');
try
rmdir('Results Maps/*','s');
mkdir('Results Maps');
catch
delete('Results Maps/*');
end


for i=1:1:24
    %% Считываем изображение
    num = i;
    number = num2str(num);
    rgbImage = imread(strcat(dir,number,format)); 
    % Под каждый кадр выводим фигуру с именем - путь к файлу
    figure
    set(gcf,'name',['Изображение ' strcat(dir,number,format)],'numbertitle','off');
    %% Покажем исходное изображение.
    subplot(2, 2, 1);
    imshow(rgbImage);
    title('Original RGB Image');
    % Узнаем размер изображения
    [row column color]=size(rgbImage);
    %% Выведем размеры
    str=sprintf('Row = %d',row);
    disp(str);
    str=sprintf('Column = %d',column);
    disp(str);
    str=sprintf('Color = %d',color);
    disp(str);

    % Отображение фигуры на фулскрин
    set(gcf, 'Position', get(0, 'ScreenSize'));

    

    %% Разобьем на цветовые потоки.
    redBand = rgbImage(:,:, 1);
    greenBand = rgbImage(:,:, 2);
    blueBand = rgbImage(:,:, 3);
    %% Рассчет mask's
    %% Red
        redsum = 0;
        % Для каждого потока устанавливаем порог.
        redthreshold = 68;
        greenThreshold = 70;
        blueThreshold = 72;
        redMask = (redBand > redthreshold);
        greenMask = (greenBand < greenThreshold);
        blueMask = (blueBand < blueThreshold);

        % Комбиним маски чтобы найти участки где все они выполнились
        redObjectsMask = uint8(redMask & greenMask & blueMask);
        subplot(2, 2, 2);
        % Вычисляем площадь (кол-во пикселей) 
        redsum = bwarea(redObjectsMask);
        % Дополним каналы ( уберем с исходного )
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
        % Выведем результат
        imshow(redObjectsMaskColor, []);
        title(['Red Objects Mask sum = ' num2str(redsum)]);
        colorArrayArea(1,i,1)=redsum;
    %% Green
        greensum = 0;
        % Для каждого потока устанавливаем порог.
        redthreshold = 68;
        greenThreshold = 70;
        blueThreshold = 72;
        redMask = (redBand < redthreshold);
        greenMask = (greenBand > greenThreshold);
        blueMask = (blueBand < blueThreshold);

        % Комбиним маски чтобы найти участки где все они выполнились
        greenObjectsMask = uint8(redMask & greenMask & blueMask);
        % Вычисляем площадь (кол-во пикселей) 
        greensum = bwarea(greenObjectsMask);
        subplot(2, 2, 3);
        % Дополним каналы ( уберем с исходного )
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
        % Выведем результат
        imshow(greenObjectsMaskColor, []);
        title(['Green Objects Mask sum = ' num2str(greensum)]);
        colorArrayArea(2,i,1)=greensum;
    %% Yellow
        yellowsum = 0;
        % Для каждого потока устанавливаем порог.
        redthreshold = 68;
        greenThreshold = 70;
        blueThreshold = 72;
        redMask = (redBand > redthreshold);
        greenMask = (greenBand > greenThreshold);
        blueMask = (blueBand < blueThreshold);

        % Комбиним маски чтобы найти участки где все они выполнились
        yellowObjectsMask = uint8(redMask & greenMask & blueMask);
        % Вычисляем площадь (кол-во пикселей) 
        yellowsum = bwarea(yellowObjectsMask);
        % Дополним каналы ( уберем с исходного )
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
        % Выведем результат
        subplot(2, 2, 4);
        imshow(yellowObjectsMaskColor, []);
        title(['Yellow Objects Mask sum = ' num2str(yellowsum)]);
        colorArrayArea(3,i,1)=yellowsum;
        % Вычисляем максимальную площадь дорог на всех кадрах
     if ( (colorArrayArea(1,i,1)+colorArrayArea(2,i,1)+colorArrayArea(3,i,1)) > maxArea )
        maxArea = (colorArrayArea(1,i,1)+colorArrayArea(2,i,1)+colorArrayArea(3,i,1));
     end
     
     %% Создадим необходимые директории
%         У нас есть:
%             rgbImage - исходное изображение
%             redObjectsMask - чб маска изображения с красными объектами
%             greenObjectsMask - чб маска изображения с зелеными объектами
%             yellowObjectsMask - чб маска изображения с желтыми объектами
%             redObjectsMaskColor - RGB маска изображения с красными объектами
%             greenObjectsMaskColor - RGB маска изображения с зелеными объектами
%             yellowObjectsMaskColor - RGB маска изображения с желтыми объектами
%    
    %% FullScreen изображение
    source = strcat('Results Maps/Source image #',num2str(number));
    mkdir(source);
    % Изображение целое
    mkdir(strcat(source,'/Full screen image'));
    imwrite(rgbImage, strcat(source,'/Full screen image/rgb.jpg'));
    imwrite(redObjectsMaskColor, strcat(source,'/Full screen image/redObjectsMaskColor.jpg'));
    imwrite(greenObjectsMaskColor, strcat(source,'/Full screen image/greenObjectsMaskColor.jpg'));
    imwrite(yellowObjectsMaskColor, strcat(source,'/Full screen image/yellowObjectsMaskColor.jpg'));
    %% Запись FullScreen изображения в файл
    fid = fopen(strcat(source,'/Full screen image/','AreaResult.txt'), 'w+'); 
    fprintf(fid, 'Площадь занимаемая красным цветом = %6.2f\n', redsum); 
    fprintf(fid, 'Площадь занимаемая зеленым цветом = %6.2f\n', greensum); 
    fprintf(fid, 'Площадь занимаемая желтым цветом = %6.2f\n', yellowsum); 
    fprintf(fid, 'Максимальная площадь дорог = %6.2f\n', maxArea); 
    fclose(fid);
    %% Начало Cегментации
    rowPosition = 0;
    columnPostition = 0;
    rowStep = row / numberOfSegments;
    columnStep = column / numberOfSegments;
    cropRowPosition = 0;
    cropColumnPosition = 0;
    %% Расчет секции. где A[rowPosition,columnPostition] ( A11 ) равен пиксельно A[cropColumnPosition,cropRowPosition]
    % !!! Участок A12 где 1 строка 2 столбец в матлаб матрицах будет А21
    % где 2 столбец 1 строка
    for rowPosition=1:1:numberOfSegments
            for columnPostition=1:1:numberOfSegments
                % RGB
                mkdir(strcat(source,'/A',num2str(rowPosition),num2str(columnPostition)));
                I2 = imcrop(rgbImage,[cropColumnPosition cropRowPosition columnStep rowStep]);
                imwrite(I2, strcat(source,'/A',num2str(rowPosition),num2str(columnPostition),'/rgb.jpg'));
                % Красный
                I2 = imcrop(redObjectsMaskColor,[cropColumnPosition cropRowPosition columnStep rowStep]);
                imwrite(I2, strcat(source,'/A',num2str(rowPosition),num2str(columnPostition),'/redObjectsMaskColor.jpg'));
                I2 = imcrop(redObjectsMask,[cropColumnPosition cropRowPosition columnStep rowStep]);
                redsumcrop = bwarea(I2);
                % Зеленый
                I2 = imcrop(greenObjectsMaskColor,[cropColumnPosition cropRowPosition columnStep rowStep]);
                imwrite(I2, strcat(source,'/A',num2str(rowPosition),num2str(columnPostition),'/greenObjectsMaskColor.jpg'));
                I2 = imcrop(greenObjectsMask,[cropColumnPosition cropRowPosition columnStep rowStep]);
                greensumcrop = bwarea(I2);
                % Желтый
                I2 = imcrop(yellowObjectsMaskColor,[cropColumnPosition cropRowPosition columnStep rowStep]);
                imwrite(I2, strcat(source,'/A',num2str(rowPosition),num2str(columnPostition),'/yellowObjectsMaskColor.jpg'));
                I2 = imcrop(yellowObjectsMask,[cropColumnPosition cropRowPosition columnStep rowStep]);
                yellowsumcrop = bwarea(I2);
                % Запись в файл
                fid = fopen(strcat(source,'/A',num2str(rowPosition),num2str(columnPostition),'/AreaResult.txt'), 'w+'); 
                fprintf(fid, 'Площадь занимаемая красным цветом = %6.2f\n', redsumcrop); 
                fprintf(fid, 'Площадь занимаемая зеленым цветом = %6.2f\n', greensumcrop); 
                fprintf(fid, 'Площадь занимаемая желтым цветом = %6.2f\n', yellowsumcrop); 
                fprintf(fid, 'Максимальная площадь дорог = %6.2f\n', maxArea); 
                fclose(fid);
                % Шаг по столбцам
                cropColumnPosition = cropColumnPosition + columnStep;
            end
            % Шаг по строкам и сброс столбцов в начало 0
            cropColumnPosition = 0;
            cropRowPosition = cropRowPosition + rowStep;
    end
    
end



%% График
figure
set(gcf,'name','График соотношения загруженности дорог в течении дня' ,'numbertitle','off');
x = 1:24;
red = (colorArrayArea(1,x,1)/maxArea)*100;
green = (colorArrayArea(2,x,1)/maxArea)*100;
yellow = (colorArrayArea(3,x,1)/maxArea)*100;
plot(x,red,'r-',x,green,'g-',x,yellow,'y-');
axis( [ 1, 24, 0, 100 ] );
% Сетка
grid on;
title(['Общая площадь дорог = ' num2str(maxArea)]);
xlabel('Номер кадра в последовательности'); 
ylabel('% от общей площади дороги');
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
