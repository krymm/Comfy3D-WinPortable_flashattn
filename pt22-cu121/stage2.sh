#!/bin/bash
set -eux

gcs='git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules'

workdir=$(pwd)

export PYTHONPYCACHEPREFIX="$workdir"/pycache

export PATH="$PATH:$workdir/Comfy3D_WinPortable/python_embeded/Scripts"

ls -lahF

mkdir -p "$workdir"/Comfy3D_WinPortable

# Redirect HuggingFace-Hub model folder
export HF_HUB_CACHE="$workdir/Comfy3D_WinPortable/HuggingFaceHub"
mkdir -p "$HF_HUB_CACHE"

# ComfyUI main app
git clone https://github.com/comfyanonymous/ComfyUI.git \
    "$workdir"/Comfy3D_WinPortable/ComfyUI

cd "$workdir"/Comfy3D_WinPortable/ComfyUI
git reset --hard "v0.0.1"

# CUSTOM NODES
cd "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes

mv "$workdir"/ComfyUI-3D-Pack ./ComfyUI-3D-Pack

$gcs https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
$gcs https://github.com/kijai/ComfyUI-KJNodes.git
$gcs https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
$gcs https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git
$gcs https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git
$gcs https://github.com/WASasquatch/was-node-suite-comfyui.git

cd "$workdir"
mv  python_embeded  Comfy3D_WinPortable/python_embeded

# Copy & Replace start script files

cp -rf "$workdir"/attachments/* \
    "$workdir"/Comfy3D_WinPortable/

# Download Impact-Pack & Subpack & models
cd "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes
$gcs https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
cd ComfyUI-Impact-Pack
$gcs https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git impact_subpack
# Use its installer to download models
"$workdir"/Comfy3D_WinPortable/python_embeded/python.exe -s -B install.py

# Run test, also let custom nodes download some models
cd "$workdir"/Comfy3D_WinPortable
./python_embeded/python.exe -s -B ComfyUI/main.py --quick-test-for-ci --cpu

# Copy u2net model files needed by rembg (to avoid download at first start)
cd "$workdir"/Comfy3D_WinPortable
mkdir extras
cp ~/.u2net/u2net.onnx ./extras/u2net.onnx

# Copy example files of 3D-Pack
mv "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes/ComfyUI-3D-Pack/_Example_Workflows/_Example_Inputs_Files/* \
    "$workdir"/Comfy3D_WinPortable/ComfyUI/input/

# Clean up
cd "$workdir"/Comfy3D_WinPortable/ComfyUI/custom_nodes
rm ./was-node-suite-comfyui/was_suite_config.json
rm ./ComfyUI-Impact-Pack/impact-pack.ini

cd "$workdir"