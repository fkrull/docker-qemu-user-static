FROM ubuntu:artful

RUN apt-get update && \
    apt-get install -y qemu-user-static && \
    rm -rf /var/lib/apt/lists/*

ADD enable-fix-binary.sh /enable-fix-binary.sh
RUN bash /enable-fix-binary.sh && rm /enable-fix-binary.sh

ADD qemu-enable.sh /qemu-enable.sh
RUN chmod 0755 /qemu-enable.sh
ENTRYPOINT ["/qemu-enable.sh"]
