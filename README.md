# Self-Driving-Car
Computational Logic Project

  Simulation of a Self Driving Car using Answer Set Programming. 
  sASP system was used.
  
  selfdrivingcar.lp contains the program code.
  testcase.lp contains the test cases for the program.



  Following command will run the program:


  sasp -i selfdrivingcar.lp
  
  
  Following commands can be used to test the program:
  
  ?- car_action(X). (hitting the semicolon will give multiple possible answers for the value of X)
  ?- car_headlights(Y).
  ?- car_wipers(Z).
