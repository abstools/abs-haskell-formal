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
src_path    = "/home/kike/svn/abs2haskell-pure/src/"
final_attr  = "the_end"
saco_path   = "/home/kike/Systems/costa/costabs/src/interfaces/shell/costabs"


def gen_cuad(n):
  f = open( str(n) + ".hs", "w" )
  f.write( "module Main where\n" )
  f.write( "import ABS\n\n")

#  f.write( "(a:" )
#  for i in range(1,n+1): 
#    f.write( "f" + str(i) + ":" ) 
#  f.write( "z:thisf:" + final_attr + ") = [1..]\n\n" )
  f.write( "(a:f:x:z:"+final_attr+") = [1..]\n\n" )

  f.write( "main_ :: Method\n" )
  f.write( "main_ [] this wb k = " )
  for i in xrange( n-1 ):
     f.write(  "Assign a (Sync g []) $ " )
  f.write(  "Assign a (Sync g []) k\n\n" )
 

  f.write( "g :: Method\n" )
  f.write( "g [] this wb k = Assign x New $ " )
  for i in xrange(1,n):
    f.write( "Assign f (Async x m []) $ " )
  f.write( "Assign f (Async x m []) $ Return x wb k\n\n" )

  f.write( "m :: Method\n" )
  f.write( "m [] this wb k = \n  Assign z New $ \n" )
  for i in xrange(100):
    f.write( "  Skip $ \n" )
  f.write( "  Return z wb k\n\n" )

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
		# executes the script redirecting the time information to 'timefn' 
		subprocess.check_output( "bash " + scriptfn + " 2> " + timefn, shell=True)
	
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
		gen_cuad(n)
		subprocess.check_output( "ghc -i" + src_path + " --make -rtsopts " + str(n) + ".hs -o " + str(n) + ".hs.o", shell=True)
    
	
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
  ftext += "{\n  Main x = new IMain();\n  x ! main(" + str(n) + ", " + str(n) + ");\n}"
  filename = str(n) + ".abs"
  fich = open( filename, "w")
  fich.write(ftext)
  fich.close()
  
  return extract_ub(filename)
  
  
def get_ub_unrolled(n):
	text = "module NSquared" + str(n)
	text += """;
	
interface Main {
	Unit main();
	Main g();
	Main m();
}
	
class IMain implements Main{
	Unit main(){\n"""
	for i in xrange(n):
		text += "		this.g();\n"
	text += """
	}
	
	Main g(){
  	Main x = new IMain();
		Fut<Main> f;\n"""
	for i in xrange(n):
		text += """
		f = x ! m();"""
	text += """
		return x;
	}
	
	Main m(){
		Main z = new IMain();
		Int i = 0;
"""
	for i in xrange(100):
		text += "		i = 20; //skip\n"
	text += """
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
