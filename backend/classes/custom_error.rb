# raise error when a variable is undefined
class UndefinedError < StandardError
  def initialize(msg = 'A variable is undefined')
    super(msg)
  end
end

class MissingTypeError < StandardError
  def initialize(msg = 'Type is missing')
    super(msg)
  end
end

# raise error when weird date
class DateError < StandardError
  def initialize(msg = 'Incorrect date')
    super(msg)
  end
end
