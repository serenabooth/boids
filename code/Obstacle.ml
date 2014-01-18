open Event
open GLObject 
open GLObjectI
open Helpers

(* within sensing range if they are within lim_dist of each other. *)
let lim_dist = 0.1


class obstacle pos : gl_object_i = 
object (self)
  inherit gl_object pos as super

method get_color_tuple = (0.2,0.2,0.2)

method get_name = "obstacle" 

method get_pos = pos

method private next_direction = ()

method private move = () 

method do_action = ()

end
