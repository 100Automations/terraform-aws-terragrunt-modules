#!/usr/bin/env bash

##############
# Install deps
##############

# Apt based distro
if command -v apt-get &>/dev/null; then
  apt-get update
  apt-get install python-pip jq -y

# Yum based distro
elif command -v yum &>/dev/null; then
  yum update -y
  # epel provides python-pip & jq
  yum install -y epel-release
  yum install python-pip jq -y
fi

#####################

# pip install --upgrade awscli

##############

cat <<"EOF" > /home/${ssh_user}/update_ssh_authorized_keys.sh
#!/usr/bin/env bash
set -e
SSH_USER=${ssh_user}
MARKER="# KEYS_BELOW_WILL_BE_UPDATED_BY_TERRAFORM"
KEYS_FILE=/home/$SSH_USER/.ssh/authorized_keys
TEMP_KEYS_FILE=$(mktemp /tmp/authorized_keys.XXXXXX)
PATH=/usr/local/bin:$PATH

# Add marker, if not present, and copy static content.
grep -Fxq "$MARKER" $KEYS_FILE || echo -e "\n$MARKER" >> $KEYS_FILE
line=$(grep -n "$MARKER" $KEYS_FILE | cut -d ":" -f 1)
head -n $line $KEYS_FILE > $TEMP_KEYS_FILE

# Pull SSH public keys from Github
IFS=' ' read -r -a GITHUB_USERNAMES_ARRAY <<<$(echo "${github_usernames}")
touch /home/$SSH_USER/github_username
echo ${github_usernames} >> /home/$SSH_USER/github_username

for gh_user in $GITHUB_USERNAMES_ARRAY; do
    echo $gh_user >> /home/$SSH_USER/github_username
    echo $gh_user >> $TEMP_KEYS_FILE
    keys=$(curl https://github.com/$gh_user.keys)
    echo $keys >> /home/$SSH_USER/github_username
    echo $keys >> $TEMP_KEYS_FILE
done

# Move the new authorized keys in place.
chown $SSH_USER:$SSH_USER $KEYS_FILE
chmod 600 $KEYS_FILE
mv $TEMP_KEYS_FILE $KEYS_FILE
if [[ $(command -v "selinuxenabled") ]]; then
    restorecon -R -v $KEYS_FILE
fi
EOF

# cat <<"EOF" > /home/${ssh_user}/.ssh/config
# Host *
#     StrictHostKeyChecking no
# EOF
# chmod 600 /home/${ssh_user}/.ssh/config
# chown ${ssh_user}:${ssh_user} /home/${ssh_user}/.ssh/config

# chown ${ssh_user}:${ssh_user} /home/${ssh_user}/update_ssh_authorized_keys.sh
# chmod 755 /home/${ssh_user}/update_ssh_authorized_keys.sh

# # Execute now
# su ${ssh_user} -c /home/${ssh_user}/update_ssh_authorized_keys.sh

# # Be backwards compatible with old cron update enabler
# if [ "${enable_hourly_cron_updates}" = 'true' -a -z "${keys_update_frequency}" ]; then
#   keys_update_frequency="0 * * * *"
# else
#   keys_update_frequency="${keys_update_frequency}"
# fi

# # Add to cron
# if [ -n "$keys_update_frequency" ]; then
#   croncmd="/home/${ssh_user}/update_ssh_authorized_keys.sh"
#   cronjob="$keys_update_frequency $croncmd"
#   ( crontab -u ${ssh_user} -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -u ${ssh_user} -
# fi

