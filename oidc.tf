# 2. GitHub Actionsが一時的に取得するIAMロールの作成
resource "aws_iam_role" "github_actions" {
  name = "github-actions-terraform-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            # 実際のID付き表記（@330691509 や @1377957341）に対応した完璧なパターンマッチ
            "token.actions.githubusercontent.com:sub" = "repo:akira98-dev@*/terraform-aws-cicd@*:*"
          }
        }
      }
    ]
  })
}