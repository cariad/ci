#!/bin/bash -e

# Validates all of the shell scripts that we can find.
#
# Assumes that scripts are named "*.sh".
#
# Optional arguments:
#
#   --expect <COUNT>
#   Fail if greater or fewer than <COUNT> scripts were found.

while [[ ${1} = -* ]]; do
  arg=${1}
  shift

  case ${arg} in
    --expect)
      expect=${1:?}
      shift
      ;;

    *)
      echo "Unexpected argument: ${arg:?}"
      exit 1
      ;;
  esac
done

li="\033[1;34m↪\033[0m "  # List item
nk="\033[0;31m⨯\033[0m "  # Not OK
ok="\033[0;32m✔️\033[0m "  # OK

count=0

while IFS="" read -r file_path
do
  echo -e "${li:?}${file_path:?}"
  shellcheck --check-sourced --enable=all --severity style -x "${file_path:?}"
  count=$((count + 1))
done < <(find . -name "*.sh")

plural() {
  if [[ "${1:?}" == "1" ]]; then
    echo "script"
  else
    echo "scripts"
  fi
}

if [[ "${expect:=${count:?}}" != "${count:?}" ]]; then
  echo -e "${nk:?}Expected ${expect:?} $(plural "${expect:?}") but found ${count:?}."
  exit 1
fi

if [[ ${count:?} == 0 ]]; then
  echo -e "${nk:?}No shell scripts found."
  exit 2
fi

echo -e "${ok:?}${count:?} $(plural "${count:?}") validated."
