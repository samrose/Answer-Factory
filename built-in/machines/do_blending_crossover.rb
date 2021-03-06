# encoding: UTF-8
class DoBlendingCrossover < Machine
  def create (n)
    @number_to_create = n
  end
  
  def process_answers
    @number_to_create ||= 1
    
    created = []
    
    answers_keyed_by_language.each do |language, group|
      group.shuffle!.each_slice(2) do |a, b|
        b = a unless b
      # progress = [a.progress, b.progress].max + 1
        
        blueprint_a = a.blueprint
        blueprint_b = b.blueprint
        
        @number_to_create.times do
          new_blueprint = blueprint_a.blending_crossover(blueprint_b)
          created << Answer.new(new_blueprint)
        end
      end
    end
    
    return :parents => answers,
           :created => created
  end
end
