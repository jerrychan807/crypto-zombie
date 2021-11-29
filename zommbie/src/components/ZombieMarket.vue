<template>
  <div class="bg-dark">
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
    <h1>
      <b-card bg-variant="dark" text-variant="white" title="Welcome">
        <b-card-text>
          Zombie Market.
        </b-card-text>
      </b-card>
    </h1>
    <table class="table table-hover text-white">
      <thead>
      <tr>
        <th scope="col">僵尸</th>
        <th scope="col">id</th>
        <th scope="col">名字</th>
        <th scope="col">等级</th>
        <th scope="col">卖方</th>
        <th scope="col">dna</th>
        <th scope="col">卖价</th>
        <th></th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="item in zombieGoodsArray" :key="item.id" :deck="true">
        <td>
          <zombie-char :isZombieLoaded="true" :optionalDna="item.dna" :autoGenerate="true"/>
        </td>
        <td>{{ item.zoombie_id }}</td>
        <td>{{ item.name }}</td>
        <td>{{ item.level }}</td>
        <td>{{ item.seller }}</td>
        <td>{{ item.dna }}</td>
        <td>{{ item.sell_price }}
          ether
          <button @click="buy(item.zoombie_id, item.sell_price, $event)">购买</button>
        </td>
      </tr>
      </tbody>
    </table>

    <!--    <b-card-group v-for="item in zombieGoodsArray" :key="item.id" :deck="true">-->
    <!--      <b-card title="Title" style="max-width: 40rem;">-->
    <!--        -->
    <!--        <b-list-group>-->
    <!--          <b-list-group-item>zoombie_id: {{ item.zoombie_id }}</b-list-group-item>-->
    <!--          <b-list-group-item>name: {{ item.name }}</b-list-group-item>-->
    <!--          <b-list-group-item>level: {{ item.level }}</b-list-group-item>-->

    <!--          <b-list-group-item>seller: {{ item.seller }}</b-list-group-item>-->
    <!--&lt;!&ndash;          <b-list-group-item>index: {{ item.index }}</b-list-group-item>&ndash;&gt;-->
    <!--          <b-list-group-item>dna: {{ item.dna }}</b-list-group-item>-->
    <!--          <b-list-group-item>sell_price: {{ item.sell_price }} ether</b-list-group-item>-->
    <!--         -->
    <!--         -->
    <!--        </b-list-group>-->
    <!--        <template v-slot:footer>-->
    <!--          <small class="text-muted"></small>-->
    <!--        </template>-->
    <!--      </b-card>-->
    <!--    </b-card-group>-->
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
      zombieGoodsIdArray: [],
      zombieGoodsArray: [],
      newZombieName: "",
      buyPrice: '',
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
    // console.log(this.zombieGoodsArray)
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
      // this.zombieCore.getZombieCount(this.account).then(
      //     r => {
      //       this.zombieOwnerCount = JSON.parse(JSON.stringify(r))
      //       console.log('my ZombieCount: ' + this.zombieOwnerCount)
      //     }
      // )

      this.zombieCore.getzombieGoodsArray({from: this.account}).then(
          r => {
            this.zombieGoodsIdArray = JSON.parse(JSON.stringify(r))
            console.log('zombieGoodsIdArray: ')
            console.log(this.zombieGoodsIdArray)
            for (let zombieId of this.zombieGoodsIdArray) {
              this.getZombieGoodDetailById(zombieId)
            }
            console.log(this.zombieGoodsArray)
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
    // 读者参与众筹的 join()函数
    // join() {
    //     this.web3.eth.sendTransaction({
    //         from: this.account,
    //         to: this.crowdFund.address,
    //         value: this.web3.utils.toWei(this.price)
    //     }).then(() =>
    //         this.getZombieInfo()
    //     )
    // },

    onSubmit(evt) {
      evt.preventDefault();
      // alert(JSON.stringify(this.addressForm))
      // this.$refs.addResModal.hide();
      this.zombieCore.createZombie(this.newZombieName, {from: this.account}).then(() => {
        this.getZombieInfo()
      })
    },
    buy(zombie_id, sell_price, evt) {
      // alert(JSON.stringify(params))
      evt.preventDefault();
      this.zombieCore.buy(zombie_id, {
        from: this.account,
        value: this.web3.utils.toWei(sell_price, 'ether')
      }).then(() => {
        this.getZombieInfo()
      })
    },

    getZombieGoodDetailById(zombie_id) {
      this.zombieCore.zombieGoodsDict(zombie_id).then(r => {
        const r1 = JSON.parse(JSON.stringify(r))
        const data = {
          'zoombie_id': r1.zoombie_id,
          'sell_price': this.web3.utils.fromWei(r1.sell_price, 'ether'),
          'seller': r1.seller,
          'index': r1.index,
          'dna': ''
        }
        this.zombieGoodsArray.push(data)
        this.zombieCore.zombieArray(zombie_id).then(r => {
          const r1 = JSON.parse(JSON.stringify(r))
          // const data = {
          //   'id': r1.id, 'name': r1.name, 'dna': r1.dna, 'level': r1.level, 'xp':
          //       this.web3.utils.fromWei(r1.xp, 'ether')
          // }
          for (let item of this.zombieGoodsArray) {
            if (item.zoombie_id == zombie_id) {
              item.id = r1.id
              item.dna = r1.dna
              item.name = r1.name
              item.level = r1.level
            }

          }


        })
        // console.log(data)
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
