open Event
open GLObject 
open GLObjectI
open Helpers

(* global limit on boid speed *)
let lim_spd = 0.002

(* boids are within sensing range if they are within lim_dist of each other. *)
let lim_dist = 0.1

(* boids will repel each other strongly 
if they are within repel_dist of one another. *)
let repel_dist = 0.02

(* boids are strongly repelled by obstacles *) 
let obj_radius = 0.03

(* boid notice food *) 
let food_radius = 0.1
(* boid eat food *)
let eat_radius = 0.005

(* boid run away from predator *) 
let predator_radius = 0.1 

let predator_eat_radius = 0.005

class boid start_pos start_vel : gl_object_i = 
object (self)
  inherit gl_object start_pos as super

val mutable pos = start_pos
val mutable vel = start_vel
val mutable boid_ct_cm = 0
val mutable boid_ct_vl = 0
val mutable food_seen = false

initializer 
  self#register_handler (World.time_event) (fun _ -> self#do_action)

(*todo: condense into one World.fold call.*)

method private center_of_mass_rule =
  let (px,py) = World.fold (fun (ux,uy) obj -> 
    if obj#get_name = "boid" && (dist pos obj#get_pos) < lim_dist then
      (boid_ct_cm <- boid_ct_cm +1; 
      t_add (t_sub obj#get_pos pos) (ux,uy)) else (ux,uy)) (0.,0.) in  
  let tmp_boid_ct = boid_ct_cm in
  boid_ct_cm <- 0;
  match tmp_boid_ct with
  | 0 -> (0.,0.)
  | _ -> ((px/. float_of_int tmp_boid_ct ),(py/. float_of_int tmp_boid_ct ))

method private flock_velocity_rule =
  let (px,py) = World.fold (fun (ux,uy) obj -> 
    if obj#get_name = "boid" && (dist pos obj#get_pos) < lim_dist then
      (boid_ct_vl <- boid_ct_vl +1; 
      t_add obj#get_vel (ux,uy)) else (ux,uy)) (0.,0.) in 
  let tmp_boid_ct = boid_ct_vl in
  boid_ct_vl <- 0;
  match tmp_boid_ct with
  | 0 -> (0.,0.)
  | _ -> ((px/.float_of_int tmp_boid_ct  ),(py/. float_of_int tmp_boid_ct))

method private repel_rule = 
  let my_vec = World.fold (fun (ux,uy) obj ->
    if obj#get_name = "predator" then 
      let d2predator = dist pos obj#get_pos in (*fear algorithm*)
      (match (d2predator < predator_radius, 
          d2predator < predator_eat_radius) with 
      | (_,true) -> self#die; (ux, uy) 
      | (true,_) -> 
          t_add (ux,uy) (t_mult (t_sub pos obj#get_pos) (0.03 /. d2predator))
      | _ -> (ux,uy)) 
    else if obj#get_name = "boid" && (dist pos obj#get_pos) < repel_dist then
      t_add (ux, uy)(t_sub pos obj#get_pos) 
    else if obj#get_name = "obstacle" && (dist pos obj#get_pos) < obj_radius
    then 
      t_add (ux, uy) 
          (t_mult (t_sub pos obj#get_pos) (0.06/.dist pos (obj#get_pos)))
    else if obj#get_name = "food" then
      let d2food = dist pos obj#get_pos in 
      (match (d2food < food_radius, d2food < eat_radius, food_seen) with
        | (_,true,_) -> obj#die; (ux, uy)
        | (true,false,false) ->  food_seen <- true; t_add (ux, uy) 
            (t_mult_squared (t_sub obj#get_pos pos) (0.03/.d2food))
        | _ -> (ux, uy))
    else (ux,uy)) (0.,0.) in
  food_seen <- false; my_vec
 
method get_name = "boid" 

method get_vel = vel

method get_pos = pos

method private pos_update w_mvmt =
  pos <- wrap(t_add (t_mult vel w_mvmt) pos)

method private move =
  self#pos_update 1.0

method private vel_update w_mass w_vel w_repel = 
  vel <- t_add vel (t_mult self#center_of_mass_rule w_mass);
  vel <- t_add vel (t_mult self#flock_velocity_rule w_vel);
  vel <- t_add vel (t_mult self#repel_rule w_repel);
  if norm vel > lim_spd then 
  vel <- t_mult (normalise vel) lim_spd

(* weights arbitrarily selected based *)
method private next_direction = 
  self#vel_update 0.001 0.003 0.005

method do_action = 
  self#next_direction; self#move


end
