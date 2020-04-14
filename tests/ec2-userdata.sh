#!/bin/bash -xe

TMP=$(mktemp -d)
#trap "{ rm -rf $TMP; }" EXIT

yum install -y \
  python3 \
  python3-pip \
  git-core
pip3 install -r $TMP/DC-9-ansible/tests/requirements.txt

# Prepare virtualenv & activate
python3 -m venv $TMP/venv
. $TMP/venv/bin/activate

# Install ansible , download role and install requirements
pip3 install ansible
git clone https://github.com/HackThisCompany/DC-9-ansible.git $TMP/DC-9-ansible
pip3 install -r $TMP/DC-9-ansible/tests/requirements.txt

# Prepare playbook
cat << EOF > $TMP/playbook.yml
- name: 'Provide DC-9 server'
  hosts: localhost
  become: yes
  connection: local
  roles:
    - role: $TMP/DC-9-ansible
      vars:
        ansible_python_interpreter: python3
EOF

# Run playbook
ansible-playbook -i localhost, $TMP/playbook.yml
