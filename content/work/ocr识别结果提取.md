
大模型ocr识别结果是一个递归的json，整个结构见链接：
[图文系统构架](https://yf2ljykclb.xfchat.iflytek.com/docx/doxrzTOZ48eQu9w4A9BQgVyqU8c?blockId=doxrzEYXpNpUcf77Hhzul4iZ70g&blockToken=WZlzwcnfShI2m9bXtJjrOYIizge&blockType=whiteboard&doc_app_id=501)

提取数据的代码示例如下:
```python
import json

import regex as re

from copy import deepcopy

import uuid

from typing import Dict, List, Any, Optional, Union

  

def extract_print_text_from_json(region: Dict[str, Any]) -> str:

"""Extract print text from a region or return underline for handwritten underlined print text."""

if region['type'] != 'text_unit':

return ''

  

if region.get('category') == 'print':

return region.get('text', '')

  

if (region.get('category') == 'handwrite' and

'attribute' in region):

for attribute_item in region['attribute']:

if (attribute_item.get('name') == 'underline' and

attribute_item.get('value', {}).get('category') == 'print'):

return '______'

return ''

  

def extract_level_a_region_from_json(json_data: Union[Dict, List], question_stem: str = '') -> List[Dict]:

"""Recursively extract level A regions from JSON data."""

region_list = []

  

if isinstance(json_data, dict):

if (json_data.get('type') == 'region' and

any(attr.get('value') == 'level_a'

for attr in json_data.get('attribute', []))):

new_data = deepcopy(json_data)

if question_stem:

new_data["deal_question_stem"] = question_stem

region_list.append(new_data)

  

for value in json_data.values():

region_list.extend(extract_level_a_region_from_json(value, question_stem))

  

elif isinstance(json_data, list):

current_question_stem = ""

for idx, item in enumerate(json_data):

if (idx == 0 and isinstance(item, dict) and

item.get('category') == 'question_stem'):

current_question_stem = extract_print_text_from_json(item)

continue

region_list.extend(extract_level_a_region_from_json(item, current_question_stem))

  

return region_list

  

def group_related_regions(data: List[Dict]) -> List[List[Dict]]:

"""Group regions based on their relation attributes."""

id_to_item = {item["id"]: item for item in data}

processed_ids = set()

groups = []

  

for item in data:

item_id = item["id"]

if item_id in processed_ids:

continue

  

relation = next((attr["value"] for attr in item.get("attribute", [])

if attr["name"] == "relation"), None)

  

if relation:

group = [item]

processed_ids.add(item_id)

  

for related_id in relation:

if (related_id != item_id and

related_id in id_to_item and

related_id not in processed_ids):

group.append(id_to_item[related_id])

processed_ids.add(related_id)

  

groups.append(group)

else:

groups.append([item])

processed_ids.add(item_id)

  

return groups

  

def trans_region_coord(coords: Optional[List[Dict]]) -> Optional[Dict]:

"""Transform region coordinates into a structured format."""

if not coords:

return None

  

x_coords = [coord['x'] for coord in coords]

y_coords = [coord['y'] for coord in coords]

sorted_x = sorted(x_coords)

sorted_y = sorted(y_coords)

  

return {

"height": sorted_y[-1] - sorted_y[0],

"width": sorted_x[-1] - sorted_x[0],

"ltX": sorted_x[0],

"ltY": sorted_y[0],

"x": x_coords,

"y": y_coords,

}

  

def find_textlines(data, _type):

if isinstance(data, dict):

for key, value in data.items():

if key == "content" and isinstance(value, list):

for item in value:

for i_item in item:

# print(i_item.get("type"))

# if i_item.get("type") == "text_block" or i_item.get("type") == "textline":

category = i_item.get("category") if isinstance(i_item, dict) else None

start_tag = [f'<{category}>'] if category else None

end_tag = [f'</{category}>'] if category else None

  

if i_item.get("type") == _type and _type == "textline":

if start_tag:

yield start_tag + i_item.get("text") + end_tag

else:

yield i_item.get("text")

elif i_item.get("type") == _type and _type == "text_block" and i_item.get("category") == "answer":

if start_tag:

yield start_tag + i_item.get("text") + end_tag

else:

yield i_item.get("text")

else:

if start_tag:

yield start_tag

yield from find_textlines(i_item, _type)

if end_tag:

yield end_tag

else:

category = value.get("category") if isinstance(value, dict) else None

start_tag = [f'<{category}>'] if category else None

end_tag = [f'</{category}>'] if category else None

  

if start_tag:

yield start_tag

yield from find_textlines(value, _type)

if end_tag:

yield end_tag

elif isinstance(data, list):

for item in data:

category = item.get("category") if isinstance(item, dict) else None

start_tag = [f'<{category}>'] if category else None

end_tag = [f'</{category}>'] if category else None

if start_tag:

yield start_tag

yield from find_textlines(item, _type)

if end_tag:

yield end_tag

  

def find_textunit(data, _type):

if isinstance(data, dict):

for key, value in data.items():

if key == "content" and isinstance(value, list):

for item in value:

for i_item in item:

# print(i_item.get("type"))

# if i_item.get("type") == "text_block" or i_item.get("type") == "textline":

category = i_item.get("category") if isinstance(i_item, dict) else None

start_tag = f'<{category}>' if category else None

end_tag = f'</{category}>' if category else None

  

# 遇到textline标志，加一个换行

if i_item.get("type") == "textline":

yield "\n"

  

if i_item.get("type") == _type:

if start_tag:

yield start_tag + i_item.get("text") + end_tag

else:

yield i_item.get("text")

else:

if start_tag:

yield start_tag

yield from find_textunit(i_item, _type)

if end_tag:

yield end_tag

else:

category = value.get("category") if isinstance(value, dict) else None

start_tag = f'<{category}>' if category else None

end_tag = f'</{category}>' if category else None

  

if start_tag:

yield start_tag

yield from find_textunit(value, _type)

if end_tag:

yield end_tag

elif isinstance(data, list):

for item in data:

category = item.get("category") if isinstance(item, dict) else None

start_tag = f'<{category}>' if category else None

end_tag = f'</{category}>' if category else None

if start_tag:

yield start_tag

yield from find_textunit(item, _type)

if end_tag:

yield end_tag

  
  

def norm_textunit(text_unit):

text = ''.join(text_unit).replace('<text>', '').replace('</text>', '').replace('<print>', '').replace('</print>', '')

answer_list = re.findall('<answer>(.*?)</answer>', text, re.DOTALL)

question_stem = re.findall('<question_stem>(.*?)</question_stem>', text, re.DOTALL)[0].strip()

  

answer_candidate_list = []

for answer in answer_list:

answer = answer.replace('<handwrite>', '').replace('</handwrite>', '')

candidate_list = re.findall('<selection>(.*?)</selection>', answer, re.DOTALL)

candidate_list = [e.strip().split('\n') for e in candidate_list]

answer_candidate_list.append(candidate_list)

  

return {

'answer_candidate_list': answer_candidate_list,

'question_stem': question_stem,

}

  
  
  
  
  

def execute(params: Dict) -> Dict:

"""Main execution function to process segmentation results."""

content_list = params.get('image', [])

  

if not content_list:

return {"AreginInfo": []}

  

region_coords = {}

print("content_list len ",len(content_list))

all_level_a_regions = []

for i in range(len(content_list)):

all_level_a_region = extract_level_a_region_from_json(content_list[i])

all_level_a_regions.extend(all_level_a_region)

region_coord = {region['id']: region.get('coord') for region in all_level_a_regions}

region_coords.update(region_coord)

  

grouped_regions = group_related_regions(all_level_a_regions)

  

for level_a_region in all_level_a_regions:

llm_ocr = list(find_textlines(level_a_region, 'textline'))

llm_ocr_unit = list(find_textunit(level_a_region, 'text_unit'))

llm_ocr_unit = norm_textunit(llm_ocr_unit)

level_a_region['llm_ocr'] = llm_ocr

level_a_region['llm_ocr_unit'] = llm_ocr_unit

  
  

aregin_info = []

for group in grouped_regions:

region_ids = [item['id'] for item in group]

ocr_boxes = [

{

"id": region_id,

"imageId": region_id.split("||")[0],

"coord": trans_region_coord(region_coords.get(region_id))

}

for region_id in region_ids

]

  

aregin_info.append({

"ARegionId": region_ids,

"OCRBoxes": ocr_boxes,

"id": str(uuid.uuid4()).replace('-', '')

})

  

return {"AreginInfo": aregin_info, 'grouped_regions': grouped_regions, 'all_level_a_regions': all_level_a_regions}

  
  

if __name__ == '__main__':

with open('335.json', encoding='utf-8') as fin:

json_data = json.load(fin)

  

res = execute(json_data)

with open('335_llm_ocr.json', 'w', encoding='utf-8') as fout:

json.dump(res, fout, ensure_ascii=False, indent=2)
```