#!/usr/bin/env bash
# Deletes every MR note + inline discussion note whose body contains the
# pronto-rubycritic brand URL, so the MR shows only the latest run's output.
#
# Required env:
#   CI_API_V4_URL                       (provided by GitLab CI)
#   CI_PROJECT_ID                       (provided by GitLab CI)
#   CI_MERGE_REQUEST_IID                (provided by GitLab CI on MR pipelines)
#   PRONTO_GITLAB_API_PRIVATE_TOKEN     (project CI variable with api scope)
set -euo pipefail

BRAND='https://github.com/Rishabhs343/custom-pronto-gem'

if [ -z "${CI_MERGE_REQUEST_IID:-}" ]; then
  echo "Not an MR pipeline — skipping cleanup."
  exit 0
fi

echo "Cleaning up any previous pronto-rubycritic output on MR !${CI_MERGE_REQUEST_IID}…"

api() {
  curl --silent --fail-with-body \
    --header "PRIVATE-TOKEN: ${PRONTO_GITLAB_API_PRIVATE_TOKEN}" \
    "$@"
}

# 1. Conversation-level MR notes
for note_id in $(api "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/merge_requests/${CI_MERGE_REQUEST_IID}/notes?per_page=100" \
                   | jq -r --arg brand "$BRAND" \
                       '.[] | select(.body | contains($brand)) | .id'); do
  echo "  - delete note #${note_id}"
  api --request DELETE \
      "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/merge_requests/${CI_MERGE_REQUEST_IID}/notes/${note_id}" \
      >/dev/null || true
done

# 2. Inline diff discussions (pronto's gitlab_mr formatter uses these)
for disc_id in $(api "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/merge_requests/${CI_MERGE_REQUEST_IID}/discussions?per_page=100" \
                   | jq -r --arg brand "$BRAND" \
                       '.[] | select(.notes[0].body | contains($brand)) | .id'); do
  # A discussion is deleted by deleting each of its notes.
  for note_id in $(api "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/merge_requests/${CI_MERGE_REQUEST_IID}/discussions/${disc_id}" \
                     | jq -r '.notes[].id'); do
    echo "  - delete discussion ${disc_id} note #${note_id}"
    api --request DELETE \
        "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/merge_requests/${CI_MERGE_REQUEST_IID}/notes/${note_id}" \
        >/dev/null || true
  done
done

echo "Cleanup complete."
