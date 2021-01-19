<template>
  <div>
    <div class="recruiting_show_comments_form">
      <textarea id="comment_textarea" placeholder="メッセージを入力してください"></textarea>
    </div>
    <div @click="comment" class="recruiting_show_comments_form_btn">
        <span>投稿する</span>
    </div>
    <div v-if="errorMasseges" class="recruiting_show_comments_form_error">
      <p>{{ errorMasseges }}</p>
    </div>
  </div>
</template>
<script>
import axios from 'axios'
var token = document.getElementsByName('csrf-token')[0].getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = token
var recruitintgId = document.getElementsByName('recruiting_id')[0].getAttribute('content')

export default {
  data() {
    return {
     recruitingId : Number(recruitintgId),
     errorMasseges : null
    };
  },
  created() {
  },
  methods:{
    comment: function(){
        var comment = document.getElementById("comment_textarea").value;
        axios({
        method: 'post',
        url: '/comments',
        data: {
          comment: {
            content: comment,
            recruiting_id: this.recruitingId
          }
        },
        validateStatus: function(status) {
          return status < 500;
        },
      }).then((response) => {
        if (response.status == 201) {
          location.reload();
        } else if (response.status == 409){
          this.errorMasseges = response.data.error_message.authority[0];
        }
      })
      .catch((error) =>  {
        this.errorMasseges = '投稿に失敗しました。再読み込みしてください。'
      });
    }
  }
} 
</script>