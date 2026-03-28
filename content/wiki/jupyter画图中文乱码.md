# jupyter画图中文乱码

[simhei 字体](https://git.lug.ustc.edu.cn/jhlf/note/-/blob/f72a14f8b4829bcb90ad79ca5123c014288eefef/attachment/excalidraw/font/SimHei.ttf)


## 字体复制到`matplotlib`包中

```bash
# 以conda为例
lib/python3.7/site-packages/matplotlib/mpl-data/fonts/ttf/
```

## 修改配置`matplotlibrc`

```bash
# 以conda为例
lib/python3.7/site-packages/matplotlib/mpl-data/matplotlibrc
```

修改如下让内容:

1. font.family : sans.serif 取消注释
2. 添加字体 font.sans.serif: SimHei, …
3. axes.unicode_minus: False 取消注释

## 删除`matplotlib`缓存

macOS: `~/.matplotlib`Linux: `~/.cache/matplotlib`