@REM 务必根据你的 GPU 型号配置！
set TORCH_CUDA_ARCH_LIST=6.1+PTX

@REM 如需配置 HuggingFace Access Token（访问令牌），取消注释并编辑。
@REM 管理令牌： https://huggingface.co/settings/tokens
rem set HF_TOKEN=

@REM 如将 CUDA Toolkit 安装到其他路径，注意修改
set CUDA_HOME=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.4

@REM 如需配置代理，取消注释（移除行首的 'rem '）并编辑下两行环境变量。
rem set HTTP_PROXY=http://localhost:1081
rem set HTTPS_PROXY=http://localhost:1081

@REM 如需启用 HF Hub 实验性高速传输，取消该行注释。仅在千兆比特以上网速有意义。
@REM https://huggingface.co/docs/huggingface_hub/hf_transfer
rem set HF_HUB_ENABLE_HF_TRANSFER=1

@REM ===========================================================================
@REM 该部分设置一般无需更改

@REM 该环境变量配置 PIP 使用国内镜像站点。
set PIP_INDEX_URL=https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

@REM 该环境变量配置 HuggingFace Hub 使用国内镜像站点。
set HF_ENDPOINT=https://hf-mirror.com

@REM 该环境变量指示 HuggingFace Hub 下载模型到"本目录\HuggingFaceHub"，而不是"用户\.cache"目录。
set HF_HUB_CACHE=%~dp0\HuggingFaceHub

@REM 该环境变量指示 Pytorch Hub 下载模型到"本目录\TorchHome"，而不是"用户\.cache"目录。
set TORCH_HOME=%~dp0\TorchHome

@REM 该命令配置 PATH 环境变量。
set PATH=%PATH%;%~dp0\python_standalone\Scripts
set PATH=%PATH%;%CUDA_HOME%\bin

@REM 该命令配置 NVRTC 会用到的头文件，影响 cumm - spconv - TRELLIS
@REM SpConv 会对没有预编译的 GPU 架构进行运行时编译
@REM 参考： https://github.com/traveller59/spconv#prebuilt-gpu-support-matrix
@REM 来源： https://github.com/traveller59/spconv/blob/master/docs/PURE_CPP_BUILD.md
set CUMM_INCLUDE_PATH=%~dp0\python_standalone\Lib\site-packages\cumm\include

@REM 该环境变量使 .pyc 缓存文件集中保存在一个文件夹下，而不是随 .py 文件分布。
set PYTHONPYCACHEPREFIX=%~dp0\pycache

@REM ===========================================================================

@REM 如不希望 ComfyUI 启动后自动打开浏览器，添加 --disable-auto-launch 到下行末尾（注意空格）。
@REM 如在用 40 系显卡，可添加 --fast 开启实验性高性能模式。
.\python_standalone\python.exe -s ComfyUI\main.py --windows-standalone-build

pause
