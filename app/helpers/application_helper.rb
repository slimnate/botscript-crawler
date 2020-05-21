module ApplicationHelper
  def nav_link(link_text, page)
    class_name = link_text == page ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, page
    end
  end
end
