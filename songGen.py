# A simple python script to output note data as array indices

notes = ""
num = 0
while True:
  com = raw_input("(reps, note)>")
  if com == "done": break
  reps, note = com.split(",")
  for i in range(int(reps)):
    notes = notes + "n["+str(num)+"] = 4'd"+note+";\n"
    num += 1

print(notes)