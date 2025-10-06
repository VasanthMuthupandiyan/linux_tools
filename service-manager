#!/bin/bash

# ===================== Colors =====================
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# ===================== Functions =====================
check_service() {
    systemctl list-unit-files | grep -q "^$1"
}

# Status display with small delay for tick/cross
status_display() {
    local NAME=$1
    local DISPLAY=$2

    printf "%-8s : " "$DISPLAY"
    # sleep 0.1  # small delay before showing status

    if check_service "$NAME"; then
        local STATUS
        STATUS=$(systemctl is-active "$NAME" 2>/dev/null)
        if [ "$STATUS" = "active" ]; then
            echo -e "${GREEN}✔ ACTIVE${RESET}"
        else
            echo -e "${RED}✖ INACTIVE${RESET}"
        fi
    else
        echo -e "${YELLOW}⚠ NOT INSTALLED${RESET}"
    fi
    sleep 0.05
}

# Minimal action animation on single line with alignment
animate_action() {
    local ACTION=$1
    local SERVICE_NAME=$2
    printf "%-8s : %s... " "$SERVICE_NAME" "$ACTION"
    sleep 0.25
    echo -e "${GREEN}Done${RESET}"
    sleep 0.05
}

manage_service() {
    local SERVICE_NAME=$1
    local SYSTEMD_NAME=$2

    if ! check_service "$SYSTEMD_NAME"; then
        echo -e "${YELLOW}$SERVICE_NAME is not installed.${RESET}\n"
        return
    fi

    case $ACTION in
        start)
            if systemctl is-active "$SYSTEMD_NAME" &>/dev/null; then
                printf "%-8s : Already ${GREEN}running${RESET}\n" "$SERVICE_NAME"
            else
                if [ "$SERVICE_NAME" = "Docker" ]; then
                    sudo systemctl start docker.service docker.socket &>/dev/null
                else
                    sudo systemctl start "$SYSTEMD_NAME" &>/dev/null
                fi
                animate_action "Starting" "$SERVICE_NAME"
            fi
            ;;
        stop)
            if ! systemctl is-active "$SYSTEMD_NAME" &>/dev/null; then
                printf "%-8s : Already ${RED}stopped${RESET}\n" "$SERVICE_NAME"
            else
                if [ "$SERVICE_NAME" = "Docker" ]; then
                    sudo docker stop $(sudo docker ps -q) 2>/dev/null || true
                    sudo systemctl stop docker.service docker.socket &>/dev/null
                else
                    sudo systemctl stop "$SYSTEMD_NAME" &>/dev/null
                fi
                animate_action "Stopping" "$SERVICE_NAME"
            fi
            ;;
        restart)
            if [ "$SERVICE_NAME" = "Docker" ]; then
                sudo systemctl restart docker.service docker.socket &>/dev/null
            else
                sudo systemctl restart "$SYSTEMD_NAME" &>/dev/null
            fi
            animate_action "Restarting" "$SERVICE_NAME"
            ;;
        *)
            echo -e "${RED}Invalid action: $ACTION. Exiting.${RESET}"
            exit 1
            ;;
    esac
}

map_service() {
    case $1 in
        d*|doc*|dock*|docke*) echo "docker" ;;
        m*|mys*|mysq*) echo "mysql" ;;
        r*|re*|red*|redi*) echo "redis-server" ;;
        all) echo "all" ;;
        *) echo "invalid" ;;
    esac
}

# ===================== Main =====================
clear

echo -e "${BOLD}${CYAN}Checking services...${RESET}"
status_display docker.service "Docker"
status_display mysql.service "MySQL"
status_display redis-server.service "Redis"
echo ""

# User input
read -p "Service (docker/mysql/redis or 'all'): " SERVICES
if [[ -z "$SERVICES" ]]; then
    echo -e "${YELLOW}No service selected. Exiting gracefully.${RESET}"
    exit 0
fi

# Map and validate service input
SERVICE_CHECK=$(map_service "$(echo $SERVICES | tr '[:upper:]' '[:lower:]')")
if [[ "$SERVICE_CHECK" == "invalid" ]]; then
    echo -e "${RED}Invalid service input: $SERVICES. Exiting.${RESET}"
    exit 1
fi

read -p "Action (start/stop/restart): " ACTION
if [[ -z "$ACTION" ]]; then
    echo -e "${YELLOW}No action selected. Exiting gracefully.${RESET}"
    exit 0
fi

# Validate action input
case $ACTION in
    start|stop|restart) ;;
    *) echo -e "${RED}Invalid action input: $ACTION. Exiting.${RESET}"; exit 1 ;;
esac

echo ""

# Normalize input
SERVICES=$(echo "$SERVICES" | tr '[:upper:]' '[:lower:]')
[[ "$SERVICES" == "all" ]] && SERVICES="docker mysql redis-server"

echo -e "${BOLD}${CYAN}Making action...${RESET}"

# Perform requested actions
for INPUT in $SERVICES; do
    SERVICE=$(map_service "$INPUT")
    case $SERVICE in
        docker) manage_service "Docker" "docker.service" ;;
        mysql) manage_service "MySQL" "mysql.service" ;;
        redis-server) manage_service "Redis" "redis-server.service" ;;
    esac
done

# Show updated status
echo -e "\n${BOLD}${CYAN}Updated service status:${RESET}"
status_display docker.service "Docker"
status_display mysql.service "MySQL"
status_display redis-server.service "Redis"
echo ""

