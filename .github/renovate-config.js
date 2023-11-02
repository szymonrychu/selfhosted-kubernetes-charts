module.exports = {
    dryRun: false,
    username: 'szymonrichert.pl bot',
    gitAuthor: 'szymonrichert.pl bot <bot@szymonrichert.pl>',
    onboarding: false,
    platform: 'github',
    repositories: [
      'szymonrychu/charts',
    ],
    regexManagers: [
      {
          fileMatch: ['(^|/)Chart\\.yaml$'],
          matchStrings: [
              '#\\s?renovate: image=(?<depName>.*?)\\s?appVersion:\\s?\\"?(?<currentValue>[\\w+\\.\\-]*)',
          ],
          datasourceTemplate: 'docker',
      },
      {
        description: "Update image in values.yaml",
        fileMatch: ["^values.yaml$"],
        matchStringsStrategy: "combination",
        matchStrings: [
          "image:\\s*\"(?<depName>.*)\"\\s*//",
          "tag:\\s*\"(?<currentValue>.*)\"\\s*//"
        ],
        datasourceTemplate: 'docker',
      },
    ],
    packageRules: [
      {
        description: 'lockFileMaintenance',
        matchUpdateTypes: [
          'pin',
          'digest',
          'patch',
          'minor',
          'major',
          'lockFileMaintenance',
        ],
        dependencyDashboardApproval: false,
        stabilityDays: 0,
      },
      {
        matchManagers: [
          'helm-requirements',
          'helm-values',
          'regex',
        ],
        postUpgradeTasks: {
          commands: [
            `version=$(grep '^version:' {{{parentDir}}}/Chart.yaml | awk '{print $2}')
            major=$(echo $version | cut -d. -f1)
            minor=$(echo $version | cut -d. -f2)
            patch=$(echo $version | cut -d. -f3)
            minor=$(expr $minor + 1)
            echo "Replacing $version with $major.$minor.$patch"
            sed -i "s/^version:.*/version: $\{major\}.$\{minor\}.$\{patch\}/g" {{{parentDir}}}/Chart.yaml
            cat {{{parentDir}}}/Chart.yaml
            `
          ],
          fileFilters: [
            '**/Chart.yaml',
          ],
          executionMode: 'branch',
        },
      },
    ],
  };