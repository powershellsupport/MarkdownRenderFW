# MarkdownRender

MarkdownRender is a hybrid solution, it is both a class library which can be used from .NET Framework projects, and a Windows PowerShell binary module - hidden inside a script module, meant to provide the `ConvertFrom-Markdown` function inside Windows PowerShell.

## MarkdownRender PowerShell module

This is a module for Windows PowerShell 5.1 meant to introduce support for `ConvertFrom-Markdown` which has been introduced with PowerShell 6.1.

`ConvertFrom-Markdown` does one thing, it converts Markdown to HTML, and returns a `MarkdownInfo` object with a `.html` property.

```powershell
# to access the HTML content use the .html property
$html = (ConvertFrom-Markdown -Path "C:\Temp\test.md").html
```