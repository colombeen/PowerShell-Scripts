#region DEFAULTS
$DefaultExtensions = @(
  # Powershell
  'ms-vscode.powershell';
  # Alphabetical sorter
  'ue.alphabetical-sorter';
  # Blockman - Highlight Nested Code Blocks
  'leodevbro.blockman';
  # Cursor Align
  'yo1dog.cursor-align';
  # Edit csv
  'janisdd.vscode-edit-csv';
  # GitLens
  'eamodio.gitlens';
  # Inline Values support for PowerShell
  'TylerLeonhardt.vscode-inline-values-powershell';
  # Prettier - Code formatter
  'esbenp.prettier-vscode';
  # Rainbow CSV
  'mechatroner.rainbow-csv';
  # XML Tools
  'DotJoshJohnson.xml';
)
$DefaultSettings = @{
  # Controls whether the editor should automatically format the pasted content
  'editor.formatOnPaste'                                  = $true
  # Format a file on save
  'editor.formatOnSave'                                   = $true
  # Show snippet suggestions below other suggestions
  'editor.snippetSuggestions'                             = 'bottom'
  # Controls whether an active snippet prevents quick suggestions
  'editor.suggest.snippetsPreventQuickSuggestions'        = $false
  #  Tab complete will insert the best matching suggestion when pressing tab
  'editor.tabCompletion'                                  = 'on'
  # The number of spaces a tab is equal to
  'editor.tabSize'                                        = 2
  # The default language identifier that is assigned to new files
  'files.defaultLanguage'                                 = 'powershell'
  # Controls whether unsaved files are remembered between sessions
  'files.hotExit'                                         = 'onExitAndWindowClose'
  # Commits will automatically be fetched from the default remote of the current Git repository
  'git.autofetch'                                         = $true
  # Commit all changes when there are no staged changes
  'git.enableSmartCommit'                                 = $true
  # When enabled, fetch all branches when pulling. Otherwise, fetch just the current one
  'git.fetchOnPull'                                       = $true
  # Specifies whether to enable GitLens+ features
  'gitlens.plusFeatures.enabled'                          = $false
  # Specifies whether to show the Welcome (Quick Setup) experience on first install
  'gitlens.showWelcomeOnInstall'                          = $false
  # Replaces aliases with their aliased name
  'powershell.codeFormatting.autoCorrectAliases'          = $true
  # Places open brace on the same line as its associated statement
  'powershell.codeFormatting.openBraceOnSameLine'         = $false
  # Trims extraneous whitespace before and after the pipeline operator ('|')
  'powershell.codeFormatting.trimWhitespaceAroundPipe'    = $true
  # Use single quotes if a string is not interpolated and its value does not contain a single quote
  'powershell.codeFormatting.useConstantStrings'          = $true
  # Use correct casing for cmdlets
  'powershell.codeFormatting.useCorrectCasing'            = $true
  # Removes redundant whitespace between parameters
  'powershell.codeFormatting.whitespaceBetweenParameters' = $true
  # Switches focus to the console when a script selection is run or a script file is debugged
  'powershell.integratedConsole.focusConsoleOnExecute'    = $false
  # Do not show the Powershell Integrated Console banner on launch
  'powershell.integratedConsole.suppressStartupBanner'    = $true
  # Specifies the PowerShell version name, as displayed by the 'PowerShell: Show Session Menu' command
  'powershell.powerShellDefaultVersion'                   = 'Windows PowerShell (x64)'
  # Always allow untrusted files to be introduced to a trusted workspace without prompting
  'security.workspace.trust.untrustedFiles'               = 'open'
  # Controls Visual Studio Code telemetry
  'telemetry.telemetryLevel'                              = 'off'
  # Controls whether the terminal cursor blinks
  'terminal.integrated.cursorBlinking'                    = $true
  # Controls the style of terminal cursor
  'terminal.integrated.cursorStyle'                       = 'line'
  # Automatically switch to the preferred color theme based on the OS appearance
  'window.autoDetectColorScheme'                          = $true
  # Open new windows maximized
  'window.newWindowDimensions'                            = 'maximized'
  # Open a new untitled file (only applies when opening an empty window)
  'workbench.startupEditor'                               = 'newUntitledFile'
}
$UserSettingsPath = ('{0}\Code\User\settings.json' -f $env:APPDATA)
#endregion

#region VS CODE EXTENSIONS
$DefaultExtensions | ForEach-Object {
  code --install-extension $_ --force
}
#endregion

#region VS CODE SETTINGS
if (!(Test-Path -Path $UserSettingsPath -ErrorAction SilentlyContinue))
{
  New-Item -Path $UserSettingsPath -ItemType File
  '{}' | Out-File -FilePath $UserSettingsPath
}

$CurrentSettings = Get-Content -Path $UserSettingsPath | ConvertFrom-Json

#region VS CODE GIT REPO
Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowser.RootFolder = 'MyComputer'
$FolderBrowser.Description = 'Select your GitLab repository directory'
$null = $FolderBrowser.ShowDialog()
$GitRepoLocation = $FolderBrowser.SelectedPath

If ($null -ne $GitRepoLocation)
{
  $DefaultSettings += @{
    'git.defaultCloneDirectory' = $GitRepoLocation -replace '\\', '/'
  }
}
#endregion

$DefaultSettings.Keys | ForEach-Object {
  $CurrentSettings | Add-Member -MemberType NoteProperty -Force -Name $_ -Value $DefaultSettings.Item($_)
}

Set-Content -Path $UserSettingsPath -Value ($CurrentSettings | ConvertTo-Json)
#endregion