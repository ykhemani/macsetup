#!/bin/bash

################################################################################
# script to bootstrap macOS
# based on https://gist.github.com/kevinelliott/ab14cfb080cc85e0f8a415b147a0d895
# https://github.com/why-jay/osx-init/blob/master/install.sh
# also see https://github.com/tiiiecherle/osx_install_config
# https://www.intego.com/mac-security-blog/unlock-the-macos-docks-hidden-secrets-in-terminal/
################################################################################

################################################################################
# helpful functions
function log() {
  # usage: log (INFO|WARN|ERROR) "<message>"
  echo "$(/bin/date +%Y-%m-%d\ %H:%M:%S\ %Z) - $1 $2"
}
################################################################################
# usage
function usage() {
  echo "Usage: "
  echo "  $0 <user settings file>"
  echo ""
  echo "e.g."
  echo "  $0 example.conf"
}
################################################################################

################################################################################
# environment variables
readonly INFO="INFO"
readonly WARN="WARN"
readonly ERROR="ERROR"

PATH=${PATH}:/usr/local/bin:/usr/bin:${HOME}/bin
################################################################################

################################################################################
# check command line arguments
user_settings=$1
#lastpass_account=$2
error=0
if [ "${user_settings}" == "" ]
then
  error=1
elif [ ! -f "${user_settings}" ]
then
  log ${ERROR} "User settings file ${user_settings} not found."
  error=1
fi

#if [ "${lastpass_account}" == "" ]
#then
#  error=1
#fi

if [ "${error}" == "1" ]
then
  usage
  exit ${error}
fi
#
################################################################################

################################################################################
# source user settings
source ${user_settings}
################################################################################

################################################################################
# install hashi tools
function hashi() {
  # use:
  # hashi vault 1.3.1 ent
  # hashi consul 1.7.0 "" beta2
  software=$1
  version=$2
  enterprise=$3
  beta=$4

  if [ "${enterprise}" != "" ]
  then
    enterprise="+${enterprise}"
  fi

  if [ "${beta}" != "" ]
  then
    beta="-${beta}"
  fi

  url=${hashi_base_url}/${software}/${version}${enterprise}${beta}/${software}_${version}${enterprise}${beta}_darwin_amd64.zip
  mkdir -p ${hashi_download_dir} && \
    cd ${hashi_download_dir} && \
    wget -O ${software}.zip "${url}" && \
    unzip -d /usr/local/bin ${software}.zip && \
    cd -
}
################################################################################

################################################################################
# notice
log ${INFO} "Starting setup"
log ${INFO} "You will be prompted to log into the Mac App Store as part of this setup."
################################################################################

################################################################################
# install Xcode Command Line Tools
# https://github.com/timsutton/osx-vm-templates/blob/ce8df8a7468faa7c5312444ece1b977c1b2f77a4/scripts/xcode-cli-tools.sh

# cloning this repo will result in Xcode Command Line Tools getting installed.

# log ${INFO} "Installing XCode Command Line Tools"
# touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
# PROD=$(softwareupdate -l |
#   grep "\*.*Command Line" |
#   head -n 1 | awk -F"*" '{print $2}' |
#   sed -e 's/^ *//' |
#   tr -d '\n')
# softwareupdate -i "$PROD" --verbose;
# log ${INFO} "Finished installing XCode Command Line Tools"

################################################################################

################################################################################
# install homebrew (brew)
# https://brew.sh
log ${INFO} "Installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
log ${INFO} "Finished installing homebrew"
################################################################################

################################################################################
if [ -f ${brewfile} ]
then
  log ${INFO} "Installing software from homebrew"
  brew bundle --file=${brewfile}
  log ${INFO} "Finished installing software from homebrew"
fi
################################################################################

################################################################################
# Prompt to log into the Mac App Store
echo "Please log into the Mac App Store if you haven't already, and then press Enter to continue."
read -s foo
unset foo
################################################################################

################################################################################
if [ -f ${masfile} ]
then
  log ${INFO} "Installing software from Mac App Store"
  brew bundle --file=${masfile}
  log ${INFO} "Finished installing software from Mac App Store"
fi
################################################################################

################################################################################
log ${INFO} "Installing HashiCorp Tools"

if [ "${vault_version}" != "" ]
then
  hashi vault ${vault_version} ${vault_ent}
fi

if [ "${consul_version}" != "" ]
then
  hashi consul ${consul_version} ${consul_ent}
fi

if [ "${nomad_version}" != "" ]
then
  hashi nomad ${nomad_version} ${nomad_ent}
fi

if [ "${terraform_version}" != "" ]
then
  hashi terraform ${terraform_version}
fi

if [ "${packer_version}" != "" ]
then
  hashi packer ${packer_version}
fi

if [ "${envconsul_version}" != "" ]
then
  hashi envconsul ${envconsul_version}
fi

if [ "${consul_template_version}" != "" ]
then
  hashi consul-template ${consul_template_version}
fi

log ${INFO} "Finished installing HashiCorp Tools"
#
################################################################################

################################################################################
if [ -f ${vscode_package_list} ]
then
  log ${INFO} "Installing Visual Studio Code Packages"
  code --install-extension $(cat ${vscode_package_list})
  log ${INFO} "Finished installing Visual Studio Code Packages"
fi
################################################################################

################################################################################
if [ -f ${atom_package_list} ]
then
  log ${INFO} "Installing atom packages"
  apm install --packages-file ${atom_package_list}
  log ${INFO} "Finished installing atom packages"
fi
################################################################################

################################################################################
if [ -f ${bash_profile} ]
then
  log ${INFO} "Installing bash profile"
  cp ${bash_profile} ${HOME}/.bash_profile
  log ${INFO} "Finished installing bash profile"
fi

if [ -f ${bash_colors} ]
then
  log ${INFO} "Installing bash colors"
  cp ${bash_colors} ${HOME}/.bash_colors
  log ${INFO} "Finished installing bash colors"
fi
################################################################################

################################################################################
if [ -f ${gpg_agent_config} ]
then
  log ${INFO} "Installing gpg-agent config"
  mkdir -p ${HOME}/.gnupg
  cp ${gpg_agent_config} ${HOME}/.gnupg/
  log ${INFO} "Finished installing gpg-agent config"
fi
################################################################################

################################################################################
#log ${INFO} "Logging into LastPass"
#lpass login ${lastpass_account}
#log ${INFO} "Finished logging into LastPass"
################################################################################

################################################################################
log ${INFO} "Configuring ssh"
mkdir -p ${ssh_dir}
cat <<EOF >> ${ssh_dir}/${ssh_config}
Host *
  ServerAliveInterval 60
  StrictHostKeyChecking no
EOF
log ${INFO} "Finished configuring ssh"
################################################################################

################################################################################
#log ${INFO} "Configuring git"
#git config --global user.name $(lpass show ${lpass_github} --field=git_name)
#git config --global user.email $(lpass show ${lpass_github} --field=git_email)
#git config --global github.user $(lpass show ${lpass_github} --field=login)
#git config --global color.ui true
#log ${INFO} "Finished configuring git"
################################################################################
