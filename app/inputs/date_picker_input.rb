class DatePickerInput < SimpleForm::Inputs::StringInput
  def input_html_options
    value = object.send(attribute_name)
    super.merge(type: 'text', value: value.nil? ? nil : value.strftime('%Y-%m-%d'))
  end
end
