variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "description" {
  description = "Lambda description"
  type        = string
  default     = "Lambda function"
}

variable "handler" {
  description = "Lambda handler"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
}

variable "source_path" {
  description = "Path to Lambda source code"
  type        = string
}

variable "tags" {
  description = "Tags for Lambda"
  type        = map(string)
  default     = {}
}