
Import-Module "$PSScriptRoot\MarkdownRender.psd1"

#InModuleScope -ModuleName MarkdownRender {
    Describe -Name "MarkdownRender" -Fixture {

        Context "Environment" {
            BeforeAll {
                $MarkdownText = @"
                # Header
                ## Sub-header
                This is the first paragraph.
"@
                $MarkdownText | Out-File -FilePath "TestDrive:\Test1.md" -Encoding UTF8
            }

            It "Test drive & Test file" {
                "TestDrive:\Test1.md" | Should -Exist
                "TestDrive:\Test1.md" | Should -FileContentMatch '# Header'
            }

            It "Match header" {
                $((ConvertFrom-Markdown -Path "TestDrive:\Test1.md").html) | Should -BeLike '*Header*'
                $((ConvertFrom-Markdown -Path "TestDrive:\Test1.md").html) | clip
            }
        }
        Context "Convert the README.md" {
            It "Match header" {
                $((ConvertFrom-Markdown -Path "$PSScriptRoot\README.md").Html) | Should -BeLike '*MarkdownRender*'
                $((ConvertFrom-Markdown -Path "$PSScriptRoot\README.md").Html) | Should -BeLike '<h1 id="markdownrender">MarkdownRender</h1>*'
            }
        }
    }
#}