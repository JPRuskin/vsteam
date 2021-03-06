Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\teams.psm1 -Force

InModuleScope teams {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe "Teams VSTS" {
      . "$PSScriptRoot\mockProjectNameDynamicParam.ps1"
        
      Context 'Get-VSTeam with project name' {  
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teams' {
            Get-VSTeam -ProjectName Test

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test/teams/?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Get-VSTeam with project name, with top' {  
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teams' {
            Get-VSTeam -ProjectName Test -Top 10

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test/teams/?api-version=$($VSTeamVersionTable.Core)&`$top=10"
            }
         }
      }

      Context 'Get-VSTeam with project name, with skip' {  
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teams' {
            Get-VSTeam -ProjectName Test -Skip 10

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test/teams/?api-version=$($VSTeamVersionTable.Core)&`$skip=10"
            }
         }
      }

      Context 'Get-VSTeam with project name, with top and skip' {  
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teams' {
            Get-VSTeam -ProjectName Test -Top 10 -Skip 5

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test/teams/?api-version=$($VSTeamVersionTable.Core)&`$top=10&`$skip=5"
            }
         }
      }

      Context 'Get-VSTeam with specific project and specific team id' {  
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teams' {
            Get-VSTeam -ProjectName Test -TeamId TestTeamId

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test/teams/TestTeamId?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Get-VSTeam with specific project and specific team Name' {  
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teams' {
            Get-VSTeam -ProjectName Test -TeamName TestTeamName

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test/teams/TestTeamName?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Add-VSTeam with team name only' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should create a team' {
            Add-VSTeam -ProjectName Test -TeamName "TestTeam"

            $expectedBody = '{ "name": "TestTeam", "description": "" }'

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test/teams/?api-version=$($VSTeamVersionTable.Core)" -and
               $Method -eq "Post" -and
               $Body -eq $expectedBody
            }
         }
      }

      Context 'Add-VSTeam with team name and description' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}
            
         It 'Should create a team' {
            Add-VSTeam -ProjectName Test -TeamName "TestTeam" -Description "Test Description"

            $expectedBody = '{ "name": "TestTeam", "description": "Test Description" }'

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test/teams/?api-version=$($VSTeamVersionTable.Core)" -and
               $Method -eq "Post" -and
               $Body -eq $expectedBody
            }
         }
      }

      Context 'Update-VSTeam without name or description' {            
         It 'Should throw' {
            { Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" } | Should Throw
         }
      }

      Context 'Update-VSTeam with new team name' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}
            
         It 'Should update the team' {
            Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName"

            $expectedBody = '{ "name": "NewTeamName" }'

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test/teams/OldTeamName?api-version=$($VSTeamVersionTable.Core)" -and
               $Method -eq "Patch" -and
               $Body -eq $expectedBody
            }
         }
      }

      Context 'Update-VSTeam with new description' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}
            
         It 'Should update the team' {
            Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -Description "New Description"

            $expectedBody = '{"description": "New Description" }'

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test/teams/OldTeamName?api-version=$($VSTeamVersionTable.Core)" -and
               $Method -eq "Patch" -and
               $Body -eq $expectedBody
            }
         }
      }

      Context 'Update-VSTeam with new team name and description' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}
            
         It 'Should update the team' {
            Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName" -Description "New Description"

            $expectedBody = '{ "name": "NewTeamName", "description": "New Description" }'

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test/teams/OldTeamName?api-version=$($VSTeamVersionTable.Core)" -and
               $Method -eq "Patch" -and
               $Body -eq $expectedBody
            }
         }
      }

      Context 'Update-VSTeam, fed through pipeline' {
         Mock Get-VSTeam { return New-Object -TypeName PSObject -Prop @{projectname = "TestProject"; name = "OldTeamName"} }
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should update the team' {
            Get-VSTeam -ProjectName TestProject -TeamId "OldTeamName" | Update-VSTeam -NewTeamName "NewTeamName" -Description "New Description"

            $expectedBody = '{ "name": "NewTeamName", "description": "New Description" }'

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/TestProject/teams/OldTeamName?api-version=$($VSTeamVersionTable.Core)" -and
               $Method -eq "Patch" -and
               $Body -eq $expectedBody
            }
         }
      }

      Context 'Remove-VSTeam' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}
            
         It 'Should remove the team' {
            Remove-VSTeam -ProjectName Test -TeamId "TestTeam" -Force

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/Test/teams/TestTeam?api-version=$($VSTeamVersionTable.Core)" -and
               $Method -eq "Delete"
            }
         }
      }

      Context 'Remove-VSTeam, fed through pipeline' {
         Mock Get-VSTeam { return New-Object -TypeName PSObject -Prop @{projectname = "TestProject"; name = "TestTeam"} }
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should remove the team' {
            Get-VSTeam -ProjectName TestProject -TeamId "TestTeam" | Remove-VSTeam -Force

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/projects/TestProject/teams/TestTeam?api-version=$($VSTeamVersionTable.Core)" -and
               $Method -eq "Delete"
            }
         }
      }
   }

   Describe "Teams TFS" {
      . "$PSScriptRoot\mockProjectNameDynamicParam.ps1"

      Mock _useWindowsAuthenticationOnPremise { return $true }
      
      $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'

      Context 'Get-VSTeam with project name on TFS local Auth' {  
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teams' {
            Get-VSTeam -ProjectName Test

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Get-VSTeam with project name, with top on TFS local Auth' {  
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teams' {
            Get-VSTeam -ProjectName Test -Top 10

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/?api-version=$($VSTeamVersionTable.Core)&`$top=10"
            }
         }
      }

      Context 'Get-VSTeam with project name, with skip on TFS local Auth' {  
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teams' {
            Get-VSTeam -ProjectName Test -Skip 10

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/?api-version=$($VSTeamVersionTable.Core)&`$skip=10"
            }
         }
      }

      Context 'Get-VSTeam with project name, with top and skip on TFS local Auth' {  
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teams' {
            Get-VSTeam -ProjectName Test -Top 10 -Skip 5

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/?api-version=$($VSTeamVersionTable.Core)&`$top=10&`$skip=5"
            }
         }
      }

      Context 'Get-VSTeam with specific project and specific team Name on TFS local Auth' {  
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teams' {
            Get-VSTeam -ProjectName Test -Name TestTeamName

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/TestTeamName?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Get-VSTeam with specific project and specific team ID on TFS local Auth' {  
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should return teams' {
            Get-VSTeam -ProjectName Test -TeamId TestTeamId

            # Make sure it was called with the correct URI
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/TestTeamId?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Add-VSTeam with team name only on TFS local Auth' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}

         It 'Should create a team' {
            Add-VSTeam -ProjectName Test -TeamName "TestTeam"

            $expectedBody = '{ "name": "TestTeam", "description": "" }'

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/?api-version=$($VSTeamVersionTable.Core)" -and
               $Method -eq "Post" -and
               $Body -eq $expectedBody
            }
         }
      }

      Context 'Update-VSTeam with new team name on TFS local Auth' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}
            
         It 'Should update the team' {
            Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName"

            $expectedBody = '{ "name": "NewTeamName" }'

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/OldTeamName?api-version=$($VSTeamVersionTable.Core)" -and
               $Method -eq "Patch" -and
               $Body -eq $expectedBody
            }
         }
      }

      Context 'Remove-VSTeam on TFS local Auth' {
         Mock Invoke-RestMethod { return @{value = 'teams'}}
         
         It 'Should remove the team' {
            Remove-VSTeam -ProjectName Test -TeamId "TestTeam" -Force

            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/TestTeam?api-version=$($VSTeamVersionTable.Core)" -and
               $Method -eq "Delete"
            }
         }
      }

      # Must be last because it sets $VSTeamVersionTable.Account to $null
      Context '_buildURL handles exception' {
         
         # Arrange
         $VSTeamVersionTable.Account = $null
         
         It 'should return approvals' {
         
            # Act
            { _buildURL -ProjectName project } | Should Throw
         }
      }
   }
}