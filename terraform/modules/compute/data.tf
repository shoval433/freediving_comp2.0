data "local_file" "user_data" {
  filename = "/home/ubuntu/task_3/modules/compute/user_data.txt"
}
data "local_file" "ami_role"{
  filename="/home/ubuntu/task_3/modules/compute/ami_role.txt"
}