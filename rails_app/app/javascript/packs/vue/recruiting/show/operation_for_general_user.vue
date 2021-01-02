<template>
  <div>
    <div class="recruiting_application" @click="apply" v-if="operationUncompleted">
      <span>この募集に応募する</span>
    </div>
    <div v-else>
      <span>応募しました！募集者の承認をお待ちください！</span>
    </div>
    <div v-if="errorMasseges">
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
        axios.post('/applicant_entry_recruitings',{
        applicant_entry_recruiting: {
          recruiting_id: this.recruitingId
        }
      }).then((response) => {
        if (response.status == 201) {
          this.operationUncompleted = false;
        } else {
          this.errorMasseges = '応募に失敗しました。再読み込みしてください。'
        }
      })
      .catch((error) =>  {
        this.errorMasseges = '応募に失敗しました。再読み込みしてください。'
      });
    }
  }
} 
</script>