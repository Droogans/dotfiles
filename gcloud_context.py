#!/usr/bin/env python

import sys

try:
    config_file_name = ".config/gcloud/configurations/config_{}".format(sys.argv[1])
except IndexError:
    # current-context is not set
    sys.exit(1)

try:
    from configparser import ConfigParser
except ImportError:
    from ConfigParser import RawConfigParser as ConfigParser

try:
    from pathlib import Path
    config_file = Path.home() / config_file_name
except ImportError:
    import os
    config_file = os.path.join(os.path.expanduser("~"), config_file_name)

config = ConfigParser()

try:
    config.read(config_file)
    print(config.get("core", "project"))
except:
    sys.exit(1)
