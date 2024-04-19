# NetplanApply

Netplan configuration script for Ubuntu.

## Usage

1. Make the script executable by running:

    ```bash
    sudo chmod +x setipubuntu.sh
    ```

2. Execute the script:

    ```bash
    sudo sh ./setipubuntu.sh
    ```

3. You will be prompted to choose between DHCP and static IP configuration. 

    - If you choose static, follow the prompts to set your IP address, gateway, and DNS servers.

4. After configuring the network settings, the script will display available netplan configurations. 

5. Choose the correct configuration file. 

6. Netplan will be configured with your new network settings.

