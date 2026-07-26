#!/bin/bash
# ================================================
# 搭子社区 - 一键启动脚本
# 同时启动后端(Java)和前端(Vite)服务
# ================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/dazi-community-backend"
FRONTEND_DIR="$SCRIPT_DIR/dazi-community-frontend"
PID_FILE="$SCRIPT_DIR/.running.pid"

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║      🤝 搭子社区 - 一键启动             ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""

# ------ 1. Check MySQL ------
echo "[1/4] 检查 MySQL 数据库..."
if command -v docker &> /dev/null; then
  RUNNING=$(docker ps --filter "name=mysql-dazi-community" --format "{{.Names}}" 2>/dev/null)
  if [ -n "$RUNNING" ]; then
    echo "  ✅ MySQL 容器运行中"
  else
    EXIST=$(docker ps -a --filter "name=mysql-dazi-community" --format "{{.Names}}" 2>/dev/null)
    if [ -n "$EXIST" ]; then
      echo "  🔄 启动 MySQL 容器..."
      docker start mysql-dazi-community > /dev/null 2>&1
      sleep 3
      echo "  ✅ MySQL 已启动"
    else
      echo "  ⚠️  MySQL 容器不存在，请先创建:"
      echo "     docker run -d --name mysql-dazi-community -p 3306:3306"
      echo "     -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_DATABASE=dazi_community mysql:8.0"
      exit 1
    fi
  fi
else
  echo "  ⚠️  未检测到 Docker，请确保 MySQL 已运行在 localhost:3306"
fi

# ------ 2. Check JAR ------
echo "[2/4] 检查后端程序..."
JAR_FILE="$BACKEND_DIR/target/dazi-community-1.0.0.jar"
if [ ! -f "$JAR_FILE" ]; then
  echo "  🔧 未找到 JAR，正在编译..."
  JAVA_17_HOME="/usr/local/Cellar/openjdk@17/17.0.19/libexec/openjdk.jdk/Contents/Home"
  cd "$BACKEND_DIR"
  if [ -d "$JAVA_17_HOME" ]; then
    JAVA_HOME="$JAVA_17_HOME" mvn clean package -DskipTests -q
  else
    mvn clean package -DskipTests -q
  fi
  echo "  ✅ 编译完成"
else
  echo "  ✅ JAR 已就绪"
fi

# ------ 3. Start Backend ------
echo "[3/4] 启动后端服务..."
cd "$BACKEND_DIR"

JAVA_17_HOME="/usr/local/Cellar/openjdk@17/17.0.19/libexec/openjdk.jdk/Contents/Home"
if [ -d "$JAVA_17_HOME" ]; then
  JAVA_CMD="$JAVA_17_HOME/bin/java"
  echo "  📦 使用 JDK 17"
else
  JAVA_CMD="java"
  echo "  📦 使用默认 JDK"
fi

# Kill any existing backend on port 8080
lsof -ti:8080 | xargs kill -9 2>/dev/null || true
sleep 1

$JAVA_CMD -jar "$JAR_FILE" > /tmp/dazi-backend.log 2>&1 &
BACKEND_PID=$!
echo "  🚀 后端启动中 (PID: $BACKEND_PID, 端口: 8080)..."

# Wait for backend ready
sleep 6
if curl -s http://localhost:8080/api/v1/community/first/list > /dev/null 2>&1; then
  echo "  ✅ 后端已就绪"
else
  echo "  ⏳ 等待后端就绪..."
  sleep 6
fi

# ------ 4. Start Frontend ------
echo "[4/4] 启动前端服务..."
cd "$FRONTEND_DIR"

# Kill any existing frontend on port 5173
lsof -ti:5173 | xargs kill -9 2>/dev/null || true
sleep 1

npx vite --host > /tmp/dazi-frontend.log 2>&1 &
FRONTEND_PID=$!
echo "  🚀 前端启动中 (PID: $FRONTEND_PID, 端口: 5173)..."
sleep 3

# Save PIDs for stop script
echo "$BACKEND_PID" > "$PID_FILE"
echo "$FRONTEND_PID" >> "$PID_FILE"

# ------ Done ------
echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║          🎉 启动完成！                   ║"
echo "  ╠══════════════════════════════════════════╣"
echo "  ║  🔗 前端地址:                            ║"
echo "  ║     http://localhost:5173                 ║"
echo "  ║                                          ║"
echo "  ║  🔗 后端地址:                            ║"
echo "  ║     http://localhost:8080                 ║"
echo "  ║                                          ║"
echo "  ║  🔗 API文档:                             ║"
echo "  ║     http://localhost:8080/doc.html        ║"
echo "  ║                                          ║"
echo "  ║  🛑 停止服务: bash stop.sh               ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""
