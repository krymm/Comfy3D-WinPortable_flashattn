#!/bin/bash
set -eux

# Chores
git config --global core.autocrlf true
gcs='git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules'
workdir=$(pwd)
pip_exe="${workdir}/python_embeded/python.exe -s -m pip"
export PYTHONPYCACHEPREFIX="${workdir}/pycache"
export PATH="$PATH:$workdir/Comfy3D_WinPortable/python_embeded/Scripts"
export PIP_NO_WARN_SCRIPT_LOCATION=0

ls -lahF

# Download Python embeded
cd "$workdir"
curl -sSL https://github.com/adang1345/PythonWindows/raw/refs/heads/master/3.10.16/python-3.10.16-embed-amd64.zip \
    -o python_embeded.zip
unzip -q python_embeded.zip -d "$workdir"/python_embeded

# Download 3D-Pack
# Note: zip archive doesn't contain the ".git" folder, it's not upgradable.
cd "$workdir"
curl -sSL https://github.com/MrForExample/ComfyUI-3D-Pack/archive/bdc5e3029ed96d9fa25e651e12fce1553a4422c4.zip \
    -o ComfyUI-3D-Pack-bdc5e3029ed96d9fa25e651e12fce1553a4422c4.zip
unzip -q ComfyUI-3D-Pack-bdc5e3029ed96d9fa25e651e12fce1553a4422c4.zip
mv ComfyUI-3D-Pack-bdc5e3029ed96d9fa25e651e12fce1553a4422c4 ComfyUI-3D-Pack
rm ComfyUI-3D-Pack-bdc5e3029ed96d9fa25e651e12fce1553a4422c4.zip

cd "$workdir"
curl -sSL https://github.com/MrForExample/Comfy3D_Pre_Builds/archive/d11afaad1944278712f13865f0bb902a5fd9c745.zip \
    -o Comfy3D_Pre_Builds-d11afaad1944278712f13865f0bb902a5fd9c745.zip
unzip -q Comfy3D_Pre_Builds-d11afaad1944278712f13865f0bb902a5fd9c745.zip
mv Comfy3D_Pre_Builds-d11afaad1944278712f13865f0bb902a5fd9c745 Comfy3D_Pre_Builds
rm Comfy3D_Pre_Builds-d11afaad1944278712f13865f0bb902a5fd9c745.zip

# Header files for ComfyUI-3D-Pack
# Do this firstly (in a clean python_embeded folder)
mv \
    "$workdir"/Comfy3D_Pre_Builds/_Python_Source_cpp/py310/include \
    "$workdir"/python_embeded/include

mv \
    "$workdir"/Comfy3D_Pre_Builds/_Python_Source_cpp/py310/libs \
    "$workdir"/python_embeded/libs

# Setup PIP
cd "$workdir"/python_embeded
sed -i 's/^#import site/import site/' ./python310._pth
curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
./python.exe get-pip.py

# PIP installs
$pip_exe install --upgrade pip wheel setuptools

$pip_exe install -r "$workdir"/requirements2.txt
$pip_exe install -r "$workdir"/requirements3.txt
$pip_exe install -r "$workdir"/requirements4.txt
$pip_exe install -r "$workdir"/requirements5.txt
$pip_exe install -r "$workdir"/requirements6.txt

# From: https://github.com/rusty1s/pytorch_scatter?tab=readme-ov-file#binaries
$pip_exe install torch-scatter -f https://data.pyg.org/whl/torch-2.3.1%2Bcu121.html

$pip_exe install -r "$workdir"/requirements9.txt

# Add Ninja binary (replacing PIP Ninja)
## The 'python_embeded\Scripts\ninja.exe' is not working,
## because most .exe files in 'python_embeded\Scripts' are wrappers 
## that looking for 'C:\Absolute\Path\python.exe', which is not portable.
## So here we use the actual binary of Ninja.
## Whatsmore, if the end-user re-install/upgrade the PIP Ninja,
## the path problem will be fixed automatically.
curl -sSL https://github.com/ninja-build/ninja/releases/latest/download/ninja-win.zip \
    -o ninja-win.zip
unzip -q -o ninja-win.zip -d "$workdir"/python_embeded/Scripts
rm ninja-win.zip

# Add aria2 binary
curl -sSL https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0-win-64bit-build1.zip \
    -o aria2.zip
unzip -q aria2.zip -d "$workdir"/aria2
mv "$workdir"/aria2/*/aria2c.exe  "$workdir"/python_embeded/Scripts/
rm aria2.zip

# Setup Python embeded, part 3/3
cd "$workdir"/python_embeded
sed -i '1i../ComfyUI' ./python310._pth

$pip_exe list

cd "$workdir"
