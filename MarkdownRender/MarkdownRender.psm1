function ConvertFrom-Markdown {
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="Path", ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path
    )

    begin {
    }

    process {
        foreach ($onePath in $Path) {
            $content = Get-Content -Path $onePath -Raw
            [MarkdownRender.MarkdownConverter]::Convert($content,[MarkdownRender.MarkdownConversionType]::HTML,[MarkdownRender.PSMarkdownOptionInfo]::new()) #| Select-Object -ExpandProperty Html
            #[MarkdownRender.MarkdownConverter]::Convert($(Get-Content C:\source\github\MarkdownRenderFW\README.md),[MarkdownRender.MarkdownConversionType]::HTML,[MarkdownRender.PSMarkdownOptionInfo]::new())
        }
    }

    end {
    }
}

Add-Type -Path "$PSScriptRoot\System.Runtime.CompilerServices.Unsafe.dll" -ErrorAction SilentlyContinue
Export-ModuleMember -Function 'ConvertFrom-Markdown'