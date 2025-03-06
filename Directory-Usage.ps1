<#
.SYNOPSIS
  Get the size of a directory and its subdirectories. 
.DESCRIPTION
  This function will return the size of a directory and its subdirectories. 
  It will return the size in bytes.
.PARAMETER dir
  The directory to get the size of.
.EXAMPLE
  Directory-Usage
  This will return the size of the current directory and its subdirectories.
.EXAMPLE
  Directory-Usage "C:\Windows"
  This will return the size of the C:\Windows directory and its subdirectories.
.NOTES
  Name: Directory-Usage
#>

function Directory-Usage($dir=".") { 
  get-childitem $dir | 
    Foreach-Object { $f = $_ ; 
        Get-ChildItem -r $_.FullName | 
           Measure-Object -property length -sum | 
             Select-Object @{Name="Name";Expression={$f}},Sum}
}
