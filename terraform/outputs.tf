output "ec2_public_ip" {
  description = "EC2 ka public IP address"
  value       = aws_instance.scd_ec2.public_ip
}

output "s3_bucket_name" {
  description = "S3 bucket ka naam"
  value       = aws_s3_bucket.scd_bucket.bucket
}

output "ssh_command" {
  description = "EC2 se connect karne ki ready-made command"
  value       = "ssh -i ~/.ssh/scd-key ec2-user@${aws_instance.scd_ec2.public_ip}"
}