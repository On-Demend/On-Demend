# Code - BigData(temp)


## 1. NBA 연봉 King
```bash
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
salary = pd.read_csv('nba.csv')
#salary.info()
salary2 = salary.sort_values('Salary', ascending=False).head(10)
salary2
```

```bash
plt.rc('font', family = 'Gulim')
salary2.plot(kind = 'bar', x = 'Name', y = 'Salary', color = 'blue', rot = 45)
plt.title('NBA 연봉 King', fontsize = 18)
plt.xlabel('선수명', fontsize = 14, loc = 'right')
plt.ylabel('연봉', fontsize = 14, loc = 'top')
plt.ylim(30000000, 41000000)
plt.show()
```

## 2. Titanic
```bash
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
titanic = pd.read_csv('train1.csv')
titanic.head()
#titanic.info()
```

```bash
titanic[['Name', 'Pclass', 'Sex']]
```

```bash
titanic[['Embarked', 'Sex', 'Survived']].groupby(['Embarked', 'Sex']).mean(numeric_only=True)
```

## 3. DataFrame
```bash
import pandas as pd
import numpy as np
import datetime as dt

#np.random.seed(42)
df = pd.DataFrame({'상점':['상점 A', '상점 B', '상점 C', '상점 D', '상점 E'] * 6,
                    '과일':['사과', '참외', '수박'] * 10,
                    '산지':['경북', '충북', '전남'] * 10,
                    '가격':[20000, 30000, 15000, 18000, 23000] * 6,
                    '출하일':[dt.datetime(2024,1,i) for i in range(1, 16)] + [dt.datetime(2024,2,i) for i in range(1, 16)]
                  })
df_sum = pd.pivot_table(df, values='가격', index='상점', columns='과일', aggfunc='sum')
df_sum['합계'] = df_sum['사과'] + df_sum['참외'] + df_sum['수박']
df_sum
```

## 4. Sales by employee
```bash
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
sales = pd.read_csv('sales_by_employee.csv')
sales[['Date', 'Revenue', 'Expenses']].groupby(['Date']).sum()
sales3 = pd.pivot_table(sales, values=['Expenses', 'Revenue'], index='Date', aggfunc='sum')
sales3.plot(kind = 'bar', rot = 45)
plt.xticks(np.arange(5), ['2020-01-01', '2020-01-02', '2020-01-03', '2020-01-04', '2020-01-05'])
plt.show()
#sales.info()
```

## 5. ChinaFood
```bash
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

cf = pd.read_excel('chinafood.xlsx')
cf2 = pd.pivot_table(cf, values='quantity', index='item_name', aggfunc='sum')
plt.rc('font', family = 'Gulim')
#cfh = cf[['item_name', 'quantity']].groupby('item_name').sum(numeric_only = True)
cf2.plot(kind = 'bar')
plt.title('요리별 총주문량', fontsize = 14)
plt.xlabel('요리이름', fontsize = 14, loc = 'right')
plt.ylabel('주문한 요리의 개수', fontsize = 14, loc = 'center')
plt.legend().remove()
plt.show()
```
