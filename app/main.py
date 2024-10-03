import socket
import time

def resolve_nginx():
    try:
        nginx_service = "nginx.default.svc.cluster.local"
        print(f"Resolving {nginx_service}")
        ip = socket.gethostbyname(nginx_service)
        print(f"Nginx Service IP: {ip}")
    except socket.gaierror:
        print("Error resolving the DNS")

if __name__ == "__main__":
    while True:
        resolve_nginx()
        time.sleep(5)  # Resolve every 5 seconds

