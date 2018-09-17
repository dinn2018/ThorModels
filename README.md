# thor-models
Swift library defines VeChain Thor data models, to aid iOS and macOS development.

### Basics

----

#### Account

create account  by mnemonic phrase 

```
let account = Account(mnemonicPhrase: "tonight access dinner guide sunny ball copper lucky feel flavor choose cluster")

print(account?.privateKey?.hexString(),account?.address?.hexString)
```

create account  by private key 

```
let account = Account(privateKey: "0x0f0f630e380dbe8199b2f649495d4b6f6c0b6a47dd4c1ace6c1942b13011857b".hexadecimal()!)

print(account?.privateKey?.hexString(),account?.address?.hexString)
```

create keystore json by existed account

```
let account = Account(privateKey: "0x0f0f630e380dbe8199b2f649495d4b6f6c0b6a47dd4c1ace6c1942b13011857b".hexadecimal()!)

account?.encryptSecretStorageJSON(password: "password", callback: { (json, err) in
    if err == nil {
		print(json)
    }
})
```

create account by decripting keystore json

```
let json = "{\"version\":3,\"id\":\"2A3195DE-3F84-41AF-98B6-18A7DD3A194C\",\"crypto\":{\"mac\":\"d9a04fdc7a282b902eef18d393a0c4eb5d4600b40f7b515c5f4fc8971eb84dcc\",\"kdfparams\":{\"dklen\":32,\"r\":8,\"salt\":\"12a4684c5571d960163f5dc9e39122af638871b767125e6b44a3eab1ac718a1a\",\"p\":1,\"n\":262144},\"cipherparams\":{\"iv\":\"c09df1fcd9c8e4a9dc957e8ca2a93290\"},\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"a026b3e808d3ef4c7fb2ab1049e1e81928b32f4f4ff55c7e27326ab4daf8157b\",\"kdf\":\"scrypt\"},\"address\":\"ba138c7957f750a816799831b784013e2f0cb0d8\"}"

Account.decryptSecretStorageJSON(json: json, password: "password") { (account, err) in
	if err == nil {
		print(account?.privateKey?.hexString(),account?.address?.hexString)
	}
}
```

----

#### Transaction

Create transaction

```
let clause = Clause(toAddress: Address(hexString: "0x7567d83b7b8d80addcb281a71d54fc7b3364ffed"), value: BigNumber(integer: 10), data: nil)

let tx = Transaction()
tx.chainTag(chainTag: ChainTag.test)
	.blockRef(blockRef:  BlockRef(blockNumber: 0))
	.expiration(expiration: 10)
	.gas(gas: 21000)
	.appendClause(clause: clause)
	
print(tx.ID()?.hexString)
```



