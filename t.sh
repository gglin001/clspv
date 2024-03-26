# NOTE: patchs are inspired by
# https://github.com/conda-forge/clspv-feedstock

# https://github.com/gglin001/Dockerfiles/tree/main/pocl
# micromamba install -y clangdev=18.1 llvmdev=18.1 clang-tools=18.1

CLANGD_VERSION=$(clangd --version | grep -Po '(?<=clangd version )[^.]+') &&
echo "CLANGD_VERSION: $CLANGD_VERSION"

cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PWD/build/install \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_INSTALL_RPATH=ON \
  -DSPIRV_HEADERS_SOURCE_DIR=/home/spirv-headers \
  -DSPIRV_TOOLS_SOURCE_DIR=/home/spirv-tools \
  -DCLSPV_BUILD_TESTS=OFF \
  -DEXTERNAL_LLVM=1 \
  -DCLSPV_LLVM_BINARY_DIR=/root/micromamba/envs/pyenv \
  -DCLSPV_LLVM_SOURCE_DIR=/root/micromamba/envs/pyenv \
  -DCLSPV_CLANG_SOURCE_DIR=/root/micromamba/envs/pyenv/lib/clang/$CLANGD_VERSION/include \
  -S $PWD -B $PWD/build -GNinja

cmake --build $PWD/build --target install

export LD_LIBRARY_PATH="$CONDA_PREFIX/lib:/opt/pocl/lib:${LD_LIBRARY_PATH}"

build/bin/clspv --help
build/bin/clspv-opt --help
build/bin/clspv-reflection --help

