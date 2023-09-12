FROM jenkins/jenkins:lts

USER root

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    zip \
    git \
    python3 \
    python3-pip \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common

# Install Docker CLI
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip ./aws

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod +x get_helm.sh && \
    ./get_helm.sh && \
    rm -f get_helm.sh

# Install Terraform
RUN curl -fsSL -o terraform.zip https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    rm -f terraform.zip

# Install Docker Compose
RUN curl -fsSL -o /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" && \
    chmod +x /usr/local/bin/docker-compose

# Install kubectl
RUN curl -fsSL -o /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x /usr/local/bin/kubectl


# Download and install the ArgoCD CLI
RUN curl -LO https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 && \
    chmod +x argocd-linux-amd64 && \
    mv argocd-linux-amd64 /usr/local/bin/argocd


# Switch back to the Jenkins user
USER jenkins

# Set the default command for Jenkins
CMD ["/usr/local/bin/jenkins.sh"]
