initialize_system() {
    if [ ! -d "active_logs" ]; then
        echo "Creating active_logs directory..."
        mkdir active_logs
    fi

    if [ ! -d "archived_logs" ]; then
        echo "Creating archived_logs directory..."
        mkdir archived_logs
    fi

    if [ ! -d "reports" ]; then
        echo "Creating reports directory..."
        mkdir reports
    fi
}

# Permissions
secure_data() {

    chmod 700 active_logs
    ls -ld active_logs
    
}

# Orchestration
main() {
    initialize_system
    secure_data
    echo "System Environment Secured on $(date)"
}
main