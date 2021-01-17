module RecruitingsHelper
  
  #ログインしているユーザーのポジションに合わせたvueファイルをう埋め込む
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


  #文字列をバイト単位で切り抜き、最後に省略記号を追加するメソッド
  def resize_string(str, options = {})
    return nil unless str

    options = { 
      size: 20,
      ellipsis: true 
    }.merge(options)

    byte_size = str.bytesize

    #文字列をカットして不正な文字は削除
    last_index = options[:size] - 1
    str = str.byteslice(0..last_index).scrub('')

    #文字列の最後に省略記号を追加
    str = str + '....' if options[:ellipsis] && byte_size > last_index
    
    return str
  end
end
