configuration InstallRRAS
{
   param
    (

    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {
        WindowsFeature Routing
        {
            Ensure = 'Present'
            Name = 'Routing'

        }
        WindowsFeature RemoteAccessPowerShell
        {
            Ensure = 'Present'
            Name = 'RSAT-RemoteAccess-PowerShell'
            DependsOn = '[WindowsFeature]Routing'
        }
        Service RemoteAccessAutomatic
        {
            Name        = "RemoteAccess"
            StartupType = "Automatic"
            State       = "Running"
            DependsOn = '[WindowsFeature]Routing'
        }
        Service RemoteAccess
        {
            Ensure = 'Present'
            Name = 'RemoteAccess'
            State = 'Running'
            DependsOn = '[Service]RemoteAccessAutomatic'
        }
        

    }
}