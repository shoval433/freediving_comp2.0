data "local_file" "user_data" {
  filename = "./user_data.txt"
}
data "local_file" "ami_role"{
  filename="./ami_role.txt"
}
