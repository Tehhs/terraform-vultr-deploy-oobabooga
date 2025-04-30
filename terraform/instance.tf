resource "vultr_instance" "my_instance" {
    label       = "sample-server"
    plan        = "vcg-a100-12c-120g-80vram"
    region      = "nrt"
    os_id       = "2284"
    enable_ipv6 = true

    user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y git wget curl python3 python3-pip ca-certificates

              # Add Docker's official GPG key
              sudo install -m 0755 -d /etc/apt/keyrings
              sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
              sudo chmod a+r /etc/apt/keyrings/docker.asc

              # Add the Docker repository to Apt sources
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
              focal stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update

              # Install Docker and related plugins
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

              # Start and enable Docker service
              sudo systemctl start docker
              sudo systemctl enable docker

              # Clone the oobabooga repository
              git clone https://github.com/oobabooga/text-generation-webui.git /opt/oobabooga

              # Navigate to the repository directory
              cd /opt/oobabooga

              # Copy configuration files
              cp user_data/CMD_FLAGS.txt docker/nvidia/CMD_FLAGS.txt
              cp docker/.env.example docker/nvidia/.env

              # Build and run the Docker Compose setup
              cd docker/nvidia
              docker compose up --build -d
              EOF
}