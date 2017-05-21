# Factory

This repository is workshop for sonm smart-contracts organisation.


See presale and token contracts here:
(https://github.com/sonm-io/token)

Contracts schematic could be found here :
(https://github.com/sonm-io/Contracts-scheme)

[Wallets contracts](https://github.com/sonm-io/Smart-dummy/tree/master/contracts/Hubs&Miners)



[Factory contract](https://github.com/sonm-io/Forge/blob/master/contracts/Hubs/Factory.sol)

[Whitelist prototype](https://github.com/sonm-io/Forge/tree/master/contracts/Whitelist)

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
