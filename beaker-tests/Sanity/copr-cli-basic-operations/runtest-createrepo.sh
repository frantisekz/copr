#!/bin/bash

. /usr/bin/rhts-environment.sh || exit 1
. /usr/share/beakerlib/beakerlib.sh || exit 1

# Load config settings
HERE=$(dirname "$(realpath "$0")")
source "$HERE/config"
source "$HERE/helpers"

URL=${FRONTEND_URL#https://}

rlJournalStart
    rlPhaseStartSetup
    rlPhaseEnd

    rlPhaseStartTest
        rlRun "copr-cli create ${NAME_PREFIX}Createrepo --chroot fedora-30-x86_64"
        echo "sleep 60 seconds to give backend enough time to generate the repo"
        sleep 60
        rlRun "dnf -y copr enable ${URL}/${NAME_PREFIX}Createrepo"
        rlRun "dnf --disablerepo='*' \
            --enablerepo='copr:${URL}:group_copr:${NAME_VAR}Createrepo' \
            list available 2>&1 | grep 'Failed to synchronize'" 1

        rlRun "copr-cli modify ${NAME_PREFIX}Createrepo --chroot fedora-rawhide-x86_64"
        echo "sleep 60 seconds to give backend enough time to generate the repo"
        sleep 60
        rlRun "dnf -y copr enable ${URL}/${NAME_PREFIX}Createrepo fedora-rawhide-x86_64"
        rlRun "dnf --disablerepo='*' \
            --enablerepo='copr:${URL}:group_copr:${NAME_VAR}Createrepo' \
            list available 2>&1 | grep 'Failed to synchronize'" 1

        rlRun "copr-cli delete ${NAME_PREFIX}Createrepo"
    rlPhaseEnd

    rlPhaseStartCleanup
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
