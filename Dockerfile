####################################################################################################
#
# 第一阶段：安装 MATLAB
#
####################################################################################################
FROM ubuntu:22.04-x11 AS matlab-install

# 设置环境变量（避免安装过程中交互式时区选择）
ENV DEBIAN_FRONTEND=noninteractive
# 定义 MATLAB 根目录环境变量
ENV MATLAB_ROOT=/usr/local/MATLAB/R2024a

# 复制安装文件及许可证文件到安装准备目录
COPY ./tmp/ /tmp/
COPY ./tmp/license.lic ${MATLAB_ROOT}/license.lic

# 解压安装包到安装目录, 执行安装
RUN 7z x /tmp/R2024a_Linux.iso -o/matlab_install && \
    chmod -R 755 /matlab_install && \
    /matlab_install/install -mode silent -inputFile /tmp/installer_input.txt && \
    if ! [ -f ${MATLAB_ROOT}/bin/matlab ]; then \
        cat ${MATLAB_ROOT}/install.log \
        && echo "Installation failed and MATLAB was not installed. See the build log above for more information"; \
        exit 1; \
    fi && \
    cp ./tmp/libmwlmgrimpl.so ${MATLAB_ROOT}/bin/glnxa64/matlab_startup_plugins/lmgrimpl/libmwlmgrimpl.so && \
    rm -rf /tmp/* /matlab_install

####################################################################################################
#
# 第二阶段：创建 matlab 用户并设置权限
#
####################################################################################################
FROM ubuntu:22.04-x11

# 定义 MATLAB 根目录环境变量
ENV MATLAB_ROOT=/usr/local/MATLAB/R2024a \
    MATLAB_USER=matlabuser \
    MATLAB_GROUP=docker

# 数据卷
VOLUME /data

# 从第一阶段复制 MATLAB 安装文件
COPY --from=matlab-install ${MATLAB_ROOT} ${MATLAB_ROOT}

# 创建用户和组，动态指定 UID 和 GID
ARG HOST_UID=1000
ARG HOST_GID=998
RUN groupadd -g ${HOST_GID} ${MATLAB_GROUP} && \
    useradd -u ${HOST_UID} -g ${MATLAB_GROUP} -m -s /bin/bash ${MATLAB_USER} && \
    mkdir -p /data && \
    chown -R ${MATLAB_USER}:${MATLAB_GROUP} /data && \
    chmod -R 775 /data

# 配置 SSH（用于 MATLAB Parallel Server 集群通信）
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config

# 复制并配置 entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 切换到普通用户
USER ${MATLAB_USER}
WORKDIR /data

# 暴露集群通信端口
EXPOSE 2222 27370 27000-27100

# 设置启动 MATLAB GUI 的 entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["-desktop"]
