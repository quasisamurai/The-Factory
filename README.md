# Factory

This repository is workshop for sonm smart-contracts organisation.


See presale and token contracts here:
(https://github.com/sonm-io/token)

Contracts schematic could be found here :
(https://github.com/sonm-io/Contracts-scheme)



## Golang artefacts

 Golang artefacts of solidity contracts is used for bindings contract to native golang applications.

 You can find golang artefacts in ```contracts``` directory

 To generate artefact from source you should install ```abigen``` first.

 Abigen is a tool from ```go-ethereum``` package.

### Abigen install

 First you need to install godep tool by

 ```go get github.com/tools/godep```

  Then you should install abigen itself

  ```
  cd $GOPATH/src/github.com/ethereum/go-ethereum
  godep go install ./cmd/abigen
  ```



 If something wrong with abigen dependency (like someone forget to check broken dep from abigen in official go-ethereum)
  you could try just ```go install abigen ``` from  ```./cmd/``` directory.

  You should see your abigen binary in  ```/bin/``` your $GOPATH directory.


### Generating go artefacts

  You should use proper way to generate golang bindings from source ```.sol``` files.

  ```abigen --sol token.sol --pkg main --out token.go ```

  Where the flags are:

    --abi: Mandatory path to the contract ABI to bind to
    --pgk: Mandatory Go package name to place the Go code into
    --type: Optional Go type name to assign to the binding struct
    --out: Optional output path for the generated Go source file (not set = stdout)


  this command will generate go bindings from your token.sol contract and you can further use it in your go application.

  note, that if you will use ```--type``` flags as
  ```abigen --abi token.abi --pkg main --type Token --out token.go```

  it will create new ```Token``` struct for your go project and you can be use this struct without neccesarry to import your generated file into main project.
  This is simplier way to develop, but may be confusing when you would not remember where do you declarated this struct and how to change it.

  note - you **have to ** store zeppelin library in contracts directory because apigen does not recognise ethpm folders as truffle do.

  ### GO generate
  You can generate go binds from sol files by ```go generate``` see more info in ```generator.go``` in contracts directory.

  To generate packages you need to run in console ```go generate``` in contracts directory. Generated files will be saved in ```/go-build/``` directory.

  # Rinkbey Testnet

  To run rinkey testnet through go-ethereum node you should run it as follows:

  ```
  geth --networkid=4 --datadir=$HOME/.rinkeby --cache=512 --ethstats='yournode:Respect my authoritah!@stats.rinkeby.io' --bootnodes=enode://a24ac7c5484ef4ed0c5eb2d36620ba4e4aa13b8c84684e1b4aab0cebea2ae45cb4d375b77eab56516d34bfbd3c1a833fc51296ff084b770b94fb9028c4d25ccf@52.169.42.101:30303 --rpc --password <(echo yourpassword) --unlock 0 --rpccorsdomain localhost --rpcport 8080

```

  To attach official ethereum foundation wallet
  ```
  ethereumwallet --rpc $HOME/.rinkeby/geth.ipc --node-networkid=4 --node-datadir=$HOME/.rinkeby --node-ethstats='yournode:Respect my authoritah!@stats.rinkeby.io' --node-bootnodes=enode://a24ac7c5484ef4ed0c5eb2d36620ba4e4aa13b8c84684e1b4aab0cebea2ae45cb4d375b77eab56516d34bfbd3c1a833fc51296ff084b770b94fb9028c4d25ccf@52.169.42.101:30303
```

 ## Rinkbey metamask

  Metamask plugin is currently working perfect with Rinkbey testnet. You could run frontend of Factory as ```npm run dev ``` which will build react frontend and start minimal npm server
  You could interact with Factory contracts throught this frontend and using metamask as a node to work with rinkbey testnet.


 ## Rinkbey testnet contract addresses:

 Migrations: 0x6fe8b88ddab1f97be0b2fb7d49cf4e2beb78c692
 SDT: 0x5dc277eec942aef60d360c3b4e112d40d1301d80
 Factory: 0xb121cbde60afb91761fd28d753faa0a6314c9747
 Whitelist: 0xb0a80ab6b8d1082c5bbbf8bf77c93604cebe12f5

 Test hubwallet contracts
 0x1b120c90f1b2f15924991dff1a4f4cdbf30478bc

 
