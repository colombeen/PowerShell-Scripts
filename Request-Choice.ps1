Function Request-Choice
{
  Param
  (
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [ValidateSet('AbortRetryIgnore', 'CancelTryAgainContinue', 'OkCancel', 'RetryCancel', 'YesNo', 'YesNoCancel')]
    [string]
    $Type,
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Title,
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 2)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Text,
    [Parameter(ValueFromPipelineByPropertyName = $true, Position = 3)]
    [ValidateRange(1,3)]
    [int]
    $DefaultItem = 1
  )
  
  Process
  {
    # Reset stuff
    $SelectedItem = $DefaultItem - 1
    $OptionList = @()
    $Result = $null
    
    # Start
    Switch ($Type)
    {
      'AbortRetryIgnore'
      {
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&Abort','Aborts the operation')
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&Retry','Retries the operation')
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&Ignore','Ignores the operation')
      }
      'CancelTryAgainContinue'
      {
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&Cancel','Cancels the operation')
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&Try Again','Retries the operation')
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('C&ontinue','Continues the operation')
      }
      'OkCancel'
      {
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&OK','Accepts the operation')
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&Cancel','Cancels the operation')
      }
      'RetryCancel'
      {
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&Retry','Retries the operation')
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&Cancel','Cancels the operation')
      }
      'YesNo'
      {
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&Yes','Replies with Yes')
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&No','Replies with No')
      }
      'YesNoCancel'
      {
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&Yes','Replies with Yes')
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&No','Replies with No')
        $OptionList += New-Object -TypeName System.Management.Automation.Host.ChoiceDescription ('&Cancel','Cancels the operation')
            }
      Default
      {
        Throw  ('Can''t match the provided type {0}' -f $Type)
      }
    }
    
    $Options = [System.Management.Automation.Host.ChoiceDescription[]] $OptionList
    $Result = $host.UI.PromptForChoice($Title, $Text, $Options, $SelectedItem)
    
    If ($Result -ne $null)
    {
      $Options[$Result].Label.Replace('&','')
    }
  }
}