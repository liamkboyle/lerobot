#!/usr/bin/env bash
# Teleoperate the SO-101 (leader -> follower) with the cameras and the VL53L9 ToF depth shown in the viewer.
#   /dev/serial/by-id/usb-1a86_USB_Single_Serial_5C82107846-if00  follower arm
#   /dev/serial/by-id/usb-1a86_USB_Single_Serial_5C82109423-if00  leader arm
#   /dev/serial/by-id/usb-STMicroelectronics_STLINK-V3_0033004F3235511137333439-if02  VL53L9 ToF board (STLINK-V3)
set -euo pipefail

cd "$(dirname "$0")/.."

# Serial port access. The group change only applies after the next login, the chmods apply right away
# (and are lost when a board is re-plugged).
sudo usermod -aG dialout admin
sudo chmod 666 /dev/serial/by-id/usb-1a86_USB_Single_Serial_5C82107846-if00
sudo chmod 666 /dev/serial/by-id/usb-1a86_USB_Single_Serial_5C82109423-if00

uv run lerobot-teleoperate \
    --robot.type=so101_follower \
    --robot.port=/dev/serial/by-id/usb-1a86_USB_Single_Serial_5C82109423-if00 \
    --robot.id=loki_follower \
    --robot.cameras="{front: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}, wrist: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}}" \
    --teleop.type=so101_leader \
    --teleop.port=/dev/serial/by-id/usb-1a86_USB_Single_Serial_5C82107846-if00 \
    --teleop.id=loki_leader \
    --display_data=true \

