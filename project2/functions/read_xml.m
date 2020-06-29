function [data] = read_xml(file_path)
% ��ȡ'.\project2-data\project2-data\a.xml'���ļ�


% ��ȡxml�ļ�
xmlDoc = xmlread(file_path);
% ��ȡ����trainingExample
trainingExampleArray = xmlDoc.getElementsByTagName('trainingExample');
for i = 0 : trainingExampleArray.getLength-1
    % ��ÿһ��trainingExample����ȡ����coord
    ith_data = [];
    ith_trainingExample = trainingExampleArray.item(i);
    coordArray = ith_trainingExample.getElementsByTagName('coord');
    for j = 0:coordArray.getLength-1
        % ����ÿһ��coord�����xyt
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

