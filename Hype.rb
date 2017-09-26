#!/usr/bin/env ruby
#-----------------------------------------------
# Hype
#-----------------------------------------------
# Mau Magnaguagno
#-----------------------------------------------
# Planning description converter
#-----------------------------------------------

# Require parsers, compilers and extensions
Dir.glob(File.expand_path('../{parsers,compilers,validators}/*.rb', __FILE__)) {|file| require file}

module Hype
  extend self

  attr_reader :parser

  HELP = "  Usage:
    Hype domain problem [output]\n
  Output:
    print - print parsed data(default)
    rb    - generate Ruby files to Hypertension
    grammar  - generate grammar files
    nil   - avoid print parsed data"

  #-----------------------------------------------
  # Predicates to string
  #-----------------------------------------------

  def predicates_to_s(predicates, prefix)
    predicates.map {|i| "#{prefix}(#{i.join(' ')})"}.join
  end
  
  #-----------------------------------------------
  # States to string
  #-----------------------------------------------
  
  def states_to_s
    output = ''
    @parser.stateO.each {|i| 
    output << "    #{i.name}(#{i.args.join(' ')})\n"
    }
    output
  end
  

  #-----------------------------------------------
  # Goals to string
  #-----------------------------------------------
  
  def goals_to_s
    output = ''
    @parser.tasksO.each {|t| 
    output << "    #{t.name}(#{t.args.join(' ')})\n"
    }
    output
  end

  #-----------------------------------------------
  # Subtasks to string
  #-----------------------------------------------

  def subtasks_to_s(tasks, prefix, ordered = true)
    if tasks.empty?
      "#{prefix}empty"
    else
      operators = @parser.operatorsO
      output = "#{prefix}#{'un' unless ordered}ordered"
      tasks.each {|t| output << prefix << (operators.find{ |op| op.name == t.first} ? 'operator' : 'method  ') << " (#{t.join(' ')})"}
      output
    end
  end

  #-----------------------------------------------
  # Operators to string
  #-----------------------------------------------

  def operators_to_s
    output = ''
    indent = "\n        "
    @parser.operatorsO.each {|op|
      output << "    #{op.name}(#{op.args.join(' ')})\n"
      output << "      Precond positive:#{predicates_to_s(op.positive_precond, indent)}\n" unless op.positive_precond.empty?
      output << "      Precond negative:#{predicates_to_s(op.negative_precond, indent)}\n" unless op.negative_precond.empty?
      output << "      Effect positive:#{predicates_to_s(op.positive_effect, indent)}\n" unless op.positive_effect.empty?
      output << "      Effect negative:#{predicates_to_s(op.negative_effect, indent)}\n" unless op.negative_effect.empty?
      output << "\n"
    }
    output
  end

  #-----------------------------------------------
  # Methods to string
  #-----------------------------------------------

  def methods_to_s
    output = ''
    indent = "\n          "
    @parser.methodsO.each {|met|
      output << "    #{met.task_name}(#{met.variables.join(' ')})\n"
	  output << "      Label: #{met.method_name}\n"
	  output << "        Free variables:\n          #{met.free_variable.join(indent)}\n" unless met.free_variable.empty?
	  output << "        Precond positive:#{predicates_to_s(met.positive_precond, indent)}\n" unless met.positive_precond.empty?
	  output << "        Precond negative:#{predicates_to_s(met.negative_precond, indent)}\n" unless met.negative_precond.empty?
	  output << "        Subtasks:#{subtasks_to_s(met.subtasks, indent)}\n"
      output << "\n"
    }
    output
  end

  #-----------------------------------------------
  # To string
  #-----------------------------------------------

  def to_s
"Domain #{@parser.domain_name}
  Operators:\n#{operators_to_s}
  Methods:\n#{methods_to_s}
  Problem #{@parser.problem_name}
  State:\n#{states_to_s}
  Goal:
  Tasks:
  #{@parser.order}
  #{goals_to_s}
"
#
#  

#    Positive:#{@parser.goal_pos.empty? ? "\n      empty" : predicates_to_s(@parser.goal_pos, "\n      ")}
#    Negative:#{@parser.goal_not.empty? ? "\n      empty" : predicates_to_s(@parser.goal_not, "\n      ")}
  end

  #-----------------------------------------------
  # Parse
  #-----------------------------------------------

  def parse(domain, problem, plan)
    raise 'Incompatible extensions between domain and problem' if File.extname(domain) != File.extname(problem)
    @parser = case File.extname(domain)
    when '.lisp' then HTN_Parser
    else raise "Unknown file extension #{File.extname(domain)}"
    end
    @parser.parse_domain(domain)
    @parser.parse_problem(problem)
    @parser.parse_plan(plan)
  end

  #-----------------------------------------------
  # Compile
  #-----------------------------------------------

  def compile(domain, problem, type)
#    compiler = case type
#    when 'validate' then Grammar_Compiler
#    else raise "Unknown type #{type}"
#    end
#    args = [
#      @parser.domain_name,
#      @parser.problem_name,
#      @parser.operatorsO,
#      @parser.methodsO,
#      @parser.predicatesO,
#      @parser.stateO,
#      @parser.tasksO
#    ]
#    data = compiler.compile_domain(*args)
#    IO.write("#{domain}.#{type}", data) if data
#    data = compiler.compile_problem(*args << File.basename(domain))
#    IO.write("#{problem}.#{type}", data) if data
    args2 = [
      @parser.operatorsO,
      @parser.methodsO,
      @parser.predicatesO,
      @parser.stateOpos,
      @parser.stateOneg,
      @parser.tasksO,
      @parser.planO,
      @parser.tasklistO
    ]
#    t = Time.now.to_f
    Validator.verify(*args2)
#    puts "Total time: #{Time.now.to_f - t}s"
  end
end

#-----------------------------------------------
# Main
#-----------------------------------------------
if $0 == __FILE__
  begin
    if ARGV.size < 2 or ARGV.first == '-h'
      puts Hype::HELP
    else
      domain = ARGV.shift
      problem = ARGV.shift
      plan = ARGV.shift
      type = ARGV.pop
      extensions = ARGV
      if not File.exist?(domain)
        puts "Domain file #{domain} not found"
      elsif not File.exist?(problem)
        puts "Problem file #{problem} not found"
      elsif not File.exist?(problem)
        puts "Plan file #{plan} not found"
      else
        t = Time.now.to_f
        Hype.parse(domain, problem, plan)
        if not type or type == 'print'
          puts Hype.to_s
        elsif type != 'nil'
          Hype.compile(domain, problem, type)
        end
        puts "Total time: #{Time.now.to_f - t}s"
      end
    end
  rescue
    puts $!, $@
  end
end
