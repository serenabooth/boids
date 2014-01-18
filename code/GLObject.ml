open GLObjectI
open Event

class gl_object pos : gl_object_i = 
object (self)

val die_event : unit Event.event = Event.new_event ()


method private register_handler : 'a. 'a Event.event -> ('a -> unit) -> unit =
   fun e f -> let id = Event.add_listener e f in
   ignore(Event.add_listener die_event (fun () -> Event.remove_listener e id))

method get_name = "object" 

method get_vel = (0.,0.) 

method get_pos = pos

method do_action = ()

method move_up = ()

method move_down = () 

method move_left = () 

method move_right = ()

method get_color_tuple = (1.0,1.0,1.0)

method private move = ()

method die = 
   World.remove (self :> gl_object_i)

end
