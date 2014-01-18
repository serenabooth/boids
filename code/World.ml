open Event
open GLObjectI
open List

let rand : float -> float = Random.self_init () ; Random.float

let rand_negify f =
  match Random.self_init (); Random.bool () with
  | true -> f *. (-1.0)
  | false -> f

let rand_vel () = (rand_negify (rand 0.001), rand_negify (rand 0.001))
let rand_pos () = (rand 1.77, rand 1.0)
let rand_pos_near (px,py) = 
  Helpers.t_add (rand_negify (rand 0.05), rand_negify (rand 0.05)) (px,py)  

(***********************)
(***** World State *****)
(***********************)

(** world is a list ref*)
let world : gl_object_i list ref =
  ref []

(** mv_world is a user-controllable object **)
let mv_world : gl_object_i option ref =
  ref None

(****************************)
(***** World Operations *****)
(****************************)

(** Clear out all objects from the world. *)
let reset () : unit =
  world := [];
  mv_world := None

let reset_mv () : unit =
  mv_world := None

(** Add an object to the list of world objects. *)
let add (w:gl_object_i) : unit =
  world := (w::!world)

let add_mv (w:gl_object_i) : unit =
  mv_world := Some w

(** Remove an object from the list of world objects. Does
    nothing if the object was not in the list. *)

let has_mv () : bool = match !mv_world with
  | None -> false
  | _ -> true
  
let remove (w:gl_object_i) : unit =
  world := List.filter (fun w' -> w' <> w) !world

let remove_mv () = match !mv_world with
  | None -> ()
  | Some _ -> mv_world := None

(** Same as remove but fails if the object is not in the list. *)
let remove_must_exist (w:gl_object_i) : unit =
  assert (mem w !world) ;
  remove w

(** Fold over all objects in the world. *)
let fold (f: 'a -> gl_object_i -> 'a) (i:'a) : 'a =
  match !mv_world with
  | None -> fold_left f i !world
  | Some w -> fold_left f i (w::!world)

(** Iter over all objects in the world. :) *)
let iter_all (f:gl_object_i -> unit) : unit =
  match !mv_world with
  | None -> iter f !world
  | Some w -> iter f (w::!world)

let obj_ct name= 
  fold (fun ct obj -> if obj#get_name = name then ct+1 else ct) 0

(****************************)
(***** Spawning Objects *****)
(****************************)
let rec spawn (n: int) (w: gl_object_i) : unit = 
  if n <= 0 then () else
  (ignore (add w ) ; 
  spawn (n-1) w)

(* removes the first instance of a specified object in world *)
let rec take_wrap (name:string) (lst:gl_object_i list) : unit =
  if obj_ct name > 0 then
  match lst with
  |(hd::tl) when hd#get_name = name -> hd#die
  |(hd::tl) -> take_wrap name tl 
  | _ -> ()

let take (name:string) =
  take_wrap name !world

let remove (w:gl_object_i) = 
  world := filter (fun x -> x <> w) !world

(******************)
(***** EVENTS *****)
(******************)

(** Fires with time. *)
let time_event : unit Event.event = Event.new_event ()
