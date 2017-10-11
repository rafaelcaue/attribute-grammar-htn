module Validator
  extend self
  
  attr_reader :subplans

  #-----------------------------------------------
  # init
  #-----------------------------------------------

  def init(plan, operators, states_pos, states_neg)
    @subplans = []
    aux_state_pos = Predicate.to_arr(states_pos)
    aux_state_neg = Predicate.to_arr(states_neg)
    op = operators.find{|op| op.name == plan.first.name and op.args.size() == plan.first.args.size()}
    if op != nil
      init_pre_pos = Predicate.set_args(op.positive_precond,plan.first.args,op.args)
      init_pre_pos = Predicate.to_arr(init_pre_pos)
      init_pre_pos = init_pre_pos | aux_state_pos
      @op_pre_pos = Predicate2.all_predicates_to_objects(init_pre_pos)
      init_pre_neg = Predicate.set_args(op.negative_precond,plan.first.args,op.args)
      init_pre_neg = Predicate.to_arr(init_pre_neg)
      init_pre_neg = init_pre_neg | aux_state_neg
      @op_pre_neg = Predicate2.all_predicates_to_objects(init_pre_neg)
      @op_pos_eff = Predicate.set_args(op.positive_effect,plan.first.args,op.args)
      @op_neg_eff = Predicate.set_args(op.negative_effect,plan.first.args,op.args)
      @subplans << subplan = [plan.first,1,1,[[@op_pre_pos, @op_pre_neg, plan.first, @op_pos_eff, @op_neg_eff]]]
    else 
      return false
    end
    plan.drop(1).each_with_index {|p,i|
      op = operators.find{|op| op.name == p.name and op.args.size() == p.args.size()}
      if op != nil
        @op_pre_pos = Predicate.set_args(op.positive_precond,p.args,op.args)
        @op_pre_neg = Predicate.set_args(op.negative_precond,p.args,op.args)
        @op_pos_eff = Predicate.set_args(op.positive_effect,p.args,op.args)
        @op_neg_eff = Predicate.set_args(op.negative_effect,p.args,op.args)
        @subplans << subplan = [p,i+2,i+2,[[@op_pre_pos, @op_pre_neg, p, @op_pos_eff, @op_neg_eff]]]
      else
        return false
      end
    }
    return true
  end
  
  #-----------------------------------------------
  # the end condition of the valid plan
  #-----------------------------------------------

  def planisvalid(plan,tasklist)
	plansize = plan.size()
    @subplans.each {|sub|
	  if sub[1] == 1 and sub[2] == plansize
		puts "This subplan has its first action with index equal to 1 and its last action with index equal to the size of the solution plan."
		valid = 0
		for i in 0..plansize-1
		  if sub[3][i][2] != nil #and test = plan.find{|p| p.name == slot[2].name}
		    #puts test.to_s
		    valid = valid + 1
		  else break
		  end
		end
		if valid == plansize
		  puts "All subplans have an action."
		  return true
		end
#		if sub[0].name == tasklist.first.name and sub[0].args == tasklist.first.args
#		  puts "Subplan matches the initial tasklist.	"
#		  return true
#		end
#	  else
#		puts "This subplan does not satisfy the condition."
	  end
    }
    return false
  end
  
  #-----------------------------------------------
  # merge timelines
  #-----------------------------------------------

  def mergeplans(subplans)
    lb = subplans.min_by {|subplan| subplan[1]}[1]
	ub = subplans.max_by {|subplan| subplan[2]}[2]
	newtimeline = []
	auxnewtimeline = []
	for i in lb..ub
	  auxnewtimeline << [i, [], [], nil, [], []]
	end
	subplans.each {|sub|
	  sub[3].each_with_index {|slot,i|
	    newslot = auxnewtimeline.find{|aux| aux.first == sub[1]+i}.drop(1)
	    ind = auxnewtimeline.find_index{|aux| aux.first == sub[1]+i}
	    auxnewtimeline[ind] = mergeslots(sub[1]+i,slot,newslot)
	  }
	}
	auxnewtimeline.each {|aux|
	  newtimeline << aux.drop(1)
	}
    return newtimeline
  end
  
  #-----------------------------------------------
  # merge slots
  #-----------------------------------------------

  def mergeslots(i,s1,s2)
    if s1[2].nil? or s2[2].nil?
      pre_pos = Array(s1[0]) | Array(s2[0])
      pre_neg = Array(s1[1]) | Array(s2[1])
      post_pos = Array(s1[3]) | Array(s2[3])
      post_neg = Array(s1[4]) | Array(s2[4])
      if s1[2].nil? 
        a = s2[2]
      else 
        a = s1[2]
      end 
      return [i,pre_pos,pre_neg,a,post_pos,post_neg]
    end
  end
  
  #-----------------------------------------------
  # apply before constraints
  #-----------------------------------------------

  def applypre(timeline,pre_pos,pre_neg,subtasks)
#    puts subtasks.to_s
#    id = @subplans.map{|p| subtasks.find{|sub| sub[0].name == p.first.name} and p[1]}.min
    timeline.first[0] = Predicate2.all_predicates_to_objects(Predicate.to_arr(timeline.first[0]) | Predicate.to_arr(pre_pos))
    timeline.first[1] = Predicate2.all_predicates_to_objects(Predicate.to_arr(timeline.first[1]) | Predicate.to_arr(pre_neg))
    return timeline
  end
  
  #-----------------------------------------------
  # apply after constraints
  #-----------------------------------------------

  def applypost(timeline,after)

  end
  
  #-----------------------------------------------
  # apply between constraints
  #-----------------------------------------------

  def applybetween(timeline,between)
  
  end
  
  #-----------------------------------------------
  # propagate
  #-----------------------------------------------

  def propagate(slots)
    for i in 0..slots.size-2 do
      pre_pos_plus = Predicate.to_arr(slots[i+1][0])
      pre_neg_plus = Predicate.to_arr(slots[i+1][1])
      post_pos = Predicate.to_arr(slots[i][3])
      post_neg = Predicate.to_arr(slots[i][4])
      if pre_pos_plus.empty?
        new_pre_pos_plus = slots[i][3]
      elsif not post_pos.empty?
        new_pre_pos_plus = [pre_pos_plus] | [post_pos]
        new_pre_pos_plus = Predicate2.all_predicates_to_objects2(new_pre_pos_plus)
      else 
        new_pre_pos_plus = slots[i+1][0]
      end
      if pre_neg_plus.empty?
        new_pre_neg_plus = slots[i][4]
      elsif not post_neg.empty?
        new_pre_neg_plus = [pre_neg_plus] | [post_neg]
        new_pre_neg_plus = Predicate2.all_predicates_to_objects2(new_pre_neg_plus)
      else 
        new_pre_neg_plus = slots[i+1][1]
      end
      slots[i+1][0] = new_pre_pos_plus
      slots[i+1][1] = new_pre_neg_plus
      
      if slots[i][2] != nil
        pre_pos_plus = Predicate.to_arr(slots[i+1][0])
        pre_neg_plus = Predicate.to_arr(slots[i+1][1])
        pre_pos = Predicate.to_arr(slots[i][0])
        pre_neg = Predicate.to_arr(slots[i][1])
        diff1 = pre_pos - post_neg
        if pre_pos_plus.empty?
          new_pre_pos_plus = Predicate2.all_predicates_to_objects(diff1)
        elsif not diff1.empty?
          new_pre_pos_plus = [pre_pos_plus] | [diff1]
          new_pre_pos_plus = Predicate2.all_predicates_to_objects2(new_pre_pos_plus)
        else
          new_pre_pos_plus = slots[i+1][0]
        end
        diff2 = pre_neg - post_pos
        if pre_neg_plus.empty?
          new_pre_neg_plus = Predicate2.all_predicates_to_objects(diff2)
        elsif not diff2.empty?
          new_pre_neg_plus = [pre_neg_plus] | [diff2]
          new_pre_neg_plus = Predicate2.all_predicates_to_objects2(new_pre_neg_plus)
        else
          new_pre_neg_plus = slots[i+1][1]
        end
        slots[i+1][0] = new_pre_pos_plus
        slots[i+1][1] = new_pre_neg_plus
      end
      
    end
    (slots.size-2).downto(0).each{|i|
      if slots[i][2] != nil
        pre_pos = Predicate.to_arr(slots[i][0])
        pre_neg = Predicate.to_arr(slots[i][1])
        post_pos = Predicate.to_arr(slots[i][3])
        post_neg = Predicate.to_arr(slots[i][4])
        pre_pos_plus = Predicate.to_arr(slots[i+1][0])
        pre_neg_plus = Predicate.to_arr(slots[i+1][1])
        diff1 = pre_pos_plus - post_pos
        if pre_pos.empty?
          new_pre_pos = Predicate2.all_predicates_to_objects(diff1)
        elsif not diff1.empty?
          new_pre_pos = [pre_pos] | [diff1]
          new_pre_pos = Predicate2.all_predicates_to_objects2(new_pre_pos)
        else
          new_pre_pos = slots[i][0]
        end
        diff2 = pre_neg_plus - post_neg
        if pre_neg.empty?
          new_pre_neg = Predicate2.all_predicates_to_objects(diff2)
        elsif not diff2.empty?
          new_pre_neg = [pre_neg] | [diff2]
          new_pre_neg = Predicate2.all_predicates_to_objects2(new_pre_neg)
          
        else
          new_pre_neg = slots[i][1]
        end
        
        slots[i][0] = new_pre_pos
        slots[i][1] = new_pre_neg
      end
    }
    return slots
  end
  
  #-----------------------------------------------
  # verify main
  #-----------------------------------------------

  def verify(operators, methods, predicates, states_pos, states_neg, tasks, plan, tasklist)
#    states.each {|i| 
#		puts "#{i.name}(#{i.args.join(' ')})\n"
#	 }
	puts "\n\n"
	print "Plan to be validated:"
    plan.each {|p|
	  print " #{p.name}(#{p.args.join(' ')})"
    }
    puts "\n"

    if not init(plan, operators, states_pos, states_neg)
      puts "Operators not found, the plan is not valid!"
      puts "\n\n"
      return false
    end

	inters = []
	pre_pos = Predicate.to_arr(@subplans.first[3].first[0])
	pre_neg = Predicate.to_arr(@subplans.first[3].first[1])
	inters = pre_pos & pre_neg
	if not inters.empty?
	  puts "After adding the initial states, the positive preconditions are not disjoint with the negative preconditions of the first action, thus, the plan is not valid."
	  puts "\n\n"
	  return false
	end

	while not planisvalid(plan, tasklist) do
	  puts "Subplans is:"
	  print @subplans
	  subsize = @subplans.size
	  methods.each{|rule|
	    puts "\n\n"
	    puts "Plan is not valid yet, expanding more."
	    puts "\n"
		puts "Rule: #{rule.name}"
		subtasks = []
		subtasksaux = []
		subargs = []
		rule.subtasks.each{|sub|
		  subtasksaux = []
		  subpaux = [@subplans.find_all{|p| p.first.name == sub.name and p.first.args.size() == sub.args.size()}]
		  subpaux.flatten!(1)
		  if not subpaux.empty?
		     subpaux.each{|subp|	
		       newsub = Predicate.set_single_pred_args(sub,subp.first.args, sub.args)
		       subargs << [sub.args,subp.first.args]
			   puts "Subtask #{newsub.name} is an element of subplans."
			
		   	   subtasksaux << subtask = [newsub,subp[1],subp[2],subp[3]]
		     }
	      
#		  if subtasks.empty?
#		    subtasks = subtasksaux
#		  else
		    subtasks << subtasksaux
#		    puts subtasks.to_s
#		    puts subtasks.size
#		    puts "\n\n"
#		    puts subtasksaux.to_s
#		    puts subtasksaux.size
#		    subtasks = subtasks.product(subtasksaux)
#		    puts "\n\n"
#		    puts subtasks.flatten(1).to_s
#		  end

		  else break
		  end
		}
		if rule.subtasks.size == 1
		subtasks.flatten!(1)
			subtasks = subtasks.product()
		end
		puts subtasks.to_s
		puts subtasks.size()
		subtasks.each{|subs|
		  puts subs.size
		  puts subs.to_s
		  if not subs.empty? and subs.size == rule.subtasks.size
		  puts "Subtasks to be merged into the timeline:"
   		  subs.sort_by! {|sub| sub[1]}
		
		  subs.each{|sub|  
		  puts "Name: #{sub[0].name+'('+sub[0].args.join(',')+')'}"
		  puts "Begin index: #{sub[1]}"
		  puts "End index: #{sub[2]}"
		  puts "Timeline:"
		  sub[3].each_with_index{|slot,i|
		    puts "Slot #{i}:"
		    puts "Positive precondition: #{slot[0]}"
			puts "Negative precondition: #{slot[1]}"
			if not slot[2].nil?
			  puts "Action: #{slot[2].name+'('+slot[2].args.join(',')+')'}"
			else
			  puts "Action: nil"
			end
			puts "Positive effect: #{slot[3]}"
			puts "Negative effect: #{slot[4]}"
		  }
		
		  }
		
		timeline = mergeplans(subs)
		puts "\n\n"
		puts "New time line (after merges): #{timeline}"
		
#		applybetween(timeline,rule.between) between is not supported yet
#		applypost(timeline,rule.post_cond) # methods do not have post conditions in shop2 syntax
		newposprecs = []
	    newnegprecs = []
	  	newargs = []
	  	indexes = []
	  	subindex = []
	  	#puts subargs.to_s
	  	rule.positive_precond.each{|rpos|
	  	  rpos.args.each{|rarg| indexes <<  subargs.index{|sarg| aux = sarg[0].index{|sargvar| sargvar == rarg} and aux != nil and subindex << aux}}
	  	  indexes.each_with_index{|ind,i|
	  	    if ind != nil
	  	      newargs << subargs.fetch(ind)[1].fetch(subindex[i])
	  	    end
	  	  }
	  	  newposprecs << Predicate.set_single_pred_args(rpos,newargs,rpos.args)
	  	  indexes = []
	  	  subindex = []
	  	  newargs = []
	  	}
	  	rule.negative_precond.each{|rneg|
	  	  rneg.args.each{|rarg| indexes <<  subargs.index{|sarg| aux = sarg[0].index{|sargvar| sargvar == rarg} and aux != nil and subindex << aux}}
	  	  indexes.each_with_index{|ind,i|
	  	    if ind != nil
	  	      newargs << subargs.fetch(ind)[1].fetch(subindex[i])
	  	    end
	  	  }
	  	  newnegprecs << Predicate.set_single_pred_args(rneg,newargs,rneg.args)
	  	  indexes = []
	  	  subindex = []
	  	  newargs = []
	  	}

		puts newposprecs.to_s
		puts newnegprecs.to_s
		puts subs.to_s
		timeline = applypre(timeline,newposprecs,newnegprecs,subs)
		puts "\n\n"
		puts "New time line (after applying before contraints): #{timeline}"
		
		puts "\n\n"
		
		puts "Slots to be propagated:"
		timeline.each{|slot|
		  puts slot.to_s
		}
		
		puts "\n\n"
		
		timeline = propagate(timeline)
		puts "Propagated timeline: #{timeline}"
		
		puts "\n\n"
		
		inters_pre = []
		inters_post = []
		timeline.each{|slot|
		  pre_pos = Predicate.to_arr(slot[0])
		  pre_neg = Predicate.to_arr(slot[1])
		  post_pos = Predicate.to_arr(slot[3])
		  post_neg = Predicate.to_arr(slot[4])
		  inters_pre = pre_pos & pre_neg
		  inters_post = post_pos & post_neg
		  if not inters_pre.empty? or not inters_post.empty?
		   puts "The timeline from applying this rule is not valid, aborting it."
		   break
		  end
		}
		if inters_pre.empty? and inters_post.empty?
		  b = subs.min_by {|subtask| subtask[1]}[1]
		  e = subs.max_by {|subtask| subtask[2]}[2]
		  puts "Minimum begin index: #{b}"
		  puts "Maximum end index: #{e}"
		
	  	  puts "\n\n"
	  	  

	  	  #newargs = []
	  	  #timeline.each{|slot|
	  	  #  if slot[2] !=nil
	  	  #    newargs << slot[2].args
	  	  #  end
	  	  #}
	  	  
	  	  rule.args.each{|rarg| indexes <<  subargs.index{|sarg| aux = sarg[0].index{|sargvar| sargvar == rarg} and aux != nil and subindex << aux}}
	  	  indexes.each_with_index{|ind,i|
	  	   if ind != nil
  	  	     newargs << subargs.fetch(ind)[1].fetch(subindex[i])
	  	   end
	  	  }
		  #puts rule.args.to_s
		  #puts newargs.to_s

	  	  rulenew = Task.new(rule.name,newargs)
	  	  subplan = [rulenew,b,e,timeline]
	  	  duplicate = @subplans.find{|sub| sub[0].name == subplan[0].name and sub[0].args == subplan[0].args and sub[1] == subplan[1] and sub[2] == subplan[2]}
	  	  
	  	  if duplicate == nil
		  @subplans << subplan
		  puts "The following subplan was added to the subplans set: #{subplan}"
		  if planisvalid(plan,tasklist)
		    puts "Plan is valid!"
		    puts "\n\n"
		    return true
  	      end
		  end
		  
		end
		else puts "Not all subtasks of this rule are elements of subplans."
		end
		}
		puts "\n\n"
	  }
	
	if @subplans.length == subsize
	  puts "Plan is not valid!"
	  puts "\n\n"
	  return false
  	end	
     
	end
	
	puts puts "The plan is valid!"
	puts "\n\n"
	return true
	
  end
  
  
end
