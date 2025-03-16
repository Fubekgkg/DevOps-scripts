import re
import sys

LOG_FILE = "/var/log/syslog"
ERROR_PATTERN = r"error|failed|critical"

try:
    with open(LOG_FILE, "r") as log:
        for line in log:
            if re.search(ERROR_PATTERN, line, re.IGNORECASE):
                print(f"ALERT: {line.strip()}")
except FileNotFoundError:
    print(f"Log file {LOG_FILE} not found.")
    sys.exit(1)