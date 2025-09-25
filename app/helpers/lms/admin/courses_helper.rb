module Lms
  module Admin::CoursesHelper
    def link_to_add_fields(name, f, association, controller, **args)
      # Create a new object of the association type
      new_object = f.object.send(association).klass.new
      # Generate the fields for the new object with a unique index
      id = new_object.object_id
      fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
        render(association.to_s.singularize + "_fields", form: builder)
      end
      # Create a link that will add the new fields when clicked
      link_to(name, '#', class: "add_fields btn btn-outline", data: {
        id: id,
        "#{controller}-template-value": fields.gsub("\n", "")
      }.merge(args))
    end
  end
end
