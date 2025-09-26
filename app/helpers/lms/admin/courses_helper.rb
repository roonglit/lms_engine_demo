module Lms
  module Admin::CoursesHelper
    def template_fields_for(f, association)
      # Create a new object of the association type
      new_object = f.object.send(association).klass.new
      # Generate the fields for the new object with a unique index
      id = new_object.object_id
      fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
        render(association.to_s.singularize + "_fields", form: builder)
      end

      h(fields.gsub("\n", ""))
    end
    
    def template_data_for(f, association)
      # Create a new object of the association type
      new_object = f.object.send(association).klass.new
      # Generate the fields for the new object with a unique index
      id = new_object.object_id
      fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
        render(association.to_s.singularize + "_fields", form: builder)
      end

      {
        template: h(fields.gsub("\n", "")),
        id: id
      }
    end
  end
end
