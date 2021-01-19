<template>
  <div>
    <section class="recruiting_show_users">
      <h3 class="recruiting_show_users_ttl">参加者</h3>

      <ul 
        v-if="this.participants == null || this.participants.length > 0"
        class="recruiting_show_users_list"
      >
        <li v-for="user in participants" :key="user.user_id">
          <div class="recruiting_show_users_list_left">
            <a v-bind:href="'/users/' + user.user_id">
              <img alt="" src="../../../images/common/user_ico.png">
              <span class="recruiting_show_users_list_left_name">{{ user.name }}</span>
            </a>
          </div>
          <div class="recruiting_show_users_list_right">
            <div class="recruiting_show_users_list_btn_wrap">
              <span
                @click="delete_entry" 
                v-bind:data-id= user.user_id
                data-reason = 'kick'
                class = "recruiting_show_users_list_kick_btn"
              >
                キックする
              </span>
            </div>
          </div>
        </li>
      </ul>
      <div v-else>
        <p>参加者はいません。</p>
      </div>
    </section>
    <section class="recruiting_show_users">
      <h3 class="recruiting_show_users_ttl">応募者</h3>
      <ul 
        v-if="this.applicants == null || this.applicants.length > 0"
        class="recruiting_show_users_list"
      >
        <li v-for="user in applicants" :key="user.user_id">
          <div class="recruiting_show_users_list_left">
            <a v-bind:href="'/users/' + user.user_id">
              <img alt="" src="../../../images/common/user_ico.png">
              <span class="recruiting_show_users_list_left_name">{{ user.name }}</span>
            </a>
          </div>
          <div class="recruiting_show_users_list_right">
            <div class="recruiting_show_users_list_btn_wrap">
              <span
                @click="approve" 
                v-bind:data-id= user.user_id
                class = "recruiting_show_users_list_approve_btn"
              >
                参加を承認する
              </span>
            </div>
            <div class="recruiting_show_users_list_btn_wrap">
              <span
                @click="delete_entry" 
                v-bind:data-id= user.user_id
                data-reason = 'refusal'
                class = "recruiting_show_users_list_kick_btn"
              >
                参加を拒否する
              </span>
            </div>
          </div>
          <div v-if="errorMasseges" class="recruiting_show_users_list_error">
            <p>{{ errorMasseges }}</p>
          </div>
        </li>
      </ul>
      <div v-else>
        <p>応募者はいません。</p>
      </div>
    </section>
  </div>
</template>
<script>
import axios from 'axios'
import qs from 'qs';

var token = document.getElementsByName('csrf-token')[0].getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = token
var recruitintgIdReg = new RegExp('/recruitings/(.*)');
var recruitingIdStr = location.href.match(recruitintgIdReg)

var params = {
  applicant_entry_recruiting: {
    recruiting_id: Number(recruitingIdStr[1])
  }
};
var paramsSerializer = (params) => qs.stringify(params);

export default {
  data() {
    return {
      recruitingId : Number(recruitingIdStr[1]),
     operationUncompleted : true,
     errorMasseges : null,
     applicants : null,
     participants : null
    };
  },

  created() {
    axios.get('/applicant_entry_recruitings',{
      params, paramsSerializer
    }).then((response) => {
      if (response.status == 200) {
        this.applicants = response.data['applicants'];
        this.participants = response.data['participants'];
      } else {
        this.errorMasseges = 'ユーザーデータの読み込みに失敗しました。再読み込みしてください。'
      }
    })
    .catch((error) =>  {
      this.errorMasseges = 'ユーザーデータの読み込みに失敗しました。再読み込みしてください。'
    });
  },

  methods: {
    approve: function(e){
      var id = e.currentTarget.getAttribute('data-id');
      axios({
        method: 'put',
        url: '/applicant_entry_recruitings',
        data: {
          applicant_entry_recruiting: {
            recruiting_id: this.recruitingId,
            applicant_id: id,
            status: 'approved'
          }
        },
        validateStatus: function(status) {
          return status < 500;
        },
      }).then((response) => {
        if (response.data.status == 201) {
          location.reload();
        } else if (response.data.status == 409){
          this.errorMasseges = response.data.error_message.entry_recruiting[0];
        } else {
          this.errorMasseges = '承認に失敗しました。再読み込みしてください。'
        }
      })
      .catch((error) =>  {
          this.errorMasseges = '承認に失敗しました。再読み込みしてください。'
      });
    },

    delete_entry: function(e){
      var id = e.currentTarget.getAttribute('data-id')
      var delete_reason = e.currentTarget.getAttribute('data-reason')
      axios({
        method: 'delete',
        url: '/applicant_entry_recruitings',
        data: {
          applicant_entry_recruiting: {
            recruiting_id: this.recruitingId,
            applicant_id: id,
            delete_reason: delete_reason
          }
        }
      }).then((response) => {
        if (response.data.status == 200) {
          location.reload();
        } else {
          this.errorMasseges = 'キックに失敗しました。再読み込みしてください。'
        }
      })
      .catch((error) =>  {
        this.errorMasseges = 'キックに失敗しました。再読み込みしてください。'
      });
    },
  }
} 
</script>