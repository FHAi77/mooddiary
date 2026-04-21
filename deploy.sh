#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

show_help() {
    echo "Usage: ./deploy.sh [command]"
    echo ""
    echo "Commands:"
    echo "  deploy    - Build and start the Mood Diary service"
    echo "  restart   - Restart the Mood Diary service"
    echo "  stop      - Stop the Mood Diary service"
    echo "  status    - Check the service status"
    echo "  logs      - View service logs"
    echo "  help      - Show this help message"
    echo ""
    echo "使用方法: ./deploy.sh [命令]"
    echo ""
    echo "命令:"
    echo "  deploy    - 构建并启动心情日记服务"
    echo "  restart   - 重启心情日记服务"
    echo "  stop      - 停止心情日记服务"
    echo "  status    - 查看服务状态"
    echo "  logs      - 查看服务日志"
    echo "  help      - 显示此帮助信息"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Error: Docker is not installed. Please install Docker first."
        echo "错误: Docker 未安装，请先安装 Docker。"
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo "Error: Docker Compose is not installed. Please install Docker Compose first."
        echo "错误: Docker Compose 未安装，请先安装 Docker Compose。"
        exit 1
    fi
}

deploy() {
    echo "Starting Mood Diary deployment..."
    echo "开始部署心情日记服务..."
    
    check_docker
    
    mkdir -p "$SCRIPT_DIR/data"
    
    echo "Building Docker image..."
    echo "构建 Docker 镜像..."
    docker-compose build
    
    echo "Starting services..."
    echo "启动服务..."
    docker-compose up -d
    
    echo ""
    echo "Deployment completed successfully!"
    echo "部署成功完成！"
    echo ""
    echo "Access the application at: http://localhost:5000"
    echo "访问地址: http://localhost:5000"
    echo ""
    echo "To check status: ./deploy.sh status"
    echo "查看状态: ./deploy.sh status"
    echo "To view logs: ./deploy.sh logs"
    echo "查看日志: ./deploy.sh logs"
}

restart() {
    echo "Restarting Mood Diary service..."
    echo "正在重启心情日记服务..."
    
    check_docker
    docker-compose restart
    
    echo ""
    echo "Service restarted successfully!"
    echo "服务重启成功！"
}

stop() {
    echo "Stopping Mood Diary service..."
    echo "正在停止心情日记服务..."
    
    check_docker
    docker-compose down
    
    echo ""
    echo "Service stopped successfully!"
    echo "服务已停止！"
}

status() {
    echo "Checking Mood Diary service status..."
    echo "检查心情日记服务状态..."
    echo ""
    
    check_docker
    docker-compose ps
}

logs() {
    check_docker
    docker-compose logs -f
}

case "${1:-deploy}" in
    deploy)
        deploy
        ;;
    restart)
        restart
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    logs)
        logs
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        echo "未知命令: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
