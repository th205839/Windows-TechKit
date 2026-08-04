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

## Portable USB / pendrive usage
To use the toolkit from a USB drive as a technician deployment kit:

1. Copy the repository contents to the pendrive, or use the prepared portable folder under [Windows-TechKit-Portable](Windows-TechKit-Portable).
2. For a bootable-style deployment layout, use the folder [portable-usb](portable-usb).
3. Open PowerShell in the copied folder.
4. Run:

```powershell
./Start-TechKit.ps1
```

If you want to prepare a target USB drive from Windows PowerShell:

```powershell
./portable-usb/Prepare-USB.ps1 -DriveLetter E:
```

This creates a Windows-TechKit folder on the target drive and prepares a structure that can be used alongside Windows 10/11 installation media.

### Windows 10/11 installation scenario
- Place your licensed Windows 10 or Windows 11 ISO files in [portable-usb/isos](portable-usb/isos).
- Use the USB to boot the target machine.
- Start the Windows setup from the USB.
- Use the same USB to run diagnostics, repairs, backup/restore operations, and reporting tools.

## Documentation
- docs/ARCHITECTURE.md
- docs/INTERNAL_REPORT.md
