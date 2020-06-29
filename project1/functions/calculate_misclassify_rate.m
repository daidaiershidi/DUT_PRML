function [misclassift_rate] = calculate_misclassify_rate(predict,test_label)
% 计算误判率
% 输入：
% predict = [N X 1]
% test_label = [N X 1]

% 统计错误率
misclassift_num = 0;
for i = 1:length(test_label)
    if(predict(i, :) ~= test_label(i, :))
        misclassift_num = misclassift_num + 1;
    end
end
misclassift_rate = misclassift_num / length(test_label);

end

