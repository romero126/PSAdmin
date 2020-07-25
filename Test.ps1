$testResults = Invoke-Pester .\Tests\* -PassThru

if ($testResults.FailedCount -gt 0 -or $null -eq $TestResults) {
	Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
}