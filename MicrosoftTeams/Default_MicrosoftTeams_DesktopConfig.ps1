﻿<#
      .SYNOPSIS
      Microsoft Teams Client customization settings via PowerShell

      .DESCRIPTION
      Microsoft Teams Client customization settings via PowerShell

      .EXAMPLE
      PS C:\> .\Default_MicrosoftTeams_DesktopConfig.ps1

      .EXAMPLE
      PS C:\> .\Default_MicrosoftTeams_DesktopConfig.ps1 -verbose

      .NOTES
      Refactored and extended version of Desktop-Config-Json.ps1 by eshlomo1

      .LINK
      https://github.com/eshlomo1/MS_Teams/blob/master/Desktop-Config-Json.ps1

      .LINK
      https://www.eshlomo.us/microsoft-teams-client-personalization-with-powershell/
#>
[CmdletBinding(ConfirmImpact = 'None')]
param ()

#region DefaultSettings
$AppPrefSetOpenAsHidden = $false
$AppPrefSetOpenAtLogin = $false
$AppPrefSetRegisterAsIMProvider = $true
$AppPrefSetRunningOnClose = $false
$NotificationWindowOnClose = $true
$OverrideOpenAsHiddenProperty = $true
$IsAppFirstRun = $false
$CurrentWebLanguage = 'en-us'
#endregion DefaultSettings

#region Cleanup
$ChangedConfig = $null
$SourceConfigFile = $null
$Teams = $null
#endregion Cleanup

#region SetConfigPath
if (($PSVersionTable.PSEdition -eq 'Core') + ($PSVersionTable.Platform -eq 'Unix') -and ($PSVersionTable.OS -like 'Darwin*'))
{
   # OK, macOS is supported
   $SourceConfigFile = ($Env:HOME + '/Library/Application Support/Microsoft/Teams/desktop-config.json')
}
elseif (($PSVersionTable.PSEdition -eq 'Core') + ($PSVersionTable.Platform -eq 'Unix') -and ($PSVersionTable.OS -like 'Linux*'))
{
   # Sorry, Linux is not supported...
	$paramWriteError = @{
		Message	   = 'Sorry, Linux is not supported...'
		Exception   = 'Sorry, Linux is not supported!'
		Category	   = 'NotImplemented'
		ErrorAction = 'Stop'
	}
	Write-Error @paramWriteError

   exit 1
}
else
{
   # Windows? Really??? OK, sure this is supported
   $SourceConfigFile = ($env:userprofile + '\AppData\Roaming\Microsoft\Teams\desktop-config.json')
}
#endregion SetConfigPath

if (Test-Path -Path $SourceConfigFile -ErrorAction SilentlyContinue -WarningAction Continue)
{
   #region GetConfig
   try
   {
      # Splat the parameters
      $paramGetContent = @{
         Path          = $SourceConfigFile
         Force         = $true
         ErrorAction   = 'Stop'
         WarningAction = 'Continue'
      }
      $Teams = (Get-Content @paramGetContent | ConvertFrom-Json -ErrorAction Stop)

      # Cleanup
      $paramGetContent = $null
   }
   catch
   {
      # get error record
      [Management.Automation.ErrorRecord]$e = $_

      # retrieve information about runtime error
      $info = [PSCustomObject]@{
         Exception = $e.Exception.Message
         Reason    = $e.CategoryInfo.Reason
         Target    = $e.CategoryInfo.TargetName
         Script    = $e.InvocationInfo.ScriptName
         Line      = $e.InvocationInfo.ScriptLineNumber
         Column    = $e.InvocationInfo.OffsetInLine
      }

      # output information. Post-process collected info, and log info (optional)
      $info | Out-String | Write-Verbose

      Write-Error -Message $e.Exception.Message -ErrorAction Stop -Exception $e.Exception -TargetObject $e.CategoryInfo.TargetName

      break
   }
   #endregion GetConfig

   #region
   if ($Teams.appPreferenceSettings)
   {
      if ($Teams.appPreferenceSettings.openAsHidden -ne $null)
      {
         if ($Teams.appPreferenceSettings.openAsHidden -ne $AppPrefSetOpenAsHidden)
         {
            Write-Verbose -Message 'Value of openAsHidden will be changed to the desired default'

            $Teams.appPreferenceSettings.openAsHidden = $AppPrefSetOpenAsHidden

            # Set the change indicator
            $ChangedConfig = $true

            Write-Verbose -Message 'Value of openAsHidden was changed to the desired default'
         }
         else
         {
            Write-Verbose -Message 'Value of openAsHidden is unchanged'
         }
      }
      else
      {
         Write-Verbose -Message 'The Parameter openAsHidden will be created with the desired default value'

         # Splat the parameters
         $paramAddMember = @{
            MemberType = 'NoteProperty'
            Name       = 'openAsHidden'
            Value      = $AppPrefSetOpenAsHidden
         }
         $null = ($Teams.appPreferenceSettings | Add-Member @paramAddMember)

         # Cleanup
         $paramAddMember = $null

         # Set the change indicator
         $ChangedConfig = $true

         Write-Verbose -Message 'The Parameter openAsHidden was created with the desired default value'
      }

      if ($Teams.appPreferenceSettings.openAtLogin -ne $null)
      {
         if ($Teams.appPreferenceSettings.openAtLogin -ne $AppPrefSetOpenAtLogin)
         {
            Write-Verbose -Message 'Value of openAtLogin will be changed to the desired default'

            $Teams.appPreferenceSettings.openAtLogin = $

            # Set the change indicator
            $ChangedConfig = $true

            Write-Verbose -Message 'Value of openAtLogin was changed to the desired default'
         }
         else
         {
            Write-Verbose -Message 'Value of openAtLogin is unchanged'
         }
      }
      else
      {
         Write-Verbose -Message 'The Parameter openAtLogin will be created with the desired default value'

         # Splat the parameters
         $paramAddMember = @{
            MemberType = 'NoteProperty'
            Name       = 'openAtLogin'
            Value      = $AppPrefSetOpenAtLogin
         }
         $null = ($Teams.appPreferenceSettings | Add-Member @paramAddMember)

         # Cleanup
         $paramAddMember = $null

         # Set the change indicator
         $ChangedConfig = $true

         Write-Verbose -Message 'The Parameter openAtLogin was created with the desired default value'
      }

      if (($PSVersionTable.PSEdition -eq 'Core') + ($PSVersionTable.Platform -eq 'Unix') -and ($PSVersionTable.OS -like 'Darwin*') )
      {
         Write-Verbose -Message 'The setting registerAsIMProvider is not supported on macOS...'
      }
      else
      {
         if ($Teams.appPreferenceSettings.registerAsIMProvider -ne $null)
         {
            if ($Teams.appPreferenceSettings.registerAsIMProvider -ne $AppPrefSetRegisterAsIMProvider)
            {
               Write-Verbose -Message 'Value of registerAsIMProvider will be changed to the desired default'

               $Teams.appPreferenceSettings.registerAsIMProvider = $AppPrefSetRegisterAsIMProvider

               # Set the change indicator
               $ChangedConfig = $true

               Write-Verbose -Message 'Value of registerAsIMProvider was changed to the desired default'
            }
            else
            {
               Write-Verbose -Message 'Value of registerAsIMProvider is unchanged'
            }
         }
         else
         {
            Write-Verbose -Message 'The Parameter registerAsIMProvider will be created with the desired default value'

            # Splat the parameters
            $paramAddMember = @{
               MemberType = 'NoteProperty'
               Name       = 'registerAsIMProvider'
               Value      = $AppPrefSetRegisterAsIMProvider
            }
            $null = ($Teams.appPreferenceSettings | Add-Member @paramAddMember)

            # Cleanup
            $paramAddMember = $null

            # Set the change indicator
            $ChangedConfig = $true

            Write-Verbose -Message 'The Parameter registerAsIMProvider was created with the desired default value'
         }
      }

      if ($Teams.appPreferenceSettings.runningOnClose -ne $null)
      {
         if ($Teams.appPreferenceSettings.runningOnClose -ne $AppPrefSetRunningOnClose)
         {
            Write-Verbose -Message 'Value of runningOnClose will be changed to the desired default'

            $Teams.appPreferenceSettings.runningOnClose = $AppPrefSetRunningOnClose

            # Set the change indicator
            $ChangedConfig = $true

            Write-Verbose -Message 'Value of runningOnClose was changed to the desired default'
         }
         else
         {
            Write-Verbose -Message 'Value of runningOnClose is unchanged'
         }
      }
      else
      {
         Write-Verbose -Message 'The Parameter runningOnClose will be created with the desired default value'

         # Splat the parameters
         $paramAddMember = @{
            MemberType = 'NoteProperty'
            Name       = 'runningOnClose'
            Value      = $AppPrefSetRunningOnClose
         }
         $null = ($Teams.appPreferenceSettings | Add-Member @paramAddMember)

         # Cleanup
         $paramAddMember = $null

         # Set the change indicator
         $ChangedConfig = $true

         Write-Verbose -Message 'The Parameter runningOnClose was created with the desired default value'
      }
   }

   if ($Teams.notificationWindowOnClose -ne $null)
   {
      if ($Teams.notificationWindowOnClose -ne $NotificationWindowOnClose)
      {
         Write-Verbose -Message 'Value of notificationWindowOnClose will be changed to the desired default'

         $Teams.notificationWindowOnClose = $NotificationWindowOnClose

         # Set the change indicator
         $ChangedConfig = $true

         Write-Verbose -Message 'Value of notificationWindowOnClose was changed to the desired default'
      }
      else
      {
         Write-Verbose -Message 'Value of notificationWindowOnClose is unchanged'
      }
   }
   else
   {
      Write-Verbose -Message 'The Parameter currentWebLanguage will be created with the desired default value'

      # Splat the parameters
      $paramAddMember = @{
         MemberType = 'NoteProperty'
         Name       = 'notificationWindowOnClose'
         Value      = $NotificationWindowOnClose
      }
      $null = ($Teams | Add-Member @paramAddMember)

      # Cleanup
      $paramAddMember = $null

      # Set the change indicator
      $ChangedConfig = $true

      Write-Verbose -Message 'The Parameter currentWebLanguage was created with the desired default value'
   }

   if ($Teams.overrideOpenAsHiddenProperty -ne $null)
   {
      if ($Teams.overrideOpenAsHiddenProperty -ne $OverrideOpenAsHiddenProperty)
      {
         Write-Verbose -Message 'Value of overrideOpenAsHiddenProperty will be changed to the desired default'

         $Teams.overrideOpenAsHiddenProperty = $OverrideOpenAsHiddenProperty

         # Set the change indicator
         $ChangedConfig = $true

         Write-Verbose -Message 'Value of overrideOpenAsHiddenProperty was changed to the desired default'
      }
      else
      {
         Write-Verbose -Message 'Value of overrideOpenAsHiddenProperty is unchanged'
      }
   }
   else
   {
      Write-Verbose -Message 'The Parameter overrideOpenAsHiddenProperty will be created with the desired default value'

      # Splat the parameters
      $paramAddMember = @{
         MemberType = 'NoteProperty'
         Name       = 'overrideOpenAsHiddenProperty'
         Value      = $OverrideOpenAsHiddenProperty
      }
      $null = ($Teams | Add-Member @paramAddMember)

      # Cleanup
      $paramAddMember = $null

      # Set the change indicator
      $ChangedConfig = $true

      Write-Verbose -Message 'The Parameter overrideOpenAsHiddenProperty was created with the desired default value'
   }

   if ($Teams.isAppFirstRun -ne $null)
   {
      if ($Teams.isAppFirstRun -ne $IsAppFirstRun)
      {
         Write-Verbose -Message 'Value of isAppFirstRun will be changed to the desired default'

         $Teams.isAppFirstRun = $IsAppFirstRun

         # Set the change indicator
         $ChangedConfig = $true

         Write-Verbose -Message 'Value of isAppFirstRun was changed to the desired default'
      }
      else
      {
         Write-Verbose -Message 'Value of isAppFirstRun is unchanged'
      }
   }
   else
   {
      Write-Verbose -Message 'The Parameter isAppFirstRun will be created with the desired default value'

      # Splat the parameters
      $paramAddMember = @{
         MemberType = 'NoteProperty'
         Name       = 'isAppFirstRun'
         Value      = $false
      }
      $null = ($Teams | Add-Member @paramAddMember)

      # Cleanup
      $paramAddMember = $null

      # Set the change indicator
      $ChangedConfig = $true

      Write-Verbose -Message 'The Parameter isAppFirstRun was created with the desired default value'
   }

   if ($Teams.currentWebLanguage -ne $null)
   {
      if ($Teams.currentWebLanguage -ne $CurrentWebLanguage)
      {
         Write-Verbose -Message 'Value of currentWebLanguage will be changed to the desired default'

         $Teams.currentWebLanguage = $CurrentWebLanguage

         # Set the change indicator
         $ChangedConfig = $true

         Write-Verbose -Message 'Value of currentWebLanguage was changed to the desired default'
      }
      else
      {
         Write-Verbose -Message 'Value of currentWebLanguage is unchanged'
      }
   }
   else
   {
      Write-Verbose -Message 'The Parameter currentWebLanguage will be created with the desired default value'

      # Splat the parameters
      $paramAddMember = @{
         MemberType = 'NoteProperty'
         Name       = 'currentWebLanguage'
         Value      = $CurrentWebLanguage
      }
      $null = ($Teams | Add-Member @paramAddMember)

      #Cleanup
      $paramAddMember = $null

      # Set the change indicator
      $ChangedConfig = $true

      Write-Verbose -Message 'The Parameter currentWebLanguage was created with the desired default value'
   }
   #endregion

   #region SaveNewConfig
   if ($ChangedConfig)
   {
      Write-Verbose -Message 'Changed configuration will be saved'

      try
      {
         # Splat the parameters
         $paramConvertToJson = @{
            Compress      = $true
            ErrorAction   = 'Stop'
            WarningAction = 'Continue'
         }

         $paramSetContent = @{
            Path          = $SourceConfigFile
            Force         = $true
            Confirm       = $false
            ErrorAction   = 'Stop'
            WarningAction = 'Continue'
         }

         $null = ($Teams | ConvertTo-Json @paramConvertToJson | Set-Content @paramSetContent)

         # Cleanup
         $paramConvertToJson = $null
         $paramSetContent = $null
         $Teams = $null
      }
      catch
      {
         # get error record
         [Management.Automation.ErrorRecord]$e = $_

         # retrieve information about runtime error
         $info = [PSCustomObject]@{
            Exception = $e.Exception.Message
            Reason    = $e.CategoryInfo.Reason
            Target    = $e.CategoryInfo.TargetName
            Script    = $e.InvocationInfo.ScriptName
            Line      = $e.InvocationInfo.ScriptLineNumber
            Column    = $e.InvocationInfo.OffsetInLine
         }

         # output information. Post-process collected info, and log info (optional)
         $info | Out-String | Write-Verbose

         Write-Error -Message $e.Exception.Message -ErrorAction Stop -Exception $e.Exception -TargetObject $e.CategoryInfo.TargetName

         break
      }

      Write-Verbose -Message 'Changed configuration was saved'
   }
   else
   {
      Write-Verbose -Message 'No changes made to the configuration'
   }
   #endregion SaveNewConfig
}
else
{
   Write-Warning -Message 'No Configuration File for Microsoft Teams was found.'

   exit 1
}