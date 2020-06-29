function [observation_seq] = get_observation1(data, equal_parts_num, observation_state_num, x_or_y)
% ͨ����ͼ������۲�����
% ���룺
% data = [x, y]��һ��x����һ��y����
% equal_parts_num = x�����ϵȷֵ�������������ȷ�100�֣��۲����г��Ⱦ���100
% observation_state_num = y�����ϵȷֵ�����
% x_or_y = 0��ʾ�ȷ�x�ᣬ1��ʾ�ȷ�y��
% �����
% observation = [1,2,3,1,1,1,3...],����Ϊequal_parts_num

x_theshold = (1 - 1/4) / 2;
% y_theshold = (1 - 1/4) / 2;

if(x_or_y == 0)
    XX = data(:, 1);
    YY = data(:, 2);
else if(x_or_y == 1)
    XX = data(:, 2);
    YY = data(:, 1);
    end
end

DATA = [XX, YY];
XX_min = min(XX);
XX_max = max(XX);
XX_equal_length = (XX_max - XX_min) / equal_parts_num;
YY_min = min(YY);
YY_max = max(YY);
YY_equal_length = (YY_max - YY_min) / observation_state_num;
% 
% scatter(DATA(:, 1), DATA(:, 2));
% hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����ͳ��
observation_seq = [];
for i = 1:equal_parts_num
%     �ȷֿ�ķ�Χ�뷶Χ�ڵ�XX����
    ith_observation = 0;
    XX_range = [XX_min + (i-1) * XX_equal_length,XX_min + i * XX_equal_length];
    XX_range = int64([XX_range(1) + XX_equal_length*x_theshold, XX_range(2) - XX_equal_length*x_theshold]);
    
%     plot([XX_range(1), XX_range(1)], [YY_min, YY_max])
%     hold on
%     plot([XX_range(2), XX_range(2)], [YY_min, YY_max])
%     hold on
    
    
    for j = 1:observation_state_num
        YY_range = int64([YY_min + (j-1) * YY_equal_length,YY_min + j * YY_equal_length]);
%         YY_range = int64([YY_range(1) + YY_equal_length*y_theshold, YY_range(2) - YY_equal_length*y_theshold]);
        point_in_equal_parts = find(DATA(:,1)>= XX_range(1) & DATA(:,1)<= XX_range(2) & DATA(:,2)>= YY_range(1) & DATA(:,2)<=YY_range(2));
        
        
%         plot([XX_min, XX_max], [YY_range(1), YY_range(1)])
%         hold on
%         plot([XX_min, XX_max], [YY_range(2), YY_range(2)])
%         hold on
%         point = DATA(point_in_equal_parts, :);
%         scatter(point(:, 1), point(:, 2), '*');
%         hold on
        
        if(isempty(point_in_equal_parts) ~= 1)
            ith_observation = ith_observation + 1;
        end
    end
    ith_observation = ith_observation + 1;
    observation_seq = [observation_seq, ith_observation];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% observation = zeros(1, equal_parts_num);
% for i = 1:length(DATA)
%     ith_XX = DATA(i, 1);
%     index = floor( (ith_XX - XX_min)/ XX_equal_length);
% end

end




