#!/bin/sh

FASTDFS_BASE_PATH=/data/fastdfs_data
FASTDFS_STORE_PATH=/data/fastdfs/upload
FASTDFS_TRACKER_CONF_PATH=/etc/fdfs/tracker.conf
FASTDFS_STORAGE_CONF_PATH=/etc/fdfs/storage.conf


if [ ! -d "$FASTDFS_BASE_PATH" ];  then
	 mkdir -p ${FASTDFS_BASE_PATH};
fi	 

###############################################
# 启动 Tracker 服务
# 
###############################################
function start_tracker(){
  /usr/bin/fdfs_trackerd ${FASTDFS_TRACKER_CONF_PATH}
  tail -f ${FASTDFS_BASE_PATH}/logs/trackerd.log
}

###############################################
# 启动 Storage 服务
# 
###############################################
function start_storage(){
  if [ ! -d "$FASTDFS_STORE_PATH" ]; then
	     mkdir -p ${FASTDFS_STORE_PATH}/{path0,path1,path2,path3};
  fi     
  /usr/bin/fdfs_storaged ${FASTDFS_STORAGE_CONF_PATH}
  sleep 5

  # nginx日志存储目录为/data/fastdfs_data/logs/，手动创建一下，防止storage启动慢，还没有来得及创建logs目录
  if [ ! -d "$FASTDFS_BASE_PATH/logs" ];  then
	 mkdir -p ${FASTDFS_BASE_PATH}/logs;
  fi
  
  # 启动Nginx
  /usr/local/nginx/sbin/nginx;

  tail -f ${FASTDFS_BASE_PATH}/logs/storaged.log;
}

###############################################
# 帮助说明
###############################################
function  usage() {
  echo "Usage: $θ <option>"
  echo "Options:"
  echo "  tracker     - 启动 Tracker 服务"
  echo "  storage     - 启动 Storage 服务"
  exit 1
}


###############################################
# 主函数
# 
# 参数：
#    start_parameter: 启用参数
#            - tracker : 启动 tracker 服务
#            - storage : 启动 storage 服务
###############################################
function main (){
  local start_parameter=$1
  
  case ${start_parameter} in
    tracker)
      echo ">>> 启动tracker"
      start_tracker
      ;;
    storage)
      echo ">>> 启动storage"
      start_storage
      ;;
    *)
      usage
      ;;
  esac
}

main $@
