#!/usr/bin/env bash

#
# firmware repository access
#

set -e

mkdir -p $HOME/.ssh

openssl \
    aes-256-cbc \
    -K $encrypted_7c4298487d20_key \
    -iv $encrypted_7c4298487d20_iv \
    -in $TRAVIS_BUILD_DIR/buildroot/secret/repo_key.enc \
    -out $HOME/.ssh/id_rsa \
    -d \

chmod 600 $HOME/.ssh/id_rsa
