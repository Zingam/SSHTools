$coverityBuildDirectory = "../__build-CoverityScan/"

################################################################################
# Functions
################################################################################

function Invoke-Executable
{
  param ([string] $FilePath, [string] $ArgumentList)

  $psInfo = New-Object System.Diagnostics.ProcessStartInfo
  $psInfo.FileName = $FilePath
  $psInfo.Arguments = $ArgumentList
  $psInfo.WorkingDirectory = Get-Location
  $psInfo.RedirectStandardError = $true
  $psInfo.RedirectStandardOutput = $true
  $psInfo.UseShellExecute = $false

  $ps = New-Object System.Diagnostics.Process
  $ps.StartInfo = $psInfo
  $ps.Start() | Out-Null
  $ps.WaitForExit()

  $stdout = $ps.StandardOutput.ReadToEnd()
  $stderr = $ps.StandardError.ReadToEnd()

  Write-Host $stdout
  Write-Host $stderr
  Write-Host "[$FilePath] Process exited with code: " $ps.ExitCode
}

function Find-FileInPath()
{
  param (
      [string] $filename
  )
  
  $matches = $env:Path.Split(';') | %{ Join-Path $_ $filename} | ?{ Test-Path $_ }
  
  if (0 -eq $matches.Length)
  {
      Write-Host "File not found in `"PATH`": $filename"
      
      return $false;
  }
  else
  {
      return $true    
  }
}

################################################################################

$currentDirectory =  [string](Get-Location)
$coverityScanOutputPath = "{0}/{1}" -f $currentDirectory, $coverityBuildDirectory

################################################################################
# Output path

New-Item -Path $coverityScanOutputPath -ItemType "Directory" -Force

$coverityScanOutputPath = Resolve-Path -Path $coverityScanOutputPath | %{ "$_" }
$coverityScanOutputPath = $coverityScanOutputPath.Replace("\","/")

cd $coverityScanOutputPath

################################################################################

try
{
  # Store the environment variables from the Batch script to a temporary file
  $vcvarsFile = "{0}vcvars64.txt" -f $coverityScanOutputPath
  
  Write-Host "`n--> Setup build environment...`n"
  
  cmd /c "call `"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat`" && set > `"$vcvarsFile`""
  
  $result = Test-Path $vcvarsFile
  if (-not $result)
  {
    Write-Host "File not found: $vcvarsFile"
    
    throw "File not found..."
  }
  # Set the environment variables from the temporary file in PowerShell
  Get-Content $vcvarsFile | ForEach-Object -Process `
  {
    if ($_ -match "^(.*?)=(.*)$")
    {
      #Set-Content "env:\$($matches[1])" $matches[2]
      Set-Item -Force -Path "env:$($matches[1])" -Value $matches[2]
    }
  }
  
  $result = Find-FileInPath "cmake.exe"
  if (-not $result)
  {
    throw "File not found..."
  }
  
  Write-Host "`n--> Configure project...`n"
  
  cmake -G"Ninja" -D"CMAKE_TOOLCHAIN_FILE=$env:VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" "../SSHTools/"

  $coverityScan = "$env:COVERITYSCAN_ROOT/bin/cov-build.exe "
  $coverityScanArgumentList = "--dir cov-int/ cmake --build ."
  
  $result = Test-Path $coverityScan
  if (0 -eq $result)
  {
    Write-Host "`n`"CoverityScan`" not found:`n"
  
    $result = Get-Variable -Name "COVERITYSCAN_ROOT" -ErrorAction "SilentlyContinue"
    if ($result)
    {
      Write-Host "Is CoverityScan installed?"
    }
    else
    {
      Write-Host "  Environment variable `"COVERITYSCAN_ROOT`" is not set..."
    }
  
    throw "CoverityScan not found"
  }
  
  Write-Host "`n--> Build project...`n"
  
  Invoke-Executable -FilePath "$coverityScan" -ArgumentList "$coverityScanArgumentList"
}
catch
{
  # Nothing to see here...
}
finally
{
  cd $currentDirectory
}
