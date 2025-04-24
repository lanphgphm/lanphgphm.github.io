---
layout: default 
title: "FP vs. OOP on the Expression problem" 
date: 2025-04-22
tags: "Learning::"
---

This was part of my assignments in Programming Language Paradigms, instructed by Dr. Huynh Viet Linh, Spring 2025. It was so informative and eye-opening for myself that I thought I would repost to archive. 

Read [this writing](https://eli.thegreenplace.net/2016/the-expression-problem-and-its-solutions) and answer (based on the writing above) to these questions

## 1. What is the advantage/disadvantage of object-oriented programming (OOP)?
- Pro: Easier to add new data type (Class)
- Con: Harder to add new data action (Method/Operation)    
![alt text](/images/oop-matrix.png)

**Reason**: In OOP, methods (functions) are not first-class citizens, a function must always be wrapped within a class, even if it means the class has no data fields. This tight coupling means if one method is added to a class A, it starts domino-ing to the classes that inherit froms, extends, interact with that class A. 

## 2. What is the advantage/disadvantage of functional programming (FP)?
- Pro: Easier to add a new data operation (function)
- Con: Harder to add a new data type    
![alt text](/images/fp-matrix.png)

**Reason**: In FP, functions are first-class citizens. Pure FP makes "class" a meaningless construct. There is no class, only functions, which means each and every function is subjected to be used on all types of data. This means all functions must inherently account for all kinds of data. Adding a new type means updating all functions to recognize this new type. 

## 3. How to overcome of the disadvantage of OOP?
**Problem**: Hard to add new method     
**Solution**: 
1. Visitor pattern  
    Each time new type X is added and new way of handling type X is needed, created a XVisitor function and add this XVisitor to the shared Visit(). 

    We still need to change existing code, but it is minimal in the sense that we need to add a new case (switch-case) in the base Visit() method only, and all other visitors can be left untouched.

    But, in this sense, we have made it harder to add new type, because adding new type means we have to go back and update the base Visitor() function. This turns the problem of OOP closer to the problem in FP. 
2. Dynamic cast       
    At runtime, perform checks to see if the pointer to the base class (Expr) can be casted to the derived class (FunctionCallExpr), if can, cast it, and now we have an expression that is capable of evaluating function call expressions.    
    --> Less performant, less safe -- the cast can fail which requires extra logic to handle. 

    > "Adding one new type looks manageable; what about adding 15 new types, gradually over time? Imagine the horrible zoo of ExprVisitor extensions and dynamic checks this would lead to."

3. Dynamic dispatch     
    At runtime, decide which implementation of a method to use after checking the type of the object (Evaluate or EvaluateWithFunctionCall). 

    This highlights how dynamic dispatch is not great for backwards compatibility: In a massive project where we don't control all the instances, the new code (that accomodate for a new type like FunctionCall) might break other instances of Evaluator that we don't control

    > "If we have an instance of an Evaluator, it will no longer work on the whole extended expression tree since it has no understanding of FunctionCall. It's easy to say that all new evaluators should rather be EvaluatorWithFunctionCall, but we don't always control this. What about code that was already written? What about Evaluators created in third-party or library code which we have no control of?" 

    

## 4. How to overcome the disadvantage of FP?
**Problem**: Hard to add new type   
**Solution**: 

1. Multi-method -- parameterized dynamic dispatch    
    OOP dynamic dispatch offers one policy to decide which method implementation to dispatch: checks the type of object at runtime. In this sense, functions' behavior are still controlled by object type --> still second class citizens. 

    Clojure's multi-method is also dynamic dispatch, but it is **parameterized** dynamic dispatch--meaning it allows user to decide which method to dispatch by providing a type argument--effectively giving all the dispatch control to the user. Functions can now be dispatched at user's will, not bounded to any type. 
2. Protocols    
    I don't understand the details enough at this point to say why protocols are wonderful, I'm just echoing the author's point as part of the answer to this question with a Clojure document: 

    > "Avoid the 'expression problem' by allowing independent extension of the set of types, protocols, and implementations of protocols on types, by different parties [...] without wrappers/adapters"

    So it's probably like having a pool of functions, then give language user power to implement their own dynamic dispatch policy by parameterize traditional type-bound dynamic dispatch. 