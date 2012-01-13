function new_pos=mob_pos(t,v,old_pos)
n=length(v);
new_pos=[];
new_pos=old_pos + v*t;