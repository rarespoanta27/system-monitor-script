# system-monitor-script

A comprehensive Bash script for monitoring key system resources on Linux. It provides a clean, color-coded, at-a-glance overview of your server's health directly in the terminal.

---

## 📸 Demo


*A snapshot of the script's output, showing a clear, color-coded overview of system health.*

---

## ✨ Features

-   **📊 Resource Monitoring:** Real-time usage statistics for **CPU**, **RAM**, and the root **Disk** partition.
-   **⚙️ System Load:** Displays the 1, 5, and 15-minute load averages.
-   **🌐 Network Analysis:**
    -   Calculates real-time network traffic (**Rx/Tx KB/s**) for a specified interface.
    -   Lists the top 5 active/established network connections.
-   **📈 Top Processes:** Identifies the top 5 processes by both **CPU** and **Memory** consumption to quickly spot resource hogs.
-   **ℹ️ System Information:** Provides key system details including **Hostname**, **Kernel Version**, **Uptime**, and the number of **Logged-in Users**.
-   **🎨 Color-Coded Alerts:** Uses colors to provide instant visual feedback. The system status is marked as **OK** (green) or **WARNING** (yellow) if any resource exceeds its configurable threshold.

---

## 🔧 Prerequisites

-   A Debian/Ubuntu-based Linux system.
-   The `bc` command-line calculator is required for network speed calculations. If it's not installed, you can install it with:
    ```bash
    sudo apt update && sudo apt install bc
    ```

---

## 🚀 Usage

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/rarespoanta27/system-monitor-script.git](https://github.com/rarespoanta27/system-monitor-script.git)
    cd system-monitor-script
    ```

2.  **Make the script executable:**
    ```bash
    chmod +x pro_monitor.sh
    ```
    *(Assuming your script is named `pro_monitor.sh`)*

3.  **Run the script:**
    ```bash
    ./pro_monitor.sh
    ```

---

## 🛠️ Configuration

Configuration is done by editing the variables at the top of the script file.

-   `CPU_THRESHOLD`: CPU usage percentage to trigger a warning.
-   `MEM_THRESHOLD`: Memory usage percentage to trigger a warning.
-   `DISK_THRESHOLD`: Disk usage percentage to trigger a warning.
-   `LOAD_THRESHOLD`: 1-minute load average to trigger a warning.
-   `NETWORK_INTERFACE`: The network interface to monitor (e.g., `eth0`, `ens33`). You can find yours with the `ip a` command.

---

## 📝 License

This project is licensed under the MIT License.
