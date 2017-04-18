module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Relational Algebra Learning Tool"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def active_nav(request_controller, request_action)
    controller.class.to_s == request_controller && action_name == request_action ? 'active' : ''
  end
end
