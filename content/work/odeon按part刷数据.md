
针对某些日志数据过于庞大，按天存储的增量表。

如果想获取最近一年甚至三年的数据，直接查询的话，由于表过大一般很难成功。因此需要分别分区的数据分别查询，最后合并。


## 带变量的sql

首先，在sql脚本里定义part的变量

```sql
set
  spark.sql.shuffle.partitions = 1;
insert
  overwrite directory "/project/edu_ai/lfhao/data/${PART_DATE}" row format delimited fields terminated by '\t'
select
  *
from
  gxhtk_dev.odb_ai_service_log_di
where
  part = '${PART_DATE}'
```

如该表，定义`PART_DATE`

## 定义作业

在作业中制定sql脚本的位置和新增`PART_DATE`变量
![](http://imageocean.longfeihao.eu.org/26_17_56_13_PixPin_2025-03-26_17-55-26.png)


## 运行作业

在作业运行界面定义“并行执行参数”，“调度日期的起止时间”，“PART_DATE接收格式为”`$[yyyy-MM-dd]`时，表明接收调度日期的格式。

下图是一个示例，并行4个任务，跑`2025-03-01到2025-03-04`四天，每天传入sql的`PART_DATE`是'yyyy-MM-dd'格式

![](http://imageocean.longfeihao.eu.org/26_17_59_24_PixPin_2025-03-26_17-58-52.png)