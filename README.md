# Playing with Packer, Ansible, & Terraform

Packer a new AMI containing up to date OS and latest Docker

```shell
$ ( cd packer; packer build ubuntuanddocker.json )
```

Start new EC2 instance using above AMI

```shell
$ ( cd terraform; terraform init; terraform apply -auto-approve )
```
