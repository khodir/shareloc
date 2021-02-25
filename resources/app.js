import Vue from 'vue'
import router from './router'
import './lib/bootstrap-vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    name: 'ShareLoc',
    router,
    template: `<router-view/>`
  }).$mount('#app')
})