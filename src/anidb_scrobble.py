#!/usr/bin/env python
# Description:  Marks episodes as watched with pyanidb on anidb
# Author:       Gosha
# PlexPy script trigger:    Watched status

import argparse
import requests
import configparser
import sys
import os

import pyanidb
import pyanidb.hash
import pprint


def getTautulliApikey():
    config = configparser.ConfigParser()
    config.read("/config/config.ini")
    return config.get("General", "api_key")


### EDIT SETTINGS ###

ANIDB_USERNAME = os.environ["ANIDB_USERNAME"]
ANIDB_PASSWORD = os.environ["ANIDB_PASSWORD"]
PLEX_USER = os.environ["PLEX_USER"]
TAUTULLI_URL = os.environ.get("TAUTULLI_URL", "http://localhost:8181")
TAUTULLI_APIKEY = getTautulliApikey()
# Can be seen under settings -> notification agents -> agent -> popup header
NOTIFIER_ID = os.environ.get("NOTIFIER_ID", None)


### CODE BELOW ###

def send_notification(subject, body):
    if not NOTIFIER_ID:
        return

    params = {'apikey': TAUTULLI_APIKEY,
              'cmd': 'notify',
              'notifier_id': NOTIFIER_ID,
              'subject': subject,
              'body': body}
    print("Sending notification:\n{}\n=====\n{}".format(subject, body))
    r = requests.post(TAUTULLI_URL.rstrip('/') + '/api/v2', params=params)


def main(p):
    if p.user_name != PLEX_USER:
        sys.exit(0)

    a = pyanidb.AniDB(ANIDB_USERNAME, ANIDB_PASSWORD)
    try:
        a.auth()
        print("Logged in to anidb")
    except:
        send_notification("Failed to scrobble", "Couldn't log in")
        sys.exit(1)

    filename = p.filename.replace("D:\\Data", "/data").replace("\\", "/")

    try:
        for file in pyanidb.hash.hash_files([filename]):
            fid = (file.size, file.ed2k)
            a.add_file(fid, viewed=True, retry=True)
    except pyanidb.AniDBUnknownFile:
        send_notification("Failed to scrobble", "Unknown file: {}".format(filename))
        sys.exit(1)
    except Exception as e:
        send_notification(
            "Failed to scrobble",
            "Unknown error: {}\nFile: {}".format(e.__class__.__name__, p.filename),
        )
        sys.exit(1)

    send_notification("Scrobbled", "File: {}".format(p.filename))


if __name__ == "__main__":
    # Parse arguments from PlexPy
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "-med", "--media_type", action="store", default="", help="Media type"
    )
    parser.add_argument(
        "-lbn", "--library_name", action="store", default="", help="Library name"
    )
    parser.add_argument(
        "-file", "--filename", action="store", default="", help="File name"
    )
    parser.add_argument(
        "-usr", "--user_name", action="store", default="", help="Username"
    )
    # Add more arguments as needed

    p = parser.parse_args()

    main(p)
