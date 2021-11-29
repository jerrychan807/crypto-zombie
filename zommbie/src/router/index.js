import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import ZombiePreview from '../components/ZombiePreview.vue'
import ZombieMarket from '../components/ZombieMarket.vue'

Vue.use(VueRouter)

const routes = [
    {
        path: '/',
        name: 'Home',
        component: Home
    },
    {
        path: '/preview',
        name: 'preview',
        component: ZombiePreview
    },
    {
        path: '/market',
        name: 'market',
        component: ZombieMarket
    }
]

const router = new VueRouter({
    mode: 'history',
    base: process.env.BASE_URL,
    routes
})

export default router
