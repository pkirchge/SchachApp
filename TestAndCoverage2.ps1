$testProjects = "SchachWebAppVueTest"

# Gets the path of a file in the most recent NuGet package
function getFrameworkNameFromFilename {
    Param($package, $file)
    $nugetOpenCoverPackage = Join-Path -Path "C:\Users\Svenja" -ChildPath "\.nuget\packages\$package"
    $latestOpenCover = Join-Path -Path ((Get-ChildItem -Path $nugetOpenCoverPackage | Sort-Object Fullname -Descending)[0].FullName) -ChildPath $file
    return $latestOpenCover;
}

$latestOpenCover = getFrameworkNameFromFilename "OpenCover" "tools\OpenCover.Console.exe"
$latestReportGenerator = getFrameworkNameFromFilename "ReportGenerator" "tools\ReportGenerator.exe"
# run dotnet restore on project
cd .\SchachWebAppVue
& dotnet restore
cd ..

If (Test-Path "$PSScriptRoot\OpenCover.coverageresults"){
	Remove-Item "$PSScriptRoot\OpenCover.coverageresults"
}

If (Test-Path "$PSScriptRoot\testRuns_*.testresults"){
	Remove-Item "$PSScriptRoot\testRuns_*.testresults"
}

If (Test-Path "$PSScriptRoot\CoverageReport"){
	Remove-Item "$PSScriptRoot\CoverageReport" -Recurse
}

$testRuns = 1;
foreach ($testProject in $testProjects){

    # Arguments for running dotnet
    $dotnetArguments = "xunit", "-xml `"`"$PSScriptRoot\testRuns_$testRuns.testresults`"`""
    "Running tests with OpenCover"
    & $latestOpenCover `
        -register:user `
        -target:dotnet.exe `
        -targetdir:$PSScriptRoot\$testProject `
        "-targetargs:$dotnetArguments" `
        -returntargetcode `
        -output:"$PSScriptRoot\OpenCover.coverageresults" `
        -mergeoutput `
        -oldStyle `


        $testRuns++
}

"Generating Html coverage report"
& $latestReportGenerator -reports:"*.coverageresults" -targetdir:"$PSScriptRoot\CoverageReport"