# crypto-zombie
僵尸世界-区块链NFT游戏

---

# 在线Demo:

[crypto-zombie-website](http://199.255.96.224:9090/preview)

需要使用Chrome浏览器和Metamask钱包插件,连接`Ropsten`测试网

---

# 效果图:

![20211129150336](https://raw.githubusercontent.com/jerrychan807/imggg/master/image/20211129150336.png)

![20211129150410](https://raw.githubusercontent.com/jerrychan807/imggg/master/image/20211129150410.png)

---

# 项目安装-Web

```bash
# 进入前端目录
$ cd zommbie

# 安装前端依赖
$ npm install

# 启动游戏
$ npm run serve
```

访问 `http://YourIp:9090/preview`

---

# 需求列表:

## 基因:

- 每个僵尸有一个16位10进制数字作为基因
- 根据名称和随机数创建僵尸基因
- 每人可以免费领养2只僵尸

## 升级:

- 每分钟只能喂食一次(原本设置为每天，后面忘记改了)
- 每次喂食需要消耗`0.01`ether，可获得1000xp
- 每分钟只能冒险一次(原本设置为每天，后面忘记改了)
- 每次冒险可获得250xp
- 升1级需要250xp,升2级需要500xp
- 每一级递增250xp

## 交易:

- 可以把自己的僵尸放到市场定价并销售
- 可以购买市场的僵尸

---

# Refs:

- https://github.com/onee-io/crypto-zombies
- https://github.com/Fankouzu/smart-contract/blob/master/Solidity%20Lesson%2004/contracts/zombieCore.sol
- https://fankouzu.github.io/my-crypto-zombie/?MyZombie
