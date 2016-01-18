#!/usr/bin/env python2

import subprocess
import numpy
import os


scriptfn    = "exech"
timefn      = "tmp_time"
stepsfn     = "tmp_steps"
num_tests   = 25
timedat     = "time.dat"
stepsdat    = "steps.dat"
ubdat       = "ub.dat"
sizes       = range(5,101,5)
final_attr  = "the_end"
saco_path   = "costabs"



def gen_n_par( n ):
  f = open( str(n) + ".hs", "w" )
  f.write( "module Main where\n" )
  f.write( "import ABS\n\n")

#  f.write( "(" )
#  for i in xrange(1,n+1):
#    f.write( "x" + str(i) + ":f" + str(i) + ":y" + str(i) + ":" )
#  f.write( "xm:ym:n:" + final_attr + ") = [1..]\n\n" )
  f.write( "(x:f:xm:ym:n:"+final_attr+") = [1..]\n\n" )

  f.write( "main_ :: Method\n" )
  f.write( "main_ [] this wb k = \n" )
  for i in xrange(n-1):
    f.write( "  Assign x New $ \n" )
    f.write( "  Assign f (Async x m []) $ \n" )
  f.write( "  Assign x New $ \n" )
  f.write( "  Assign f (Async x m []) k\n\n" )

  methodm = """
m :: Method
m [] this wb k = 
	Assign xm (Sync ma []) $ 
  Assign xm (Sync ma []) $ 
  Assign xm (Sync ma []) $ 
  Assign xm (Sync ma []) $ 
  Assign xm (Sync ma []) $ 
  Return xm wb k
 	
"""
  f.write( methodm )
  #f.write( "m :: Method\n" )
  #f.write( "m [] this wb k = \ () -> \n  Assign xm (Sync ma []) $ \ () -> \n  Assign ym (Sync ma []) $ \ () -> \n  Return xm wb k\n\n" )

  f.write( "ma :: Method\n" )
  f.write( "ma [] this wb k = \n  Assign n New $ \n") 
  for i in xrange(100):
  	f.write( "  Assign n (Val (Attr n)) $ \n" )
  f.write( "  Return n wb k\n\n" )

  f.write( "main :: IO ()\n" )
  f.write( "main = run' 1000000 main_ (head " + final_attr + ")\n" )

  f.close()


def get_data(n,nt):
	
	# create the script that executes the Haskell program redirecting the 
	# steps information to the file 'stepsfn'
	script = open( scriptfn, "w" )
	script.write( "TIMEFORMAT='%3R'\n" )
	script.write( "time ./" + str(n) + ".hs.o +RTS -A2G -RTS 2> " + stepsfn )
	script.close()
	
	times = list()
	for i in xrange(nt):
		try:
			# executes the script redirecting the time information to 'timefn' 
			subprocess.check_output( "bash " + scriptfn + " 2> " + timefn, shell=True)
		except Exception,e:
			print e
	
		ftime = open( timefn, "r" )
		curr_time = int(float(ftime.readline())*1000)
		times.append(curr_time)
		ftime.close()
				
		fsteps = open( stepsfn, "r" )
		curr_steps = int(fsteps.readline().split('\t')[1])
		fsteps.close()
	
	return (n, curr_steps, int(numpy.median(times)) )

	
def gen_all(l):
	# Generate & compile Haskell programs
	for n in l:
		print "Compiling n == ", n
		gen_n_par(n)
		subprocess.check_output( "ghc -i../../src --make -rtsopts " + str(n) + ".hs -o " + str(n) + ".hs.o", shell=True)
    
	
def get_data_all(l):
	# Get time and steps and write them to the files
	ftimes = open( timedat, "w" )
	fsteps = open( stepsdat, "w" )
	
	for i in l:
		print "Testing n == ", i
		(n,s,t) = get_data(i,num_tests)
		ftimes.write( str(n) + '\t' + str(t) + '\n' )
		fsteps.write( str(n) + '\t' + str(s) + '\n' )
		
	ftimes.close()
	fsteps.close()
	
	
def extract_ub(filename):
  cwd = os.getcwd()
  comando = saco_path + " " + cwd + "/" + filename + " -entries main -cost_model steps"
  salida = subprocess.check_output( comando, shell=True )
  salida = salida.split("\n")
 
  pasos = -1
  for line in salida:
    if line.startswith( "UB for main(this) =" ):
      pasos = line.split("=")[1]
      pasos = int(pasos)
      break
  return pasos
  
	
def get_ub(n):
  fich = open("Sample.abs","r")
  ftext = fich.read()
  fich.close()
  
  # Create 'n'.abs and insert main block
  ftext += "{\n  Main x = new IMain();\n  x ! main(" + str(n) + ");\n}"
  filename = str(n) + ".abs"
  fich = open( filename, "w")
  fich.write(ftext)
  fich.close()
  
  return extract_ub(filename)
  
  
def get_ub_unrolled(n):
  text = "module NHighP" + str(n)
  text += """;
	
interface Main {
	Unit main();
	Main m();
	Main ma();
}

class IMain implements Main{

	Unit main(){
		Main x;
		Fut<Main> f;"""
  for i in xrange(n):
  	text += """
  	x = new IMain();
  	f = x ! m();"""
  text += """
	}
	
	Main m(){
		Main x;
		x = this.ma();
		x = this.ma();
		x = this.ma();
		x = this.ma();
		x = this.ma();
		return x;
	}
	
	Main ma(){
    Main z = new IMain();
    Main y;    
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    y = z;
    z = y;
    return z;
  }
}

{
	Main x = new IMain();
	x ! main();
}
"""
  filename = str(n) + ".abs"
  fich = open( filename, "w")
  fich.write(text)
  fich.close()
	
  return extract_ub(filename)
  
  
def get_ub_all(l):
  fub = open( ubdat, "w" )
  for i in l:
	  ub = get_ub_unrolled(i)
	  fub.write( str(i) + '\t' + str(ub) + '\n' )
  fub.close()
		

if __name__ == "__main__":
	gen_all(sizes)
	get_data_all(sizes)
	get_ub_all(sizes)
