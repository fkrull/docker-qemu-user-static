FROM ubuntu:17.10 AS binaries
RUN apt-get update && \
    apt-get install -y \
        python3 \
        qemu-user-static

COPY scripts/convert-formats.py /convert-formats.py
RUN mkdir -p /formats && \
    python3 /convert-formats.py /var/lib/binfmts /formats

FROM busybox
COPY --from=binaries /usr/bin/qemu-*-static /usr/bin/
COPY --from=binaries /formats/qemu-* /formats/
COPY scripts/qemu-enable.sh /qemu-enable.sh
RUN chmod 0755 /qemu-enable.sh
ENTRYPOINT ["/qemu-enable.sh"]
