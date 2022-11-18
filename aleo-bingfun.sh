aleo_key="/root/aleo_key.txt"

full_install(){
cat /root/aleo.txt
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
    mkdir /opt/snarkos && cd /opt/snarkos
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
    sleep 3
}

aleo_client(){
    source $HOME/.cargo/env
    source /etc/profile
    cd /root/snarkOS
    nohup ./run-client.sh > run-client.log 2>&1 &
}

aleo_prover(){
    source $HOME/.cargo/env
    source /etc/profile
    cd /root/snarkOS
    nohup ./run-prover.sh > run-prover.log 2>&1 &
}

aleo_address(){
    cat /root/aleo.txt
}

echo "本腳本完全開源免費，請勿使用於商業用途"
echo "Made with Love by @b1ngfun"
echo "1) What"
echo "Donates are welcome, FUCK SBF"
echo "Ethereum,Polygon,BSC chain address"
echo "0xcfb1ce68A1cb80AB7423622dB26Bd9966F025E17"
echo "Binance ID Donate : 37528377"


aleo_one_key_menu(){
echo "
1.完整安裝 aleo節點
2.執行 Aleo client
3.執行 Aleo prover
4.讀取 Aleo 帳戶詳細資料
5.離開
" && echo
read -e -p " 請輸入選項 [1-4]:" number
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
    aleo_address
    ;;
5)
    exit
    ;;    

*)
    echo
    echo -e "輸入錯誤"
    ;;
esac
}