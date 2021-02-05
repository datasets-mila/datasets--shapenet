#!/bin/bash

function exit_on_error_code {
	local _ERR=$?
	if [[ ${_ERR} -ne 0 ]]
	then
		>&2 echo "$(tput setaf 1)ERROR$(tput sgr0): $1: ${_ERR}"
		exit ${_ERR}
	fi
}

function test_enhanced_getopt {
	! getopt --test > /dev/null
	if [[ ${PIPESTATUS[0]} -ne 4 ]]
	then
		>&2 echo "enhanced getopt is not available in this environment"
		exit 1
	fi
}

function enhanced_getopt {
	local _NAME=$0
	while [[ $# -gt 0 ]]
	do
		local _arg="$1"; shift
		case "${_arg}" in
			--options) local _OPTIONS="$1"; shift ;;
			--longoptions) local _LONGOPTIONS="$1"; shift ;;
			--name) local _NAME="$1"; shift ;;
			--) break ;;
			-h | --help | *)
			if [[ "${_arg}" != "-h" ]] && [[ "${_arg}" != "--help" ]]
			then
				>&2 echo "Unknown option [${_arg}]"
			fi
			>&2 echo "Options for $(basename "$0") are:"
			>&2 echo "--options OPTIONS The short (one-character) options to be recognized"
			>&2 echo "--longoptions LONGOPTIONS The long (multi-character) options to be recognized"
			>&2 echo "--name NAME name that will be used by the getopt routines when it reports errors"
			exit 1
			;;
		esac
	done

	local _PARSED=`getopt --options="${_OPTIONS}" --longoptions="${_LONGOPTIONS}" --name="${_NAME}" -- "$@"`
	if [[ ${PIPESTATUS[0]} -ne 0 ]]
	then
		exit 2
	fi

	echo "${_PARSED}"
}

function init_conda_env {
	while [[ $# -gt 0 ]]
	do
		local _arg="$1"; shift
		case "${_arg}" in
			--name) local _NAME="$1"; shift
			echo "name = [${_NAME}]"
			;;
			--tmp) local _TMPDIR="$1"; shift
			echo "tmp = [${_TMPDIR}]"
			;;
			-h | --help | *)
			if [[ "${_arg}" != "-h" ]] && [[ "${_arg}" != "--help" ]]
			then
				>&2 echo "Unknown option [${_arg}]"
			fi
			>&2 echo "Options for $(basename "$0") are:"
			>&2 echo "--name NAME conda env prefix name"
			>&2 echo "--tmp DIR tmp dir to hold the conda prefix"
			exit 1
			;;
		esac
	done

	# Configure conda for bash shell
	eval "$(conda shell.bash hook)"

	if [[ ! -d "${_TMPDIR}/env/${_NAME}/" ]]
	then
		conda create --prefix "${_TMPDIR}/env/${_NAME}/" --yes --no-default-packages || \
		exit_on_error_code "Failed to create ${_NAME} conda env"
	fi

	conda activate "${_TMPDIR}/env/${_NAME}/" && \
	exit_on_error_code "Failed to activate ${_NAME} conda env"
}

function init_venv {
	while [[ $# -gt 0 ]]
	do
		local _arg="$1"; shift
		case "${_arg}" in
			--name) local _NAME="$1"; shift
			echo "name = [${_NAME}]"
			;;
			--tmp) local _TMPDIR="$1"; shift
			echo "tmp = [${_TMPDIR}]"
			;;
			-h | --help | *)
			if [[ "${_arg}" != "-h" ]] && [[ "${_arg}" != "--help" ]]
			then
				>&2 echo "Unknown option [${_arg}]"
			fi
			>&2 echo "Options for $(basename "$0") are:"
			>&2 echo "--name NAME venv prefix name"
			>&2 echo "--tmp DIR tmp dir to hold the virtualenv prefix"
			exit 1
			;;
		esac
	done

	if [[ ! -d "${_TMPDIR}/venv/${_NAME}/" ]]
	then
		mkdir -p "${_TMPDIR}/venv/${_NAME}/" && \
		virtualenv --no-download "${_TMPDIR}/venv/${_NAME}/" || \
		exit_on_error_code "Failed to create ${_NAME} venv"
	fi

	source "${_TMPDIR}/venv/${_NAME}/bin/activate" || \
	exit_on_error_code "Failed to activate ${_NAME} venv"
	python3 -m pip install --no-index --upgrade pip
}

function unshare_mount {
	if [[ ${EUID} -ne 0 ]]
	then
		unshare -rm ./"${BASH_SOURCE[0]}" unshare_mount "$@" <&0
		exit $?
	fi

	if [[ -z ${_SRC} ]]
	then
		local _SRC=${PWD}
	fi
	while [[ $# -gt 0 ]]
	do
		local _arg="$1"; shift
		case "${_arg}" in
			--src) local _SRC="$1"; shift
			echo "src = [${_SRC}]"
			;;
			--dir) local _DIR="$1"; shift
			echo "dir = [${_DIR}]"
			;;
			--cd) local _CD=1
			echo "cd = [${_CD}]"
			;;
	                --) break ;;
			-h | --help | *)
			if [[ "${_arg}" != "-h" ]] && [[ "${_arg}" != "--help" ]]
			then
				>&2 echo "Unknown option [${_arg}]"
			fi
			>&2 echo "Options for $(basename "$0") are:"
			>&2 echo "[--dir DIR] mount location"
			>&2 echo "[--src DIR] source dir (optional)"
			exit 1
			;;
		esac
	done

	mkdir -p ${_SRC}
	mkdir -p ${_DIR}

	local _SRC=$(cd "${_SRC}" && pwd -P)
	local _DIR=$(cd "${_DIR}" && pwd -P)

	mount -o bind ${_SRC} ${_DIR}
	exit_on_error_code "Could not mount directory"

	if [[ ! ${_CD} -eq 0 ]]
	then
		cd ${_DIR}
	fi

	unshare -U ${SHELL} -s "$@" <&0
}

# function unshare_mount {
# 	if [[ ${EUID} -ne 0 ]]
# 	then
# 		unshare -rm ./"${BASH_SOURCE[0]}" unshare_mount "$@" <&0
# 		exit $?
# 	fi
#
# 	if [[ -z ${_SRC} ]]
# 	then
# 		local _SRC=${PWD}
# 	fi
# 	if [[ -z ${_DIR} ]]
# 	then
# 		local _DIR=${_PWD}
# 	fi
# 	while [[ $# -gt 0 ]]
# 	do
# 		local _arg="$1"; shift
# 		case "${_arg}" in
# 			--src) local _SRC="$1"; shift
# 			echo "src = [${_SRC}]"
# 			;;
# 			--upper) local _UPPER="$1"; shift
# 			echo "upper = [${_UPPER}]"
# 			;;
# 			--dir) local _DIR="$1"; shift
# 			echo "dir = [${_DIR}]"
# 			;;
# 			--wd) local _WD="$1"; shift
# 			echo "wd = [${_WD}]"
# 			;;
# 			--cd) local _CD=1
# 			echo "cd = [${_CD}]"
# 			;;
# 	                --) break ;;
# 			-h | --help | *)
# 			if [[ "${_arg}" != "-h" ]] && [[ "${_arg}" != "--help" ]]
# 			then
# 				>&2 echo "Unknown option [${_arg}]"
# 			fi
# 			>&2 echo "Options for $(basename "$0") are:"
# 			>&2 echo "[--upper DIR] upper mount overlay"
# 			>&2 echo "[--wd DIR] overlay working directory"
# 			>&2 echo "[--src DIR] lower mount overlay (optional)"
# 			>&2 echo "[--dir DIR] mount location (optional)"
# 			exit 1
# 			;;
# 		esac
# 	done
#
# 	mkdir -p ${_SRC}
# 	mkdir -p ${_UPPER}
# 	mkdir -p ${_WD}
# 	mkdir -p ${_DIR}
#
# 	local _SRC=$(cd "${_SRC}" && pwd -P) || echo "${_SRC}"
# 	local _UPPER=$(cd "${_UPPER}" && pwd -P)
# 	local _WD=$(cd "${_WD}" && pwd -P)
# 	local _DIR=$(cd "${_DIR}" && pwd -P)
#
# 	mount -t overlay overlay -o lowerdir="${_SRC}",upperdir="${_UPPER}",workdir="${_WD}" "${_DIR}"
# 	exit_on_error_code "Could not mount overlay"
#
# 	if [[ ! ${_CD} -eq 0 ]]
# 	then
# 		cd ${_DIR}
# 	fi
#
# 	unshare -U ${SHELL} -s "$@" <&0
# }

if [[ ! -z "$@" ]]
then
	"$@"
fi
