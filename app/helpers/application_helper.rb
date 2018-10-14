module ApplicationHelper
  def edit_and_destroy_buttons(item)
    edit = link_to('Edit', url_for([:edit, item]), class: "btn btn-primary") if current_user
    del = link_to('Destroy', item, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-danger") if current_user &.admin
    raw("#{edit} #{del}")
  end

  def round(item)
    number_with_precision(item, precision: 1, strip_insignificant_zeros: true)
  end
end
