# 心情日记系统 - 部署运维文档
# Mood Diary System - Deployment and Operations Documentation

---

## 📋 目录 | Table of Contents

1. [系统概述 | System Overview](#系统概述--system-overview)
2. [环境要求 | Environment Requirements](#环境要求--environment-requirements)
3. [快速部署 | Quick Deployment](#快速部署--quick-deployment)
4. [运维操作 | Operations](#运维操作--operations)
5. [目录结构 | Directory Structure](#目录结构--directory-structure)
6. [数据持久化 | Data Persistence](#数据持久化--data-persistence)
7. [故障排查 | Troubleshooting](#故障排查--troubleshooting)

---

## 📌 系统概述 | System Overview

### 中文
心情日记系统是基于 Python + Flask + SQLite 开发的个人心情记录应用。本部署方案采用 Docker 容器化部署，具备以下特性：
- 一键部署、重启、停止
- 异常自动重启（除非手动停止）
- 代码和数据挂载到宿主机
- 健康检查机制

### English
Mood Diary System is a personal mood recording application based on Python + Flask + SQLite. This deployment solution uses Docker containerization with the following features:
- One-click deploy, restart, stop
- Auto-restart on failure (unless manually stopped)
- Code and data mounted to host machine
- Health check mechanism

---

## 🔧 环境要求 | Environment Requirements

### 中文
| 软件 | 版本要求 |
|------|----------|
| Docker | >= 20.10 |
| Docker Compose | >= 2.0 |
| 操作系统 | Linux/macOS/Windows |
| 内存 | >= 512MB |

安装 Docker:
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com | bash

# macOS/Windows 请下载 Docker Desktop
```

### English
| Software | Version Required |
|----------|------------------|
| Docker | >= 20.10 |
| Docker Compose | >= 2.0 |
| Operating System | Linux/macOS/Windows |
| Memory | >= 512MB |

Install Docker:
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com | bash

# For macOS/Windows, download Docker Desktop
```

---

## 🚀 快速部署 | Quick Deployment

### 中文

#### 1. 克隆项目 | Clone Project
```bash
cd mooddiary
```

#### 2. 赋予脚本执行权限 | Grant Script Execution Permission
```bash
chmod +x deploy.sh
```

#### 3. 一键启动服务 | One-click Start Service
```bash
./deploy.sh start
```

#### 4. 访问应用 | Access Application
打开浏览器访问: `http://localhost:5000`

### English

#### 1. Enter Project Directory
```bash
cd mooddiary
```

#### 2. Grant Script Execution Permission
```bash
chmod +x deploy.sh
```

#### 3. One-click Start Service
```bash
./deploy.sh start
```

#### 4. Access Application
Open browser and visit: `http://localhost:5000`

---

## 🛠️ 运维操作 | Operations

### 中文

| 操作 | 命令 | 说明 |
|------|------|------|
| 启动/部署 | `./deploy.sh start` | 首次启动或日常启动，自动构建镜像 |
| 停止 | `./deploy.sh stop` | 停止运行中的容器 |
| 重启 | `./deploy.sh restart` | 重启正在运行的服务 |
| 查看日志 | `./deploy.sh logs` | 实时查看服务日志 |
| 查看状态 | `./deploy.sh status` | 查看服务运行状态和健康检查 |
| 更新服务 | `./deploy.sh update` | 重新构建镜像并启动（代码更新后使用）|
| 帮助 | `./deploy.sh help` | 显示帮助信息 |

#### 常用 Docker 命令补充
```bash
# 查看运行中的容器
docker ps

# 查看所有容器
docker ps -a

# 手动进入容器
docker exec -it mooddiary bash
```

### English

| Operation | Command | Description |
|-----------|---------|-------------|
| Start/Deploy | `./deploy.sh start` | First start or regular start, auto build image |
| Stop | `./deploy.sh stop` | Stop running container |
| Restart | `./deploy.sh restart` | Restart running service |
| View Logs | `./deploy.sh logs` | Real-time view service logs |
| Check Status | `./deploy.sh status` | Check service status and health check |
| Update Service | `./deploy.sh update` | Rebuild image and start (use after code update) |
| Help | `./deploy.sh help` | Show help information |

#### Useful Docker Commands
```bash
# List running containers
docker ps

# List all containers
docker ps -a

# Enter container manually
docker exec -it mooddiary bash
```

---

## 📁 目录结构 | Directory Structure

### 中文
```
mooddiary/
├── app.py                    # 应用主程序
├── requirements.txt          # Python依赖
├── Dockerfile                # Docker构建文件
├── docker-compose.yml        # Docker编排配置
├── deploy.sh                 # 一键部署脚本
├── README-DEPLOY.md          # 本文档
├── templates/                # 模板目录（挂载）
├── static/                   # 静态资源目录（挂载）
└── instance/                 # 数据目录（挂载）
    └── mooddiary.db          # SQLite数据库文件
```

### English
```
mooddiary/
├── app.py                    # Main application
├── requirements.txt          # Python dependencies
├── Dockerfile                # Docker build file
├── docker-compose.yml        # Docker compose configuration
├── deploy.sh                 # One-click deploy script
├── README-DEPLOY.md          # This document
├── templates/                # Template directory (mounted)
├── static/                   # Static assets directory (mounted)
└── instance/                 # Data directory (mounted)
    └── mooddiary.db          # SQLite database file
```

---

## 💾 数据持久化 | Data Persistence

### 中文

所有重要数据都已挂载到宿主机，删除容器不会丢失数据：

| 挂载路径 | 说明 |
|----------|------|
| `./app.py` | 应用主程序，修改后重启生效 |
| `./templates/` | 模板文件，修改后立即生效 |
| `./static/` | 静态资源，修改后立即生效 |
| `./instance/` | SQLite数据库目录，**重要数据请定期备份** |

#### 数据库备份
```bash
# 备份数据库
cp instance/mooddiary.db instance/mooddiary.db.backup.$(date +%Y%m%d)

# 恢复数据库
cp instance/mooddiary.db.backup instance/mooddiary.db
./deploy.sh restart
```

### English

All critical data is mounted to the host machine, deleting container will not lose data:

| Mount Path | Description |
|------------|-------------|
| `./app.py` | Main application, restart after modification |
| `./templates/` | Template files, effective immediately after modification |
| `./static/` | Static assets, effective immediately after modification |
| `./instance/` | SQLite database directory, **important data please backup regularly** |

#### Database Backup
```bash
# Backup database
cp instance/mooddiary.db instance/mooddiary.db.backup.$(date +%Y%m%d)

# Restore database
cp instance/mooddiary.db.backup instance/mooddiary.db
./deploy.sh restart
```

---

## 🔄 自动重启机制 | Auto Restart Mechanism

### 中文

容器配置了 `restart: unless-stopped` 策略：
- ✅ 应用崩溃时自动重启
- ✅ 服务器重启后自动启动
- ✅ Docker 服务重启后自动恢复
- ❌ 只有执行 `./deploy.sh stop` 才会停止

### English

Container configured with `restart: unless-stopped` policy:
- ✅ Auto restart on application crash
- ✅ Auto start after server reboot
- ✅ Auto recover after Docker service restart
- ❌ Only stops when executing `./deploy.sh stop`

---

## ❗ 故障排查 | Troubleshooting

### 中文

#### 1. 服务无法启动
```bash
# 查看详细错误日志
./deploy.sh logs

# 检查端口是否被占用
netstat -tlnp | grep 5000
# 或修改 docker-compose.yml 中的端口映射
```

#### 2. 容器不断重启
```bash
# 查看健康检查状态
./deploy.sh status

# 检查依赖是否完整
pip install -r requirements.txt
```

#### 3. 数据库权限问题
```bash
# 修复数据目录权限
chmod -R 755 instance/
```

### English

#### 1. Service Cannot Start
```bash
# View detailed error logs
./deploy.sh logs

# Check if port is occupied
netstat -tlnp | grep 5000
# Or modify port mapping in docker-compose.yml
```

#### 2. Container Keeps Restarting
```bash
# Check health status
./deploy.sh status

# Check dependencies
pip install -r requirements.txt
```

#### 3. Database Permission Issues
```bash
# Fix data directory permissions
chmod -R 755 instance/
```

---

## 📞 技术支持 | Technical Support

### 中文
如遇到问题，请：
1. 查看本文档的故障排查章节
2. 检查 `./deploy.sh logs` 输出
3. 确保 Docker 和 Docker Compose 版本符合要求

### English
If you encounter issues, please:
1. Check the Troubleshooting section in this document
2. Check `./deploy.sh logs` output
3. Ensure Docker and Docker Compose versions meet requirements
