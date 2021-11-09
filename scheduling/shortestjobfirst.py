# This script implements sjf ( shortest job first  ) cpu scheduling
# shortest job next (SJN), also known as shortest job first (SJF) or shortest process next (SPN),
n = int(input("Enter number of processes : "))

# initialize with zero to avoid errors
burstTime = [0]*n # burst time
processes = [0]*n  # processes
waitTime = [0]*n # waiting time
turnAroundTime = [0]*n # turn around time

# get user input for fill burst time array stick with one time unit (s/ms/us/ns) whole numbers
for i in range(0,n):
       burstTime.insert(i,int(input(f"Enter burst time (ms) for process {i} --> ")))

# array each process with in burstTime ascending order
for i in range(0,n):
      for j in range(i+1,n):
          if burstTime[i]>burstTime[j]:
             temp = burstTime[i]
             burstTime[i] = burstTime[j]
             burstTime[j] = temp

             temp = processes[i]
             processes[i] = processes[j]
             processes[j] = temp

# set turn around time[0] to shortest burts time
turnAroundTime[0] =  burstTime[0]

for i in range(1,n):
      waitTime[i] = waitTime[i-1] + burstTime[i-1]
      turnAroundTime[i] = turnAroundTime[i-1] + burstTime[i]

print("{:<15} {:<15} {:<15} {:<15}".format('PROCESS','BURST TIME' ,'WAITING TIME','TURN AROUND TIME'))

for i in range(0,n):
     print("{:<15} {:<15} {:<15} {:<15}".format(i,burstTime[i],waitTime[i], turnAroundTime[i]))