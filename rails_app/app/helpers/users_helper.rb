module UsersHelper
  
  def edit_icon_link(link)
    return unless user_signed_in?
    
    if current_user.user_id == params[:user_id]
      link_to link, class: 'edit_user_icon_link'  do
        img = image_tag('users/show/edit_ico.png', alt: '')
        img + '編集する'
      end
    end
  end

  def my_page?
    return false unless user_signed_in?
    current_user.user_id == params[:user_id] ? true : false
  end
end
