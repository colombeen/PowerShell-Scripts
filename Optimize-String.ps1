Function Optimize-String
{
  Param
  (
    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
        Position = 0
    )]
    [ValidateNotNullOrEmpty()]
    [string]
    $String,
    
    [ValidateSet('Diacritics', 'AllSpaces', 'LeadingSpaces', 'TrailingSpaces', 'DoubleSpaces', 'LowerCase', 'UpperCase', 'Numbers', 'SpecialChars', 'NewLines')]
    [string[]]
    $Remove,
    
    [ValidateSet('LowerToUpperCase', 'UpperToLowerCase', 'DashToHyphen', 'SmartQuotes')]
    [string[]]
    $Replace
  )

  Begin
  {
  }
  
  Process
  {
    If ($Remove.Count -gt 0)
    {
      If ('Diacritics' -in $Remove)
      {
        $String = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding('Cyrillic').GetBytes($String))
      }
      
      If ('LowerCase' -in $Remove)
      {
        $String = $String -creplace '[\p{Ll}]'
      }
      
      If ('UpperCase' -in $Remove)
      {
        $String = $String -creplace '[\p{Lu}]'
      }
      
      If ('Numbers' -in $Remove)
      {
        $String = $String -creplace '[\p{N}]'
      }
      
      If ('SpecialChars' -in $Remove)
      {
        $String = $String -creplace '[^\p{L}\p{Nd}\p{Z}\r\n]'
      }
      
      If ('NewLines' -in $Remove)
      {
        $String = $String -creplace '[\r\n]'
      }
      
      If ('AllSpaces' -in $Remove)
      {
        $String = $String -replace ' '
      }
      
      If ('LeadingSpaces' -in $Remove)
      {
        $String = $String.TrimStart()
      }
      
      If ('TrailingSpaces' -in $Remove)
      {
        $String = $String.TrimEnd()
      }
      
      If ('DoubleSpaces' -in $Remove)
      {
        $String = $String -creplace '[\p{Zs}]+', ' '
      }
    }
    
    
    If ($Replace.Count -gt 0)
    {
      If ('DashToHyphen' -in $Replace)
      {
        $String = $String -creplace '[\p{Pd}]', '-'
      }
      
      If ('LowerToUpperCase' -in $Replace)
      {
        $String = $String.ToUpper()
      }
      
      If ('UpperToLowerCase' -in $Replace)
      {
        $String = $String.ToLower()
      }
      
      If ('SmartQuotes' -in $Replace)
      {
        $String = $String -creplace '[\u2019\u2018]', ''''
        $String = $String -creplace '[\u201C\u201D]', '"'
      }
    }
    
    Write-Output $($String -as [string])
  }
}