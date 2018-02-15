FROM ubuntu:17.10
RUN apt-get update && \
    apt-get install -y \
        python3 \
        qemu-user-static

COPY scripts/convert-formats.py /convert-formats.py
RUN mkdir -p /formats && \
    python3 /convert-formats.py /var/lib/binfmts /formats

COPY scripts/qemu-enable.sh /qemu-enable.sh
ENTRYPOINT ["/bin/bash", "/qemu-enable.sh"]

RUN rm /formats/python*
