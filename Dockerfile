FROM ubuntu:jammy as base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential ansible sudo && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base as main
ARG TAGS

RUN addgroup --gid 1000 astral
RUN adduser --gecos astral --uid 1000 --gid 1000 --disabled-password astral
RUN adduser astral sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
ENV PATH="$PATH:/usr/games"

USER astral
WORKDIR /home/astral

FROM main
COPY --chown=astral:astral . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml --become"]

