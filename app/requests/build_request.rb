class BuildRequest < Mustache

  def initialize(name, params = {})
    params.each do |key, value|
      context[key.to_sym] = value
    end
    self.template = read_template(name)
  end

  def read_template(statement_type)
    template = statement_type + '.xml'
    File.read File.expand_path File.join('../../views/ezags', template), __FILE__
  end

  %w(register_period child_birth_period father_birth_period mother_birth_period).each do |name|
    [name + '_from', name + '_to'].each do |method|
      define_method(method) do
        Date.new(context[(method + '_year').to_sym].to_i,
                 context[(method + '_month').to_sym].to_i,
                 context[(method + '_day').to_sym].to_i)
      end
    end

  end

  def child_gender_string
    case context[:child_gender]
    when 'false'
      'female'
    when 'true'
      'male'
    else
      'undefined'
    end
  end


end
