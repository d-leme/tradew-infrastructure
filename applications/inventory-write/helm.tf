module "iam_user" {
  version = "~> 3.14.0"
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"

  name = "inventory_read_iam"

  create_iam_user_login_profile = false
  create_iam_access_key         = true
}

resource "aws_iam_user_policy" "inventory_read_policy" {
  name = "inventory-read-policy"
  user = module.iam_user.this_iam_user_name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Action": [
              "sns:*",
              "sqs:*"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
    ]
}
EOF
}

output "this_iam_access_key_id" {
  description = "The access key ID"
  value       = module.iam_user.this_iam_access_key_id
}

output "this_iam_access_key_secret" {
  description = "The access key secret"
  value       = module.iam_user.this_iam_access_key_secret
}

resource "kubernetes_secret" "inventory-read-application-credentials" {
  metadata {
    name = "inventory-read-application-credentials"
  }

  data = {
    "credentials" = <<EOF
    [default]
    region = us-west-2
    aws_access_key_id = ${module.iam_user.this_iam_access_key_id}
    aws_secret_access_key = ${module.iam_user.this_iam_access_key_secret}
    EOF
  }
}

resource "null_resource" "delay-secrets" {
  provisioner "local-exec" {
    command = "sleep 30"
  }
  depends_on = [kubernetes_secret.inventory-read-application-credentials]
}


resource "helm_release" "inventory-read" {
  name          = "inventory-read"
  chart         = "./eks/charts/application-template"
  max_history   = 3
  recreate_pods = true
  force_update  = true

  depends_on = [
    null_resource.delay-secrets
  ]

  values = [
    "${file("./applications/inventory-read-values.yaml")}"
  ]
}
