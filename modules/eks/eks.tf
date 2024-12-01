module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name        = "${var.app_name}-eks-${var.environment}"
  cluster_version     = var.eks_cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
      resolve_conflicts        = "OVERWRITE"
    }
  }

  vpc_id                                 = var.vpc_id
  subnet_ids                             = var.private_subnets
  control_plane_subnet_ids               = var.private_subnets

  enable_irsa                            = true

  cluster_enabled_log_types = []
  cloudwatch_log_group_retention_in_days = 30

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = [var.instance_type]
    disk_size      = 50
  }

  eks_managed_node_groups = {
    "${var.app_name}-eks-node-${var.environment}" = {
      min_size        = 1
      max_size        = 1
      desired_size    = 1

      instance_types  = [var.instance_type]
      capacity_type   = "SPOT"
      ami_type        = "AL2023_ARM_64_STANDARD"

      iam_role_name   = "${var.app_name}-eks-node-${var.environment}"

      iam_role_additional_policies = {
        "AmazonSSMManagedInstanceCore" = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }

  node_security_group_tags = {
    "karpenter.sh/discovery" = "${var.app_name}-eks-${var.environment}"
  }

  tags = {
    Terraform                  = "true"
    Environment                = var.environment
  }
}

module "eks-auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "20.24.0"

  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::389520016828:role/AWSReservedSSO_AdministratorAccess_15368246cd6d923e"
      username = "AWSReservedSSO_AdministratorAccess_15368246cd6d923e:{{SessionName}}"
      groups   = ["system:masters"]
    },
    {
      rolearn  = module.eks_admins_iam_role.iam_role_arn
      username = module.eks_admins_iam_role.iam_role_name
      groups   = ["system:masters"]
    }
  ]

  depends_on = [  
    module.eks
  ]
}
