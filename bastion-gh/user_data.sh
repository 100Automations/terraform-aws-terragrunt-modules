#!/usr/bin/env bash

# -----------------------------
# Created by Darren Pham
# github.com/darpham
# ------------------------------

# -----------------------------
# Import Github Public SSH Keys
# -----------------------------

cat <<"EOF" > /home/root/create_ssh_authorized_keys.sh
#!/usr/bin/env bash
set -e
SSH_USER=${ssh_user}
MARKER="# KEYS_BELOW_WILL_BE_UPDATED_BY_TERRAFORM"
KEYS_FILE=/home/$SSH_USER/.ssh/authorized_keys
GITHUB_SSH_USERNAMES_URL="https://raw.githubusercontent.com/${github_repo_owner}/${github_repo_name}/${github_branch}/${github_filepath}"
TEMP_GITHUB_KEYS_FILE=$(mktemp /tmp/github_ssh_keys.XXXXXX)
# TEMP_KEYS_FILE=$(mktemp /tmp/authorized_keys.XXXXXX)
PATH=/usr/local/bin:$PATH

# Add marker, if not present, and copy static content.
grep -Fxq "$MARKER" $KEYS_FILE || echo -e "\n$MARKER" >> $KEYS_FILE
line=$(grep -n "$MARKER" $KEYS_FILE | cut -d ":" -f 1)
# head -n $line $KEYS_FILE > $TEMP_KEYS_FILE

# Pull SSH public keys from Github
wget --output-document $TEMP_GITHUB_KEYS_FILE $GITHUB_SSH_USERNAMES_URL
IFS='\n' read -r -a GITHUB_USERNAMES_ARRAY <<< $(grep "^[^#;]" $TEMP_GITHUB_KEYS_FILE)

# Create user and move authorized keys
for gh_user in $GITHUB_USERNAMES_ARRAY; do
  useradd -m -d /home/$gh_user -s /bin/bash $gh_user
  install -d -m 700 -o $gh_user -g $gh_user /home/$gh_user/.ssh
  install -b -m 600 -o $gh_user -g $gh_user /dev/null /home/$gh_user/.ssh/authorized_keys
  install -b -m 600 -o $gh_user -g $gh_user /dev/null /home/$gh_user/.ssh/config
  curl https://github.com/$gh_user.keys | tee -a /home/$gh_user/.ssh/authorized_keys
  usermod -aG sudo $gh_user
  cat <<"EOF" > /home/$gh_user/.ssh/config
  Host *
      StrictHostKeyChecking no
  EOF
done
EOF

# Execute now
chmod 755 /home/root/create_ssh_authorized_keys.sh
su root -c /home/root/create_ssh_authorized_keys.sh

# Enable timestamp in History for all users
echo 'export HISTTIMEFORMAT="%F %T "' >> /etc/profile && source  /etc/profile

# -----------------------------
# Setup Cron Job
# -----------------------------

# Be backwards compatible with old cron update enabler
if [ "${enable_hourly_cron_updates}" = 'true' -a -z "${cron_key_update_schedule}" ]; then
  cron_key_update_schedule="0 * * * *"
else
  cron_key_update_schedule="${cron_key_update_schedule}"
fi

# Add to cron
if [ -n "$cron_key_update_schedule" ]; then
  croncmd="/home/root/create_ssh_authorized_keys.sh"
  cronjob="$cron_key_update_schedule $croncmd"
  ( crontab -u root -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -u root -
fi

# Append addition user-data script
${additional_user_data_script}