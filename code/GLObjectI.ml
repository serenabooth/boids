(* object_i abstract class *) 
open Event 

class type gl_object_i = 
object

(* identify world creatures by name *) 
method get_name : string

(* repositions boid *)
method do_action : unit

(* used in boids computation *) 
method get_vel : float * float 

(* retrieve object positions *) 
method get_pos : float * float 

method move_up : unit
 
method move_down : unit

method move_left : unit 
 
method move_right : unit

method get_color_tuple : float * float * float 

(* defines how a boid moves given some next_direction *) 
method private move : unit

method private register_handler : 'a. 'a Event.event -> ('a -> unit) -> unit

(* Kill the object. *)
method die : unit

end 
