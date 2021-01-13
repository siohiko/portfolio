import Vue from 'vue'
import RecruitingApplication from '../../vue/recruiting/show/operation_for_member.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(RecruitingApplication)
  }).$mount('#recruiting_operation')
})
