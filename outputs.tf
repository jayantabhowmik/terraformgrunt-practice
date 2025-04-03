output "private_key_path" {
  value = local_file.private_key.filename
}

output "instance_public_ip" {
  value = module.ec2_instance.public_ip
}
