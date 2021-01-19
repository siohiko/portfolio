<template>
  <div>
    <div class="recruiting_show_application">
      <p v-if="operationUncompleted">あなたはこの募集のメンバーです</p>
      <div 
        v-if="operationUncompleted"
        class="recruiting_show_application_revocation_btn"
        @click="declining"
        data-reason = 'decline'
      >
          <span>参加を辞退する</span>
      </div>
      <div v-else class="recruiting_application_success">
          <span>辞退しました！</span>
      </div>
      <div v-if="errorMasseges != null" class="recruiting_application_error">
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
    declining: function(e){
      var delete_reason = e.currentTarget.getAttribute('data-reason')

      axios({
        method: 'delete',
        url: '/applicant_entry_recruitings',
        data: {
          applicant_entry_recruiting: {
            recruiting_id: this.recruitingId,
            delete_reason: delete_reason
          }
        }
      }).then((response) => {
        if (response.status == 200) {
          this.operationUncompleted = false;
        } else {
          this.errorMasseges = '辞退に失敗しました。再読み込みしてください。'
        }
      })
      .catch((error) =>  {
        this.errorMasseges = '辞退に失敗しました。再読み込みしてください。'
      });
    }
  }
} 
</script>