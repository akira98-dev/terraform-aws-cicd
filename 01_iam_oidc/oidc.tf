# 1. GitHub Actions用 OIDC アイデンティティプロバイダーの登録
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a2a851532f7743e4096741c41140a3f54244"]
}

# 2. GitHub Actionsが一時的に取得するIAMロールの作成
resource "aws_iam_role" "github_actions" {
  name = "github-actions-terraform-role"

  # GitHub Actionsからのアクセスのみを許可する信頼関係ポリシー（Trust Policy）
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
            # 実際のID付き表記（@330691509 や @1377957341）に対応したパターンマッチ
            "token.actions.githubusercontent.com:sub" = "repo:akira98-dev@*/terraform-aws-cicd@*:*"
          }
        }
      }
    ]
  })
}

# 3. IAMロールにTerraform実行用の権限（AdministratorAccess）を付与
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# 4. 作成されたIAMロールのARN（識別子）をターミナルに出力
output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions.arn
  description = "GitHub Actionsに設定するIAMロールのARN"
}