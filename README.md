# Windows-TechKit

Windows-TechKit is a professional technician toolkit for Windows maintenance, diagnostics, and support operations.

## Current capabilities
- Professional launcher and startup pipeline
- Runtime and health checks
- Logging and reporting
- Dashboard and menu flow
- Modular architecture for repair, network, backup, drivers, updates, and support workflows
- Client and maintenance history support
- Inventory snapshot collection
- USB layout scaffolding for bootable maintenance media
- Operational diagnostics, maintenance workflows, and report export

## Structure
- core/launcher, runtime, dashboard, module-manager, reporting, settings-manager, branding, health, client, usb
- modules/Hardware, Network, Repair, Drivers, Backup, Recovery, Security, Inventory, Support, Tweaks, Updates

## Usage
Run the toolkit from the repository root:

```powershell
./Start-TechKit.ps1
```

For non-interactive validation:

```powershell
./Start-TechKit.ps1 -Mode noninteractive
```

## Documentation
- docs/ARCHITECTURE.md
- docs/INTERNAL_REPORT.md
