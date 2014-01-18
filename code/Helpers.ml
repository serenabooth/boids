(** A package of generic and useful helper functions. *)
(** Adapted from pset 7 *)

(************************)
(***** List Helpers *****)
(************************)

(** The list containing n replicas of e *)
let rec replicate (n:int) (e:'a) : 'a list =
  if n = 0 then [] else e::replicate (n-1) e


(* Makes vectors fit within (0,0) -> (1.77,1) frame *)
let wrap (t1x,t1y) =  
  let (x,y) = (mod_float t1x 1.77, mod_float t1y 1.) in 
  match (x<0.,y<0.) with 
  | (true, true) -> (x +. 1.77, y +. 1.)
  | (true, false) -> (x +. 1.77, y)
  | (false, true) -> (x, y +. 1.)
  | (false, false) -> (x, y)
 
(* Adds vectors, defined as float tuples *)
let t_add (t1x,t1y) (t2x,t2y) =
  ((t1x +. t2x), (t1y +. t2y))

(* Subtracts vectors, defined as float tuples *) 
let t_sub (t1x,t1y) (t2x,t2y) =
  ((t1x -. t2x), (t1y -. t2y))

(* Multipies vectors by a scalar *) 
let t_mult (t1x,t1y) r = 
  ((t1x *. r), (t1y *. r))

(* Multiplies vectors by the square of a scalar *)
let t_mult_squared (t1x,t1y) r = 
  (((t1x *. r)*.r),((t1y *. r) *.r))

(* Finds the norm of a vector *) 
let norm (t1x,t1y) = 
  sqrt (t1x ** 2. +. t1y ** 2.)

(* Returns a normalised vector *) 
let normalise (t1x,t1y) = 
  let get_norm = norm (t1x,t1y) in
  (t1x /. get_norm, t1y /. get_norm)

let pi = 4.0 *. atan 1.0

(* Get direction faced in degrees *) 
let heading (t1x,t1y) = 
  let angle = atan2 t1y t1x in 
  (angle *. (180. /. pi)) +. 270.

(* Finds the length of the difference between two vectors *)
let dist t1 t2 = 
  norm (t_sub t1 t2)

let t_invert (t1x, t1y) = 
  match (t1x, t1y) with 
  | (0., 0.) -> (t1x,t1y) 
  | (0., _) -> (t1x, 1. /. t1y)
  | (_, 0.) -> (1. /. t1x, t1y) 
  | _ -> (1. /. t1x, 1. /. t1y)

(** The cross produce of lists xs and ys.
    result = \[ (x,y) | x in xs and y in ys \] *)
let rec cross (xs:'a list) (ys:'b list) : ('a*'b) list =
  match xs with
  | [] -> []
  | hd::tl -> List.map (fun y -> (hd,y)) ys @ cross tl ys

(** The monotonically increasing list containing each number in the range
    between n1 and n2 (inclusive) *)
let rec range (n1:int) (n2:int) : int list =
  if n1 > n2 then [] else n1::range (n1+1) n2

(** The list of unique elements in xs. *)
let rec unique xs =
  match xs with
  | [] -> []
  | hd::tl ->
      let tl' = unique tl in
      if List.mem hd tl' then tl' else hd::tl'

(**************************)
(***** Number Helpers *****)
(**************************)

(** Bound x between low and high. *)
let bound (low:int) (high:int) (x:int) : int = min (max low x) high

(********************************)
(***** Random Value Helpers *****)
(********************************)

(** call f with probability (1/p) and g if f is not called *)
let with_inv_probability_or (r:int->int) (p:int)
                            (f:unit->'a) (g:unit->'a) : 'a =
  if r p = 0 then f () else g ()

(** Call f with probability (1/p) (using r to generate random numbers) *)
let with_inv_probability (r:int->int) (p:int) (f:unit->unit) : unit =
  with_inv_probability_or r p f (fun () -> ())

(** Call one of the functions in the list with equal probability. *)
let with_equal_probability (r:int->int) (fs:(unit -> unit) list) : unit =
  (List.nth fs (r (List.length fs))) ()
