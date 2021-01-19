<template>
  <div>
    <div class="recruiting_show_application" v-if="operationUncompleted">
      <div class="recruiting_show_application_text_form_wrap">
        <span class="recruiting_show_application_text_form_ttl">メッセージ</span>
        <textarea id="application_message" placeholder="メッセージを入力してください">
        </textarea>
      </div>
      <div @click="apply" class="recruiting_show_application_btn">
        <span>応募する</span>
      </div>
    </div>
    <div v-else class="recruiting_show_application">
      <div class="recruiting_show_application_success">
        <p>応募しました！募集者の承認をお待ちください！</p>
      </div>
    </div>
    <div v-if="errorMasseges" class="recruiting_show_application_error">
      <p>{{ errorMasseges }}</p>
    </div>
  </div>
</template>
<script>
import axios from 'axios'
var token = document.getElementsByName('csrf-token')[0].getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = token
var recruitintgIdReg = new RegExp('/recruitings/(.*)');
var recruitingIdStr = location.href.match(recruitintgIdReg)

export default {
  data() {
    return {
     recruitingId : Number(recruitingIdStr[1]),
     operationUncompleted : true,
     errorMasseges : null
    };
  },
  created() {
  },
  methods:{
    apply: function(){
        var message = document.getElementById("application_message").value;
        axios({
        method: 'post',
        url: '/applicant_entry_recruitings',
        data: {
          applicant_entry_recruiting: {
            message: message,
            recruiting_id: this.recruitingId
          }
        },
        validateStatus: function(status) {
          return status < 500;
        },
      }).then((response) => {
        if (response.status == 201) {
          this.operationUncompleted = false;
        } else if (response.data.status == 409){
          this.errorMasseges = response.data.error_message.entry_recruiting[0];
        }
      })
      .catch((error) =>  {
        this.errorMasseges = '応募に失敗しました。再読み込みしてください。'
      });
    }
  }
} 
</script>