#!/bin/bash
# ================================================
# 搭子社区 - 一键停止脚本
# 停止后端(Java)和前端(Vite)服务
# ================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$SCRIPT_DIR/.running.pid"

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║      🛑 搭子社区 - 一键停止              ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""

# Read PIDs from file
BACKEND_PID=""
FRONTEND_PID=""
if [ -f "$PID_FILE" ]; then
  BACKEND_PID=$(sed -n '1p' "$PID_FILE" 2>/dev/null)
  FRONTEND_PID=$(sed -n '2p' "$PID_FILE" 2>/dev/null)
fi

# Stop backend (port 8080)
BACKEND_PORT_PID=$(lsof -ti:8080 2>/dev/null || true)
if [ -n "$BACKEND_PORT_PID" ]; then
  kill -9 "$BACKEND_PORT_PID" 2>/dev/null || true
  echo "  ✅ 已停止后端服务 (PID: $BACKEND_PORT_PID)"
elif [ -n "$BACKEND_PID" ]; then
  kill -9 "$BACKEND_PID" 2>/dev/null || true
  echo "  ✅ 已停止后端服务 (PID: $BACKEND_PID)"
else
  echo "  ℹ️  后端服务未运行"
fi

# Stop frontend (port 5173)
FRONTEND_PORT_PID=$(lsof -ti:5173 2>/dev/null || true)
if [ -n "$FRONTEND_PORT_PID" ]; then
  kill -9 "$FRONTEND_PORT_PID" 2>/dev/null || true
  echo "  ✅ 已停止前端服务 (PID: $FRONTEND_PORT_PID)"
elif [ -n "$FRONTEND_PID" ]; then
  kill -9 "$FRONTEND_PID" 2>/dev/null || true
  echo "  ✅ 已停止前端服务 (PID: $FRONTEND_PID)"
else
  echo "  ℹ️  前端服务未运行"
fi

# Clean up PID file
rm -f "$PID_FILE"

# Verify ports are free
sleep 1
if lsof -ti:8080 > /dev/null 2>&1 || lsof -ti:5173 > /dev/null 2>&1; then
  echo ""
  echo "  ⚠️  部分服务仍在运行，尝试强制停止..."
  lsof -ti:8080 | xargs kill -9 2>/dev/null || true
  lsof -ti:5173 | xargs kill -9 2>/dev/null || true
  sleep 1
fi

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║      ✅ 所有服务已停止                   ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""

# Ask if user wants to stop MySQL
read -p "  🗄️  是否同时停止 MySQL 容器? (y/N): " STOP_DB
if [ "$STOP_DB" = "y" ] || [ "$STOP_DB" = "Y" ]; then
  echo "  🔄 停止 MySQL 容器..."
  docker stop mysql-dazi-community 2>/dev/null && echo "  ✅ MySQL 已停止" || echo "  ⚠️  MySQL 容器不存在或已停止"
fi
echo ""
