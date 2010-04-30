require 'active_support'
require 'answer-factory'

class Setup_Factory < Thor::Group
  include Thor::Actions
  
  # Define arguments and options
  argument :project_name
  class_options :test_framework => :rspec
  
  desc "Creates a new project folder structure for new Nudge types, instructions, search operators and specs"
  
  def self.source_root
    File.dirname(__FILE__)
  end
  
  def answer_factory_gem_path
    AnswerFactory.gem_root
  end
  
  def set_up_project_in_this_folder
    empty_directory("./lib")
    empty_directory("./lib/nudge/instructions")
    empty_directory("./lib/nudge/types")
    empty_directory("./lib/factory/operators")
    empty_directory("./spec")
  end
  
  def create_runner
    template("#{answer_factory_gem_path}/templates/answer_factory_activate_template.erb", "./activate.rb")
  end
  
  def create_spec_helper
    filename = "spec_helper.rb"
    template("#{answer_factory_gem_path}/templates/answer_factory_spec_helper_template.erb",
      "#{New_Nudge_Type.source_root}/spec/#{filename}")
  end  
  
  def say_byebye
    puts "your answer-factory project is located in directory #{Dir.pwd}\n"
  end
end


class New_Nudge_Type < Thor::Group
  include Thor::Actions
  
  # Define arguments and options
  argument :typename_root
  class_option :test_framework, :default => :rspec
  desc "Creates a new NudgeType class definition, shared instructions, and rspec files"
  

  def self.source_root
    File.dirname(__FILE__)
  end
  
  def self.type_name(string)
    string.camelize + "Type"
  end
  
  def nudge_gem_path
    Nudge.gem_root
  end
  
  def answer_factory_gem_path
    AnswerFactory.gem_root
  end
  
  
  def camelcased_type_name
    @camelcased_type_name = New_Nudge_Type.type_name(typename_root)
  end
  
  def create_lib_file
    filename = "#{camelcased_type_name}.rb"
    template("#{nudge_gem_path}/templates/nudge_type_class.erb", "#{New_Nudge_Type.source_root}/lib/nudge/types/#{filename}")
  end
  
  def create_lib_spec
    filename = "#{camelcased_type_name}_spec.rb"
    template("#{nudge_gem_path}/templates/nudge_type_spec.erb", "#{New_Nudge_Type.source_root}/spec/#{filename}")
  end  
  
  def create_instructions
    suite = ["define", "equal_q", "duplicate", "flush", "pop",
      "random", "rotate", "shove", "swap", "yank", "yankdup"]
    
    suite.each do |inst|
      @core = "#{typename_root}_#{inst}"
      filename = "#{@core}.rb"
      @instname = "#{@core.camelize}Instruction"
      @type = typename_root
      @camelized_type = New_Nudge_Type.type_name(typename_root)
      template("#{nudge_gem_path}/templates/nudge_#{inst}_instruction.erb", "#{New_Nudge_Type.source_root}/lib/nudge/instructions/#{filename}")
    end
  end
end