# arXiv Daily Workflow - Learnings

## 2026-04-19: RSS Feed Fallback for Rate Limiting

### Problem
arXiv API returns persistent HTTP 429 rate limits. Even the official `arxiv` Python library (with Client API and delay_seconds settings) fails.

### Solution: RSS Feed Fallback

Use arXiv RSS feeds which bypass API entirely:

```python
import feedparser
import json
import time
from datetime import datetime

RSS_FEEDS = [
    "http://export.arxiv.org/rss/cs.CL",  # Computation and Language
    "http://export.arxiv.org/rss/cs.AI",  # Artificial Intelligence  
    "http://export.arxiv.org/rss/cs.LG",  # Machine Learning
    "http://export.arxiv.org/rss/cs.CV",  # Computer Vision
]

KEYWORDS = ["LLM", "multi-modal", "agent", "RLHF", "RAG", "MoE", "GPT", "transformer"]

def matches_keywords(title, abstract):
    text = (title + " " + abstract).lower()
    return any(kw.lower() in text for kw in KEYWORDS)

papers = []
seen_ids = set()

for feed_url in RSS_FEEDS:
    feed = feedparser.parse(feed_url)
    for entry in feed.entries:
        arxiv_id = entry.link.split('/')[-1]
        if arxiv_id in seen_ids:
            continue
        title = entry.title.replace('\n', ' ').strip()
        abstract = entry.summary.replace('\n', ' ').strip()
        if not matches_keywords(title, abstract):
            continue
        pub_date = entry.get('published_parsed', entry.get('updated_parsed'))
        published = datetime(*pub_date[:6]) if pub_date else datetime.now()
        # Clean abstract (remove "arXiv:xxx Abstract:" prefix)
        abstract_clean = abstract.split('Abstract:', 1)[1].strip() if 'Abstract:' in abstract else abstract
        paper = {
            "title": title,
            "authors": [],
            "year": published.year,
            "url": entry.link,
            "abstract": abstract_clean,
            "arxiv_id": arxiv_id,
            "pdf_url": f"https://arxiv.org/pdf/{arxiv_id}",
            "categories": [feed_url.split('/')[-1]],
            "primary_category": feed_url.split('/')[-1],
            "published": published.isoformat(),
            "updated": published.isoformat(),
        }
        papers.append(paper)
        seen_ids.add(arxiv_id)
    time.sleep(1)

papers.sort(key=lambda x: x['published'], reverse=True)
papers = papers[:10]

with open('papers/papers_raw.jsonl', 'w') as f:
    for p in papers:
        f.write(json.dumps(p, ensure_ascii=False) + '\n')
```

### Usage
```bash
cd /tmp/arxiv_daily && mkdir -p papers && python3 fetch_rss.py
```

### Notes
- RSS feeds update daily with new submissions
- No structured authors field (RSS limitation)
- Keywords filtering happens after retrieval (less precise than API search)
- Works reliably when API is rate limited