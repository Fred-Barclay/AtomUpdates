#!/bin/bash
# Atom-Beta_Updates.sh (ABU) -- Intelligent update script for Atom Beta.
# DEBIAN VERSION.
# Copyright (C) 2016 ABU authors:
# nihilismus (https://github.com/nihilismus) <hba.nihilismus@gmail.com>
# Fred Barclay (https://github.com/Fred-Barclay) <BugsAteFred@gmail.com>
#
# Dual-licensed under the GPL v2 and custom license terms.
# GPL v2:
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License
#   as published by the Free Software Foundation; either version 2
#   of the License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# Custom license terms:
#   You are hereby granted a perpetual, irrevocable license to copy, modify,
#   publish, release, and distribute this program as you see fit. However,
#   under no circumstances may you claim original authorship of this code; you
#   must credit the ABU authors. If you release the source code, whether
#   modified or original, you may not remove the ABU authors as the original
#   authors, though you may change the licensing terms. If you release binaries
#   or similarly compiled files, you must credit the ABU authors on your home or
#   distribution page. In your documentation, you must credit the ABU authors
#   for the portions of their code you have used. This, of course, does not
#   revoke or change your right to claim original authorship to any portions of
#   the code that you have written.
#
#   You must agree to assume all liability for your use of the program, and to
#   indemnify and hold harmless the ABU authors from any liability arising from
#   use of this program, including, but not limited to: loss of data, death,
#   dismemberment, or injury, and all consequential and inconsequential damages.
#
#   For clarification, contact Fred Barclay:
#       https://github.com/Fred-Barclay
#       BugsAteFred@gmail.com
#

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi
github_server="https://github.com"
github_releases="https://github.com/atom/atom/releases"
last_release=$(wget -o /dev/null -O - ${github_releases} | \
	grep -E '.*releases.*download.*beta.*amd64.deb.*' | \
    sed 's/^.*ref="//' | \
	sed 's/amd64.deb.*$/amd64.deb/' | \
	grep -E 'atom-amd64.deb$' | \
	head -1)

last_release_pretty=$(echo $last_release | cut -c 31-41)
local_version=$(atom-beta --version | grep -E beta | cut -c 11-21)

if [ $last_release_pretty = $local_version ]; then
    echo 'Congratulations! You have the latest version!'
    exit
else
    echo Latest version is $last_release_pretty
    echo -e You have $local_version
    echo
    read -p 'Upgrade to the latest version now? [y/N] ' up
    if [ $up != y ]; then echo "Terminating!"; fi
    if [ $up == y ]; then
        mkdir temp-atom-dir
        cd temp-atom-dir
        echo -e 'Created by Atom-Beta_Updates.sh' >> whoami.txt
        echo ' => Downloading ${github_server}${last_release}'
        wget "${github_server}/${last_release}" -O atom-beta-amd64.deb
        echo 'Download complete!'
        dpkg -i atom-beta-amd64.deb
    fi
    cd ..
    rm -rf temp-atom-dir
fi
exit
