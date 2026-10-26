```bash
#!/bin/bash
set -Eeuo pipefail

# ╔══════════════════════════════════════════════╗
# ║       FAVOURITE SERVICE DEPLOYMENT           ║
# ║       DOCKER HUB  >>  KUBERNETES             ║
# ╚══════════════════════════════════════════════╝

# ---------- CONFIGURATION ----------
IMG_FILE_NAME="favourite-service/Dockerfile"
IMG_NAME="favourite-service:v1.0"
DOCKER_HUB_USERNAME="hemantdevgan"
K8S_FILE_NAME="k8s/favourite-service.yml"
FULL_IMAGE="${DOCKER_HUB_USERNAME}/${IMG_NAME}"

# ---------- TERMINAL COLORS ----------
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
    GREEN='\033[1;92m'
    CYAN='\033[1;96m'
    PURPLE='\033[1;95m'
    YELLOW='\033[1;93m'
    RED='\033[1;91m'
    WHITE='\033[1;97m'
    DIM='\033[2m'
    RESET='\033[0m'
else
    GREEN='' CYAN='' PURPLE='' YELLOW=''
    RED='' WHITE='' DIM='' RESET=''
fi

# ---------- UI HELPERS ----------
line() {
    printf "${DIM}────────────────────────────────────────────────${RESET}\n"
}

banner() {
    clear 2>/dev/null || true
    printf "${GREEN}"
    cat <<'EOF'
 __  __ _  ____ _  _  ___ ___
|  \/  | |/ ___| || |/ _ \_ _|
| |\/| | | |   | || | | | | |
| |  | | | |___|__   _| |_| |
|_|  |_|_|\____|  |_| \___/___|
EOF
    printf "${RESET}"
    printf "${CYAN}        FAVOURITE SERVICE DEPLOYMENT${RESET}\n"
    printf "${PURPLE}        DOCKER HUB  >>  KUBERNETES${RESET}\n"
    line
}

stage() {
    printf "\n${CYAN}[ STAGE $1 ]${RESET} ${WHITE}%s${RESET}\n" "$2"
    line
}

success() {
    printf "${GREEN}[  OK  ]${RESET} %s\n" "$1"
}

info() {
    printf "${CYAN}[ INFO ]${RESET} %s\n" "$1"
}

fail() {
    printf "\n${RED}[ FAIL ]${RESET} %s\n" "$1" >&2
    exit 1
}

run() {
    local description="$1"
    shift

    printf "${YELLOW}[ RUN  ]${RESET} %s\n" "$description"
    "$@" || fail "$description failed. Check the error above."
    success "$description completed"
}

# ---------- ERROR HANDLER ----------
on_error() {
    local exit_code=$?
    printf "\n${RED}[ ERROR ]${RESET} Deployment stopped (exit code: %s).\n" "$exit_code" >&2
    exit "$exit_code"
}
trap on_error ERR

# ---------- START ----------
banner

info "Image      : ${FULL_IMAGE}"
info "Dockerfile : ${IMG_FILE_NAME}"
info "K8s config : ${K8S_FILE_NAME}"
info "Pipeline   : BUILD -> TAG -> PUSH -> DEPLOY"

# ---------- PRE-FLIGHT CHECKS ----------
stage "00" "PRE-FLIGHT SYSTEM CHECKS"

[[ -f "$IMG_FILE_NAME" ]] || fail "Dockerfile not found: $IMG_FILE_NAME"
[[ -f "$K8S_FILE_NAME" ]] || fail "Kubernetes YAML not found: $K8S_FILE_NAME"

command -v docker >/dev/null 2>&1 || fail "Docker is not installed."
command -v kubectl >/dev/null 2>&1 || fail "kubectl is not installed."

run "Docker daemon check" docker info
run "Kubernetes cluster check" kubectl cluster-info

success "All pre-flight checks passed"

# ---------- BUILD ----------
stage "01" "BUILDING DOCKER IMAGE"

run "Build image" \
    docker build -f "$IMG_FILE_NAME" -t "$IMG_NAME" .

# ---------- TAG ----------
stage "02" "TAGGING IMAGE"

run "Tag image for Docker Hub" \
    docker tag "$IMG_NAME" "$FULL_IMAGE"

# ---------- PUSH ----------
stage "03" "PUSHING TO DOCKER HUB"

info "Make sure you have logged in using: docker login"
run "Push image" docker push "$FULL_IMAGE"

# ---------- DEPLOY ----------
stage "04" "DEPLOYING TO KUBERNETES"

run "Apply Kubernetes manifests" \
    kubectl apply -f "$K8S_FILE_NAME"

# ---------- FINAL STATUS ----------
stage "05" "DEPLOYMENT COMMANDS COMPLETED"

printf "${GREEN}"
cat <<'EOF'
  ____  _   _  ____ ____ _____ ____ ____
 / ___|| | | / ___/ ___| ____/ ___/ ___|
 \___ \| | | | |  | |   |  _| \___ \___ \
  ___) | |_| | |__| |___| |___ ___)  __) |
 |____/ \___/ \____\____|_____|____/____/
EOF
printf "${RESET}"

success "Image pushed: ${FULL_IMAGE}"
success "Kubernetes manifests applied successfully"

printf "\n${CYAN}Useful verification commands:${RESET}\n"
printf "  ${WHITE}kubectl get pods -A${RESET}\n"
printf "  ${WHITE}kubectl get svc -A${RESET}\n"
printf "  ${WHITE}kubectl rollout status deployment/favourite-service${RESET}\n"
line
printf "${PURPLE}[*] Pipeline finished. Stay sharp, DevOps engineer.${RESET}\n\n"
```
