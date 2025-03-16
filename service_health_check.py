import subprocess

def check_service_status(service_name):
    try:
        result = subprocess.run(["systemctl", "is-active", service_name], capture_output=True, text=True)
        return result.stdout.strip()
    except Exception as e:
        return f"Error checking service {service_name}: {str(e)}"

def main():
    services = ["nginx", "docker", "ssh", "mysql"]  
    
    print("Service Health Check Report:")
    for service in services:
        status = check_service_status(service)
        print(f"{service}: {status}")
    
    # Log results to a file
    with open("/var/log/service_health.log", "a") as log_file:
        for service in services:
            status = check_service_status(service)
            log_file.write(f"{service}: {status}\n")

if __name__ == "__main__":
    main()