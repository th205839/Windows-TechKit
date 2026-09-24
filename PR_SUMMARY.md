PR: Standardize Start scripts and ModuleExecutor improvements

Summary
- Standardized module Start.ps1 files (Network, Inventory, Hardware) to return a structured $result object with fields: Module, Timestamp, Status, StatusDetail, AdminRequired, Details.
- Improved core/module-manager/ModuleExecutor.ps1 to:
  - Fall back to known function contracts when Start.ps1 does not return an object.
  - Import any .psm1 files inside module folders so Export-ModuleMember works as intended.
  - Removed problematic Export-ModuleMember usage that caused dot-sourcing issues in tests.
- Added .gitignore entries for runtime logs and test artifacts and untracked existing log files.

Validation
- Test suite run: Invoke-Pester .\tests — All tests passed (30/30) on the environment used.
- Commits including these changes were pushed to main earlier; this PR documents the work and provides a summary for reviewers.

Notes
- This PR branch only contains this PR_SUMMARY.md; code changes are already present in main. The PR serves for visibility, discussion, and CI checks.
- If you want the PR to contain code changes instead, we can create a feature branch with code changes and open a PR with diffs.

