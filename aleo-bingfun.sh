#check_root
    [[ $EUID != 0 ]] && echo -e "${Error} 登入root帳號獲取權限以繼續安裝 ${Green_background_prefix}sudo su${Font_color_suffix} 命令取得臨時root權限。" && exit 1

#install_rust
    check_root
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source "HOME/.cargo/env"
    echo "Rust installed"

    apt install git -y
    echo "Git installed"

#install_snarkos(){
    mkdir /opt/snarkos && cd /opt/snarkos
    git clone https://github.com/AleoHQ/snarkOS.git --depth 1
    cd snarkOS
    sh ./build_ubuntu.sh
    echo "snarkOS build succeed"

#start_snarkos
    echo "請儲存下列重要資訊!"
    snarkos account new
    read -p -s "儲存完成後請按任意鍵繼續安裝流程"

#start node
    read -p "輸入你的 Private Key:" P_KEY
    PROVER_PRIVATE_KEY=P_KEY ./run-prover.sh > /opt/snarkos/miner.log 2>&1 &
    read -p -s "Aleo節點成功啟動，請按任意鍵查看日誌，查看完畢請按 Ctrl+C 離開本安裝腳本"
    read -p -s "本腳本完全開源免費，請勿使用於商業用途"