<template>
  <div>
    <div class="sp_header">
      <div class="sp_header_menu_button" v-on:click="clickHandler">
        <div class="sp_header_menu_button_bar"></div>
        <div class="sp_header_menu_button_bar"></div>
        <div class="sp_header_menu_button_bar"></div>
      </div>
    </div>


    <div class="side_menu_back" v-if="showSideMenu" v-on:click="showSideMenu = !showSideMenu"></div>
    <transition name="sideMenu">
      <aside class="side_menu" id="side_menu" v-if="showSideMenu">
          <ul class="side_menu_list">
          <li>
            <a href="/recruitings/new">
              <img alt="" class="side_menu_list_ico" src="../images/common/recruiting_ico.png">
              <span>募集</span>
            </a>
          </li>
          <li>
            <a href="">
              <img alt="" class="side_menu_list_ico" src="../images/common/message_ico.png">
              <span>メッセージ</span>
            </a>
          </li>
          <li>
            <a rel="nofollow" data-method="delete" href="/users/sign_out">
              <img alt="" class="side_menu_list_ico" src="../images/common/logout_ico.png">
              <span>ログアウト</span>
            </a>
          </li>
        </ul>
      </aside>
    </transition>
  </div>
</template>
<script>
export default {
  data() {
    return {
     showSideMenu : false
    };
  },
  created() {
    if (window.matchMedia('(max-width: 897px)').matches) {
      this.showSideMenu = false;
    } else if (window.matchMedia('(min-width:897px)').matches) {
      this.showSideMenu = true;
    }
  },
  methods:{
    clickHandler: function(){
      this.showSideMenu = !this.showSideMenu
    }
  }
} 
</script>
