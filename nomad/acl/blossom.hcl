description = "policy for blossom services"

# allow all transitional policy
namespace "blossom" {
  policy       = "deny"
  capabilities = ["list-jobs", "parse-job", "read-job", "submit-job"]
}
