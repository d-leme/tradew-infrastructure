
locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.cluster-node-role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.cluster.certificate_authority[0].data}
  name: ${aws_eks_cluster.cluster.arn}
contexts:
- context:
    cluster: ${aws_eks_cluster.cluster.arn}
    user: ${aws_eks_cluster.cluster.arn}
  name: ${aws_eks_cluster.cluster.arn}
current-context: ${aws_eks_cluster.cluster.arn}
kind: Config
preferences: {}
users:
- name: ${aws_eks_cluster.cluster.arn}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - --region
      - ${var.aws_region}
      - eks
      - get-token
      - --cluster-name
      - "${aws_eks_cluster.cluster.name}"
      command: aws
      env:
      - name: AWS_PROFILE
        value: ${var.aws_profile}
KUBECONFIG
}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "kubeconfig" {
  value = local.kubeconfig
}

resource "local_file" "kubecfg" {
  content  = local.kubeconfig
  filename = var.kubeconfig_path
}


resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 30"
  }
  depends_on = [local_file.kubecfg]
}
