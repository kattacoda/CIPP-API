function Invoke-OutBoundSpamAlert {
    <#
    .FUNCTIONALITY
    Internal
    #>
    param($Tenant, $Settings)
    If ($Settings.Remediate) {
        $Contacts = $settings.OutboundSpamContact
        try {
            New-ExoRequest -tenantid $tenant -cmdlet 'Set-HostedOutboundSpamFilterPolicy' -cmdparams @{ Identity = 'Default'; NotifyOutboundSpam = $true; NotifyOutboundSpamRecipients = $Contacts.OutboundSpamContact } -useSystemMailbox $true
            Write-LogMessage -API 'Standards' -tenant $tenant -message "Set outbound spam filter alert to $($Contacts.OutboundSpamContact)" -sev Info
        } catch {
            Write-LogMessage -API 'Standards' -tenant $tenant -message "Could not set outbound spam contact to $($Contacts.OutboundSpamContact). $($_.exception.message)" -sev Error
        }
    }
    if ($Settings.Alert) {
        $CurrentInfo = New-ExoRequest -tenantid $Tenant -cmdlet 'Get-HostedOutboundSpamFilterPolicy' -useSystemMailbox $true
        if ($CurrentInfo.NotifyOutboundSpam -eq $true) {
            Write-LogMessage -API 'Standards' -tenant $tenant -message "Outbound spam filter alert is set to $($CurrentInfo.NotifyOutboundSpamRecipients)" -sev Info
        } else {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'Outbound spam filter alert is not set' -sev Alert
        }
    }
}