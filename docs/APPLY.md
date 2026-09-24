Apply (execution) model and safe usage

Overview

Windows-TechKit uses a two-phase model for module workflows:

- "prepare": modules provide a safe, non-destructive plan or status object. This is the default behavior and is used by the menu and automated checks.
- "apply": modules perform the actual actions (which may be destructive). Apply is explicitly requested and guarded by confirmation and an authorization mechanism.

Design goals

- Prevent accidental destructive operations during normal runs and CI.
- Make programmatic automation possible while keeping a deliberate consent mechanism for execution.
- Log and export the results of apply operations for audit.

Authorization and safety

- Apply requires one of:
  - A matching token provided via the environment variable TECHKIT_APPLY_TOKEN and supplied to Invoke-TechKitModule with -ApplyToken, or
  - The -Force flag to bypass the token check (use only when you understand the risks).

- In interactive menu flows the toolkit provides a confirmation helper (Confirm-And-Apply) that requires the user to type YES to use the environment token, or FORCE to bypass the token and apply immediately.

Environment variables

- TECHKIT_APPLY_TOKEN
  - If set, this string is used by interactive confirmation to authorize apply operations (Confirm-And-Apply uses it automatically when the user types YES).
  - For automated runs (CI or scripts), set TECHKIT_APPLY_TOKEN in the environment and pass the same token to Invoke-TechKitModule via -ApplyToken.

- TECHKIT_TESTING
  - Set to '1' in test environments to prevent ModuleExecutor from importing real module implementations. Used by the test suite to provide mocked functions.

How to run apply (examples)

- Non-interactive (automation) with token:

  $env:TECHKIT_APPLY_TOKEN = 's3cr3t'
  # Prepare only (no apply):
  Invoke-TechKitModule -Name Repair
  # Apply with token:
  Invoke-TechKitModule -Name Repair -Apply -ApplyToken 's3cr3t'

- Non-interactive forced apply (dangerous):

  Invoke-TechKitModule -Name Repair -Apply -Force

- Interactive via MainMenu

  1. Run Start-TechKit.ps1
  2. Choose the module (e.g., 4 - Repair) to prepare the plan
  3. When prompted, type YES to apply using TECHKIT_APPLY_TOKEN (if set), or type FORCE to bypass token.

Return object contract

Modules should return a structured object on prepare and apply with at minimum the following properties:

- Module: module name
- Timestamp: ISO timestamp of operation
- Status: 'Prepared' | 'Executed' | 'Failed'
- StatusDetail or Plan: module-specific details (e.g., summary, steps, inventory snapshot)
- AdminRequired: boolean indicating whether elevated privileges are necessary for apply
- Details: human-friendly string describing the result
- Execution (only on apply): object containing apply-time results
- ExecutionError (only on failure): textual error

Recommendations

- Always run Prepare first (default) and inspect the returned plan before applying.
- Store TECHKIT_APPLY_TOKEN in a secure secrets source for automation workflows and rotate it periodically.
- Configure centralized audit logging (append-only) or preserve the exported apply report files created by the toolkit.

Security note

Apply operations may execute OS-level utilities (sfc, dism, chkdsk, Export-WindowsDriver, etc.). Only run apply on systems where you have backups and permission to perform maintenance. Use -Force only when you explicitly accept the risk.

Troubleshooting

- If a module's apply fails due to missing privileges, re-run the apply with administrative elevation or using an account with required rights.
- To run tests safely, use TECHKIT_TESTING=1 to allow the tests to stub out implementations.

