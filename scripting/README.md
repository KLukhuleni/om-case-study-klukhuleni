# Terraform Validator Script

## Prerequisites

- **Bash**: The script is written in bash and requires a bash shell to run
- **jq**: The script uses `jq` for JSON parsing. Install it using:
  - Ubuntu: `sudo apt-get install jq`
  - macOS: `brew install jq`

## Usage

1. The script is saved as `script.sh` in the `scripting` folder
2. Make it executable:
   ```bash
   chmod +x script.sh
   ```
3. Run the script with a terraform plan JSON file:
   ```bash
   ./script.sh tfplan-1.json
   ```