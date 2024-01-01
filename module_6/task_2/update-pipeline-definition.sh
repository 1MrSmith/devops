display_jq_installation_instructions() {
  echo "JQ is not installed. Please install it using one of the following commands based on your platform:"
  echo "For Ubuntu/Debian:"
  echo "  sudo apt-get install jq"
  echo "For CentOS/RHEL:"
  echo "  sudo yum install jq"
  echo "For macOS (using Homebrew):"
  echo "  brew install jq"
  exit 1
}

if ! command -v jq &> /dev/null; then
  display_jq_installation_instructions
fi

if [ "$#" -lt 1 ]; then
  echo "Error: Path to pipeline definition JSON file is required."
  exit 1
fi

pipeline_file="$1"
configuration="production"
owner=""
branch="main"
poll_for_source_changes="false"

while [[ $# -gt 1 ]]; do
  case "$2" in
    --configuration)
      configuration="$3"
      shift 2
      ;;
    --owner)
      owner="$3"
      shift 2
      ;;
    --branch)
      branch="$3"
      shift 2
      ;;
    --poll-for-source-changes)
      poll_for_source_changes="$3"
      shift 2
      ;;
    *)
      echo "Error: Unknown parameter $2"
      exit 1
      ;;
  esac
done

if ! jq -e '.pipeline.version and .pipeline.source and .pipeline.source.owner and .pipeline.source.branch and .pipeline.actions' "$pipeline_file" &> /dev/null; then
  echo "Error: Necessary properties are not present in the JSON definition."
  exit 1
fi

jq --arg branch "$branch" --arg owner "$owner" \
 'del(.metadata) | .pipeline.version += 1 | .pipeline.source.owner = $owner | .pipeline.source.branch = $branch' "$pipeline_file" > "pipeline-$(date +"%Y%m%d%H%M%S").json"

echo "Pipeline definition updated successfully."
