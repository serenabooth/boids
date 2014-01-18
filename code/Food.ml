open Event
open GLObject 
open GLObjectI
open Helpers

(* within sensing range if they are within lim_dist of each other. *)
let lim_dist = 0.1


class food pos : gl_object_i = 
object (self)
  inherit gl_object pos as super

method get_name = "food" 

method get_pos = pos

method get_color_tuple = (0.0,0.4,0.0)

method private next_direction = ()

method private move = () 

method do_action = ()

end
