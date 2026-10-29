#!/bin/bash
# Stop 훅 — 턴 종료 시 pytest를 돌려 CI와 같은 품질 게이트를 로컬에서 먼저 강제한다.
# 실패하면 exit 2 + stderr 로 Claude가 수정을 이어가게 한다.

# 이미 Stop 훅으로 이어진 턴이면 재차단하지 않는다(무한 루프 방지).
if [ "$(jq -r '.stop_hook_active // false')" = "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR" || exit 0
PYTEST=pytest
[ -x .venv/bin/pytest ] && PYTEST=.venv/bin/pytest

if ! OUTPUT=$($PYTEST -q -x 2>&1); then
  echo "테스트 실패. 아래 오류를 수정한 뒤 계속하라:" >&2
  echo "$OUTPUT" | tail -40 >&2
  exit 2
fi

exit 0
