#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        log_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
}

docker_compose_cmd() {
    if docker compose version &> /dev/null; then
        docker compose "$@"
    else
        docker-compose "$@"
    fi
}

deploy() {
    log_info "Starting deployment..."
    
    check_docker
    
    mkdir -p data
    
    log_info "Building Docker image..."
    docker_compose_cmd build --no-cache
    
    log_info "Starting containers..."
    docker_compose_cmd up -d
    
    log_success "Deployment completed successfully!"
    log_info "Application is running at: http://localhost:5000"
    
    show_status
}

start() {
    log_info "Starting application..."
    check_docker
    docker_compose_cmd up -d
    log_success "Application started successfully!"
    show_status
}

stop() {
    log_info "Stopping application..."
    check_docker
    docker_compose_cmd down
    log_success "Application stopped successfully!"
}

restart() {
    log_info "Restarting application..."
    check_docker
    docker_compose_cmd restart
    log_success "Application restarted successfully!"
    show_status
}

rebuild() {
    log_info "Rebuilding and redeploying application..."
    check_docker
    docker_compose_cmd down
    docker_compose_cmd build --no-cache
    docker_compose_cmd up -d
    log_success "Application rebuilt and started successfully!"
    show_status
}

show_status() {
    log_info "Container status:"
    docker_compose_cmd ps
}

show_logs() {
    local lines=${1:-100}
    log_info "Showing last $lines lines of logs..."
    docker_compose_cmd logs --tail="$lines" -f
}

clean() {
    log_warning "This will remove all containers, images, and volumes!"
    read -p "Are you sure? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        log_info "Cleaning up..."
        docker_compose_cmd down -v --rmi all
        log_success "Cleanup completed!"
    else
        log_info "Cleanup cancelled."
    fi
}

backup_db() {
    log_info "Backing up database..."
    local backup_dir="./backups"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    mkdir -p "$backup_dir"
    
    if [ -f "./data/mooddiary.db" ]; then
        cp "./data/mooddiary.db" "$backup_dir/mooddiary_$timestamp.db"
        log_success "Database backed up to: $backup_dir/mooddiary_$timestamp.db"
    else
        log_warning "No database file found to backup."
    fi
}

show_help() {
    echo "
${GREEN}Mood Diary Deployment Script${NC}
${BLUE}Usage:${NC} $0 {command}

${YELLOW}Commands:${NC}
  ${GREEN}deploy${NC}     - Full deployment (build and start)
  ${GREEN}start${NC}      - Start the application
  ${GREEN}stop${NC}       - Stop the application
  ${GREEN}restart${NC}    - Restart the application
  ${GREEN}rebuild${NC}    - Rebuild and redeploy the application
  ${GREEN}status${NC}     - Show container status
  ${GREEN}logs${NC}       - Show application logs (default: 100 lines)
  ${GREEN}logs N${NC}     - Show last N lines of logs
  ${GREEN}backup${NC}     - Backup the database
  ${GREEN}clean${NC}      - Remove all containers, images, and volumes
  ${GREEN}help${NC}       - Show this help message

${BLUE}Examples:${NC}
  $0 deploy          # Deploy the application
  $0 restart         # Restart the application
  $0 logs 200        # Show last 200 lines of logs
"
}

case "$1" in
    deploy)
        deploy
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    rebuild)
        rebuild
        ;;
    status)
        check_docker
        show_status
        ;;
    logs)
        show_logs "$2"
        ;;
    backup)
        backup_db
        ;;
    clean)
        clean
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        log_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
