# caj2pdf：将知网caj文件转换为pdf
> https://github.com/caj2pdf/caj2pdf/

- 官方的帮助文档并不友好，这里补充说明一下
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

:: 暂停,方便看 error log
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


---
### PS

个人修改后的全部代码见：https://github.com/shenbo/caj2pdf
可直接下载使用。

---

### PS: 有坑 !!! 
- **官方的帮助文档并不友好**
- **只支持部分文件的转换，全凭运气**