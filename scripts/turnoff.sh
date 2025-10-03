#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

main() {
    clear
    echo "=================================="
    echo "    SSH Remote Command Tool       "
    echo "    (Teacher Account - Batch Mode)"
    echo "=================================="
    echo
    
    # Check if command argument is provided
    if [ -z "$1" ]; then
        print_error "No command specified!"
        echo "Usage: $0 \"command\""
        echo "Example: $0 \"whoami\""
        echo "Example: $0 \"sudo poweroff\""
        echo
        print_status "Press Enter to exit..."
        read
        exit 1
    fi
    
    COMMAND="$1"
    
    print_status "Running as administrator"
    print_status "Target: 192.168.104.1-23 via teacher account"
    print_status "Command to execute: $COMMAND"
    echo
    print_status "Press Enter to confirm..."
    read
  
    print_status "Sending commands to all computers..."
    for i in {1..23}; do 
        ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no teacher@192.168.104.$i "$COMMAND" &
    done
    
    # Wait for all background processes to complete
    wait
    
    echo
    print_success "All commands sent!"
    print_status "Press Enter to exit..."
    read
}

# Run main function
main "$@"
