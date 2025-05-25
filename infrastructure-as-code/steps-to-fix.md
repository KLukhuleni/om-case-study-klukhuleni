# Steps to Remove the 2nd Resource (index 1) Without Affecting Others

### Step 1: Create a backup of current state
```bash
cp terraform.tfstate terraform.tfstate.backup-before-changes
```

### Step 2: Modify the Terraform configuration
Convert the resource from using `count` to `for_each` with explicit file indices, excluding index 1:

### Step 3: Import existing resources to new for_each structure
Use `terraform state mv` to move each resource from count-based to for_each-based addressing:

```bash
# Move the resources we want to keep
terraform state mv 'local_file.foo[0]' 'local_file.foo["0"]'
terraform state mv 'local_file.foo[2]' 'local_file.foo["2"]'
terraform state mv 'local_file.foo[3]' 'local_file.foo["3"]'
terraform state mv 'local_file.foo[4]' 'local_file.foo["4"]'
```

### Step 4: Remove the unwanted resource from state
```bash
terraform state rm 'local_file.foo[1]'
```

### Step 5: Verify the plan shows no changes
```bash
terraform plan
```
This should show No changes

### Step 6: Apply to confirm no changes
```bash
terraform apply
```