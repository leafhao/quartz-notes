---
tags:
  - mongo
  - python
---

## 基础查询

查询某个字段等于'xx'
```python
import pymongo

# 链接pymongo服务
client = pymongo.MongoClient(
	host='xxx',
	port=27017,
	username='admin',
	password='xxx',
	authSource='admin'
)

# 指定数据库和collection
database = client['science_pigai_log']
collection = database['questin_html']

# 查询
query = {'topic_id': 'xxx'}
cursor = collection.find(query, projection={'_id': False})

data_list = []
for record in cursor:
	data_list.append(record)
```

查询某个字段在一个集合内
```python
query = {'section': {'$in': section_code_list}}
```


## pipeline

复杂的操作，需要使用pipeline的复杂操作。顾名思义，是对数据库做一个操作流程，获得最终结果

如，我有一个如下需求：
> 从数据库中查询给定试题id列表，要求每个试题随机抽样N条数据


```python
pipeline = [
	{'$match': {'topic_id': {'$in': topic_id_list}}},
	{'$addFields': {'random': {'$rand': {}}}},
	{'$setWindowFields': {
		'partitionBy': '$topic_id',
		'sortBy': {'random': 1},
		'output': {
			'rank': {'$rank': {}}
			}
		}
	}，
	{'$match': {'rank': {'$lt': N}}},
	{'$unset': ['random', 'rank']},
	{'$project': {'_id': 0}}
]

# 执行聚合（允许磁盘使用，处理大量数据）
cursor = collection.aggregate(pipeline, allowDiskUse=True)
```