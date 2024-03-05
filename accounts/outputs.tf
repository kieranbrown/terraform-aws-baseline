output "accounts" {
  value = {
    for key, account in aws_organizations_account.this : key => {
      id = sensitive(account.id)
    }
  }

  sensitive = true
}
