#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

mkdir -p instance

show_help() {
    echo "心情日记系统部署脚本"
    echo "用法: $0 [命令]"
    echo ""
    echo "可用命令:"
    echo "  start    - 启动/部署服务（首次部署或重启）"
    echo "  stop     - 停止服务"
    echo "  restart  - 重启服务"
    echo "  logs     - 查看日志"
    echo "  status   - 查看服务状态"
    echo "  update   - 更新服务（重新构建镜像）"
    echo "  help     - 显示帮助信息"
    echo ""
    echo "Mood Diary System Deploy Script"
    echo "Usage: $0 [command]"
    echo ""
    echo "Available commands:"
    echo "  start    - Start/Deploy service (first deploy or restart)"
    echo "  stop     - Stop service"
    echo "  restart  - Restart service"
    echo "  logs     - View logs"
    echo "  status   - Check service status"
    echo "  update   - Update service (rebuild image)"
    echo "  help     - Show help information"
}

start_service() {
    echo "正在启动心情日记服务..."
    echo "Starting Mood Diary service..."
    docker compose up -d --build
    echo ""
    echo "服务启动成功!"
    echo "Service started successfully!"
    echo "访问地址 / Access URL: http://localhost:5000"
}

stop_service() {
    echo "正在停止心情日记服务..."
    echo "Stopping Mood Diary service..."
    docker compose down
    echo "服务已停止"
    echo "Service stopped"
}

restart_service() {
    echo "正在重启心情日记服务..."
    echo "Restarting Mood Diary service..."
    docker compose restart
    echo "服务已重启"
    echo "Service restarted"
}

view_logs() {
    echo "查看服务日志 (按Ctrl+C退出):"
    echo "Viewing service logs (Press Ctrl+C to exit):"
    docker compose logs -f
}

check_status() {
    echo "服务状态:"
    echo "Service Status:"
    docker compose ps
    echo ""
    echo "健康检查:"
    echo "Health Check:"
    docker inspect --format='{{.State.Health.Status}}' mooddiary 2>/dev/null || echo "未运行 / Not running"
}

update_service() {
    echo "正在更新服务..."
    echo "Updating service..."
    docker compose down
    docker compose build --no-cache
    docker compose up -d
    echo "服务更新完成!"
    echo "Service update completed!"
}

case "${1:-help}" in
    start)
        start_service
        ;;
    stop)
        stop_service
        ;;
    restart)
        restart_service
        ;;
    logs)
        view_logs
        ;;
    status)
        check_status
        ;;
    update)
        update_service
        ;;
    help)
        show_help
        ;;
    *)
        echo "未知命令: $1"
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
