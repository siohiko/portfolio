module RecruitingsHelper
  
  #return contents of operation against recruitment for user position
  def operation_display_for_position(position)
    packs_for_user = {
      owner:     { pack: 'recruiting/show/operation_for_owner' },
      member:    { pack: 'recruiting/show/operation_for_member' },
      applicant: { pack: 'recruiting/show/operation_for_applicant' },
      free:      { pack: 'recruiting/show/operation_for_general_user' }
    }

    if position === :applicant_for_another_recruiting
      content = content_tag(:div) do
        content_tag(:p, "他の募集に応募しているので、応募はできません。")
      end
    elsif position
      #div to mount vue
      mounted_div_tag = content_tag(:div, nil, id: "recruiting_operation")
      #load js
      js_pack_tag = javascript_pack_tag(packs_for_user[position][:pack])
      content = mounted_div_tag + js_pack_tag
    else
      content = nil
    end

    return content
  end


  def display_recruiting_status
    if @recruiting.status == "open"
      content_tag(:span, "募集中", class: "open")
    elsif @recruiting.status == "close"
      content_tag(:span, "募集終了", class: "close")
    elsif @recruiting.status == "filled"
      content_tag(:span, "満員", class: "filled")
    end
  end

end
