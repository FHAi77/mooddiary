# 心情日记系统 - 部署与运维指南
# Mood Diary System - Deployment & Operations Guide

---

## 目录 / Table of Contents

1. [系统概述 / System Overview](#系统概述--system-overview)
2. [环境要求 / Requirements](#环境要求--requirements)
3. [快速部署 / Quick Deployment](#快速部署--quick-deployment)
4. [运维操作 / Operations](#运维操作--operations)
5. [数据备份与恢复 / Backup & Restore](#数据备份与恢复--backup--restore)
6. [故障排查 / Troubleshooting](#故障排查--troubleshooting)
7. [目录结构 / Directory Structure](#目录结构--directory-structure)

---

## 系统概述 / System Overview

### 中文
心情日记系统是一个基于 Python + Flask + SQLite 开发的简洁版日记应用，用于记录个人每日心情及相关备注。系统支持日记的添加、查看、编辑、删除操作，可按日期范围查询日记，并能按周/月统计心情分布情况。

### English
The Mood Diary System is a lightweight diary application built with Python + Flask + SQLite, designed for recording daily moods and related notes. It supports adding, viewing, editing, and deleting diary entries, querying by date range, and generating weekly/monthly mood distribution statistics.

---

## 环境要求 / Requirements

### 中文
- **操作系统**: Linux / macOS / Windows (with WSL2)
- **Docker**: 20.10.0 或更高版本
- **Docker Compose**: 2.0.0 或更高版本
- **端口**: 5000 端口需要未被占用

### English
- **OS**: Linux / macOS / Windows (with WSL2)
- **Docker**: 20.10.0 or higher
- **Docker Compose**: 2.0.0 or higher
- **Port**: Port 5000 must be available

---

## 快速部署 / Quick Deployment

### 中文

#### 1. 进入项目目录
```bash
cd mooddiary
```

#### 2. 执行部署脚本
```bash
./deploy.sh deploy
```

部署完成后，访问 http://localhost:5000 即可使用。

### English

#### 1. Navigate to project directory
```bash
cd mooddiary
```

#### 2. Run deployment script
```bash
./deploy.sh deploy
```

After deployment, access the application at http://localhost:5000.

---

## 运维操作 / Operations

### 中文

#### 查看帮助
```bash
./deploy.sh help
```

#### 部署服务
```bash
./deploy.sh deploy
```
构建镜像并启动服务。

#### 重启服务
```bash
./deploy.sh restart
```

#### 停止服务
```bash
./deploy.sh stop
```

#### 查看状态
```bash
./deploy.sh status
```

#### 查看日志
```bash
./deploy.sh logs
```
按 `Ctrl+C` 退出日志查看。

### English

#### Show Help
```bash
./deploy.sh help
```

#### Deploy Service
```bash
./deploy.sh deploy
```
Build image and start services.

#### Restart Service
```bash
./deploy.sh restart
```

#### Stop Service
```bash
./deploy.sh stop
```

#### Check Status
```bash
./deploy.sh status
```

#### View Logs
```bash
./deploy.sh logs
```
Press `Ctrl+C` to exit log view.

---

## 数据备份与恢复 / Backup & Restore

### 中文

#### 数据存储位置
- SQLite 数据库文件: `./mooddiary.db`
- 数据挂载目录: `./data/`

#### 备份数据
```bash
# 停止服务
docker-compose down

# 备份数据库
cp mooddiary.db mooddiary.db.backup.$(date +%Y%m%d)

# 重新启动服务
docker-compose up -d
```

#### 恢复数据
```bash
# 停止服务
docker-compose down

# 恢复数据库
cp mooddiary.db.backup.YYYYMMDD mooddiary.db

# 重新启动服务
docker-compose up -d
```

### English

#### Data Storage Locations
- SQLite database file: `./mooddiary.db`
- Data mount directory: `./data/`

#### Backup Data
```bash
# Stop service
docker-compose down

# Backup database
cp mooddiary.db mooddiary.db.backup.$(date +%Y%m%d)

# Restart service
docker-compose up -d
```

#### Restore Data
```bash
# Stop service
docker-compose down

# Restore database
cp mooddiary.db.backup.YYYYMMDD mooddiary.db

# Restart service
docker-compose up -d
```

---

## 故障排查 / Troubleshooting

### 中文

#### 1. 端口被占用
**现象**: 部署时报错 `bind: address already in use`

**解决方法**:
```bash
# 查找占用 5000 端口的进程
lsof -i :5000

# 终止进程（将 <PID> 替换为实际进程号）
kill -9 <PID>
```

#### 2. 容器无法启动
**现象**: `docker-compose ps` 显示容器状态为 `Exit`

**解决方法**:
```bash
# 查看详细日志
docker-compose logs

# 检查数据库权限
ls -la mooddiary.db
```

#### 3. 数据库权限问题
**现象**: 应用无法写入数据

**解决方法**:
```bash
# 修复文件权限
chmod 666 mooddiary.db
chmod 755 data/
```

#### 4. Docker 服务未运行
**现象**: 命令报错 `Cannot connect to the Docker daemon`

**解决方法**:
```bash
# 启动 Docker 服务
sudo systemctl start docker

# 或 macOS/Windows 上启动 Docker Desktop
```

### English

#### 1. Port Already in Use
**Symptom**: Deployment error `bind: address already in use`

**Solution**:
```bash
# Find process using port 5000
lsof -i :5000

# Kill process (replace <PID> with actual process ID)
kill -9 <PID>
```

#### 2. Container Won't Start
**Symptom**: `docker-compose ps` shows container status as `Exit`

**Solution**:
```bash
# View detailed logs
docker-compose logs

# Check database permissions
ls -la mooddiary.db
```

#### 3. Database Permission Issues
**Symptom**: Application cannot write data

**Solution**:
```bash
# Fix file permissions
chmod 666 mooddiary.db
chmod 755 data/
```

#### 4. Docker Service Not Running
**Symptom**: Command error `Cannot connect to the Docker daemon`

**Solution**:
```bash
# Start Docker service
sudo systemctl start docker

# Or start Docker Desktop on macOS/Windows
```

---

## 目录结构 / Directory Structure

### 中文

```
mooddiary/
├── app.py                 # Flask 应用主文件
├── requirements.txt       # Python 依赖
├── Dockerfile            # Docker 镜像构建文件
├── docker-compose.yml    # Docker Compose 配置
├── deploy.sh             # 一键部署脚本
├── OPS_GUIDE.md          # 本运维文档
├── mooddiary.db          # SQLite 数据库（运行时生成）
├── data/                 # 数据挂载目录
├── static/               # 静态资源
│   └── css/
│       └── style.css
└── templates/            # HTML 模板
    ├── index.html
    └── form.html
```

### English

```
mooddiary/
├── app.py                 # Flask application main file
├── requirements.txt       # Python dependencies
├── Dockerfile            # Docker image build file
├── docker-compose.yml    # Docker Compose configuration
├── deploy.sh             # One-click deployment script
├── OPS_GUIDE.md          # This operations guide
├── mooddiary.db          # SQLite database (generated at runtime)
├── data/                 # Data mount directory
├── static/               # Static assets
│   └── css/
│       └── style.css
└── templates/            # HTML templates
    ├── index.html
    └── form.html
```

---

## 配置说明 / Configuration

### 中文

#### Docker Compose 配置说明

| 配置项 | 说明 |
|--------|------|
| `restart: unless-stopped` | 除非手动停止，否则异常停止后自动重启 |
| `volumes` | 挂载代码和数据库到宿主机，数据持久化 |
| `ports` | 映射容器 5000 端口到宿主机 5000 端口 |

### English

#### Docker Compose Configuration

| Configuration | Description |
|---------------|-------------|
| `restart: unless-stopped` | Auto-restart on failure unless manually stopped |
| `volumes` | Mount code and database to host for persistence |
| `ports` | Map container port 5000 to host port 5000 |

---

## 联系与支持 / Contact & Support

### 中文
如有问题，请查看日志或联系开发团队。

### English
For issues, please check logs or contact the development team.

---

*文档版本 / Document Version: 1.0*  
*最后更新 / Last Updated: 2026-04-21*
