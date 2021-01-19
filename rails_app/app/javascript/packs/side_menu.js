import Vue from 'vue'
import SideMenu from './vue/side_menu.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(SideMenu)
  }).$mount('#side_mounted')
})
