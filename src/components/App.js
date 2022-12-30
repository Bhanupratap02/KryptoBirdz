import "./App.css"
import React, { useEffect, useState } from "react"
import KryptoBird from "../abis/KryptoBird.json";
import Web3 from "web3";
import { MDBBtn, MDBCard, MDBCardBody, MDBCardImage, MDBCardText, MDBCardTitle } from "mdb-react-ui-kit";
import "./App.css";
function App() {
    const [walletAddress, setWalletAddress] = useState("");
    const [contract, setContract] = useState(null);
    const [totalSupply, setTotalSupply] = useState(0);
    const [kryptoBirdz, setKryptoBirdz] = useState([]);
    const [kryptoBird, setKryptoBird] = useState("");

 // connect to metamask wallet on button click
    const connectWallet = async () => {
        // Check if MetaMask is installed on user's browser
        if (window.ethereum) {
            try {
                const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
                setWalletAddress(accounts[0]);
            } catch (error) {
                console.error(error.message)
            }

        } else {
            alert("Please install Mask");
        }
    }
    // get connected account address on page reload
    const getConnectedWallet = async () => {
        // Check if MetaMask is installed on user's browser
        if (window.ethereum) {
            try {
                const accounts = await window.ethereum.request({ method: 'eth_accounts' });
                if(accounts.length >0)
                {setWalletAddress(accounts[0]);}
                else {
                    console.log("connect metamask using connect button")
                }
            } catch (error) {
                console.error(error.message)
            }

        } else {
            alert("Please install Mask");
        }
    }
    // get account address on  account change
    const addWalletListener = async () => {
        // Check if MetaMask is installed on user's browser
        if ( typeof window.ethereum != "undefined") {
          window.ethereum.on("accountsChanged",(accounts)=>{
             setWalletAddress(accounts[0])
             console.log(accounts[0]);
          })

        } else {
            setWalletAddress(0);
            alert("Please install Mask");
        }
    }
    const mint = async  (kryptoBird) =>{
        try {
            await contract.methods.mint(kryptoBird).send({ from: walletAddress }).once("receipt", (receipt) => {
                setKryptoBirdz(prev => [...prev, kryptoBird]);
            })  
        } catch (error) {
           console.error(error.message) 
        }
       
    }
    useEffect(() => {
        getConnectedWallet()
        addWalletListener();
    });

    useEffect(() => {
        const createContractInstance = async () =>{
            if( typeof window.ethereum != "undefined"){
            const networkId = await window.ethereum.request({ method: 'net_version' });
            if(networkId){
                const networkData = KryptoBird.networks[networkId];
                if (networkData) {
                    const abi = KryptoBird.abi;
                    const address = networkData.address;
                    const web3 = new Web3(window.ethereum);
                    const contract = new web3.eth.Contract(abi, address);
                    setContract(contract);
                    const totalSupply = await contract.methods.totalSupply().call();
                    setTotalSupply(totalSupply)
                    for (let i = 0; i < totalSupply; i++) {
                        let KryptoBird = await contract.methods.kryptoBirdz(i).call();
                        setKryptoBirdz(prev => [...prev, KryptoBird]);

                    }
                } else {
                    alert("Smart contract not deployed");
                }
            } else{
                console.log("connect to metamask using button");
            }
             
            }else{
                alert("please install metamask")
            }
        }
        createContractInstance()
    },[]);
  
    return (
        <div className="container-filled">
        <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-1  shadow" style={{color:"white"}}>
            <div className="navbar-brand col-sm-3 col-md-3 mr-0 ml-5">
             <h4>KryptoBird - NFT Marketplace</h4>
            </div>
                {walletAddress && walletAddress.length > 0 ? <ul className="navbar-nav px-3">
                    <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
                        <span className="text-white">
                            {walletAddress && walletAddress.length > 0 ? `connected:${walletAddress.substring(0, 6)}.....${walletAddress.substring(38)}` : "connect Wallet"}
                        </span>
                    </li>
                </ul> : <button type="button" className="btn btn-outline-warning btn-sm mr-3" onClick={() => {
                    connectWallet()}}>
                  Connect Wallet
                  </button> }    
        </nav>
           <div className="container-fluid" style={{marginTop:"7rem"}}>
            <div className="row">
                <div className="col-lg-10 d-flex text-center">
                <div className="content ml-auto mr-auto" style={{opacity:"0.8"}}>
    
                <form onSubmit={(e)=>{
                e.preventDefault();
                 kryptoBird && mint(kryptoBird);
                 setKryptoBird("");
                }} className="d-flex">
                <div className="form-group d-flex textCenter">
                                    <input type={"text"} placeholder="Add a file location" className="form-control mx-auto mb-1" value={kryptoBird} onChange={(e) => setKryptoBird(e.target.value)} style={{width:"29rem"}} />
                                    <button type="submit" disabled={!kryptoBird} className="btn btn-danger  px-3 ml-2" style={{ marginTop: "-5px" }}>Mint</button>
                </div>
                
                
                </form>
                </div>
             </div>
            </div>
           <hr></hr>
            <div className="row textCentre">
            {/* <div className="col-lg-6 col-md-7 d-flex"> */}
                        {kryptoBirdz.map((item, index) => (<div>
                            <div className="mx-2 ml-4 mb-3">
                                <MDBCard className="token img" style={{ maxWidth: "15rem",maxHeight:"30.8rem" }} >
                                    <MDBCardImage src={item} position="top" style={{ marginRight: "4px" }}  />
                                <MDBCardBody>
                                    <MDBCardTitle>
                                        KryptoBirdz
                                    </MDBCardTitle>
                                    <MDBCardText>The KryptBirdz are  uniguely generated KBIRDz from the cyber punk cloud galaxy mystopia!.Each kryprtoBird is owned by a single owner</MDBCardText>
                                    <MDBBtn href={item}>Download</MDBBtn>
                                </MDBCardBody>
                                </MDBCard>
                            </div>
                        </div>))}
            {/* </div> */}
                  
            </div>
           </div>
        </div>
    )
}

export default App;