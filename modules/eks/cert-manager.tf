resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  version          = "1.14.2"
  create_namespace = true
  wait             = false

  values = [
    <<-EOT
    installCRDs: true

    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: "${aws_iam_role.dns_manager.arn}"
    EOT
  ]

  depends_on       = [ module.eks ]
}
