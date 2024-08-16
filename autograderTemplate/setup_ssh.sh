# Setting up SSH access to the Git host
mkdir -p $SSH_DIR
sed "s/GIT_HOST/$GIT_HOST/" ssh_config_template > $SSH_DIR/config

# Make sure to include your private key here
cp $SSH_PRIVATE_KEYFILE $SSH_DIR/$SSH_PRIVATE_KEYFILE
# To prevent host key verification errors at runtime
ssh-keyscan -t rsa $GIT_HOST >> $SSH_DIR/known_hosts
