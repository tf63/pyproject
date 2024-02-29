# syntax=docker/dockerfile:1
FROM python:3.10.13

# ワークディレクトリの指定
WORKDIR /app

# 非インタラクティブモードにする (入力待ちでブロックしなくなる)
ENV DEBIAN_FRONTEND=noninteractive
# .pycを作らないように
ENV PYTHONDONTWRITEBYTECODE 1
# バッファの無効化
ENV PYTHONUNBUFFERED 1
# torchvisionでpretrainedのモデルを保存する場所
ENV TORCH_HOME /app/.cache

# ----------------------------------------------------------------
# setup (root) 
# ----------------------------------------------------------------
RUN apt update && \
    apt install -y bash \
    build-essential \
    git \
    git-lfs \
    curl \
    ca-certificates \
    libsndfile1-dev \
    libgl1 && \
    rm -rf /var/lib/apt/lists

# ----------------------------------------------------------------
# create user
# ----------------------------------------------------------------
# UIDとGIDは外から与える
ARG USER_UID
ARG USER_GID

# コンテナ内でのユーザー名， グループ名
ARG USER_NAME=user
ARG GROUP_NAME=user

# グループが存在しなかったら，　適当なグループを作成
RUN if ! getent group $USER_GID >/dev/null; then \
    groupadd -g $USER_GID $GROUP_NAME; \
    fi

# ユーザーを作成
RUN useradd -m -u $USER_UID -g $USER_GID -s /bin/bash $USER_NAME

# 初期ユーザーの変更
USER $USER_NAME

ENV PATH $PATH:/home/$USER_NAME/.local/bin

# ----------------------------------------------------------------
# setup (user) 
# ----------------------------------------------------------------

# poetryのインストール
RUN curl -sSL https://install.python-poetry.org | python3 -

# Poetryのパスを通す
ENV PATH /home/user/.local/bin:$PATH

# vscodeが仮想環境を読み込むようにする
RUN poetry config virtualenvs.in-project true


# pre-install the heavy dependencies (these can later be overridden by the deps from setup.py)
# RUN python3 -m pip install --no-cache-dir --upgrade pip && \
#     python3 -m pip install --no-cache-dir \
#     torch \
#     torchvision \
#     torchaudio \
#     invisible_watermark && \
#     python3 -m pip install --no-cache-dir \
#     accelerate \
#     datasets \
#     hf-doc-builder \
#     huggingface-hub \
#     Jinja2 \
#     librosa \
#     numpy \
#     scipy \
#     tensorboard \
#     transformers \
#     omegaconf \
#     pytorch-lightning \
#     xformers


ENTRYPOINT /bin/bash