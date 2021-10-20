Function ConvertTo-HashTable
{
  [OutputType([hashtable])]
  
  Param
  (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
    [Alias('PSCustomObject', 'PSObject')]
    [ValidateNotNullOrEmpty()]
    [PSCustomObject[]]
    $Object,
    
    [Parameter(Position = 1)]
    [switch]
    $RemoveNullOrEmpty,
    
    [Parameter(Position = 2)]
    [switch]
    $ReplaceNullWithEmpty
  )

  Process
  {
    $Object | ForEach-Object -Process {
      $_.PSObject.Properties | ForEach-Object -Begin {
        # Create empty hashtable
        
        $HashTable = [hashtable]@{}
      } -Process {
        # Fill the hashtable
        
        If (!($RemoveNullOrEmpty.IsPresent) -or ($RemoveNullOrEmpty.IsPresent -and !([string]::IsNullOrEmpty($_.Value)))) {
          # Check for null values
          If ($ReplaceNullWithEmpty.IsPresent -and $null -eq $_.Value) {
            # Create the key with an empty value
            $HashTable[$_.Name] = ''
          } Else {
            # Create the key with the matching value
            $HashTable[$_.Name] = $_.Value
          }
        }
      } -End {
        # Return the hashtable
        
        $HashTable
      }
    }
  }
}