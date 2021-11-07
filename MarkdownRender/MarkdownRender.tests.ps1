
Import-Module "$PSScriptRoot\MarkdownRender.psd1"

InModuleScope -ModuleName MarkdownRender {
    Describe -Name "MarkdownRender" -Fixture {
        $MarkdownText = @"
# Header

## Sub-header

This is the first paragraph.
"@
        $MarkdownText | Out-File -FilePath "TestDrive:\Test1.md" -Encoding UTF8
        Context "Environment" {
            It "Test drive & Test file" {
                "TestDrive:\Test1.md" | Should -Exist
                "TestDrive:\Test1.md" | Should -FileContentMatch '# Header'
            }
        }
        Context "Converter" {
            It "Match header" {
                (ConvertFrom-Markdown -Path "TestDrive:\Test1.md").Html | Should -Match '<h1 id="header">Header</h1>'
            }
        }
    }
}