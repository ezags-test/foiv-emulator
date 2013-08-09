# encoding: utf-8

class GenderInput < SimpleForm::Inputs::CollectionSelectInput
  self.default_options = { :collection    => [["Мужской", true], ["Женский", false]]}
end
