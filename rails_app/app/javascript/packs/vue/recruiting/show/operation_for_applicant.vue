<template>
  <div>
    <p>募集者の承認待ちです。</p>
    <div v-if="operationUncompleted">
      <div class="recruiting_application" @click="declining">
        <span>この募集にたいする応募を取り消す</span>
      </div>
    </div>
    <div v-else>
      <div class="recruiting_application">
        <span>応募を取り消しました！！</span>
      </div>
    </div>
    <div v-if="errorMasseges != null">
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