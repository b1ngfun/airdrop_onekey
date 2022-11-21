aleo_key="/root/aleo_key.txt"
Crontab_file="/usr/bin/crontab"

full_install(){
#install_curl
    apt-get install curl -y
    echo "curl installed"

#install_git
    apt-get install git -y
    echo "Git installed"

#install_rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
    echo "Rust installed"
    
#install_snarkos
    git clone https://github.com/AleoHQ/snarkOS.git --depth 1 /root/snarkOS
    cd /root/snarkOS
    bash root/snarkOS/build_ubuntu.sh
    cargo install --path /root/snarkOS
    if [ -f ${aleo_key} ]
    then
        echo "Aleo地址已存在"
    else
        snarkos account new > /root/aleo.txt
        echo "snarkOS build succeed"
    fi
    cat /root/aleo.txt
    PrivateKey=$(cat /root/aleo.txt | grep Private | awk '{print $3}')
    echo export PROVER_PRIVATE_KEY=$PrivateKey >> /etc/profile
    source /etc/profile
    echo "Aleo帳戶詳細資料已儲存於 /root/aleo.txt"
}

aleo_client(){
    source $HOME/.cargo/env
    source /etc/profile
    cd /root/snarkOS
    nohup ./run-client.sh > run-client.log 2>&1 &
    echo "Aleo Client已成功啟動"
}

aleo_prover(){
    source $HOME/.cargo/env
    source /etc/profile
    cd /root/snarkOS
    nohup ./run-prover.sh > run-prover.log 2>&1 &
    echo "Aleo Prover已成功啟動"
}

aleo_log(){
    tail -f -n100 /root/snarkOS/miner.log
}

aleo_address(){
    cat /root/aleo.txt
}

exit(){
    exit
}

echo "本腳本完全開源免費，請勿使用於商業用途"
echo "Made with Love by @b1ngfun"
echo "Donates are welcome, FUCK SBF"
echo "Binance ID Donate : 37528377"
echo "
1.完整安裝 aleo節點
2.執行 Aleo client
3.執行 Aleo prover
4.查看Log確認運作狀態
5.讀取 Aleo 帳戶詳細資料
6.離開
"
read -e -p " 請輸入選項 [1-6]:" number
case "$number" in
1)
    full_install
    ;;
2)
    aleo_client
    ;;
3)
    aleo_prover
    ;;
4)
    aleo_log
    ;;
5)
    aleo_address
    ;;
6)
    exit
    ;;    

*)
    echo
    echo -e "輸入錯誤"
    ;;
esac