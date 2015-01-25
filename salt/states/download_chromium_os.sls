{% set build_user = salt['pillar.get']('build_user') %}

repo_init:
  cmd.run:
    - name: repo init -u https://chromium.googlesource.com/chromiumos/manifest.git && touch .salt_repo_initialized
    {% if salt['pillar.get']('resync_sources') == "0" %}
    - creates: /home/{{ build_user }}/chromiumos/.salt_repo_initialized
    {% endif %}
    - user: {{ build_user }}
    - cwd: /home/{{ build_user }}/chromiumos
    - umask: 022
    - env:
      - PATH: '/opt/depot_tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games'

repo_sync:
  cmd.run:
    - name: repo sync && touch .salt_repo_synced
    {% if salt['pillar.get']('resync_sources') == "0" %}
    - creates: /home/{{ build_user }}/chromiumos/.salt_repo_synced
    {% endif %}
    - requires: repo_init
    - user: {{ build_user }}
    - cwd: /home/{{ build_user }}/chromiumos
    - umask: 022
    - env:
      - PATH: '/opt/depot_tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games'
