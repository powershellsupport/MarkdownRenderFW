[CmdletBinding()]
param ()

try {
    $env:PSModulePath += ";$PSScriptRoot\MarkdownRender"

    New-Item -Path "$PSScriptRoot\MarkdownRenderOut" -Force -ItemType Directory | Out-Null

    if ( $null -eq $(Get-PSRepository -Name MarkdownRender -ErrorAction SilentlyContinue) ) {
        Register-PSRepository -Name MarkdownRender -SourceLocation "$PSScriptRoot\MarkdownRenderOut"
    }

    Publish-Module -Name MarkdownRender -Repository MarkdownRender

} catch {
    Write-Error $_
}