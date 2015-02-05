module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def roles
    Employee.roles.map{|k,v| [k.humanize, k]}
  end

  def audience_list
    CheckinBallyhoo.audiences.map{|k,v| [k.humanize, v]}
  end

  def repeat_list
    CheckinBallyhoo.repeat_types.map{|k,v| [k.humanize, v]}
  end

  def new_btn(resource, url_for_resource = resource)
    return unless policy(resource).create?
    link_to "+ New #{resource.class.to_s.humanize}", new_polymorphic_path(url_for_resource), class: 'btn btn-success'
  end

  def show_btn(resource, url_for_resource = resource)
    return unless policy(resource).show?
    link_to resource, class: 'btn btn-info' do
      content_tag(:i, nil, class: 'glyphicon glyphicon-eye-open')
    end
  end

  def edit_btn(resource, url_for_resource = resource)
    return unless policy(resource).update?
    link_to edit_polymorphic_path(url_for_resource), class: 'btn btn-warning' do
      content_tag(:i, nil, class: 'glyphicon glyphicon-edit')
     end
  end

  def destroy_btn(resource, url_for_resource = resource)
    return unless policy(resource).destroy?
    link_to url_for_resource, class: 'btn btn-danger', method: :delete, data: {confirm: 'Are you sure?'} do
      content_tag(:i, nil, class: 'glyphicon glyphicon-trash')
    end
  end

  def row_for(resource, options = {}, &blk)
    options[:data] ||= {}
    options[:data][:href] = url_for(resource)
    content_tag(:tr, options, &blk)
  end

  def content_holder(use_table, options={}, &block)
    if use_table
      content_tag(:td, options,&block)
    else
      content_tag(:div, options,&block)
    end
  end

  def row_edit_for(resource, options = {}, &blk)
    options[:data] ||= {}
    options[:data][:href] = url_for([:edit, resource])
    content_tag(:tr, options, &blk)
  end

      
  def select_hours
    [
      "00:00",
      "00:30",
      "01:00",
      "01:30",
      "02:00",
      "02:30",
      "03:00",
      "03:30",
      "04:00",
      "04:30",

      "05:00",
      "05:30",
      "06:00",
      "06:30",
      "07:00",
      "07:30",
      "08:00",
      "08:30",
      "09:00",
      "09:30",
      "10:00",
      "10:30",
      "11:00",
      "11:30",

      "12:00",
      "12:30",
      "13:00",
      "13:30",
      "14:00",
      "14:30",
      "15:00",
      "15:30",
      "16:00",
      "16:30",
      "17:00",
      "17:30",
      "18:00",
      "18:30",
      "19:00",
      "19:30",
      "20:00",
      "20:30",
      "21:00",
      "21:30",
      "22:00",
      "22:30",
      "23:00",
      "23:30"
    ]
  end
end
