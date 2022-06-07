
# 官方的帮助文档并不友好，所以自己也写了一个说明，readme_v2
# 增加了拖拽caj文件自动转换的脚本

---
---

## caj2pdf：将知网caj文件转换为pdf

https://github.com/caj2pdf/caj2pdf/

## 使用
### 1. 环境和依赖（win10）

- Python 3.3+
- PyPDF2, https://github.com/mstamy2/PyPDF2
  - pypi安装： https://pypi.org/project/PyPDF2/
  ``` bash
  pip install PyPDF2<1.28 # 只支持1.28以下的版本
  ```
- mutool, https://mupdf.com/index.html
  - 实际上不用安装，只要把一个 `mutool.exe` 文件放进 `caj2pdf/` 目录就行了。
  - 也可以用 scoop 安装
  ``` bash
  scoop install mupdf 
  ```

### 2. 官方用法

<!-- more -->

- 克隆仓库： `git clone https://github.com/caj2pdf/caj2pdf.git`

- 在`caj2pdf/` 目录下运行。
``` bash
# 打印文件基本信息（文件类型、页面数、大纲项目数）
python caj2pdf show [input_file]

# 转换文件
# - 输出文件名可省略
python caj2pdf convert [input_file] -o/--output [output_file]

# 从 CAJ 文件中提取大纲信息并添加至 PDF 文件
# 遇到不支持的文件类型或 Bug 时，可用 CAJViewer 打印 PDF 文件，并用这条命令为其添加大纲
python caj2pdf outlines [input_file] -o/--output [pdf_file]
```

---

### 3. 拖拽caj文件自动转换（个人自用版）

上述官方命令行的方法实际使用起来比较烦，

我这里写个 bat 脚本支持**拖拽文件实现格式转换**。

- 方法：

在`caj2pdf`目录下，新建一个文件：`caj2pdf_convert_by_drag.bat`，内容如下：

``` bash
:: 切换目录
cd /d %~dp0

:: 转换文件
python caj2pdf convert %*

:: 暂停方便看error log
pause
```
- 使用：

直接把 caj 论文文件拖到 bat 脚本文件上就可以了，

生成的 pdf 文件与原 caj 文件的目录保持一致。


---
### PS

个人修改后的全部代码见：https://github.com/shenbo/caj2pdf
可直接下载使用。

---

### PS: 有坑 !!! 
- **官方的帮助文档并不友好**
- **只支持部分文件的转换，全凭运气**
