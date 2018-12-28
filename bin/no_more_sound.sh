#!/bin/bash
sudo /etc/init.d/alsa-utils stop && sudo alsa force-reload && sudo /etc/init.d/alsa-utils start
