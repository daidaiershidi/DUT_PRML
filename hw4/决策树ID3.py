import numpy as np
import pandas as pd
from pprint import pprint
pd.set_option('display.unicode.ambiguous_as_wide', True)
pd.set_option('display.unicode.east_asian_width', True)
def ID3(data):
    # 计算ID3的E和Gain，并迭代进行各个分支计算

    # 输入data为dataframe数据，最后一列是判断值
    # 例子，data：
    #    Outlook     Temperature     Humidity      Wind       PlayTennis
    # 0  Sunny       Hot             High          Weak       -1
    # 1  Sunny       Hot             High          Strong     -1
    # 2  Overcast    Hot             High          Weak        1

    def calculate_iN(target):
        # 计算i(N)，输入为一列dataframe数据
        # 例子：
        # target   =  PlayTennis（列名）
        #                     1
        #                    -1
        #                     1
        # 输出为i(N) = -(1/3)log(1/3)-(2/3)log(2/3)
        target_list = target.tolist()
        unique_target_list = list(set(target_list))
        E = [0] * len(unique_target_list)
        for i in range(len(target_list)):
            target_index = unique_target_list.index(target_list[i])
            E[target_index] += 1
        for i in range(len(unique_target_list)):
            E[i] /= len(target_list)
            E[i] = E[i] * np.log2(E[i])
        return -sum(E)

    def get_unique_name(column):
        # 得到无重复元素的集合，输入为一列dataframe数据
        # 例子：
        # column  =  Humidity（列名）
        #                High
        #              Normal
        #              Normal
        # 输出为[High, Normal]
        column_list = column.tolist()
        unique_column_list = list(set(column_list))
        return unique_column_list

    def get_P(column, name):
        # 得到指定元素的比例，输入为一列dataframe数据
        # 例子：
        # name    =  High
        # column  =  Humidity（列名）
        #                High
        #              Normal
        #              Normal
        # 输出为1/3
        column_list = column.tolist()
        P = 0
        for i in column_list:
            if i == name:
                P += 1
        P_ = 1 if P == 0 else P / len(column_list)
        return P_

    # 得到列名
    column_name = data.columns.tolist()
    column_len = len(column_name)
    target_name = column_name[column_len - 1]
    del column_name[column_len - 1]
    # 分别计算E(i(N))和Gain(theta_i(N))
    E = {}
    theta_iN = {}
    for i in column_name:
        E[i] = {}
        E[i][i] = calculate_iN(data[target_name])
        theta_iN[i] = E[i][i]
        unique_name = get_unique_name(data.loc[:, i])
        for j in unique_name:
            i_j_data = data[data[i] == j][target_name]
            E[i][j] = [calculate_iN(i_j_data), get_P(data[i], j)]
        for j in unique_name:
            theta_iN[i] -= (E[i][j][0] * E[i][j][1])
    # 输出E和Gain
    print('E and P:')
    pprint(E)
    print('Gain:')
    pprint(theta_iN)
    # 选取最大的Gain
    max_name = list(theta_iN.keys())[0]
    for i in theta_iN.keys():
        if theta_iN[i] > theta_iN[max_name]:
            max_name = i
    print('选取：', max_name)
    print('分支：', get_unique_name(data[max_name]))
    if max_name in list(data.columns) and len(data.columns) != 2:
        # 对每个分支进行类似操作
        for i in get_unique_name(data[max_name]):
            i_data = data[data[max_name] == i]
            del i_data[max_name]
            # 输出分支下的dataframe数据
            print('-' * 80)
            print('下一次ID3数据({},{})：'.format(max_name, i))
            pprint(i_data)
            # 判断是否需要继续计算,如果剩下的数据都是同一类，就不需要计算了
            if len(get_unique_name(i_data[target_name])) != 1:
                # 进行下一次ID3的计算
                ID3(i_data)


if __name__ == '__main__':
    import pandas as pd
    raw_data = {
        'Outlook':['Sunny', 'Sunny', 'Overcast', 'Rain', 'Rain', 'Rain', 'Overcast', 'Sunny', 'Sunny', 'Rain', 'Sunny', 'Overcast', 'Overcast', 'Rain'],
        'Temperature':['Hot', 'Hot', 'Hot', 'Mild', 'Cool', 'Cool', 'Cool', 'Mild', 'Cool', 'Mild', 'Mild', 'Mild', 'Hot', 'Mild'],
        'Humidity':['High', 'High', 'High', 'High', 'Normal', 'Normal', 'Normal', 'High', 'Normal', 'Normal', 'Normal', 'High', 'Normal', 'High'],
        'Wind':['Weak', 'Strong', 'Weak', 'Weak', 'Weak', 'Strong', 'Strong', 'Weak', 'Weak', 'Weak', 'Strong', 'Strong', 'Weak', 'Strong'],
        'PlayTennis':[-1,-1,1,1,1,-1,1,-1,1,1,1,1,1,-1]
    }
    data = pd.DataFrame.from_dict(raw_data)
    pprint(data)
    print('第一次ID3：')
    ID3(data)
