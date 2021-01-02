module RecruitingsHelper
  
  def load_js_pack_for_user_position(user, recruiting)

    if user.is_owner?(recruiting)
      js_pack_tag = javascript_pack_tag('recruiting/show/operation_for_owner')
    elsif user.is_member?(recruiting)
      js_pack_tag = javascript_pack_tag('recruiting/show/operation_for_member')
    elsif user.is_applicant?(recruiting)
      js_pack_tag = javascript_pack_tag('recruiting/show/operation_for_applicant')
    elsif user.is_free?
      js_pack_tag = javascript_pack_tag('recruiting/show/operation_for_general_user')
    else
      content = content_tag(:div) do
        content_tag(:p, "他の募集に応募しているので、応募はできません。")
      end
      return content
    end


    mounted_div_tag = content_tag(:div, nil, id: "recruiting_operation")
    return mounted_div_tag + js_pack_tag
  end

end
