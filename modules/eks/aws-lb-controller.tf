resource "helm_release" "aws_load_balancer_controller" {
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"
  version          = "1.6.0"
  create_namespace = true
  wait             = false

  values = [
    <<-EOT
    replicaCount: 1

    clusterName: "${module.eks.cluster_name}"

    region: "${var.region}"
    vpcId: "${var.vpc_id}"

    serviceAccount:
      name: aws-load-balancer-controller
      annotations:
        eks.amazonaws.com/role-arn: "${module.aws_load_balancer_controller_irsa_role.iam_role_arn}"
    EOT
  ]

  depends_on       = [ module.eks ]
}
