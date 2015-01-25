base:
  '*':
    - remove_salt_minion
    - setup_dev_prereqs
    - download_chromium_os
    - setup_cros_sdk
    - build_board_images
    - nfs_export
