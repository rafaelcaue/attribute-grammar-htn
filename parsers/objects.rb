class MethodPl

  attr_reader :name, :method_name, :free_variable, :positive_precond, :negative_precond, :subtasks, :args

  def initialize(name_task, intermediate_rep_method, var)
    @name = name_task
    @args = var
    @method_name = intermediate_rep_method[0]
    @free_variable = intermediate_rep_method[1]
    @positive_precond = Predicate.all_predicates_to_objects(intermediate_rep_method[2])
    @negative_precond = Predicate.all_predicates_to_objects(intermediate_rep_method[3])
    @subtasks = Predicate.all_predicates_to_objects(intermediate_rep_method[4])
  end


  def self.all_methods_to_objects(tasks)
    all_methods = Array.new
    tasks.each{|task|
      name = task[0]
      var = task[1]
       task[2..-1].each{|dec|
         all_methods.push(MethodPl.new(name, dec, var))
         }
    }
    return all_methods
  end
  
  def self.setargs(rule,newargs)
    dec = []
    dec << rule.method_name << rule.free_variable << rule.positive_precond << rule.negative_precond << rule.subtasks
    return MethodPl.new(rule.name, dec, newargs)
  end

end

class Operator

  attr_reader :name, :args, :positive_precond, :negative_precond, :positive_effect, :negative_effect

  def initialize(intermediate_rep_operator)
    @name = intermediate_rep_operator[0]
    @args = intermediate_rep_operator[1]
    @positive_precond = Predicate.all_predicates_to_objects(intermediate_rep_operator[2])
    @negative_precond = Predicate.all_predicates_to_objects(intermediate_rep_operator[3])
    @positive_effect = Predicate.all_predicates_to_objects(intermediate_rep_operator[4])
    @negative_effect = Predicate.all_predicates_to_objects(intermediate_rep_operator[5])
  end

  def self.all_operators_to_objects(all_operators)
    all_ops = Array.new
    all_operators.each{|op|
      all_ops.push(Operator.new(op))
    }
    return all_ops
  end

end

class Predicate

  attr_reader :name, :args

  def initialize(intermediate_rep_pred)
    @name = intermediate_rep_pred[0]
    @args = intermediate_rep_pred[1..-1]
  end
    
  def self.all_predicates_to_objects(all_predicates)
    all_pre = Array.new
    all_predicates.each{|pre|
#	  if pre.first == "not"
#	    pre[1].prepend("not ")
#        all_pre.push(Predicate.new(pre.drop(1)))
#      else all_pre.push(Predicate.new(pre))
#      end
	all_pre.push(Predicate.new(pre))
    }
    return all_pre
  end
  
  def self.all_states_to_objects(all_states)
    all_sta_pos = Array.new
    all_sta_neg = Array.new
    all_states.each{|sta|
	  if sta.first == "not"
        all_sta_neg.push(Predicate.new(sta.drop(1)))
      else all_sta_pos.push(Predicate.new(sta))
      end	
    }
    return all_sta_pos, all_sta_neg
  end
  
  def self.all_tasks_to_objects(all_tasks)
    all_tas = Array.new
    all_tasks[1..-1].each{|tas|
      all_tas.push(Predicate.new(tas))
    }
    return all_tas
  end
  
  def self.set_args(predicates, new_args)
	new_preds = Array.new	
	predicates.each {|pre|
	  new_preds.push(Predicate2.new(pre.name, new_args))
	}
	return new_preds
  end
  
  def self.set_args(predicates, new_args, old_args)
	new_preds = Array.new
	predicates.each {|pre|
	  new_preds.push(Predicate.set_single_pred_args(pre, new_args, old_args))
	}
	return new_preds
  end
  
  def self.set_single_pred_args(predicate, new_args, old_args)
    args = []
	predicate.args.each{|arg|
	  args << new_args.fetch(old_args.index(arg))
	  
	}
	return Predicate2.new(predicate.name, args)
  end
  
  def self.to_arr(predicates)
    new_array = Array.new
    predicates.each{|pre|
      predicate = []
      predicate << pre.name
      predicate << pre.args
      new_array << predicate
    }
    return new_array
  end

end

class Predicate2

  attr_reader :name, :args
  
  def initialize(name, args)
    @name = name
    @args = args
  end
  
  def self.all_predicates_to_objects(all_predicates)
    all_pre = Array.new
    all_predicates.each{|pre|
      all_pre.push(Predicate2.new(pre[0], pre[1]))
    }
    return all_pre
  end
  
  def self.all_predicates_to_objects2(all_predicates)
    all_pre = Array.new
    all_predicates.each{|pre|
      all_pre.push(Predicate2.new(pre.first[0], pre.first[1]))
    }
    return all_pre
  end
  
end
  

class Plan

  attr_reader :name, :args

  def initialize(intermediate_rep_operator)
    @name = intermediate_rep_operator[0]
    @args = intermediate_rep_operator[1..-1]
  end

  def self.all_plans_to_objects(all_plans)
    all_p = Array.new
    all_plans.each{|p|
      all_p.push(Plan.new(p))
    }
    return all_p
  end

end

class Task

  attr_reader :name, :args

  def initialize(tname, targs)
    @name = tname
    @args = targs
  end

end
