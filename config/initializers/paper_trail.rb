PaperTrail.serializer = PaperTrail::Serializers::JSON

PaperTrail::Version.class_eval do
  def changed_object
    @changed_object ||= JSON.parse(object, object_class: OpenStruct)
  end
end
