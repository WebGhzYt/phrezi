class << ActiveRecord::Base
  def strong_attr_accessor(attribute_name, type)
    attr_accessor attribute_name
    columns_hash[attribute_name.to_s] = ActiveRecord::ConnectionAdapters::Column.new(attribute_name.to_s, nil, type.to_s)
  end
end
