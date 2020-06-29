import numpy as np
import pandas as pd
from pprint import pprint
pd.set_option('display.unicode.ambiguous_as_wide', True)
pd.set_option('display.unicode.east_asian_width', True)
def CART(data):
    # 计算ID3的E和Gain，并迭代进行各个分支计算

    # 输入data为dataframe数据，最后一列是判断值
    # 例子，data：
    #    Outlook     Temperature     Humidity      Wind       PlayTennis
    # 0  Sunny       Hot             High          Weak       -1
    # 1  Sunny       Hot             High          Strong     -1
    # 2  Overcast    Hot             High          Weak        1

    def calculate_iN(target):
        # 计算Gini(i(N))，输入为一列dataframe数据
        # 例子：
        # target   =  PlayTennis（列名）
        #                     1
        #                    -1
        #                     1
        # 输出为i(N) = (1 - (1/3)^2 - (2/3)^2)
        target_list = target.tolist()
        unique_target_list = list(set(target_list))
        E = [0] * len(unique_target_list)
        for i in range(len(target_list)):
            target_index = unique_target_list.index(target_list[i])
            E[target_index] += 1
        iN = 1
        for i in range(len(unique_target_list)):
            E[i] /= len(target_list)
            iN -= E[i] ** 2
        return iN

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
    if len(data.columns) == 1 or data.empty:
        return
    # 得到列名
    column_name = data.columns.tolist()
    column_len = len(column_name)
    target_name = column_name[column_len - 1]
    del column_name[column_len - 1]
    # 分别计算Gini(L)和Gini(R)和G
    Gini = {}
    theta_iN = {}
    for i in column_name:
        Gini[i] = {}
        Gini[i][i] = calculate_iN(data[target_name])
        unique_name = get_unique_name(data.loc[:, i])
        for j in unique_name:
            i_j_data = data[data[i] == j][target_name]
            i_not_j_data = data[data[i] != j][target_name]
            Gini[i][j] = [calculate_iN(i_j_data), calculate_iN(i_not_j_data), get_P(data[i], j)]
        for j in unique_name:
            theta_iN[i + '_' + j] = (Gini[i][j][0] * Gini[i][j][2]) + (Gini[i][j][1] *(1 - Gini[i][j][2]))
    # 输出E和Gain
    print('Gini(L),Gini(R),P(L):')
    pprint(Gini)
    print('G = Gini(L)*P(L) + Gini(L)*(1 - P(L))：')
    pprint(theta_iN)
    # 选取最大的Gain
    min_name = list(theta_iN.keys())[0]
    for i in theta_iN.keys():
        if theta_iN[i] < theta_iN[min_name]:
            min_name = i
    print('分支：', min_name)
    # 获得下次数据
    i = min_name.split('_')[0]
    j = min_name.split('_')[1]
    i_not_j_data = data[data[i] != j]
    i_j_data = data[data[i] == j]

    if len(get_unique_name(i_not_j_data[i])) == 1:
        del i_not_j_data[i]
    if len(get_unique_name(i_j_data[i])) == 1:
        del i_j_data[i]

    print('-' * 80)
    print('下一次CART数据({}_not_{})：'.format(i, j))
    pprint(i_not_j_data)
    if len(get_unique_name(i_not_j_data[target_name])) != 1:
        CART(i_not_j_data)

    print('-' * 80)
    print('下一次CART数据({}_{})：'.format(i, j))
    pprint(i_j_data)
    if len(get_unique_name(i_j_data[target_name])) != 1:
        CART(i_j_data)




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
    CART(data)
