<template>
  <div>
    <div class="recruiting_show_application">
      <p v-if="operationUncompleted">募集者の承認待ちです。</p>
      <div v-if="operationUncompleted" class="recruiting_show_application_revocation_btn" @click="declining">
        <span>この募集にたいする応募を取り消す</span>
      </div>
      <div v-else class="recruiting_application_success">
        <span>応募を取り消しました！！</span>
      </div>
      <div v-if="errorMasseges" class="recruiting_application_error">
        <p>{{ errorMasseges }}</p>
      </div>
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
 console.log(this);
  },
  methods: {
    declining: function(){
      axios.delete(
        '/applicant_entry_recruitings',
        { data: { applicant_entry_recruiting: { recruiting_id: this.recruitingId } } }
      ).then((response) => {
        if (response.status == 200) {
          this.operationUncompleted = false;
        } else {
          this.errorMasseges = '取り消しに失敗しました。再読み込みしてください。'
        }
      })
      .catch((error) =>  {
        this.errorMasseges = '取り消しに失敗しました。再読み込みしてください。'
      });
    }
  }
} 
</script>