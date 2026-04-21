# 心情日记系统部署与运维文档
# Mood Diary System Deployment and Operations Guide

---

## 目录 / Table of Contents

- [系统要求 / System Requirements](#系统要求--system-requirements)
- [快速开始 / Quick Start](#快速开始--quick-start)
- [部署操作 / Deployment Operations](#部署操作--deployment-operations)
- [运维管理 / Operations Management](#运维管理--operations-management)
- [故障排查 / Troubleshooting](#故障排查--troubleshooting)
- [文件说明 / File Description](#文件说明--file-description)

---

## 系统要求 / System Requirements

### 中文

- **操作系统**: Linux / macOS / Windows (支持 Docker)
- **Docker**: 版本 20.10 或更高
- **Docker Compose**: 版本 2.0 或更高
- **内存**: 至少 512MB 可用内存
- **磁盘空间**: 至少 1GB 可用空间
- **端口**: 5000 端口需可用

### English

- **Operating System**: Linux / macOS / Windows (with Docker support)
- **Docker**: Version 20.10 or higher
- **Docker Compose**: Version 2.0 or higher
- **Memory**: At least 512MB available memory
- **Disk Space**: At least 1GB available space
- **Port**: Port 5000 must be available

---

## 快速开始 / Quick Start

### 中文

1. **克隆或下载项目到本地**
   ```bash
   cd /path/to/mooddiary
   ```

2. **一键部署**
   ```bash
   ./deploy.sh deploy
   ```

3. **访问应用**
   
   打开浏览器访问: `http://localhost:5000`

### English

1. **Clone or download the project to local**
   ```bash
   cd /path/to/mooddiary
   ```

2. **One-click deployment**
   ```bash
   ./deploy.sh deploy
   ```

3. **Access the application**
   
   Open browser and visit: `http://localhost:5000`

---

## 部署操作 / Deployment Operations

### 中文

#### 一键部署
```bash
./deploy.sh deploy
```
此命令将完成以下操作:
- 检查 Docker 环境
- 创建必要的数据目录
- 构建 Docker 镜像
- 启动容器服务

#### 启动服务
```bash
./deploy.sh start
```

#### 停止服务
```bash
./deploy.sh stop
```

#### 重启服务
```bash
./deploy.sh restart
```

#### 重新构建部署
```bash
./deploy.sh rebuild
```
当更新代码后，使用此命令重新构建镜像并部署。

### English

#### One-click Deployment
```bash
./deploy.sh deploy
```
This command will:
- Check Docker environment
- Create necessary data directories
- Build Docker image
- Start container services

#### Start Service
```bash
./deploy.sh start
```

#### Stop Service
```bash
./deploy.sh stop
```

#### Restart Service
```bash
./deploy.sh restart
```

#### Rebuild and Deploy
```bash
./deploy.sh rebuild
```
Use this command to rebuild the image and redeploy after updating code.

---

## 运维管理 / Operations Management

### 中文

#### 查看服务状态
```bash
./deploy.sh status
```

#### 查看日志
```bash
# 查看最近100行日志
./deploy.sh logs

# 查看最近200行日志
./deploy.sh logs 200
```

#### 备份数据库
```bash
./deploy.sh backup
```
备份文件将保存在 `./backups/` 目录下。

#### 清理环境
```bash
./deploy.sh clean
```
此命令将删除所有容器、镜像和数据卷，请谨慎使用！

#### 查看帮助
```bash
./deploy.sh help
```

### English

#### Check Service Status
```bash
./deploy.sh status
```

#### View Logs
```bash
# View last 100 lines of logs
./deploy.sh logs

# View last 200 lines of logs
./deploy.sh logs 200
```

#### Backup Database
```bash
./deploy.sh backup
```
Backup files will be saved in `./backups/` directory.

#### Clean Environment
```bash
./deploy.sh clean
```
This command will remove all containers, images, and volumes. Use with caution!

#### View Help
```bash
./deploy.sh help
```

---

## 故障排查 / Troubleshooting

### 中文

#### 问题1: 端口被占用
**症状**: 启动失败，提示端口 5000 已被使用

**解决方案**:
```bash
# 查看占用端口的进程
lsof -i :5000

# 修改 docker-compose.yml 中的端口映射
ports:
  - "5001:5000"  # 将宿主机端口改为 5001
```

#### 问题2: 容器无法启动
**症状**: 容器启动后立即退出

**解决方案**:
```bash
# 查看容器日志
./deploy.sh logs

# 检查 Docker 环境
docker info
```

#### 问题3: 数据库权限问题
**症状**: 无法写入数据库

**解决方案**:
```bash
# 检查数据目录权限
ls -la ./data

# 修复权限
chmod -R 755 ./data
```

#### 问题4: 镜像构建失败
**症状**: 构建过程中报错

**解决方案**:
```bash
# 清理 Docker 缓存
docker system prune -a

# 重新构建
./deploy.sh rebuild
```

### English

#### Issue 1: Port Already in Use
**Symptom**: Startup fails, port 5000 is already in use

**Solution**:
```bash
# Check process using the port
lsof -i :5000

# Modify port mapping in docker-compose.yml
ports:
  - "5001:5000"  # Change host port to 5001
```

#### Issue 2: Container Won't Start
**Symptom**: Container exits immediately after starting

**Solution**:
```bash
# View container logs
./deploy.sh logs

# Check Docker environment
docker info
```

#### Issue 3: Database Permission Issues
**Symptom**: Cannot write to database

**Solution**:
```bash
# Check data directory permissions
ls -la ./data

# Fix permissions
chmod -R 755 ./data
```

#### Issue 4: Image Build Failure
**Symptom**: Error during build process

**Solution**:
```bash
# Clean Docker cache
docker system prune -a

# Rebuild
./deploy.sh rebuild
```

---

## 文件说明 / File Description

### 中文

| 文件名 | 说明 |
|--------|------|
| `Dockerfile` | Docker 镜像构建文件 |
| `docker-compose.yml` | Docker Compose 编排配置文件 |
| `deploy.sh` | 一键部署脚本 |
| `DEPLOYMENT.md` | 本部署文档 |

#### 目录挂载说明

| 容器路径 | 宿主机路径 | 说明 |
|----------|------------|------|
| `/app/app.py` | `./app.py` | 主程序文件（只读） |
| `/app/templates` | `./templates` | 模板目录（只读） |
| `/app/static` | `./static` | 静态资源目录（只读） |
| `/app/data` | `./data` | 数据存储目录（读写） |

### English

| File Name | Description |
|-----------|-------------|
| `Dockerfile` | Docker image build file |
| `docker-compose.yml` | Docker Compose orchestration configuration |
| `deploy.sh` | One-click deployment script |
| `DEPLOYMENT.md` | This deployment document |

#### Directory Mount Description

| Container Path | Host Path | Description |
|----------------|-----------|-------------|
| `/app/app.py` | `./app.py` | Main program file (read-only) |
| `/app/templates` | `./templates` | Templates directory (read-only) |
| `/app/static` | `./static` | Static resources directory (read-only) |
| `/app/data` | `./data` | Data storage directory (read-write) |

---

## 自动重启策略 / Auto Restart Policy

### 中文

Docker Compose 配置中设置了 `restart: unless-stopped` 策略，这意味着:

- **容器异常退出时**: 自动重启
- **Docker 服务重启时**: 自动启动容器
- **手动停止容器时**: 不会自动重启（除非再次手动启动）

### English

The Docker Compose configuration uses `restart: unless-stopped` policy, which means:

- **When container exits abnormally**: Auto restart
- **When Docker service restarts**: Auto start container
- **When manually stopped**: Will not auto restart (until manually started again)

---

## 健康检查 / Health Check

### 中文

系统配置了健康检查机制:
- **检查间隔**: 每 30 秒
- **超时时间**: 10 秒
- **重试次数**: 3 次
- **启动等待**: 10 秒

可通过以下命令查看健康状态:
```bash
docker ps
```

### English

The system has health check configured:
- **Check Interval**: Every 30 seconds
- **Timeout**: 10 seconds
- **Retries**: 3 times
- **Start Period**: 10 seconds

View health status with:
```bash
docker ps
```

---

## 日志管理 / Log Management

### 中文

日志配置:
- **最大文件大小**: 10MB
- **最大文件数量**: 3 个
- **日志位置**: Docker 默认日志目录

### English

Log configuration:
- **Max File Size**: 10MB
- **Max File Count**: 3 files
- **Log Location**: Docker default log directory

---

## 安全建议 / Security Recommendations

### 中文

1. 生产环境请修改 `app.py` 中的 `SECRET_KEY`
2. 建议配置 HTTPS 反向代理（如 Nginx）
3. 定期备份数据库
4. 限制服务器访问 IP

### English

1. Change `SECRET_KEY` in `app.py` for production environment
2. Configure HTTPS reverse proxy (e.g., Nginx)
3. Backup database regularly
4. Restrict server access by IP

---

## 联系支持 / Contact Support

### 中文

如有问题，请查看项目 README.md 或联系开发团队。

### English

For any issues, please refer to README.md or contact the development team.
