module.exports = {
  "dryRun": null,
  "extends": ["config:recommended", ":rebaseStalePrs"],
  "dependencyDashboard": false,
  "rebaseWhen": "conflicted",
  "suppressNotifications": ["prIgnoreNotification"],
  "username": "szymonrichert.pl bot",
  "gitAuthor": "szymonrichert.pl bot <bot@szymonrichert.pl>",
  "onboarding": false,
  "platform": "github",
  "repositories": ["szymonrychu/selfhosted-kubernetes-charts"],
  "customManagers": [
    {
      "customType": "regex",
      "fileMatch": ["(^|/)Chart\\.yaml$"],
      "matchStrings": [
        "#\\s?renovate: image=(?<depName>.*?)\\s?appVersion:\\s?\\\"?(?<currentValue>[\\w+\\.\\-]*)"
      ],
      "datasourceTemplate": "docker"
    },
    {
      "customType": "regex",
      "description": "Update image in values.yaml",
      "fileMatch": ["^values.yaml$"],
      "matchStringsStrategy": "combination",
      "matchStrings": [
        "image:\\s*\"(?<depName>.*)\"\\s*//",
        "tag:\\s*\"(?<currentValue>.*)\"\\s*//"
      ],
      "datasourceTemplate": "docker"
    }
  ],
  "packageRules": [
    {
      "description": "lockFileMaintenance",
      "matchUpdateTypes": [
        "pin",
        "digest",
        "patch",
        "minor",
        "major",
        "lockFileMaintenance"
      ],
      "dependencyDashboardApproval": false,
      "minimumReleaseAge": null
    },
    {
      "matchManagers": ["helm-requirements", "helm-values", "regex"],
      "postUpgradeTasks": {
        "commands": [
          "version=$(grep '^version:' {{{parentDir}}}/Chart.yaml | awk '{print $2}')\n            major=$(echo $version | cut -d. -f1)\n            minor=$(echo $version | cut -d. -f2)\n            patch=$(echo $version | cut -d. -f3)\n            minor=$(expr $minor + 1)\n            echo \"Replacing $version with $major.$minor.$patch\"\n            sed -i \"s/^version:.*/version: ${major}.${minor}.${patch}/g\" {{{parentDir}}}/Chart.yaml\n            cat {{{parentDir}}}/Chart.yaml\n            "
        ],
        "fileFilters": ["**/Chart.yaml"],
        "executionMode": "branch"
      }
    }
  ]
};