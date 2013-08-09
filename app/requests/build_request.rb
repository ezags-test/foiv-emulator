class BuildRequest < Mustache

  def initialize(name)
    self.template = read_template(name)
  end

  def read_template(statement_type)
    template = statement_type + '.xml'
    File.read File.expand_path File.join('../../views/ezags', template), __FILE__
  end

end
