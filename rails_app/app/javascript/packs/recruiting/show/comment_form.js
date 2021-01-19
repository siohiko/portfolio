import Vue from 'vue'
import CommentSection from '../../vue/recruiting/show/comment_form.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(CommentSection)
  }).$mount('#recruiting_show_mounted_comment_form')
})
