---
tags:
  - mongo
---
问题：创建数据库时，创建了一个复合id，忘记拆分。其中复合id的前k为是一个单独id。
新增一个id的方式如下：

```sh
db.yourCollectionName.updateMany( 
	{}, // 空的查询对象意味着修改所有文档 
	[{ 
		$set: { 
				a: { $substrCP: ["$b", 0, K] } // 将K替换成实际的字符数 
			  } 
     }]
);
```