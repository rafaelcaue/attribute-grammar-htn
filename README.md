# attribute-grammar-htn

## Install
- Make sure ruby is installed (to check type `ruby -v` on a terminal).
- Clone (or download) the repository.
- Open a terminal and navigate to the repostory main folder

## Usage
- To validate type `ruby Hype.rb domain problem plan validate` where domain, problem, and plan are the locations of the domain, problem, and solution plan files.
- To parse HTN models in SHOP2-like syntax type `ruby Hype.rb domain problem validate` where domain, and problem, are the locations of the domain, and problem files.

## Examples
`ruby Hype.rb examples/toy/domain.lisp examples/toy/problem.lisp examples/toy/plan.lisp validate`

`ruby Hype.rb examples/toy/domain.lisp examples/toy/problem.lisp parse`
