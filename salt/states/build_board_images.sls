{% set build_user = salt['pillar.get']('build_user') %}

{% for board in salt['pillar.get']('board_list').split(' ') %}
{% if board %}
setup_board_{{ board }}:
  cmd.run:
    - name: cros_sdk -- ./setup_board --board={{ board }}
    - user: {{ build_user }}
    - cwd: /home/{{ build_user }}/chromiumos
    - umask: 022
    - env:
      - PATH: '/opt/depot_tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games'

build_packages_{{ board }}:
  cmd.run:
    - name: cros_sdk -- ./build_packages --board={{ board }}
    - user: {{ build_user }}
    - cwd: /home/{{ build_user }}/chromiumos
    - umask: 022
    - env:
      - PATH: '/opt/depot_tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games'

build_image_{{ board }}:
  cmd.run:
    - name: cros_sdk -- ./build_image --board={{ board }} {{ salt['pillar.get']('image_flags') }}
    - user: {{ build_user }}
    - cwd: /home/{{ build_user }}/chromiumos
    - umask: 022
    - env:
      - PATH: '/opt/depot_tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games'

{% endif %}
{% endfor %}