import Vue from 'vue'
import App from './App.vue'
import router from './router'
import 'bootstrap/dist/css/bootstrap.css';
import BootstrapVue from 'bootstrap-vue';
import ZombieChar from "zombie-char-component-vue2";

Vue.use(BootstrapVue);

Vue.component("zombie-char", ZombieChar);
Vue.config.productionTip = false

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
