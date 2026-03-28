---
tags:
- streamlit
---

通常的html可直接渲染
```python
import streamlit as st

st.markdown(html_content, unsafe_allow_html=True)
```

如果包含一些控件(CSS, JS)的复杂html可使用html专用的包
```python
from streamlit.components.v1 import html

html(html_content, height=300)
```

如果html中包含一些外部网址，streamlit无法正常展示，需要把这些图片下载本地才能正常访问。

一种比较方便的方式是替换html中所有图片网址下载到`static`中，启动stream的静态服务。完成后自动清空`static`文件夹。参考代码如下

```python
import json
import shutil
import atexit
import regex as re
import requests
from pathlib import Path
import streamlit as st
from streamlit.components.v1 import html

# STREAMLIT_SERVER_ENABLE_STATIC_SERVING=true streamlit run xxx.py #可加载静态资源

@st.cache_data
def load_json(data_path):
    with open(data_path, encoding='utf-8') as fin:
        return [json.loads(line) for line in fin]
    

def clean_static_folder():
    """程序退出时删除static文件夹及其内容"""
    clean_dir = Path('./static')
    if clean_dir.exists() and clean_dir.is_dir():
        try:
            shutil.rmtree("static")  # 递归删除文件夹及内容
            print("✅ static文件夹已清空")
        except Exception as e:
            print(f"❌ 清理static文件夹失败：{str(e)}")

# 注册清理函数，确保程序退出时执行
atexit.register(clean_static_folder)



# 提取html中的图片链接并下载到本地
def norm_html_text(html_text):
    html_img_dir = Path('./static')
    if not html_img_dir.exists():
        html_img_dir.mkdir(parents=True, exist_ok=True)
    local_img_url_prefix = 'http://172.31.131.31:8501/app/static/'
    img_urls = re.findall(r'<img.*?src="(.*?)"', html_text)
    for img_url in img_urls:
        img_name = img_url.split('/')[-1]
        img_path = html_img_dir / img_name
        if not img_path.exists():
            try:
                response = requests.get(img_url, timeout=5)
                if response.status_code == 200:
                    with open(img_path, 'wb') as f:
                        f.write(response.content)
                    print(f'Downloaded image: {img_url} to {img_path}')
                else:
                    print(f'Failed to download image: {img_url}, status code: {response.status_code}')
            except Exception as e:
                print(f'Error downloading image: {img_url}, error: {e}')

        local_img_url = local_img_url_prefix + img_name
        html_text = html_text.replace(img_url, local_img_url)

    return html_text


data_list = load_json('./llm_out/comm_valid_data.json')


from streamlit import config  # 导入配置对象

# 打印Streamlit实际读取的静态服务配置（应显示True）
st.write("静态服务是否启用：", config.get_option("server.enableStaticServing"))


st.write('''
# 数据显示
''')

if 'index' not in st.session_state:
    st.session_state.index = 0

# 增加搜索框
search = st.text_input('Search')
if search:
    for i, data in enumerate(data_list):
        if search.strip() == data['topic_id']:
            st.session_state.index = i
            break

pre_button = st.button('Previous')
if pre_button:
    st.session_state.index -= 1

next_button = st.button('Next')
if next_button:
    st.session_state.index += 1

index = st.slider('slider', 0, len(data_list)-1, st.session_state.index)
if index:
    st.session_state.index = index

index = st.session_state.index


data = data_list[index]

st.markdown('## 信息')

topic_id = data['topic_id']
user_id = data['user_id']

st.markdown(f'**index:** {index} / {len(data_list)}')
st.markdown(f'**topic_id:** {topic_id}, **user_id:** {user_id}')
st.markdown('---')


question = data['question']
answer = data['answer']

steps = data['steps']

fmt_steps = ''
for i, step in enumerate(steps):
    fmt_steps += f'空{i+1}: ${step} $\n\n'

img_path_list = data['img_path_list']
llm_out = data['llm_out']



st.markdown('## 渲染数据')
st.markdown('**题干:**')
st.markdown(norm_html_text(question), unsafe_allow_html=True)

st.markdown('**标准答案:**')
st.markdown(norm_html_text(answer), unsafe_allow_html=True)



st.markdown('**学生作答:**')
st.markdown(fmt_steps)

st.markdown('**图片:**')
for img_path in img_path_list:
    st.image(img_path)


st.markdown('---')

st.markdown('## 大模型评分')
st.markdown('```\n' + llm_out + '\n```')
```


