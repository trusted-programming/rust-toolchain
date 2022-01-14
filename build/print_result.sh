#!/bin/bash

echo -e "#####################################结果展示#####################################\n\n\n"
# 打印未使用的依赖项
# ‘\047’代表单引号，在我们的例子中最后实际执行的是拼接命令awk 'NR>=381' workplace/cargo-udeps.txt 表示取文件中行号大于381开始的部分
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-deps：未使用的crate依赖项\n"
cat -n workplace/cargo-udeps.txt | grep "unused dependencies:" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-udeps.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n"

# 打印依赖树
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-tree：crates依赖关系树\n"
cat workplace/cargo-tree.txt
echo -e "-----------------------------------------------------------------------------\n"

# 程序画像结果
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-profiler：函数调用统计\n"
cat workplace/cargo-profiler-callgrind.txt
echo -e "cargo-profiler：cpu cache信息统计\n"
cat workplace/cargo-profiler-cachegrind.txt
echo -e "-----------------------------------------------------------------------------\n"

# 漏洞检测
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-audit：漏洞检测\n"
cat workplace/cargo-audit.txt
echo -e "-----------------------------------------------------------------------------\n"

# 统计unsafe代码片段信息
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-geiger：unsafe代码片段检测\n"
cat -n workplace/cargo-geiger.txt | grep "Metric" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-geiger.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n"

# 代码行数统计
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-tokei：代码行数统计\n"
cat workplace/cargo-tokei.txt
echo -e "-----------------------------------------------------------------------------\n"

# 代码行统计
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-count：代码行数统计\n"
#cargo count --separator , --unsafe-statistics
cat workplace/cargo-count.txt
echo -e "-----------------------------------------------------------------------------\n"

# 检查unwrap函数
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-strict：检查unwrap函数\n"
cat workplace/cargo-strict.txt
echo -e "-----------------------------------------------------------------------------\n"

# clippy lint检查
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-clippy：lints检查\n"
rm workplace/cargo-clippy-result.txt
grep "warn(clippy::" workplace/cargo-clippy.txt | awk -F"::" '{print $2}' | awk -F")" '{cmd= "c="$1"; a=\140grep \""$1"\" workplace/cargo-clippy.txt | wc -l\140; d=\042$c : $a\042; echo $d >> workplace/cargo-clippy-result.txt"; system(cmd)}'
grep "warnings emitted" workplace/cargo-clippy.txt
cat workplace/cargo-clippy-result.txt
#cat workplace/cargo-clippy.txt
echo -e "-----------------------------------------------------------------------------\n"

# dylint lint检查
#cargo install cargo-dylint dylint-link

# 检查crate在可执行文件的空间占用百分比
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-bloat： 可执行文件的空间占用百分比\n"
cat -n workplace/cargo-bloat-crates.txt | grep "File  .text" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-bloat-crates.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n"

# 检查各个函数在可执行文件的空间占用百分比
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-bloat： 可执行文件的空间占用百分比\n"
cat -n workplace/cargo-bloat-func.txt | grep "File  .text" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-bloat-func.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n"

# 计算泛型函数所有实例化中LLVM IR的行数
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-llvm-lines： 各函数LLVM IR的行数\n"
cat -n workplace/cargo-llvm-lines.txt | grep "Lines        Copies" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-llvm-lines.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n"

# 显示crates概述信息
# cargo-modules
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-modules： 依赖树信息\n"
cat -n workplace/cargo-modules-tree.txt | grep "rust_build_demo1" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-modules-tree.txt"; system(cmd)}'
echo -e "cargo-modules： 依赖图信息\n"
cat -n workplace/cargo-modules-graph.txt | grep "digraph" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-modules-graph.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n"

# 代码覆盖率检测
# cargo-tarpaulin
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-tarpaulin： 代码覆盖率\n"
cat -n workplace/cargo-tarpaulin.txt | grep "Coverage Results:" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-tarpaulin.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n"

# 打印汇编代码
# cargo-asm
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-asm： 汇编代码展示\n"
cat workplace/cargo-asm-asm.txt
cat workplace/cargo-asm-llvm.txt
echo -e "-----------------------------------------------------------------------------\n"

# 格式检查
# cargo fmt check
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo fmt -- --check： 格式检查结果\n"
cat workplace/cargo-fmt-check.txt
echo -e "-----------------------------------------------------------------------------\n"

# license信息展示
# cargo-license
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-license： license结果展示\n"
cat workplace/cargo-license.txt
echo -e "-----------------------------------------------------------------------------\n"

# 查看依赖crates是否有新的版本
# cargo-outdated
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-outdated： 查看依赖crates是否有新的版本结果展示\n"
cat -n workplace/cargo-outdated.txt | grep "Name" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-outdated.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n"

# 宏展开展示
# cargo-expand
echo -e "-----------------------------------------------------------------------------\n\n\n"
echo -e "cargo-expand： 宏展开结果展示\n"
cat workplace/cargo-expand.txt
echo -e "-----------------------------------------------------------------------------\n"

# cargo deny
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-deny： 源检查结果展示\n"
cat workplace/cargo-deny-sources.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-deny： 禁用crate结果展示\n"
cat workplace/cargo-deny-bans.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-deny： license禁用结果展示\n"
cat workplace/cargo-deny-license.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

# cargo-script
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-script： rust脚本执行结果展示\n"
cat workplace/cargo-script.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

# cargo-tomlfmt
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-tomlfmt： 配置检测结果展示\n"
cat workplace/cargo-tomlfmt.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

# cargo-mlc
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-mlc： 文档链接结果展示\n"
cat -n workplace/cargo-mlc.txt | grep "Result" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-mlc.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n\n\n"

# cargo-grcov.txt 2>&1
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-grcov： 代码覆盖率结果展示\n"
cat -n workplace/cargo-grcov.txt | grep "Overall coverage rate" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-grcov.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n\n\n"

# 测试结果
echo -e "-----------------------------------------------------------------------------\n"
echo -e "测试结果展示\n"
cat -n workplace/cargo-test.txt | grep "running" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-test.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n\n\n"

# sanitizer
echo -e "-----------------------------------------------------------------------------\n"
echo -e "sanitizer快速内存错误检测器:stack_buffer_overflow\n"
cat -n workplace/cargo-sanitizer_heap_buffer_overflow.txt | grep "============================" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-sanitizer_heap_buffer_overflow.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n\n\n"

echo -e "-----------------------------------------------------------------------------\n"
echo -e "sanitizer快速内存错误检测器:sanitizer_stack_use_after_scope\n"
cat -n workplace/cargo-sanitizer_stack_use_after_scope.txt | grep "============================" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-sanitizer_stack_use_after_scope.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n\n\n"

echo -e "-----------------------------------------------------------------------------\n"
echo -e "sanitizer快速内存错误检测器:sanitizer_use_of_uninitialized_value\n"
cat -n workplace/cargo-sanitizer_use_of_uninitialized_value.txt | grep "use-of-uninitialized-value" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-sanitizer_use_of_uninitialized_value.txt"; system(cmd)}'
#cat workplace/cargo-sanitizer_use_of_uninitialized_value.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

echo -e "-----------------------------------------------------------------------------\n"
echo -e "sanitizer快速内存错误检测器:sanitizer_data_race\n"
cat -n workplace/cargo-sanitizer_data_race.txt | grep "==================" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-sanitizer_data_race.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n\n\n"

# honggfuzz
echo -e "-----------------------------------------------------------------------------\n"
echo -e "honggfuzz模糊测试\n"
cat -n workplace/cargo-honggfuzz.txt | grep "Summary iterations" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-honggfuzz.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n\n\n"

# cargo-fuzz
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-fuzz模糊测试\n"
cat -n workplace/cargo-fuzz.txt | grep "Running" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-fuzz.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n\n\n"

# miri run
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo miri run 运行结果\n"
cat workplace/cargo-miri-run.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

# miri test
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo miri test 运行结果\n"
cat workplace/cargo-miri-test.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

# benchcmp
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-benchcmp benchmark结果对比\n"
cat workplace/cargo-benchcmp.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

# criterion stable benchmark
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo criterion.rs benchmark\n"
cat -n workplace/cargo-criterion.txt | grep "criterion benchmark" | awk '{cmd= "awk \047NR>="$1"\047 workplace/cargo-criterion.txt"; system(cmd)}'
echo -e "-----------------------------------------------------------------------------\n\n\n"

# rust-code-analysis
echo -e "-----------------------------------------------------------------------------\n"
echo -e "rust-code-analysis:代码度量\n"
tail -n 43 workplace/cargo-rust-code-analysis.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

# cargo-inspect
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-inspect:解开语法糖\n"
cat workplace/cargo-inspect.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

# cargo-spellcheck
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-spellcheck:检查拼写或语法错误\n"
cat workplace/cargo-spellcheck.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

# rust-semverver
echo -e "-----------------------------------------------------------------------------\n"
echo -e "rust-semverver:\n"
echo -e "-----------------------------------------------------------------------------\n\n\n"

# cargo-deadlinks
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-deadlinks:检查损坏的链接\n"
cat workplace/cargo-deadlinks.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

# cargo-build
echo -e "-----------------------------------------------------------------------------\n"
echo -e "cargo-build:构建结果查看\n"
cat workplace/cargo-build.txt
echo -e "-----------------------------------------------------------------------------\n\n\n"

# perf
echo -e "-----------------------------------------------------------------------------\n"
echo -e "perf:调试信息结果查看\n"
cat workplace/perf-report.txt

echo -e "#####################################结果展示 end#####################################\n\n\n"

