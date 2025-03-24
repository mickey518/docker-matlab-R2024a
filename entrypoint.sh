#!/bin/bash
# entrypoint.sh

# 根据 CMD 参数启动 MATLAB
if [ "$1" = "-desktop" ]; then
    /usr/local/MATLAB/R2024a/bin/matlab -desktop
elif [ "$1" = "-nodesktop" ]; then
    /usr/local/MATLAB/R2024a/bin/matlab -nodesktop -nosplash
elif [ "$1" = "-mjs" ]; then
    /usr/local/MATLAB/R2024a/bin/service ssh start && /usr/local/MATLAB/R2024a/toolbox/parallel/bin/startmjs
else
    # 默认启动 bash，允许调试
    /bin/bash
fi
