# Teacher progress server

This stack is separate from every student stack.

It creates an API Gateway HTTPS endpoint, one Lambda function, and one DynamoDB table. It does not create a public EC2 instance or open an SSH port.

## Install in the teacher CloudShell

```bash
curl -fsSL \
  https://raw.githubusercontent.com/ShinyaHaga0910/Introduction_CyberSecurity/main/2026/v1.4.1/teacher/install-teacher.sh \
  -o /tmp/jdu-install-teacher.sh
bash /tmp/jdu-install-teacher.sh --region us-east-1
```

Use the AWS region allowed by the Academy Lab. If the Lambda execution role is not named `LabRole`, add `--role-name ROLE_NAME`.

The installer prints the one-line student installation command. The registration key in that command is shared only for initial server registration. Do not save it in Git or send it through a public channel.

## Open the dashboard

Run this only in the teacher CloudShell:

```bash
jdu-dashboard
```

The command authenticates with the admin key stored in `~/.jdu-teacher/admin.key`. It prints a dashboard URL that expires after 30 minutes. Open that URL in a browser.

The HTTPS endpoint is internet reachable because the browser must reach it. The admin endpoint is protected by a random key kept in the teacher CloudShell. The browser receives only a short-lived session token.

## Data policy

The table stores a random server ID, EC2 instance metadata, the latest M0-M7 scores, and timestamps. It does not store student names or email addresses. Use `jdu-progress id` on a student server to display its server ID.

This is a formative progress view. It is not a tamper-proof examination system because students have administrative access to their own lab server.
