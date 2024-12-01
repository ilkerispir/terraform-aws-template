module "ebs_csi_irsa_role" {
  source                            = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                           = "~> 5.28"

  role_name                         = "${var.app_name}-${var.environment}-ebs-csi"
  attach_ebs_csi_policy             = true

  oidc_providers = {
    ex = {
      provider_arn                  = module.eks.oidc_provider_arn
      namespace_service_accounts    = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

module "aws_load_balancer_controller_irsa_role" {
  source                                  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                 = "~> 5.28"

  role_name                               = "${var.app_name}-${var.environment}-eks-lb-role"
  attach_load_balancer_controller_policy  = true

  oidc_providers = {
    ex = {
      provider_arn                        = module.eks.oidc_provider_arn
      namespace_service_accounts          = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

# Optional: Used for the DNS-01 challenge.
data "aws_iam_policy_document" "dns_manager" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:cert-manager:cert-manager"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "dns_manager" {
  assume_role_policy = data.aws_iam_policy_document.dns_manager.json
  name               = "${var.app_name}-${var.environment}-dns-manager"
}

resource "aws_iam_policy" "dns_manager" {
  name = "dns_manager"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "route53:GetChange",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:route53:::change/*"
      },
      {
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:route53:::hostedzone/*"
      },
      {
        Action = [
          "route53:ListHostedZonesByName"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dns_manager" {
  policy_arn = aws_iam_policy.dns_manager.arn
  role       = aws_iam_role.dns_manager.name
}
