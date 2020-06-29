function [data] = read_xml(file_path)
% 读取'.\project2-data\project2-data\a.xml'等文件


% 读取xml文件
xmlDoc = xmlread(file_path);
% 读取所有trainingExample
trainingExampleArray = xmlDoc.getElementsByTagName('trainingExample');
for i = 0 : trainingExampleArray.getLength-1
    % 对每一个trainingExample，读取所有coord
    ith_data = [];
    ith_trainingExample = trainingExampleArray.item(i);
    coordArray = ith_trainingExample.getElementsByTagName('coord');
    for j = 0:coordArray.getLength-1
        % 对于每一个coord，获得xyt
        jth_coord = coordArray.item(j);
        x = jth_coord.getAttribute('x');
        y = jth_coord.getAttribute('y');
%         t = jth_coord.getAttribute('t');
%         ith_data_jth_coord = [str2num(x), str2num(y), str2num(t)];
        ith_data_jth_coord = [str2num(x), str2num(y), j];
        ith_data = [ith_data; ith_data_jth_coord];
    end
    data{i+1} = ith_data;
end


end

