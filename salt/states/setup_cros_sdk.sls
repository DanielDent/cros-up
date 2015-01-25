{% set build_user = salt['pillar.get']('build_user') %}

cros_sdk:
  cmd.run:
    - name: cros_sdk
    - requires: repo_sync
    - user: {{ build_user }}
    - cwd: /home/{{ build_user }}/chromiumos
    - umask: 022
    - env:
      - PATH: '/opt/depot_tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games'

