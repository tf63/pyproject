# python project

GPU環境用のpythonテンプレート

### 用法
イメージのビルド
```
    bash docker.sh build
```

コンテナの起動
```
    bash docker.sh shell
```

poetry周り
```
    poetry install # pyproject.tomlからインストール
    poetry add <パッケージ名> # パッケージをインストール
    poetry remove <パッケージ名> # パッケージを削除
```

### 備考

torchをpoetryで入れればワークディレクトリ配下の`.venv/`にtorchが入ってくれる

そうするとVSCodeにコンテナをアタッチしなくとも仮想環境が使える

しかし，ワークスペースごとにtorch (1.8GB)を入れる必要があるので注意

```
    poetry add https://download.pytorch.org/whl/cu117/torch-1.13.0%2Bcu117-cp38-cp38-linux_x86_64.whl
    poetry add https://download.pytorch.org/whl/cu117/torchvision-0.14.0%2Bcu117-cp38-cp38-linux_x86_64.whl
```

### 参考リンクなど

setuptools

https://packaging.python.org/en/latest/guides/distributing-packages-using-setuptools/

semantic version

https://semver.org/

formatter linter周り

https://data.gunosy.io/entry/linter_option_on_pyproject
