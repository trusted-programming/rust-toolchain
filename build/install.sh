#!/bin/bash
# 测试项目: https://github.com/surechen/rust_build_demo/
echo -e "#####################################环境准备#####################################\n\n\n"
echo -e "安装rustup\n"
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo -e "更新rustup\n"
# rustup update nightly && rustup default nightly
echo -e "安装 rustc组件\n"
# rustup 代理
#export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
#export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
# rustc-dev，包含hir和ast解析相关的crate
# 安装rustfmt
# 安装clippy
rustup component add rustc-dev rust-src clippy rustfmt miri llvm-tools-preview
rm -rf workplace
rm -rf ../target/
mkdir workplace
unset RUSTFLAGS RUSTDOCFLAGS
echo -e "\n\n\n"
echo -e "#####################################环境准备 end#####################################\n\n\n"

echo -e "####################################安装依赖检查工具####################################\n\n\n"
echo -e "cargo-supply-chain:  crate发布者信息查询，执行慢，暂时关闭\n"
cargo install cargo-supply-chain
echo -e "\n\n\n"

echo -e "cargo-geiger:  统计项目使用到的crates的unsafe代码片段信息\n"
# 需要正确安装openssl
#cargo install --locked cargo-geiger
cargo install cargo-geiger --features vendored-openssl
echo -e "\n\n\n"

echo -e "cargo-tree:  跟踪和查询crates依存关系图\n"
cargo install cargo-tree
echo -e "\n\n\n"

echo -e "cargo-deps:  软件依赖图\n"
cargo install cargo-deps
sudo apt install graphviz
echo -e "\n\n\n"

echo -e "cargo-depgraph:  软件依赖图\n"
cargo install cargo-depgraph
echo -e "\n\n\n"

echo -e "cargo-udeps:  检查Cargo.toml中未使用的依赖\n"
cargo +stable install cargo-udeps --locked
echo -e "\n\n\n"

echo -e "cargo-modules: 显示crates概述信息\n"
# cargo-modules
cargo install cargo-modules1
echo -e "\n\n\n"

echo -e "cargo-license:  license信息展示\n"
cargo install cargo-license
echo -e "\n\n\n"

echo -e "cargo-outdated:  cargo 依赖的crates是否有新版本\n"
cargo install cargo-outdated || true
cargo outdated > workplace/cargo-outdated.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "####################################安装依赖检查工具 end####################################\n\n\n"
echo -e "\n\n\n"

echo -e "####################################安装漏洞检查工具####################################\n\n\n"
# 拉取advisory-db有时候会失败
echo -e "cargo-audit: 从advisory-db搜索并打印项目依赖的crates的漏洞信息\n"
cargo +stable install --locked cargo-audit  --features=fix || true
git clone https://github.com/rustsec/advisory-db
echo -e "\n\n\n"
echo -e "####################################安装漏洞检查工具 end####################################\n\n\n"

echo -e "####################################安装静态检查工具####################################\n\n\n"

echo -e "cargo deny:  配置在deny.toml，根据配置禁用crate，包含crate源位置、license、漏洞\n"
cargo install --locked cargo-deny
echo -e "\n\n\n"

echo -e "cargo-strict:  检查unwrap函数\n"
cargo install --git https://github.com/hhatto/cargo-strict.git || true
echo -e "\n\n\n"

echo -e "cargo-deadlinks:  cargo doc中损坏的链接检查\n"
cargo install cargo-deadlinks
echo -e "\n\n\n"

echo -e "mlc:  检查损坏的链接\n"
cargo install mlc
echo -e "\n\n\n"

echo -e "cargo-spellcheck: 检查拼写或语法错误\n"
cargo install cargo-spellcheck
echo -e "\n\n\n"

echo -e "####################################安装静态检查工具 end####################################\n\n\n"

echo -e "####################################安装动态检查工具####################################\n\n\n"
echo -e "cargo-profiler：  给程序画像\n"
# 程序画像，根据函数调用和cache访问的信息，分析问题
# 只限于linux
sudo apt-get install valgrind
cargo install cargo-profiler
echo -e "\n\n\n"

echo -e "rust-semverver:  合规性检查\n"
#rustup install nightly-2021-07-23
#rustup component add rustc-dev llvm-tools-preview --toolchain nightly-2021-07-23
#cargo +nightly-2021-07-23 install --git https://github.com/rust-lang/rust-semverver
echo -e "\n\n\n"

echo -e "####################################安装动态检查工具 end####################################\n\n\n"

echo -e "####################################安装度量工具####################################\n\n\n"

echo -e "rust-code-analysis:  代码度量\n"
git clone https://github.com/mozilla/rust-code-analysis && cd rust-code-analysis && cargo build --workspace && cd ..
echo -e "\n\n\n"

echo -e "tokei:  代码行数统计\n"
cargo install tokei
echo -e "\n\n\n"

echo -e "cargo-count:  代码行数统计\n"
git clone https://github.com/kbknapp/cargo-count && cd cargo-count && cargo build
cp ./target/debug/cargo-count /root/.cargo/bin/cargo-count && cd ..
echo -e "\n\n\n"

echo -e "####################################安装度量工具 end####################################\n\n\n"

echo -e "####################################安装测试工具####################################\n\n\n"
# 测试检查
echo -e "cargo-tarpaulin:  代码覆盖率检查\n"
# cargo-tarpaulin 只支持x86上的linux系统
cargo install cargo-tarpaulin
echo -e "\n\n\n"

echo -e "cargo-kcov:  代码覆盖率检查kcov\n"
cargo install cargo-kcov || true
sudo apt-get install cmake g++ pkg-config jq libssl-dev libcurl4-openssl-dev libelf-dev libdw-dev binutils-dev libiberty-dev || true
cargo kcov --print-install-kcov-sh | sh || true
echo -e "\n\n\n"

echo -e "grcov:  代码覆盖率\n"
# grcov
cargo install grcov
echo -e "\n\n\n"

# fuzzcheck模糊测试
# 维护者少，待观察
#cargo +nightly install cargo-fuzzcheck

# fuzz测试
echo -e "cargo-fuzz:  模糊测试\n"
cargo install cargo-fuzz
#cargo fuzz init
#cargo fuzz add build_demo
cargo +nightly fuzz run build_demo > workplace/cargo-fuzz.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "honggfuzz模糊测试\n"
apt install build-essential binutils-dev libunwind-dev libblocksruntime-dev liblzma-dev || true
cargo install honggfuzz || true
echo -e "\n\n\n"

echo -e "cargo-benchcmp:  性能检测结果对比\n"
cargo install cargo-benchcmp
echo -e "\n\n\n"

# mock测试，已添加代码，可直接使用cargo test执行
#mockall
#mockiato 官方从2019年尾已经不维护了，准备去掉

echo -e "####################################安装测试工具 end####################################\n\n\n"

echo -e "################################安装辅助开发和运维工具################################\n\n\n"

echo -e "cargo-bloat:  检查crate或function占用可执行文件空间百分比\n"
cargo install cargo-bloat
echo -e "\n\n\n"

echo -e "cargo-llvm-lines:  计算泛型函数所有实例化中LLVM IR的行数\n"
cargo install cargo-llvm-lines
echo -e "\n\n\n"

# 运行miri检测
echo -e "miri： 实验性mir解释器\n"
rustup +nightly component add miri
echo -e "\n\n\n"

echo -e "cargo-expand：  宏展开工具\n"
cargo install cargo-expand
echo -e "\n\n\n"

# 解开Rust语法糖，查看编译器对代码做了什么
# 2020年7月后无人工维护，实际测试中发现对2018版本的项目不能正确分析
# 需要使用nightly
#cargo install cargo-inspect
#cargo inspect ./src/toolsbox/toolinspect/toolinspect.rs > workplace/cargo-inspect.txt 2>&1

echo -e "cargo-update：  更新依赖的crate\n"
cargo install cargo-update
echo -e "\n\n\n"

echo -e "cargo-cache：  打印cargo cache信息\n"
cargo install cargo-cache
echo -e "\n\n\n"

echo -e "cargo-tomlfmt：  格式化Cargo.toml检测\n"
cargo install cargo-tomlfmt
echo -e "\n\n\n"

echo -e "cargo-asm：  打印Rust代码的汇编或LLVM IR\n"
cargo install cargo-asm
echo -e "\n\n\n"

echo -e "cargo-do：  一行执行多个命令\n"
cargo install cargo-do
echo -e "\n\n\n"

echo -e "cargo-deb：  从cargo项目创建Debian packages\n"
cargo install cargo-deb
echo -e "\n\n\n"

echo -e "cargo-generate：  以已有的git项目作为模板创建一个crate\n"
cargo install cargo-generate
echo -e "\n\n\n"

echo -e "cargo-multi：  一条命令操作多个crates\n"
cargo install cargo-multi
echo -e "\n\n\n"

echo -e "cargo-release：  发布新版本\n"
cargo install cargo-release
# [level](https://github.com/sunng87/cargo-release/blob/master/docs/reference.md)
echo -e "\n\n\n"

echo -e "cargo-rpm： 创建crate的rpm版本\n"
# 目前有问题： error: rpmbuild error: error running rpmbuild: No such file or directory (os error 2)
cargo install cargo-rpm
echo -e "\n\n\n"

echo -e "cargo-script：  执行rs脚本\n"
cargo install cargo-script
echo -e "\n\n\n"

echo -e "cargo-bindgen：  根据.h头文件生成bingding文件\n"
#cargo install bindgen
echo -e "\n\n\n"

echo -e "################################安装辅助开发和运维工具 end################################\n\n\n"


