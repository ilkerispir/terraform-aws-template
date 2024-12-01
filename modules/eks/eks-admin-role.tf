module "allow_eks_access_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.28"

  name          =  "${var.app_name}-${var.environment}-eks-policy"

  create_policy = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

module "eks_admins_iam_role" {
  source                  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version                 = "~> 5.28"

  role_name               = "${var.app_name}-${var.environment}-eks-role"

  create_role             = true
  role_requires_mfa       = false

  custom_role_policy_arns = [module.allow_eks_access_iam_policy.arn]

  trusted_role_arns = [
    "arn:aws:iam::389520016828:role/sandbox_buddy_role",
    "arn:aws:sts::389520016828:assumed-role/sandbox_buddy_role/Buddy"
  ]
}

module "allow_assume_eks_admins_iam_policy" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version       = "~> 5.28"

  name          = "${var.app_name}-${var.environment}-eks-admin-policy"
  create_policy = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = module.eks_admins_iam_role.iam_role_arn
      },
    ]
  })
}
