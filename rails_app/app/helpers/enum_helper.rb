module EnumHelper
  
  def options_for_select_from_enum(klass, column)
    enum_list = klass.send(column.to_s.pluralize)
    enum_list.map do | name , _value |
      [ name , name ]
    end
  end

end