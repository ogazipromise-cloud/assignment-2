#!/usr/bin/env bash

set -u

show_help() {
echo "Diagnostic Tool"
echo
echo "Usage: diagnostic <command> [arguments]"
echo
echo "Commands:"
echo "  system                 Display Linux system information"
echo "  network <host>         Check and resolve a host"
echo "  disk                   Display disk information"
echo "  help                   Display this help message"
}

system_info() {
echo "===== System Information ====="
echo "Hostname: $(hostname)"
echo "Current User: $(whoami)"
echo "Date/Time: $(date)"
echo "Kernel Version: $(uname -r)"
echo "Uptime: $(uptime -p)"


echo
echo "===== CPU Information ====="

if command -v lscpu >/dev/null 2>&1; then
    lscpu | grep -E "Model name|CPU\(s\)" || true
else
    grep -m1 "model name" /proc/cpuinfo || true
fi

echo
echo "===== Memory Information ====="
free -h


}

network_check() {
local host="$1"
local resolved_address


if ! resolved_address=$(getent hosts "$host" | awk 'NR==1 {print $1}'); then
    echo "Error: Unable to resolve host: $host" >&2
    return 1
fi

if [[ -z "$resolved_address" ]]; then
    echo "Error: Unable to resolve host: $host" >&2
    return 1
fi

echo "Host: $host"
echo "Resolved Address: $resolved_address"

echo
echo "===== Connectivity Check ====="

if ping -c 1 -W 3 "$host" >/dev/null 2>&1; then
    echo "Connectivity: Successful"
else
    echo "Connectivity: Failed"
    return 1
fi


}

disk_info() {
echo "===== Disk Information ====="
df -h /
}

main() {
local command="${1:-}"


case "$command" in
    system)
        if [[ $# -ne 1 ]]; then
            echo "Error: 'system' does not accept additional arguments." >&2
            exit 2
        fi
        system_info
        ;;

    network)
        if [[ $# -ne 2 || -z "${2:-}" ]]; then
            echo "Error: 'network' requires a host argument." >&2
            show_help
            exit 2
        fi
        network_check "$2"
        ;;

    disk)
        if [[ $# -ne 1 ]]; then
            echo "Error: 'disk' does not accept additional arguments." >&2
            exit 2
        fi
        disk_info
        ;;

    help|--help|-h)
        show_help
        ;;

    "")
        echo "Error: Missing command." >&2
        show_help
        exit 2
        ;;

    *)
        echo "Error: Invalid command: $command" >&2
        show_help
        exit 2
        ;;
esac


}

main "$@"
