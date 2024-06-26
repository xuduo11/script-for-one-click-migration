# 定义变量
REPO_URL="https://github.com/xuduo11/script-for-one-click-migration"
CONFIG_DIR="$HOME/configs"
BACKUP_DIR="$HOME/config_backup_$(date +%Y%m%d_%H%M%S)"
CONFIG_FILES=(".vimrc" ".zshrc")

# 更新系统并安装必要的软件
echo "更新系统并安装必要的软件..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git

# 克隆配置仓库
echo "克隆配置仓库：$REPO_URL"
git clone "$REPO_URL" "$CONFIG_DIR"

# 创建备份目录
echo "创建备份目录：$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# 备份现有的配置文件
echo "开始备份现有的配置文件..."
for FILE in "${CONFIG_FILES[@]}"; do
    if [ -f "$HOME/$FILE" ]; then
        echo "备份 $FILE 到 $BACKUP_DIR"
        mv "$HOME/$FILE" "$BACKUP_DIR"
    else
        echo "$FILE 不存在，跳过备份。"
    fi
done

# 复制新的配置文件到主目录
echo "开始复制新的配置文件..."
for FILE in "${CONFIG_FILES[@]}"; do
    if [ -f "$CONFIG_DIR/$FILE" ]; then
        echo "复制 $CONFIG_DIR/$FILE 到 $HOME"
        cp "$CONFIG_DIR/$FILE" "$HOME"
    else
        echo "新配置文件 $CONFIG_DIR/$FILE 不存在，跳过复制。"
    fi
done

# 验证复制是否成功
echo "验证配置文件是否成功复制..."
for FILE in "${CONFIG_FILES[@]}"; do
    if diff "$HOME/$FILE" "$CONFIG_DIR/$FILE" > /dev/null; then
        echo "$FILE 复制成功。"
    else
        echo "$FILE 复制失败或内容不同。"
    fi
done

echo "配置文件迁移完成。"
