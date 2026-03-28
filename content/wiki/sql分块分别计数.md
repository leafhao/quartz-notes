---
tags:
  - sql
---
# 分块分别计数

![sample](http://imageocean.longfeihao.eu.org/21_15_6_54_15724028779106.jpg)

有上图中的（序号，类别）信息，想得到（计数）这样的结果

## 方法
1. 新建一个表， （seq, class, target)
2. 查询SQL
```SQL
SELECT  num
        ,seq
        ,class
        ,la
        ,diff
        ,cum
        ,ROW_NUMBER() OVER(PARTITION BY num, cum ORDER BY seq) AS rn
FROM    (
            SELECT  num
                    ,seq
                    ,class
                    ,la
                    ,diff
                    ,SUM(diff) OVER(PARTITION BY num ORDER BY seq) AS cum
            FROM    (
                        SELECT  num
                                ,seq
                                ,class
                                ,LAG(class, 1) OVER(PARTITION BY num ORDER BY seq) AS la
                                ,IF( class = LAG(class, 1) OVER(PARTITION BY num ORDER BY seq) ,0 ,1 ) AS diff
                        FROM    (
                                    SELECT  1 AS num
                                            ,seq
                                            ,class
                                    FROM    alihealth_algo_dev.toy_yaoguang
                                ) org_tab
                    ) block_tb
        ) res_tb
;
```
