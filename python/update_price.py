import argparse
import os
from pathlib import Path
from typing import Any

import requests

REQUEST_TIMEOUT_SECONDS = 60


def build_api_url(api_host: str) -> str:
    """Build the ABCP upload endpoint, accepting host-only or full URL input."""
    host = api_host.strip().rstrip("/")
    if host.startswith("http://") or host.startswith("https://"):
        base = host
    else:
        base = f"https://{host}"
    return f"{base}/cp/distributor/pricelistUpdate"


def update_price(
    distributor_id: str,
    file_path: Path,
    file_type_id: str,
    timeout: int = REQUEST_TIMEOUT_SECONDS,
) -> int:
    """Upload a price list file and print the API result."""
    api_username = os.getenv("API_USERNAME")
    api_userpsw = os.getenv("API_USERPSW")
    api_host = os.getenv("API_HOST")

    if not all([api_username, api_userpsw, api_host]):
        print("Error: API_USERNAME, API_USERPSW, and API_HOST must be set.")
        return 2

    if not file_path.is_file():
        print(f"Error: file does not exist: {file_path}")
        return 2

    url = build_api_url(api_host)
    data = {
        "userlogin": api_username,
        "userpsw": api_userpsw,
        "distributorId": distributor_id,
        "fileTypeId": file_type_id,
    }

    try:
        with file_path.open("rb") as upload_file:
            response = requests.post(
                url,
                files={"uploadFile": upload_file},
                data=data,
                timeout=timeout,
            )
        response.raise_for_status()
    except requests.RequestException as exc:
        print(f"Request failed: {exc}")
        return 1

    try:
        result: dict[str, Any] = response.json()
    except ValueError:
        print(f"Error: non-JSON response from server: {response.text}")
        return 1

    error_message = str(result.get("errorMessage") or "").strip()
    if error_message:
        print(f"Error: {error_message}")
        return 1

    message = str(result.get("message") or "").strip()
    if message:
        print(message)
    else:
        print("Upload completed, but response message is empty.")
    return 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Upload a price list to the ABCP pricelistUpdate API."
    )
    parser.add_argument("distributor_id", help="Distributor ID")
    parser.add_argument("file_path", type=Path, help="Path to the price list file")
    parser.add_argument(
        "--incremental",
        action="store_true",
        help="Send incremental update (fileTypeId=4). Default is full upload (fileTypeId=1).",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=REQUEST_TIMEOUT_SECONDS,
        help=f"HTTP request timeout in seconds (default: {REQUEST_TIMEOUT_SECONDS}).",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    file_type_id = "4" if args.incremental else "1"
    return update_price(
        distributor_id=args.distributor_id,
        file_path=args.file_path,
        file_type_id=file_type_id,
        timeout=args.timeout,
    )


if __name__ == "__main__":
    raise SystemExit(main())
