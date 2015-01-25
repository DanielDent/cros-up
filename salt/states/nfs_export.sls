
{% if salt['pillar.get']('nfs_export') %}

nfs-kernel-server:
  pkg.installed: []
  service.running:
    - watch:
      - file: /etc/exports
  file.managed:
    - name: /etc/exports
    - source: salt://etc/exports.jinja
    - template: jinja

{% endif %}
