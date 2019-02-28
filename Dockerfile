# Example Dockerfile for setting up Docker container with MiniConda and an
# example app.

FROM ubuntu:18.04

# System packages 
RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list && \
    sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list
RUN apt-get update && apt-get install -y curl

# Install miniconda to /miniconda
RUN curl -LO https://mirrors.ustc.edu.cn/anaconda/miniconda/Miniconda2-latest-Linux-x86_64.sh
RUN bash Miniconda2-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda2-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/main/ && \
    conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/free/ && \
    conda config --remove channels defaults && conda update -y conda

# Python packages from conda
RUN conda install -y \
    scikit-image \
    flask \
    pillow

# Setup application
COPY imgsrv.py /
ENTRYPOINT ["/miniconda/bin/python", "/imgsrv.py"]
EXPOSE 8080
