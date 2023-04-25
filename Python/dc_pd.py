# Created 25.02.2023
import os

def install_docker():
    os.system('sudo dnf -y install dnf-plugins-core')
    os.system('sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo')
    os.system('sudo dnf install docker-ce docker-ce-cli containerd.io')
    os.system('sudo systemctl start docker')
    os.system('sudo systemctl enable docker')

def install_podman():
    os.system('sudo dnf -y install podman')

print("Please choose an option:")
print("1. Install Docker")
print("2. Install Podman")
print("3. Exit script")

choice = input("Please Select 1, 2 or 3. ")

match choice:
    case 1:
        install_docker()
        print("Docker installed successfully!")
    case 2:
        install_podman()
        print("Podman installed successfully!")
