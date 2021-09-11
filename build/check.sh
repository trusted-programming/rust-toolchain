#!/bin/bash

echo -e "####################################依赖检查####################################\n\n\n"
echo -e "cargo-supply-chain:  crate发布者信息查询，执行慢，暂时关闭\n"
#cargo supply-chain update
#cargo supply-chain crates
#cargo supply-chain publishers
echo -e "\n\n\n"

echo -e "cargo-geiger:  统计项目使用到的crates的unsafe代码片段信息\n"
# 需要正确安装openssl
#cargo install --locked cargo-geiger
cargo geiger > workplace/cargo-geiger.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "cargo-tree:  跟踪和查询crates依存关系图\n"
cargo tree > workplace/cargo-tree.txt 2>&1
echo -e "\n\n\n"

echo -e "cargo-deps:  软件依赖图\n"
cargo deps --all-deps | dot -Tpng > workplace/cargo-deps.png || true
echo -e "\n\n\n"

echo -e "cargo-depgraph:  软件依赖图\n"
cargo depgraph --all-deps | dot -Tpng > workplace/cargo-depgraph.png || true
echo -e "\n\n\n"

echo -e "cargo-udeps:  检查Cargo.toml中未使用的依赖\n"
cargo +nightly udeps --all-targets > workplace/cargo-udeps.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "cargo-modules: 显示crates概述信息\n"
cargo modules generate tree --all-features --bin rust_build_demo1 > workplace/cargo-modules-tree.txt 2>&1
cargo modules generate graph --all-features --bin rust_build_demo1 | dot -Tpng > workplace/cargo-modules-graph.png
echo -e "\n\n\n"

echo -e "cargo-license:  license信息展示\n"
cargo license > workplace/cargo-license.txt 2>&1

echo -e "cargo-outdated:  cargo 依赖的crates是否有新版本\n"
cargo outdated > workplace/cargo-outdated.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "####################################依赖检查 end####################################\n\n\n"
echo -e "\n\n\n"

echo -e "####################################漏洞检查####################################\n\n\n"
# 拉取advisory-db有时候会失败
echo -e "cargo-audit: 从advisory-db搜索并打印项目依赖的crates的漏洞信息\n"
cargo audit --db /usr/local/src/rust/advisory-db --no-fetch > workplace/cargo-audit.txt 2>&1 || true
echo -e "\n\n\n"
echo -e "####################################漏洞检查 end####################################\n\n\n"

echo -e "####################################静态检查####################################\n\n\n"
echo -e "cargo fmt: 代码格式化检查\n"
cargo fmt -- --check > workplace/cargo-fmt-check.txt 2>&1 || true
# 代码格式化应该由开发者做
# cargo  fmt --all
echo -e "\n\n\n"

echo -e "cargo-clippy:  lints检查\n"
cargo clippy > workplace/cargo-clippy.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "cargo deny:  配置在deny.toml，根据配置禁用crate，包含crate源位置、license、漏洞\n"
cargo deny check sources > workplace/cargo-deny-sources.txt 2>&1 || true
cargo deny check bans > workplace/cargo-deny-bans.txt 2>&1 || true
cargo deny check license > workplace/cargo-deny-license.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "cargo-strict:  检查unwrap函数\n"
cargo strict > workplace/cargo-strict.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "cargo-deadlinks:  cargo doc中损坏的链接检查\n"
cargo deadlinks > workplace/cargo-deadlinks.txt 2>&1 || true
#cargo deadlinks --check-http
echo -e "\n\n\n"

echo -e "mlc:  检查损坏的链接\n"
mlc > workplace/cargo-mlc.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "cargo-spellcheck: 检查拼写或语法错误\n"
cargo spellcheck check > workplace/cargo-spellcheck.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "####################################静态检查 end####################################\n\n\n"

echo -e "####################################动态检查####################################\n\n\n"
echo -e "cargo-profiler：  给程序画像\n"
# 程序画像，根据函数调用和cache访问的信息，分析问题
# 只限于linux
cargo profiler callgrind > workplace/cargo-profiler-callgrind.txt 2>&1
cargo profiler cachegrind --release > workplace/cargo-profiler-cachegrind.txt 2>&1
echo -e "\n\n\n"

echo -e "cargo build: 构建\n"
cargo build > workplace/cargo-build.txt 2>&1
echo -e "\n\n\n"

echo -e "sanitizer快速内存错误检测器，能够检测unsafe部分\n"
# 编译并执行
# AddressSanitizer
# HWAddressSanitizer
export RUSTFLAGS=-Zsanitizer=address RUSTDOCFLAGS=-Zsanitizer=address
sanitizer_heap_buffer_overflow_before="//sanitizer_heap_buffer_overflow();"
sanitizer_heap_buffer_overflow_check="sanitizer_heap_buffer_overflow();"
sed -i "s:${sanitizer_heap_buffer_overflow_before}:${sanitizer_heap_buffer_overflow_check}:" src/main.rs
cargo +nightly run --target x86_64-unknown-linux-gnu > workplace/cargo-sanitizer_heap_buffer_overflow.txt 2>&1 || true
sed -i "s:${sanitizer_heap_buffer_overflow_check}:${sanitizer_heap_buffer_overflow_before}:" src/main.rs

export RUSTFLAGS=-Zsanitizer=address RUSTDOCFLAGS=-Zsanitizer=address
sanitizer_stack_use_after_scope_before="//sanitizer_stack_use_after_scope();"
sanitizer_stack_use_after_scope_check="sanitizer_stack_use_after_scope();"
sed -i "s:${sanitizer_stack_use_after_scope_before}:${sanitizer_stack_use_after_scope_check}:" src/main.rs
cargo +nightly run --target x86_64-unknown-linux-gnu > workplace/cargo-sanitizer_stack_use_after_scope.txt 2>&1 || true
sed -i "s:${sanitizer_stack_use_after_scope_check}:${sanitizer_stack_use_after_scope_before}:" src/main.rs

# LeakSanitizer待补充
export RUSTFLAGS='-Zsanitizer=leak'
export RUSTDOCFLAGS='-Zsanitizer=leak'


# MemorySanitizer
export RUSTFLAGS='-Zsanitizer=memory -Zsanitizer-memory-track-origins'
export RUSTDOCFLAGS='-Zsanitizer=memory -Zsanitizer-memory-track-origins'
sanitizer_use_of_uninitialized_value_before="//sanitizer_use_of_uninitialized_value();"
sanitizer_use_of_uninitialized_value_check="sanitizer_use_of_uninitialized_value();"
sed -i "s:${sanitizer_use_of_uninitialized_value_before}:${sanitizer_use_of_uninitialized_value_check}:" src/main.rs
cargo +nightly run --target x86_64-unknown-linux-gnu > workplace/cargo-sanitizer_use_of_uninitialized_value.txt 2>&1 || true
sed -i "s:${sanitizer_use_of_uninitialized_value_check}:${sanitizer_use_of_uninitialized_value_before}:" src/main.rs

# ThreadSanitizer
export RUSTFLAGS=-Zsanitizer=thread RUSTDOCFLAGS=-Zsanitizer=thread
sanitizer_data_race_before="//sanitizer_data_race();"
sanitizer_data_race_check="sanitizer_data_race();"
sed -i "s:${sanitizer_data_race_before}:${sanitizer_data_race_check}:" src/main.rs
cargo +nightly run -Zbuild-std --target x86_64-unknown-linux-gnu  > workplace/cargo-sanitizer_data_race.txt 2>&1 || true
sed -i "s:${sanitizer_data_race_check}:${sanitizer_data_race_before}:" src/main.rs

unset RUSTFLAGS RUSTDOCFLAGS
echo -e "\n\n\n"

echo -e "rust-semverver:  合规性检查\n"
#cargo +nightly-2021-07-23 semver
echo -e "\n\n\n"

echo -e "####################################动态检查 end####################################\n\n\n"

echo -e "####################################度量####################################\n\n\n"

echo -e "rust-code-analysis:  代码度量\n"
build_demo_path=`pwd`
# 支持的输出格式为 json toml cbor yaml
rust-code-analysis-cli -m -O yaml  -p ${build_demo_path}/src  > workplace/cargo-rust-code-analysis.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "tokei:  代码行数统计\n"
tokei > workplace/cargo-tokei.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "cargo-count:  代码行数统计\n"
cargo count --separator , --unsafe-statistics > workplace/cargo-count.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "####################################度量 end####################################\n\n\n"

echo -e "####################################测试####################################\n\n\n"
# 测试检查
echo -e "cargo-tarpaulin:  代码覆盖率检查\n"
# cargo-tarpaulin 只支持x86上的linux系统
cargo tarpaulin --all  --all-features > workplace/cargo-tarpaulin.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "cargo-kcov:  代码覆盖率检查kcov\n"
cargo kcov || true
echo -e "\n\n\n"

echo -e "grcov:  代码覆盖率\n"
# grcov
#cargo install grcov
# How to generate source-based coverage for a Rust project
# 需要重新使用nightly版编译
unset RUSTFLAGS RUSTDOCFLAGS
export RUSTFLAGS="-Zinstrument-coverage"
rustup default nightly
cargo build -q > /dev/null 2>&1
cargo test > /dev/null 2>&1
#cargo build
#export LLVM_PROFILE_FILE="your_name-%p-%m.profraw"
#cargo test
# How to generate .gcda files for a Rust project
#export CARGO_INCREMENTAL=0
#export RUSTFLAGS="-Zprofile -Ccodegen-units=1 -Copt-level=0 -Clink-dead-code -Coverflow-checks=off -Zpanic_abort_tests -Cpanic=abort"
#export RUSTDOCFLAGS="-Cpanic=abort"
#cargo build
#cargo test
# .gcda in target/debug/deps/ dir
#grcov . -s . --binary-path ./target/debug/ -t html --branch --ignore-not-existing -o ./target/debug/coverage/
# the report in target/debug/coverage/index.html
rm workplace/lcov.info
grcov . -s . --binary-path ./target/debug/ -t lcov --branch --ignore-not-existing -o workplace/lcov.info
genhtml -o ./target/debug/coverage/ --show-details --highlight --ignore-errors source --legend workplace/lcov.info > workplace/cargo-grcov.txt 2>&1 || true
# coveralls format
#grcov . --binary-path ./target/debug/ -t coveralls -s . --token YOUR_COVERALLS_TOKEN > coveralls.json
#rustc版本还原
rustup default stable
unset RUSTFLAGS RUSTDOCFLAGS
echo -e "\n\n\n"

# fuzz测试
echo -e "cargo-fuzz:  模糊测试\n"
cargo +nightly fuzz run build_demo > workplace/cargo-fuzz.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "honggfuzz模糊测试\n"
export HFUZZ_RUN_ARGS="-t 20 -n 12 -v -N 10000000 --exit_upon_crash"
cargo hfuzz run honggfuzz > workplace/cargo-honggfuzz.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "cargo-benchcmp:  性能检测结果对比\n"
cd benchcmp
cargo +nightly bench > 1.txt
# 运用修改
cargo +nightly bench > 2.txt
cargo benchcmp 1.txt 2.txt > ../workplace/cargo-benchcmp.txt 2>&1 || true
cd ..
echo -e "\n\n\n"

# mock测试，已添加代码，可直接使用cargo test执行
# 推荐mockall
# mockiato 官方从2019年尾已经不维护了，准备去掉

# criterion.rs 可以在stable rustc执行benchmark
echo -e "cargo test： 测试\n"
echo -e "criterion.rs benchmark性能测试\n"
unset RUSTFLAGS RUSTDOCFLAGS
cargo +stable bench > workplace/cargo-criterion.txt 2>&1 || true
echo -e "\n\n\n"

# 代码中已包含proptest和quickcheck
echo -e "cargo test： 测试\n"
echo -e "属性测试quickcheck\n"
echo -e "属性测试proptest，这个用例设计为会报错，影响tarpaulin等覆盖率工具，默认注释掉，需要尝试请打开注释\n"
cargo test > workplace/cargo-test.txt 2>&1 || true
echo -e "\n\n\n"
echo -e "####################################测试 end####################################\n\n\n"

echo -e "################################辅助开发和运维工具################################\n\n\n"
# 自动应用rustc建议的错误修复方式
# 使用方法请看官网文档
#cargo fix

echo -e "cargo-bloat:  检查crate或function占用可执行文件空间百分比\n"
# 检查各个crate在可执行文件的空间占用百分比
cargo bloat --release --crates > workplace/cargo-bloat-crates.txt 2>&1 || true
# 检查各个函数在可执行文件的空间占用百分比
cargo bloat --release -n 30 > workplace/cargo-bloat-func.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "cargo-llvm-lines:  计算泛型函数所有实例化中LLVM IR的行数\n"
cargo llvm-lines --bin rust_build_demo1 > workplace/cargo-llvm-lines.txt 2>&1 || true
echo -e "\n\n\n"

# 运行miri检测
unset RUSTFLAGS RUSTDOCFLAGS
cargo +nightly miri run > workplace/cargo-miri-run.txt 2>&1 || true
cargo +nightly miri test > workplace/cargo-miri-test.txt 2>&1 || true

echo -e "cargo-expand：  宏展开工具\n"
cargo expand --bin rust_build_demo1 > workplace/cargo-expand.txt 2>&1
echo -e "\n\n\n"

# 解开Rust语法糖，查看编译器对代码做了什么
# 2020年7月后无人工维护，实际测试中发现对2018版本的项目不能正确分析
# 需要使用nightly
#cargo install cargo-inspect
#cargo inspect ./src/toolsbox/toolinspect/toolinspect.rs > workplace/cargo-inspect.txt 2>&1

echo -e "cargo-update：  更新依赖的crate\n"
#cargo update
echo -e "\n\n\n"

echo -e "cargo-cache：  打印cargo cache信息\n"
#cargo cache
echo -e "\n\n\n"

echo -e "cargo-tomlfmt：  格式化Cargo.toml检测\n"
cargo tomlfmt > workplace/cargo-tomlfmt.txt 2>&1 || true
echo -e "\n\n\n"

echo -e "cargo-asm：  打印Rust代码的汇编或LLVM IR\n"
cargo asm rust_build_demo1::main --rust > workplace/cargo-asm-asm.txt 2>&1
cargo llvm-ir rust_build_demo1::main --rust > workplace/cargo-asm-llvm.txt 2>&1
echo -e "\n\n\n"

echo -e "cargo-do：  一行执行多个命令\n"
#cargo do clean, update, build
echo -e "\n\n\n"

echo -e "cargo-deb：  从cargo项目创建Debian packages\n"
#cargo deb
echo -e "\n\n\n"

echo -e "cargo-generate：  以已有的git项目作为模板创建一个crate\n"
#cargo generate --git https://github.com/HPCWorkspace/rust_build_demo.git -name rust_build_demo_test
echo -e "\n\n\n"

echo -e "cargo-multi：  一条命令操作多个crates\n"
#cargo multi update
#cargo multi build
#cargo multi test
echo -e "\n\n\n"

echo -e "cargo-release：  发布新版本\n"
# [level](https://github.com/sunng87/cargo-release/blob/master/docs/reference.md)
#cargo release [level]
echo -e "\n\n\n"

echo -e "cargo-rpm： 创建crate的rpm版本\n"
# 目前有问题待解决： error: rpmbuild error: error running rpmbuild: No such file or directory (os error 2)
#cargo rpm init
#cargo rpm build
echo -e "\n\n\n"

echo -e "cargo-script：  执行rs脚本\n"
cargo script ./src/toolsbox/cargo-script/helloworld.rs > workplace/cargo-script.txt 2>&1
echo -e "\n\n\n"

echo -e "rustdoc：  文档生成\n"
# 使用rustdoc
#cargo doc
echo -e "\n\n\n"

echo -e "cargo-bindgen：  根据.h头文件生成bingding文件\n"
#bindgen ./src/toolsbox/bindgen/input.h -o bindings.rs
echo -e "\n\n\n"
echo -e "################################辅助开发和运维工具 end################################\n\n\n"


