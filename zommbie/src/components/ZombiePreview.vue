<template>
  <div className="row zombie-parts-bin-component" authenticated="true" lesson="1" lessonidx="1">
    <b-navbar toggleable="lg" type="dark" variant="dark">
      <b-navbar-brand href="#">CryptoZombie</b-navbar-brand>

      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav>
          <b-nav-item href="/preview">我的僵尸</b-nav-item>
          <b-nav-item href="/market">僵尸市场</b-nav-item>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>


    <b-card-group deck v-for="item in zombieOwnerArray" :key="item.id">
      <b-card title="" style="max-width: 30rem;">
        <zombie-char :isZombieLoaded="true" :optionalDna="item.dna" :autoGenerate="true"/>
        <b-list-group>
          <b-list-group-item>id: {{ item.id }}</b-list-group-item>
          <b-list-group-item>Name: {{ item.name }}</b-list-group-item>
          <b-list-group-item>dna: {{ item.dna }}</b-list-group-item>
          <b-list-group-item>level: {{ item.level }}</b-list-group-item>
          <b-list-group-item>xp: {{ item.xp }}</b-list-group-item>
          <button @click="adventure(item.id)">冒险</button>
          <button @click="feed(item.id)">喂养(0.01ether)</button>
          <button @click="levelup(item.id)">升级</button>
          <b-form inline @submit="onSell(item.id, $event)" class="w-100">
            <!--          <label class="sr-only" for="inline-form-input-name">Address</label>-->
            <b-input
                id="inline-form-input-name"
                class="mb-2 mr-sm-2 mb-sm-0"
                placeholder="卖出价格"
                type="text"
                v-model="sellPrice"
            ></b-input>
            <b-button type="submit" variant="primary">卖出</b-button>
          </b-form>
        </b-list-group>
        <template v-slot:footer>
          <small class="text-muted"></small>
        </template>
      </b-card>
    </b-card-group>
    <div v-if="zombieOwnerCount < 2" className="zombie-preview" id="zombie-preview">
      <b-form inline @submit="onSubmit" class="w-100">
        <!--          <label class="sr-only" for="inline-form-input-name">Address</label>-->
        <b-input
            id="inline-form-input-name"
            class="mb-2 mr-sm-2 mb-sm-0"
            placeholder="铸造新的Zombie,请输入zombie名字"
            type="text"
            v-model="newZombieName"
        ></b-input>
        <b-button type="submit" variant="primary">mint</b-button>
      </b-form>
    </div>
  </div>
</template>


<script>
import contract from "truffle-contract";
// import zoombieUpgrader from '../../public/build/contracts/ZoombieUpgrader.json';
import zombieCore from '../../public/build/contracts/ZombieCore.json';

const Web3 = require('web3');

export default {
  name: 'ZombiePreview',
  // 定义上面HTML模板中使用的变量
  data() {
    return {
      className: "zombie-parts head-visible-1 eye-visible-6 shirt-visible-1",
      style: {
        color: '{filter:"hue-rotate(0deg)"}',
        skin: '{filter:"hue-rotate(0deg)"}',
        eye_color: '{filter:"hue-rotate(0deg)"}',
      },
      zombies: [],
      zombieCount: 0,
      zombieOwnerCount: 0,
      zombieIdArray: [],
      zombieOwnerArray: [],
      newZombieName: "",
      sellPrice: '',
      total: 0,
      isAuthor: true,
    }
  },
  // 当前Vue组件被创建时回调的hook 函数
  async created() {
    //  初始化 web3及账号
    await this.initWeb3Account()
    //  初始化合约实例
    await this.initContract()
    //  获取合约的状态信息
    await this.getZombieInfo()

    // console.log("=========")
    // console.log(this.zombieOwnerArray)
  },
  methods: {
    async initWeb3Account() {
      console.log("initWeb3Account 方法执行了-------");
      // 检查新版MetaMask
      if (window.ethereum) {
        this.provider = window.ethereum;
        try {
          // 请求用户账号授权
          await window.ethereum.enable();
        } catch (error) {
          // 用户拒绝了访问
          console.log("User denied account access");
        }
      }
      // 老版 MetaMask
      else if (window.web3) {
        this.provider = window.web3.currentProvider;
      }
      // 如果没有注入的web3实例，回退到使用 Ganache
      else {
        alert("请安装MetaMask!");
        this.provider = new Web3.providers.HttpProvider("http://127.0.0.1:7545");
      }
      this.web3 = new Web3(this.provider);
      this.web3.eth.getAccounts().then(accs => {
        this.account = accs[0]
        console.log(accs)
      })
    },
    async initContract() {
      // const zoombieUpgraderContract = contract(zoombieUpgrader)
      // zoombieUpgraderContract.setProvider(this.provider)
      // this.zoombieUpgrader = await zoombieUpgraderContract.deployed()

      const zombieCoreContract = contract(zombieCore)
      zombieCoreContract.setProvider(this.provider)
      this.zombieCore = await zombieCoreContract.deployed()
    },
    async getZombieInfo() {
      this.zombieCore.getZombieCount(this.account).then(
          r => {
            this.zombieOwnerCount = JSON.parse(JSON.stringify(r))
            console.log('my ZombieCount: ' + this.zombieOwnerCount)
          }
      )

      this.zombieCore.getAllZombie(this.account).then(
          r => {
            this.zombieIdArray = JSON.parse(JSON.stringify(r))
            console.log('get my AllZombie: ')
            console.log(this.zombieIdArray)
            for (let zombieId of this.zombieIdArray) {
              this.getZombieDetailById(zombieId)
            }
          }
      )

      // this.zoombieUpgrader.zoombieCount(this.account).then(
      //     r => {
      //       this.zoombieCount = JSON.parse(JSON.stringify(r))
      //       console.log('get AllZoombie: ' + JSON.parse(JSON.stringify(r)))
      //
      //     }
      // )
    },

    onSubmit(evt) {
      evt.preventDefault();
      // alert(JSON.stringify(this.addressForm))
      // this.$refs.addResModal.hide();
      this.zombieCore.createZoombie(this.newZombieName, {from: this.account}).then(() => {
        this.getZombieInfo()
      })
    },
    onSell(params, evt) {
      // alert(JSON.stringify(params))
      evt.preventDefault();
      this.zombieCore.sell(params, this.web3.utils.toWei(this.sellPrice, 'ether'), {from: this.account}).then(() => {
        this.getZombieInfo()
      })
    },
    adventure(params = '') {
      console.log(params)
      this.zombieCore.adventure(params, {from: this.account}).then(() => {
        this.getZombieInfo()
      })
    },
    feed(params = '') {
      console.log(params)
      this.zombieCore.feed(params, {from: this.account, value: this.web3.utils.toWei('0.01', 'ether')}).then(() => {
        this.getZombieInfo()
      })
    },
    levelup(params = '') {
      console.log(params)
      this.zombieCore.level_up(params, {from: this.account}).then(() => {
        this.getZombieInfo()
      })
    },

    getZombieDetailById(zombie_id) {
      this.zombieCore.zombieArray(zombie_id).then(r => {
        const r1 = JSON.parse(JSON.stringify(r))
        const data = {
          'id': r1.id, 'name': r1.name, 'dna': r1.dna, 'level': r1.level, 'xp':
              this.web3.utils.fromWei(r1.xp, 'ether')
        }
        this.zombieOwnerArray.push(data)
        console.log(data)
      })
    },
    // 创作者提取资金的 withdrawFund()函数
    // withdrawFund() {
    //   this.crowdFund.withdrawFund({
    //     from: this.account
    //   }).then(() => {
    //     this.getZombieInfo()
    //   })
    // }
  }
}
</script>
