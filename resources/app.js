import Vue from 'vue'
import router from './router'
import App from './app.vue'
import './lib/bootstrap-vue'
import './lib/rails'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    name: 'ShareLoc',
    router,
    render: h => h(App)
  }).$mount('#app')
})