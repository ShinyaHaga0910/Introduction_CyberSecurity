# Teacher progress server

This stack is separate from every student stack.

It creates an API Gateway HTTPS endpoint, one Lambda function, and one DynamoDB table. It does not create a public EC2 instance or open an SSH port.

## Install in the teacher CloudShell

```bash
curl -fsSL \
  https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.0.0/teacher/install-teacher.sh \
  -o /tmp/jdu-install-teacher.sh
bash /tmp/jdu-install-teacher.sh --region us-east-1
```

Use the AWS region allowed by the Academy Lab. If the Lambda execution role is not named `LabRole`, add `--role-name ROLE_NAME`.

The installer prints the one-line student installation command. The current progress endpoint and registration key are fixed in the v1.0.0 student installer, so students do not enter either value.

## Open the dashboard

Run this only in the teacher CloudShell:

```bash
jdu-dashboard
```

The command authenticates with the admin key stored in `~/.jdu-teacher/admin.key`. It prints a dashboard URL that expires after 30 minutes. Open that URL in a browser. The admin key remains private. The fixed registration key is only a public course bootstrap value and does not open the dashboard.

The HTTPS endpoint is internet reachable because the browser must reach it. The admin endpoint is protected by a random key kept in the teacher CloudShell. The browser receives only a short-lived session token.

The fixed registration key is public by design. It cannot open the teacher dashboard, but anyone who knows the endpoint and key can create a new anonymous server record. Therefore, use this dashboard for formative progress only, not identity verification or formal grading.

## Data policy

The table stores a random server ID, EC2 instance metadata, the latest guided P1-P6 and challenge M0-M7 scores, and timestamps. P6 and M6 store Ubuntu (2 checks) and CloudShell (4 checks) separately. The dashboard counts each complete only when both parts are complete. It does not store student names or email addresses. Use `jdu-progress id` on a student server to display its server ID.

P1-P6 are checked on each student's Ubuntu instance by `jdu-check P1` through `jdu-check P6`; P6 also requires `jdu-check P6` in CloudShell. Each run submits its latest PASS count over HTTPS. The teacher stack receives and displays those results; it does not independently log in to or re-check student instances. The student CloudFormation stack already installs the guided fixtures and check scripts, so no separate teacher-side CloudFormation stack is needed for P1-P6 beyond this progress server.

This is a formative progress view. It is not a tamper-proof examination system because students have administrative access to their own lab server.
