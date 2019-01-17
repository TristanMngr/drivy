require 'json'

# all usefull method
module Utils
  def self.read_from_json(path)
    file = File.read(path)
    JSON.parse(file)
  end

  # def self.create_object(input_json, object)
  #   input_json[object.downcase + 's'].each do |o|
  #     class_name = o.constantize
  #     o.each do |key, value|
  #       class_name.send("#{key}=", value)
  #     end
  #     array_of_class.push(class_name)
  #   end
  #   array_of_class
  # end
end
