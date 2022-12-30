
const { should } = require("chai");
let chai = require("chai");
const assert = chai.assert;
 chai.should();
chai.use(require("chai-as-promised"))

const KryptoBird = artifacts.require("./KryptoBird");
contract("KryptoBird", (accounts)=>{
    let contract;
    before(async ()=>{
        contract = await KryptoBird.deployed();
    })



     // testing container - describe
     // it takes a string and  callback function
     // the string what about we are testing
     // here we are testing that the contract is correctly deployed or not
     describe("deployment",async ()=>{
       // test samples with writing it
        it("deploys successfully",async ()=>{
            const address = contract.address;
            assert.notEqual(address,'');
            assert.notEqual(address,null);
            assert.notEqual(address,undefined);
            assert.notEqual(address,0x0);
        });
        it("has a name" , async ()=>{
            const name = await contract.name();
            assert.equal(name,"Kryptobird");
        });
         it("has a symbol", async () => {
             const symbol = await contract.symbol();
             assert.equal(symbol, "KBIRDZ");
         });
     });
     describe("minting",async ()=>{
        it("creates a new token",async ()=>{
            const result = await contract.mint('https....1');
            const totalSupply = await contract.totalSupply();
            //success
            assert.equal(totalSupply,1);
            const event = result.logs[0].args;
            assert.equal(event.from,"0x0000000000000000000000000000000000000000","from is the contract");
            assert.equal(event.to,accounts[0],"to is msg.sender");

            // failure- check that if we mint the same token then it should be failed
            await contract.mint("https....1").should.be.rejected
        })
     });

     describe("indexing",async ()=>{
        it("lists Kryptobirdz",async ()=>{
            // mint three more tokens
            await contract.mint('https....2');
            await contract.mint('https....3');
            await contract.mint('https....4');

            const totalSupply = await contract.totalSupply();

            // loop through list and grab KBirdz from lists
            let result = [];
            for(let i=0;i<totalSupply;i++){
                let KryptoBird = await contract.kryptoBirdz(i);
                result.push(KryptoBird);
            }
            let expect = ['https....1', 'https....2', 'https....3', 'https....4']
            assert.equal(result.join(','),expect.join(','));
        })
     })

})