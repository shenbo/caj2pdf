# caj2pdf: 将知网caj文件转换为pdf
> https://github.com/caj2pdf/caj2pdf/

- 官方的帮助文档并不友好，增加一些说明。
- 增加了拖拽caj文件自动转换的脚本
- 增加了右键菜单快捷命令

## 使用
### 1. 环境和依赖（win10）

- Python 3.3+
- PyPDF2, https://github.com/mstamy2/PyPDF2
  - pypi安装： https://pypi.org/project/PyPDF2/
  ``` bash
  pip install PyPDF2
  ```
- mutool, https://mupdf.com/index.html
  - 可以用 scoop 安装: `scoop install mupdf`
  - 实际上不用安装，只把 `mutool.exe` 文件放进 `caj2pdf/` 目录就行


### 2. 官方用法
- 克隆仓库： `git clone https://github.com/caj2pdf/caj2pdf.git`
- 在`caj2pdf/` 目录下运行相应的命令：
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

上述官方命令行的方法实际使用起来比较烦，我这里写个 bat 脚本支持**拖拽文件实现格式转换**。

- 方法：

在`caj2pdf`目录下，新建一个文件：`caj2pdf_convert_by_drag.bat`，内容如下：

``` bash
:: 切换目录
cd /d %~dp0

:: 转换文件
python caj2pdf convert %*

:: 暂停, 方便看 error 或 log
pause
```
- 使用：

直接把 caj 论文文件拖到 bat 脚本文件上就可以了，生成的 pdf 文件与原 caj 文件的目录保持一致。


### 4. 右键菜单加入 caj2pdf（个人自用版）

编辑： `caj2pdf_add_to_context.reg` 中 python 与 caj2pdf 的路径。

``` powershell 
Windows Registry Editor Version 5.00
; -----------------------------------------------------------------------------
;  associate '.caj' files to be run with caj2pdf cmd
; -----------------------------------------------------------------------------

[HKEY_CURRENT_USER\Software\Classes\.caj]
@="zhiwang_file"

[HKEY_CURRENT_USER\Software\Classes\zhiwang_file]
@="Shell Script"

[HKEY_CURRENT_USER\Software\Classes\zhiwang_file\shell\caj2pdf\command]
@="\"C:\\Users\\bo\\scoop\\apps\\python310\\3.10.11\\python.exe\" "D:\\8.Repositories\\caj2pdf\\caj2pdf\" convert \"%1\""

```

运行 `caj2pdf_add_to_context.reg` 。


=== ↓ 官方 Readme  ↓ ===

## Why

[中国知网](http://cnki.net/)的某些文献（多为学位论文）仅提供其专有的 CAJ 格式下载，仅能使用知网提供的软件（如 [CAJViewer](http://cajviewer.cnki.net/) 等）打开，给文献的阅读和管理带来了不便（尤其是在非 Windows 系统上）。

若要将 CAJ 文件转换为 PDF 文件，可以使用 CAJViewer 的打印功能。但这样得到的 PDF 文件的内容为图片，无法进行文字的选择，且原文献的大纲列表也会丢失。本项目希望可以解决上述两问题。

## How far we've come

知网下载到的后缀为 `caj` 的文件内部结构其实分为两类：CAJ 格式和 HN 格式（受考察样本所限可能还有更多）。目前本项目支持 CAJ 格式文件的转换，HN 格式的转换未完善，并且需要建立两个新的共享库（除了Microsoft Windows：我们提供Microsoft Windows 32-bit/64-bit DLLs, Mac OS users can download from [extra libs build](https://github.com/caj2pdf/caj2pdf-extra-libs/releases/tag/BUILD-0.1), and `chmod +x ...`)，详情如下：

```
cc -Wall -fPIC --shared -o libjbigdec.so jbigdec.cc JBigDecode.cc
cc -Wall `pkg-config --cflags poppler` -fPIC -shared -o libjbig2codec.so decode_jbig2data.cc `pkg-config --libs poppler`
```

抑或和libpoppler 相比，还是取决于您是否更喜欢libjbig2dec一点，可以替换libpoppler：

```
cc -Wall -fPIC --shared -o libjbigdec.so jbigdec.cc JBigDecode.cc
cc -Wall `pkg-config --cflags jbig2dec` -fPIC -shared -o libjbig2codec.so decode_jbig2data_x.cc `pkg-config --libs jbig2dec`
```

**关于两种格式文件结构的分析进展和本项目的实现细节，请查阅[项目 Wiki](https://github.com/JeziL/caj2pdf/wiki)。**

## How to contribute

受测试样本数量所限，即使转换 CAJ 格式的文件也可能（或者说几乎一定）存在 Bug。如遇到这种情况，欢迎在 [Issue](https://github.com/JeziL/caj2pdf/issues) 中提出，**并提供可重现 Bug 的 caj 文件**——可以将样本文件上传到网盘等处<del>，也可直接提供知网链接</del>（作者已滚出校园网，提 issue 请提供可下载的 caj 文件）。

如果你对二进制文件分析、图像/文字压缩算法、逆向工程等领域中的一个或几个有所了解，欢迎帮助完善此项目。你可以从阅读[项目 Wiki](https://github.com/JeziL/caj2pdf/wiki) 开始，看看是否有可以发挥你特长的地方。**Pull requests are always welcome**.

## How to use

### 环境和依赖

- Python 3.3+
- [PyPDF2](https://github.com/mstamy2/PyPDF2)
- [mutool](https://mupdf.com/index.html)

除了Microsoft Windows：我们提供Microsoft Windows 32-bit/64-bit DLLs，HN 格式需要

- C/C++编译器
- libpoppler开发包，或libjbig2dec开发包

### 用法

```
# 打印文件基本信息（文件类型、页面数、大纲项目数）
caj2pdf show [input_file]

# 转换文件
caj2pdf convert [input_file] -o/--output [output_file]

# 从 CAJ 文件中提取大纲信息并添加至 PDF 文件
## 遇到不支持的文件类型或 Bug 时，可用 CAJViewer 打印 PDF 文件，并用这条命令为其添加大纲
caj2pdf outlines [input_file] -o/--output [pdf_file]
```

### 例

```
caj2pdf show test.caj
caj2pdf convert test.caj -o output.pdf
caj2pdf outlines test.caj -o printed.pdf
```

### 异常输出（IMPORTANT!!!）

尽管这个项目目前有不少同学关注到了，但它**仍然只支持部分 caj 文件的转换**，必须承认这完全不是一个对普通用户足够友好的成熟项目。具体支持哪些不支持哪些，在前文也已经说了，但似乎很多同学并没有注意到。所以**如果你遇到以下两种输出，本项目目前无法帮助到你**。与此相关的 issue 不再回复。

- `Unknown file type.`：未知文件类型；

## License

本项目基于 [GLWTPL](https://github.com/me-shaon/GLWTPL)  (Good Luck With That Public License) 许可证开源。

