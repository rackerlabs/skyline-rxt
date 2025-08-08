FROM ubuntu:22.04
RUN apt update -y && apt install -y --no-install-recommends apt-utils \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
    gcc make nginx traceroute lsof iputils-ping vim git wget curl locales-all ssl-cert \
    python3 python3-pip python3-dev python3-venv python-dev-is-python3

RUN git clone https://github.com/rackerlabs/skyline-apiserver /opt/skyline-apiserver
RUN git clone https://github.com/rackerlabs/skyline-console /opt/skyline-console
RUN mkdir /opt/skyline-apiserver/skyline_console  
RUN tar -czvf /opt/skyline-apiserver/skyline_console/skyline_console.tar.gz -C /opt/skyline-console .
RUN pip install -U /opt/skyline-apiserver/skyline_console/skyline_console.tar.gz
RUN pip install -r /opt/skyline-apiserver/requirements.txt -chttps://releases.openstack.org/constraints/upper/2025.1

RUN pip install /opt/skyline-apiserver -chttps://releases.openstack.org/constraints/upper/2025.1 \
    && apt-get clean \
    && rm -rf ~/.cache/pip \
    && mkdir -p /etc/skyline /var/log/skyline /var/lib/skyline
EXPOSE 443
