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
            <a href="/recruitings/new" class="side_menu_list_link">
              <img alt="" class="side_menu_list_link_ico" src="../images/common/recruiting_ico.png">
              <span class="side_menu_list_link_text">募集</span>
            </a>
          </li>
          <li>
            <a href="" class="side_menu_list_link">
              <img alt="" class="side_menu_list_link_ico" src="../images/common/message_ico.png">
              <span class="side_menu_list_link_text">メッセージ</span>
            </a>
          </li>
          <li>
            <div class="side_menu_list_child_ttl" v-bind:class="{ active: showConfigMenu }" v-on:click="configMenuHandler">
              <img alt="" class="side_menu_list_child_ttl_ico" src="../images/common/gear_ico.png">
              <span class="side_menu_list_child_ttl_text">設定</span>
            </div>
            <ul class="side_menu_list_child" v-if="showConfigMenu">
              <li>
                <a href="/users/password/edit" class="side_menu_list_child_link">
                  <span class="side_menu_list_child_link_text">パスワード変更</span>
                </a>
              </li>
              <li>
                <a rel="nofollow" data-method="delete" href="/users/sign_out"  class="side_menu_list_child_link">
                  <span class="side_menu_list_child_link_text">ログアウト</span>
                </a>
              </li>
              <li>
                <a href="/users/delete_form/new" class="side_menu_list_child_link">
                  <span class="side_menu_list_child_link_text">退会する</span>
                </a>
              </li>
            </ul>
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
     showSideMenu : false,
     showConfigMenu : false
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
    },
    configMenuHandler: function(){
      this.showConfigMenu = !this.showConfigMenu
    }
    
  }
} 
</script>
