# CI/CD Integration: GitHub Actions

## Overview

This project includes a **GitHub Actions workflow** that:
- Runs XCUITest suite on every push/PR
- Tests on iOS simulator (iPhone 15, iOS 17.5)
- Generates test reports
- Uploads artifacts for analysis

## Workflow File

Location: `.github/workflows/xcode-tests.yml`

## Workflow Configuration

### Triggers

The workflow runs on:

```yaml
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 9 * * *'  # Daily at 9 AM UTC
```

### Environment Setup

```yaml
jobs:
  test:
    runs-on: macos-latest-xlarge
    
    strategy:
      matrix:
        device: ["iPhone 15"]
        os: ["17.5"]
```

## Running Tests in CI

### Basic Test Run

```bash
xcodebuild test \
  -scheme SampleApp \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5'
```

### Generate Test Report

```bash
xcodebuild test \
  -scheme SampleApp \
  -resultBundlePath test-results.xcresult \
  -resultBundleVersion 3
```

## Workflow Steps

### 1. Setup

```yaml
- uses: actions/checkout@v3

- name: Select Xcode version
  run: sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### 2. Install Dependencies

```yaml
- name: Install dependencies
  run: |
    pip install --upgrade pip
    # Add any other dependencies here
```

### 3. Build

```yaml
- name: Build App
  run: |
    xcodebuild build \
      -scheme SampleApp \
      -configuration Debug \
      -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5'
```

### 4. Run Tests

```yaml
- name: Run XCUITests
  run: |
    xcodebuild test \
      -scheme SampleApp \
      -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5' \
      -resultBundlePath test-results.xcresult \
      -resultBundleVersion 3
```

### 5. Upload Artifacts

```yaml
- name: Upload Test Results
  if: always()
  uses: actions/upload-artifact@v3
  with:
    name: xctest-results
    path: test-results.xcresult
```

## Complete Workflow Example

See `.github/workflows/xcode-tests.yml` in repository for full configuration.

```yaml
name: XCUITest CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 9 * * *'

jobs:
  test:
    runs-on: macos-latest-xlarge
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Select Xcode
      run: sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    
    - name: Build
      run: |
        xcodebuild build \
          -scheme SampleApp \
          -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5'
    
    - name: Test
      run: |
        xcodebuild test \
          -scheme SampleApp \
          -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5' \
          -resultBundlePath test-results.xcresult
    
    - name: Upload Results
      if: always()
      uses: actions/upload-artifact@v3
      with:
        name: test-results
        path: test-results.xcresult
```

## Viewing Test Results

### In GitHub UI

1. Go to Actions tab
2. Click workflow run
3. Scroll to "Artifacts" section
4. Download `test-results` zip

### Locally

```bash
# Download artifacts
gh run download <RUN_ID> -n test-results

# Open in Xcode
open test-results.xcresult
```

## Debugging CI Failures

### Enable Verbose Output

```yaml
- name: Run Tests with Verbose
  run: |
    xcodebuild test \
      -scheme SampleApp \
      -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5' \
      -verbose \
      -resultBundlePath test-results.xcresult
```

### Collect Logs

```yaml
- name: Collect Logs
  if: failure()
  run: |
    mkdir -p logs
    cp ~/Library/Logs/DiagnosticMessages/*.log logs/ || true
    ls -la logs/
```

### Upload Logs on Failure

```yaml
- name: Upload Logs
  if: failure()
  uses: actions/upload-artifact@v3
  with:
    name: xcode-logs
    path: logs/
```

## Performance Optimization

### Parallel Test Execution

```yaml
- name: Run Tests in Parallel
  run: |
    xcodebuild test \
      -scheme SampleApp \
      -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5' \
      -parallel-testing-enabled YES \
      -maximum-concurrent-test-simulator-destinations 4
```

### Cache Dependencies

```yaml
- name: Cache CocoaPods
  uses: actions/cache@v3
  with:
    path: Pods/
    key: ${{ runner.os }}-pods-${{ hashFiles('**/Podfile.lock') }}
    restore-keys: |
      ${{ runner.os }}-pods-
```

## Email Notifications

Add to `.github/workflows/xcode-tests.yml`:

```yaml
- name: Send Email on Failure
  if: failure()
  uses: davisben/ghaction-smtp@v1
  with:
    server_address: smtp.gmail.com
    server_port: 465
    username: ${{ secrets.EMAIL_USERNAME }}
    password: ${{ secrets.EMAIL_PASSWORD }}
    subject: "XCUITest Failed in ${{ github.repository }}"
    body: "Tests failed on ${{ github.ref }}. Check details: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
    to: "your-email@example.com"
```

## Slack Notifications

```yaml
- name: Slack Notification
  if: always()
  uses: slackapi/slack-github-action@v1
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK }}
    payload: |
      {
        "text": "XCUITest ${{ job.status }}",
        "blocks": [
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "*Test Results*\nStatus: ${{ job.status }}\nRun: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
            }
          }
        ]
      }
```

## Troubleshooting

### Simulator Not Starting

```bash
# Reset simulator
xcrun simctl erase all
xcrun simctl boot "iPhone 15"
```

### Build Timeout

Increase timeout in workflow:

```yaml
- name: Run Tests
  timeout-minutes: 30
  run: xcodebuild test ...
```

### Code Signing Issues

```yaml
- name: Disable Code Signing
  run: |
    xcodebuild test \
      -scheme SampleApp \
      -configuration Debug \
      -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5' \
      -skipPackagePluginValidation
```

## Best Practices

1. **Run tests on every push** - catch issues early
2. **Use matrix testing** - test multiple device/OS combinations
3. **Set appropriate timeouts** - prevent hanging jobs
4. **Upload artifacts** - enable post-run analysis
5. **Send notifications** - inform team of results
6. **Cache dependencies** - speed up workflow
7. **Keep logs** - aid debugging

## Next Steps

1. Set up GitHub secrets for email/Slack
2. Configure notification preferences
3. Add code coverage reporting
4. Set up performance tracking

See main `README.md` for related CI/CD info.
