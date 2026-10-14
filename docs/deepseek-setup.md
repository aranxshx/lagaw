# DeepSeek backend connectivity check

1. Install Python 3.12 or newer. Open PowerShell in the repository root.
2. Create an isolated environment and install the backend dependencies:

   ```powershell
   python -m venv .venv
   .\.venv\Scripts\python.exe -m pip install -r backend/requirements.txt
   ```

3. Edit the root `.env` locally. Preserve any other settings, and add:

   ```dotenv
   DEEPSEEK_API_KEY=<your DeepSeek API key>
   DEEPSEEK_MODEL=deepseek-flash
   DEEPSEEK_TIMEOUT_MS=30000
   ```

   Never paste the real key into chat, screenshots, source, or terminal commands.
   Only the root `.env` is loaded. Process environment variables take precedence.

4. Run offline failure handling checks, then the explicit live test:

   ```powershell
   Push-Location backend
   ..\.venv\Scripts\python.exe -m unittest -v
   ..\.venv\Scripts\python.exe smoke_test.py
   Pop-Location
   ```

5. Confirm exit code zero and `"status": "passed"` in
   `docs/evidence/deepseek-smoke.json`. Only a passed live run establishes
   connectivity. The evidence contains a timestamp and schema-validated values,
   or a safe failure code. It excludes keys and raw provider responses.

Missing credentials, invalid input/configuration, authentication errors, rate
limits, network failures, timeouts, and invalid output have safe failure codes.
The future API layer should map these codes to HTTP responses and offer the
standard trip form when extraction is unavailable. This script is a backend
connectivity check; it does not expose a public API endpoint.

CI runs offline tests only. The live test must be invoked explicitly and can
consume API quota. Do not enable HTTP debug logging with real credentials.

References: [HTTPX documentation](https://www.python-httpx.org/)
and [structured output](https://api-docs.deepseek.com/guides/json_mode/).
