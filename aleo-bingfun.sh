echo "Algo 自動安裝腳本 by B1ngfun"
echo "本腳本完全開源免費，請勿使用於商業用途"
echo "請使用root帳號服用腳本否則會出現錯誤，五秒後繼續安裝流程。"
sleep 5

#install_curl
    apt-get install curl
    echo "curl installed"

#install_git
    apt-get install git -y
    echo "Git installed"

#install_rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source "$HOME/.cargo/env"
    echo "Rust installed"

#install_snarkos
    mkdir /opt/snarkos && cd /opt/snarkos
    git clone https://github.com/AleoHQ/snarkOS.git --depth 1
    cd snarkOS
    sh ./build_ubuntu.sh
    echo "snarkOS build succeed"

#start_snarkos
    echo "請儲存下列重要資訊!"
    snarkos account new

#start node
    read -p "貼上你的 Private Key:" P_KEY
    PROVER_PRIVATE_KEY=P_KEY ./run-prover.sh > /opt/snarkos/miner.log 2>&1 &

#watch log
    echo "本腳本完全開源免費，請勿使用於商業用途"
    echo "Aleo節點成功啟動，五秒後進入節點畫面，使用完畢請按Ctrl+C 或直接離開腳本"
    sleep 5
    tail -f -n100 /opt/snarkos/miner.log