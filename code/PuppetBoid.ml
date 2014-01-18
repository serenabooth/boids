open Event
open Helpers

let start_pos = (1.,1.)
let start_vel = (0., 0.) 
let obj_radius = 0.03
let eat_radius = 0.005
let lim_spd = 0.0025

class puppet start_pos start_vel : GLObjectI.gl_object_i = 
object (self)
  inherit GLObject.gl_object start_pos as super

  val mutable pos = start_pos
  
  val mutable vel = (0.,0.)

  initializer 
    self#register_handler (World.time_event) (fun _ -> self#do_action);

   method move_left =
     self#vel_update (-0.0005,0.)
   method move_right =
     self#vel_update (0.0005,0.)
   method move_down = 
     self#vel_update (0.,-0.0005)
   method move_up =
     self#vel_update (0.,0.0005)

   method private vel_update v =
     vel <- t_add vel v; 
   
   method private next_direction =
     vel <- t_add vel (World.fold (fun (ux,uy) obj -> 
     if obj#get_name = "obstacle" && (dist pos obj#get_pos) < obj_radius then
       t_add (ux, uy) 
           (t_mult (t_sub pos obj#get_pos) (0.06/.dist pos (obj#get_pos)))
     else if obj#get_name = "food" && (dist pos obj#get_pos) < eat_radius then
       (obj#die; (ux,uy)) 
     else (ux,uy)) (0.,0.))
   
   method private pos_update w_mvmt = 
     pos <- wrap(t_add (t_mult vel w_mvmt) pos)     

   method private do_action = self#move

   method private move = 
     self#next_direction;
     if norm vel > lim_spd then
     vel <- t_mult (normalise vel) lim_spd;
     self#pos_update 1.0 
   
   (*other boids will recognize puppetboid as one of their own :evilgrin: *)
   method get_name = "boid"

   method get_pos = pos

   method get_color_tuple = (1.0,1.0,0.0)

   method get_vel = vel
      
end 
