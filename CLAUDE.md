# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Configuration

This is a Quickshell configuration - a modern, flexible shell replacement built on Qt/QML. Quickshell uses QML for creating desktop shells and panels for Linux window managers like Hyprland.

## Running the Shell

- **Start the shell**: `quickshell` (assumes default config in ~/.config/quickshell/)
- **Kill existing instance**: `quickshell kill`
- **List running instances**: `quickshell list`
- **View logs**: `quickshell log`

## Architecture Overview

### Core Structure
- **shell.qml**: Main entry point that initializes the shell and creates screen variants
- **ScreenState.qml**: Per-screen state management, creates bars, notifications, OSD, and monitor rounding
- **config/**: Configuration management and global settings
  - **Config.qml**: Main configuration singleton with themes, settings, and utilities
  - **Globals.qml**: Animation curves, timing constants, and system detection

### Component Organization
- **bar/**: Main panel components (Clock, Battery, Workspaces, Mpris, etc.)
- **leftmenu/**: Left-side popup menu with system settings and controls
- **rightmenu/**: Right-side menu with system stats, power options, and updates
- **commonwidgets/**: Reusable UI components (buttons, sliders, switches, etc.)
- **state/**: State management singletons for various system services
- **popup/**: Popup window management system
- **settings/**: Configuration panel components
- **notifs/**: Notification system

### Key Features
- **Multi-monitor support**: Configurable monitor inclusion/exclusion
- **Theming**: Material Design colors via matugen.json integration
- **IPC communication**: Built-in handlers for external control
- **Hyprland integration**: Workspace management and window state tracking
- **System integration**: Audio, brightness, networking, Bluetooth controls

### Configuration System
The shell uses JSON-based configuration stored in:
- **config.json**: Main settings (bar layout, fonts, panels, etc.)
- **account.json**: User account information
- **misc.json**: Miscellaneous settings and state
- **matugen.json**: Material Design color theme

### State Management
Each major system component has its own state singleton in the `state/` directory, managing services like:
- System information and stats
- Audio (PipeWire/PulseAudio)
- Brightness control
- Network and WiFi
- Bluetooth
- MPRIS media control
- Notifications

## Development Guidelines

- Follow QML/QtQuick conventions and property binding patterns
- Use existing state singletons rather than creating new ones
- Leverage the commonwidgets for consistent UI elements
- Configuration changes should update the appropriate JSON files
- Test on multiple monitors if making panel-related changes