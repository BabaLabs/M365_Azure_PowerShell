#IDK do something with this and make it a script for Boujie customers

Set-OrganizationConfig -DefaultMinutestoReduceLongEventsBy 5

Set-OrganizationConfig -DefaultMinutestoReduceShortEventsBy 5

Set-OrganizationConfig -ShortenEventScopeDefault EndEarly