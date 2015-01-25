{% set build_user = salt['pillar.get']('build_user') %}

pkg.upgrade:
  module.run:
    - refresh: True

dev_deps:
  pkg.installed:
    - pkgs:
      - git-core
      - gitk
      - git-gui
      - subversion
      - curl
      - screen
      - bwm-ng
      - jed

depot_tools:
  git.latest:
    - name: https://chromium.googlesource.com/chromium/tools/depot_tools.git
    - rev: master
    - target: /opt/depot_tools

{{ build_user }}:
  user.present:
    - fullname: RD SDK Dev User
    - shell: /bin/bash
    - home: /home/{{ build_user }}
    - gid_from_name: True

/home/{{ build_user }}/.gitconfig:
  file.managed:
    - source: salt://etc/gitconfig.jinja
    - template: jinja

/home/{{ build_user }}/.bashrc:
  file.append:
    - text: |
        export PATH=/opt/depot_tools:"$PATH"
        export SOURCE_REPO=/home/{{ build_user }}/chromiumos
        umask 022

/home/{{ build_user }}/chromiumos:
  file.directory:
    - user: {{ build_user }}
    - group: {{ build_user }}
    - dir_mode: 755

/home/{{ build_user }}/.ssh:
  file.directory:
    - user: {{ build_user }}
    - group: {{ build_user }}
    - dir_mode: 700

/home/{{ build_user }}/.ssh/authorized_keys:
  file.copy:
    - source: /root/.ssh/authorized_keys
    - user: {{ build_user }} # Not supported until Lithium SaltStack release
    - group: {{ build_user }} # Not supported until Lithium SaltStack release
    - mode: 600 # Not supported until Lithium SaltStack release

# Workaround for pre-Lithium SaltStack
ssh_permissions_owner_fix:
  file.directory:
    - name: /home/{{ build_user }}/.ssh
    - user: {{ build_user }}
    - group: {{ build_user }}
    - dir_mode: 700
    - file_mode: 600
    - recurse:
      - user
      - group
      - mode

/etc/sudoers.d/relax_requirements:
  file.managed:
    - source: salt://etc/sudoers_relax_requirements.jinja
    - template: jinja

