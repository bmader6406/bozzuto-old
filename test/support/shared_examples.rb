module SharedExamples
  @@shared_examples ||= {}

  def self.included(base)
    base.class_eval do
      def self.shared_example_for(name, &block)
        @@shared_examples[name] = block
      end
    end
  end

  def it_should_behave_like(name, *args)
    instance_exec *args, &@@shared_examples[name]
  end
end
