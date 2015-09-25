#!/usr/bin/env python2

import subprocess
import numpy


scriptfn  = "exech"
timefn    = "tmp_time"
stepsfn   = "tmp_steps"
num_tests = 25
timedat   = "time.dat"
stepsdat  = "steps.dat"
sizes     = range(10,101,5)

def gen_n_seq(ring_cnts,n):
  f = open( str(n) + ".hs", "w" )
  #f.write( "module Ex2_" + str(n) + " where\n" )
  f.write( "module Main where\n" )
  f.write( "import ABS\n" )

  f.write( "param_actors ="+str(n) + "\n" )
  f.write( "param_rounds ="+str(n) + "\n" )

  f.write(ring_cnts)

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
        r = open("Ring.hs", "r")
        r_cnts = r.read()
	for n in l:
		print "Compiling n == ", n
		gen_n_seq(r_cnts, n)
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
		

if __name__ == "__main__":
	gen_all(sizes)
	get_data_all(sizes)