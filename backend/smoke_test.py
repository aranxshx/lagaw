"""Run explicitly: one live call, saving only allowlisted evidence."""

import json
import logging
import sys
from datetime import UTC, datetime

from app.deepseek import ROOT, DeepSeekFailure, extract_preferences


def main() -> int:
    logging.disable(logging.CRITICAL)
    evidence = {
        "tested_at_utc": datetime.now(UTC).isoformat(),
        "test": "backend_deepseek_connectivity",
        "live_call": True,
    }
    try:
        result = extract_preferences(
            "I want a cheap and relaxing afternoon with coffee and photography spots."
        )
        evidence.update(status="passed", validated_response=result.model_dump())
        exit_code = 0
    except DeepSeekFailure as exc:
        evidence.update(status="failed", error_code=str(exc))
        exit_code = 1
    except Exception:  # noqa: BLE001 - Sanitize all unexpected errors in smoke-test evidence.
        # No exception text, request headers, raw responses, or traceback in evidence.
        evidence.update(status="failed", error_code="unexpected_backend_error")
        exit_code = 1
    target = ROOT / "docs" / "evidence" / "deepseek-smoke.json"
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(json.dumps(evidence, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(evidence, indent=2))
    return exit_code


if __name__ == "__main__":
    sys.exit(main())
