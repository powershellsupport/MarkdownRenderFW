

Get-Module MarkdownRender | Remove-Module -Force -ErrorAction SilentlyContinue
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
        }

        It "Match sub-header" {
            $((ConvertFrom-Markdown -Path "TestDrive:\Test1.md").html) | Should -BeLike '*Sub-header*'
        }

        It "Match first paragraph" {
            $((ConvertFrom-Markdown -Path "TestDrive:\Test1.md").html) | Should -BeLike '*This is the first paragraph.*'
        }

        It "Return two objects" {
            ConvertFrom-Markdown -Path "TestDrive:\Test1.md","TestDrive:\Test1.md" | Should -HaveCount 2
        }
    }
    Context "Convert the README.md" {
        It "Match header" {
            $((ConvertFrom-Markdown -Path "$PSScriptRoot\README.md").Html) | Should -BeLike '*MarkdownRender*'
            $((ConvertFrom-Markdown -Path "$PSScriptRoot\README.md").Html) | Should -BeLike '<h1 id="markdownrender">MarkdownRender</h1>*'
        }
    }
    Context "Convert the README.md as text" {
        It "Match header" {
            #$((Get-item "$PSScriptRoot\README.md" | ConvertFrom-Markdown).Html) | Should -BeLike '*MarkdownRender*'
            $((Get-Content -Path "$PSScriptRoot\README.md" -Raw | ForEach-Object { ConvertFrom-Markdown -InputObject $_ }).Html) | Should -BeLike '<h1 id="markdownrender">MarkdownRender</h1>*'
        }
    }
    Context "Convert the README.md as file info" {
        It "Match header" {
            $((Get-item "$PSScriptRoot\README.md" | ConvertFrom-Markdown).Html) | Should -BeLike '*MarkdownRender*'
            #$((Get-Content -Path "$PSScriptRoot\README.md" -Raw | ForEach-Object { ConvertFrom-Markdown -InputObject $_ }).Html) | Should -BeLike '<h1 id="markdownrender">MarkdownRender</h1>*'
        }
    }
    Context "Convert as VT100" {
        It "Convert from bold text" {
            "**Bold text**" | ConvertFrom-Markdown -AsVT100EncodedString | Select-Object -exp Html | Should -BeLike '<b>Bold text</b>'
        }
    }
}
#}