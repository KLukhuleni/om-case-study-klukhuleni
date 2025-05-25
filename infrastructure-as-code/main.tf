

variable "file_indices" {
  description = "List of file indices to create"
  type        = list(number)
  default     = [0, 2, 3, 4]
}

resource "local_file" "foo" {
  for_each = { for idx in var.file_indices : idx => idx }
  content  = "${each.value}"
  filename = "file${each.value}.txt"
}