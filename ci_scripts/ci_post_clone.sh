#!/bin/sh

# Xcode Cloud runs this script automatically after cloning the repository, before
# resolving Swift packages and building.
#
# The project uses the SwiftLint build tool plugin (SwiftLintPlugins). Build tool
# plugins require fingerprint validation that can only be approved interactively in
# Xcode ("Trust & Enable"). In a headless CI environment that prompt can't be
# answered, so the build fails with:
#   Plugin "SwiftLintBuildToolPlugin" from package "SwiftLintPlugins" must be enabled before it can be used
#
# Skipping the package-plugin (and macro) fingerprint validation for the CI Xcode
# lets the plugin run unattended. Note: "Validatation" is Apple's actual (misspelled)
# defaults key — do not "fix" it.

set -e

defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
