.PHONY: build install pack test help clean

define PRINT_HELP_PYSCRIPT
import re, sys
for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT
output_dir=output
project_dir := $(shell pwd)
help:
	@python3 -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

test: pack  ## 运行测试用例
	@cd $(project_dir)
	@ctest --test-dir $(project_dir)/build -C Release

pack: install ## 打包代码
	@cd $(project_dir)
	@$(project_dir)/scripts/pack.sh

install: build ## 安装打包文件到指定目录
	@cmake --build build \
		  --target install \
		  --config Release 

build: ## 编译代码
	cmake -B $(project_dir)/build \
		  -DCMAKE_BUILD_TYPE=Release \
		  -DCMAKE_INSTALL_PREFIX=$(output_dir) \
		  -DCMAKE_TOOLCHAIN_FILE=$(project_dir)/cmake/ToolChain.cmake;
	@cmake --build $(project_dir)/build --parallel

clean: ## 删除编译缓存
	rm -rf build $(output_dir)
