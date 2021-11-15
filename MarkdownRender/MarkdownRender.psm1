function ConvertFrom-Markdown {
    <#
    .SYNOPSIS
        Convert the contents of a string or a file to a MarkdownInfo object
    .DESCRIPTION
        This cmdlet converts the specified content into a MarkdownInfo.
        When a file path is specified for the Path parameter, the contents on the file are converted.
        The output object has three properties:
            - The Token property has the abstract syntax tree (AST) of the the converted object
            - The Html property has the HTML conversion of the specified input
            - The VT100EncodedString property has the converted string with ANSI (VT100) escape sequences if
            the AsVT100EncodedString parameter was specified, but this paramter is not supported yet.

        This cmdlet was backported to Windows PowerShell 5.1.
    .PARAMETER Path
        The path to the file to convert.
    .INPUTS
    .OUTPUTS
    .EXAMPLE
        ConvertFrom-Markdown -Path "C:\Temp\test.md"
    .EXAMPLE
        # to access the HTML content use the .html property
        $html = (ConvertFrom-Markdown -Path "C:\Temp\test.md").html
    .EXAMPLE
        # to access the HTML content use the .html property
        $html = ConvertFrom-Markdown -Path "C:\Temp\test.md" | Select-Object -ExpandPropery html
    .NOTES
        This cmdlet was backported to Windows PowerShell 5.1 from PowerShell 7.
    .LINK
    #>
    [CmdletBinding(DefaultParameterSetName = "InputObject")]
    [OutputType([MarkdownRender.MarkdownInfo])]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Path", ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path
        ,
        # Specifies the object to be converted.
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "InputObject",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Specifies the object to be converted")]
        [ValidateNotNullOrEmpty()]
        [PSObject]
        $InputObject
        ,
        # Specifies if the output should be encoded as a string with VT100 escape codes.
        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = "InputObject", HelpMessage = "Specifies if the output should be encoded as a string with VT100 escape codes.")]
        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = "Path", HelpMessage = "Specifies if the output should be encoded as a string with VT100 escape codes.")]
        [switch]
        $AsVT100EncodedString
    )

    begin {
    }

    process {
        switch ($pscmdlet.ParameterSetName) {
            "Path" {
                foreach ($onePath in $Path) {
                    $content = Get-Content -Path $onePath -Raw
                    [MarkdownRender.MarkdownConverter]::Convert($content, [MarkdownRender.MarkdownConversionType]::HTML, [MarkdownRender.PSMarkdownOptionInfo]::new())
                }
            }
            "InputObject" {
                if ($InputObject -is [System.String]) {
                    $content = $InputObject
                    [MarkdownRender.MarkdownConverter]::Convert($content, [MarkdownRender.MarkdownConversionType]::HTML, [MarkdownRender.PSMarkdownOptionInfo]::new())
                } elseif ($InputObject -is [System.IO.FileInfo]) {
                    $content = Get-Content -Path $InputObject -Raw
                    [MarkdownRender.MarkdownConverter]::Convert($content, [MarkdownRender.MarkdownConversionType]::HTML, [MarkdownRender.PSMarkdownOptionInfo]::new())
                } else {
                    throw "InputObject must be a string or a file path"
                }
            }
            Default { throw "Invalid parameter set name: $($pscmdlet.ParameterSetName)" }
        }
    }

    end {}
}

Add-Type -Path "$PSScriptRoot\System.Runtime.CompilerServices.Unsafe.dll" -ErrorAction SilentlyContinue
Export-ModuleMember -Function 'ConvertFrom-Markdown'