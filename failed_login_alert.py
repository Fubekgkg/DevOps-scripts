import re
import os
import time

auth_log = "/var/log/auth.log"  
alert_threshold = 5 

def tail_log(filename):
    with open(filename, "r") as file:
        file.seek(0, os.SEEK_END)
        while True:
            line = file.readline()
            if line:
                yield line
            else:
                time.sleep(1)

def monitor_failed_logins():
    failed_attempts = {}
    
    for line in tail_log(auth_log):
        if "Failed password" in line:
            match = re.search(r"from (\d+\.\d+\.\d+\.\d+)", line)
            if match:
                ip = match.group(1)
                failed_attempts[ip] = failed_attempts.get(ip, 0) + 1
                
                if failed_attempts[ip] >= alert_threshold:
                    print(f"ALERT: {failed_attempts[ip]} failed login attempts from {ip}")
                    with open("/var/log/failed_login_alert.log", "a") as log_file:
                        log_file.write(f"ALERT: {failed_attempts[ip]} failed login attempts from {ip}\n")
                    
                    failed_attempts[ip] = 0  

if __name__ == "__main__":
    print("Monitoring failed login attempts...")
    monitor_failed_logins()