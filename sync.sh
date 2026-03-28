#!/bin/bash
# Obsidian → Quartz → GitHub 同步脚本
# 监听 Obsidian 笔记目录，自动同步到 Quartz 并推送

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QUARTZ_DIR="$SCRIPT_DIR"
CONTENT_DIR="/Users/longfeihao/workspace/obsidian/Note"

echo "🍃 Obsidian → Quartz 同步服务启动"
echo "   笔记目录: $CONTENT_DIR"
echo "   Quartz: $QUARTZ_DIR"

# 使用 fswatch 监听变化
fswatch -o --recursive --include "\.md$" --exclude "\.obsidian" "$CONTENT_DIR" | while read -r event; do
    echo "📝 检测到变化: $(date '+%Y-%m-%d %H:%M:%S')"
    
    cd "$QUARTZ_DIR"
    
    # 拉取远程更新（避免冲突）
    git pull --rebase origin v4 2>/dev/null || true
    
    # 添加所有变化
    git add -A
    
    # 检查是否有变化
    if git diff --staged --quiet; then
        echo "   无实际变化，跳过"
        continue
    fi
    
    # 提交
    COMMIT_MSG="Sync: $(date '+%Y-%m-%d %H:%M')"
    git commit -m "$COMMIT_MSG"
    
    # 推送
    if git push origin v4; then
        echo "✅ 已推送: $COMMIT_MSG"
    else
        echo "❌ 推送失败"
    fi
done