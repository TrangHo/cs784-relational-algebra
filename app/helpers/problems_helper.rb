module ProblemsHelper
  def link_to_add_relation(name, f)
    fields = f.fields_for(:attrs, child_index: "new_attribute") do |builder|
      render('form_relation_attribute', builder: builder)
    end
    link_to_function(name, "addFields(this, \"attribute\", \"#{escape_javascript(fields)}\")")
  end
end
