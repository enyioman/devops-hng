resource "aws_default_vpc" "default" {

}
//HTTP SERVER
//SG -> 80 TCP, 22 TCP, CIDR ["0.0.0.0/0"]

resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "http_server_sg"
  }
}

resource "aws_instance" "http_server" {
  ami                    = data.aws_ami.ubuntu-linux-2004.id
  key_name               = "tf-user"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id              = data.aws_subnets.default_subnets.ids[0]

  # connection {
  #   type        = "ssh"
  #   host        = self.public_ip
  #   user        = ""
  #   private_key = file(var.aws_key_pair)
  # }

  provisioner "remote-exec" {
    inline = [
      # "sudo apt install nginx -y", //install nginx
      # "sudo systemctl enable nginx",  //start nginx
      "sudo apt update -y",
      "sudo apt upgrade -y",
      "sudo curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -",
      "sudo apt-get install -y nodejs",
      "sudo apt install -y python3-pip",
      "sudo apt install -y software-properties-common",
      "sudo apt install -y python3-virtualenv",
      "sudo pip3 install -y django",
      "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'",
      "apt-cache policy docker-ce",
      "sudo apt install -y docker-ce",
      "sudo curl -L 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)' -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "git clone https://github.com/enyioman/devops-django-react-task.git"


      # "echo Slack: enyioman HNGi9 is at ${self.public_ip} | sudo tee /var/www/html/index.html" //copy a file 
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(var.aws_key_pair)
      agent       = false
    }
  }

}

