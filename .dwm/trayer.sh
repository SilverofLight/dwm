#!/bin/bash

# 检查 trayer 是否在运行
if pgrep -x trayer > /dev/null; then
    # 如果在运行，就关闭它
    killall -9 trayer
else
    # 如果没有运行，就启动它
    trayer --align right \
           --transparent true \
           --tint 0xcba6f7&
fi
